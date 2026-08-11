# C2 Vault

C2 Group's standard for personal work vaults in [Obsidian](https://obsidian.md),
driven by Claude. One plugin delivers everything: the blank vault template,
a guided onboarding interview that personalizes it, and the skills that do
the recurring work — processing meeting transcripts, triaging email,
auditing and documenting live dashboards, and building new skills of your own.

## Install (one time)

**Claude Code**

```
/plugin marketplace add atinnell97/c2_plugin
/plugin install c2-vault@c2-group
```

Turn on auto-update for the marketplace so new skills arrive automatically.

**Claude Cowork / Claude Desktop**

Sidebar → **Customize → Plugins → Add marketplace** → enter
`atinnell97/c2_plugin` → install **C2 Vault**.

## Get started

1. Create an empty folder for your vault (keep it in a plain local
   location — if it must live under OneDrive, set "Always keep on this
   device").
2. Point Claude at that folder (Claude Code: open it; Cowork: *Work in
   a Folder*).
3. Say **"onboard me"**. The `c2-onboard` skill builds the vault
   structure and interviews you to personalize it.
4. Open the folder as a vault in Obsidian.

## What's inside

| Skill | What it does |
|---|---|
| `c2-onboard` | Scaffolds a blank vault from the template, then runs the onboarding interview |
| `meeting-notes` | Turns a transcript or AI meeting summary into a filed meeting note with action items |
| `gmail-triage` | Processes your Gmail inbox: urgent first, your action items captured, strictly read-only |
| `validate-live-html` | Full audit of a live HTML dashboard — sources, calculations, output, independently recomputed |
| `html-documentation` | Builds the Word documentation for an audited dashboard in the approved house style |
| `c2-make-a-skill` | Helps you create personal skills of your own, guardrails included |

`templates/vault/` holds the vault template the scaffold step copies —
folder structure, system files, and note blueprints.

## Ground rules baked into every skill

- Skills confirm before anything outward — nothing is ever sent,
  scheduled, deleted, or published autonomously.
- Gmail access is read-only, set up per person through Google's own
  consent screen. No credentials are ever handled by a skill.
- `05 Personal/` in your vault is yours; skills touch only the
  designated Action Items list inside it.
- Per-vault tuning lives in your vault (`99 System/Skill
  Preferences.md`) and survives every plugin update.

## Updating

Updates ship new and improved skills. Your vault — structure, notes,
preferences, personal skills — is never modified by a plugin update.
