This directory contains subdirectories, which correspond to individual TeX
formats. These subdirectories contain subdirectories with TeX source code
templates and a file named `COMMANDS.m4`.

The TeX source code templates contain three documents: `head.tex.m4`,
`body.tex.m4`, and `foot.tex.m4`. First, these files are preprocessed by
the m4 macro preprocessor with the following macro definitions:

 1. `OUTPUT_DIRECTORY` corresponds to the name of the TeX output directory.
 2. `TEST_SETUP_FILENAME` corresponds to the name of the file containing the
    test setup TeX source code. This macro is only available in `body.tex.m4`.
 3. `TEST_INPUT_FILENAME` corresponds to the name of the file containing the
    test markdown source code. This macro is only available in `body.tex.m4`.

Then, the file `head.tex`, the preprocessing results of `body.tex.m4`, and the
file `foot.tex` are concatenated. Finally, the concatenation result is typeset.

The `COMMANDS.m4` file contains a newline-separated list of commands that will
be used to typeset the pre-processed TeX source code templates. Before use,
the commands will preprocessed with the following macro definitions:

 1. `OUTPUT_DIRECTORY` corresponds to the name of the TeX output directory.
 2. `TEST_FILENAME` corresponds to the name of the pre-processed TeX source
    code template that is being typeset.
