# Reference image for the OpenImageIO `iinfo` migration task.
#
# Builds the upstream C++ `iinfo` binary from C++-Original/ and exposes it
# as the image entrypoint. The grader builds and runs this image directly
# as one half of the dual-container test harness.
#
# Build context: the task root (data/AcademySoftwareFoundation-OpenImageIO/).

FROM ubuntu:24.04 AS builder
# [oom-mitigation] cap build parallelism to 4 so heavy C/C++ builds fit the 16GB eval sandbox (no extra RAM)
ENV CMAKE_BUILD_PARALLEL_LEVEL=4 MAKEFLAGS=-j4 CARGO_BUILD_JOBS=4
RUN printf '#!/bin/sh\necho 4\n' > /usr/local/bin/nproc && chmod 0755 /usr/local/bin/nproc


# Coverage instrumentation hook. Empty by default → no-op for normal builds.
# The coverage adapter overrides via --build-arg to inject --coverage flags
# without per-task spec changes (see Dockerfile.reference.template).
ARG CFLAGS=""
ARG CXXFLAGS=""
ARG LDFLAGS=""
ENV CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"
ARG COVERAGE_CXX_WRAP=""
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        ninja-build \
        git \
        ca-certificates \
        pkg-config \
        zlib1g-dev \
        libtiff-dev \
        libpng-dev \
        libjpeg-turbo8-dev \
        libopenexr-dev \
        libimath-dev \
        libwebp-dev \
        libfreetype-dev \
        libgif-dev \
        libfmt-dev \
        libpugixml-dev \
        libboost-dev \
        libsquish-dev \
    && rm -rf /var/lib/apt/lists/*

# Coverage build: install clang + llvm so we can run with llvm-cov gcov. Why
# clang? gcc 13's libstdc++ headers inline differently across TUs, causing
# geninfo to abort with "mismatched exception tag" errors that can't be
# suppressed without modifying shared adapter code. clang's profile data is
# processed via llvm-cov gcov and doesn't trip that path. No-op for normal
# builds (COVERAGE_CXX_WRAP empty).
RUN if [ -n "$COVERAGE_CXX_WRAP" ]; then \
        apt-get update && apt-get install -y --no-install-recommends \
            clang llvm libclang-rt-18-dev && \
        rm -rf /var/lib/apt/lists/*; \
    fi

# Coverage compiler shim. Catches build systems that don't honor LDFLAGS env
# (e.g. yosys's hand-rolled make uses LINKFLAGS internally). When the coverage
# adapter passes --build-arg COVERAGE_CXX_WRAP=--coverage, install
# /usr/local/bin shims that prepend the wrap flag to every cc/c++/clang/g++
# invocation. PATH order means shims win. Empty default → no-op.
RUN if [ -n "$COVERAGE_CXX_WRAP" ]; then \
        for c in cc gcc clang c++ g++ clang++; do \
            real=$(command -v "$c" 2>/dev/null) || continue; \
            [ "$real" = "/usr/local/bin/$c" ] && continue; \
            { echo "#!/bin/sh"; echo "exec \"$real\" $COVERAGE_CXX_WRAP \"\$@\""; } > "/usr/local/bin/$c"; \
            chmod +x "/usr/local/bin/$c"; \
        done; \
    fi

WORKDIR /build/src
COPY C++-Original/ /build/src/

# Build with only the formats / features needed for `iinfo`. Tools and tests
# are built; Python bindings, docs, OpenVDB, FFmpeg, RAW, HEIF, JPEG-XL,
# DCMTK, Ptex, OpenJPEG, and the iv viewer are disabled to keep the build
# tractable. Missing / too-old deps (robin-map, fmt fallbacks) are fetched
# automatically by the OIIO build system.
RUN if [ -n "$COVERAGE_CXX_WRAP" ]; then export CC=clang CXX=clang++; fi && \
    cmake -S /build/src -B /build/build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_STANDARD=17 \
        -DCMAKE_INSTALL_PREFIX=/opt/oiio \
        -DOIIO_BUILD_TOOLS=ON \
        -DOIIO_BUILD_TESTS=OFF \
        -DBUILD_DOCS=OFF \
        -DINSTALL_DOCS=OFF \
        -DINSTALL_FONTS=OFF \
        -DUSE_PYTHON=OFF \
        -DUSE_QT=OFF \
        -DUSE_NUKE=OFF \
        -DUSE_FFMPEG=OFF \
        -DUSE_OPENVDB=OFF \
        -DUSE_LIBHEIF=OFF \
        -DUSE_LIBRAW=OFF \
        -DUSE_DCMTK=OFF \
        -DUSE_PTEX=OFF \
        -DUSE_OPENJPEG=OFF \
        -DUSE_OPENJPH=OFF \
        -DUSE_JXL=OFF \
        -DUSE_R3DSDK=OFF \
        -DUSE_LIBULTRAHDR=OFF \
        -DENABLE_INSTALL_testtex=OFF \
        -DBUILD_FMT_FORCE=OFF \
        -DOpenImageIO_BUILD_MISSING_DEPS=all \
    && cmake --build /build/build --target iinfo --parallel "$(nproc)"

# Stage the binary plus the OIIO runtime libs into /opt/iinfo-ref. The
# runtime stage doesn't have the OIIO build, only Ubuntu's system libs;
# we copy the freshly-built libOpenImageIO.so* alongside the binary.
RUN mkdir -p /opt/iinfo-ref/bin /opt/iinfo-ref/lib && \
    cp /build/build/bin/iinfo /opt/iinfo-ref/bin/iinfo && \
    cp -P /build/build/lib/libOpenImageIO*.so* /opt/iinfo-ref/lib/

# Install the wrapper on PATH in the builder stage as well so the coverage
# adapter (which targets --target=builder) can invoke `iinfo` directly. The
# runtime stage installs the same wrapper below.
RUN printf '#!/bin/sh\nexec env LD_LIBRARY_PATH=/opt/iinfo-ref/lib /opt/iinfo-ref/bin/iinfo "$@"\n' \
        > /usr/local/bin/iinfo \
    && chmod +x /usr/local/bin/iinfo

# Strip coverage notes from vendored deps that OIIO's CMake fetches via
# OpenImageIO_BUILD_MISSING_DEPS (libjpeg-turbo, libuhdr, libpng, etc.).
# These deps pick up CXXFLAGS=--coverage from env but produce gcda/gcno that
# trigger geninfo "mismatched exception tag" aborts (gcc 13 inlining diverges
# across the deps' own CMake-applied flags). We only want coverage of OIIO's
# own source tree, so deleting the deps' .gcno files makes geninfo skip them.
RUN find /build/build/deps -name '*.gcno' -delete 2>/dev/null || true

# ---------------------------------------------------------------------------
# Runtime stage — Ubuntu 24.04 to match the build's libc / system libs.
# ---------------------------------------------------------------------------
FROM ubuntu:24.04
# Pick up distro ca-certificates updates (e.g. the eMudhra intermediate CA distrust) before base images refresh.
RUN apt-get update && apt-get install -y --no-install-recommends --only-upgrade ca-certificates && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        libstdc++6 \
        zlib1g \
        libtiff6 \
        libpng16-16 \
        libjpeg-turbo8 \
        libopenexr-3-1-30 \
        libimath-3-1-29t64 \
        libwebp7 \
        libwebpdemux2 \
        libwebpmux3 \
        libfreetype6 \
        libgif7 \
        libfmt9 \
        libpugixml1v5 \
        libsquish0 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/iinfo-ref /opt/iinfo-ref
RUN printf '#!/bin/sh\nexec env LD_LIBRARY_PATH=/opt/iinfo-ref/lib /opt/iinfo-ref/bin/iinfo "$@"\n' \
        > /usr/local/bin/iinfo \
    && chmod +x /usr/local/bin/iinfo \
    && ln -sf /usr/local/bin/iinfo /usr/local/bin/__eval_iinfo-cpp

ENTRYPOINT ["iinfo"]
