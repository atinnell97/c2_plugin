# Skill Preferences

Per-vault tuning for C2 plugin skills. Skills read this file at runtime;
plugin updates never touch it, so everything recorded here persists.
When a skill needs a preference that isn't recorded yet, it asks you
once and writes the answer here. Edit freely, or ask Claude to.

## gmail-triage

Urgency rules — senders, clients, or topics that are always urgent
(e.g. "anything from my supervisor", "invoices from Client X"):

- (none recorded yet — defaults apply)

## meeting-notes

Filing and action-item preferences (e.g. teammate-spillover behavior,
preferred meeting-series folders):

- (none recorded yet — defaults apply)

## Dashboard audit & documentation

Used by validate-live-html and html-documentation:

- python: (path to your Python environment — the skill asks on first audit)
- documentation folder: (where audit files and docs are written — asked on first use)

## (other skills)

Sections appear here as skills need them. One `##` heading per skill.
