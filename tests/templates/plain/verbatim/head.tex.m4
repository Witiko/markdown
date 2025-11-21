% Load the package.
\input markdown

% Load the support files.
\markdownSetup {
  outputDir = OUTPUT_DIRECTORY,
  import = {
    witiko/markdown/test = snippet as testSnippet,
  },
  snippet = testSnippet,
}
