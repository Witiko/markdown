\documentclass{minimal}
\csname UseRawInputEncoding\endcsname
% Load the package.
\usepackage[plain]{markdown}
\markdownSetup{import=witiko/markdown/test}
% Load the support files.
\input setup\relax
% Load the test-specific setup.
\input TEST_SETUP_FILENAME\relax
\begin{document}
% Perform the test.
\markdownInput[snippet=witiko/markdown/test/snippet]{TEST_INPUT_FILENAME}%
\end{document}
