FROM ubuntu:latest

# Docker image: tut-env:v1
LABEL organization="TJ-CSCCG"
LABEL maintainer="skyleaworlder"
LABEL version="v1"

# WRITE_ENV is folder to compile document
#   by compile function, all contents will be copied here
ENV WRITE_ENV=/opt/TongjiThesis
ENV TL_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/CTAN
ENV TL_PROFILE_PATH=/tmp
ENV TL_DIR=/tmp/texlive
ENV TL_BIN=${TL_DIR}/bin/x86_64-linux
ENV TL_PACKAGES="adjustbox algorithmicx algorithms biber biblatex biblatex-gb7714-2015 bibtex booktabs caption carlisle cases catchfile chinese-jfm chngcntr cleveref collectbox ctex dvips enumitem environ extarrows fancybox fancyhdr fancyvrb float framed fvextra gbt7714 gsftopk helvetic hologo ifplatform lastpage latexmk lineno minted multirow mwe natbib needspace newtx nth oberdiek pdftexcmds realscripts rsfs setspace siunitx subfig tcolorbox texcount texliveonfly threeparttable threeparttablex times titling tocloft trimspaces txfonts ucs upquote was xcolor xecjk xstring zhnumber"
ENV PATH=${PATH}:${TL_BIN}
WORKDIR /opt

# install necessary packages
# thank sjtug & tuna
RUN sed -i 's/http:\/\/archive.ubuntu.com/http:\/\/mirror.sjtu.edu.cn/g' /etc/apt/sources.list && \
    apt-get update
RUN apt-get install -y git \
        perl \
        wget \
        libfontconfig \
        python3 \
        pipx && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
RUN pipx install Pygments -i https://pypi.tuna.tsinghua.edu.cn/simple

# download & install TeXLive
COPY texlive.profile ${TL_PROFILE_PATH}
RUN wget ${TL_MIRROR}/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar -xzf install-tl-unx.tar.gz && \
    cd install-tl-20* && \
    ./install-tl --profile ${TL_PROFILE_PATH}/texlive.profile && \
    rm -rf install-tl-* && \
    tlmgr option repository ${TL_MIRROR}/systems/texlive/tlnet && \
    tlmgr install ${TL_PACKAGES} && \
    tlmgr update --self --all --no-auto-install && \
    tlmgr path add

# create folder where compile function builds output file
RUN mkdir TongjiThesis
WORKDIR ${WRITE_ENV}

CMD [ "/bin/bash" ]
