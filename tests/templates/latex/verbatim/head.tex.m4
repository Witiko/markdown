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
  },
  snippet = testSnippet,
}

\begin{document}

% Prevent the folding of characters into a single space token.
\catcode"09=12%  Tabs (U+0009)
\catcode"20=12%  Spaces (U+0020)

% Disable active characters of the TeX engine.
\catcode"7E=12%  Tildes (U+007E)
