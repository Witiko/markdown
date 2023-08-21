\begingroup
% Load the test-specific setup.
\input TEST_SETUP_FILENAME\relax
% Prevent the folding of characters into a single space token.
\catcode"09=12%  Tabs (U+0009)
\catcode"20=12%  Spaces (U+0020)
% Disable active characters of the TeX engine.
\catcode"7E=12%  Tildes (U+007E)
% Perform the test.
\markdownBegin
undivert(TEST_INPUT_FILENAME)dnl
\markdownEnd
\endgroup