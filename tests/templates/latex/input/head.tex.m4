\documentclass{minimal}
\csname UseRawInputEncoding\endcsname

% Load the package.
\usepackage[
  plain,
  import = {
    witiko/markdown/test/latex = snippet as testSnippet,
  },
]{markdown}

% Load the support files.
\markdownSetup {
  eagerCache = false,
  outputDir = OUTPUT_DIRECTORY,
}

\begin{document}
