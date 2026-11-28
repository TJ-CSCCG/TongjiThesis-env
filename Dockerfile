FROM texlive/texlive:latest-minimal

LABEL org.opencontainers.image.source="https://github.com/TJ-CSCCG/TongjiThesis-env"
LABEL org.opencontainers.image.description="Docker environment for TongjiThesis"

ENV WRITE_ENV=/opt/TongjiThesis

# The TeX Live packages are the ones the released template lists in
# TJ-CSCCG/TongjiThesis's .github/tl-packages.txt (one name per line, # starts a
# comment), read at build time so the image and the template never drift. The
# CI workflow compiles the released template in the image to catch a gap.
ADD https://raw.githubusercontent.com/TJ-CSCCG/TongjiThesis/master/.github/tl-packages.txt /opt/tl-packages.txt

# Sync database, install packages (tlmgr resolves dependencies automatically),
# then verify key binaries. mirror.ctan.org sends each tlmgr run to a random
# mirror, and some mirrors lag or fail TLS, so a failed attempt is retried and
# lands on another mirror; the third failure fails the build.
RUN for attempt in 1 2 3; do \
      tlmgr update --self && tlmgr install $(sed 's/#.*//' /opt/tl-packages.txt) && break; \
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
