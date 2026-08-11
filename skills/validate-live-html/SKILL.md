---
name: validate-live-html
description: Complete audit of a live HTML dashboard, every tab - source data, calculations, and output verified by independent recompute, plus an Excel-engine spot check. Step 1 of the two-skill documentation flow; ends with a results file and open caveats for the vault owner to answer, never with a document. Use when asked to audit or validate a dashboard or to check whether its numbers can be trusted.
---

# Validate a Live HTML (the audit skill)

You audit a live HTML dashboard, all tabs, and report whether its numbers can
be trusted. This is step 1 of a two-step flow:

1. **This skill** runs the audit and presents results plus open caveats.
2. The vault owner reads the results and answers the caveats.
3. Only after the vault owner confirms does the `html-documentation` skill
   create the doc.

Never create or update the documentation doc from this skill. End with the
report and the questions, then stop and wait.

You validate by reading code. Every number on the page was put there by a
generator; until you have read the code that put it there, you know what the
number is labeled, not what it means.

## Per-vault preferences

Two settings live in `99 System/Skill Preferences.md` under the
`## Dashboard audit & documentation` section:

- `python:` — full path to the Python executable used for audit scripts.
- `documentation folder:` — the folder where audit files (and later the
  documentation docs) are written.

If either is missing, ask the user once, then record the answer in that
section of Skill Preferences so the question never recurs.

## Procedure

**1. Find the artifact people actually open.** Not necessarily the repo
copy. Generators often copy the built bundle to a synced/published location
on every build (look for a copy step in the generator); the copy people
actually open may not be the repo copy — find the published artifact, not a
stale committed one. Note the published file's build timestamp; later steps
depend on it.

**2. Read the generator end to end and build the metric map.** For every
number on every tab: source field(s) and the formula. Do not assert on a
field you have not traced. Read the repo's CLAUDE.md first; the sharp edges
are usually documented.

**3. Validate sources.** Modified times vs build time **to the second** (a
same-date source can still be stale or, worse, newer than the build).
Wreckage scan: only `nan`, `nat`, `undefined`, Excel error text count -
`none`/`null`/`n/a` are real values here. Row volumes vs the previous
audit's counts if one exists; record this run's counts either way.

**4. Recompute every embedded dataset with independent code.** Fresh code
reading the same sources, never importing the generator. Compare every
field of every row where feasible, not samples.

**5. Check output consistency.** Inside each dataset (parts sum to wholes,
percentages match their own numerators, detail lists match their counts)
and across datasets (shared payloads byte-identical, cross-references
resolve). Client-side rendering is NOT covered by blob checks; say so.

**6. Spot check via Excel's own engine.** Re-derive a handful of displayed
values inside the live workbooks (`Worksheet.Evaluate` with COUNTIF/SUMIFS/
SUMPRODUCT formula strings). This is a third computation path. The human
spot check row still belongs to the vault owner unless they delegate it;
when they do, attribute it that way.

**7. Write the audit file.** `<documentation folder>\<Dashboard Name> -
Audit.md`, where the folder comes from the `documentation folder:`
preference. Contents: build audited (path + timestamp), source files with
modified times and row counts, per-tab verdicts with what passed/failed/
was skipped, findings (operational notes, by-design behaviors, blind
spots), and an **Open caveats** section listing every question the vault
owner must answer, each with a blank `Answer:` line. This file is the
handoff to `html-documentation`; the vault owner's answers get recorded
in it.

**8. Report to the vault owner and stop.** Lead with the verdict. List the
caveats as direct questions. Do not proceed to documentation; that is the
vault owner's call after they have answered.

## Rules bought with real mistakes

- **Investigate first, accuse second.** In one real audit, 9 findings were
  flagged across two passes and all 9 were errors in the audit code, not the
  page. Known traps: a page 0 vs a recompute-absent is usually a genuine
  zero by design (general-time-only people, drafters with only closed
  projects); a formula column reading blank usually means stripped caches,
  not missing data (below). When an expected rule fails, the default
  explanation is that you misunderstand the column.
- **Stripped formula caches.** A programmatic save of an Excel master
  removes cached formula results. Some generators detect this and compute
  validated mirror formulas with the build date — read the generator to see
  if yours does. Your recompute must mirror the mirrors (see
  `reference/audit_all_tabs_example.py`); in one audit, comparing against
  the blank cache reported 98 false failures. Note it as an operational
  finding: open + save in Excel restores the caches.
- **Skip is not pass.** A check that examined nothing must say so.
- **Never present green as full verification.** The not-covered list ships
  with every report: rendering, and whatever else was out of scope.
- **Audit, do not repair.** Change nothing in the dashboard, generator, or
  sources. Masters and pipeline scripts are read-only, always.
- **Never let one malformed input kill the run.** Exceptions are findings.
  Expect `BadZipFile` from partially synced OneDrive files.
- **Clock-dependent values:** anything derived from TODAY() at a source's
  last recalculation reproduces only with the right reference date. Cached
  values compare directly; fallback-computed values compare with the build
  date. Skip and count what cannot be reproduced.

## Mechanics that already work (reference/ has the code)

- Python: run scripts with the full path from the `python:` preference in
  Skill Preferences (plain `python`/`py` are often not on PATH; never
  assume they are). openpyxl with `data_only=True, read_only=True`.
- Bundle blobs are JS-string-escaped. Extract: find `const NAME = `, scan to
  a candidate `;` terminator, then `json.loads('"' + chunk + '"')` to
  unescape and `json.loads` again to parse; extend the scan on failure.
- Excel COM: `WorksheetFunction.CountIf` misbehaves through PowerShell; use
  `$ws.Evaluate("COUNTIF(...)")` formula strings. Columns are found from
  header row via UsedRange, never assumed. Open workbooks read-only.
- Name joins: `display_name` ("Last, First" to "First Last") plus the
  generator's alias table, applied exactly as the generator applies them.
- `reference/audit_all_tabs_example.py` is a full working audit of a real
  multi-tab dashboard (names and paths genericized); adapt it rather than
  starting blank.

## When decisions come up

Rules about what is and is not a valid check for a given dashboard belong in
the vault under the relevant Responsibility in `02 Responsibilities`. If a
dashboard keeps needing the same manual audit, say so in the findings —
permanent every-build checks belong in the dashboard's own build pipeline,
which is a separate decision for the vault owner.
