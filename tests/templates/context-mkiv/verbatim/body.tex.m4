\begingroup
% Load the test-specific setup.
\input TEST_SETUP_FILENAME\relax
% Prevent the folding of characters into a single space token in logs.
\catcode"09=12%  Tabs (U+0009)
\catcode"20=12%  Spaces (U+0020)
% Do not preserve trailing spaces in input buffer for parity with other TeX formats.
\ctxlua{document.markdown_preserve_trailing_spaces = false}
% Disable active characters of the TeX engine.
\catcode"7E=12%  Tildes (U+007E)
\catcode"7C=12%  Pipes (U+007C)
% Perform the test.
\startmarkdown
undivert(TEST_INPUT_FILENAME)dnl
\stopmarkdown
\endgroup
