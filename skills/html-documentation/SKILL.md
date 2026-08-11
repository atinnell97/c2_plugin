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
2. **Purpose** - two lead bullets: What it is, What it shows.
3. **Tab Breakdown** - one block per tab: teal `Tab:` heading, "What it
   shows", a Metric/Source/Logic table, that tab's own **How to Use**
   (Controls / Interactions / Good to know - written from the page's real
   controls, which you verify in the page HTML, not invent), and the green
   stamp.
4. **Validations** - scope paragraph, the 4-row table (Source data,
   Calculations, Output, Human spot check), then amber notes: Operational
   note, Not covered, Standing finding, By design not faults.

Section 4 and the stamps come **from the audit file**, including the vault
owner's caveat answers. Tab descriptions and metric tables come from the
generator and the page HTML, which you read yourself.

## House style (each rule is a deliberate correction - do not drift)

- Fonts: Calibri; body, title and section headers 11pt; tab headings 16pt;
  table text 10pt.
- Colors: navy for structure (title, section headers, bold lead-ins), teal
  for the `Tab:` prefix and How to Use headings, green for Validated
  stamps, amber for the four caution labels, gray italic for placeholders.
- The stamp is `Validated YYYY-MM-DD` and nothing else - no explanation
  sentence. A tab whose audit did not pass, or was not audited, gets no
  stamp.
- Plain prose. No em dashes, no dash-clauses, no irony or cleverness, and
  minimal clarifying asides - state the fact once and stop. Real hyphens in
  folder names (`OneDrive - C2 Group`) stay.
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
