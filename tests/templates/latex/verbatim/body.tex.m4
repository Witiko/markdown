\begingroup
% Load the test-specific setup.
\input TEST_SETUP_FILENAME\relax
% Perform the test.
\begin{markdown*}{snippet=witiko/markdown/test/snippet}
undivert(TEST_INPUT_FILENAME)dnl
\end{markdown*}
\endgroup
