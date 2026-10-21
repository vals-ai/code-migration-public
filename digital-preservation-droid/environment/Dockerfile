# Reference image for the DROID migration task.
#
# Builds the Java droid-command-line module from Java-Original/ and exposes
# it as the image entrypoint. The grader builds and runs this image directly
# as one half of the dual-container test harness.
#
# Build context: the task root (data/digital-preservation-droid/).

# Stage 1: build droid-command-line and gather its runtime classpath.
FROM maven:3.9-eclipse-temurin-21 AS builder
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*
WORKDIR /build
COPY Java-Original/ .
# The droid-parent pom binds the `buildversion-plugin:set-properties` goal to
# every build, and that plugin shells out to `git` to read the current
# commit. The clone in Phase 1 strips `.git/` so we recreate a minimal repo
# here just to satisfy the plugin.
RUN git init -q && git config user.email droid@build.local && git config user.name builder \
    && git add -A && git -c commit.gpgsign=false commit -q -m bootstrap >/dev/null
# Build & install droid-command-line and all of its dependency modules into
# the local Maven repo. install (not package) is required so the next step
# can resolve the snapshot droid-* jars when copying runtime deps.
RUN mvn -pl droid-command-line -am install -DskipTests -Dmaven.javadoc.skip=true -q
# Now copy the full runtime classpath into /lib next to the driver jar.
RUN mkdir -p /lib && cd droid-command-line \
    && mvn dependency:copy-dependencies -DincludeScope=runtime -DoutputDirectory=/lib -q
# Move the driver jar to a stable path; exclude the sources and javadoc jars
# that the Maven build also produces under the same target/ directory.
RUN find droid-command-line/target -maxdepth 1 -name 'droid-command-line-*.jar' \
        ! -name '*-sources.jar' ! -name '*-javadoc.jar' \
        -exec cp {} /droid-command-line.jar \;

# Stage 2: lean JRE-only runtime image.
FROM eclipse-temurin:21-jre-jammy
# Pick up distro ca-certificates updates (e.g. the eMudhra intermediate CA distrust) before base images refresh.
RUN apt-get update && apt-get install -y --no-install-recommends --only-upgrade ca-certificates && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y --no-install-recommends jq && rm -rf /var/lib/apt/lists/*
COPY --from=builder /droid-command-line.jar /opt/droid/droid-command-line.jar
COPY --from=builder /lib/ /opt/droid/lib/

# DROID writes its config and copies its bundled-in-jar signature files into
# ~/.droid6 on first run. Run it once during image build so the runtime
# directory is fully populated and deterministic at exec time — no network
# round-trips, no first-run setup latency.
ENV HOME=/root
RUN java -jar /opt/droid/droid-command-line.jar -X >/dev/null 2>&1 || true

ENTRYPOINT ["java", "-jar", "/opt/droid/droid-command-line.jar"]
