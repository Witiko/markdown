#!/bin/bash
# Speed-test the unit testing framework with different numbers of hyperthreads
# and batch size, repeating the tests a number of times, so that we can better
# esimate the expected runtime and also so that we can estimate the measurement
# error.

set -e -o xtrace

NUMS_PROCESSES=(1 2 4 8 16 32 64)
BATCH_SIZES=(1 2 4 8 16 32 64 128 256 512 1024)
SAMPLES=({1..5})

parallel --bar --jobs 1 --ungroup --joblog speed-tests.joblog --halt now,fail=1 --resume-failed -- \
  ./speed-test.sh {2} {3} \
  ::: "${SAMPLES[@]}" ::: "${NUMS_PROCESSES[@]}" ::: "${BATCH_SIZES[@]}"
