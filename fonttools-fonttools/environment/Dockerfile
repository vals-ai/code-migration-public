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

COPY Python-Original/ /tmp/fonttools-src
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir /tmp/fonttools-src \
    && rm -rf /tmp/fonttools-src

ENTRYPOINT ["ttx"]
