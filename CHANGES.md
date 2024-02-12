# Changes

## 3.4.1 (2024-02-17)

Fixes:

- Rename option `contentType` to `contentLevel`. (#300, #400, ca98e039)

## 3.4.0 (2024-01-31)

Development:

- Separate default token renderer prototype definitions to a universal theme
  `witiko/markdown/defaults`. (#391, #392)
- Add format-independent options `noDefaults` and `plain`, which control the
  loading of theme `witiko/markdown/defaults`. (#393, #394)
- Add `contentLevel` Lua option.
  (#300, #375, #400, contributed by @lostenderman)

Fixes:

- Make Pandoc syntax extensions `tex_single_backslash_math` and
  `tex_double_backslash_math` robust against extra spaces at the beginning /
  end of inline / display math. (#386, #399, contributed by @lostenderman)

Libraries:

- Update `tinyyaml` to v0.4.4. (e2a59ba)

Contributed Software:

- Remove private GitHub repository `contributions/istqb_latex`. (cc21fe2)
- Add `contributions/37c3-beamer`. (f5bb26b, contributed by @TeXhackse)

Default Renderer Prototypes:

- Do not unnecessarily override math renderer prototypes in LaTeX/ConTeXt.
  (#387, #396, contributed by @zousiyu1995)

Unit Tests:

- In pull requests, process added and modified testfiles first.
  (feafe9b9, 9ff530da, 18deae73)

Deprecation:

- Replace all instances of `\markdownInfo`, `\markdownWarning`, and
  `\markdownError` with l3msg functions and deprecate `\markdownInfo`,
  `\markdownWarning`, and `\markdownError`. (#383, #398)

Docker:

- Uninstall the distribution Markdown package. (258a73d4)

## 3.3.0 (2023-12-30)

Development:

- Add support for universal (cross-format) themes. (#276, #373)

Fixes:

- Prevent unwanted space tokens before `*ContextEnd` renderers. (#373)
- Make ConTeXt command `\inputmarkdown` properly process extra options.
  (#389, #390, contributed by @ibotty)

Documentation:

- Improve the discoverability of the `\markdownInput` macro.
  (#381, #382, contributed by @solernou)
- Encourage alternatives to the `hybrid` option in the user manual. (#382)

Speed Improvements:

- Optimize needless catcode switching in package code. (3eb7231)

Default Renderer Prototypes:

- Fix the typesetting of level four headings with attributes for LaTeX document
  classes without the `\chapter` command such as `article` and level five
  headings for LaTeX document classes with the `\chapter` command such as
  `book`. (86eefc0)

## 3.2.1 (2023-11-23)

Fixes:

- Remove the `options.cacheDir` directory if it is empty after conversion.
  (5cfcea6)
- Allow tables inside lists. (#368, #371, contributed by @lostenderman,
  sponsored by ISTQB)
- Check that shell access is unrestricted before attempting shell escape.
  (#365, witiko/lt3luabridge#22, latex3/latex3#1339, #372)

Documentation:

- Add a link to a work-in-progress article for TUGboat 45:1 to `README.md`.
  (1988a0c2, 3b85533d)
- Fix miscellaneous issues with the technical documentation. (#366, #367)
- In `README.md`, add a link to a GPT chatbot with background knowledge about
  the Markdown Package for TeX. (59eb04d)

Docker:

- Include developer tools in the development Docker image. (#374)

## 3.2.0 (2023-10-21)

Development:

- Add support for Pandoc `auto_identifiers` and `gfm_auto_identifiers`
  syntax extensions.
  (#237, #238, lostenderman/markdown#153, #315, #354,
   contributed by @lostenderman)
- Add support for bulk redefinition of token renderers and token renderer
  prototypes in the `\markdownSetup` command using enumeration.
  (#232, #361..#363, [matrix.org][matrix-361])

 [matrix-361]: https://matrix.to/#/!UeAwznpYwwsinVTetR:matrix.org/$k__vWylYp_L9eyZ0lXCPy26GokZ-Y9g5v8Xs9n47twQ?via=matrix.org&via=im.f3l.de

Fixes:

- Make the `import` LaTeX option correctly handle recursive imports.
  (68c7a2f5, danopolan/istqb_latex#87)
- Support attributes on multi-line setext headings.
  (#315, #355, #356, contributed by @lostenderman)
- Correctly process the combination of Lua options `fancyLists` and
  `startNumber`. (59fb97e8)
- Properly parse emphasis at line endings in headings.
  (#358, #360, contributed by @lostenderman)
- Fix fancy lists that use roman numerals as markers.
  (danopolan/istqb_latex#87, #359, #364,
   contributed by @lostenderman, sponsored by ISTQB)

Documentation:

- Add a link to a preprint from TUGboat 44:3 to `README.md`.
  (cf6b3d7b, dc57af7)
- Measure the speed impact of test file batching.
  (#357, b526fa65, 8c94ffc9, [matrix.org][matrix-357])

 [matrix-357]: https://matrix.to/#/!efVbynJpCMjlOTfose:matrix.org/$WR3quuO1fyOl6w_KX6YFA4BACBcL-cWUWBpVfpPWDkI?via=matrix.org&via=im.f3l.de

Unit Tests:

- Restore CommonMark testfiles with trailing tabs and spaces.
  (#348, #353, lostenderman/markdown#2, contributed by @lostenderman)
- Fail faster during batch bisection. (5177ef6)
- Speed up tests by running ConTeXt MkIV only once. (61f36e6d)
- Use `BEGIN document` and `END document` instead of `documentBegin`
  and `documentEnd` for consistence with other renderers. (0be6be4)

Continuous Integration:

- Do not rebuild existing Docker images when we rerun the
  continuous integration for the same commit multiple times.
  (ae390ec, 70c5f2e5)

Default Renderer Prototypes:

- In LaTeX, correctly capitalize fancy list labels. (0a10053f)
- In LaTeX, properly indent fancy ordered lists when the Lua option
  `startNumber` is enabled. (6a7649e8)

## 3.1.0 (2023-09-27)

Development:

- Add `\markdownSetup` command to all TeX formats.
  (#275, #349, [matrix.org][matrix-349])
- Add an optional argument to the `markdown` LaTeX environment.
  (#299, #351)
- Add support for Pandoc `mark` syntax extension.
  (jgm/lunamark#67, #303, #352, [matrix.org][matrix-352],
   contributed by @Omikhleia)

 [matrix-349]: https://matrix.to/#/!efVbynJpCMjlOTfose:matrix.org/$8JXGbDz0viyRyv6ySWQ3344BOhwd4dj5WYeawzEg_tU?via=matrix.org&via=im.f3l.de
 [matrix-352]: https://matrix.to/#/!lWGKeMcpgwGHpfLYkf:matrix.org/$yVeWB0Yzfz6mgORv5VeG9IEl7a4xLogkAUmdNMSCxEg?via=matrix.org&via=im.f3l.de

Deprecation:

- Deprecate the `markdown*` LaTeX environment.
  (#299, #351, [matrix.org][matrix-351])

 [matrix-351]: https://matrix.to/#/!lWGKeMcpgwGHpfLYkf:matrix.org/$yVeWB0Yzfz6mgORv5VeG9IEl7a4xLogkAUmdNMSCxEg?via=matrix.org&via=im.f3l.de

Unit Tests:

- Add support for YAML metadata in testfiles.
  (#345, #347, [matrix.org][matrix-347])

 [matrix-347]: https://matrix.to/#/!efVbynJpCMjlOTfose:matrix.org/$8JXGbDz0viyRyv6ySWQ3344BOhwd4dj5WYeawzEg_tU?via=matrix.org&via=im.f3l.de

Documentation:

- Add a link to a preprint from CSTUG Bulletin to `README.md`.
  (2c354f49)

## 3.0.1 (2023-09-10)

Fixes:

- Correctly parse paragraphs with trailing spaces.
  (danopolan/istqb_latex#77, #345, #347)

## 3.0.0 (2023-08-25)

Development:

- Add support for TeX-like rich paragraphs.
  (#30, #306, [matrix.org][matrix-306])

 [matrix-306]: https://matrix.to/#/!lWGKeMcpgwGHpfLYkf:matrix.org/$g9ZTEyXP-V_5elJjcqRd-D9QyIfJuTw-TWlZIFoh72c?via=matrix.org&via=im.f3l.de

Fixes:

- Reset current heading level at the end of a markdown document.
  (1261e6f)
- Fix out-of-memory issues with CommonMark implementation.
  (#308, #318, 28650b8)
- Fix `rawAttribute` option being enabled in Lua by default.
  (92c9ac2)
- Make our implementation of attributes compatible with jgm/pandoc.
  (jgm/lunamark#68, #304, #343, contributed by @Omikhleia)

Documentation:

- Fix the link to @xvrabcov's talk at TUG 2022 in `README.md`.
  (166c4506)
- Add a link to @writersglen's talk at TUG 2022 to `README.md`.
  (f3efcb9)
- Document setting up catcodes in Lua. (#329, #342)

Unit Tests:

- Batch unit tests to improve speed.
  (#245, #316, 8bfd0b3, #317, #319..#325, #327, #328, e3b31696,
   #331, #332, #334, 0a230fa, 90cc428, 3be0013, dbe1808, a0108814)
- Use self-hosted GitHub runners for tests to improve speed.
  (#326, #330, #331, a9948a86, 68b6216b, contributed by @TeXhackse,
   [matrix.org][matrix-331])

 [matrix-331]: https://matrix.to/#/!efVbynJpCMjlOTfose:matrix.org/$6qKDXlLxsaJnOl0muFX3K7Htj41B-7hL2PmSFTIm6NE?via=matrix.org&via=im.f3l.de

Continuous Integration:

- In draft pull requests, do not build documentation or examples
  and do not run pkgcheck. (#337, #338, 189bb153)
- Push temporary Docker images to GitHub Packages.
  (#340, #341, d15ae88a, 7e42e846)

## 3.0.0-alpha.2 (2023-08-01)

Development:

- Add support for attributes on tables. (#310, #313, 8786408)

Default Renderer Prototypes:

- Correctly handle multiple heading identifiers. (3ae1b0d1)
- Add alt text to figures. (#312)

Documentation:

- Add a link to TUG 2023 slides and video to the README.
  (ce6047b8, adb69e2f)

Unit Tests:

- Rewrite the unit testing framework from Bash to Python
  and implement summarization. (#245, #314)

## 3.0.0-alpha (2023-06-27)

Development:

- Comply with CommonMark 0.30 and increment `grammar_version` to `3`.
  (contributed by @lostenderman, #29, #210, #212, #226)
- Add a demo of using the Markdown package in OpTeX.
  (contributed by @olsak, #215, 109c1b5, #292)
- Add `singletonCache` Lua option. (#226)

Documentation:

- Add @lostenderman's thesis to `README.md`. (#226, 8a4536e)

Default Renderer Prototypes:

- Do not force line breaks after high-level headings in LaTeX.
  Allow the text to follow the heading on the same line. (df8562c)

Deprecation:

- Remove deprecated parts of the package. (#309)
- Remove support for LuaMetaTeX. (#226)

Fixes:

- Allow references in fenced divs. (#307, jgm/lunamark#69)
- Prevent `eagerCache=false` from causing undefined behavior and make
  it the new default. (#129)

## 2.23.0 (2023-04-27)

Development:

- Add support of bulk redefinition of token renderers and
  token renderer prototypes in the `\markdownSetup` LaTeX
  command using wildcards. (#232, #287)

Fixes:

- Drop support for ConTeXt Mark II, since the MkII files are
  no longer installed in TeX Live 2023, see the article by
  [Hans Hagen](https://tug.org/texlive/files/tb136hagen-texlive.pdf).
  (#281, #282)
- Remove extra space after inline elements with attributes.
  (#288)
- Make our implementation of attributes compatible with jgm/pandoc.
  (#279, #297, f7c701b)

Documentation:

- Add a link to a preprint from TUGboat 44(1) to `README.md`.
  (#234, a4d9fbf)
- Separate example files for pdfLaTeX, XeLaTeX, LuaLaTeX, and
  TeX4ht. (daccaa8)

Docker:

- Add TeX Live 2022 historical image. (#285, #295)
- Add support for TeX Live 2023. (contributed by @gucci-on-fleek,
  #281, #282)

Refactoring:

- Use `\prg_new_conditional:Nnn` to define `\@@_if_option:n`.
  (#289)

Libraries:

- Make tinyyaml a standalone CTAN package. (contributed by
  @zepinglee, #218, #294)

Default Renderer Prototypes:

- Make the default LaTeX renderer prototypes for tight lists produce
  surrounding spaces. (#290, #296)

## 2.22.0 (2023-04-02)

Development:

- Add support for TeX math surrounded by backslash-escaped
  parens and brackets. (contributed by @lostenderman, #61,
  #235, #236, #270)
- Add support for attributes on links, images, fenced code,
  and inline code spans. (jgm/lunamark#36, jgm/lunamark#43,
  #50, #123, #256, #280, [matrix.org][matrix-256])
- Add `import` LaTeX option. (#107, #286)

 [matrix-256]: https://matrix.to/#/!pznomuvubVyxElflTe:matrix.org/$mDATROtxOLOGBvH5Nt3o86iysRe1LCfZB-lw4PqjKJk?via=matrix.org&via=im.f3l.de

Documentation:

- Unify how Pandoc syntax extensions are named and cited in
  documentation. (#274, #284)

Refactoring:

- Only configure the Kpathsea library if it has not already
  been configured. (#268, #283)

Deprecation:

- Deprecate `theme` LaTeX option in favor of the new
  `import` LaTeX option. (#107, #285)

## 2.21.0 (2023-02-28)

Development:

- Add renderers that represent the sections implied by headings.
  (#258, #264)
- Add support for slicing fenced divs. (#229, #266)
- Add support for TeX math surrounded by dollar signs.
  (contributed by @lostenderman, #61, #216, #267)

Fixes:

- Use MathML to render math in the user manual. (#261, #262)
- Properly normalize link references according to
  [CommonMark](https://spec.commonmark.org/0.30/#matches).
  (lostenderman#56, #265)
- Fail gracefully when CLI receives unknown options. (eddcb18)

Documentation:

- Rename `writer->encode_*()` methods to clarify their purpose.
  (lostenderman#101, #271, #272)

Deprecation:

- Deprecate the current semantics of header attribute contexts.
  (#258, #264)
- Deprecate `hardLineBreaks` Lua option. (#227, #263)

## 2.20.0 (2023-02-01)

Development:

- Add support for line blocks.
  (contributed by @Omikhleia and @lostenderman, jgm/lunamark#41,
  #209, #248)
- Add support for attributes on fenced code blocks.
  (contributed by @Omikhleia, jgm/lunamark#36, #123, #211)

Documentation:

- Add @drehak's thesis to `README.md`. (204a18c, aec9b44, cda53fb)
- Update examples for options `bracketedSpans` and `fencedDivs`.
  (499c65a, 532cdb8)

Fixes:

- Map U+0000 and U+FFFD to new replacement character renderer.
  (lostenderman#34, #247, #250)
- Map non-breaking space to `writer->nbsp` in strings.
  (lostenderman#99, #247, #249)
- Fix input normalization and move it from Lua CLI and plain TeX
  layers directly to the `convert()` Lua method. (#246, #253)
- Allow fenced div closing tag to break out of a blockquote.
  (contributed by @Omikhleia, jgm/lunamark#60, jgm/lunamark#61,
  #230, #259)

Default Renderer Prototypes:

- Use `paralist` LaTeX package to define default renderer prototypes for
  fancy lists when `fancyList` Lua option is enabled. (#241)
- Insert `\unskip` after default raw inline renderer prototype. (ca2047e)
- Make `\*group_begin:` and `\*group_end:` the default renderer prototypes
  for attribute contexts. (#243)
- In LaTeX and ConTeXt, use just first word of infostring to determine fence
  code block language. (#244)

Unit Tests:

- Do not fold tabs and spaces into a single space token.
  (lostenderman#107, #242)
- Do not escape URIs in test outputs. (lostenderman#8, #260, 291e388)

Speed Improvements:

- Only make backticks special when `codeSpans` or `fencedCode` are enabled.
  (#239)
- Use fast unit testing in continuous integration. (#231, #255)

Continuous Integration:

- Fix ownership of repository before running Docker image. (#240)

## 2.19.0 (2022-12-23)

Development:

- Add support for fenced divs and bracketed spans. (#126, #207)

Fixes:

- Fix incorrect category codes in plain TeX renderer prototype definitions.
  (f156f05)
- Allow backticks in tilde code block infostrings. (#214, #219, #221)

Refactoring:

- Sort Lua options, token renderers, and built-in syntax extensions. (#208)

Documentation:

- Add article [*High-Level Languages for
  TeX*](https://www.doi.org/10.5300/2022-1-4/35) (in Czech) from
  CSTUG Bulletin 1–4/2022 to `README.md`. (authored by @witiko, a2bbdea)

Continuous Integration:

- Make latexmk treat warnings as errors. (#228)

## 2.18.0 (2022-10-30)

Development:

- Accept snake\_case variants of options in addition to camelCase variants in
  `\markdownSetup` and Lua CLI. Accept snake\_case and caseless variants of
  options in `\setupmarkdown`. (#193, #194, #195, #196, #197, #198)
- Rename renderers, renderer prototypes and options based on the semantics of
  elements: (#187, #201)
  - Rename the `horizontalRule` and `footnote` renderers and renderer
    prototypes to `thematicBreak` and `note`.
  - Rename the `footnotes` and `inlineFootnotes` options to `notes` and
    `inlineNotes`.
  - Rename the `HorizontalRule` rule to `ThematicBreak` and increment
    `grammar_version` to `2`.
- Add `\markdownEscape` macro that inputs a TeX document in the middle of a
  markdown document fragment. (1478f7b)
- Add support for raw attributes. (#173, #202)

Fixes:

- Fix missing support for forward slashes in
  `\markdownSetup{jekyllDataRenderers = {...}}` keys. (#199, #200)
- Fix `plain` LaTeX option not preventing changes to renderer prototypes.
  (013abbb)

Continuous Integration:

- Check user manual with MarkdownLint. (#203)

Contributed Software:

- Update `contributions/pandoc-to-markdown`.
  (contributed by @drehak, 3d5b8e5, d3073bc)

Deprecation:

- Deprecate `horizontalRule` and `footnote` renderers and renderer prototypes.
  (#187, #201)

## 2.17.1 (2022-10-03)

Fixes:

- Add `debugExtensions` and `debugExtensionsFileName` Lua options for debugging
  user-defined syntax extensions. (#191, #192)
  - Add a third optional argument to the `reader->insert_pattern()` method and
    increment `user_extension_api_version` to `2`. This change is fully
    backwards-compatible with the `user_extension_api_version` of `1`.
    (658fbbe)
  - Fix typos in example code for user-defined syntax extensions.
    (7c6de52, d3195f7)

Documentation:

- Move `contentBlocksLanguageMap` option to the file and directory names
  section of the technical documentation. (dd564f2)

## 2.17.0 (2022-09-30)

Development:

- Add support for user-defined syntax extensions. (#182)

## 2.16.1 (2022-08-30)

Fixes:

- Fix default rendering of fancy lists in LaTeX. (#179, #180)
- Change category code of hash sign (`#`) to other in the
  `\markdownInput` command. (#181, d067ae8)

Deprecation:

- Use `make4ht` instead of `htlatex` in `examples/Makefile`. (#183)

Continuous Integration:

- Use all available CPU cores for unit tests. (#178)

## 2.16.0 (2022-08-26)

Development:

- Add support for strike-throughs, fenced divs, subscripts, superscripts,
  and fancy lists. (#149, #160, #162, #168, #170)
- Add facade in front of expl3 inferface for YAML metadata. (#118, #175)
- Add `\setupmarkdown` and `\inputmarkdown` commands to ConTeXt. (#17, #176)

Fixes:

- Make any ASCII character escapable as per
  [CommonMark](https://spec.commonmark.org/0.30/#backslash-escapes).
  (#163)
- Make our implementation of header attributes compatible with jgm/lunamark.
  (#164, #177)

Documentation:

- Add file `CHANGES.md` with the changelog of the Markdown package.
- Add badges for Matrix.org and Discord chat spaces. (2f1104d..acdc989)
- Add a link to @xvrabcov's TUG 2022 talk, slides, and example documents to the
  README. (d422f5c)

Proposals:

- Propose support for user-defined syntax extensions. (#172, #174)

Continuous Integration:

- Ignore changes to `**/README.md`. (e39a7aa)

## 2.15.4 (2022-07-29)

Fixes:

- In `parsers.specialchar`, only include special characters of enabled syntax
  extensions. (#150, #152)
- Avoid nesting `\markdownIfOption`. (#151)
- Make the `\markdownSetup` and `\markdownSetupSnippet` commands accept `\par`
  tokens. (#130)

Deprecation:

- Deprecate TeX Live 2019. (5c861e3)

Refactoring:

- Replace `xstring` with `l3str`. (contributed by @drehak, #96, #153)
- Replace `keyval` with `l3keys` (contributed by @drehak, #96, #155, #157)

Continuous Integration:

- Add Luacheck. (#154)

## 2.15.3 (2022-06-29)

Refactoring:

- Add a mechanism for extending the Markdown reader and the LaTeX writer.
  (#138, #143)
- Separate the Lua shell escape bridge into [the `lt3luabridge`
  package](https://github.com/witiko/lt3luabridge). (#140, #141)
- Add further reflection capabilities. (#124, #137)

Contributed Software:

- Update `contributions/book-templates`. (contributed by @xvrabcov, b4d892c,
  a6d5c77)

Deprecation:

- The `\markdownOptionHelperScriptFileName` command will be removed in Markdown
  3.0.0. (#141)
- The `\markdownOptionOutputTempFileName` command will be removed in Markdown
  3.0.0. (#141)
- The `\markdownOptionErrorTempFileName` command will be removed in Markdown
  3.0.0. (#141)
- The `\markdownMode` command will be removed in Markdown 3.0.0. (#141)

Docker:

- Remove `latest-with-cache` tag from Docker images. (04301f0)

Documentation:

- Remove disfunctional badges for Docker from `README.md`. (ad00b58, 707cad9)
- Link to TUG's version of the TUG 2021 video in `README.md`. (1462411)

Miscellaneous:

- As of today, Markdown has 234 stars, 56 forks, and 7 watchers on GitHub. 🥂

## 2.15.2 (2022-06-01)

Documentation:

- Document that no `eagerCache` makes recursive nesting undefined behavior.
  (a486b88)
- Fix typos in the documentation. (03a172a, ab3ad8d)

Contributed Software:

- Update `contributions/book-templates`. (contributed by @xvrabcov, 8c56288,
  78af2fd, b238dbc)
- Update `contributions/pandoc-to-markdown`. (contributed by @drehak, 7cc7edc,
  2e7ccfe)
- List @TeXhackse's [document templates](https://gitlab.com/l4070) in
  `contributions/README.md`.

Continuous Integration:

- Fix a typo in `Makefile` that made it impossible to recover from `pkgcheck`
  errors. (33c8c99)

## 2.15.1 (2022-05-18)

Fixes:

- Only let LaTeX's default link renderer prototype produce `\ref` for relative
  autolinks (discovered by @drehak, 7f3fd9b, #127)
- Ensure that `cacheDir` exists in `witiko/graphicx/http` LaTeX theme.
  (discovered by @drehak, 5145954, #128)

Documentation:

- Fix a typo in the documentation. (5e3b149)
- Add a link to a preprint from TUGboat 43(1) to the README. (authored by
  @witiko, @drehak, @michal-h21, and @xvrabcov, 7d47780, e9c7bfc)
- Only use the emoji package in TeX Live 2020 and later. (a46ffd2..a8e5838)

Contributed Software:

- Update `contributions/book-templates`. (contributed by @xvrabcov, 9f51cb4,
  8d6e5d6)
- Update `contributions/pandoc-to-markdown`. (contributed by @drehak, ac82a5f,
  102b1a5)
- Add contributions/doctoral-thesis. (a8fbd97)

Continuous Integration:

- Add TL2021-historic image to the continuous integration. (a9e3b08)

## 2.15.0 (2022-03-31)

Development:

- Add reflection to the TeX implementation. (#119, 73f699b..30ee46d, 02dd30a)
- Add an option to include arbitrary YAML documents. (#117, 78dc62b..93246a4)
- Move expl3 interface for YAML metadata from LaTeX to plain TeX.
  (1ec7931..95d83ba)
- Add LaTeX `\markdownIfSnippetExists` command. (929137a)
- Add code key to LaTeX `\markdownSetup` command. (ef53fae)

Contributed Software:

- Add a proof-of-concept of integration Markdown with Pandoc. (contributed by
  @drehak, #25, c40b51c)
- Add LaTeX themes for typesetting books and marketing colaterals. (contributed
  by @xvrabcov, #104, a7d6d2e)

Fixes:

- Use current theme name to resolve `\markdownSetup{snippet = ...}`. (0c79a80)

Documentation:

- Add directory `contributions/` with contributed third-party software.
  (contributed by @drehak and @xvrabcov, c40b51c..9296cf1)
- Fix formatting gaffes in the documentation. (97dee2f)
- Remove an extra backslash in the user manual. (994d06f)
- Move `<link>` element out of the technical documentation. (18b6241)

## 2.14.1 (2022-03-01)

Fixes:

- Fix default LaTeX renderer prototypes for block HTML comments. (b933d81)

## 2.14.0 (2022-02-28)

Fixes:

- Track nested LaTeX themes with a stack. (69478c0, 00c3e6a)

Development:

- Add renderers for inline HTML tags, block HTML elements, and block HTML
  comments. (#90, e5e28ed, 44affc3)
- Add renderers for heading attributes. (#87, #91, cad83f6)
- Add `relativeReferences` Lua option for writing relative autolinks such as
  `<#some-section>`. (#87, #91, e7267c0)

Documentation:

- Change category code of percent sign (`%`) before `\input`ting the output of
  `markdown-cli` in LaTeX and ConTeXt examples. (a61e371, 9635d76)

Quality of Life:

- Emit an error message when an undefined LaTeX setup snippet is invoked.
  (9d25074)
- Add a trailing newline to the output of `markdown-cli`. (80b7067)

Default Renderer Prototypes:

- Do not use image alt text to produce labels in renderer prototypes. (reported
  by @writersglen, 1c31c01)
- Pass HTML through to TeX4ht. (contributed by @michal-h21, #90, 2f5dcba)
- Be lazy about what commands to use for default LaTeX table rules.
  (contributed by @michal-h21, #90, 03a444a)

Continuous Integration:

- Retry failed `pkgcheck --urlcheck` in `Makefile`. (3c31baf)
- Always upload artifacts, even outside the `main` branch. (24feb6a)

## 2.13.0 (2022-01-30)

Fixes:

- Disable the parsing of timestamps in YAML metadata. (contributed by
  @TeXhackse, 75f6f20, 7d18b58, a27fdd9, #116)

Development:

- Add [markdown document
  renderers](https://witiko.github.io/markdown/#markdown-document-renderers).
  (2199c22, 4a70b04, #109)
- Add an example document for ConTeXt MkIV. (8bbb6ab, #17)

Default Renderer Prototypes:

- Redefine default LaTeX `codeSpan` renderer prototype to work in math mode.
  (35b53d3, e68a631)
- Support the unicode-math LaTeX package. (9d840be, #110)

Continuous Integration:

- Produce artefacts and GitHub pages only for the `latest` Docker tag.
  (976f074)
- Only push the latest Docker image once. (cc78fa1)
- Add `--urlcheck` option to the `pkgcheck` command in `Makefile`. (3b4d6a1,
  d9b2a01)

Docker:

- Show the size of the latest Docker image in the `README`. (1f680a8)

## 2.12.0 (2021-12-30)

Fixes:

- Add default definition for `\markdownRendererJekyllDataSequenceEnd`.
  (6c4abe3)

Development:

- Preserve trailing spaces in ConTeXt MkIV. (#101)
- Add `eagerCache` Lua option. (#102)
- Add `hardLineBreaks` Lua option. (#98)

Documentation:

- Document how we can set Lua options from plain TeX and both Lua options and
  plain TeX options from LaTeX (#105)
- Update link to TUGboat 42(2) article from preprint to archival version.
  (715f53c)
- Add two articles from the CSTUG Bulletin 2021/1-4 to the README. (76da1d6)
- Escape percent signs in code examples in techdoc (7d6ca54)

Default Renderer Prototypes:

- Make content blocks automatically `\input` TeX files. (c798106)

Docker:

- Build and publish Docker images for historical TeX Live versions. (#111)

## 2.11.0 (2021-10-01)

Fixes:

- Remove a spurious print when handling the `texComments` Lua option. (4ee94ec)
- Escape `escaped_minimal_strings` even in `hybrid` mode. (c1fd53b)
- Make assignments in `writer->set_state()` and `writer->defer_call()` local.
  (9261349)
- Don't let default LaTeX renderer prototype for `ulItem` gobble next token.
  (reported by @writersglen, 8d8023f)
- In LaTeX, prevent `\@ifundefined` from making `\markdownOptionTightLists`
  into `\relax`.
- Fix even backslashes before newline being gobbled by the `texComments` Lua
  option. (9ca0511)

Development:

- Add [`taskLists` Lua
  option](https://witiko.github.io/markdown#option-tasklists) for writing task
  lists. (suggested by @xvrabcov, #95)
- Add [`jekyllData` Lua
  option](https://witiko.github.io/markdown#option-jekylldata) for writing YAML
  metadata. (contributed by @TeXhackse, #22, #77)

Documentation:

- Add a link to @witiko's TUG 2021 talk, preprint, and slides to the README.
  (4b89f84, 6f61e48, 745a6f3, 99b1041, 872fb4d)
- Add a cornucopia of badges to the README. (60f7033, 8e9a34c)
- Use HTTPS links for CTAN in the README. (b068b65, a743b06)
- Use emoji in the technical documentation. (ccfcaf4)
- Add block and sequence diagrams to the technical documentation. (6168473,
  0b4bb91, 5fd2e19, 3b4af9c, 4e99cb9, cbccf36, a7f9a60, 48d5a21)
- Add index to the technical documentation. (3ee5a99, 32d93e8)
- Add a list of figures to the technical documentation. (48d5a21)
- Use varioref in the technical documentation. (2f8e85e)
- Describe Lua command-line interface (CLI) in the README. (ba27b51, 1ad85a2)
- Publish user manual to [GitHub Pages](https://witiko.github.io/markdown).
  (4a812a4, 4f1f349)
- Document that the `hybrid` option is `false` by default. (955d7c1)
- Show how
  [`tugboat.bib`](http://mirrors.ctan.org/info/digests/tugboat/biblio/tugboat.bib)
  can be used to cite the Markdown package.  (7e20eee)

Continuous Integration and Distribution:

- Rename `master` branch to `main`. (513de1f)
- Make `make implode` clean up auxiliary markdown files. (fe25ae9)
- Add `Dockerfile` and make continuous integration use Docker image. (#97,
  cbc0089, f64bfa5, 8a7b656, e185547, 1bb7075)
- Rebuild the Docker image every Monday at 4:30AM (UTC). (c9f87a9, 28b0e93)
- Automatically prerelease the latest version. (cd7fbd2)
- Use MarkdownLint in continuous integration. (2440659, aa1e14b)
- Test Lua command-line interface in continuous integration. (6a84f98, 4e28ef0)
- Matrix-test all supported TeX Live versions. (69b9edc)

## 2.10.1 (2021-08-31)

Fixes:

- Always enable `texComments` when `hybrid` is enabled. (715d025)
- Make the preprocessor of TeX comments surjective. (6021dd5)

## 2.10.0 (2021-08-07)

Fixes:

- String text and parenthetical citations. (e6026c1)
- Escape autolink labels even when hybrid mode is enabled. (repored by @iwelch,
  693e134)
- Protect LaTeX strong emphasis renderer prototype and make it detect font.
  (reported by @iwelch, 89a031a)
- Let users name their documents `markdown.tex`. (reported by @mmarras, cb50d4,
  9d21141)
- Support deferred content (footnotes, links, and images) with slicing.
  (edbdced)
- Support tables with slicing. (5a61511)
- Increment `markdownFrozenCacheCounter` globally. (c151cbc)
- Change the category code of the percent sign to other in `\markdownInput`.
  (b21fac4, 4d025e1, 5b1625f, 6f24307)
- Add `\startmodule` command to the ConTeXt module. (9f2ec1d)
- Add a missing `local` qualifier to the definition of a local variable.
  (1153afb)
- Don't allow LaTeX list item renderers to consume surrounding text. (reported
  by @nbubis, cb79225)

Development:

- Add the `theme` LaTeX option. (39ab6f3, 8699eb4, a1ae258, ea9c237, 3740742,
  67aaf40)
- Add the `stripIndent` Lua option. (b94dda5, 5757067, 654624c)
- Add the `texComments` Lua options. (c439a0f, 5f7c5e3, 744bcdb, 1ec06f4,
  b74fd01, 2dd76f1)
- Add support for LuaMetaTeX. (f004170, 905c832, 575a1e0, f93a353)
- Add the `inlineHtmlComment` renderer. (bf54b2f)
- Add the `plain` LaTeX package option. (af9c0d6)
- Add the `snippet` LaTeX option. (b43024f, 438f075, 2960810)

Debugging:

- Add helpful messages to read/write errors. (contributed by @drehak, d22cd25)
- Make ConTeXt/LaTeX use their info/warning/error commands during loading.
  (a638a91)

Documentation:

- Remove deprecated filecontents package from examples. (dd2dc1c)
- Fix a typo in the user manual. (13f056)
- Fix code style in the user manual. (416c24e)
- Update out-of-date-documentation. (713ec92)
- Add *Making Markdown into a Microwave Meal* article into the README.
  (4698224)
- Add a link to @witiko's PV212 talk to the README. (e5e8708)
- Fix overlong lines in the documentation. (34e9f4f)
- Update installation documentation. (b3957a8)
- Fix a typo in the documentation of `expandtabs`. (3e55507)
- Remove unnecessary `footnotes` option from the `inlineFootnotes` example.
  (30792ef)
- Fix a typo in the documentation of `\markdownRendererOlItemWithNumber`.
  (d05df9d)
- Fix errors in the documentation markup. (a6a0059)
- Remove multiply-defined refs in documentation. (ab99a30)

Licensing:

- Bump the copyright year. (9462f17)
- Sublicense the code as LPPL v1.3c. (609aeee)

Unit tests:

- Remove xtrace from `test.sh` for less verbose output. (b307ee6)
- Treat all files as text with GNU diff in `test.sh`. (ec89e6d)
- Print full TeX log when there is an error in a unit test. (7640c20)

Distribution:

- Add `banner.png` to the CTAN distribution. (fe107d6)
- Add base `Makefile` target. (41ab71a)

Continuous integration:

- Convert CircleCI configuration to GitHub Actions workflow. (0f77bc5)
- Add shellcheck. (27e825b)
- Upload artifacts in GitHub Actions workflows. (12e3585, e696d41)
- Install Graphviz in continuous integration. (3ebf0c9, 4ef340c)
- Test that the number of pages in typeset documentation is sane. (048b7fc)

Miscellanea:

- Use `\@ifdefined` and `\@onlypreamble` in LaTeX code. (40b77f4)

## 2.9.0 (2020-09-14)

Development:

- Add support for finalizing and freezing the cache.

Fixes:

- Fix default definition of `markdownRendererAmpersandPrototype`.
- Remove redundant `\label` in contentBlocks LaTeX renderer prototype.
- Make LaTeX and ConTeXt implementations also expand `\markdownEnd`.
- Fortify I/O in Lua with additional asserts.

Documentation:

- Fix links in the documentation.
- Fix typos in the documentation.
- Remove deprecated `filecontents` package.
- Do not use package `xcolor`.
- Add blank lines to `README.md`.
- Add Citing Markdown section to `README.md`.
- Add banner to `README.md`.
- Cite new CSTUG Bulletin article.

Continuous integration:

- Use TeX Live 2020.

Miscellanea:

- Update distribution packaging according to CTAN requirements.

## 2.8.2 (2020-03-20)

Fixes:

- Add example-image.png to the Git repository (closes issue #49).
- Require that text citations are not preceded by non-space characters.
- Add a line ending at the end of markdown file in case there is none.
- Do not assume `\markdownInput` input comes from `\markdownOptionOutputDir`
  (closes issue #57).

Documentation:

- Extend the abstract of the Markdown package.
- Document continuous integration and the Makefile.
- Properly highlight the syntax of shell commands in user manual.
- Add CSTUG bulletin articles to the README.

Miscellanea:

- Upgrade continuous integration from TeX Live 2019 to TeX Live 2020 pretest.

## 2.8.1 (2019-04-30)

Fixes:

- Correctly produce the user manual for [CTAN](https://ctan.org/).
- Complete the support for named HTML entities (closes issue #36).

Documentation:

- Document the precise behavior of the `preserveTabs` Lua option (closes issue
  #38).
- Acknowledge [Lian Tze Lim](http://liantze.penguinattack.org/) and
  [Overleaf](https://www.overleaf.com/) in the README.
- Link TUGboat journal articles from the README.
- Link the Markdown package installation from the README.

Miscellanea:

- Upgrade continuous integration from TeX Live 2019 pretest to TeX Live 2019.

## 2.8.0 (2019-04-27)

Development:

- Added the `pipeTables` Lua option that enables [the PHP Markdown table syntax
  extension](https://michelf.ca/projects/php-markdown/extra/#table), the
  `tableCaptions` Lua option that enables [the Pandoc `table_captions` syntax
  extension](https://pandoc.org/MANUAL.html#extension-table_captions), and the
  `table` token renderer. Thanks to [David Vins](https://github.com/dvins) and
  [Omedym](https://www.omedym.com) for sponsoring the development of table
  support.
- Added the `shiftHeadings` Lua option for shifting section levels, which
  extends the *content slicing* capabilities of the Markdown package. Thanks to
  [David Vins](https://github.com/dvins) and [Omedym](https://www.omedym.com)
  for sponsoring the development of content slicing.

Documentation:

- Update README links to Markdown examples and tutorials by [Lian Tze
  Lim](http://liantze.penguinattack.org/) and
  [Overleaf](https://www.overleaf.com/).

Fixes:

- Remove an unreachable branch of the `parsers.line` parser.

## 2.7.0 (2019-04-05)

Development:

- Added Natbib citation renderer to LaTeX.
- Added the `slice` Lua option for *content slicing* – typesetting only certain
  parts of a markdown document.
  Thanks to [David Vins](https://github.com/dvins) and
  [Omedym](https://www.omedym.com) for sponsoring the development of
  content slicing.

Fixes:

- Stopped using the possibly active ASCII double quote characters (`"`) after
  the `\input` TeX command.
- Added space before the second parameter in the basic LaTeX citation renderer.
- Fixed the `outputDir` Lua option, which enables the use of the
  `-output-directory` TeX option.
- Added support for Lua 5.3, which has been part of LuaTeX since 1.08.
- Fixed the non-terminating LaTeX citation renderers for BibTeX and Natbib.
- Fixed the capability of the unit testing script to add expected outcome to
  unfinished testfiles.

Documentation:

- Finished the user manual.
- Removed spurious commas in the documentation.
- Used CTAN-compatible markdown markup in the README.

Miscellaneous:

- Made the unit testing script write Lua stack trace to the terminal when a
  test fails.

## 2.6.0 (2018-04-09)

*Except for some minor changes in the README document, this version is
identical to version 2.5.6. The author realized that they had forgotten to
increase the minor version number despite adding a significant amount of new
functionality.*

## 2.5.6 (2018-04-08)

Development:

- Added a Lua command-line interface.
- Added the `stripPercentSign` Lua option for using markdown in TeX package
  documentation.

Fixes:

- Fixed TeX Live 2013 minted package detection.
- Fixed the default LaTeX hyperlink renderer prototype to correctly typeset
  hash signs.
- Fixed lonely level four and five headings not being rendered in LaTeX.
- Removed the no-op `outputDir` Lua option.

Documentation:

- Added a user manual.
- Added information for contributors to the README document.
- Increased portability of the technical documentation by using a built-in
  BibLaTeX style.
- Rewrote the technical documentation in markdown using the new
  `stripPercentSign` Lua option.

Miscellaneous:

- Tuned the continuous integration service configuration, so that tests run
  under 15 minutes.

## 2.5.5 (2018-01-08)

Documentation:

- Fixed a typo in section 2.2.1.
- Documented that the `contentBlocksCode` renderer receives five arguments.
- Updated information in the documentation bibliography.
- Incremented the year in copyright notices.

## 2.5.4 (2017-09-12)

Fixes:

- `\markdownInfo` writes only to the log in the plain TeX implementation.
- `\markdownInfo` and `\markdownWarning` start a new line in the plain TeX
  implementation.
- Lua errors are now caught even with shell escape.

Development:

- Added an `outputDir` option that enables the use of the TeX
  `-output-directory` option.

## 2.5.3 (2017-05-07)

Fixes:

- Added a missing file `examples/scientists.csv` to the CTAN archive.

Documentation:

- Added examples into the TDS archive.
- Replaced tux in the examples with a generic example image.

Development:

- Updated the code for initializing testfiles.

## 2.5.2 (2017-04-28)

Fixes:

- Added proper support for trailing internal punctuation in citations.

## 2.5.1 (2017-04-27)

Fixes:

- Tab-indented fenced code is now supported.
- Added missing underscore to `parsers.internal_punctuation`.
- Removed unnecessary internal punctuation escaping (`$&~`) in citations.

Documentation:

- Corrected typo in bibliography.

## 2.5.0 (2017-04-10)

New features:

- Added the `codeSpans` and `underscores` options.

Documentation:

- Reordered options alphabetically.

## 2.4.0 (2017-03-27)

Fixes:

- Fixed the number of arguments in the `\markdownError` dummy definition.

New features:

- Added [the iA Writer content blocks syntax
  extension](https://github.com/Witiko/markdown/issues/4).

Documentation:

- Fixed errors in the Lua interface documentation.
- Fixed a typo in the `tests/templates` directory documentation.

Development:

- Added parallelized unit testing.

## 2.3.0 (2017-01-05)

Fixes:

- ConTeXt module no longer mishandles active characters from `\enableregime`.
- Shell access is no longer necessary with ConTeXt MarkIV.
- The default renderers now render strong emphasis using a bold font face
  rather than a bold-italic font face.
- Lazy blockquotes are now parsed properly.

New features:

- Added optional HTML support; when the support is enabled, the Markdown reader
  will recognize HTML elements, entities, instructions, and comments in the
  input.
- Added optional breakable blockquotes support; when the support is enabled,
  blockquotes can be split apart using blank lines.

Documentation:

- Documented the behavior of the `-output-directory` TeX option.

Development:

- Removed unnecessary PEG patterns.
- PEG patterns are now hash table entries rather than local variables; this was
  a necessary step due to the local variable number limit. This change was also
  backported to and merged by the
  [upstream project](https://github.com/jgm/lunamark).
- The unit test templates now use M4 instead of ad-hoc sed string replacement.
- The Lua text buffering routine was removed as it only introduced complexity
  to the package with no tangible benefits. All text buffering is now done in
  TeX. As a corrolary, the `\markdownLuaRegisterIBCallback` and
  `\markdownLuaUnregisterIBCallback` macros have been deprecated.

## 2.2.2 (2016-12-09)

Fixes:

- Inline footnotes can now be enabled via the LaTeX interface.

Development:

- Added inline footnotes to the example documents.

## 2.2.1 (2016-12-07)

New features:

- Added Pandoc-style inline footnotes.

## 2.1.3 (2016-09-15)

Fixes:

- LaTeX implementation doesn't load `paralist` in `beamer` unless requested.

## 2.1.2 (2016-09-14)

Fixes:

- Unordered list items now may begin with a `bulletchar`.

Documentation:

- Expanded the documentation on `hashEnumerators`.

## 2.1.1 (2016-09-06)

Fixes:

- The citations extension should now be fully compliant with the
  [Pandoc spec](http://pandoc.org/MANUAL.html#citations).
- The `citationNbsps` option now also affects newlines, as is expected.
- The default `\markdownOptionCacheDir` explicitly specifies the current
  working directory, so that the cache files are not sought in the TeX
  directory structure.

Documentation:

- Added information about the supported LuaTeX versions.
- Added information about the portable use of the package.

Development:

- All the syntax extensions (fenced code blocks and citations) were merged by
  the [upstream project](http://github.com/jgm/lunamark).

## 2.1.0 (2016-08-29)

New features:

- Added Pandoc-style citations and CommonMark fenced code blocks syntax
  extensions.
- Added the following renderers:
  - `interblockSeparator`,
  - `ulItemEnd`, `olItemEnd`, `dlItemEnd`,
  - `nbsp`, `cite`, `textCite`, and
  - `inputFencedCode`.
- Added the following Lua options:
  - `citations`, `citationNbsps`,
  - `fencedCode`, and `blankBeforeCodeFence`.

Changes in behavior:

- Replaced the `-` character in the default `\markdownOptionCacheDir` with `_`.
- The cache filenames are now different based on the version of the package.
- Code spans may now be empty.

Fixes:

- The conversion from Markdown should now produce consistent behavior no matter
  if the input of the conversion function ends with `\n\n`, `\n`, or nothing.
- LaTeX interface `rendererPrototypes` keys for the `pipe`, `link`, and `image`
  renderers no longer incorrectly set the `\markdownRenderers<Renderer>` macros
  rather than the  `\markdownRenderers<Renderer>Prototype` macros.

## 2.0.2 (2016-08-17)

Fixes:

- Fixed nested `keyval` handling inside `\markdownSetup` et al.

## 2.0.1 (2016-08-15)

Fixes:

- Make the programming more defensive, so that the package works correctly
  under TeXLive 2012.

Development:

- Added the package to a continuous integration service.

## 2.0.0 (2016-08-15)

New features:

- Added raw unescaped URI to the `link` and `image` renderer arguments.
  (This breaks backwards compatibility, hence the major version number bump.)
- Added renderers for plain TeX and ConteXt special characters.

Fixes:

- Make autolinks work by preventing `Str` from consuming `<`.
- Non-found footnote ref no longer outputs unescaped text.
- Catcode of `|` is now other in `\markdownReadAndConvert` for ConTeXt.
- Restore escapability of `<`, `>` to enable escaping of autolinks.

Development:

- Added a suite of tests.

## 1.0.1 (2016-06-06)

New features:

- Added the `tightLists` Lua interface option.

## 1.0.0 (2016-06-04)

The first release.
