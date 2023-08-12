#!/bin/bash
# Determine whether the current commit is affected by the memory leak
# described in <https://github.com/Witiko/markdown/pull/226>.

# Log ran commands.
set -o xtrace

# Build the Docker image
./build-docker-image.sh
DOCKER_BUILD_EXIT_CODE=$?

# Test the memory leak.
if [[ $DOCKER_BUILD_EXIT_CODE = 0 ]]
then
  ./run-test.sh memory-leak.lua
  DOCKER_RUN_EXIT_CODE=$?
fi

# Clean up
./remove-docker-image.sh

# Return the exit code
if [[ $DOCKER_BUILD_EXIT_CODE != 0 ]]
then
  exit "$DOCKER_BUILD_EXIT_CODE"
elif [[ $DOCKER_RUN_EXIT_CODE != 0 ]]
then
  exit "$DOCKER_RUN_EXIT_CODE"
else
  echo No problems were detected, success.
  exit 0
fi
