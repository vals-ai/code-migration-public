# Reference image for the Z3 migration task.
#
# Builds the upstream C++ z3 CLI from C++-Original/ and exposes it as the
# image entrypoint. The grader builds and runs this image directly as one
# half of the dual-container test harness.
#
# Build context: the task root (data/Z3Prover-z3/).
#
# Note on base image: recent Z3 uses C++20's <format> header which requires
# GCC 13+. Debian bookworm (12) ships GCC 12, so we build on debian:trixie
# (13) which ships GCC 14. Coverage instrumentation is opt-in via build-args
# but the c_cpp coverage adapter is incompatible with trixie's lcov 2.0, so
# we set coverage_adapter: skip in spec.yaml.

FROM debian:trixie-slim AS builder

# Coverage instrumentation hook. Empty by default -> no-op for normal builds.
# The c_cpp coverage adapter overrides these via --build-arg.
ARG CFLAGS=""
ARG CXXFLAGS=""
ARG LDFLAGS=""
ENV CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"
ARG COVERAGE_CXX_WRAP=""

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential cmake ninja-build \
        python3 \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN if [ -n "$COVERAGE_CXX_WRAP" ]; then \
        for c in cc gcc clang c++ g++ clang++; do \
            real=$(command -v "$c" 2>/dev/null) || continue; \
            [ "$real" = "/usr/local/bin/$c" ] && continue; \
            { echo "#!/bin/sh"; echo "exec \"$real\" $COVERAGE_CXX_WRAP \"\$@\""; } > "/usr/local/bin/$c"; \
            chmod +x "/usr/local/bin/$c"; \
        done; \
    fi

WORKDIR /build
COPY C++-Original/ .

# Configure with CMake (out-of-source), build only the shell target so we
# avoid building tests / bindings / examples. The shell target links against
# the in-tree libz3 components.
#
# Parallelism is capped at min(nproc, 4): several of Z3's simplifier TUs
# (bound_simplifier.cpp, eliminate_predicates.cpp, mbp_arrays.cpp, model.cpp,
# euf_completion.cpp) peak around 2 GB of resident memory each under -O3
# C++20. The grader sandbox is 16 GB, so -j$(nproc) on an 8-vCPU sandbox
# OOM-kills cc1plus mid-build.
RUN JOBS="$(nproc)" \
    && if [ "$JOBS" -gt 4 ]; then JOBS=4; fi \
    && cmake -S . -B build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DZ3_BUILD_LIBZ3_SHARED=OFF \
        -DZ3_BUILD_TEST_EXECUTABLES=OFF \
        -DZ3_BUILD_EXECUTABLE=ON \
        -DZ3_BUILD_PYTHON_BINDINGS=OFF \
        -DZ3_BUILD_JAVA_BINDINGS=OFF \
        -DZ3_BUILD_DOTNET_BINDINGS=OFF \
        -DZ3_INCLUDE_GIT_HASH=OFF \
        -DZ3_INCLUDE_GIT_DESCRIBE=OFF \
    && cmake --build build --target z3 -j"$JOBS"

FROM debian:trixie-slim
# Pick up distro ca-certificates updates (e.g. the eMudhra intermediate CA distrust) before base images refresh.
RUN apt-get update && apt-get install -y --no-install-recommends --only-upgrade ca-certificates && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y --no-install-recommends \
        libstdc++6 \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /build/build/z3 /usr/local/bin/z3
ENTRYPOINT ["/usr/local/bin/z3"]
