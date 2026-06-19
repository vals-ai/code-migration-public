Your goal is to migrate the C++ repository located in '/source/C++-Original/' into {target} code.
The new {target} code should be created in the empty '/submission/' directory.
All functionality of the original code must be ported.
The output of any given command should be *exactly* the same. This includes any formatting - from text placement to color.
The '/submission/' directory must contain a Dockerfile that builds and runs the migrated {target} CLI tool.

The Dockerfile's ENTRYPOINT must invoke the migrated CLI in a way that preserves Z3's argv conventions: positional arguments are treated as the input file path (an `[-file:]file` form is also accepted, as is `--` to terminate option parsing), standard input is read with `-in`, and option flags use a single-leading-dash form (e.g. `-smt2`, `-T:10`, `param=value`). Use an absolute path for the launcher (e.g. `ENTRYPOINT ["/usr/local/bin/z3"]`). Do not wrap stdout in any extra prefix/suffix — your migration's stdout must match the reference byte-for-byte.

## What Z3 does

Z3 is a Satisfiability Modulo Theories (SMT) solver from Microsoft Research. The CLI reads an SMT-LIB v2 script (default), or one of several alternate input languages selected via flags, executes its commands (`assert`, `check-sat`, `get-model`, `get-value`, `get-unsat-core`, `eval`, `simplify`, `push`/`pop`, `set-option`, `set-info`, `declare-fun`, `define-fun`, `declare-sort`, `declare-datatypes`, ...), and prints responses to stdout.

Input formats: the CLI selects the input language via flags. SMT-LIB v2 is the default; the reference also supports alternate languages reachable from CLI flags (DIMACS CNF for SAT, weighted CNF for MaxSAT, pseudo-Boolean optimization, a CPLEX LP subset, and TPTP first-order). The fixedpoint engine is reachable through SMT-LIB `(set-logic HORN)`.

Theories Z3 handles include: linear / nonlinear / integer / real arithmetic, bit-vectors, arrays, uninterpreted functions, datatypes (algebraic and tuples / records), floating-point (IEEE 754), strings and sequences, finite sets, and quantifiers (E-matching + MBQI), wherever they are reachable through the CLI input languages.

Pay special attention to:
- The exact stdout format of `check-sat` (`sat`, `unsat`, `unknown`), `(model ... )` blocks, `(get-value (...))` responses, and `(error "...")` lines — these must match byte-for-byte.
- Numeric value formatting: rationals printed as `p` or `(/ p q)`, decimals printed only when the SMT-LIB option `pp.decimal` is on, bit-vectors printed as `#b...`, `#x...`, or `(_ bvN k)` depending on context, algebraic reals printed as `(root-obj p k)`, floating-point printed as `(fp #b<sign> #b<exp> #b<sig>)` triples (or as `+oo`, `-oo`, `NaN`, `+zero`, `-zero` when applicable).
- `(declare-fun x () T)` model values vs. `(define-fun x () T ...)` model values — Z3 prints the latter form in models.
- `push` / `pop` scope semantics: assertions, declarations made inside the scope, and `set-option` overrides are all discarded on `pop`.
- `(check-sat-assuming (...))`, `(get-unsat-assumptions)`, `(get-unsat-core)` — the printed assumption / label sets are sets in source order with specific canonicalization.
- Verbose / statistics / `set-option` printing: preserve stdout/stderr routing and reference-defined formatting for verbose messages, statistics, and print-success / model-production options. Statistics emitted to stderr are not byte-compared, but must not leak into stdout.
- Error messages: parse errors are emitted on stdout inside `(error "...")` with file:line:column information; option / argument errors are emitted on stderr. The text inside `(error "...")` is part of the contract.
- Reference-info / introspection flags (help, version, parameter dumps, tactic / simplifier / probe listings) emit reference-defined text that must match.

## Running the Reference Implementation

The reference implementation is available locally under `/reference`. Run `/reference/canary.sh` before probing it; that loads the reference Docker image as `code-migration-reference:current`. Do not copy reference files into `/submission`.
