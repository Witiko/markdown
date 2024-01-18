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
    ruby \
    unzip \
    wget \
    zip \
"

ARG DEV_DEPENDENCIES="\
    less \
    vim \
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

ARG BUILD_DIR
ARG INSTALL_DIR
ARG PREINSTALLED_DIR

ARG DEV_IMAGE

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm
ENV TEXMFLOCAL=${INSTALL_DIR}

COPY . ${BUILD_DIR}/

RUN <<EOF

set -o errexit
set -o nounset
set -o xtrace

# Install dependencies
apt-get -qy update
apt-get -qy install --no-install-recommends ${DEPENDENCIES}

# Generate the ConTeXt file database
mtxrun --generate

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
mtxrun --generate

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

ARG DEV_IMAGE

LABEL authors="Vít Starý Novotný <witiko@mail.muni.cz>"

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm
ENV TEXMFLOCAL=${INSTALL_DIR}

RUN <<EOF

set -o errexit
set -o nounset
set -o xtrace

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

# Generate the ConTeXt file database
mtxrun --generate

# Reindex the TeX directory structure
texhash

EOF
