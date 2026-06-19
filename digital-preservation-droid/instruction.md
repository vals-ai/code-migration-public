Your goal is to migrate the Java repository located in '/source/Java-Original/' into {target} code.
The new {target} code should be created in the empty '/submission/' directory.
All functionality of the original code must be ported.
The output of any given command should be *exactly* the same. This includes any formatting - from text placement to color.
The '/submission/' directory must contain a Dockerfile that builds and runs the migrated {target} CLI tool.

Pay special attention to output formatting: DROID emits CSV by default (`"col1","col2",...`) and JSON with `--json`. Field ordering, quoting rules (escape rules for embedded quotes, `--quote-commas`/`-qc` mode), column subsetting (`--columns`/`-co`), and the URI encoding of file paths (`file:/absolute/path`) all matter.

## Tool Overview

DROID (Digital Record Object Identification) is The National Archives' file-format identification tool. Given a file or directory, it identifies the format by matching internal byte signatures (the PRONOM signature database) and emits one row per identified file. It runs in two modes:

- **No-profile mode** — streams identifications directly to stdout (CSV or JSON), with recursion, signature/container file overrides, and extension filtering. This is the simplest mode.
- **Profile mode** — builds a binary `.droid` profile database from one or more sources, including recursive traversal and filtering controls, then exports it or reports on it.

## Running the Reference Implementation

The reference implementation is available locally under `/reference`. Run `/reference/canary.sh` before probing it; that loads the reference Docker image as `code-migration-reference:current`. Do not copy reference files into `/submission`.
