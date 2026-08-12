---
name: c2-onboard
description: Set up a C2 vault — scaffold the folder structure from the template if the folder is empty, then run the onboarding interview for a new employee: six questions, one at a time, filling 99 System/Context.md and creating approved seed folders under Projects, Responsibilities, and Meetings. Use when pointed at an empty folder to become a vault, when Context.md is blank, or when the user asks to be onboarded or set up.
---

# C2 Onboarding

You are onboarding a C2 Group employee into their new vault. First make
sure the vault exists (scaffold), then interview them. The interview
fills `99 System/Context.md` and seeds their folder structure. Every C2
skill and chatbot session will read what you write here first — write it
for them.

## Step 0 — scaffold (only when the folder is not yet a vault)

If the current folder has no `99 System/` directory (an empty folder, or
one that is clearly not a C2 vault):

1. Confirm with the user that THIS folder should become their C2 vault.
2. Copy the entire vault template from
   `${CLAUDE_PLUGIN_ROOT}/templates/vault/` into the folder — all
   folders, About notes, `99 System/` files, `Templates/`, `CLAUDE.md`,
   `Start Here.md` — exactly as shipped. Never improvise structure.
3. Verify the copy: folders `00 Inbox` through `06 Archive`,
   `99 System`, and `Templates` all present.

If `99 System/` already exists, never re-copy — an existing vault is
never overwritten. Continue below.

## Before the interview

1. Read `99 System/Contract.md` and follow it exactly: frontmatter
   schema, exact status strings, naming, filing rules. Hardcode only
   `99 System/` paths; learn everything else from Contract at runtime.
2. Read `99 System/Context.md`. If it is already filled in, STOP and ask
   whether they want to re-run onboarding (which updates answers) —
   never silently overwrite an existing Context.

## The rules (non-negotiable, hold them for the whole interview)

- Ask **ONE question at a time**. Wait for the answer.
- After each answer, **write it into the vault immediately**, before
  asking the next question.
- The user may say **"skip"** on any question — leave that item blank and
  move on. Blanks are noted in the final summary, never guessed at.
- Before creating **any** folder: list exactly what you will create and
  **wait for approval**. Offer a "different name" option — the duty or
  project is theirs to name.
- Write **only** into `99 System/Context.md` and approved seed folders.
  **Never change the top-level structure.** Never touch `05 Personal/`.

## Branch check — existing material (ask before Question 3)

Ask whether they already have work material: an old Obsidian vault, a
notes folder, a working directory. If yes:

- **Survey it first, read-only.** Folder tree, file counts, key documents.
  Verify what it actually is — a stated "vault" may turn out to be a code
  repo whose docs point at the real vault.
- Then run Questions 3–4 in **propose-from-data mode**: propose candidate
  duties and projects from what you saw and ask confirm/deny/rename,
  instead of asking cold. Proposals beat blank questions.
- If they want the old vault's notes brought in: that is a **migration**,
  a separate approved-plan operation — survey → filing map presented for
  approval → convert (their schema → Contract schema, provenance keys
  `migrated:` + `canonical:` pointing at the untouched original) → rewrite
  wikilinks for renames → link audit proving zero breakage. Never move or
  edit the original vault; copy only. Anything unfilable → `00 Inbox`.

## The six questions

**1. Name, role, and team** → Context.md frontmatter `name:`, `role:`,
and `team:`. The name matters operationally: skills use it to recognize
which action items, mentions, and assignments belong to the vault owner
— capture the name they actually go by in meetings/transcripts (and any
username, e.g. `jdoe`, if it differs).

**2. Primary client** → frontmatter `primary_client:`. Offer the client
list from Contract.md as options plus skip. Default is Internal. If they
name a client not yet in the Contract's list, add it there (additive,
safe).

**3. Standing duties** — the hats they wear regardless of any project
(recurring maintenance, systems they keep running, things they own that
survive projects). For each duty, propose one folder under
`02 Responsibilities/` (approval first), then create it with a
`<Duty> Home.md` from the Project Home template. Write the duties into
Context.md's **What I do** section as you go.

**4. Active projects** — for each project, ask (one at a time, sub-answers
written as received):
- end state? (none/indefinite is a valid answer — record it honestly)
- client?
- part of a group of related projects? (grouping folder: one level max,
  two-project minimum, status lives on children)
- recurring cadence? (free text, e.g. "Hourly, every day")

Clarify structural ambiguity before creating anything — e.g. "Team and
high-level versions: one project containing both, or two projects?"
Then propose the folder set (approval first) and create each project with
a `<Project> Home.md` from `Templates/Project Home.md`: status and cadence
from their answers, `## Current state` first, end state recorded, and a
link up to its Responsibility of origin if one exists. Add each project
to Context.md's **Active projects** section as it is settled.

**5. Recurring meeting series** — meetings no single project owns (1:1s,
team syncs, all-hands). One subfolder each under `03 Meetings/` (approval
first). Meetings *about* one project file in that project instead — say
so if their answer belongs there. Record in Context.md **Recurring
tasks**.

**6. Anything a future project should know about how they work** — tools,
habits, constraints, preferences. Write it into Context.md's last section
**verbatim** — their words, not a paraphrase.

## Writing rules

- New notes come from `Templates/`, five-key frontmatter complete, exact
  Title Case status strings, `home:` = container path minus the numbered
  root, `date:` = today.
- Home notes are named `<Container Name> Home.md`, never bare `Home.md`,
  with `## Current state` as the first section.
- Link generously with `[[wikilinks]]` — project Homes link to their
  Responsibility, Responsibility Homes list their projects.

## Closing moves (after Question 6)

1. **Summarize everything created and note anything left blank.** The
   summary is the receipt; blanks are honest, not failures.
2. **Generate the first `99 System/Vault Index.md`** by scanning every
   `*Home.md` under 01/02/06. Format — header line with generation date, a
   `GENERATED FILE — do not edit` comment, then sections `## Projects`,
   `## Responsibilities`, `## Archive` with one line per container:
   `- **Name** (Group) | status | client | cadence — one-clause purpose`,
   and a `## Hygiene` footer (Inbox count awaiting sweep, blank-`home`
   note count). This file regenerates at every session start thereafter.
3. **Toolchain check — connectors, in two tiers.**

   **Tier 1 — ask everyone, one at a time: Gmail, then Google Drive**
   (each optional, skippable, doable later). One line each on what it
   unlocks: Gmail powers `gmail-triage`; Google Drive lets Claude read
   the Drive files their meetings and projects reference.

   **Tier 2 — one menu question, only after Tier 1:** "C2 also supports
   these, if you use them in your work — want to connect any?
   **Microsoft 365** (SharePoint, OneDrive, Outlook, Teams), **GitHub**
   (repos, issues, pull requests), **QuickBooks** (books, invoices,
   reports), **Trello** (boards and cards)." They pick any, none, or all — never
   push; a tool they don't use is a "no" you accept in stride. Anything
   skipped gets one line in the summary: connect later by asking Claude.

   For every connector they say yes to:
   - **Walk them through in plain words:** in Claude's settings,
     Customize → Connectors → pick the service → sign in with their
     work account → Allow. About 3 clicks each, one time. Never ask
     for credentials yourself — the service's own consent screen
     handles all auth.
   - **Then verify by actually reading something harmless.** A
     connector isn't "set up" until a real read succeeds. Gmail: most
     recent message's sender + subject only (never the body) — say
     "connected; your latest email is from X." Drive: search for any
     file, confirm results. Menu connectors: the equivalent smallest
     read — list/search something (M365: find a file; GitHub: list
     their repos; QuickBooks: company info; Trello: list boards) — and
     never read anything sensitive aloud.
   - **If it fails or the service says "blocked — ask your admin":**
     say so plainly, tell them this needs IT to approve the connector
     for the company (a one-time admin step), and move on — never
     leave a failure mysterious, never retry-loop a consent screen.

   Note every outcome (connected / skipped / blocked) in the closing
   summary. Point them at `99 System/Skill Preferences.md` as the place
   their skill tuning will live.
4. Remind them of the two follow-up rhythms: the Inbox sweep (Inbox
   trends toward empty) and that status digests exist on request.
