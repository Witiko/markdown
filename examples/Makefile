.PHONY: all clean

AUXFILES=*.tmp *.tui *.tuo *.mp *.tuc *.markdown.in *.markdown.out \
  *.markdown.lua *.log *.aux *.dvi *.idv *.lg *.tmp *.xref *.4ct *.4tc \
  example.tex *.debug-extensions.json debug-extensions.json
AUXDIRS=_markdown_*/
LUACLI_OPTIONS=\
  cacheDir=_markdown_example \
  contentBlocks=true \
  debugExtensions=true \
  definitionLists=true \
  eagerCache=false \
  fancy_lists=true \
  fencedCode=true \
  hashEnumerators=true \
  inlineNotes=true \
  lineBlocks=true \
  notes=true \
  pipeTables=true \
  rawAttribute=true \
  smartEllipses=true \
  strikeThrough=true \
  subscripts=true \
  superscripts=true \
  tableCaptions=true \
  taskLists=true \
  texMathDollars=true \
  texMathDoubleBackslash=true \
  texMathSingleBackslash=true
OUTPUT=\
  context-mkiv.pdf \
  latex-pdftex.pdf latex-xetex.pdf latex-luatex.pdf \
  latex-tex4ht.html latex-tex4ht.css \
  optex.pdf

# This is the default pseudo-target.
all: $(OUTPUT)
	$(MAKE) clean

# This target typesets the ConTeXt example using the Mark IV format.
context-mkiv.pdf: context-mkiv.tex example.tex
	context --luatex context-mkiv.tex

# This target typesets the LaTeX example using the pdfTeX engine.
latex-pdftex.pdf: latex-pdftex.tex example.tex
	pdflatex --shell-escape $<
	pdflatex --shell-escape $<

# This target typesets the LaTeX example using the XeTeX engine.
latex-xetex.pdf: latex-xetex.tex example.tex
	xelatex --shell-escape $<
	xelatex --shell-escape $<

# This target typesets the LaTeX example using the LuaTeX engine.
latex-luatex.pdf: latex-luatex.tex example.tex
	lualatex $<
	lualatex $<

# This target typesets the LaTeX example using TeX4ht.
latex-tex4ht.html latex-tex4ht.css: latex-tex4ht.tex example.tex
	make4ht --shell-escape $< fn-in

# This target typesets the OpTeX example.
optex.pdf: optex.tex
	optex $<

# This target converts the markdown example to a plain TeX representation
# using the Lua command-line interface for the Markdown package.
example.tex: example.md
	markdown2tex $(LUACLI_OPTIONS) -- $< $@

# This pseudo-target removes any existing auxiliary files and directories.
clean:
	rm -f $(AUXFILES)
	rm -rf $(AUXDIRS)

# This pseudo-target removes any makeable files.
implode: clean
	rm -f $(OUTPUT)
