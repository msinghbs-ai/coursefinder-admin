# Continuous direct-KBE Layer 4 controller — design

Date: 30 October 2026
Status: approved design for implementation in this mandate

## Decision

Create `cf-layer4-kbe`, a direct Kimi Browser Extension sidebar controller for all 17 current Layer 4 kinds. Reuse the canonical v5 action playbook unchanged. Leave both `cf-layer4-triage` v5 and `cf-layer4-course-link-kbe` unchanged.

The controller will run **By kind**, move automatically to the next kind after the current kind has no eligible stored-evidence work, and continue without asking for repeated confirmation while the user's mandate and existing UI permissions cover the action.

## Finish line

The supported finish line is:

> No currently actionable stored-evidence items remain after a complete pass and final refresh, or a safety/authorisation stop condition is reached.

“Absolutely cleared” cannot be guaranteed. Source gaps, identity/ownership conflicts, policy judgement, duplicates, unavailable roles, failed writes, deferred outcomes and newly arriving items must remain visible and pending where required. The controller must never force pending to zero.

## Continuous orchestration

1. Start on the authenticated Platform Admin Layer 4 Review tab in the direct KBE sidebar; no Kimi Work, local-agent remote control, SQL, GitHub or helper files.
2. Create one batch id and record current counts. Match live pills to the 17-kind playbook; stop on an unknown/changed contract.
3. Select one exact kind with pending, eligible stored-evidence work. Prefer the current/resumed kind; otherwise use the oldest eligible work and avoid repeated broad scans.
4. Verify the first decision and each distinct action route before repeating it in that browser session. Qualification for one kind/route does not qualify another.
5. Process oldest first, one item at a time. Submit actual existing choices, complete linked destination work and verify each ref leaves Waiting for a person.
6. Record actual field/page/row admission separately from refusal, rejection, navigation, deferred outcomes and downstream reads/rebuilds/onboarding.
7. Checkpoint in the sidebar chat every 10 decisions, every 20 reviews without a decision, and at every kind transition.
8. When a kind has no eligible work, record pending exceptions and move automatically to the next kind. Do not loop over unchanged blockers.
9. Reconcile a newly raised item once when the same rule/evidence applies; leave a second re-raise as a defect. Do not repeatedly rebuild or retry.
10. After all kinds have been passed, refresh once. Process eligible new work once, then stop with the remaining-exception register. Do not run an unbounded loop chasing newly generated work.

## Authority and safety

- Stored evidence only by default; no new AI re-checks, Firecrawl, paid reads or new source acquisition without separate explicit authorisation.
- Existing UI decisions only; no SQL, direct database writes, deletion, select-all or generic bulk approval.
- No manual value/binding overwrite, uncertain publication/admission/archive, autonomous reader repair or consumer/API change.
- AER: the continuous prompt explicitly authorises review of existing AER Inbox items under Platform Admin, one item at a time; no generic bulk decision or AER re-read/spend.
- Provider mergers still require separate explicit approval for the exact provider and successor. CRICOS-data-only choices require existing policy or explicit operating authority.
- Stop for authentication/role loss, repeated uncertain writes, shared evidence/decision defects, unexpected consumer-visible changes, irreconcilable queue state or unknown UI contracts.

## Direct-sidebar operation and recovery

- Read page text/controls first; screenshot only for unclear state/errors.
- Keep the consolidated checkpoint in the current sidebar chat. Resume only while that checkpoint remains visible; otherwise start a new batch from current queue state and skip refs already absent.
- Do not open the failing Decided view or request SQL.
- Final report distinguishes reconciled, admitted/applied, deferred, downstream work, left pending and newly raised, with owner/next action for every unresolved class.

## Deliverables

- Installable `cf-layer4-kbe.skill` containing the controller and canonical v5 action playbook.
- Canonical sources under `docs/platform/skills/cf-layer4-kbe/`.
- Copy-paste continuous sidebar prompt.
- Validation, integrity and canonical-source comparison recorded in the delivery document.
