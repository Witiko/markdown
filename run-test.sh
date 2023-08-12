#!/bin/bash
# Run Lua script $1 and determine whether it has been killed by the OOM killer.

# Log ran commands.
set -o xtrace

# Test the memory leak.
GIT_COMMIT="$(git rev-parse HEAD)"
IMAGE_NAME="lostenderman/markdown:$GIT_COMMIT"
# For reproducibility and consideration for other running programs, restrict the memory usage to 1GiB of RAM.
docker run -m 1g --rm -v "$PWD":/workdir -w /workdir "$IMAGE_NAME" texlua "$1"
DOCKER_RUN_EXIT_CODE=$?

# Return the exit code
if [[ $DOCKER_RUN_EXIT_CODE = 137 ]]
then
  echo Failed the test "$1", failure.
  exit 1
elif [[ $DOCKER_RUN_EXIT_CODE != 0 ]]
then
  echo Some error in markdown.lua, cannot be tested.
  exit 125
fi
