# C2 Vault Conventions

This is the rulebook for the whole vault. Humans read it once during
onboarding. **The machine-readable subset — exact schema, status strings,
filing one-liners, naming formats, hard rules — lives in `Contract.md`,
which skills read at runtime instead of this file** (kept separate to cut
per-session token cost). This file holds the judgment guidance and the
why. Change behavior → edit Contract.md; change reasoning → edit here;
never let them disagree.

---

## The map

| Folder                | What lives there                                                                                                                                        |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `00 Inbox`            | Capture with zero filing decisions. A waypoint, never a home.                                                                                           |
| `01 Projects`         | Work with an end state.                                                                                                                                 |
| `02 Responsibilities` | Standing duties — the hats you wear.                                                                                                                    |
| `03 Meetings`         | Meetings no project owns: standing series, 1:1s, all-hands.                                                                                             |
| `04 Resources`        | Reference you don't own.                                                                                                                                |
| `05 Personal`         | **05 Personal is yours, both directions**: the standard never restructures it, and skills do not read or write it unless you explicitly ask. Permanent. |
| `06 Archive`          | Cold storage for finished containers. Never a trash can.                                                                                                |
| `99 System`           | The machine interface: Context.md, Contract.md, Skill Preferences.md, Skill Index.md, Version.md, the generated Vault Index.                            |
| `Templates`           | Blueprints for new notes, frontmatter pre-filled.                                                                                                       |

Each folder's About note explains its purpose at the point of confusion.
The top level is immutable — personalization happens in depth (subfolders
and notes), never in structure.

---

## Filing rules

1. Has an end state → **Project**. Any distance, any cadence. A monthly
   refresh until December is a slow heartbeat, not a stalled project.
2. Everything scoped to a project — meetings, decisions, automations,
   refresh logs — lives **inside** the project and archives with it.
   Never split one duty across two containers.
3. A standing duty that survives projects → **Responsibilities**. Keep it
   job-description short. If it grows past a handful of hats, something
   project-scoped leaked upward.
4. Shared tools serving many projects: tool knowledge and the shared SOP
   live in **Responsibilities**; each project's run records live in that
   project and link to the shared SOP.
5. **Status is frontmatter, never location.** Notes don't move to show
   state.
6. No ownership, just lookup → **Resources**.
7. Related projects may share **one grouping folder** (e.g.
   `Client Engineering/`). One level max. Two-project minimum. Status
   lives on the child projects, never the group. The Archive mirrors the
   grouping.
8. A meeting *about* a project files **in that project**. Everything else
   files in `03 Meetings`, one subfolder per series.
9. Claude's unfilable outputs land in `00 Inbox` tagged `source: claude`.
   The Inbox trends toward empty — sweep it weekly.

Promotion rule: a project-scoped duty that outlives its project moves up
to Responsibilities at project close; the finished project archives with
its old logs.

---

## Naming

- **Dates are `YYYY-MM-DD`, everywhere** — frontmatter values and filename
  prefixes. Dated notes (meetings, logs, decisions) start with the date:
  `2026-08-11 Kickoff Meeting.md`.
- **Home notes take the container's name**: `Team Dashboard Home.md`,
  never a bare `Home.md` (forty identical `[[Home]]` links is chaos).
- **Grouped project folders drop the redundant prefix**: the hierarchy
  carries context — `Client Engineering/Team Dashboard/`, not
  `Client Engineering/Client Engineering Team Dashboard/`.
- **Container names are unique across Projects and Responsibilities**, so
  a bare `home:` value always resolves to exactly one place.

---

## Frontmatter schema

Five required keys on every templated note:

```yaml
---
type:    meeting · decision · run · sop · note
home:    the note's Project or Responsibility
client:  your client list · Internal
status:  Not Started · In Progress · Completed · Inactive · Blocked
date:    YYYY-MM-DD
---
```

**`type`** — baked into each template. What query skills filter on first.

**`home`** — the container's folder path minus the numbered root:
`Invoicing`, `Client Engineering/Team Dashboard`. Plain text, no
brackets. **Blank `home` means untriaged** — the weekly sweep is
literally the query for blank-home notes.

**`client`** — required on every note. Default is `Internal`. New clients
are added to the Contract's list as values; additive, safe.

**`status`** — exact strings, Title Case, spaces included: `Not Started`,
`In Progress`, `Completed`, `Inactive`, `Blocked`. Never improvise casing;
skills match literally. Per-type glosses where meaning isn't obvious:

| type | notes on status |
|---|---|
| meeting | `Completed` = filed after the fact. An agenda drafted beforehand starts `Not Started`. |
| decision | `Blocked` = waiting on someone. `Completed` = made. |
| run | `Completed` = ran clean. `Blocked` = died on a dependency. Details go in the `issues:` key. |
| sop | `Completed` = currently in force. `Inactive` = retired. |
| project home | Full lifecycle, all five words. |

**`date`** — auto-filled by the template.

**Typed extensions**: individual templates may add optional keys on top of
the required five — `cadence:` on Project Home, `issues:` on run logs,
`source:` on fallback notes. Extensions never replace the core five.

**The two-blank rule**: a human filing manually fills at most `home` and
`client`. `date` auto-fills, `type` is baked into the template, and skills
fill everything when they do the filing.

---

## Tags and links

Frontmatter properties are the load-bearing metadata in this vault —
`type: meeting` does the work `#meeting` would do elsewhere, reliably.
Inline `#tags` are optional personal seasoning; no skill or convention
depends on them.

Link generously with `[[wikilinks]]`: run logs link up to their shared
SOP, decisions link back to the meeting that made them, project home
notes link to their Responsibility of origin. Links are how the vault
becomes a web instead of a filing cabinet.

---

## The contracts

- **05 Personal is inviolable, both directions**: the standard never
  restructures it, and skills never read it. Permanent — with one scoped
  amendment (2026-08-07): `05 Personal/Action Items/` is the designated
  home of the personal action-item list, and skills may write to that
  folder only. Rationale: action items from every context (meetings,
  projects, email) belong to the *person*, so their unified to-do view
  lives in their personal space. The rest of 05 Personal keeps the full
  guarantee.
- **Skills hardcode only `99 System/` paths.** Everything else they learn
  from the Contract at runtime. That is why this vault keeps working
  across template versions.
- **Your vault is yours.** Template updates apply only to vaults created
  after them. Nothing ever reaches in and restructures a deployed vault.
  Version.md records what this vault was born from; newer versions are
  inform-only, opt-in, never automatic. (New and improved *skills* do
  arrive via plugin updates — but skills only ever act within these
  contracts.)
- **Skill tuning is per-vault and survives updates.** C2 plugin skills
  read `99 System/Skill Preferences.md` at runtime; your preferences live
  there, never in the plugin's files. Personal skills live in this
  vault's `.claude/skills/` — ask Claude to run `c2-make-a-skill` to
  build one; `99 System/Skill Index.md` is the inventory.
