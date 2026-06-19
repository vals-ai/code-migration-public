# Reference image for the comrak migration task.
#
# Builds the upstream Rust comrak binary from Rust-Original/ and exposes it as
# the image entrypoint. The grader builds and runs this image directly as one
# half of the dual-container test harness.
#
# Build context: the task root (data/kivikakk-comrak/).

FROM rust:1-slim-bookworm AS builder

# Coverage instrumentation hook. Empty by default → no-op for normal builds.
# The coverage adapter overrides via --build-arg RUSTFLAGS=-Cinstrument-coverage
# (see Dockerfile.reference.template). cargo honors RUSTFLAGS from env.
ARG RUSTFLAGS=""
ENV RUSTFLAGS="${RUSTFLAGS}"
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential pkg-config \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /build
COPY Rust-Original/ .
RUN cargo build --release --bin comrak

FROM debian:12-slim
COPY --from=builder /build/target/release/comrak /usr/local/bin/comrak
ENTRYPOINT ["comrak"]
