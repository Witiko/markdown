.PHONY: all base clean implode dist test docker-image force

SHELL=/bin/bash

AUXFILES=markdown.bbl markdown.cb markdown.cb2 markdown.glo markdown.bbl \
  markdown.run.xml markdown.markdown.in markdown.markdown.lua \
  markdown.markdown.out markdown-interfaces.md markdown-miscellanea.md \
  markdown-options.md markdown-tokens.md $(TECHNICAL_DOCUMENTATION_RESOURCES) \
  $(VERSION_FILE)
AUXDIRS=_minted-markdown _markdown_markdown markdown pkgcheck
TDSARCHIVE=markdown.tds.zip
CTANARCHIVE=markdown.ctan.zip
DISTARCHIVE=markdown.zip
ARCHIVES=$(TDSARCHIVE) $(CTANARCHIVE) $(DISTARCHIVE)
EXAMPLES_RESOURCES=examples/example.md examples/scientists.csv
EXAMPLES_SOURCES=examples/context-mkii.tex examples/context-mkiv.tex examples/latex.tex
EXAMPLES=examples/context-mkii.pdf examples/context-mkiv.pdf \
  examples/latex-pdftex.pdf examples/latex-luatex.pdf examples/latex-xetex.pdf \
  examples/latex-tex4ht.html examples/latex-tex4ht.css
TESTS=tests/test.sh tests/support/*.tex tests/templates/*/*.tex.m4 \
  tests/templates/*/COMMANDS.m4 tests/testfiles/*/*.test
MAKES=Makefile $(addsuffix /Makefile, $(SUBDIRECTORIES)) latexmkrc
ROOT_README=README.md markdown.png
READMES=$(ROOT_README) LICENSE examples/README.md tests/README.md \
  tests/support/README.md tests/templates/README.md tests/testfiles/README.md \
  tests/templates/*/README.md tests/testfiles/*/README.md
VERSION_FILE=VERSION
CHANGES_FILE=CHANGES.md
DTXARCHIVE=markdown.dtx
INSTALLER=markdown.ins docstrip.cfg
TECHNICAL_DOCUMENTATION_RESOURCES=markdown.bib markdown-figure-block-diagram.tex \
  markdownthemewitiko_markdown_techdoc.sty
TECHNICAL_DOCUMENTATION=markdown.pdf
MARKDOWN_USER_MANUAL=markdown.md markdown.css
HTML_USER_MANUAL=markdown.html markdown.css
USER_MANUAL=$(MARKDOWN_USER_MANUAL) $(HTML_USER_MANUAL)
DOCUMENTATION=$(TECHNICAL_DOCUMENTATION) $(HTML_USER_MANUAL) $(ROOT_README) $(VERSION_FILE) \
  $(CHANGES_FILE)
LIBRARIES=libraries/markdown-tinyyaml.lua
INSTALLABLES=markdown.lua markdown-cli.lua markdown.tex markdown.sty t-markdown.tex \
  markdownthemewitiko_dot.sty markdownthemewitiko_graphicx_http.sty \
  markdownthemewitiko_tilde.sty
EXTRACTABLES=$(INSTALLABLES) $(MARKDOWN_USER_MANUAL) $(TECHNICAL_DOCUMENTATION_RESOURCES)
MAKEABLES=$(TECHNICAL_DOCUMENTATION) $(USER_MANUAL) $(INSTALLABLES) $(EXAMPLES)
RESOURCES=$(DOCUMENTATION) $(EXAMPLES_RESOURCES) $(EXAMPLES_SOURCES) $(EXAMPLES) \
  $(MAKES) $(READMES) $(INSTALLER) $(DTXARCHIVE) $(TESTS)
EVERYTHING=$(RESOURCES) $(INSTALLABLES) $(LIBRARIES)
GITHUB_PAGES=gh-pages

VERSION=$(shell git describe --tags --always --long --exclude latest)
LASTMODIFIED=$(shell git log -1 --date=format:%Y-%m-%d --format=%ad)

# This is the default pseudo-target. It typesets the manual,
# the examples, and extracts the package files.
all: $(MAKEABLES)
	$(MAKE) clean

# This pseudo-target extracts the source files out of the DTX archive and
# produces external Lua libraries.
base: $(INSTALLABLES) $(LIBRARIES)
	$(MAKE) clean

# This pseudo-target builds a witiko/markdown Docker image.
docker-image:
	DOCKER_BUILDKIT=1 docker build --pull --build-arg TEXLIVE_TAG=$(TEXLIVE_TAG) \
	                               -t witiko/markdown:$(TEXLIVE_TAG) \
	                               -t witiko/markdown:$(VERSION)-$(TEXLIVE_TAG) .

# This targets produces a directory with files for the GitHub Pages service.
$(GITHUB_PAGES): $(HTML_USER_MANUAL)
	mkdir -p $@
	cp markdown.html $@/index.html
	cp markdown.css $@

# This target extracts the source files out of the DTX archive.
$(EXTRACTABLES): $(INSTALLER) $(DTXARCHIVE)
	xetex $<
	sed -i \
	    -e 's#(((VERSION)))#$(VERSION)#g' \
	    -e 's#(((LASTMODIFIED)))#$(LASTMODIFIED)#g' \
	    $(INSTALLABLES)

# This target produces the version file.
$(VERSION_FILE): force
	printf '%s (%s)\n' $(VERSION) $(LASTMODIFIED) > $@

# This target produces external Lua libraries.
$(LIBRARIES): force
	$(MAKE) -C libraries $(notdir $@)

# This target typesets the manual.
$(TECHNICAL_DOCUMENTATION): $(DTXARCHIVE) $(TECHNICAL_DOCUMENTATION_RESOURCES)
	latexmk -silent $< || (cat $(basename $@).log 1>&2; exit 1)
	test `tail $(basename $<).log | sed -rn 's/.*\(([0-9]*) pages.*/\1/p'` -gt 150

# These targets typeset the examples.
$(EXAMPLES): $(EXAMPLE_SOURCES) examples/example.tex
	$(MAKE) -C examples $(notdir $@)

examples/example.tex: force
	$(MAKE) -C examples $(notdir $@)

# This target converts the markdown user manual to an HTML page.
%.html: %.md %.css
	awk '{ \
	    filename = gensub(/^\/(.*\.md)$$/, "\\1", "g"); \
	    if(filename != $$0) \
	        system("cat " filename); \
	    else \
	        print($$0); \
	}' <$< | \
	sed -e 's#\\markdownVersion{}#$(VERSION)#g' \
	    -e 's#\\markdownLastModified{}#$(LASTMODIFIED)#g' \
	    -e 's#\\TeX{}#<span class="tex">T<sub>e</sub>X</span>#g' \
	    -e 's#\\LaTeX{}#<span class="latex">L<sup>a</sup>T<sub>e</sub>X</span>#g' \
	    -e 's#\\Hologo{ConTeXt}#Con<span class="tex">T<sub>e</sub>X</span>t#g' \
	    -e 's#\\Opt{\([^}]*\)}#**`\1`**#g' \
	    -e 's#\\pkg{\([^}]*\)}#**`\1`**#g' \
	    -e 's#\\,# #g' \
	    -e 's#\\meta{\([^}]*\)}#\&LeftAngleBracket;*\1*\&RightAngleBracket;#g' \
	    -e 's#\\acro{\([^}]*\)}#<abbr>\1</abbr>#g' \
	    -e 's#😉#<i class="em em-wink"></i>#g' \
	    -e 's#\\envm{\([^}]*\)}#`\1`#g' \
	    -e 's#\\envmdef{\([^}]*\)}#`\1`#g' \
	    -e 's#\\envmref{\([^}]*\)}#`\1`#g' \
	    -e 's#\\m{\([^}]*\)}#`\\\1`#g' \
	    -e 's#\\mdef{\([^}]*\)}#`\\\1`#g' \
	    -e 's#\\mref{\([^}]*\)}#`\\\1`#g' \
	| \
	pandoc -f markdown -t html -N -s --toc --toc-depth=3 --css=$(word 2, $^) >$@

# This pseudo-target runs all the tests in the `tests/` directory.
test:
	$(MAKE) -C tests

# This pseudo-target produces the distribution archives.
dist: implode
	$(MAKE) $(ARCHIVES)
	git clone https://gitlab.com/Lotz/pkgcheck.git
	unzip $(CTANARCHIVE) -d markdown
	for RETRY in $$(seq 1 10); \
	do \
	    if (( RETRY > 1 )); \
	    then \
	        sleep $$((RETRY * 15)); \
	    fi; \
	    if pkgcheck/bin/pkgcheck -d markdown/markdown -T $(TDSARCHIVE) --urlcheck; \
	    then \
	        EXIT_CODE=0; \
	        break; \
	    else \
	        EXIT_CODE=$$?; \
	    fi; \
	done; \
	exit $$EXIT_CODE
	$(MAKE) clean

# This target produces the TeX directory structure archive.
$(TDSARCHIVE): $(DTXARCHIVE) $(INSTALLER) $(INSTALLABLES) $(DOCUMENTATION) $(EXAMPLES_RESOURCES) $(EXAMPLES_SOURCES) $(LIBRARIES)
	@# Installing the macro package.
	mkdir -p tex/generic/markdown tex/luatex/markdown tex/latex/markdown \
	  tex/context/third/markdown scripts/markdown
	cp markdown.lua $(LIBRARIES) tex/luatex/markdown/
	cp markdown-cli.lua scripts/markdown/
	cp markdown.sty markdownthemewitiko_dot.sty markdownthemewitiko_graphicx_http.sty \
	  markdownthemewitiko_tilde.sty tex/latex/markdown/
	cp markdown.tex tex/generic/markdown/
	cp t-markdown.tex tex/context/third/markdown/
	@# Installing the documentation.
	mkdir -p doc/generic/markdown doc/latex/markdown/examples \
	  doc/context/third/markdown/examples
	cp $(DOCUMENTATION) doc/generic/markdown/
	cp examples/context-mkii.tex examples/context-mkiv.tex $(EXAMPLES_RESOURCES) \
	  doc/context/third/markdown/examples/
	cp examples/latex.tex $(EXAMPLES_RESOURCES) doc/latex/markdown/examples/
	@# Installing the sources.
	mkdir -p source/generic/markdown
	cp $(DTXARCHIVE) $(INSTALLER) source/generic/markdown
	zip -r -v -nw $@ doc scripts source tex
	rm -rf doc scripts source tex

# This target produces the distribution archive.
$(DISTARCHIVE): $(EVERYTHING) $(TDSARCHIVE)
	-ln -s . markdown
	zip -MM -r -v -nw $@ $(addprefix markdown/,$(EVERYTHING)) $(TDSARCHIVE)
	rm -f markdown

# This target produces the CTAN archive.
$(CTANARCHIVE): $(DTXARCHIVE) $(INSTALLER) $(DOCUMENTATION) $(EXAMPLES_RESOURCES) $(EXAMPLES_SOURCES) $(LIBRARIES) $(TDSARCHIVE)
	-ln -s . markdown
	zip -MM -r -v -nw $@ $(addprefix markdown/,$(DTXARCHIVE) $(INSTALLER) $(DOCUMENTATION) $(EXAMPLES_RESOURCES) $(EXAMPLES_SOURCES) $(LIBRARIES)) $(TDSARCHIVE)
	rm -f markdown

# This pseudo-target removes any existing auxiliary files and directories.
clean:
	latexmk -c $(DTXARCHIVE)
	rm -f $(AUXFILES)
	rm -rf ${AUXDIRS}
	$(MAKE) -C examples clean

# This pseudo-target removes any makeable files.
implode: clean
	rm -f $(MAKEABLES) $(ARCHIVES)
	$(MAKE) -C examples implode
	$(MAKE) -C libraries implode
