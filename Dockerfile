FROM texlive/texlive:latest-minimal

LABEL org.opencontainers.image.source="https://github.com/TJ-CSCCG/TongjiThesis-env"
LABEL org.opencontainers.image.description="Docker environment for TongjiThesis"

ENV WRITE_ENV=/opt/TongjiThesis

# Package list mirrors .github/workflows/test.yaml in TongjiThesis
# Uses TeX Live names (not CTAN); subcaption.sty is part of "caption"
ENV TL_PACKAGES="\
    adjustbox algorithmicx algorithms \
    biber biblatex biblatex-gb7714-2015 bibtex booktabs \
    caption carlisle cases catchfile chinese-jfm chngcntr \
    circledsteps cleveref collectbox ctex dvips \
    enumitem environ eso-pic extarrows \
    fancyhdr fancyvrb float framed fvextra \
    gbt7714 gsftopk helvetic hologo ifplatform \
    lastpage latexmk lineno listings minted multirow mwe \
    natbib needspace newtx nth oberdiek \
    pdftexcmds pgf pict2e picture realscripts rsfs \
    setspace siunitx tcolorbox texcount texliveonfly \
    threeparttable threeparttablex times titling tocloft \
    trimspaces txfonts ucs upquote was \
    xcolor xecjk xpatch xstring zhnumber"

# Sync database, install packages (tlmgr resolves dependencies automatically),
# then verify key binaries
RUN tlmgr update --self \
  && tlmgr install ${TL_PACKAGES} \
  && tlmgr path add \
  && xelatex --version && latexmk --version && biber --version

# Pygments for minted code highlighting
RUN apt-get update \
  && apt-get install -y --no-install-recommends python3-pygments \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${WRITE_ENV}
WORKDIR ${WRITE_ENV}

CMD [ "/bin/bash" ]
