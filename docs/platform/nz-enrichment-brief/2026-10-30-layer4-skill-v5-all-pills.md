# Layer 4 triage Skill v5 — all current pills

Date: 30 October 2026  
Authority: Platform Admin request to extend `cf-layer4-triage` so a v5 package covers every Layer 4 Review filter/pill and its required actions, closing supported outstanding items as quickly as safe.  
Status: design decision lodged before Skill source changes. No Pilot code, migration, UI, queue or canonical-data change is included.

## Current gap

The live UI contract `security.layer4_inbox_kinds_v1()` exposes 17 decision kinds. The v4 action playbook covers 14. It has no category-specific rules for:

- `aer_review` — Entry requirements (AER);
- `site_down` — Website not answering;
- `counsellor_report` — Counsellor report.

V4 can qualify one kind and run provider batches, but has no resumable command dedicated to draining one pill across providers.

## V5 decisions

1. **Cover all 17 current kinds.** The action playbook will name every current kind, its existing UI choices, required evidence, action-completion condition and exceptions. No new UI choice, status, panel or backend route is introduced.
2. **Add single-kind execution.** Add `layer4-clear-kind <kind>` to process one exact current kind across providers, oldest first, one item at a time, with periodic checkpoints and safe resume. Keep the existing bounded qualification and provider workflows.
3. **Preserve per-route proof.** The first saved decision in each kind/action route must be verified before continuing. Initial workstation qualification remains bounded to five decisions in a conservative suitable kind.
4. **Keep AER human-governed.** AER decisions are Platform Admin only and one item at a time. A sequential kind batch is not a generic bulk decision. Apply the current A1–A5 and D4 rules, including stored-copy/newest-run checks, row evidence, completeness, scale/basis, exclusions, stale-item rejection and held conflicts. No AER re-read or spend is authorised by this Skill change.
5. **Complete linked actions before claiming closure.** Choices such as Open the course, Open the adapter, Add page addresses and Open the central pages are navigation, not decisions. The required correction/approval must be completed through the existing destination UI and the Layer 4 item verified closed before progress is reported.
6. **Keep evidence and role gates.** Stored evidence only by default; no new acquisition, AI re-check or Firecrawl without explicit authorisation. Existing rank checks remain authoritative. No evidence-free publish, admission, archive, source replacement or provider merger.
7. **Do not force zero.** Items with inadequate/conflicting evidence, missing authority, downstream work or repeated defects remain pending with stable refs, owner and next action. `Keep waiting`, queued rebuilds and similar outcomes are reported separately from reconciled/admitted work.
8. **Require specific approval for exceptional ownership actions.** A generic all-kind/all-provider command is not approval for a provider merger, ownership change or other exceptional action. Those remain pending unless separately authorised for the exact item.
9. **Stop on unknown future kinds.** V5's all-pills contract is the 17-kind UI checked on 30 October 2026. If a later pill is absent from the playbook, leave that kind pending and report the contract gap rather than guessing.
10. **Retain audit behaviour.** Record stable UI refs, actual decisions, verified queue exits, downstream outcomes and exceptions. Inbox history and routed detail remain separate ledgers; never double-count an action appearing in both.

## Current 17-kind coverage contract

| Key | Pill |
|---|---|
| `course_link` | Course link |
| `held_scholarship` | Held scholarship |
| `website_needed` | Website needed |
| `pages_not_found` | Course pages not found |
| `too_few_pages` | Too few course pages |
| `nothing_ready` | Adapter has nothing ready |
| `central_to_approve` | Central pages to approve |
| `onboarding_failed` | Adapter proposal failed |
| `site_down` | Website not answering |
| `not_offered` | Course not offered |
| `fee_check` | Fee fails the check |
| `counsellor_report` | Counsellor report |
| `not_on_site` | Course not on the university's site |
| `provider_departure` | Provider left the register |
| `no_page_first_run` | No page published: first run |
| `conjoint_first_run` | Conjoint or double degrees: first run |
| `aer_review` | Entry requirements (AER) |

`All` remains an unfiltered navigation option, not an eighteenth decision kind or a bulk-approval command.

## Acceptance checks

- All 17 keys appear in the packaged action playbook with actionable existing-choice guidance.
- AER, Website not answering and Counsellor report have explicit new sections.
- The Skill includes single-kind execution, per-route first-decision verification, linked-action completion and unknown-kind stop rules.
- No instruction permits select-all approval, arbitrary SQL, direct database writes, evidence-free consumer-visible changes or autonomous provider mergers.
- Canonical GitHub source and portable package contain the same v5 text.
- Skill validation and ZIP integrity/content checks pass; package SHA-256 is recorded here before handover.

## Sources checked

- Live read-only `security.layer4_inbox_kinds_v1()` on 30 October 2026: current labels, choices, role limits and return paths.
- Pilot `src/Layer4Inbox.jsx`: filter behaviour, linked actions and one-item AER controls.
- Admin `docs/platform/LAYER4-INBOX-DESIGN.md`: Inbox choices and return paths.
- Admin `docs/platform/AER-ROLE-GUIDES.md` §§4–5: Platform Admin review, evidence and A1–A5 behaviour.
- Admin `docs/platform/ui-audit/2026-10-30-D4-design-note.md`: Approve except supersession and held conflicts.
- Pilot `docs/sops/operator-sop.md`: Counsellor report correction/closure workflow.
- Current canonical `docs/platform/skills/cf-layer4-triage/` v4 source.

## Delivery record

To be completed after source update and package validation.
