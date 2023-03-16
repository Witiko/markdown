% Load the package.
\usemodule[t][markdown]
% Load the support files.
\input setup\relax
\input plain-setup\relax
% Load the test-specific setup.
\input TEST_SETUP_FILENAME\relax
% Perform the test.
\starttext
  \inputmarkdown{TEST_INPUT_FILENAME}%
\stoptext
