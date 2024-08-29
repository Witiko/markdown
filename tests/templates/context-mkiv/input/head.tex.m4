% Load the package.
\startluacode
local kpse = require("kpse")
kpse.set_program_name("luatex")
\stopluacode
\usemodule[t][markdown]

% Load the support files.
\setupmarkdown [
  eagerCache = false,
  import = {
    witiko/markdown/test = snippet as testsnippet,
  }
]

\starttext
