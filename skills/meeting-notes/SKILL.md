---
name: meeting-notes
description: Turn a meeting transcript or AI meeting summary (pasted text or a file path — PLAUD, Gemini, Teams, or any format) into a structured, human-readable meeting note filed to the right project, with action items extracted and mirrored to the personal action-item list. Use whenever the user provides a meeting transcript, recording summary, or notes file, or asks to process a meeting.
---

# Meeting Notes

You turn raw meeting artifacts into one structured vault note plus
action items. The note is for humans skimming later; the action items
feed the person's unified to-do list.

## Before starting

1. Read `99 System/Contract.md` and follow it exactly.
2. Read `99 System/Vault Index.md` (regenerate it first if stale/missing)
   — it is your map of existing projects and responsibilities for the
   filing step.
3. Check the `## meeting-notes` section of `99 System/Skill
   Preferences.md` — the owner's recorded preferences there override
   the defaults below.

## Inputs

- Pasted text, or one or more file paths. Common formats:
  - **PLAUD summary** (.txt): `## Meeting Information` header with date +
    participants, then topic blocks with conclusions. Best structural
    source.
  - **PLAUD transcript** (.txt): timestamped speaker turns. Use for
    verifying details and pulling exact commitments; never re-dump it.
  - **Gemini notes** (.docx): title, date, attendee list, sectioned
    prose, then a per-person assignment block in the form
    `[Person Name] Verb: description` (before the appended transcript —
    ignore Gemini's own UI boilerplate around it).
- **Multiple artifacts of the same meeting = ONE note.** Prefer the
  summary for structure; use the transcript to verify and to catch
  action items the summary missed.
- **.docx extraction** (Read cannot open docx): copy to scratchpad with
  `Copy-Item -LiteralPath` (paths often contain `[brackets]` — always
  LiteralPath), rename to `.zip`, `Expand-Archive`, read
  `word/document.xml`, strip XML tags, HTML-decode.
- The **meeting date comes from the artifact** (PLAUD header, Gemini
  date line), never from today's date.

## Build the note

From `Templates/Meeting Note.md`. Filename: `YYYY-MM-DD <Meeting Name>.md`
(meeting date first, per naming rules).

Frontmatter: `type: meeting` (baked), `home:` = destination container,
`client:` per the meeting's subject, `status: Completed` (filed after the
fact), `date:` = meeting date.

Body — human-readable, compressed, never a transcript re-dump:

```
# YYYY-MM-DD Meeting Name

## Attendees
## Summary            (2–4 sentences: what the meeting was and settled)
## Discussion         (short subsection per topic — points + conclusion)
## Decisions          (only real decisions; omit section if none)
## Action items       (snapshot of what was agreed — see below)
## Source             (original file path(s) + format; do NOT copy the
                       raw transcript into the vault)
```

Link generously: `[[wikilinks]]` to the project Home and any notes the
discussion touched.

## Filing — where the note lives

Match the meeting's content against the Vault Index:

- **Clearly about one project** → it files IN that project's folder
  (Contract rule 3). Propose: "This reads as [[X]] — file it there?"
- **A standing series no project owns** (1:1s, team syncs, all-hands) →
  `03 Meetings/<Series>/` — propose the series subfolder if new.
- **Sounds like a NEW project** → offer to create the project (folder
  approval rules apply; Home note from the template) and file the
  meeting inside it.
- **Not sure → ASK. Never silently guess.** Present your best 1–2
  candidates and let the user pick or name a destination.

One confirmation covers the whole plan: destination + any new folder +
the note itself + the action items. Get the yes, then write everything.

## Action items — the doctrine

An action item is anything someone committed to do or that clearly needs
doing. Capture: description, owner, due date if stated, and source.

They are written to TWO places with distinct roles and DIFFERENT scopes:

1. **The meeting note's `## Action items` section** — the historical
   snapshot of EVERYTHING agreed, all owners. Format:
   `- <Owner> — <item> (due YYYY-MM-DD)` . This snapshot never changes.
2. **`05 Personal/Action Items/Action Items.md`** — THE live to-do list,
   canonical for open/done state — and it receives **ONLY the vault
   owner's items**, determined in this order:
   - **Explicit assignments are authoritative.** When the artifact names
     owners (Gemini's `[Person Name] Verb: description` block, PLAUD
     items with named people), follow them — the notetaker's assignment
     beats your inference.
   - The owner is `name:` in `99 System/Context.md` (read it; it may
     include a username variant like `jdoe`). Match attributions
     generously — first name, full name, username.
   - An item assigned to another named person is recorded in the meeting
     note only — it does not enter this vault's Personal list. (In each
     person's vault, only that person's items reach the Personal list.)
   - **Teammate spillover (judgment, conservative):** Context.md `team:`
     says who the owner works with. If a teammate's item plainly
     involves the owner's own work — they build the artifact together,
     or the Vault Index shows the owner owns that project — you MAY also
     add it to the owner's list, marked `(supporting <teammate>)`. Use
     sparingly; when in doubt, ask rather than add.
   - "All"/"Team" items that plainly include the owner count as theirs.
   - Owner ambiguous and it matters → ask the user, don't guess.
   - This filter is per-person taste — an employee who wants different
     behavior records it in the `## meeting-notes` section of
     `99 System/Skill Preferences.md` (or asks Claude to), and it
     persists across plugin updates. Append under a `## YYYY-MM` heading
   (create folder and file on first use; newest month at top):
   `- [ ] <item> — <owner, if not the vault owner> — [[<Project> Home]] (from [[<meeting note>]], due YYYY-MM-DD)`
   The **project wikilink rides on every item that belongs to a
   project, assigned PER ITEM** — a meeting filed under project X can
   produce items belonging to project Y; match each item against the
   Vault Index, don't blanket-copy the meeting's destination (omit for
   general items): it makes per-project to-dos a
   one-grep query, and Obsidian's backlinks panel on the project Home
   becomes its live action-item view for free. Never add an action-item
   list to the project Home itself — that would duplicate live state;
   backlinks are the view. Checkboxes are the completion mechanism;
   humans tick them in Obsidian.

**Scope guard:** `05 Personal/Action Items/` is the ONLY path inside
`05 Personal/` you may create, read, or write (Contract carve-out).
Never touch anything else in that folder, never list its contents.

## Quality bar

- Names: match speakers/attendees to People notes in
  `04 Resources/People/` when they exist; keep the artifact's spelling
  otherwise.
- Don't inflate: a topic that produced no decision gets no invented
  conclusion; a meeting with no action items gets "None recorded."
- If two artifacts disagree (summary vs transcript), trust the
  transcript and note the discrepancy in the relevant bullet.
