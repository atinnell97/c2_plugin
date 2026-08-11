---
name: c2-make-a-skill
description: Help the vault owner create or improve a personal Claude skill — answer questions about how skills work, interview them about what they want automated, and write a proper SKILL.md into this vault's .claude/skills/ with the C2 guardrails baked in. Use when the user wants to automate a recurring task, asks how skills work, asks to make/build/edit a skill, or asks "can Claude just do this every time?"
---

# Make a Skill

You help the vault owner turn a recurring task into a personal skill —
or just answer their questions about how skills work. They are usually
not a programmer; explain in plain words, and do the writing for them.

## What to explain (when asked — keep it short)

- **What a skill is:** a folder with a `SKILL.md` instruction file.
  The `description:` line is the trigger — when a request matches it,
  Claude loads the skill and follows it instead of improvising.
- **The two kinds in a C2 vault:**
  - **C2 plugin skills** come from the C2 plugin, update centrally, and
    are tuned per vault in `99 System/Skill Preferences.md` — never by
    editing their files (updates would overwrite the edit).
  - **Personal skills** live in this vault's `.claude/skills/` folder.
    They are the owner's — editable any time, untouched by plugin
    updates, and they work in both Claude Code and Cowork.
- **When a skill is worth it:** the same task keeps coming back, or the
  same instructions keep being repeated. One-off tasks don't need one.

## Building a skill

1. **Interview briefly — one question at a time:**
   - What should trigger it? (the phrases they'd naturally say)
   - What exactly should it do, step by step? (walk their real example)
   - What must it never do?
   - Does it write into the vault — and where?
2. **Check the name.** Kebab-case, descriptive. It must not collide with
   any skill in `99 System/Skill Index.md` — plugin skill names are
   reserved. If their request is really a *tuning* of an existing C2
   skill ("I want gmail-triage to treat X as urgent"), record it in
   `99 System/Skill Preferences.md` instead of building a duplicate —
   tell them that's what you're doing and why.
3. **Draft the SKILL.md**: frontmatter (`name:`, `description:` written
   so their trigger phrases actually match), then a body with the
   procedure in the order it should happen, concrete over abstract.
4. **Bake in the C2 guardrails — every generated skill includes these,
   non-negotiable:**
   - Read `99 System/Contract.md` first and follow it exactly (schema,
     status strings, filing, naming).
   - Confirm before anything outward — nothing is ever sent, scheduled,
     deleted, or published without the user's explicit yes.
   - `05 Personal/` is untouchable except the `Action Items/` carve-out,
     and only if this skill genuinely handles action items.
   - Anything the skill can't confidently file goes to `00 Inbox/` with
     `source: claude`.
5. **Show the draft and get approval** — the skill is theirs; adjust
   wording, triggers, and behavior until they're happy.
6. **Write it** to `.claude/skills/<name>/SKILL.md` in this vault, and
   **log it** in `99 System/Skill Index.md` under `## Personal` (name,
   one-line description, date).
7. Tell them how to invoke it and that they can ask to change it any
   time — editing a personal skill is just another conversation.

## Editing an existing skill

- **Personal skill** → edit its SKILL.md directly (show the change,
  get approval), and note the change in the Skill Index.
- **C2 plugin skill** → never edit files; record the preference in
  `99 System/Skill Preferences.md` under that skill's section, creating
  the section if needed.

## Quality bar

- A skill that needs a tool or connection (an MCP server, a program)
  states the requirement at the top of its body, checks at runtime, and
  degrades gracefully with plain-words setup guidance — never a
  mysterious failure.
- Description lines earn their triggers: write them from the user's own
  phrasing, not abstract categories.
- Small is fine. A five-line skill that nails one recurring task beats a
  long one that tries to do everything.
