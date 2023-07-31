#!/bin/bash
# Run tests in a Python virtual environment.

set -o errexit

if [ ! -d test-virtualenv ]
then
  # Create a Python virtual environment.
  trap 'rm -rf test-virtualenv' EXIT
  python3 -m venv test-virtualenv
  source test-virtualenv/bin/activate
  pip install -U pip wheel setuptools
  pip install -r requirements.txt
  deactivate
  trap '' EXIT
fi

# Activate a Python virtual environment.
source test-virtualenv/bin/activate

# Run tests.
python3 test.py "$@"

# TODO: Remove all below code.

exit

# Run a test for each testfile passed as an argument. If a testfile does not
# contain the expected test result, generate one.

set -o errexit
set -o pipefail
set -o nounset

BUILDDIR="$(mktemp -d)"
trap 'rm -rf "$BUILDDIR"' INT TERM
for TESTFILE; do
  printf 'Testfile %s\n' "$TESTFILE"
  for FORMAT in templates/*/; do
    printf '  Format %s\n' "$FORMAT"
    for TEMPLATE in "${FORMAT}"*.tex.m4; do
      printf '    Template %s\n' "$TEMPLATE"
      m4 -DTEST_FILENAME=test.tex <"$FORMAT"/COMMANDS.m4 |
      (while read -r COMMAND; do
        printf '      Command %s\n' "$COMMAND"

        # Set up the testing directory.
        cp support/* "$TESTFILE" "$BUILDDIR"
        cd "$BUILDDIR"
        sed -r '/^\s*<<<\s*$/{x;q}' \
          <"${TESTFILE##*/}" >test-setup.tex
        sed -rn '/^\s*<<<\s*$/,/^\s*>>>\s*$/{/^\s*(<<<|>>>)\s*$/!p}' \
          <"${TESTFILE##*/}" >test-input.md
        sed -n '/^\s*>>>\s*$/,${/^\s*>>>\s*$/!p}' \
          <"${TESTFILE##*/}" >test-expected.log
        m4 -DTEST_SETUP_FILENAME=test-setup.tex \
           -DTEST_INPUT_FILENAME=test-input.md <"$OLDPWD"/"$TEMPLATE" >test.tex

        # Run the test, filter the output and concatenate adjacent lines.
        eval "$COMMAND" >/dev/null 2>&1 ||
          printf '        Command terminated with exit code %d.\n' $?
        touch test.log
        sed -nr '/^\s*TEST INPUT BEGIN\s*$/,/^\s*TEST INPUT END\s*$/{
          /^\s*TEST INPUT (BEGIN|END)\s*$/!H
          /^\s*TEST INPUT END\s*$/{s/.*//;x;s/\n//g;p}
        }' <test.log >test-actual.log

        # If the testfile does not contain an expected outcome, use the current
        # outcome and update the testfile.
        if ! grep -q '^\s*>>>\s*$' <"${TESTFILE##*/}"; then
          cp test-actual.log test-expected.log
          (cat "${TESTFILE##*/}" && printf '>>>\n'
            cat test-expected.log) >"$OLDPWD"/"$TESTFILE"
          printf '        Added the expected test outcome to the testfile.\n'
        fi

        # Compare the expected outcome against the actual outcome.
        diff -a -c test-expected.log test-actual.log ||
        # Uncomment the below lines to update the testfile with the actual
        # outcome whenever the expected outcome and the actual outcome
        # mismatch.
#          (sed -n '1,/^\s*>>>\s*$/p' <"${TESTFILE##*/}" &&
#            cat test-actual.log) >"$OLDPWD"/"$TESTFILE" ||
           false

        # Clean up the testing directory.
        cd "$OLDPWD"
        find "$BUILDDIR" -mindepth 1 -exec rm -rf {} + # && break
      done) # && break
    done # && break
  done
done
rm -rf "$BUILDDIR"
