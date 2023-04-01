% Load the package.
\usemodule[t][markdown]
% Load the support files.
\input setup\relax
\input plain-setup\relax
% Load the test-specific setup.
\input TEST_SETUP_FILENAME\relax
% Perform the test.
\starttext
  \catcode"7C=12%  Prevent pipes (U+007C) from being active in ConTeXt
  \inputmarkdown{TEST_INPUT_FILENAME}%
\stoptext
