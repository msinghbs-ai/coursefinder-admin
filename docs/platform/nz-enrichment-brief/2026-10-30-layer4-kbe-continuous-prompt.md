# Continuous direct-KBE Layer 4 controller — prompt and delivery

Date: 30 October 2026
Status: ready to install and use; no Kimi Work required

## Deliverables

- Skill: `cf-layer4-kbe`
- Controller: `docs/platform/skills/cf-layer4-kbe/SKILL.md`
- Action playbook: `docs/platform/skills/cf-layer4-kbe/references/action-playbook.md`
- Package: `cf-layer4-kbe.skill`
- Package size: 9,023 bytes
- Package SHA-256: `12d196a04a2c9efe2aa7999a184364293b0d9d70da03ad045fac0330e86184fc`

Canonical commits:

- Controller: `d597ab7085ab37ad6dd09e182aefa4b9655362e8`
- Exact v5 playbook match: `aa43a014bcd68e3c2cd50a54b138887986f908a0`

Use this controller instead of `cf-layer4-course-link-kbe` when the mandate is the whole queue. The focused Course link Skill and general v5 Work Skill remain unchanged.

## Run continuously in the browser sidebar

1. Install `cf-layer4-kbe` in Kimi Skills.
2. Open the authenticated **Platform Admin → Data pipeline → Layer 4 Review** tab.
3. Open the Kimi Browser Extension sidebar. Do not configure local-agent remote control.
4. Type `/`, select `cf-layer4-kbe`, then paste:

```text
layer4-kbe-continuous

Use the current authenticated Platform Admin tab. Continue automatically through every current Layer 4 kind By kind until no currently actionable stored-evidence items remain after a complete pass and one final refresh, or until a safety/authorisation stop condition is reached. Do not ask me whether to continue between items or kinds.

This instruction authorises the existing evidence-supported UI decisions, including review of existing AER Inbox items one item at a time under Platform Admin. It does not authorise generic bulk decisions, provider mergers, paid re-reads, AI re-checks, Firecrawl or new source acquisition.

For each kind and materially different action route, prove the first saved outcome before repeating it. Process oldest first using stable refs. Complete linked destination corrections and verify actual field/page/row admission; do not count navigation, queued reads/refreshes/rebuilds or deferred outcomes as admitted values.

Keep one consolidated checkpoint in this sidebar chat every 10 decisions, every 20 reviews without a decision and at every kind transition. Move automatically to the next kind when the current kind has no eligible work. Do not re-review unchanged blockers. Reconcile eligible newly raised work once, then stop with the remaining-exception register.

Use stored evidence only, no SQL and no Decided view. Report reconciled, admitted/applied, downstream, deferred, left pending and newly raised separately, with owner and next action for every unresolved class. Never force the queue to zero.
```

Keep the run in the **same sidebar chat** so its checkpoints remain visible. If it pauses there, use:

```text
layer4-kbe-continuous resume
```

After losing the chat, start a new batch from current queue state; do not claim a portable resume or repeat refs already absent.

## What continuous means

The controller automatically:

- selects the next eligible kind;
- qualifies each new kind/action route with a real saved outcome;
- submits and verifies one item at a time;
- completes linked destination work before claiming closure;
- moves admitted values into their existing destination records/fields;
- records downstream reads, refreshes and rebuilds separately;
- skips unchanged evidence/identity/policy blockers;
- transitions without asking for repeated confirmation;
- makes one complete pass, handles eligible new work once and returns the final exception register.

It stops for authentication/role loss, unreliable writes, shared evidence defects, unexpected consumer-visible changes, irreconcilable queue state, unknown UI contracts, or work requiring separate source/spend/merger/policy authority.

## Why absolute zero is not the completion criterion

A continuous sidebar run can clear all **currently actionable** items, but it cannot legitimately guarantee an empty queue:

- unreadable/missing sources require evidence acquisition;
- identity, ownership, duplicate and policy conflicts require human resolution;
- some choices require separate authority or a current official source;
- downstream jobs can raise new items;
- new operational work can arrive after the final refresh.

The successful end state is therefore **no eligible stored-evidence work left**, with every remaining item assigned an owner and next action. It must never publish, archive or admit uncertain data to make the count reach zero.

## Validation

- Skill validation: passed.
- Packaged entries: exactly controller `SKILL.md` and `references/action-playbook.md`.
- ZIP integrity: passed.
- Packaged/local source comparison: exact for both files.
- Controller Git blob SHA-1: `f89e1131c14e9169533795f23e8d1dd18ca114ab` (local and canonical match).
- Playbook Git blob SHA-1: `f09e9a74b3bcdb3374b4a346bb78c2bf64bfb588` (exact canonical v5 match).
- No scripts, local-agent dependencies or helper files.
- No live Platform Admin decision was submitted during construction or validation; first-use route qualification remains mandatory.
