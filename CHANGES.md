# Changes

## 3.XX.X (2025-07-XX)

Fixes:

- Correctly regenerate ConTeXT databases in `Dockerfile`. (reported by @witiko
  in gucci-on-fleek/context-packaging#2 and #575, fixed by @witiko and
  @gucci-on-fleek in gucci-on-fleek/context-packaging@0459634,
  gucci-on-fleek/context-packaging@f8ee60e, d4c0054, 6fbd4dc, ccf580b, 850bef8,
  and 53a3335)

Defaults:

- In LaTeX, load enumitem instead of paralist when the user has expressed an
  intent to use new tag-friendly code by writing `\DocumentMetadata`.
  (reported by @witiko in #578, fixed by @witiko and @u-fischer in #579)

Continuous integration:

- Rename GitHub Action `teatimeguest/setup-texlive-action@v3` to `TeX-Live/...`.
  (reported by @pablogonz in #576, fixed by @witiko in 28ba10b5)

- Use current pkgcheck. (reported by @manfredlotz via email and by @witiko
  in #580, fixed in #581)

## 3.11.4 (2025-06-24)

Documentation:

- Document the current limitations of the MikTeX distribution and TeX engines
  other than LuaTeX. (reported by @obskyr in #566 and by @viocha in #573,
  escalated upstream by @witiko in [miktex/miktex#1630][miktex-1630],
  documented by @witiko in #574 and [witiko/lt3luabridge#32][lt3luabridge-32])

  These are the current limitations:
  1. The filenames of your .tex files may not contain spaces, see also #573.
  2. If `-output-directory` is provided, it may not contain spaces and it won't be
     automatically detected by MikTeX, see also [miktex/miktex#1630][miktex-1630].

Housekeeping:

- Mark uses of the deprecated conditional functions `\regex_match:*` for
  removal after we have dropped support for TeX Live 2024 and earlier.
  (8cd8bb5f)

Deprecation:

- Undeprecate `\markdownOptionOutputDir`.
  (#566, [miktex/miktex#1630][miktex-1630], #574)

  Due to the lack of support for the automatic detection of `-output-directory`
  in MikTeX with TeX engines other than LuaTeX (see
  [miktex/miktex#1630][miktex-1630]), there are still genuine uses of this
  option. Therefore, it doesn't make sense to deprecate it.

 [miktex-1630]: https://github.com/MiKTeX/miktex/issues/1630
 [lt3luabridge-32]: https://github.com/Witiko/lt3luabridge/pull/32

## 3.11.3 (2025-05-28)

Fixes:

- Support .tex files with spaces in the filename.
  (reported by @obskyr in #568, fixed by @witiko in #571)

- Use `status.output_directory` to determine option `outputDir` on MikTeX.
  (reported by @obskyr in #566, fixed by @gucci-on-fleek, @cfr42, and @witiko
  on [TeX StackExchange][tse-742209] and in #571)

 [tse-742209]: https://tex.stackexchange.com/questions/742209/

Continuous integration:

- Switch to the GitHub Action `softprops/action-gh-release` for automatic
  pre-releases. (contributed by @muzimuzhi in expltools#82, 58698ad1)

## 3.11.2 (2025-04-28)

Fixes:

- Fix style issues identified by explcheck's semantic analysis.
  (expltools#75, #562, #564)

- Make `\markdownInput` handle file names with spaces correctly.
  (reported by @u-fischer in #563, fixed by @witiko in #565)

## 3.11.1 (2025-03-30)

Development:

- In theme `witiko/diagrams`, add parameter `format` for PlantUML diagrams.
  (reported by @mrkissinger in #555, fixed by @witiko in 7d58f3d8 and 64c78f17)

  Here is an example LaTeX document using the new parameter:

  ```` tex
  \documentclass{article}
  \usepackage[import=witiko/diagrams@v2, relativeReferences]{markdown}
  \begin{document}
  \begin{markdown}
  ``` plantuml {caption="An example UML sequence diagram" format=eps width=7cm #plantuml}
  @startmindmap
  + SIR
  ++ 指標引擎
  @endmindmap
  ```

  See the diagram in Figure <#plantuml>.
  \end{markdown}
  \end{document}
  ````

Documentation:

- Add preprint and artwork for an upcoming TUGboat article titled _Piping YAML
  files into LaTeX3 key–values_. (c684ce2e, 2214706b, 52ccb7a1, 85e96805)

Docker:

- Start building Docker images `witiko/markdown:TL2024-historic`. (bcae00a6)
- Switch Docker images `witiko/markdown:latest` from TeX Live 2024 to 2025. (bcae00a6)

## 3.11.0 (2025-02-21)

Development:

- Remove dependency on Selene Unicode and add preliminary support for LuaMetaTeX
  and ConTeXt standalone. (originally reported by @andreiborisov in #402 and #436,
  and by @witiko in latex3#1518 and [dev-context@ntg.nl][dev-context-msg03280];
  fixed in #551..#553 by @witiko and @lostenderman, and in latex3#1670
  and latex3#1671 by @hanshagen, @josephwright, @Skillmon, and @muzimuzhi)

 [dev-context-msg03280]: https://www.mail-archive.com/dev-context@ntg.nl/msg03280.html

Fixes:

- Prevent left-flanking and right-flanking delimiter runs followed by
  multi-byte whitespace or punctuation characters. (fixed in #552 and #553
  by @witiko and @lostenderman)

Documentation:

- Add a man page for `markdown2tex`. (suggested by @karlberry in #547; added by
  @witiko in #554..#556)

Docker:

- Install the current package `tinyyaml` in historical TeX Live Docker images.
  (added by @witiko in 18cb17f2 and bfb6dfbc, many thanks to @zepinglee for
  keeping the CTAN package up-to-date)

Tests:

- Test that nested numbers are correctly parsed by package `tinyyaml` in YAML
  metadata. (added by @witiko in #218 and istqb_product_base#172)

## 3.10.0 (2025-01-27)

Development:

- Add a built-in theme `witiko/diagrams@v2` for drawing different types of
  diagrams. (#448, #514, #531, #542, [matrix.org][matrix-542], a9cadc41,
  578e64d6, 22efe7f4, a3c2d93b, originally suggested by @anubane)

   [matrix-542]: https://matrix.to/#/!UeAwznpYwwsinVTetR:matrix.org/$CpfhKJT8DAkzH7Rx6ynV1BKFKbfMUtxkpNzqftvLGec?via=matrix.org&via=im.f3l.de

  Here is an example LaTeX document using the new theme:

  ```` tex
  \documentclass{article}
  \usepackage[import=witiko/diagrams@v2, relativeReferences]{markdown}
  \begin{document}
  \begin{markdown}
  ``` dot {caption="An example directed graph" width=12cm #dot}
  digraph tree {
    margin = 0;
    rankdir = "LR";

    latex -> pmml;
    latex -> cmml;
    pmml -> slt;
    cmml -> opt;
    cmml -> prefix;
    cmml -> infix;
    pmml -> mterms [style=dashed];
    cmml -> mterms;

    latex [label = "LaTeX"];
    pmml [label = "Presentation MathML"];
    cmml [label = "Content MathML"];
    slt [label = "Symbol Layout Tree"];
    opt [label = "Operator Tree"];
    prefix [label = "Prefix"];
    infix [label = "Infix"];
    mterms [label = "M-Terms"];
  }
  ```

  ``` mermaid {caption="An example mindmap" width=9cm #mermaid}
  mindmap
      root )base-idea(
          sub<br/>idea 1
              ((?))
          sub<br/>idea 2
              ((?))
          sub<br/>idea 3
              ((?))
          sub<br/>idea 4
              ((?))
  ```

  ``` plantuml {caption="An example UML sequence diagram" width=7cm #plantuml}
  @startuml
  ' Define participants (actors)
  participant "Client" as C
  participant "Server" as S
  participant "Database" as DB

  ' Diagram title
  title Simple Request-Response Flow

  ' Messages
  C -> S: Send Request
  note over S: Process request

  alt Request is valid
      S -> DB: Query Data
      DB -> S: Return Data
      S -> C: Respond with Data
  else Request is invalid
      S -> C: Return Error
  end
  @enduml
  ```

  See the diagrams in figures <#dot>, <#mermaid>, and <#plantuml>.
  \end{markdown}
  \end{document}
  ````````

  You may use the expl3 prop `\g_markdown_diagrams_infostrings_prop` to
  register other types of diagrams.

- Add option `jekyllDataKeyValue` for routing YAML metadata to expl3 key–values.
  (#77, #517, [matrix.org][matrix-517], #539, [matrix.org][matrix-539],
   f57a8c45, originally suggested by @TeXhackse)

  While the primary intended users of this new option are package authors,
  writers can also use this feature to configure various (La)TeX packages
  from YAML:

  ``` tex
  \documentclass{article}
  \usepackage{chemformula, lua-widow-control, phonenumbers}
  \usepackage[raw_attribute, tex_math_dollars]{markdown}
  \begin{document}
  \begin{markdown}[jekyll_data, jekyll_data_key_value]

  ---
  chemformula:
    decimal-marker: $\cdot$
  lua-widow-control:
    draft: true
    showcolours: true
  phonenumbers:
    area-code: place
    area-code-sep: space
    country: UK
  ---

  Phone number: `\phonenumber{02079460345}`{=tex}

  Chemical reaction: `\ch{A + B -> 3.14159}`{=tex}

  \end{markdown}
  \end{document}
  ```

  This won't work for every package but many packages use expl3 key–values
  internally for their configuration. If you are curious if your favorite
  package does, look for `\keys_define` in its source code.

  For more examples, see #517.

 [matrix-517]: https://matrix.to/#/!UeAwznpYwwsinVTetR:matrix.org/$WzqBd_p3KB766wqbFBLbn3o9DmBJCJfPAOsC5w--gW4?via=matrix.org&via=im.f3l.de
 [matrix-539]: https://matrix.to/#/!UeAwznpYwwsinVTetR:matrix.org/$VZbdWB2EpHeg290MGsYsbUEwMoN68zT8tbIRUKRJ1wc?via=matrix.org&via=im.f3l.de

Fixes:

- Allow using the options `linkAttributes` and `notes` together. (#543, #544)


Distribution:

- Alias the command `markdown-cli` as `markdown2tex`.
  (#545, #546, [tex-live@tug.org][tex-live-2025-01-051051])

 [tex-live-2025-01-051051]: https://tug.org/pipermail/tex-live/2025-January/051051.html

Docker:

- Produce Docker image `witiko/markdown:latest-minimal` with a minimum
  installation of the Markdown package for TeX based on the Docker image
  `texlive/texlive:latest-minimal`. (61a3aa2b)

## 3.9.1 (2024-12-17)

Development:

- Add version `v1` of the new built-in theme `witiko/diagrams`.
  (#514, #531, #538)

  This version is an alias for an earlier theme named `witiko/dot`. Future
  versions of the theme may have backwards-incompatible syntax and behavior,
  see the discussion in #514 and #531. Therefore, you are encouraged to always
  specify the version `v1` to keep your documents from suddenly breaking. The
  Markdown package will warn you if you don't.

Fixes:

- Make option `eagerCache` safe to use with plain LuaTeX.
  (#530, witiko/lt3luabridge#29)

Documentation:

- Add artwork by <https://www.quickcartoons.com/> to directory `artwork/`. (#533)

  You are welcome to use these artworks in your promotional materials, provided
  you comply with the license terms specified for each piece. Typically, proper
  attribution to the artist is required.

Defaults:

- In LaTeX, fix bad interaction between heading identifiers and the class name
  `{.unnumbered}` (also written as `{-}`). (#511, 3d2e81d4, reported by @jurf)

Continuous Integration:

- Use explcheck to check expl3 code in the continuous integration.
  (#535, #536, b4e3bfcd)

Deprecation:

- Soft-deprecate the name of the built-in theme `witiko/dot` in favor of
  the new built-in theme `witiko/diagrams@v1`. (#514, #531, #538)

Distribution:

- Make `markdown-cli` executable and symlink it to system directories.
  (#534, #537, [tex-live@tug.org][tex-live-2024-12-050952])

 [tex-live-2024-12-050952]: https://tug.org/pipermail/tex-live/2024-December/050952.html

Tests:

- Reenable `eagerCache` in tests for plain LuaTeX. (#530, witiko/lt3luabridge#29)

Docker:

- Install the current package lt3luabridge in `Dockerfile`. (#530)

## 3.9.0 (2024-11-21)

Development:

- Convert built-in LaTeX themes `witiko/dot` and `witiko/graphicx/http` into
  plain TeX themes. (#514, #522, #529)

  This allows these themes to be used in formats such as plain TeX and ConTeXt
  as well.

Refactoring:

- Remove dependencies on `ifthen`, `gobble`, and `catchfile`. (#514, #522, #529)

- Store small built-in LaTeX themes `witiko/dot`, `witiko/graphicx/http`, and
  `witiko/tilde` in expl3 props in files `markdown.tex` and `markdown.sty`.
  (#514, #522, #529)

  This simplifies the distribution and installation of these themes, which were
  previously located in individual `.tex` and `.sty` files.

  The built-in plain TeX, LaTeX, and ConTeXt themes `witiko/markdown/defaults`
  are still distributed in individual files. This is because inlining these
  themes in files `markdown.tex`, `markdown.sty`, and `t-markdown.tex` would
  make it more difficult for users to copy and modify these themes without
  delaying updates to the Markdown package itself. Furthermore, these themes
  are large and storing/executing them from an expl3 prop would make it more
  difficult to determine the line numbers when errors occur.

Fixes:

- Protect renderers and renderer prototypes. (#465, #506)

  After this change, default renderers and renderer prototypes as well
  as renderers and renderers and prototypes defined using the keys
  `renderers` and `rendererPrototypes` of the command `\markdownSetup`
  are protected, which is usually preferable for typesetting.

  New keys `unprotectedRenderers` and `unprotectedRendererPrototypes`
  were also added to the command `\markdownSetup`. These keys define
  unprotected renderers and renderer prototypes, respectively, which are easier
  to expand and may be preferable for programming.

Defaults:

- Define default LaTeX renderer prototypes for table identifiers.
  (#525, suggested by @machitgarha, #528)

  This establishes a reliable method for authors to reference tables within
  Markdown:

  ``` tex
  \documentclass{article}
  \usepackage[
    pipe_tables,
    table_attributes,
    table_captions,
    relative_references,
  ]{markdown}
  \begin{document}
  \begin{markdown}

  | Right | *Left* |   Default   | Center |
  |------:|:-------|-------------|:------:|
  |   12  |   12   |      12     |    12  |
  |  123  |   123  |   **123**   |   123  |
  |    1  |     1  |       1     |     1  |

    : Demonstration of *pipe table* syntax with the caption spreading over
      multiple lines. {#identifier .class-name key=value}

  Demonstration of a *relative reference*: See Table <#identifier>.

  \end{markdown}
  \end{document}
  ```

- Define default LaTeX renderer prototypes for bracketed spans.
  (discussed with @MacLotsen at TUG 2024 and with @TeXhackse at matrix.org, #528)

  This establishes a reliable method for authors to reference the last LaTeX
  counter that has been incremented in e.g. ordered lists.

  ``` tex
  \documentclass{article}
  \usepackage[
    bracketed_spans,
    relative_references,
    start_number = false,
  ]{markdown}
  \begin{document}
  \begin{markdown}

  Demonstration of *bracketed spans* syntax:

   1. First item
   2. [Second item]{#second-item}
   3. Third item

  Demonstration of a *relative reference*: See item <#second-item>.

  \end{markdown}
  \end{document}
  ```

- Use package LuaXML in default LaTeX renderer prototypes for content blocks,
  raw blocks, and inline raw spans. (#469, #532, co-authored by @michal-h21)

  This allows authors to render HTML fragments in their LaTeX documents:

  `````` tex
  \documentclass{article}
  \usepackage[content_blocks, raw_attribute]{markdown}
  \begin{filecontents}[overwrite, nosearch, noheader]{example_input.html}
  <b>foo</b> <i>bar</i>
  \end{filecontents}
  \begin{document}
  \begin{markdown}

  Raw text span: `<b>foo</b> <i>bar</i>`{=html}

  Raw code block:

  ``` {=html}
  <b>foo</b> <i>bar</i>
  ```

  Content block:

   /example_input.html

  \end{markdown}
  \end{document}
  ``````

Deprecation:

- Remove support for TeX Live 2022. (da85e015, 8f2d25c7)

  This change also removes the Lua module `markdown-tinyyaml`, which has been
  scheduled for removal ever since the Lua module `tinyyaml` was uploaded to
  CTAN in TeX Live 2023.

## 3.8.1 (2024-11-03)

Fixes:

- Fix backslashes at the ends of hybrid documents.
  (#502, #503, contributed by @lostenderman)

- Fix hard line breaks in fancy list items.
  (#508, #509, contributed by @lostenderman)

## 3.8.0 (2024-10-31)

Development:

- Add support for versioned themes and add new Lua option `experimental`.
  (#466, #512, #514, [matrix.org][matrix-514] reviewed by @TeXhackse, #521)

  The option `experimental` enables experimental features that are planned to
  be the new default in the next major release of the Markdown package.

  At the moment, this just means that the version `experimental` of the theme
  `witiko/markdown/defaults` will be loaded and warnings for hard-deprecated
  features will become errors. However, the effects may extend to other areas
  in the future as well.

 [matrix-514]: https://matrix.to/#/!UeAwznpYwwsinVTetR:matrix.org/$TTc-m7B5NSdsLBNNyIuFWQ-u2nOZ03lJ5js88hnyFiU?via=matrix.org&via=im.f3l.de

- Add first-class support for YAML documents. (#452, #473, #524)
  - Add plain TeX macros `\yamlSetup`, `\yamlInput`, `\yamlBegin`, and `\yamlEnd`.
  - Add LaTeX environment `yaml` and redefine command `\yamlInput` for LaTeX.
  - Add ConTeXt commands `\setupyaml`, `\inputyaml`, `\startyaml`, and `\stopyaml`.

Documentation:

- Document LaTeX hooks. (#464, #507)

Defaults:

- Improve the compatibility of the default LaTeX packages with PDF tagging:
  (#466, #512, #514, #521, reported and consulted by @u-fischer)

  - In TeX engines other than LuaTeX, use the package soul instead of the
    package soulutf8 in TeX Live ≥ 2023.

  - In LuaLaTeX, use the package lua-ul for strike-through/mark renderer
    prototypes instead of the package soul.

  - Use the package enumitem for tight and fancy lists instead of the package
    paralist.

    This is a breaking change that is marked as experimental. To enable it,
    either use the package option `experimental` or specify any test phase in
    the document metadata:

    1. `\usepackage[experimental]{markdown}`
    2. `\DocumentMetadata{testphase=phase-III}`

- Define LaTeX renderers for image identifiers.
  (#520, suggested by @jurf, 6f3dcd0c, 478530f, [matrix.org][matrix-520])

  This establishes a reliable method for authors to reference figures within
  Markdown:

  ``` tex
  \documentclass{article}
  \usepackage[link_attributes, relative_references]{markdown}
  \begin{document}
  \begin{markdown}

  ![example image](example-image "An example image"){#example-image-id}

  See Figure <#example-image-id>.

  \end{markdown}
  \end{document}
  ```

- Set correct category codes for version 3 of the package minted. (39980934)

Continuous Integration:

- Only use self-hosted runners for the quick CI in pull requests.
  For full CI outside pull requests, use GitHub-hosted runners.
  (c2697428, [matrix.org][matrix-950e8269])

 [matrix-950e8269]: https://matrix.to/#/!pznomuvubVyxElflTe:matrix.org/$op_onsRdhtXJsZB5d5LZrOFF75T02XvKehmikdoucx4?via=matrix.org&via=im.f3l.de
 [matrix-520]: https://matrix.to/#/!lWGKeMcpgwGHpfLYkf:matrix.org/$mZB-_YfreLFSKU5eDzp0AIvMnsV_Bn-rpUoj9HtUVwk?via=matrix.org&via=im.f3l.de

## 3.7.1 (2024-09-30)

Development:

- Remove dependency on `UnicodeData.txt`. (#400, #458 #486, #492, #499)

  This change improves the speed of parsing markdown input by up to 25%
  for a cold conversion run and makes life easier for users of TeX
  distributions other than TeX Live, such as MikTeX and ConTeXt Standalone,
  where `UnicodeData.txt` may not be as easily available. This change also
  adds a new file `markdown-unicode-data.lua`, which must be properly
  installed with the rest of the Markdown package.

- Add renderers `warning` and `error` that represent warnings and errors
  produced by the markdown parser. (#452, #473, #496)

Fixes:

- Properly load LaTeX themes when `theme` or `import` is used in
  `\usepackage[...]{markdown}`. (#471, #498)

- Prevent endless loop when setting deprecated `jekyllDataString` renderer
  (prototype). (#500)

- Correctly handle backslashes in `\markdownOptionOutputDir` on Windows.
  (#492, #500, reported by @l0th3r)

- Fix hard line breaks in blockquotes.
  (#494, #495, reported by @l0th3r, #496, contributed by @lostenderman)

Deprecation:

- Soft-deprecate the `hybrid` option. (#470, #504, 546faa87)

  Soft-deprecated features will never be removed but using them prints a
  warning and is discouraged. Instead of the `hybrid` option, consider one of
  the following better alternatives for mixing TeX and markdown:

  - With the `contentBlocks` option, authors can move large blocks of TeX
    code to separate files and include them in their markdown documents as
    external resources.

  - With the `rawAttribute` option, authors can denote raw text spans and
    code blocks that will be interpreted as TeX code.

  - With options `texMathDollars`, `texMathSingleBackslash`, and
    `texMathDoubleBackslash`, authors can freely type TeX commands between
    dollar signs or backslash-escaped brackets.

  For more information, see the user manual at
  <https://witiko.github.io/markdown/>.

## 3.7.0 (2024-08-30)

Development:

- Add renderer `jekyllDataProgrammaticString` for processing YAML
  string scalars that do not contain markdown markup and are not
  intended for typesetting.
  (istqborg/istqb_product_base#46, #440, #451, sponsored by @istqborg)
- Add option `ensureJekyllData` for processing standalone YAML files.
  (#452, #473, sponsored by @istqborg)
- Support user-defined LaTeX environments with LaTeX markup.
  (#20, #477, suggested by @cdupont)

Fixes:

- Produce more meaningful error message when KPathSea fails to
  locate a file. (#458, #472, 33e6eef2, reported by @Yggdrasil128)
- Fix soft line breaks in citation prenotes and postnotes.
  (#483, #484, contributed by @lostenderman)

Speed improvements:

- Precompile snippets to improve the speed of setting them.
  (#467, #479, inspired by the TUG 2024 talk by @josephwright)
- Use an optimized parser to determine Unicode punctuation.
  (#458, #474, #482, 4c1a7de2, co-authored by @Yggdrasil128,
   sponsored by @istqborg)
  This improves the speed of parsing markdown input by up to 500%.
- Enable option `eagerCache` by default. (#468, #490, sponsored by @istqborg)
  This improves the speed by up to 25% for large documents with many
  markdown fragments that require multiple compilation runs.
- Prevent loading the full Markdown package when converting cached markdown
  fragments. (#487, #491, 40f0803f, 6609d43d, sponsored by @istqborg)
  This significantly improves the speed for large documents with many
  markdown fragments that require multiple compilation runs in pdfTeX.

Deprecation:

- Deprecate `jekyllDataString` renderer and renderer prototype.
  (istqborg/istqb_product_base#46, #440, #451, sponsored by @istqborg)
  Users should use `jekyllDataTypographicString` instead.

Continuous Integration:

- Ensure that all code lines are shorter than 72 characters.
  (#478, e7160d60, 3ac95efe)

Experiments:

- Measure the speed of the Markdown package across recent versions.
  (249552e5, 55ede824, efeaecbe, #474, 7b2b2431, fcf0064c)

## 3.6.2 (2024-07-14)

Fixes:

- Fix the interplay between inline notes and square brackets.
  (#453, #456, reported by @nopria, contributed by @lostenderman)
- Fix the interplay between lists and citations.
  (witiko/expltools#3, #460, #461, contributed by @lostenderman)
- Do not override the `outputDir` option if if has been defined
  before loading the package and pass it to lt3luabridge library.
  (#457, #459)

Documentation:

- Fix various typos. (#454, contributed by @mbertucci47)
- Add file `DEPENDS.txt`. (#462, #463, 93bb7e18)

Continuous Integration:

- Only test latest TeX Live in pull requests. (81927ca1)

Tests:

- Test the `outputDir` plain TeX option. (#457, #459)

Libraries:

- Update `tinyyaml` to v0.4.4-1-g197632c. (1e83ac94)

## 3.6.1 (2024-06-20)

Fixes:

- Fix the interplay between (strong) emphasis and (inline) notes.
  (#447, #450, lostenderman/markdown#159, reported by @nopria,
   contributed by @lostenderman)
- Produce soft line break renderers in inline notes.
  (#450, lostenderman/markdown#159, contributed by @lostenderman)

Documentation:

- Improve the documentation of portable installation.
  (#444, 9afac050, contributed by @l0th3r)
- Document that the Markdown package can be installed from GitHub releases.
  (#449, #450, reported by @nopria)

Continuous Integration:

- Remove warnings from Pandoc and GitHub Actions. (2b3f3469..71f174b1)

Defaults:

- Fix default definitions for fancy tight ordered lists.
  (#446, f978e818, reported by @l0th3r)

## 3.6.0 (2024-05-27)

Development:

- Add Lua options `unicodeNormalization` and `unicodeNormalizationForm` for
  normalizing markdown text using Unicode normalization.
  (#434, #442, sponsored by @istqborg)

Fixes:

- Make `\markdownInput` search in `\l_file_search_path_seq`.
  (#443, reported by @robertjlee)

Documentation:

- Add a link to a work-in-progress article for TUGboat 45:2 to `README.md`.
  (7a1a7ea0)

Fixes:

- Correctly sort YAML map keys with mixed types. (#433, #441)

## 3.5.0 (2024-04-29)

Development:

- Add `\markinline` plain TeX command. (#300, #439, [matrix.org][matrix-439])
- Support incremental definitions of token renderers and renderer prototypes
  in the `\markdownSetup` command.
  (#232, #435, 540a83c0, [matrix.org][matrix-435], #437, #438,
   contributed by @eg9, @gucci-on-fleek, and @Skillmon
   [on TeX StackExchange][tse-716400])

 [matrix-435]: https://matrix.to/#/!UeAwznpYwwsinVTetR:matrix.org/$k4ky6I-uvxdp8ipVlHvef5JXfIfPQvFtXOAD_ogF2uU?via=matrix.org&via=im.f3l.de
 [matrix-439]: https://matrix.to/#/!pznomuvubVyxElflTe:matrix.org/$Gp9CYKWP3h_gyFyArnW3Y3CJzVXefWYThjlyB58zvP8?via=matrix.org&via=im.f3l.de
 [tse-716400]: https://tex.stackexchange.com/questions/716362/convert-control-sequence-with-a-variable-number-of-parameters-into-a-token-list/716400#716400

Default Renderer Prototypes:

- Add default renderers for unnumbered sections in LaTeX.
  (#401, istqborg/istqb_product_base#23, #430, reported by @felipecrp,
   sponsored by @istqborg)

## 3.4.3 (2024-04-04)

Fixes:

- Remove trailing paragraph/interblock separators in right-open slice
  intervals. (#408, #419)
- Do not misinterpret bracketed e-mails as citations. (#424, #426,
  sponsored by @istqborg)
- Comply with CommonMark 0.31.2. (#416, 40b516ee, de8d137d, #432,
  contributed by @lostenderman)
- Do not end a paragraph before a `:::` in fenced divs.
  (#407, lostenderman/markdown#157, #427, #428, lostenderman/markdown#158,
   #431, contributed by @lostenderman)

Documentation:

- Add slides from the defense of projects MUNI/33/1654/2022 and
  MUNI/33/1658/2022 to `README.md`. (49f01ccf)
- Remove `<mroot>` from MathML in the user manual. (#420, #422,
  contributed by @quark67)

Contributed Software:

- Make the documentation of contributions more detailed. (3f928162)

Docker:

- Add support for TeX Live 2024.
  (#411, bafbb164, #413, 04957eee, 16000aa4, #425, 9549a5d8, 8f8e1315,
   844beafc, cf592003)

Continuous Integration:

- Style-check tabs and trailing spaces in `markdown.dtx`. (a0c941ca)

## 3.4.2 (2024-03-09)

Fixes:

- In `\begin{markdown}[options]`, allow a new line before `options`.
  (#414, #415)

Contributed Software:

- Add `contributions/istqb_product_base`. (8e727c9b)
- Add `contributions/fithesis`. (0b6a436c, 0725b20c, 7daf2b5e)

## 3.4.1 (2024-02-16)

Fixes:

- Rename option `contentType` to `contentLevel`. (#300, #400, ca98e039)
- Correctly produce paragraph separators inside block-level elements.
  (#376, #377, #403, contributed by @lostenderman)

Deprecation:

- Replace `\markdownInfo`, `\markdownWarning`, and `\markdownError` with l3msg
  functions and deprecate them. (#383, #398, e3ca682c, 48002f84)
- Use the `TEXMF_OUTPUT_DIRECTORY` environmental variable to set
  `\markdownOptionOutputDir` and deprecate it.
  (#405, #409, [matrix.org][matrix-405])

 [matrix-405]: https://matrix.to/#/!efVbynJpCMjlOTfose:matrix.org/$8oUA2Bn3ch3q9K6RU-1EgpO9uQOd_3Mky4YwT325Ib0?via=matrix.org&via=im.f3l.de

Docker:

- Add support for TeX Live 2024 pretest.
  (#404, #406, e51738ba, #410, 7ef64dd9, a7cff81d, contributed by @jspitz)

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

Tests:

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
  sponsored by @istqborg)
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
  (68c7a2f5, istqborg/istqb_shared_documents#87)
- Support attributes on multi-line setext headings.
  (#315, #355, #356, contributed by @lostenderman)
- Correctly process the combination of Lua options `fancyLists` and
  `startNumber`. (59fb97e8)
- Properly parse emphasis at line endings in headings.
  (#358, #360, contributed by @lostenderman)
- Fix fancy lists that use roman numerals as markers.
  (istqborg/istqb_shared_documents#87, #359, #364,
   contributed by @lostenderman, sponsored by @istqborg)

Documentation:

- Add a link to a preprint from TUGboat 44:3 to `README.md`.
  (cf6b3d7b, dc57af7)
- Measure the speed impact of test file batching.
  (#357, b526fa65, 8c94ffc9, [matrix.org][matrix-357])

 [matrix-357]: https://matrix.to/#/!efVbynJpCMjlOTfose:matrix.org/$WR3quuO1fyOl6w_KX6YFA4BACBcL-cWUWBpVfpPWDkI?via=matrix.org&via=im.f3l.de

Tests:

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

Tests:

- Add support for YAML metadata in testfiles.
  (#345, #347, [matrix.org][matrix-347])

 [matrix-347]: https://matrix.to/#/!efVbynJpCMjlOTfose:matrix.org/$8JXGbDz0viyRyv6ySWQ3344BOhwd4dj5WYeawzEg_tU?via=matrix.org&via=im.f3l.de

Documentation:

- Add a link to a preprint from CSTUG Bulletin to `README.md`.
  (2c354f49)

## 3.0.1 (2023-09-10)

Fixes:

- Correctly parse paragraphs with trailing spaces.
  (istqborg/istqb_shared_documents#77, #345, #347)

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

Tests:

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

Tests:

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

Tests:

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
- Add facade in front of expl3 interface for YAML metadata. (#118, #175)
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

- Remove dysfunctional badges for Docker from `README.md`. (ad00b58, 707cad9)
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
- Escape autolink labels even when hybrid mode is enabled. (reported by @iwelch,
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

Tests:

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
