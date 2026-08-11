# Skill Index

Every skill available in this vault. C2 skills are delivered by the C2
plugin and update centrally — tune them in `99 System/Skill
Preferences.md`, never by editing plugin files. Personal skills live in
this vault's `.claude/skills/`, created via `c2-make-a-skill`.

## C2 plugin skills

- **c2-onboard** — scaffolds a blank vault from the template (empty
  folder → full structure), then runs the onboarding interview: six
  questions, one at a time, folders by approval; generates the first
  Vault Index and offers connectors (Gmail + Google Drive by default,
  then a menu: Microsoft 365, GitHub, Lucid, DocuSign, QuickBooks,
  Trello — guided setup, each verified with a real read).
- **meeting-notes** — turns a meeting transcript/summary (PLAUD txt,
  Gemini docx, paste) into a structured meeting note filed to the right
  project (asks when unsure), extracts action items, and mirrors the
  vault owner's items to `05 Personal/Action Items/`.
- **gmail-triage** — processes the inbox via the Gmail connector:
  urgent items first, owner's action items extracted to
  `05 Personal/Action Items/`, read-only on the mailbox (never sends,
  archives, or deletes).
- **validate-live-html** — step 1 of the dashboard-documentation flow:
  complete audit of a live HTML dashboard (all tabs; sources,
  calculations, output by independent recompute, Excel-engine spot
  check), ends with an audit file and open caveats for the vault owner.
- **html-documentation** — step 2: after the caveats are answered,
  builds the dashboard's Word documentation in the approved house style
  (Template v2). Refuses to run without a confirmed audit.
- **c2-make-a-skill** — helps you create a personal skill: explains how
  skills work, interviews you, writes the SKILL.md into this vault with
  the C2 guardrails baked in, and logs it below.

## Personal

- (none yet — ask Claude to run `c2-make-a-skill`)
