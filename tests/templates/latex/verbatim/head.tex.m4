\documentclass{minimal}
\csname UseRawInputEncoding\endcsname

% Load the package.
\usepackage[plain]{markdown}

% Load the support files.
\markdownSetup {
  eagerCache = false,
  outputDir = OUTPUT_DIRECTORY,
  import = {
    witiko/markdown/test = snippet as testSnippet,
  }
}

\begin{document}
