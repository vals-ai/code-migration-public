Your goal is to migrate the C++ repository located in '/source/C++-Original/' into {target} code.
The new {target} code should be created in the empty '/submission/' directory.
All functionality of the original code (specifically of the `iinfo` CLI tool) must be ported.
The output of any given command should be *exactly* the same. This includes any formatting — from text placement to spacing, exact label strings, comma placement, alignment padding, and trailing newlines.
The '/submission/' directory must contain a Dockerfile that builds and runs the migrated {target} CLI tool.

The CLI tool to migrate is `iinfo`, an image-metadata printer that ships with OpenImageIO. It reads an image file, parses its header (and optionally pixel data), and prints metadata to stdout.

    iinfo [options] filename...

Default-mode output (one line per file):
    <filename><padding> : <W> x <H>[ x <D>], <NCHAN> channel, <[deep ][volume ]><FORMAT> <FILEFORMAT>[ (<MB> MB)][ (+mipmap)][ (<N> subimages[ +mipmap)])]

Verbose (-v) output adds, after the header line:
    <indent>channel list: <name> (<format>), <name> (<format>), ...
    <indent>pixel data origin: x=<X>, y=<Y>[, z=<Z>]                (only if non-zero origin)
    <indent>full/display size: <W> x <H>[ x <D>]                    (only if differs from data window)
    <indent>full/display origin: <X>, <Y>[, <Z>]
    <indent>tile size: <TW> x <TH>[ x <TD>]                          (only if tiled)
    <indent><attribute name>: <value>                                (sorted, case-insensitive, non-namespaced first)

The `<indent>` is `    ` (four spaces) at the top level. With `-a` and multiple subimages, MIP-level stats are indented `      ` (six spaces).

The first column of every output line, including verbose lines, is padded to the longest input filename's length (capped at 40 chars) when no `-f` prefix is requested. With `-f`, every line starts with `<filename> : ` instead.

Errors (file missing, unsupported format, etc.) are printed to **stderr** with the prefix `iinfo ERROR: "<filename>" : <message>` and the program exits with status 1 after processing remaining files.

Pay close attention to:
- The exact format string in the header line (`%4d x %4d`, `, N channel, `, etc.). Field-width formatting matters: `iinfo` uses `{:4}` for width/height/depth in some places.
- The `extended_format_name`/`brief_format_name` rules (e.g. `uint8`, `uint16`, `half`, `float`, etc.) — these come from OpenImageIO's TypeDesc names and bit-depth handling.
- Per-attribute value formatting — ints, floats, vectors, and matrices each have their own canonical string forms in OIIO.
- The `--hash` SHA-1 is computed over the raw pixel bytes (per-channel, per-pixel) for each subimage at the highest MIP level.
- The metadata sort order (case-insensitive, non-namespaced attributes before namespaced ones).
- File-format names returned by each plugin (`png`, `jpeg`, `tiff`, `openexr`, `bmp`, `pnm`, `targa`, etc.) — the migration must report the same identifier the OIIO plugin reports.

## Running the Reference Implementation

The reference implementation is available locally under `/reference`. Run `/reference/canary.sh` before probing it; that loads the reference Docker image as `code-migration-reference:current`. Do not copy reference files into `/submission`.
