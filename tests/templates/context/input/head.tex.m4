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
