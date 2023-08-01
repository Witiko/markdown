#!/bin/bash
# Run tests in a Python virtual environment.

set -o errexit

# Create a Python virtual environment.
if [ ! -d test-virtualenv ]
then
  trap 'rm -rf test-virtualenv' EXIT
  chronic python3 -m venv test-virtualenv
  source test-virtualenv/bin/activate
  chronic pip install -U pip wheel setuptools
  chronic pip install -r requirements.txt
  deactivate
  trap '' EXIT
fi

# Activate a Python virtual environment.
source test-virtualenv/bin/activate

# Run tests.
python3 test.py "$@"
