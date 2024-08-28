Markdown
========

[![license](https://img.shields.io/github/license/witiko/markdown)](LICENSE)
[![ci](https://github.com/witiko/markdown/actions/workflows/main.yml/badge.svg)][ci]
[![release](https://img.shields.io/github/release/witiko/markdown)][release]
[![docker-witiko/markdown](https://img.shields.io/docker/v/witiko/markdown/latest?label=docker)][docker-witiko/markdown]
[![matrix](https://img.shields.io/matrix/witiko-markdown:matrix.org?label=matrix)][matrix]
[![discord](https://img.shields.io/discord/1011667276908474440?label=discord&color=blueviolet)][discord]
[![chatgpt](https://img.shields.io/badge/gpt-9cf)][chatgpt]

 [release]:  https://github.com/Witiko/markdown/releases/latest              "Releases · Witiko/markdown"
 [ci]:       https://github.com/Witiko/markdown/actions                      "GitHub Actions"
 [matrix]:   https://matrix.to/#/#witiko-markdown:matrix.org                 "The Matrix Chat Space for the Markdown package"
 [discord]:  https://discord.gg/8xJsPghzSH                                   "The Discord Chat Space for the Markdown package"
 [chatgpt]:  https://chat.openai.com/g/g-I3K0DweJe-markdown-package-for-tex  "ChatGPT - Markdown package for TeX"

The Markdown package converts [CommonMark][] markup to TeX commands. The
functionality is provided both as a Lua module, and as plain TeX, LaTeX, and
ConTeXt macro packages that can be used to directly typeset TeX documents
containing markdown markup. Unlike other converters, the Markdown package does
not require any external programs, and makes it easy to redefine how each and
every markdown element is rendered. Creative abuse of the markdown syntax is
encouraged. 😉

 [commonmark]: https://commonmark.org/ "CommonMark: A strongly defined, highly compatible specification of Markdown"

Your first Markdown document
----------------------------

Using a text editor, create an empty directory named `workdir/`. In it, create
a text document named `workdir/document.tex` with the following content:

``` latex
\documentclass{book}
\usepackage{markdown}
\markdownSetup{pipeTables,tableCaptions}
\begin{document}
\begin{markdown}
Introduction
============
## Section
### Subsection
Hello *Markdown*!

| Right | Left | Default | Center |
|------:|:-----|---------|:------:|
|   12  |  12  |    12   |    12  |
|  123  |  123 |   123   |   123  |
|    1  |    1 |     1   |     1  |

: Table
\end{markdown}
\end{document}
```

Next, run the [LaTeXMK][] tool from
[our official Docker image][docker-witiko/markdown] on `document.tex`:

    docker run --rm -v "$PWD"/workdir:/workdir -w /workdir witiko/markdown \
      latexmk -pdf -shell-escape -silent document.tex

Alternatively, you can install [TeX Live][tex-live] (can take up to several
hours) and use its [LaTeXMK][] tool:

    latexmk -cd -pdf -shell-escape -silent workdir/document.tex

A PDF document named `workdir/document.pdf` should be produced and contain the
following output:

 ![banner](markdown.png "An example LaTeX document using the Markdown package")

Congratulations, you have just typeset your first Markdown document! 🥳

 [tex-live]: https://www.tug.org/texlive/ "TeX Live - TeX Users Group"

Use Markdown for continuous integration
---------------------------------------

Can't live without the latest features of the Markdown package in your
continuous integration pipelines? It's ok, you can use
[our official Docker image][docker-witiko/markdown] as a drop-in replacement
for [the `texlive/texlive:latest` Docker image][docker-texlive/texlive]!
The following example shows a [GitHub Actions][github-actions] pipeline, which
will automatically typeset and prerelease a PDF document:

``` yaml
name: Typeset and prerelease the book
on:
  push:
jobs:
  typeset:
    runs-on: ubuntu-latest
    container:
      image: witiko/markdown:latest
    steps:
      - uses: actions/checkout@v2
      - run: latexmk -lualatex document.tex
      - uses: marvinpinto/action-automatic-releases@latest
        permissions:
          contents: write
        with:
          title: The latest typeset book
          automatic_release_tag: latest
          prerelease: true
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          files: document.pdf
```

In fact, this is how we automatically produce
[the latest documentation][techdoc-latest] for the Markdown package.

 [docker-witiko/markdown]: https://hub.docker.com/r/witiko/markdown/tags "witiko/markdown - Docker Image"
 [docker-texlive/texlive]: https://hub.docker.com/r/texlive/texlive/tags "texlive/texlive - Docker Image"

 [github-actions]: https://docs.github.com/actions "GitHub Actions Documentation"

Peek under the hood
-------------------

Remember how we said that the Markdown package converts markdown markup to
TeX commands? Let's see what that means and what we can do with this knowledge.

Using a text editor, create an empty text document named `document.md` with
the following markdown content:

``` markdown
Hello *Markdown*! $a_x + b_x = c_x$
```

Next, run [the Lua command-line interface (CLI)][lua-cli] from
[our official Docker image][docker-witiko/markdown] on `document.md`:

    docker run --rm -i witiko/markdown markdown-cli hybrid=true < document.md

We will receive the following output, where the markdown markup has been
replaced by TeX commands:

``` tex
\markdownDocumentBegin
Hello \markdownRendererEmphasis{Markdown}!
$a\markdownRendererEmphasis{x + b}x = c_x$
\markdownDocumentEnd
```

We can see right away that the Markdown package has incorrectly interpreted
`_x + b_` as an emphasized text. We can fix this by passing in the
`underscores=false` option:

    docker run --rm -i witiko/markdown markdown-cli hybrid=true underscores=false < document.md

``` tex
\markdownDocumentBegin
Hello \markdownRendererEmphasis{Markdown}!
$a_x + b_x = c_x$
\markdownDocumentEnd
```

Much better! If the Markdown package ever surprises you, use the Lua CLI to
peek under the hood and inspect the results of the conversion.

 [lua-cli]: https://mirrors.ctan.org/macros/generic/markdown/markdown.html#lua-command-line-interface "Markdown Package User Manual"

Further information
-------------------

For further information, consult one of the following:

1. The user manual for either [the released version][manual-tex-live] or
   [the latest development version][manual-latest], which can be produced by
   interpreting the `markdown.ins` file using a Unicode-aware TeX engine, such
   as LuaTeX (`luatex markdown.ins`). The manual will reside in the file
   `markdown.md` and the CSS stylesheet `markdown.css`.
2. The technical documentation for either [the released version][techdoc-tex-live]
   or [the latest development version][techdoc-latest], which can be typeset by
   running the [LaTeXMK][] tool on the `markdown.dtx` file (`latexmk
   markdown.dtx`) after [installing the Markdown package][install].
   [LaTeXMK][] should be included in your TeX distribution.
   The typeset documentation will reside in the file `markdown.pdf`.
3. Tutorials and example documents by [Lian Tze Lim][liantze] at [Overleaf][]:
    - [How to write in Markdown on Overleaf][overleaf-1],
    - [Markdown into LaTeX with Style][overleaf-2],
    - [Writing Markdown in LaTeX Documents][overleaf-3],
    - [Writing Beamer Slides with Markdown][overleaf-4],
    - [Writing Posters with Markdown][overleaf-5], and
    - [Using Markdown in LaTeX documents][overleaf-6].
4. Journal articles published by [TUGboat][]:
    - [Using Markdown inside TeX documents][tb119],
    - [Markdown 2.7.0: Towards lightweight markup in TeX][tb124],
    - [Making Markdown into a Microwave Meal][tb129],
    - [Markdown 2.10.0: LaTeX Themes & Snippets, Two Flavors of Comments, and LuaMetaTeX][tb131],
    - [Markdown 2.15.0: What's New?][tb133],
    - [Markdown 2.17.1: What's New, What's Next?][tb135],
    - [Attributes in Markdown][tb136],
    - [Markdown 3 at TUG 2023: Reflections from the Q&A session][tb138],
    - Fast Regression Testing of TeX Packages: The Unreasonable Effectiveness of Batching ([preprint][tb139]), and
    - Markdown Themes in Practice ([preprint][tb140-preprint], [work in progress][tb140]).
5. Journal articles published by [CSTUG Bulletin][csbul] (in Czech and Slovak):
    - [Rendering Markdown inside TeX Documents][10.5300/2016-1-4/78],
    - [Markdown 2.8.1: Boldly Unto the Throne of Lightweight Markup in TeX][10.5300/2020-1-2/48],
    - [Markdown 2.10.0: LaTeX Themes & Snippets][10.5300/2021-1-4/76],
    - [Direct Typesetting of Various Document Formats in TeX Using the Pandoc Utility][10.5300/2021-1-4/83],
    - [High-Level Languages for TeX][10.5300/2022-1-4/35], and
    - [Markdown 3: What's New, What's Next?][10.5300/2023-3-4/111].
6. Talks:
    - [Five Years of Markdown in LaTeX: What, Why, How, and Whereto][pv212-fall2020] (in Czech),
    - [Markdown 2.10.0: LaTeX Themes & Snippets, Two Flavors of Comments, and LuaMetaTeX][tb131-video] ([mirror][tb131-video-mirror], [slides][tb131-slides]),
    - [A Self-Publisher's Take on Markdown and TeX][tb134-01-video] ([slides][tb134-01-slides]),
    - [A Gentle Introduction to Markdown for Writers][tb134-02-video] ([slides][tb134-02-slides], [example][tb134-02-example]),
    - [Markdown 3: What's New, What's Next?][tb137-video] ([mirror][tb137-video-mirror], [slides][tb137-slides]),
    - An Implementation of the CommonMark Standard and new Syntax Extensions to the Markdown Package for TeX ([slides][gencur-defense-slides]), and
    - [Markdown Themes in Practice][tb140-video] ([preprint][tb140-preprint], [slides][tb140-slides])
7. Theses:
    - [Generic TeX Writer for the Pandoc Document Converter][thesis-umhg5]
    - [An implementation of the CommonMark standard into the Markdown package for TeX][thesis-r7z7l]

 [overleaf-1]: https://www.overleaf.com/learn/latex/Articles/How_to_write_in_Markdown_on_Overleaf       "How to write in Markdown on Overleaf"
 [overleaf-2]: https://www.overleaf.com/learn/latex/Articles/Markdown_into_LaTeX_with_Style             "Markdown into LaTeX with Style"
 [overleaf-3]: https://www.overleaf.com/learn/how-to/Writing_Markdown_in_LaTeX_Documents                "Writing Markdown in LaTeX Documents"
 [overleaf-4]: https://www.overleaf.com/latex/examples/writing-beamer-slides-with-markdown/dnrwnjrpjjhw "Writing Beamer Slides with Markdown"
 [overleaf-5]: https://www.overleaf.com/latex/examples/writing-posters-with-markdown/jtbgmmgqrqmh       "Writing Posters with Markdown"
 [overleaf-6]: https://www.overleaf.com/latex/examples/using-markdown-in-latex-documents/whdrnpcpnwrm   "Using Markdown in LaTeX documents"

 [tb119]: https://www.tug.org/TUGboat/tb38-2/tb119novotny.pdf                                                                  "Using Markdown inside TeX documents"
 [tb124]: https://www.tug.org/TUGboat/tb40-1/tb124novotny-markdown.pdf                                                         "Markdown 2.7.0: Towards lightweight markup in TeX"
 [tb129]: https://www.tug.org/TUGboat/tb41-3/tb129novotny-frozen.pdf                                                           "Making Markdown into a Microwave Meal"
 [tb131]: https://www.tug.org/TUGboat/tb42-2/tb131novotny-markdown.pdf                                                         "Markdown 2.10.0: LaTeX Themes & Snippets, Two Flavors of Comments, and LuaMetaTeX"
 [tb133]: https://www.tug.org/TUGboat/tb43-1/tb133novotny-markdown.pdf                                                         "Markdown 2.15.0: What's New?"
 [tb135]: https://www.tug.org/TUGboat/tb43-3/tb135novotny-markdown.pdf                                                         "Markdown 2.17.1: What's New, What's Next?"
 [tb136]: https://www.tug.org/TUGboat/tb44-1/tb136novotny-markdown-attr.pdf                                                    "Attributes in Markdown"
 [tb138]: https://www.tug.org/TUGboat/tb44-3/tb138starynovotny-markdown-qa.pdf                                                 "Markdown 3 at TUG 2023: Reflections from the Q&A session"
 [tb139]: https://github.com/Witiko/fast-regression-testing/releases/download/latest/tb139starynovotny-testing.pdf             "Fast Regression Testing of TeX Packages: The Unreasonable Effectiveness of Batching"
 [tb140]: https://github.com/Witiko/markdown-themes-in-practice/releases/download/latest/tb140starynovotny-markdown-themes.pdf "Markdown Themes in Practice"

 [tb131-slides]:       https://tug.org/tug2021/assets/pdf/tug2021-novotny-slides.pdf                            "Markdown 2.10.0: LaTeX Themes & Snippets, Two Flavors of Comments, and LuaMetaTeX"
 [tb131-video]:        https://youtu.be/i2GJMnLCZls                                                             "Markdown 2.10.0: LaTeX Themes & Snippets, Two Flavors of Comments, and LuaMetaTeX"
 [tb131-video-mirror]: https://youtu.be/THmPkAncMnc                                                             "Markdown 2.10.0: LaTeX Themes & Snippets, Two Flavors of Comments, and LuaMetaTeX (mirror)"
 [tb134-01-slides]:    https://tug.org/tug2022/assets/served/Lloyd_Prentice-TUG2022-prentice-selfpub-slides.pdf "A Self-Publisher's Take on Markdown and TeX"
 [tb134-01-video]:     https://youtu.be/OhwzT3TcLj8                                                             "A Self-Publisher's Take on Markdown and TeX"
 [tb134-02-slides]:    https://tug.org/tug2022/assets/pdf/Tereza_Vrabcová-TUG2022-slides.pdf                    "A Gentle Introduction to Markdown for Writers"
 [tb134-02-example]:   https://tug.org/tug2022/assets/pdf/Tereza_Vrabcová-TUG2022-example.pdf                   "A Gentle Introduction to Markdown for Writers"
 [tb134-02-video]:     https://youtu.be/FhN_x9rsR4M                                                             "A Gentle Introduction to Markdown for Writers"
 [tb137-slides]:       https://tug.org/tug2023/files/sa-03-novotny-markdown3/novotny-markdown3-slides.pdf       "Markdown 3: What's New, What's Next?"
 [tb137-video]:        https://youtu.be/U8XjTOhJkg0                                                             "Markdown 3: What's New, What's Next?"
 [tb137-video-mirror]: https://youtu.be/W15bBpVTA-c                                                             "Markdown 3: What's New, What's Next? (mirror)"
 [tb140-preprint]:     https://www.tug.org/tug2024/preprints/starynovotny-markdown-themes.pdf                   "Markdown Themes in Practice"
 [tb140-video]:        https://youtu.be/d7vTW7PR0B4?t=5h3m10s                                                   "Markdown Themes in Practice"
 [tb140-slides]:       https://www.tug.org/tug2024/slides/starynovotny-markdown-themes.pdf                      "Markdown Themes in Practice"

 [10.5300/2016-1-4/78]:  https://www.doi.org/10.5300/2016-1-4/78  "Rendering Markdown inside TeX Documents"
 [10.5300/2020-1-2/48]:  https://www.doi.org/10.5300/2020-1-2/48  "Markdown 2.8.1: Boldly Unto the Throne of Lightweight Markup in TeX"
 [10.5300/2021-1-4/76]:  https://www.doi.org/10.5300/2021-1-4/76  "Markdown 2.10.0: LaTeX Themes & Snippets"
 [10.5300/2021-1-4/83]:  https://www.doi.org/10.5300/2021-1-4/83  "Direct Typesetting of Various Document Formats in TeX Using the Pandoc Utility"
 [10.5300/2022-1-4/35]:  https://www.doi.org/10.5300/2022-1-4/35  "High-Level Languages for TeX"

 [10.5300/2023-3-4/111]: https://www.doi.org/10.5300/2023-3-4/111 "Markdown 3: What's New, What's Next?"

 [pv212-fall2020]: https://is.muni.cz/elearning/io/?qurl=%2Fel%2Ffi%2Fpodzim2020%2FPV212%2Findex.qwarp;prejit=5595952

 [gencur-defense-slides]: https://docs.google.com/presentation/d/e/2PACX-1vRbgJZ-UJlj5WMOjgWnq0BeNWKdA9ZhFqCKajhCjXtv3OarSKmojl5-X8tDp1ivnKtujuyEDmD2z_Z0/pub "An Implementation of the CommonMark Standard and new Syntax Extensions to the Markdown Package for TeX"

 [install]:  https://mirrors.ctan.org/macros/generic/markdown/markdown.html#installation "Markdown Package User Manual"
 [liantze]:  http://liantze.penguinattack.org/                                           "Rants from the Lab"
 [overleaf]: https://www.overleaf.com/                                                   "Overleaf: Real-time Collaborative Writing and Publishing Tools with Integrated PDF Preview"
 [tugboat]:  https://www.tug.org/tugboat/                                                "TUGboat - Communications of the TeX Users Group"
 [csbul]:    https://bulletin.cstug.cz/                                                  "Zpravodaj Československého sdružení uživatelů TeXu"

 [manual-latest]:     https://witiko.github.io/markdown                                  "Markdown Package User Manual"
 [manual-tex-live]:   https://mirrors.ctan.org/macros/generic/markdown/markdown.html     "Markdown Package User Manual"

 [techdoc-latest]:    https://github.com/Witiko/markdown/releases/download/latest/markdown.pdf  "A Markdown Interpreter for TeX"
 [techdoc-tex-live]:  https://mirrors.ctan.org/macros/generic/markdown/markdown.pdf             "A Markdown Interpreter for TeX"

 [thesis-umhg5]: https://is.muni.cz/th/umhg5/?lang=en "Generic TeX Writer for the Pandoc Document Converter"
 [thesis-r7z7l]: https://is.muni.cz/th/r7z7l/?lang=en "An implementation of the CommonMark standard into the Markdown package for TeX"

Acknowledgements
----------------

| Logo          | Acknowledgement |
| ------------- | --------------- |
| [<img width="150" src="https://www.fi.muni.cz/images/fi-logo.png">][fimu] | I gratefully acknowledge the funding from the [Faculty of Informatics][fimu] at the [Masaryk University][mu] in Brno, Czech Republic, for the development of the Markdown package in projects [MUNI/33/12/2015][], [MUNI/33/1784/2020][], [MUNI/33/0776/2021][], [MUNI/33/1654/2022][], and [MUNI/33/1658/2022][]. |
| [<img width="150" src="https://cdn.overleaf.com/img/ol-brand/overleaf_og_logo.png">][overleaf] | Extensive user documentation for the Markdown package was kindly written by [Lian Tze Lim][liantze] and published by [Overleaf][]. |
| [<img width="150" src="https://pbs.twimg.com/profile_images/1004769879319334912/6Bh1UthD.jpg">][omedym] | Support for content slicing (Lua options [`shiftHeadings`][option-shift-headings] and [`slice`][option-slice]) and pipe tables (Lua options [`pipeTables`][option-pipe-tables] and [`tableCaptions`][option-table-captions]) was graciously sponsored by [David Vins][dvins] and [Omedym][]. |
| [<img width="150" src="https://www.istqb.org/static/istqb-logo-1b043e800a580724ad223567f9ea57c0.png">][istqb] | Fixes for issues [#359][issue-359], [#368][issue-368], [#401][issue-401], [#424][issue-424], [#440][issue-440], [#468][issue-468], [#474][issue-474], and [#487][issue-487] were graciously sponsored by the [International Software Testing Qualifications Board (ISTQB)][istqb]. |

 [dvins]:  https://github.com/dvins             "David Vins"
 [fimu]:   https://www.fi.muni.cz/index.html.en "Faculty of Informatics, Masaryk University"
 [ISTQB]:  https://github.com/istqborg          "ISTQB.ORG: Official ISTQB® GitHub account"
 [mu]:     https://www.muni.cz/en               "Masaryk University"
 [Omedym]: https://www.omedym.com/              "Omedym"

 [issue-359]: https://github.com/witiko/markdown/issues/359 "First item of a fancy list forms a separate list"
 [issue-368]: https://github.com/witiko/markdown/issues/368 "Tables nested in list items have empty lines"
 [issue-401]: https://github.com/witiko/markdown/issues/401 "Create an unnumbered section"
 [issue-424]: https://github.com/witiko/markdown/issues/424 "E-mail addresses are incorrectly interpreted as bracketed citations"
 [issue-440]: https://github.com/witiko/markdown/issues/440 "Support programmatic text in YAML metadata values"
 [issue-468]: https://github.com/witiko/markdown/issues/468 "Enable option eagerCache by default"
 [issue-474]: https://github.com/witiko/markdown/issues/474 "Improve the speed of the Markdown package"
 [issue-487]: https://github.com/witiko/markdown/issues/487 "Prevent loading the full Markdown package when converting cached markdown fragments"

 [option-pipe-tables]:    https://mirrors.ctan.org/macros/generic/markdown/markdown.html#pipe-tables          "Markdown Package User Manual"
 [option-shift-headings]: https://mirrors.ctan.org/macros/generic/markdown/markdown.html#option-shiftheadings "Markdown Package User Manual"
 [option-slice]:          https://mirrors.ctan.org/macros/generic/markdown/markdown.html#slice                "Markdown Package User Manual"
 [option-table-captions]: https://mirrors.ctan.org/macros/generic/markdown/markdown.html#option-tablecaptions "Markdown Package User Manual"

 [MUNI/33/12/2015]:   https://www.muni.cz/en/research/projects/32984 "A Markdown Interpreter in TeX"
 [MUNI/33/1784/2020]: https://www.muni.cz/en/research/projects/58488 "Extension of the Input Formats of the Markdown Tool"
 [MUNI/33/0776/2021]: https://www.muni.cz/en/research/projects/62168 "Preparation of Templates for Typesetting Books and Publishing Collaterals with the Markdown TeX Package"
 [MUNI/33/1654/2022]: https://www.muni.cz/en/research/projects/69763 "An Implementation of the CommonMark Standard into the Markdown Package for TeX"
 [MUNI/33/1658/2022]: https://www.muni.cz/en/research/projects/69762 "Syntax Extensions of the Markdown Package for TeX"

Contributing to the Development of Markdown
-------------------------------------------

Apart from the example markdown documents, tests, and continuous integration,
which are placed in the `examples/`, `tests/`, and `.github/` directories,
the complete source code and documentation of the package are placed in the
`markdown.dtx` document following the [literate programming][] paradigm.
Some useful commands, such as building the release archives and typesetting
the documentation, are placed in the `Makefile` file for ease of maintenance.

When the file `markdown.ins` is interpreted using a Unicode-aware TeX engine,
such LuaTeX (`luatex markdown.ins`), several files are produced from the
`markdown.dtx` document. The `make base` command is provided by `Makefile` for
convenience. In `markdown.dtx`, the boundaries between the produced files are
marked up using an XML-like syntax provided by the [l3docstrip][] plain TeX
package.

Running the [LaTeXMK][] tool on the `markdown.dtx` file
(`latexmk markdown.dtx`) after the Markdown package has been
[installed][install] typesets the documentation. The `make markdown.pdf`
command is provided by `Makefile` for convenience. In `markdown.dtx`, the
documentation is placed inside TeX comments and marked up using the
[ltxdockit][] LaTeX document class. Support for typesetting the documentation
is provided by the [doc][] LaTeX package.

To facilitate continuous integration and sharing of the Markdown package,
there exists an [official Docker image][docker-witiko/markdown], which can be
reproduced by running the `docker build` command on `Dockerfile` (`docker build
-t witiko/markdown .`). The `make docker-image` command is provided by
`Makefile` for convenience.

 [doc]:                  https://ctan.org/pkg/doc                           "doc – Format LaTeX documentation"
 [l3docstrip]:           https://ctan.org/pkg/l3docstrip                    "l3docstrip – Strip documentation in LaTeX3 source"
 [LaTeXMK]:              https://ctan.org/pkg/latexmk                       "latexmk – Fully automated LaTeX document generation"
 [literate programming]: https://en.wikipedia.org/wiki/Literate_programming "Literate programming"
 [ltxdockit]:            https://ctan.org/pkg/ltxdockit                     "ltxdockit – Documentation support"

Contributed Software
--------------------

Links to contributed third-party software for the Markdown package are
available in the `contributions/` directory. The intention is to show
interesting tools for the Markdown package and to give them wider exposure
without taking responsibility for their development or maintenance.

Citing Markdown
---------------

When citing Markdown in academic papers and theses, please use the following
BibTeX entry:

``` bib
@article{novotny2017markdown,
  author  = {V\'{i}t Novotn\'{y}},
  year    = {2017},
  title   = {Using {M}arkdown Inside {\TeX} Documents},
  journal = {TUGboat},
  volume  = {38},
  number  = {2},
  pages   = {214--217},
  issn    = {0896-3207},
  url     = {https://tug.org/TUGboat/tb38-2/tb119novotny.pdf},
  urldate = {2020-07-31},
}
```

Alternatively, you can use the `Novotny:2017:UMI` key from the [`tugboat.bib`][tugboat.bib]
BibTeX file that is included in your TeX distribution like this:

``` tex
\cite{Novotny:2017:UMI}
\bibliography{tugboat}
```

 [tugboat.bib]: http://mirrors.ctan.org/info/digests/tugboat/biblio/tugboat.bib
