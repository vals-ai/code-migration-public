Your goal is to migrate the Python repository located in '/source/Python-Original/' into {target} code.
The new {target} code should be created in the empty '/submission/' directory.
All functionality of the original code must be ported.
The output of any given command should be *exactly* the same. This includes any formatting - from text placement to color.
The '/submission/' directory must contain a Dockerfile that builds and runs the migrated {target} CLI tool.

The tool to migrate is `ttx` — FontTools' font converter that reads TrueType/OpenType font files
and outputs XML (TTX format), or reads TTX XML files and compiles them back to binary fonts.

The primary CLI entry point is `ttx` (see `Lib/fontTools/ttx.py`). The migration must implement the full `ttx` command-line interface for TTF/OTF ↔ TTX XML conversion in both directions. A few behaviors carry specific contracts:

  - Dump path (font → TTX XML): output can be routed to stdout, to a named file, to a directory of per-table files, in split-table mode, and in split-glyf mode; the input font is read from standard input when the input filename is `-`.
  - Compile path (TTX XML → font): when WOFF is selected as the output container it wraps the SFNT with brotli/zlib and WOFF2 uses brotli; `--with-zopfli` selects Zopfli over zlib for WOFF compression and requires `--flavor woff`.

Pay close attention to:
  - The TTX XML format: element names, attribute names, attribute ordering, indentation (2 spaces), and value encoding must match exactly.
  - The `sfntVersion` attribute in the root `<ttFont>` element encodes the font's sfnt version bytes (\x00\x01\x00\x00 for TrueType, OTTO for CFF/OTF).
  - The `ttLibVersion` attribute in `<ttFont>` should match the Python implementation's version.
  - Table-specific XML structure: each font table (head, hhea, cmap, glyf, post, name, OS/2, CFF, fvar, etc.) has its own XML serialization format defined in `Lib/fontTools/ttLib/tables/`.
  - The `-l` table listing format: exact column widths, spacing, and hexadecimal formatting.
  - Comments inside XML output (e.g., character name comments in cmap, the "recalculated by compiler" comment in head/glyf).

The TTX output for an arbitrary input font must be produced by {target} code that parses the SFNT tables itself. If your migration cannot handle a font it has never seen before, it is not a migration.

## Running the Reference Implementation

The reference implementation is available locally under `/reference`. Run `/reference/canary.sh` before probing it; that loads the reference Docker image as `code-migration-reference:current`. Do not copy reference files into `/submission`.
