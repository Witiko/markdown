#!/usr/bin/env python3

"""Run a test for each testfile passed as an argument."""

# Imported packages
from collections import defaultdict
from difflib import context_diff
from functools import cache, cached_property
from itertools import chain
import logging
from logging import getLogger
from multiprocessing import Pool
from pathlib import Path
from typing import Dict, Iterable, List, NamedTuple, Optional, Tuple
from shutil import copyfile, rmtree
from subprocess import CompletedProcess, run
import sys
from tempfile import mkdtemp

import click
from tqdm import tqdm


# Global variables
LOGGER = getLogger(__name__)


# Configuration
LOG_LEVEL: int = logging.INFO

UPDATE_TESTS: bool = False
FAIL_FAST: bool = False
NUM_PROCESSES: Optional[int] = None  # None means that all available hyperthreads will be used.

MAX_TESTFILE_NAMES_SHOWN: int = 5
MAX_TESTFILE_NAMES_SHOWN_COLLAPSED: int = 3

TEMPLATE_DIRECTORY: Path = Path('templates')
SUPPORT_DIRECTORY: Path = Path('support')

COMMANDS_FILENAME = 'COMMANDS.m4'
TEST_FILENAME: str = 'test.tex'
TEST_OUTPUT_FILENAME: str = 'test.log'
TEST_SETUP_FILENAME: str = 'test-setup.tex'
TEST_INPUT_FILENAME: str = 'test-input.md'
TEST_EXPECTED_OUTPUT_FILENAME: str = 'test-expected.log'


# Types
TeXFormat = str
Template = Path
Command = Tuple[str]
SetupText = str
InputText = str
OutputText = str
OutputTextDiff = str


class TestParameters(NamedTuple):
    setup_text: SetupText
    input_text: InputText
    expected_output_text: OutputText
    tex_format: TeXFormat
    template: Template
    command: Command


# TestSubResult type is defined in the implementation below.
# TestResult type is defined in the implementation below.


# Implementation
class TestSubResult:
    def __init__(self, testfile: Path, test_parameters: TestParameters, temporary_directory: Path, test_process: CompletedProcess) -> None:
        self.testfile = testfile
        self.test_parameters = test_parameters
        self.temporary_directory = temporary_directory
        self.test_process = test_process

        # If test succeeded, remove temporary directory.
        if self:
            rmtree(self.temporary_directory)
            self.temporary_directory = None

    @property
    def expected_output_text(self) -> OutputText:
        expected_output_text = self.test_parameters.expected_output_text
        return expected_output_text

    @cached_property
    def actual_output_text(self) -> OutputText:
        try:
            actual_output_file = self.temporary_directory / TEST_OUTPUT_FILENAME
            actual_output_text = read_test_output_from_tex_log_file(actual_output_file)
            return actual_output_text
        except IOError:
            return ''  # We have already deleted temporary directory, or no output was produced due to an error.

    @cached_property
    def output_diff(self) -> OutputTextDiff:
        expected_output_lines = self.expected_output_text.splitlines(True)
        actual_output_lines = self.actual_output_text.splitlines(True)
        expected_output_file = self.temporary_directory / TEST_EXPECTED_OUTPUT_FILENAME
        actual_output_file = self.temporary_directory / TEST_OUTPUT_FILENAME
        output_diff_lines = context_diff(
            expected_output_lines, actual_output_lines, fromfile=str(expected_output_file), tofile=str(actual_output_file))
        output_diff_text = ''.join(output_diff_lines)
        return output_diff_text

    @property
    def exited_successfully(self) -> bool:
        return self.test_process.returncode == 0

    @property
    def output_matches(self) -> bool:
        if self.temporary_directory is None:
            return True  # We have already deleted temporary directory, output must have been the same.
        return self.expected_output_text == self.actual_output_text

    def __bool__(self) -> bool:
        return self.exited_successfully and self.output_matches


class TestResult:
    updated_testfile: Optional[bool] = None  # None means we haven't tried, False means we tried and failed, True means we succeeded.

    def __init__(self, subresults: Iterable[TestSubResult]) -> None:
        self.subresults = list(subresults)
        assert self.subresults  # Ensure that at least one subresult exists.

    @property
    def first_subresult(self) -> TestSubResult:
        first_subresult, *_ = self.subresults
        return first_subresult

    @property
    def testfile(self) -> Path:
        return self.first_subresult.testfile

    @property
    def setup_text(self) -> SetupText:
        return self.first_subresult.test_parameters.setup_text

    @property
    def input_text(self) -> SetupText:
        return self.first_subresult.test_parameters.input_text

    @property
    def subresults_succeeded(self) -> bool:
        return all(self.subresults)

    @property
    def subresults_exited_successfully(self) -> bool:
        return all(subresult.exited_successfully for subresult in self.subresults)

    @property
    def subresult_outputs_match(self) -> bool:
        return all(subresult.output_matches for subresult in self.subresults)

    def try_to_update_testfile(self) -> None:
        assert self.updated_testfile is None  # Make sure that we don't run this method twice
        assert not self.subresults_succeeded  # Make sure that an update is needed

        if not self.subresults_exited_successfully:
            self.updated_testfile = False
            LOGGER.warning(f'Cannot update testfile {self.testfile}, some commands produced non-zero exit codes')
            return

        actual_output_texts = set()
        for subresult in self.subresults:
            self.updated_testfile = False
            actual_output_texts.add(subresult.actual_output_text)

        if len(actual_output_texts) > 1:
            LOGGER.warning(f'Cannot update testfile {self.testfile}, different commands produced different outputs')
            return

        actual_output_text, = list(actual_output_texts)

        with self.testfile.open('wt') as f:
            print(self.setup_text, file=f)
            print('<<<', file=f)
            print(self.input_text, file=f)
            print('>>>', file=f)
            print(actual_output_text, file=f)

        self.updated_testfile = True

    @staticmethod
    def summarize_results(results: Iterable['TestResult']) -> str:
        result_lines: List[str] = []
        result_lines.append('')
        summaries: Dict[str, List['TestResult']] = defaultdict(lambda: list())
        for result in results:
            summaries[str(result)].append(result)
        for summary, results in sorted(summaries.items(), key=lambda x: x[0]):
            plural = 's' if len(results) > 1 else ''
            testfile_names = format_testfiles(result.testfile for result in results)
            result_lines.append(f'Testfile{plural} {testfile_names}:')
            result_lines.append('')
            for line in summary.splitlines():
                result_lines.append(f'  {line}')
            result_lines.append('')
        return '\n'.join(result_lines)

    def summarize(self) -> str:
        result_lines: List[str] = []
        result_lines.append('')
        for line_number, line in enumerate(str(self).splitlines()):
            if line_number == 0:
                result_lines.append(f'Testfile {format_testfile(self.testfile)}:')
                result_lines.append('')
            else:
                result_lines.append(f'  {line}')
        result_lines.append('')
        return '\n'.join(result_lines)

    def __str__(self) -> str:
        result_lines: List[str] = []
        if self.subresults_succeeded:
            result_lines.append('Success')
        else:
            if not self.subresults_exited_successfully:
                result_lines.append('Some commands produced non-zero exit codes:')
                exit_codes: Dict[int, List[TestSubResult]] = defaultdict(lambda: list())
                for subresult in self.subresults:
                    exit_codes[subresult.test_process.returncode].append(subresult)
                for exit_code, subresults in sorted(exit_codes.items(), key=lambda x: x[0]):
                    command_texts = format_commands(subresult.test_parameters.command for subresult in subresults)
                    plural = 's' if len(subresults) > 1 else ''
                    first_subresult, *_ = subresults
                    if first_subresult.exited_successfully:
                        result_lines.append(f'- Command{plural} {command_texts} exited successfully.')
                    else:
                        result_lines.append(f'- Command{plural} {command_texts} produced exit code {exit_code}.')
                result_lines.append('')
            if not self.subresult_outputs_match:
                result_lines.append('Some commands produced unexpected outputs:')
                diffs: Dict[OutputTextDiff, List[TestSubResult]] = defaultdict(lambda: list())
                for subresult in self.subresults:
                    diffs[subresult.output_diff].append(subresult)
                for diff, subresults in sorted(diffs.items(), key=lambda x: x[0]):
                    command_texts = format_commands(subresult.test_parameters.command for subresult in subresults)
                    plural = 's' if len(subresults) > 1 else ''
                    first_subresult, *_ = subresults
                    if first_subresult.output_matches:
                        result_lines.append(f'- Command{plural} {command_texts} produced expected output.')
                    else:
                        result_lines.append(f'- Command{plural} {command_texts} produced unexpected output with the following diff:')
                        result_lines.append('')
                        for line in diff.splitlines():
                            result_lines.append(f'  {line}')
                        result_lines.append('')
                if result_lines[-1]:  # Make sure that we don't produce double blank lines in the output.
                    result_lines.append('')
                if self.updated_testfile is not None:
                    if self.updated_testfile:
                        result_lines.append('We successfully updated the testfile.')
                    else:
                        result_lines.append('We tried to update the testfile and failed.')
        if result_lines[-1]:  # Make sure that we don't produce a blank line at the end of the output.
            result_lines.pop()
        return '\n'.join(result_lines)

    def __bool__(self) -> bool:
        return self.updated_testfile or self.subresults_succeeded


@cache
def get_tex_formats() -> Tuple[TeXFormat]:
    tex_formats: List[TeXFormat] = []
    for tex_format_path in TEMPLATE_DIRECTORY.glob('*/'):
        tex_formats.append(tex_format_path.name)
    return tuple(sorted(tex_formats))


@cache
def get_templates(tex_format: str) -> Tuple[Template]:
    templates: Iterable[Template] = (TEMPLATE_DIRECTORY / tex_format).glob('*.tex.m4')
    return tuple(sorted(templates))


def run_m4(input_file: Path, **variables) -> str:
    with input_file.open('rt') as f:
        input_text = f.read()
    m4_parameters = [f'-D{key}={value}' for key, value in variables.items()]
    m4_process = run(['m4', *m4_parameters], text=True, input=input_text, check=True, capture_output=True)
    output_text = m4_process.stdout
    return output_text


@cache
def get_commands(tex_format: str) -> Tuple[Command]:
    commands: List[Command] = []
    commands_file = TEMPLATE_DIRECTORY / tex_format / COMMANDS_FILENAME
    commands_text = run_m4(commands_file, TEST_FILENAME=TEST_FILENAME)
    for command_str in commands_text.splitlines():
        command_str = command_str.strip()
        if command_str:
            command = tuple(command_str.split())
            commands.append(command)
    return tuple(commands)


def read_testfile(testfile: Path) -> Tuple[SetupText, InputText, OutputText]:
    input_lines: Dict[str, List] = defaultdict(lambda: list())
    input_part = 'setup'
    with testfile.open('rt') as f:
        for line in f:
            line = line.rstrip('\r\n')
            if input_part == 'setup' and line.strip() == '<<<':
                input_part = 'input'
            elif input_part == 'input' and line.strip() == '>>>':
                input_part = 'expected_output'
            else:
                input_lines[input_part].append(line)

    setup_text = '\n'.join(input_lines['setup'])
    input_text = '\n'.join(input_lines['input'])
    expected_output_text = '\n'.join(input_lines['expected_output'])
    return setup_text, input_text, expected_output_text


def read_test_output_from_tex_log_file(tex_log_file: Path) -> OutputText:
    input_lines: List[str] = []
    in_test_output = False
    with tex_log_file.open('rt') as f:
        for line in f:
            line = line.rstrip('\r\n')
            if not in_test_output and line.strip() == 'TEST INPUT BEGIN':
                in_test_output = True
            elif in_test_output and line.strip() == 'TEST INPUT END':
                in_test_output = False
            elif in_test_output:
                input_lines.append(line)

    output_text = '\n'.join(input_lines)
    return output_text


def format_commands(commands: Iterable[Command]) -> str:
    command_texts = [' '.join(command) for command in commands]
    if len(command_texts) > 1:
        command_texts = [f'"{command_text}"' for command_text in command_texts]
    command_texts = ', '.join(command_texts)
    return command_texts


def format_command(command: Command) -> str:
    return format_commands([command])


def format_testfiles(testfiles: Iterable[Path]) -> str:
    testfile_texts = list(map(str, testfiles))
    if len(testfile_texts) > 1:
        testfile_texts = [f'"{testfile_text}"' for testfile_text in testfile_texts]
    if len(testfile_texts) > MAX_TESTFILE_NAMES_SHOWN:
        num_hidden = len(testfile_texts) - MAX_TESTFILE_NAMES_SHOWN_COLLAPSED
        testfile_texts = testfile_texts[:MAX_TESTFILE_NAMES_SHOWN_COLLAPSED]
        testfile_texts.append(f'and {num_hidden} others')
    testfile_texts = ', '.join(testfile_texts)
    return testfile_texts


def format_testfile(testfile: Path) -> str:
    return format_testfiles([testfile])


def get_test_parameters(testfile: Path) -> Iterable[TestParameters]:
    LOGGER.debug(f'Testfile {format_testfile(testfile)}')
    setup_text, input_text, expected_output_text = read_testfile(testfile)

    for tex_format in get_tex_formats():
        LOGGER.debug(f'  Format {tex_format}')
        for template in get_templates(tex_format):
            LOGGER.debug(f'    Template {template.name}')
            for command in get_commands(tex_format):
                LOGGER.debug(f'      Command {format_command(command)}')
                yield TestParameters(setup_text, input_text, expected_output_text, tex_format, template, command)


def run_test(testfile: Path) -> TestResult:

    # Run the test for all different test parameters.
    test_subresults: List[TestSubResult] = []
    for test_parameters in get_test_parameters(testfile):

        setup_text, input_text, expected_output_text, tex_format, template, command = test_parameters

        # Create a temporary directory.
        temporary_directory = Path(mkdtemp())

        # Copy global support files.
        for support_file in SUPPORT_DIRECTORY.glob('*'):
            copyfile(support_file, temporary_directory / support_file.name)

        # Create test-specific support files.
        with (temporary_directory / TEST_SETUP_FILENAME).open('wt') as f:
            print(setup_text, file=f)

        with (temporary_directory / TEST_INPUT_FILENAME).open('wt') as f:
            print(input_text, file=f)

        with (temporary_directory / TEST_EXPECTED_OUTPUT_FILENAME).open('wt') as f:
            print(expected_output_text, file=f)

        # Create test file.
        test_text = run_m4(
            template, TEST_SETUP_FILENAME=TEST_SETUP_FILENAME, TEST_INPUT_FILENAME=TEST_INPUT_FILENAME)
        with (temporary_directory / TEST_FILENAME).open('wt') as f:
            print(test_text, file=f)

        # Run test.
        test_process = run(command, cwd=temporary_directory, capture_output=True)
        test_subresult = TestSubResult(testfile, test_parameters, temporary_directory, test_process)
        test_subresults.append(test_subresult)

    test_result = TestResult(test_subresults)
    return test_result


# Command-line interface
@click.command()
@click.argument('testfiles',
                nargs=-1,
                type=click.Path(exists=True, dir_okay=False, file_okay=True),
                required=True)
@click.option('--update-tests/--no-update-tests',
              help='Update testfiles with unexpected results',
              is_flag=True,
              default=UPDATE_TESTS)
@click.option('--fail-fast/--no-fail-fast',
              help='When a test fails, stop immediately',
              is_flag=True,
              default=FAIL_FAST)
def main(testfiles: Iterable[str], update_tests: bool, fail_fast: bool) -> None:

    testfiles: List[Path] = list(map(Path, testfiles))
    LOGGER.info(f'Running tests for {len(testfiles)} testfiles')

    # Run tests.
    some_tests_failed = False
    results: List[TestResult] = []
    sequential_results = list(map(run_test, testfiles[:1]))  # Populate caches with the first testfile.
    with Pool(NUM_PROCESSES) as pool:
        parallel_results = pool.imap(run_test, testfiles[1:])  # Run the remaining tests in parallel.
        results_iter = chain(sequential_results, parallel_results)
        results_iter = tqdm(results_iter, total=len(testfiles))
        for result in results_iter:
            if not result:
                some_tests_failed = True
            if not result and update_tests:
                result.try_to_update_testfile()  # Will change bool(result) to True on success.
            if not result and fail_fast:
                results_iter.close()  # Close the progress bar.
                print(result.summarize(), file=sys.stderr)
                sys.exit(1)
            results.append(result)

    if some_tests_failed:
        LOGGER.error('Some tests failed, see the summary below:')
        print(TestResult.summarize_results(results), file=sys.stderr)
        sys.exit(1)
    else:
        LOGGER.info('All tests succeeded!')


if __name__ == '__main__':
    logging.basicConfig(level=LOG_LEVEL, format='%(asctime)s %(message)s')
    main()
