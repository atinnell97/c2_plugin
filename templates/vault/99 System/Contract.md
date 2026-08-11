# Contract — the machine-readable rules

Skills and chatbots read THIS file at runtime; `Conventions.md` holds the
human guidance and rationale. If the two ever disagree, this file wins for
machine behavior — and the disagreement is a bug to fix.

## Frontmatter (required on every templated note)

```yaml
type:    home · meeting · decision · run · sop · log · note · report
home:    container path minus numbered root (e.g. Invoicing, or Client Engineering/Team Dashboard)
client:  Internal   (additive per-vault list — add your clients as values; default Internal)
status:  Not Started · In Progress · Completed · Inactive · Blocked
date:    YYYY-MM-DD
```

- Status strings are EXACT — Title Case, spaces included. Never improvise.
- Blank `home:` = untriaged (the sweep queries for it).
- Templates may add typed extensions (`cadence:`, `issues:`, `source:`);
  extensions never replace the core five.
- Optional queryable keys, **present only while true** (delete the key
  the moment it stops being true, so a grep returns only live hits):
  - `blocked_on:` person or dependency — pairs with `status: Blocked`
  - `due:` YYYY-MM-DD — real deadlines only, never aspirational dates

## Status semantics per type

| type | gloss |
|---|---|
| home | full project lifecycle, all five words |
| meeting | Completed = filed after the fact; pre-drafted agenda = Not Started |
| decision | Completed = made; Blocked = waiting on someone; Inactive = superseded |
| run | Completed = ran clean; Blocked = died (detail in `issues:`) |
| sop | Completed = in force; Inactive = retired |
| log | Completed always (filed history) |

## Filing (one line each; judgment guidance in Conventions.md)

1. End state → `01 Projects`. Standing duty → `02 Responsibilities`.
2. Everything project-scoped lives IN the project and archives with it.
3. Meetings about a project → that project; else `03 Meetings/<series>/`.
4. Lookup-only, no ownership → `04 Resources`.
5. Unfilable → `00 Inbox` (+ `source: claude` if Claude filed it).
6. Status is frontmatter, never location.
7. Grouping folders: one level max, two-project minimum, status on children.
8. Archive takes finished AND scrapped containers; Home status says which
   (Completed vs Inactive).

## Naming

- Dates `YYYY-MM-DD` everywhere; dated notes start with the date.
- Home notes: `<Container Name> Home.md`, never bare `Home.md`.
- Container names unique across Projects + Responsibilities.
- Grouped project folders drop the group prefix.

## Hard rules

- `05 Personal/` is never read or written unless explicitly asked — with
  ONE carve-out (amended 2026-08-07): skills MAY create and append to
  `05 Personal/Action Items/`, the personal action-item list. Action
  items assigned to THE VAULT OWNER (`name:` in Context.md) — and only
  those — are mirrored there from wherever they're captured; other
  people's items stay in the source note only. The list is canonical
  for open/done state; source notes hold the historical snapshot.
  Nothing else in 05 Personal is ever touched.
- Top-level structure is immutable — personalize in depth only.
- Skills hardcode only `99 System/` paths.
- `99 System/Vault Index.md` is GENERATED — regenerate at session start,
  never hand-edit.
- **C2 plugin skills are tuned per vault via `99 System/Skill
  Preferences.md`.** When the user asks to change how a skill behaves
  ("read transcripts differently from now on"), record the preference
  there — skills read it at runtime, and plugin updates never touch it —
  then note the change in `99 System/Skill Index.md`. Never edit a
  plugin skill's files (updates overwrite them), and never treat a
  skill's behavior as fixed. Personal skills (created by
  `c2-make-a-skill` in this vault's `.claude/skills/`) are edited
  directly.
- Status digests are generated **on request only** (never automatic)
  into `99 System/Reports/` with `type: report`, dated filename.
- One home per fact: never duplicate state between notes — link to it.
  (Generated files are renders, not duplicates.)
