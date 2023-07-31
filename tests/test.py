#!/usr/bin/env python3

"""Run a test for each testfile passed as an argument."""

from typing import List

import click


UPDATE_TESTS = False
FAIL_FAST = False


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
def main(testfiles: List[str], update_tests: bool, fail_fast: bool):
    pass


if __name__ == '__main__':
    main()
