% Load the test-specific setup.
\input TEST_SETUP_FILENAME\relax
% Perform the test.
\catcode"7C=12%  Prevent pipes (U+007C) from being active in ConTeXt
\startmarkdown
undivert(TEST_INPUT_FILENAME)dnl
\stopmarkdown
