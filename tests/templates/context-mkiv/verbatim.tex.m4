% Load the package.
\startluacode
local kpse = require("kpse")
kpse.set_program_name("luatex")
\stopluacode
\usemodule[t][markdown]
% Load the support files.
\input setup\relax
\input plain-setup\relax
% Load the test-specific setup.
\input TEST_SETUP_FILENAME\relax
% Perform the test.
\starttext
  \catcode"7C=12%  Prevent pipes (U+007C) from being active in ConTeXt
  \startmarkdown
undivert(TEST_INPUT_FILENAME)dnl
  \stopmarkdown
\stoptext
