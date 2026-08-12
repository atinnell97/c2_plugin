---
name: html-documentation
description: Create or update the Word documentation doc for a live HTML dashboard in the approved house style (Template v2). Step 2 of the two-skill flow; runs only after a validate-live-html audit exists and the vault owner has answered its caveats. Use when asked to document a dashboard, create its HTML documentation, or update an existing dashboard doc.
---

# HTML Documentation (the doc-creation skill)

You produce the Word documentation for a live HTML dashboard, in the
approved house style (Template v2). This is step 2 of the flow:

1. `validate-live-html` audits the dashboard and writes
   `<Dashboard Name> - Audit.md` into the documentation folder.
2. The vault owner reads the results and answers the open caveats.
3. **This skill** builds the doc from the confirmed audit.

The vault owner's name is the `name:` value in the frontmatter of
`99 System/Context.md`.

## The documentation folder - a per-vault preference

Both the audit-file check and the output docx live in the vault's
documentation folder. Read it from `99 System/Skill Preferences.md`,
section `## Dashboard audit & documentation`, key `documentation folder:`.
If the section or key is missing, ask the user once where dashboard audits
and documentation should live, then record the answer under that section
and key before continuing. Do not ask again in later sessions.

## Preconditions - check before writing anything

- The audit file `<Dashboard Name> - Audit.md` exists in the documentation
  folder.
- Its Open caveats are answered (in the file or by the vault owner in
  conversation; record conversation answers into the file first).

If either is missing, stop and say so. Do not document an unaudited
dashboard, and do not guess at unanswered caveats. Offer to run
`validate-live-html` instead.

## What to produce

`<documentation folder>/<Dashboard Name> - Documentation.docx`,
built by a Word COM PowerShell script (adapt
`reference/make_doc_example.ps1`, which produced the approved reference
doc; the blank template comes from `reference/make_template.ps1`).
Regenerate the whole doc from the script on updates; do not hand-edit the
docx. Keep the same filename so it stays one file per dashboard.

Structure, exactly as Template v2:

1. **General Information** - 8-row table: Project, Scope, Creation Date,
   Author/Owner, Audience, Live location, Update cadence, Data sources.
   Data sources are a list inside the cell, one source per line with its
   description indented under it (join lines with `[char]11`).
2. **Purpose** - two lead bullets: What it is, What it shows. "What it is"
   is ONE sentence: what kind of page it is and how often it rebuilds. Not
   which modules it imports, not that the page is a snapshot of its build
   time.
3. **Tab Breakdown** - one block per tab: teal `Tab:` heading, "What it
   shows", a Metric/Source/Logic table, that tab's own **How to Use**
   (Controls / Interactions / Good to know - written from the page's real
   controls, which you verify in the page HTML, not invent), and the green
   stamp.
4. **Validations** - a ONE-SENTENCE scope line, the 4-row table (Source
   data, Calculations, Output, Human spot check), then a single amber note:
   **By design, not faults**.
   - Scope line format: `Scope: <what was audited> via the
     validate-live-html skill.` No build timestamps, no feed-freshness
     narrative, no figure counts.
   - `How it was checked` says what was checked and how, not an inventory
     of every dataset and row count. `PASS`, not `PASS. Rendering not
     verified.` `By / Date` is who signed it off and a short date.
   - Operational note, Not covered by this audit, and Standing finding are
     **not** carried into the doc. They stay in the audit file, which is
     where the detail belongs.

Section 4 and the stamps come **from the audit file**, including the vault
owner's caveat answers. Tab descriptions and metric tables come from the
generator and the page HTML, which you read yourself.

## House style (each rule is a deliberate correction - do not drift)

- Fonts: Calibri; body, title and section headers 11pt; tab headings 16pt;
  table text 10pt.
- Colors: navy for structure (title, section headers, bold lead-ins), teal
  for the `Tab:` prefix and How to Use headings, green for Validated
  stamps, amber for the caution label, gray italic for placeholders.
- The stamp is `Validated YYYY-MM-DD` and nothing else - no explanation
  sentence. A tab whose audit did not pass, or was not audited, gets no
  stamp.
- **American English throughout.** color not colour, labor not labour,
  labeled not labelled, itemized not itemised, modeled not modelled, gray
  not grey, analyze not analyse. Check before you save: these creep in
  through phrases like "scope colour", "labour hours" and "the labelled
  tabs".
- Plain prose. No em dashes, no dash-clauses, no irony or cleverness, and
  minimal clarifying asides - state the fact once and stop. Real hyphens in
  folder names (`OneDrive - C2 Group`) stay.
- **Say it once, in one place.** A fact appears in exactly one of: the
  metric table's Logic cell, the tab's How to Use, or the doc-level
  "By design, not faults" note. Never two of them.
  - If a caveat is cross-cutting (it is true of several tabs), it belongs in
    **By design, not faults** only. Do not also put it in a tab's "Good to
    know" - that bullet gets deleted.
  - If it is specific to one tab, it belongs in that tab's Logic cell or How
    to Use, and does not go in the doc-level note.
  - Within a paragraph, do not restate the opening clause at the end. "read
    from the raw evidence columns, not from Stage ... Stage is not consulted
    because it disagrees with the evidence" says one thing twice.
- **General Information cells are terse.** This table is a fact sheet, not
  prose. Four rows in particular are one short answer and nothing else:
  - `Audience` - the group only: `C2 internal`, `Management`,
    `Engineering team`. Never who opens which copy, never why this page is
    kept separate from another one.
  - `Author / Owner` - the name only. No email, no "built from X's machine",
    no generator path.
  - `Creation Date` - a bare date. No first-published / went-live /
    put-on-a-schedule history.
  - `Update cadence` - the interval and the generator script, e.g.
    `Every 4 hours from high_level.py`. Not the scheduled task name, not the
    run times, not "every rebuild publishes live", not where the build time
    is shown.

  What gets cut here is not relocated into the body. It already lives in the
  audit file and the generator, which is where anyone who needs it looks.

## What to leave out (the single biggest correction)

The first drafts of these docs were roughly twice the length they needed to
be. The over-writing was not in the structure, it was in sentences that felt
informative and were not. Every rule below is something that got cut:

- **No changelog.** The doc describes the page as it is now, never how it
  got here. Cut "the warning box was removed 2026-08-10", "Simplified
  2026-08-10: stage bars and the footnote were removed", "moved to the
  shared folder on 2026-08-11", "removed from the nav on 2026-08-11". If a
  reader needs the history, it is in the audit file and in git.
- **No figures that move.** Cut counts taken from the audited build: "18
  people at the audited build", "across all 4,200 segments", "at the audit
  that gap was 900 rows", "the crew size is 1.9", "currently 75% coverage".
  Describe the rule, never the reading. A number that is stale by the next
  rebuild makes the whole document look stale. The one exception is the
  Human spot check row, where the values checked ARE the evidence.
- **No cross-reference boilerplate.** Cut "Same rule as the other tab", "The
  same counts the companion page shows". Keep a cross-reference only when it
  carries a guarantee the reader can rely on, e.g. "Same source as the
  companion page's delivery tab, so the two cannot disagree on a count."
- **No attributions in the body.** Cut "(owner name, 2026-03-20)". Sign-off
  lives in the Validations table's `By / Date` column and nowhere else.
- **No restating the point.** Cut trailing emphasis like "and nobody else"
  and "They answer different questions and do not match" when the preceding
  sentence already said it.
- **Logic cells give the rule, not the trivia.** Cut "Also broken out by
  month", "with per-project provenance on the page". If it does not change
  how a number is read, it does not belong in the cell.
- **How to Use gives the control, not a worked example.** Cut "Submittal
  tracking starts May 2026. March shows 0 received because those sites were
  assigned in February."

The test for any sentence: does it change how someone reads a number on the
page? If not, cut it. Length is not thoroughness, and the audit file is
already carrying the detail.
- Paths are written slash-style (`OneDrive - C2 Group/folder/file.html`),
  never with arrows.
- Each tab's How to Use is individual to that tab. A tab with no controls
  says so.

## Word COM mechanics (learned the hard way; the reference script has them)

- Style changes go on the style objects; when typing mixed formatting,
  reset direct formatting to the *current paragraph style's* font
  (`Reset-Font` in the reference), never to hardcoded values - hardcoding
  silently shrank 16pt headings to 11pt once.
- Disable AutoCorrect sentence-caps and replace-text while typing; restore
  after.
- Lists inside a table cell: join lines with `[char]11`.
- `SaveAs` fails if the user has the doc open; catch it and save a `(v2)`
  copy beside it, tell them, and swap it in after they close the original
  (then delete the copy - the folder stays clean).
- Verify after saving: reopen read-only and check heading styles, sizes,
  and table count before reporting done.
