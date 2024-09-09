\documentclass{minimal}
\csname UseRawInputEncoding\endcsname

% Load the package.
\usepackage[plain, theme=witiko/markdown/test/latex]{markdown}
\markdownSetupSnippet{testSnippet}{
  snippet = witiko/markdown/test/latex/snippet,
}

% Load the support files.
\markdownSetup {
  eagerCache = false,
  outputDir = OUTPUT_DIRECTORY,
}

\begin{document}
