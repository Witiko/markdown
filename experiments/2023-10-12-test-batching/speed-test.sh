#!/bin/bash
# Speed-test the unit testing framework with a specified number of hyperthreads
# and batch size.

set -e -o xtrace

NUM_PROCESSES="$1"
BATCH_SIZE="$2"
OUTPUT_FILE=speed-test-num_processes="$NUM_PROCESSES"-batch_size="$BATCH_SIZE".txt

GIT_REF=7613632
DOCKER_IMAGE=witiko/markdown:3.0.0-alpha.2-98-g"$GIT_REF"-latest

# Fetch the Markdown package and patch it for speed-testing
git clone https://github.com/Witiko/markdown.git
cd markdown
git checkout "$GIT_REF"
git apply <<EOF
diff --git a/tests/test.py b/tests/test.py
index 7f1b4d0..87bdf4a 100644
--- a/tests/test.py
+++ b/tests/test.py
@@ -33,7 +33,7 @@ LOG_LEVEL: int = logging.INFO
 UPDATE_TESTS: bool = False
 FAIL_FAST: bool = True
 
-NUM_PROCESSES: int = cpu_count()
+NUM_PROCESSES: int = $NUM_PROCESSES
-TESTFILE_BATCH_SIZE: Dict[bool, int] = {True: 20, False: 100}  # The batch size depends on whether fail-fast is enabled.
+TESTFILE_BATCH_SIZE: Dict[bool, int] = {True: $BATCH_SIZE, False: $BATCH_SIZE}  # The batch size depends on whether fail-fast is enabled.
 
 MAX_TESTFILE_NAMES_SHOWN: int = 5
@@ -704,14 +704,6 @@ def run_tests(testfiles: Iterable[TestFile], fail_fast: bool) -> Iterable[TestRe
             if remaining_testfiles:
                 nonlocal testfile_batch_size
                 num_batches = int(ceil(len(remaining_testfiles) / testfile_batch_size))
-                if num_batches < NUM_PROCESSES:
-                    updated_testfile_batch_size = int(ceil(len(remaining_testfiles) / NUM_PROCESSES))
-                    updated_num_batches = int(ceil(len(remaining_testfiles) / updated_testfile_batch_size))
-                    assert updated_num_batches <= NUM_PROCESSES
-                    assert updated_testfile_batch_size <= testfile_batch_size
-                    if updated_testfile_batch_size < testfile_batch_size:
-                        LOGGER.debug(f'Reducing batch size to {updated_testfile_batch_size} to fully utilize {NUM_PROCESSES} hyperthreads.')
-                    testfile_batch_size, num_batches = updated_testfile_batch_size, updated_num_batches
                 remaining_testfile_batches: List[TestFileBatch] = list(chunked(remaining_testfiles, testfile_batch_size))
                 remaining_batches = zip(remaining_testfile_batches, repeat(fail_fast))
                 assert len(remaining_testfile_batches) == num_batches
EOF
cd -

# Create a Python virtualenv before measuring the speed.
docker run --rm -i -u "$(id -u)":"$(id -g)" -v "$PWD"/markdown:/workdir -w /workdir/tests "$DOCKER_IMAGE" ./test.sh || true

# Measure the speed
/usr/bin/env time -o "$OUTPUT_FILE" -a docker run --rm -i -v "$PWD"/markdown:/workdir:ro -w /workdir "$DOCKER_IMAGE" make test

# Clean up
rm -rf markdown/
