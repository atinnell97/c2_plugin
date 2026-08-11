# C2 vault

This folder is a C2 Group Obsidian vault, created from the C2 vault
template (`99 System/Version.md` records which version).

- **First session check:** if `99 System/Context.md` has blank frontmatter
  (`role:` empty), this vault hasn't been set up — offer to run the
  `c2-onboard` skill before anything else. Don't force it; offer it.
- **Prefer skills over improvising.** When a request matches a C2 skill —
  a transcript arrives (`meeting-notes`), email needs checking
  (`gmail-triage`), a dashboard needs auditing (`validate-live-html`) or
  documenting (`html-documentation`), the user wants to automate something
  (`c2-make-a-skill`) — invoke the skill rather than handling the task ad
  hoc. The skills carry guardrails and vault conventions that ad-hoc
  handling loses. `99 System/Skill Index.md` lists what's available.
- C2 skills arrive via the C2 plugin and update centrally. Tuning them is
  per-vault: record preferences in `99 System/Skill Preferences.md`, never
  by editing plugin files (updates would overwrite the edit).
- Before creating, moving, or filing any note, read `99 System/Contract.md`
  (the compact machine rules: schema, status vocabulary, filing, naming)
  and follow it exactly. Read `99 System/Conventions.md` only when you need
  the judgment guidance behind a rule.
- At the start of each session, regenerate `99 System/Vault Index.md` (it
  is a generated file — never hand-edit it), then use it as your map of
  the vault.
- Don't read or write anything under `05 Personal/` unless the user
  explicitly asks you to. One carve-out (see Contract): skills may create
  and append to `05 Personal/Action Items/` only.
- Anything you cannot confidently file goes in `00 Inbox/` with
  `source: claude` added to its frontmatter.
- New notes are created from the blueprints in `Templates/`.
