# syntax = docker/dockerfile:1.3-labs

ARG AUXILIARY_FILES="\
    /tmp/* \
    /var/tmp/* \
    /var/log/* \
    /var/lib/apt/lists/* \
    /var/lib/{apt,dpkg,cache,log}/* \
    /usr/share/man/* \
    /usr/share/locale/* \
    /var/cache/apt/* \
"

ARG DEPENDENCIES="\
    ca-certificates \
    curl \
    gawk \
    graphviz \
    m4 \
    moreutils \
    pandoc \
    parallel \
    poppler-utils \
    python3-pygments \
    python3-venv \
    retry \
    unzip \
    wget \
    zip \
"

ARG DEV_DEPENDENCIES="\
    less \
    vim \
"

ARG TEXLIVE_DEPENDENCIES="\
    l3kernel \
    latex \
    latexmk \
    luatex \
"

ARG BINARY_DIR=/usr/local/bin
ARG BUILD_DIR=/git-repo
ARG INSTALL_DIR=/usr/local/texlive/texmf-local
ARG PREINSTALLED_DIR=/usr/local/texlive/*/texmf-dist

ARG FROM_IMAGE=texlive/texlive
ARG TEXLIVE_TAG=latest
ARG DEV_IMAGE=false

FROM $FROM_IMAGE:$TEXLIVE_TAG as build

ARG DEPENDENCIES
ARG TEXLIVE_DEPENDENCIES

ARG BUILD_DIR
ARG INSTALL_DIR
ARG PREINSTALLED_DIR

ARG TEXLIVE_TAG
ARG DEV_IMAGE

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm
ENV TEXMFLOCAL=${INSTALL_DIR}

COPY . ${BUILD_DIR}/

RUN <<EOF

set -o errexit
set -o nounset
set -o xtrace

# Install OS dependencies
apt-get -qy update
apt-get -qy install --no-install-recommends ${DEPENDENCIES}

# Update packages in non-historic TeX Live versions
if echo ${TEXLIVE_TAG} | grep -q latest
then
  retry -t 30 -d 60 tlmgr update --self --all
elif echo ${TEXLIVE_TAG} | grep -q pretest
then
  retry -t 30 -d 60 tlmgr update --self --all --repository ftp://ftp.cstug.cz/pub/tex/local/tlpretest/
fi

# Install basic TeX Live dependencies
if echo ${TEXLIVE_TAG} | grep -q latest-minimal
then
  retry -t 30 -d 60 tlmgr install ${TEXLIVE_DEPENDENCIES}
  tlmgr path add
fi

# Uninstall the distribution Markdown package
rm -rfv ${PREINSTALLED_DIR}/tex/luatex/markdown/
rm -rfv ${PREINSTALLED_DIR}/scripts/markdown/
rm -rfv ${PREINSTALLED_DIR}/tex/generic/markdown/
rm -rfv ${PREINSTALLED_DIR}/tex/latex/markdown/
rm -rfv ${PREINSTALLED_DIR}/tex/context/third/markdown/

# Install the current Markdown package
make -C ${BUILD_DIR} implode
make -C ${BUILD_DIR} base
mkdir -p                                                     ${INSTALL_DIR}/tex/luatex/markdown/
cp ${BUILD_DIR}/markdown.lua                                 ${INSTALL_DIR}/tex/luatex/markdown/
cp ${BUILD_DIR}/libraries/markdown-tinyyaml.lua              ${INSTALL_DIR}/tex/luatex/markdown/
mkdir -p                                                     ${INSTALL_DIR}/scripts/markdown/
cp ${BUILD_DIR}/markdown-cli.lua                             ${INSTALL_DIR}/scripts/markdown/
mkdir -p                                                     ${INSTALL_DIR}/tex/generic/markdown/
cp ${BUILD_DIR}/markdown.tex                                 ${INSTALL_DIR}/tex/generic/markdown/
cp ${BUILD_DIR}/markdownthemewitiko_tilde.tex                ${INSTALL_DIR}/tex/generic/markdown/
cp ${BUILD_DIR}/markdownthemewitiko_markdown_defaults.tex    ${INSTALL_DIR}/tex/generic/markdown/
mkdir -p                                                     ${INSTALL_DIR}/tex/latex/markdown/
cp ${BUILD_DIR}/markdown.sty                                 ${INSTALL_DIR}/tex/latex/markdown/
cp ${BUILD_DIR}/markdownthemewitiko_dot.sty                  ${INSTALL_DIR}/tex/latex/markdown/
cp ${BUILD_DIR}/markdownthemewitiko_graphicx_http.sty        ${INSTALL_DIR}/tex/latex/markdown/
cp ${BUILD_DIR}/markdownthemewitiko_markdown_defaults.sty    ${INSTALL_DIR}/tex/latex/markdown/
mkdir -p                                                     ${INSTALL_DIR}/tex/context/third/markdown/
cp ${BUILD_DIR}/t-markdown.tex                               ${INSTALL_DIR}/tex/context/third/markdown/
cp ${BUILD_DIR}/t-markdownthemewitiko_markdown_defaults.tex  ${INSTALL_DIR}/tex/context/third/markdown/

# Generate the ConTeXt file database
if test ${DEV_IMAGE} != true
then
  mtxrun --generate
  texlua /usr/bin/mtxrun.lua --luatex --generate
  context --make
  context --luatex --make
fi

# Reindex the TeX directory structure
texhash

# Produce the complete distribution archive of the Markdown package
make -C ${BUILD_DIR} dist NO_DOCUMENTATION=${DEV_IMAGE}
mkdir ${BUILD_DIR}/dist
unzip ${BUILD_DIR}/markdown.tds.zip -d ${BUILD_DIR}/dist

EOF


FROM $FROM_IMAGE:$TEXLIVE_TAG

ARG AUXILIARY_FILES
ARG DEPENDENCIES
ARG DEV_DEPENDENCIES

ARG BINARY_DIR
ARG BUILD_DIR
ARG INSTALL_DIR
ARG PREINSTALLED_DIR

ARG TEXLIVE_TAG
ARG DEV_IMAGE

LABEL authors="Vít Starý Novotný <witiko@mail.muni.cz>"

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm
ENV TEXMFLOCAL=${INSTALL_DIR}

COPY --from=build ${BUILD_DIR}/DEPENDS.txt ${BUILD_DIR}/DEPENDS.txt
COPY --from=build ${BUILD_DIR}/tests/DEPENDS.txt ${BUILD_DIR}/tests/DEPENDS.txt

RUN <<EOF

set -o errexit
set -o nounset
set -o xtrace

# Install dependencies, but this time we clean up after ourselves
apt-get -qy update
apt-get -qy install --no-install-recommends ${DEPENDENCIES}
if [ ${DEV_IMAGE} = true ]
then
  apt-get -qy install --no-install-recommends ${DEV_DEPENDENCIES}
fi
apt-get -qy autoclean
apt-get -qy clean
apt-get -qy autoremove --purge
rm -rfv ${AUXILIARY_FILES}

# Update packages in non-historic TeX Live versions
if echo ${TEXLIVE_TAG} | grep -q latest
then
  retry -t 30 -d 60 tlmgr update --self --all
elif echo ${TEXLIVE_TAG} | grep -q pretest
then
  retry -t 30 -d 60 tlmgr update --self --all --repository ftp://ftp.cstug.cz/pub/tex/local/tlpretest/
fi

# Install TeX Live dependencies
if echo ${TEXLIVE_TAG} | grep -q latest-minimal
then
  retry -t 30 -d 60 tlmgr install $(awk '{ print $2 }' ${BUILD_DIR}/DEPENDS.txt ${BUILD_DIR}/tests/DEPENDS.txt | sort -u)
  tlmgr path add
fi

# Uninstall the distribution Markdown package
rm -rfv ${PREINSTALLED_DIR}/tex/luatex/markdown/
rm -rfv ${PREINSTALLED_DIR}/scripts/markdown/
rm -rfv ${PREINSTALLED_DIR}/tex/generic/markdown/
rm -rfv ${PREINSTALLED_DIR}/tex/latex/markdown/
rm -rfv ${PREINSTALLED_DIR}/tex/context/third/markdown/

EOF

# Install the Markdown package
COPY --from=build ${BUILD_DIR}/dist ${INSTALL_DIR}/

COPY <<EOF ${BINARY_DIR}/markdown-cli
#!/bin/bash
texlua ${INSTALL_DIR}/scripts/markdown/markdown-cli.lua \"\$@\"
echo
EOF

RUN <<EOF

set -o errexit
set -o nounset
set -o xtrace

# Make the markdown-cli script executable
chmod +x ${BINARY_DIR}/markdown-cli

# Generate the ConTeXt file database
if echo ${TEXLIVE_TAG} | grep -q latest-minimal
then
  # A temporary fix for ConTeXt, see <https://gitlab.com/islandoftex/images/texlive/-/issues/30>.
  sed -i '/package.loaded\["data-ini"\]/a if os.selfpath then environment.ownbin=lfs.symlinktarget(os.selfpath..io.fileseparator..os.selfname);environment.ownpath=environment.ownbin:match("^.*"..io.fileseparator) else environment.ownpath=kpse.new("luatex"):var_value("SELFAUTOLOC");environment.ownbin=environment.ownpath..io.fileseparator..(arg[-2] or arg[-1] or arg[0] or "luatex"):match("[^"..io.fileseparator.."]*$") end' /usr/bin/mtxrun.lua || true
fi
mtxrun --generate
texlua /usr/bin/mtxrun.lua --luatex --generate
context --make
context --luatex --make

# Reindex the TeX directory structure
texhash

# Remove the build directory
rm -rfv ${BUILD_DIR}

EOF
