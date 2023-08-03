.PHONY: all

FLAGS =
ifeq ($(UPDATE_TESTS), true)
	FLAGS += --update-tests
endif
ifeq ($(FAIL_FAST), false)
	FLAGS += --no-fail-fast
endif

# This is the default pseudo-target. It runs all the tests.
all:
	find testfiles/ -type f -name '*.test' -exec ./test.sh $(FLAGS) {} +
