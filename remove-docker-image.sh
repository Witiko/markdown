#!/bin/bash
# Remove Docker image for the current Git commit of the markdown package.
# Run from the root directory of the witiko/markdown Git repository.

# Log ran commands.
set -o xtrace

# Remove the docker image
GIT_COMMIT="$(git rev-parse HEAD)"
IMAGE_NAME="lostenderman/markdown:$GIT_COMMIT"
docker rmi "$IMAGE_NAME"
