This directory contains subdirectories with test files, which can be recognized
by the `.test` suffix. A test file has the following syntax:

    Optional YAML metadata
    ---
    The test setup TeX source code
    <<<
    The test markdown source code
    >>>
    The expected test output

The test setup TeX source code can be used to configure the Markdown package
through its plain TeX interface before the test markdown source code is
processed.

The optional YAML metadata may contain any useful information, although we
currently only process the `if` key that can be used to specify for which
TeX formats and templates the testfile should run using Python syntax:

``` yaml
if: format == 'context-mkiv' or template == 'verbatim'
```

If no YAML metadata are specified, the `---` delimiter may also be omitted.

The test markdown source code is the markdown code that will be processed
during the test. The majority of markdown tokens are configured by the support
files to produce output to the log file. This output will be compared against
the expected test output.
