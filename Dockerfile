FROM texlive/texlive:latest-minimal

LABEL org.opencontainers.image.source="https://github.com/TJ-CSCCG/TongjiThesis-env"
LABEL org.opencontainers.image.description="Docker environment for TongjiThesis"

ENV WRITE_ENV=/opt/TongjiThesis

# Package list mirrors TL_PACKAGES in TongjiThesis's .github/workflows/test.yaml;
# the test workflow compiles the template in the image to catch a missing one.
# Uses TeX Live names (not CTAN): subcaption.sty is part of "caption", and
# tabularx.sty and xspace.sty are part of "tools".
ENV TL_PACKAGES="\
    adjustbox algorithm2e algorithmicx algorithms alphalph biber \
    biblatex biblatex-gb7714-2015 bibtex booktabs caption \
    carlisle cases catchfile chinese-jfm chngcntr circledsteps \
    cleveref collectbox ctex dvips emptypage enumitem environ \
    eso-pic extarrows fancyhdr fancyvrb fandol float fontaxes \
    framed fvextra gbt7714 gsftopk haranoaji helvetic hologo \
    ifoddpage ifplatform lastpage latexmk lineno listings minted \
    multirow mwe natbib needspace newtx nth oberdiek pdftexcmds \
    pgf pict2e picture realscripts relsize rsfs setspace siunitx \
    tcolorbox tex-gyre texcount texliveonfly \
    threeparttable threeparttablex times titling tocloft \
    tools trimspaces txfonts ucs upquote was xcolor xecjk xpatch \
    xstring zhnumber"

# Sync database, install packages (tlmgr resolves dependencies automatically),
# then verify key binaries. mirror.ctan.org sends each tlmgr run to a random
# mirror, and some mirrors lag or fail TLS, so a failed attempt is retried and
# lands on another mirror; the third failure fails the build.
RUN for attempt in 1 2 3; do \
      tlmgr update --self && tlmgr install ${TL_PACKAGES} && break; \
      if [ "$attempt" = 3 ]; then exit 1; fi; \
      echo "tlmgr failed on attempt $attempt; retrying on another mirror"; sleep 10; \
    done \
  && tlmgr path add \
  && xelatex --version && latexmk --version && biber --version

# Pygments for minted code highlighting
RUN apt-get update \
  && apt-get install -y --no-install-recommends python3-pygments \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${WRITE_ENV}
WORKDIR ${WRITE_ENV}

CMD [ "/bin/bash" ]
