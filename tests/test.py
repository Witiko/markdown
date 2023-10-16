#!/usr/bin/env python3

"""Run a test for each testfile passed as an argument."""

# Imported packages
from collections import defaultdict
from difflib import context_diff
from functools import cache, cached_property
from itertools import chain, repeat
import logging
from logging import getLogger
from math import ceil
from multiprocessing import Pool, cpu_count
from pathlib import Path
from typing import Dict, Iterable, Iterator, List, NamedTuple, Optional, Set, Tuple, TypeVar
from shutil import copyfile, rmtree
from subprocess import CompletedProcess, run
import sys
from tempfile import mkdtemp

import click
from more_itertools import chunked, zip_equal
from tqdm import tqdm
import yaml


# Global variables
LOGGER = getLogger(__name__)


# Configuration
LOG_LEVEL: int = logging.INFO

UPDATE_TESTS: bool = False
FAIL_FAST: bool = True

NUM_PROCESSES: int = cpu_count()
TESTFILE_BATCH_SIZE: int = 100

MAX_TESTFILE_NAMES_SHOWN: int = 5
MAX_TESTFILE_NAMES_SHOWN_COLLAPSED: int = 3

TEMPLATE_DIRECTORY: Path = Path('templates')
SUPPORT_DIRECTORY: Path = Path('support')

COMMANDS_FILENAME = 'COMMANDS.m4'
TEMPLATE_HEAD_FILENAME: str = 'head.tex'
TEMPLATE_BODY_FILENAME: str = 'body.tex.m4'
TEMPLATE_FOOT_FILENAME: str = 'foot.tex'
TEST_FILENAME: str = 'test.tex'
TEST_OUTPUT_FILENAME: str = 'test.log'
TEST_ACTUAL_OUTPUT_FILENAME: str = 'test-actual.log'

TEST_SETUP_FILENAME_FORMAT: str = 'test-setup-{:03d}.tex'
TEST_INPUT_FILENAME_FORMAT: str = 'test-input-{:03d}.md'
TEST_EXPECTED_OUTPUT_FILENAME_FORMAT: str = 'test-expected-{:03d}.log'
TEST_ACTUAL_OUTPUT_FILENAME_FORMAT: str = 'test-actual-{:03d}.log'


# Types
T = TypeVar('T')

TestFile = Path
TestFileBatch = List[TestFile]

TeXFormat = str
Template = Path
Command = Tuple[str, ...]

Metadata = str
SetupText = str
InputText = str
OutputText = str
OutputTextDiff = str
OutputTextHeadlessDiff = str


class ReadTestFile(NamedTuple):
    metadata: Metadata
    setup_text: SetupText
    input_text: InputText
    expected_output_text: OutputText


ReadTestFiles = List[ReadTestFile]


class TestParameters(NamedTuple):
    read_test_files: ReadTestFiles
    tex_format: TeXFormat
    template: Template
    command: Command


# TestSubResult type is defined in the implementation below.
# TestResult type is defined in the implementation below.
# BatchResult type is defined in the implementation below.


# Implementation
class TestSubResult:
    def __init__(self, batch_result: 'BatchResult', testfile_number: int):
        self.batch_result = batch_result
        self.testfile_number = testfile_number

    @property
    def testfile(self) -> TestFile:
        testfile = self.batch_result.testfile_batch[self.testfile_number]
        return testfile

    @property
    def test_parameters(self) -> TestParameters:
        test_parameters = self.batch_result.test_parameters
        return test_parameters

    @property
    def temporary_directory(self) -> Optional[Path]:
        temporary_directory = self.batch_result.temporary_directory
        return temporary_directory

    @property
    def exit_code(self) -> int:
        exit_code = self.batch_result.exit_code
        return exit_code

    @property
    def read_test_file(self) -> ReadTestFile:
        read_test_file_result = self.test_parameters.read_test_files[self.testfile_number]
        return read_test_file_result

    @property
    def expected_output_text(self) -> OutputText:
        expected_output_text = self.read_test_file.expected_output_text
        return expected_output_text

    @property
    def actual_output_text(self) -> OutputText:
        try:
            actual_output_text = self.batch_result.actual_output_texts[self.testfile_number]
            return actual_output_text
        except IndexError:
            return ''  # We have already deleted temporary directory, or no output was produced due to an error.

    @cached_property
    def output_diff(self) -> OutputTextDiff:
        expected_output_lines = self.expected_output_text.splitlines()
        actual_output_lines = self.actual_output_text.splitlines()

        expected_output_filename = TEST_EXPECTED_OUTPUT_FILENAME_FORMAT.format(self.testfile_number)
        actual_output_filename = TEST_ACTUAL_OUTPUT_FILENAME_FORMAT.format(self.testfile_number)

        expected_output_file = self.temporary_directory / expected_output_filename
        actual_output_file = self.temporary_directory / actual_output_filename

        output_diff_lines = context_diff(
            expected_output_lines, actual_output_lines, fromfile=str(expected_output_file), tofile=str(actual_output_file), lineterm='')
        output_diff_text = '\n'.join(output_diff_lines)
        return output_diff_text

    @property
    def output_headless_diff(self) -> OutputTextHeadlessDiff:
        output_headless_diff_lines = self.output_diff.splitlines()[2:]
        output_headless_diff_text = '\n'.join(output_headless_diff_lines)
        return output_headless_diff_text

    @property
    def exited_successfully(self) -> bool:
        return self.exit_code == 0

    @property
    def output_matches(self) -> bool:
        if self.temporary_directory is None:
            return True  # We have already deleted temporary directory, output must have been the same.
        return not self.output_diff

    def __bool__(self) -> bool:
        return self.exited_successfully and self.output_matches


class TestResult:
    updated_testfile: Optional[bool] = None  # None means we haven't tried, False means we tried and failed, True means we succeeded.

    def __init__(self, subresults: Iterable[TestSubResult]) -> None:
        self.subresults = list(subresults)
        assert len(self) >= 1

    @property
    def first_subresult(self) -> TestSubResult:
        first_subresult = next(iter(self))
        return first_subresult

    @property
    def testfile(self) -> TestFile:
        return self.first_subresult.testfile

    @property
    def metadata(self) -> Metadata:
        return self.first_subresult.read_test_file.metadata

    @property
    def setup_text(self) -> SetupText:
        return self.first_subresult.read_test_file.setup_text

    @property
    def input_text(self) -> InputText:
        return self.first_subresult.read_test_file.input_text

    @property
    def subresults_succeeded(self) -> bool:
        return all(self)

    @property
    def subresults_exited_successfully(self) -> bool:
        return all(subresult.exited_successfully for subresult in self)

    @property
    def subresult_outputs_match(self) -> bool:
        return all(subresult.output_matches for subresult in self)

    def try_to_update_testfile(self) -> None:
        assert self.updated_testfile is None  # Make sure that we don't run this method twice
        assert not self  # Make sure that an update is needed

        if not self.subresults_exited_successfully:
            self.updated_testfile = False
            LOGGER.debug(f'Cannot update testfile {self.testfile}, some commands produced non-zero exit codes.')
            return

        actual_output_texts = set()
        for subresult in self:
            actual_output_texts.add(subresult.actual_output_text)

        if len(actual_output_texts) > 1:
            self.updated_testfile = False
            LOGGER.debug(f'Cannot update testfile {self.testfile}, different commands produced different outputs.')
            return

        actual_output_text, = list(actual_output_texts)

        with self.testfile.open('wt') as f:
            if self.metadata:
                print(self.metadata, file=f, end='')
                print('---', file=f)
            print(self.setup_text, file=f, end='')
            print('<<<', file=f)
            print(self.input_text, file=f, end='')
            print('>>>', file=f)
            print(actual_output_text, file=f)

        self.updated_testfile = True

    @staticmethod
    def summarize_results(results: Iterable['TestResult']) -> str:
        result_lines: List[str] = []
        result_lines.append('')
        summaries: Dict[str, List['TestResult']] = defaultdict(lambda: list())
        results = list(results)
        for result in results:
            if not result:  # Exclude successful tests from the summary.
                summaries[str(result)].append(result)
        for summary, merged_results in sorted(summaries.items(), key=lambda x: x[0]):
            plural = 's' if len(merged_results) > 1 else ''
            testfile_names = format_testfiles(result.testfile for result in merged_results)
            result_lines.append(f'Testfile{plural} {testfile_names}:')
            result_lines.append('')
            for line in summary.splitlines():
                result_lines.append(f'  {line}')
            result_lines.append('')

        num_successful = sum(1 if result else 0 for result in results)
        num_failed = len(results) - num_successful
        num_updated = sum(1 if result.updated_testfile is True else 0 for result in results)
        num_not_updated = sum(1 if result.updated_testfile is False else 0 for result in results)
        result_lines.append('In summary:')
        result_lines.append(f'- {num_successful} testfile{"" if num_successful == 1 else "s"} succeeded.')
        result_lines.append(f'- {num_failed} testfile{"" if num_failed == 1 else "s"} failed.')
        if num_updated or num_not_updated:
            result_lines.append(f'- {num_updated} testfile{"" if num_updated == 1 else "s"} were successfully updated.')
            if num_not_updated:
                result_lines.append(f'- {num_not_updated} testfile{"s" if num_not_updated > 1 else ""} not were successfully updated.')
        result_lines.append('')
        return '\n'.join(result_lines)

    def summarize(self) -> str:
        result_lines: List[str] = []
        result_lines.append('')
        for line_number, line in enumerate(str(self).splitlines()):
            if line_number == 0:
                result_lines.append(f'Testfile {format_testfile(self.testfile)}:')
                result_lines.append('')
            result_lines.append(f'  {line}')
        result_lines.append('')
        return '\n'.join(result_lines)

    def __str__(self) -> str:
        result_lines: List[str] = []
        if self:
            result_lines.append('Success')
        else:
            if not self.subresults_exited_successfully:
                result_lines.append('Some commands produced non-zero exit codes:')
                exit_codes: Dict[int, List[TestSubResult]] = defaultdict(lambda: list())
                commands: Dict[Command, Set[int]] = defaultdict(lambda: set())
                for subresult in self:
                    exit_codes[subresult.exit_code].append(subresult)
                    commands[subresult.test_parameters.command].add(subresult.exit_code)
                for exit_code, subresults in sorted(exit_codes.items(), key=lambda x: x[0]):
                    commands_with_templates = sorted(set(
                        (
                            command := subresult.test_parameters.command,
                            None if len(commands[command]) == 1 else subresult.test_parameters.template
                        )
                        for subresult
                        in subresults
                    ))
                    command_texts = format_commands_with_templates(commands_with_templates)
                    plural = 's' if len(subresults) > 1 else ''
                    first_subresult, *_ = subresults
                    if first_subresult.exited_successfully:
                        result_lines.append(f'- Command{plural} {command_texts} exited successfully.')
                    else:
                        result_lines.append(f'- Command{plural} {command_texts} produced exit code {exit_code}.')
                result_lines.append('')
            if not self.subresult_outputs_match:
                result_lines.append('Some commands produced unexpected outputs:')
                headless_diffs: Dict[OutputTextHeadlessDiff, List[TestSubResult]] = defaultdict(lambda: list())
                commands: Dict[Command, Set[OutputTextHeadlessDiff]] = defaultdict(lambda: set())
                for subresult in self:
                    headless_diffs[subresult.output_headless_diff].append(subresult)
                    commands[subresult.test_parameters.command].add(subresult.output_headless_diff)
                for _, subresults in sorted(headless_diffs.items(), key=lambda x: x[0]):
                    commands_with_templates = sorted(set(
                        (
                            command := subresult.test_parameters.command,
                            None if len(commands[command]) == 1 else subresult.test_parameters.template
                        )
                        for subresult
                        in subresults
                    ))
                    command_texts = format_commands_with_templates(commands_with_templates)
                    plural = 's' if len(subresults) > 1 else ''
                    first_subresult, *_ = subresults
                    if first_subresult.output_matches:
                        result_lines.append(f'- Command{plural} {command_texts} produced expected output.')
                    else:
                        result_lines.append(f'- Command{plural} {command_texts} produced unexpected output with the following diff:')
                        result_lines.append('')
                        for line in first_subresult.output_diff.splitlines():
                            result_lines.append(f'  {line}')
                        result_lines.append('')
                if result_lines[-1]:  # Make sure that we don't produce double blank lines in the output.
                    result_lines.append('')
        if self.updated_testfile is not None:
            if self.updated_testfile:
                result_lines.append('We successfully updated the testfile.')
            else:
                result_lines.append('We tried to update the testfile and failed.')
        if not result_lines[-1]:  # Make sure that we don't produce a blank line at the end of the output.
            result_lines.pop()
        return '\n'.join(result_lines)

    def __len__(self) -> int:
        return len(self.subresults)

    def __iter__(self) -> Iterator[TestSubResult]:
        return iter(self.subresults)

    def __bool__(self) -> bool:
        return self.subresults_succeeded


class BatchResult:
    def __init__(self, testfile_batch: TestFileBatch, test_parameters: TestParameters, temporary_directory: Path,
                 test_process: CompletedProcess, fail_fast: bool) -> None:
        self.testfile_batch = testfile_batch
        assert len(self) >= 1
        self.test_parameters = test_parameters
        self.temporary_directory = temporary_directory
        self.exit_code = test_process.returncode
        self.fail_fast = fail_fast

        # If test succeeded, remove temporary directory.
        if self:
            rmtree(self.temporary_directory)
            self.temporary_directory = None

    @cached_property
    def subresults(self) -> Tuple[TestSubResult, ...]:
        subresult_list: List[TestSubResult] = []

        if len(self.actual_output_texts) == len(self):  # If all testfiles produced output, return subresults.
            for testfile_number, testfile in enumerate(self.testfile_batch):
                subresult = TestSubResult(self, testfile_number)
                subresult_list.append(subresult)
        elif len(self) > 1:  # If some testfiles did not produce output and the batch is larger than one, bisect the batch.
            read_testfile_results, *remaining_parameters = self.test_parameters
            pivot = len(self) // 2
            first_testfile_subbatch = self.testfile_batch[:pivot]
            second_testfile_subbatch = self.testfile_batch[pivot:]
            LOGGER.warning(f'Bisecting batch {format_testfiles(self.testfile_batch)} due to an error:')
            LOGGER.warning(f'- First subbatch: {format_testfiles(first_testfile_subbatch)}')
            first_read_testfile_results = read_testfile_results[:pivot]
            second_read_testfile_results = read_testfile_results[pivot:]
            first_test_parameters = TestParameters(first_read_testfile_results, *remaining_parameters)
            second_test_parameters = TestParameters(second_read_testfile_results, *remaining_parameters)
            first_subresults = self.__class__.run_test_batch_with_parameters(
                first_testfile_subbatch, first_test_parameters, self.fail_fast)
            if self.fail_fast and not all(first_subresults):
                second_subresults = [TestSubResult(self, testfile_number) for testfile_number in range(pivot, len(self))]
            else:
                LOGGER.warning(f'- Second subbatch: {format_testfiles(second_testfile_subbatch)}')
                second_subresults = self.__class__.run_test_batch_with_parameters(
                    second_testfile_subbatch, second_test_parameters, self.fail_fast)
            subresult_list = list(chain(first_subresults, second_subresults))
        else:  # If some testfiles did not produce output and the batch contains a single testfile, return the result.
            testfile_number = 0
            subresult = TestSubResult(self, testfile_number)
            subresult_list.append(subresult)

        subresults = tuple(subresult_list)
        return subresults

    @cached_property
    def actual_output_texts(self) -> Tuple[OutputText, ...]:
        try:
            actual_output_file = self.temporary_directory / TEST_ACTUAL_OUTPUT_FILENAME
            with actual_output_file.open('rt') as f:
                actual_output_text = f.read()
            actual_output_texts = split_batch_output_text(actual_output_text)
            actual_output_texts = tuple(actual_output_texts)
            for actual_output_text_number, actual_output_text in enumerate(actual_output_texts):
                actual_output_filename = TEST_ACTUAL_OUTPUT_FILENAME_FORMAT.format(actual_output_text_number)
                actual_output_file = self.temporary_directory / actual_output_filename
                with actual_output_file.open('wt') as f:
                    for line in actual_output_text.splitlines():
                        print(line, file=f)
            assert len(actual_output_texts) <= len(self)
            return actual_output_texts
        except IOError:
            return tuple()  # We have already deleted temporary directory, or no output was produced due to an error.

    def __len__(self) -> int:
        return len(self.testfile_batch)

    def __iter__(self) -> Iterator[TestSubResult]:
        return iter(self.subresults)

    def __bool__(self) -> bool:
        return all(self)

    @classmethod
    def run_test_batch_with_parameters(cls, testfile_batch: TestFileBatch, test_parameters: TestParameters,
                                       fail_fast: bool) -> 'BatchResult':
        assert len(testfile_batch) >= 1
        read_testfile_results, tex_format, template, command = test_parameters

        # Create a temporary directory.
        temporary_directory = Path(mkdtemp())

        # Copy support files.
        for support_file in SUPPORT_DIRECTORY.glob('*'):
            copyfile(support_file, temporary_directory / support_file.name)

        # Create test file.
        test_texts: List[str] = []

        # Create test file fragment with header.
        with (template / TEMPLATE_HEAD_FILENAME).open('rt') as f:
            head_text = f.read()
        test_texts.append(head_text)

        for testfile_number, (testfile, read_testfile_result) in enumerate(zip_equal(testfile_batch, read_testfile_results)):
            _, setup_text, input_text, expected_output_text = read_testfile_result

            test_setup_filename = TEST_SETUP_FILENAME_FORMAT.format(testfile_number)
            test_input_filename = TEST_INPUT_FILENAME_FORMAT.format(testfile_number)
            test_expected_output_filename = TEST_EXPECTED_OUTPUT_FILENAME_FORMAT.format(testfile_number)

            # Create testfile-specific support files.
            with (temporary_directory / test_setup_filename).open('wt') as f:
                print(setup_text, file=f, end='')

            with (temporary_directory / test_input_filename).open('wt') as f:
                print(input_text, file=f, end='')

            with (temporary_directory / test_expected_output_filename).open('wt') as f:
                print(expected_output_text, file=f, end='')

            # Create testfile-specific test file fragments.
            body_text = run_m4(
                template / TEMPLATE_BODY_FILENAME,
                cwd=temporary_directory,
                TEST_SETUP_FILENAME=test_setup_filename,
                TEST_INPUT_FILENAME=test_input_filename)
            test_texts.append(body_text)

        # Create test file fragment with footer.
        with (template / TEMPLATE_FOOT_FILENAME).open('rt') as f:
            foot_text = f.read()
        test_texts.append(foot_text)

        test_text = '\n'.join(test_text.strip('\r\n') for test_text in test_texts)
        with (temporary_directory / TEST_FILENAME).open('wt') as f:
            print(test_text, file=f)

        # Run test.
        test_process = run(command, cwd=temporary_directory, capture_output=True)

        # Extract test output.
        try:
            actual_output_file = temporary_directory / TEST_OUTPUT_FILENAME
            actual_output_text = read_test_output_from_tex_log_file(actual_output_file)
            with (temporary_directory / TEST_ACTUAL_OUTPUT_FILENAME).open('wt') as f:
                print(actual_output_text, file=f)
        except IOError as e:
            LOGGER.debug(f'Failed to extract test output from log file: {e}.')

        # Store test batch result.
        batch_result = BatchResult(testfile_batch, test_parameters, temporary_directory, test_process, fail_fast)
        return batch_result

    @classmethod
    def run_test_batch(cls, args: Tuple[TestFileBatch, bool]) -> List[Optional[TestResult]]:
        testfile_batch, fail_fast = args

        # Run the test for all different test parameters.
        all_subresults: Dict[TestFile, List[TestSubResult]] = defaultdict(lambda: list())
        for test_parameters, filtered_testfile_batch in get_test_parameters(testfile_batch):
            assert len(filtered_testfile_batch) >= 1
            batch_result = cls.run_test_batch_with_parameters(filtered_testfile_batch, test_parameters, fail_fast)
            for subresult in batch_result.subresults:
                all_subresults[subresult.testfile].append(subresult)
            if fail_fast and not batch_result:  # If we want to fail fast, stop after the first failed command.
                break

        # For each testfile in the batch, create a test result
        test_results = list()
        for testfile in testfile_batch:
            if testfile not in all_subresults:
                LOGGER.warning('Skipping testfile {format_testfile(testfile)}, because it supports no test parameters.')
                test_results.append(None)
            else:
                test_result = TestResult(all_subresults[testfile])
                test_results.append(test_result)
        return test_results


@cache
def get_tex_formats() -> Tuple[TeXFormat, ...]:
    tex_formats: List[TeXFormat] = []
    for tex_format_path in TEMPLATE_DIRECTORY.glob('*/'):
        tex_formats.append(tex_format_path.name)
    return tuple(sorted(tex_formats))


@cache
def get_templates(tex_format: str) -> Tuple[Template, ...]:
    templates: Iterable[Template] = (TEMPLATE_DIRECTORY / tex_format).glob('*/')
    return tuple(sorted(templates))


def run_m4(input_file: Path, cwd: Optional[Path] = None, **variables) -> str:
    with input_file.open('rt') as f:
        input_text = f.read()
    m4_parameters = [f'-D{key}={value}' for key, value in variables.items()]
    m4_process = run(['m4', *m4_parameters], text=True, input=input_text, check=True, capture_output=True, cwd=cwd)
    output_text = m4_process.stdout
    return output_text


@cache
def get_commands(tex_format: str) -> Tuple[Command, ...]:
    commands: List[Command] = []
    commands_file = TEMPLATE_DIRECTORY / tex_format / COMMANDS_FILENAME
    commands_text = run_m4(commands_file, TEST_FILENAME=TEST_FILENAME)
    for command_str in commands_text.splitlines():
        command_str = command_str.strip()
        if command_str:
            command = tuple(command_str.split())
            commands.append(command)
    return tuple(commands)


def read_testfile(testfile: TestFile) -> ReadTestFile:
    input_lines: Dict[str, List] = defaultdict(lambda: list())
    input_part = 'setup'
    with testfile.open('rt') as f:
        for line in f:
            if input_part == 'setup' and line.strip() == '<<<':
                input_part = 'input'
            elif input_part == 'input' and line.strip() == '>>>':
                input_part = 'expected_output'
            else:
                input_lines[input_part].append(line)

    # Read optional YAML metadata.
    stripped_setup_input_lines = [input_line.strip() for input_line in input_lines['setup']]
    if '---' in stripped_setup_input_lines:
        yaml_delimiter_index = stripped_setup_input_lines.index('---')
        yaml_text = ''.join(input_lines['setup'][:yaml_delimiter_index])
        setup_text = ''.join(input_lines['setup'][yaml_delimiter_index + 1:])
    else:
        yaml_text = ''
        setup_text = ''.join(input_lines['setup'])

    # Read mandatory parts of the testfile.
    input_text = ''.join(input_lines['input'])
    expected_output_text = ''.join(input_lines['expected_output'])
    if expected_output_text and not expected_output_text.endswith('\n'):
        expected_output_text = f'{expected_output_text}\n'

    return ReadTestFile(yaml_text, setup_text, input_text, expected_output_text)


def read_test_output_from_tex_log_file(tex_log_file: Path) -> OutputText:
    input_lines: List[str] = []
    input_line_fragments: List[str] = []
    in_test_output = False
    with tex_log_file.open('rt', errors='ignore') as f:
        for line in f:
            line = line.rstrip('\r\n')
            if not in_test_output and line.strip() == 'TEST INPUT BEGIN':
                in_test_output = True
            elif in_test_output and line.strip() == 'TEST INPUT END':
                input_line = ''.join(input_line_fragments)
                input_line = f'{input_line}\n'
                input_lines.append(input_line)
                input_line_fragments.clear()
                in_test_output = False
            elif in_test_output:
                input_line_fragments.append(line)

    output_text = ''.join(input_lines)
    return output_text


def split_batch_output_text(output_text: OutputText) -> Iterable[OutputText]:
    input_lines: List[str] = []
    in_test_output = False
    for line in output_text.splitlines():
        if not in_test_output and line.strip() == 'documentBegin':
            in_test_output = True
            input_lines.append(line)
        elif in_test_output and line.strip() == 'documentEnd':
            input_lines.append(line)
            output_text = '\n'.join(input_lines)
            input_lines.clear()
            yield output_text
            in_test_output = False
        elif in_test_output:
            input_lines.append(line)


def format_commands_with_templates(commands_with_templates: Iterable[Tuple[Command, Optional[Template]]]) -> str:
    commands, templates = zip(*commands_with_templates)
    command_texts = [' '.join(command) for command in commands]
    template_texts = [f' (template {template.name})' if template is not None else '' for template in templates]
    command_with_template_texts = [
        f'{command_text}{template_text}'
        for command_text, template_text
        in zip_equal(command_texts, template_texts)
    ]
    commands_with_templates_text = ', '.join(command_with_template_texts)
    return commands_with_templates_text


def format_commands(commands: Iterable[Command]) -> str:
    command_texts = [' '.join(command) for command in commands]
    commands_text = ', '.join(command_texts)
    return commands_text


def format_command(command: Command) -> str:
    return format_commands([command])


def format_testfiles(testfiles: Iterable[TestFile]) -> str:
    testfile_texts = list(map(str, testfiles))
    if len(testfile_texts) > MAX_TESTFILE_NAMES_SHOWN:
        num_hidden = len(testfile_texts) - MAX_TESTFILE_NAMES_SHOWN_COLLAPSED
        testfile_texts = testfile_texts[:MAX_TESTFILE_NAMES_SHOWN_COLLAPSED]
        testfile_texts.append(f'and {num_hidden} others')
    testfiles_text = ', '.join(testfile_texts)
    return testfiles_text


def format_testfile(testfile: TestFile) -> str:
    return format_testfiles([testfile])


def should_process_testfile(read_testfile_result: ReadTestFile, test_parameters: TestParameters) -> bool:
    metadata = yaml.safe_load(read_testfile_result.metadata)
    if not isinstance(metadata, dict) or 'if' not in metadata:
        return True  # The testfile has no restrictions on the parameters.
    variables = {'format': test_parameters.tex_format, 'template': test_parameters.template.name}
    should_process_testfile = eval(metadata['if'], variables)
    return should_process_testfile


def get_test_parameters(testfile_batch: TestFileBatch) -> Iterable[Tuple[TestParameters, TestFileBatch]]:
    plural = 's' if len(testfile_batch) > 1 else ''
    LOGGER.debug(f'Testfile{plural} {format_testfiles(testfile_batch)}')

    # Read testfiles in the batch.
    read_testfile_results = [read_testfile(testfile) for testfile in testfile_batch]

    # List TeX formats, templates, and commands.
    for tex_format in get_tex_formats():
        LOGGER.debug(f'  Format {tex_format}')
        for template in get_templates(tex_format):
            LOGGER.debug(f'    Template {template.name}')
            for command in get_commands(tex_format):
                LOGGER.debug(f'      Command {format_command(command)}')
                # Filter out testfiles that do not support the current parameters.
                test_parameters = TestParameters(read_testfile_results, tex_format, template, command)
                filtered_testfile_batch, filtered_read_testfile_results = list(), list()
                for testfile, read_testfile_result in zip_equal(testfile_batch, read_testfile_results):
                    if should_process_testfile(read_testfile_result, test_parameters):
                        filtered_testfile_batch.append(testfile)
                        filtered_read_testfile_results.append(read_testfile_result)
                if len(filtered_testfile_batch) == 0:
                    LOGGER.debug('        Skipping, because no testfiles in the batch support these parameters.')
                else:
                    filtered_test_parameters = TestParameters(filtered_read_testfile_results, tex_format, template, command)
                    yield filtered_test_parameters, filtered_testfile_batch


def run_tests(testfiles: Iterable[TestFile], fail_fast: bool) -> Iterable[Optional[TestResult]]:
    testfiles: List[TestFile] = list(testfiles)

    def get_all_results() -> Iterable[Iterable[TestResult]]:
        testfile_batch_size = TESTFILE_BATCH_SIZE
        if NUM_PROCESSES > 1:
            # Populate caches by running the first testfile sequentially.
            first_testfile, *remaining_testfiles = testfiles
            first_testfile_batch: List[TestFileBatch] = [[first_testfile]]
            first_batch = zip(first_testfile_batch, repeat(fail_fast))
            sequential_results = map(BatchResult.run_test_batch, first_batch)

            # Run the remaining batches in parallel.
            if remaining_testfiles:
                num_batches = int(ceil(len(remaining_testfiles) / testfile_batch_size))
                if num_batches < NUM_PROCESSES:
                    updated_testfile_batch_size = int(ceil(len(remaining_testfiles) / NUM_PROCESSES))
                    updated_num_batches = int(ceil(len(remaining_testfiles) / updated_testfile_batch_size))
                    assert updated_num_batches <= NUM_PROCESSES
                    assert updated_testfile_batch_size <= testfile_batch_size
                    if updated_testfile_batch_size < testfile_batch_size:
                        LOGGER.debug(f'Reducing batch size to {updated_testfile_batch_size} to fully utilize {NUM_PROCESSES} hyperthreads.')
                    testfile_batch_size, num_batches = updated_testfile_batch_size, updated_num_batches
                remaining_testfile_batches: List[TestFileBatch] = list(chunked(remaining_testfiles, testfile_batch_size))
                remaining_batches = zip(remaining_testfile_batches, repeat(fail_fast))
                assert len(remaining_testfile_batches) == num_batches
                LOGGER.debug(f'The testfiles break down into {num_batches} batches.')
                sequential_results = list(sequential_results)  # Materialize the results for the first testfile before we parallelize.
                with Pool(NUM_PROCESSES) as pool:
                    parallel_results = pool.imap(BatchResult.run_test_batch, remaining_batches, chunksize=1)
                    all_results = chain(sequential_results, parallel_results)
                    yield from all_results
            else:
                yield from sequential_results
        # If there is just a single hyperthread, run all batches sequentially.
        else:
            testfile_batches: Iterable[TestFileBatch] = chunked(testfiles, testfile_batch_size)
            all_batches = zip(testfile_batches, repeat(fail_fast))
            all_results = map(BatchResult.run_test_batch, all_batches)
            yield from all_results

    all_results = get_all_results()
    return (result for results in all_results for result in results)


# Command-line interface
@click.command()
@click.argument('testfiles',
                nargs=-1,
                type=click.Path(exists=True, dir_okay=False, file_okay=True),
                required=True)
@click.option('--update-tests/--no-update-tests',
              help='Update testfiles with unexpected results',
              is_flag=True,
              default=None)
@click.option('--fail-fast/--no-fail-fast',
              help='When a test fails, stop immediately',
              is_flag=True,
              default=None)
def main(testfiles: Iterable[str], update_tests: Optional[bool], fail_fast: Optional[bool]) -> None:

    # Process options.
    if update_tests is None:
        update_tests = UPDATE_TESTS
    if fail_fast is None:
        fail_fast = False if update_tests else FAIL_FAST
    if update_tests and fail_fast:
        raise ValueError('Options --fail-fast and --update-tests are mutually exclusive')

    # Print information about the run.
    testfiles: List[TestFile] = sorted(map(Path, testfiles))
    plural = 's' if len(testfiles) > 1 else ''
    LOGGER.info(f'Running tests for {len(testfiles)} testfile{plural}.')

    if update_tests:
        LOGGER.info('Updating testfiles at any error.')

    if fail_fast:
        LOGGER.info('Will fail at first error.')
    else:
        LOGGER.info('Will run all tests despite errors.')

    # Run tests.
    some_tests_failed = False
    results: List[TestResult] = []
    result_iter = run_tests(testfiles, fail_fast)
    show_progress_bar = LOG_LEVEL >= logging.INFO
    progress_bar = tqdm(result_iter, total=len(testfiles), disable=not show_progress_bar)
    for result in progress_bar:
        if result is None:
            # A testfile was skipped.
            continue
        if not result:
            # A test failed.
            some_tests_failed = True
            if update_tests:
                result.try_to_update_testfile()
            if fail_fast:
                progress_bar.close()
                print(result.summarize(), file=sys.stderr)
                sys.exit(1)
        results.append(result)

    # Summarize results.
    if some_tests_failed:
        LOGGER.error('Some tests failed, see the summary below:')
        print(TestResult.summarize_results(results), file=sys.stderr)
        sys.exit(1)
    else:
        LOGGER.info('All tests succeeded!')


if __name__ == '__main__':
    logging.basicConfig(level=LOG_LEVEL, format='%(asctime)s %(message)s')
    main()
