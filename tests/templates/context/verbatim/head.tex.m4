% Load the package.
\usemodule[t][markdown]

% Load the support files.
\setupmarkdown [
  eagerCache = false,
  import = {
    witiko/markdown/test = snippet as testsnippet,
  },
  snippet = testsnippet,
]

\starttext

% Prevent the folding of characters into a single space token in logs.
\catcode"09=12%  Tabs (U+0009)
\catcode"20=12%  Spaces (U+0020)

% Disable active characters of the TeX engine.
\catcode"7E=12%  Tildes (U+007E)
