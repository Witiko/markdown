.PHONY: all base clean implode dist test force \
  docker-image docker-push-temporary-tag docker-print-temporary-tag \
  docker-push-release-tag preview check-line-length

SHELL=/bin/bash

AUXFILES=markdown.bbl markdown.cb markdown.cb2 markdown.glo markdown.bbl \
  markdown.hd markdown.run.xml markdown.markdown.in markdown.markdown.lua \
  markdown.markdown.out markdown-interfaces.md markdown-miscellanea.md \
  markdown-options.md markdown-tokens.md $(TECHNICAL_DOCUMENTATION_RESOURCES) \
  $(VERSION_FILE) $(RAW_DEPENDENCIES) markdown-transcluded.md
AUXDIRS=_minted-markdown _markdown_markdown markdown
TDSARCHIVE=markdown.tds.zip
CTANARCHIVE=markdown.ctan.zip
DISTARCHIVE=markdown.zip
ARCHIVES=$(TDSARCHIVE) $(CTANARCHIVE) $(DISTARCHIVE)
EXAMPLES_RESOURCES=examples/example.md examples/scientists.csv
EXAMPLES_SOURCES=examples/context-mkiv.tex examples/context-lmtx.tex \
  examples/latex-pdftex.tex examples/latex-xetex.tex examples/latex-luatex.tex \
  examples/optex.tex
EXAMPLES=examples/context-mkiv.pdf examples/context-lmtx.pdf \
  examples/latex-pdftex.pdf examples/latex-xetex.pdf examples/latex-luatex.pdf \
  examples/latex-tex4ht.html examples/latex-tex4ht.css \
  examples/optex.pdf
TESTS=tests/test.sh tests/test.py tests/requirements.txt tests/support/*.tex \
  tests/templates/*/*/head.tex.m4 tests/templates/*/*/body.tex.m4 \
  tests/templates/*/*/foot.tex.m4 tests/templates/*/COMMANDS.m4 tests/testfiles/*/*/*.test
MAKES=Makefile $(addsuffix /Makefile, $(SUBDIRECTORIES)) latexmkrc
ROOT_README=README.md markdown.png
READMES=$(ROOT_README) LICENSE examples/README.md tests/README.md \
  tests/support/README.md tests/templates/README.md tests/testfiles/README.md \
  tests/templates/*/README.md tests/testfiles/*/README.md tests/testfiles/*/*/README.md
VERSION_FILE=VERSION
CHANGES_FILE=CHANGES.md
DTXARCHIVE=markdown.dtx
INSTALLER=markdown.ins docstrip.cfg
TECHNICAL_DOCUMENTATION_RESOURCES=markdown.bib markdown-figure-block-diagram.tex \
  markdownthemewitiko_markdown_techdoc.sty
RAW_DEPENDENCIES=DEPENDS-raw.txt
DEPENDENCIES=DEPENDS.txt
UNICODE_DATA=UnicodeData.txt CaseFolding.txt DerivedNormalizationProps.txt \
  HangulSyllableType.txt
TECHNICAL_DOCUMENTATION=markdown.pdf
MARKDOWN_USER_MANUAL_INPUTS=markdown-interfaces.md markdown-options.md markdown-tokens.md
MARKDOWN_USER_MANUAL=markdown.md markdown.css
HTML_USER_MANUAL=markdown.html markdown.css
MAN_PAGES=markdown2tex.1
USER_MANUAL=$(MARKDOWN_USER_MANUAL) $(HTML_USER_MANUAL)
DOCUMENTATION=$(TECHNICAL_DOCUMENTATION) $(HTML_USER_MANUAL) $(ROOT_README) $(VERSION_FILE) \
  $(CHANGES_FILE) $(DEPENDENCIES)
GENERATORS=markdown-unicode-data-generator.lua
INSTALLABLES=markdown.lua markdown-parser.lua markdown-cli.lua markdown2tex.lua \
  markdown-unicode-data.lua \
  markdown.tex markdown.sty t-markdown.tex \
  markdownthemewitiko_markdown_defaults.tex \
  markdownthemewitiko_markdown_defaults.sty \
  t-markdownthemewitiko_markdown_defaults.tex
EXTRACTABLES=$(INSTALLABLES) $(MARKDOWN_USER_MANUAL) $(TECHNICAL_DOCUMENTATION_RESOURCES) \
  $(RAW_DEPENDENCIES) $(MAN_PAGES) $(GENERATORS)
MAKEABLES=$(TECHNICAL_DOCUMENTATION) $(USER_MANUAL) $(INSTALLABLES) $(EXAMPLES) $(DEPENDENCIES)
RESOURCES=$(DOCUMENTATION) $(MAN_PAGES) $(EXAMPLES_RESOURCES) $(EXAMPLES_SOURCES) $(EXAMPLES) \
  $(MAKES) $(READMES) $(INSTALLER) $(DTXARCHIVE) $(TESTS)
EVERYTHING=$(RESOURCES) $(INSTALLABLES)
GITHUB_PAGES=gh-pages

ifeq ($(NO_DOCUMENTATION), true)
  EXAMPLES=
  TECHNICAL_DOCUMENTATION=
  MARKDOWN_USER_MANUAL=
  HTML_USER_MANUAL=
endif

VERSION=$(shell git describe --tags --always --long --exclude latest)
SHORTVERSION=$(shell git describe --tags --always --long --exclude latest | sed 's/-.*//')
LASTMODIFIED=$(shell git log -1 --date=format:%Y-%m-%d --format=%ad)

ifndef DOCKER_TEXLIVE_TAG
	DOCKER_TEXLIVE_TAG=latest
endif
ifndef DOCKER_DEV_IMAGE
	DOCKER_DEV_IMAGE=false
endif
ifeq ($(DOCKER_DEV_IMAGE), true)
	DOCKER_TAG_POSTFIX=-no_docs
endif
DOCKER_TEMPORARY_IMAGE=ghcr.io/witiko/markdown
DOCKER_TEMPORARY_TAG=$(VERSION)-$(DOCKER_TEXLIVE_TAG)$(DOCKER_TAG_POSTFIX)
DOCKER_RELEASE_IMAGE=witiko/markdown
DOCKER_RELEASE_TAG=$(DOCKER_TEXLIVE_TAG)$(DOCKER_TAG_POSTFIX)

PANDOC_INPUT_FORMAT=markdown+tex_math_single_backslash-raw_tex

# This is the default pseudo-target. It typesets the manual,
# the examples, and extracts the package files.
all: $(MAKEABLES)
	$(MAKE) clean

# This pseudo-target extracts the source files out of the DTX archive.
base: $(EXTRACTABLES)
	$(MAKE) clean

# This pseudo-target builds a witiko/markdown Docker image.
docker-image:
	DOCKER_BUILDKIT=1 docker build --pull --build-arg TEXLIVE_TAG=$(DOCKER_TEXLIVE_TAG) \
	                               --build-arg DEV_IMAGE=$(DOCKER_DEV_IMAGE) \
	                               -t $(DOCKER_TEMPORARY_IMAGE):$(DOCKER_TEMPORARY_TAG) .

# This pseudo-targed pushes the built witiko/markdown Docker image to
# a Docker registry with a temporary tag.
docker-push-temporary-tag:
	docker push $(DOCKER_TEMPORARY_IMAGE):$(DOCKER_TEMPORARY_TAG)

# This pseudo-target prints the temporary tag that we used to tag the
# built witiko/markdown Docker image before pushing it to the Docker
# registry.
docker-print-temporary-tag:
	@echo $(DOCKER_TEMPORARY_TAG)

# This pseudo-targed pushes the built witiko/markdown Docker image to
# a Docker registry with a release tag.
docker-push-release-tag:
	docker pull $(DOCKER_TEMPORARY_IMAGE):$(DOCKER_TEMPORARY_TAG)
	docker tag $(DOCKER_TEMPORARY_IMAGE):$(DOCKER_TEMPORARY_TAG) \
	           $(DOCKER_RELEASE_IMAGE):$(DOCKER_TEMPORARY_TAG)
	docker tag $(DOCKER_TEMPORARY_IMAGE):$(DOCKER_TEMPORARY_TAG) \
	           $(DOCKER_RELEASE_IMAGE):$(DOCKER_RELEASE_TAG)
	docker push $(DOCKER_RELEASE_IMAGE):$(DOCKER_TEMPORARY_TAG)
	docker push $(DOCKER_RELEASE_IMAGE):$(DOCKER_RELEASE_TAG)

# This targets produces a directory with files for the GitHub Pages service.
$(GITHUB_PAGES): $(HTML_USER_MANUAL)
	mkdir -p $@
	cp markdown.html $@/index.html
	cp markdown.css $@

# This target downloads Unicode Character Database files.
$(UNICODE_DATA):
	wget https://www.unicode.org/Public/16.0.0/ucd/$@

# This target extracts the source files out of the DTX archive.
$(EXTRACTABLES): $(INSTALLER) $(DTXARCHIVE) $(UNICODE_DATA)
	luatex $<
	sed -i '1i#!/usr/bin/env texlua' markdown-cli.lua markdown2tex.lua
	chmod +x markdown-cli.lua markdown2tex.lua
	texlua markdown-unicode-data-generator.lua >> markdown-unicode-data.lua
	sed -i \
	    -e 's#(((VERSION)))#$(VERSION)#g' \
	    -e 's#(((SHORTVERSION)))#$(SHORTVERSION)#g' \
	    -e 's#(((LASTMODIFIED)))#$(LASTMODIFIED)#g' \
	    $(INSTALLABLES) \
	    $(MAN_PAGES)
	sed -i \
	    -e '/\\ExplSyntaxOff/ { N; /\\ExplSyntaxOn/d; }' \
	    $(INSTALLABLES)

# This target produces the file with package dependencies.
$(DEPENDENCIES): $(RAW_DEPENDENCIES)
	( \
	  sed -n '/^#/ ! { s/\s*#.*//; p }' $(RAW_DEPENDENCIES); \
	) | sort -u -o $(DEPENDENCIES)

# This target produces the version file.
$(VERSION_FILE): force
	printf '%s (%s)\n' $(VERSION) $(LASTMODIFIED) > $@

# This target typesets the manual.
$(TECHNICAL_DOCUMENTATION): $(DTXARCHIVE) $(TECHNICAL_DOCUMENTATION_RESOURCES)
	latexmk -silent $< || (cat $(basename $@).log 1>&2; exit 1)
	test `tail $(basename $<).log | sed -rn 's/.*\(([0-9]*) pages.*/\1/p'` -ge 450

# This pseudotarget continuously typesets the manual.
preview: $(DTXARCHIVE) $(TECHNICAL_DOCUMENTATION_RESOURCES)
	-mkdir markdown/
	-ln -s ../markdown.tex markdown/markdown.tex
	latexmk -silent -pvc $<

# These targets typeset the examples.
$(EXAMPLES): $(EXAMPLE_SOURCES) examples/example.tex
	if [[ '$(NO_DOCUMENTATION)' != true ]]; \
	then \
	  $(MAKE) -C examples $(notdir $@); \
	fi

examples/example.tex: force
	if [[ '$(NO_DOCUMENTATION)' != true ]]; \
	then \
	  $(MAKE) -C examples $(notdir $@); \
	fi

# These targets convert the markdown user manual to an HTML page.
markdown-transcluded.md: markdown.md $(MARKDOWN_USER_MANUAL_INPUTS) $(DEPENDENCIES)
	transclude() { \
	  awk '{ \
	    filename = gensub(/^\/(.*\.(md|txt))$$/, "\\1", "g"); \
	    if(filename != $$0 && filename != "nested.md") \
	        system("cat " filename); \
	    else \
	        print($$0); \
	  }'; \
	}; \
	for FILE in $(MARKDOWN_USER_MANUAL_INPUTS); \
	do \
		transclude < "$$FILE" | sponge "$$FILE"; \
	done; \
	transclude <"$<" >"$@"
	rm $^

%.html: %-transcluded.md %.css
	sed -e 's#\\markdownVersion{}#$(VERSION)#g' \
	    -e 's#\\markdownShortVersion{}#$(SHORTVERSION)#g' \
	    -e 's#\\markdownLastModified{}#$(LASTMODIFIED)#g' \
	    -e 's#\\TeX{}#<span class="tex">T<sub>e</sub>X</span>#g' \
	    -e 's#\\LaTeX{}#<span class="latex">L<sup>a</sup>T<sub>e</sub>X</span>#g' \
	    -e 's#\\Hologo{ConTeXt}#Con<span class="tex">T<sub>e</sub>X</span>t#g' \
	    -e 's#\\Hologo{XeTeX}#Xe<span class="tex">T<sub>e</sub>X</span>t#g' \
	    -e 's#\\\(Opt\|pkg\){\([^}]*\)}#<code><strong>\2</strong></code>#g' \
	    -e 's#\\,# #g' \
	    -e 's#\\meta{\([^}]*\)}#\&LeftAngleBracket;*\1*\&RightAngleBracket;#g' \
	    -e 's#\\acro{\([^}]*\)}#<abbr>\1</abbr>#g' \
	    -e 's#😉#<i class="em em-wink"></i>#g' \
	    -e 's#\\\(\(env\|lua\)\?m\(def\|ref\)\?\){\([^}]*\)}#<code>\4</code>#g' \
	    -e 's#</code><code>##g' \
	<$< | \
	pandoc -f $(PANDOC_INPUT_FORMAT) -t html -N -s --toc --toc-depth=3 --fail-if-warnings --css=$(word 2, $^) >$@

# This pseudo-target runs all the tests in the `tests/` directory.
test:
	$(MAKE) -C tests

# This pseudo-target produces the distribution archives.
dist: implode
	$(MAKE) $(ARCHIVES)
	if [[ '$(NO_DOCUMENTATION)' != true ]]; \
	then \
	    set -e -o xtrace; \
	    unzip $(CTANARCHIVE) -d markdown; \
	    pkgcheck -d markdown/markdown -T $(TDSARCHIVE); \
	fi
	$(MAKE) clean

# This target produces the TeX directory structure archive.
$(TDSARCHIVE): $(DTXARCHIVE) $(INSTALLER) $(INSTALLABLES) $(DOCUMENTATION) $(MAN_PAGES) $(EXAMPLES_RESOURCES) $(EXAMPLES_SOURCES)
	@# Installing the macro package.
	mkdir -p tex/generic/markdown tex/luatex/markdown tex/latex/markdown \
	  tex/context/third/markdown scripts/markdown
	cp markdown.lua markdown-parser.lua markdown-unicode-data.lua \
	  tex/luatex/markdown/
	cp markdown-cli.lua markdown2tex.lua scripts/markdown/
	cp markdown.tex markdownthemewitiko_markdown_defaults.tex tex/generic/markdown/
	cp markdown.sty markdownthemewitiko_markdown_defaults.sty tex/latex/markdown/
	cp t-markdown.tex t-markdownthemewitiko_markdown_defaults.tex tex/context/third/markdown/
	@# Installing the documentation.
	mkdir -p doc/generic/markdown doc/man/man1 doc/latex/markdown/examples \
	  doc/context/third/markdown/examples doc/optex/markdown/examples
	cp $(DOCUMENTATION) doc/generic/markdown/
	cp $(MAN_PAGES) doc/man/man1/
	cp examples/context-mkiv.tex $(EXAMPLES_RESOURCES) \
	  doc/context/third/markdown/examples/
	cp -L examples/latex-*.tex $(EXAMPLES_RESOURCES) doc/latex/markdown/examples/
	cp -L examples/optex.tex $(EXAMPLES_RESOURCES) doc/optex/markdown/examples/
	@# Installing the sources.
	mkdir -p source/generic/markdown
	cp $(DTXARCHIVE) $(INSTALLER) source/generic/markdown
	zip -MM -r -v -nw $@ doc scripts source tex
	rm -rf doc scripts source tex

# This target produces the distribution archive.
$(DISTARCHIVE): $(EVERYTHING) $(TDSARCHIVE)
	-ln -s . markdown
	zip -MM -r -v -nw --symlinks $@ $(addprefix markdown/,$(EVERYTHING)) $(TDSARCHIVE)
	rm -f markdown

# This target produces the CTAN archive.
$(CTANARCHIVE): $(DTXARCHIVE) $(INSTALLER) $(DOCUMENTATION) $(EXAMPLES_RESOURCES) $(EXAMPLES_SOURCES) $(TDSARCHIVE)
	-ln -s . markdown
	zip -MM -r -v -nw --symlinks $@ $(addprefix markdown/,$(DTXARCHIVE) $(INSTALLER) $(DOCUMENTATION) $(EXAMPLES_RESOURCES) $(EXAMPLES_SOURCES)) $(TDSARCHIVE)
	rm -f markdown

# This pseudo-target removes any existing auxiliary files and directories.
clean:
	latexmk -c $(DTXARCHIVE)
	rm -f $(AUXFILES)
	rm -rf ${AUXDIRS}
	$(MAKE) -C examples clean

# This pseudo-target removes any makeable files.
implode: clean
	rm -f $(MAKEABLES) $(ARCHIVES) $(GENERATORS)
	$(MAKE) -C examples implode

# This pseudo-target checks that the length of lines in the source files.
check-line-length: $(INSTALLABLES) $(GENERATORS)
	! grep -n -E '^.{73,}$$' $(filter-out markdown-unicode-data.lua,$^)

# This pseudo-target checks for tabs and trailing spaces in the source files.
check-tabs-and-spaces: $(DTXARCHIVE)
	! grep -n -P '\t|\s+$$' $<
