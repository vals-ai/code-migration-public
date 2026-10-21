# Reference image for the GATK migration task.
#
# Builds the upstream Broad Institute GATK CLI from Java-Original/ via Gradle
# and exposes the `gatk` Python launcher script (which invokes `java -jar
# gatk.jar`) as the image ENTRYPOINT. The grader builds and runs this image
# directly as one half of the dual-container test harness.
#
# Build context: the task root (data/broadinstitute-gatk/). The reference build
# does NOT use the upstream broadinstitute/gatk:gatkbase docker base (which
# bundles conda + ML deps + Spark for ~6 GB) — those layers are only needed
# for the small subset of tools that shell out to Python ML helpers. Plain
# JDK 17 is sufficient for the 270+ pure-Java tools the test suite exercises.

FROM eclipse-temurin:17-jdk-jammy AS builder

# `git` is needed because gradlew's `installDist` path & the palantir
# git-version plugin both look at .git when versionOverride is not set; we
# DO set versionOverride below so this is belt-and-suspenders. `python3` is
# needed because the `gatk` script is itself a Python file and gradle's
# `gatkPythonPackageArchive` task zips up src/main/python at build time.
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        python3 \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY Java-Original/ .

# gradlew is gitignored and shipped via S3 (scripts/tasks_from_s3.py), which
# does not preserve the unix executable bit, so it arrives mode 0644. Restore
# +x or the `RUN ./gradlew` below fails with "Permission denied" (exit 126).
RUN chmod +x gradlew

# The build aborts unless src/main/resources/large/*.pt exist as real files
# (not git-lfs stubs). The repo we ship already has them resolved (~9 MB).
# Verify here so a stub slip-up fails loudly at build time.
RUN test -s src/main/resources/large/nvscorevariants/small_2d.pt \
 && test -s src/main/resources/large/nvscorevariants/1d_cnn_mix_train_full_bn.pt

# Pin a deterministic version string so the jar name is stable and any
# `gatk --version` output is reproducible across rebuilds. `versionOverride`
# also bypasses the gradle build's git-clone sanity check.
ARG GATK_VERSION=4.6.1.0

# shadowJar produces build/libs/gatk-package-${GATK_VERSION}-local.jar
# (the all-in-one fat jar) plus a same-dir `gatk.jar` symlink. Skip tests,
# skip the Spark-only shaded jar, skip the conda env metadata zip.
# Memory: GATK's shadowJar needs ~4G heap. `installDist` is a separate task
# we deliberately do not invoke because it pulls down a large GSA reference
# file (`downloadGsaLibFile`) that isn't needed at runtime.
ENV GRADLE_OPTS="-Xmx4g -Dorg.gradle.daemon=false"
RUN ./gradlew --no-daemon shadowJar \
        -DversionOverride=${GATK_VERSION} \
        -Drelease=true \
        --warning-mode=none \
        -x test

# Sanity check the jar exists and report its size.
RUN ls -la build/libs/ && \
    test -f build/libs/gatk-package-${GATK_VERSION}-local.jar

# Stage 2: runtime image. JRE is enough; the `gatk` Python launcher script
# invokes `java -jar` directly (no spark-submit, no gcloud) when GATK_LOCAL_JAR
# is set.
FROM eclipse-temurin:17-jre-jammy
# Pick up distro ca-certificates updates (e.g. the eMudhra intermediate CA distrust) before base images refresh.
RUN apt-get update && apt-get install -y --no-install-recommends --only-upgrade ca-certificates && rm -rf /var/lib/apt/lists/*

ARG GATK_VERSION=4.6.1.0

# `python3` is required because /opt/gatk/gatk is a Python script.
# `procps` provides `ps`, sometimes used by the JVM startup helpers.
# `bash` is already in the base image but we make it explicit.
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 \
        procps \
        ca-certificates \
        bash \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3 /usr/local/bin/python

COPY --from=builder /build/build/libs/gatk-package-${GATK_VERSION}-local.jar /opt/gatk/libs/gatk-package-${GATK_VERSION}-local.jar
COPY --from=builder /build/gatk /opt/gatk/gatk

RUN chmod +x /opt/gatk/gatk \
    && ln -sf /opt/gatk/libs/gatk-package-${GATK_VERSION}-local.jar /opt/gatk/gatk.jar \
    && ln -sf /opt/gatk/gatk /usr/local/bin/gatk

# `gatk` script honors GATK_LOCAL_JAR before any of its own fallback paths.
ENV GATK_LOCAL_JAR=/opt/gatk/gatk.jar \
    PATH=/opt/gatk:$PATH \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

WORKDIR /work

ENTRYPOINT ["/opt/gatk/gatk"]
