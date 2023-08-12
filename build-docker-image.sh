#!/bin/bash
# Build Docker image for the current Git commit of the markdown package.
# Run from the root directory of the witiko/markdown Git repository.

# Stop on the first command with non-zero error code and log ran commands.
set -e
set -o xtrace

# Fetch and checkout the current submodules.
git submodule update --recursive

# Do not typeset the technical documentation.
sed -r -i -e 's/(TECHNICAL_DOCUMENTATION=).*/\1/' Makefile

# Do not typeset the examples.
sed -n -i '/EXAMPLES=/,/[^\\]$/!p' Makefile

# Do not run the pkgcheck command on the distribution archive.
sed -n -i '/git clone https:\/\/gitlab.com\/Lotz\/pkgcheck\.git/!p' Makefile
sed -n -i '/for RETRY in \$\$(seq 1 10);/,/exit \$\$EXIT_CODE/!p' Makefile

# Do not stop on the first command with non-zero error code.
# We will inspect the exit codes manually, so that we can clean up in case of failure.
set +e

# Build the Docker image
GIT_COMMIT="$(git rev-parse HEAD)"
IMAGE_NAME="lostenderman/markdown:$GIT_COMMIT"
DOCKER_BUILDKIT=1 docker build --build-arg BUILDKIT_CONTEXT_KEEP_GIT_DIR=1 . -t "$IMAGE_NAME"
DOCKER_BUILD_EXIT_CODE=$?

# Clean up
git add markdown.dtx
git checkout .
git restore --staged markdown.dtx

# Return the exit code
if [[ $DOCKER_BUILD_EXIT_CODE != 0 ]]
then
  echo Failed to build the docker image
  exit 125
fi
