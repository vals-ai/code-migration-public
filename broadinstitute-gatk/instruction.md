Your goal is to migrate the Java repository located in '/source/Java-Original/' into {target} code.
The new {target} code should be created in the empty '/submission/' directory.
All functionality of the original code must be ported.
The output of any given command should be *exactly* the same. This includes any formatting - from text placement to color.
The '/submission/' directory must contain a Dockerfile that builds and runs the migrated {target} CLI tool.

Pay special attention to: VCF/BAM output formatting (tab-separated columns, INFO field ordering, header line ordering), numeric formatting in tool output (the Java code uses `Double.toString` and `String.format` with specific patterns — e.g. `232.46` not `232.460000`), and exit codes (0 success, 1 user error, 2 unexpected exception, 3 missing argument).

## Tool Overview

GATK ("Genome Analysis Toolkit") is a command-line toolkit for variant discovery and genotype analysis on high-throughput sequencing data. The user-facing binary is the `gatk` Python launcher script at the repo root, which dispatches to per-tool implementations defined inside `gatk-package-*-local.jar`.

Invocation shape:

    gatk <ToolName> [tool-flags ...]

Each tool is a Java class annotated with `@CommandLineProgramProperties` under `src/main/java/org/broadinstitute/hellbender/tools/`. Tools share a common framework (`org.broadinstitute.hellbender.cmdline`, `engine`, `utils`) that handles argument parsing, BAM/VCF/FASTA I/O via HTSJDK, reference walking, interval handling, and standard option groups.

Common I/O surface that any port must implement faithfully:

- **BAM / SAM / CRAM** read & write, including index files (`.bai`, `.crai`), header parsing (`@HD`, `@SQ`, `@RG`, `@PG`), CIGAR strings, flag bits, MAPQ, mate-pair fields, tag fields (`NM`, `MD`, `RG`, `AS`, …).
- **VCF / BCF / VCF.gz (BGZF)** read & write, including indexes (`.tbi`, `.idx`), all VCF spec versions (3.x, 4.0–4.3), `##INFO`/`##FORMAT`/`##FILTER`/`##contig`/`##META`/`##ALT`/`##PEDIGREE` header lines, multi-sample genotype columns, all type codes (`Integer`, `Float`, `String`, `Character`, `Flag`).
- **FASTA reference + .fai index + .dict sequence dictionary**.
- **BED / Picard interval lists / GATK-style interval strings (`chr1:100-200`)**.

Argument parsing follows the Barclay parser conventions; match the reference's accepted argument forms and per-tool option surface.

## Running the Reference Implementation

The reference implementation is available locally under `/reference`. Run `/reference/canary.sh` before probing it; that loads the reference Docker image as `code-migration-reference:current`. Do not copy reference files into `/submission`.
