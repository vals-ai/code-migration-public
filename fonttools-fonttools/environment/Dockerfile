# ===========================================================================
# Reference image for fonttools (Python source).
#
# Single-stage: install fonttools from Python-Original/, then use the
# `ttx` console-script entrypoint that pip installs to /usr/local/bin.
# The grader invokes this image directly via docker exec — no
# PYTHON_ENTRYPOINT shim is needed because the reference runs in its
# own container.
# ===========================================================================

FROM python:3.12-slim
# Pick up distro ca-certificates updates (e.g. the eMudhra intermediate CA distrust) before base images refresh.
RUN apt-get update && apt-get install -y --no-install-recommends --only-upgrade ca-certificates && rm -rf /var/lib/apt/lists/*

COPY Python-Original/ /tmp/fonttools-src
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir /tmp/fonttools-src \
    && rm -rf /tmp/fonttools-src

ENTRYPOINT ["ttx"]
