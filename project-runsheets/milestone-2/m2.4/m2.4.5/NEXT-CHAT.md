# M2.4.5 NEXT CHAT

Recommended chat name:

`CF M2.4.5 — Recovery Closure, Remaining Gates & Pre-Production Hardening — 2026-09-07`

Continue CourseFinder M2.4.5 from repository/runtime truth. Do not rely on the previous chat as the authoritative state.

## Mandatory start — no material work before reconciliation

1. Read `PROJECT_INSTRUCTIONS.md`.
2. Read `docs/README.md` as the authoritative current-document router.
3. Read `docs/01-governance/coursefinder-pim-operating-principles-v1.0.md`.
4. Read `docs/01-governance/coursefinder-troubleshooting-bugfix-recovery-protocol-v1.0.md`.
5. Read `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md` and applicable M2 execution addenda, especially ranking/provider-asset/contact authorities where the next task overlaps.
6. Read `change-control/README.md`, `change-control/REGISTER.md`, CF-087 and the owning/recent corrective Change Controls.
7. Read current M2.4.5 `RUNSHEET.md`, `CURRENT-STATE.md`, `FOLLOW-UPS.md`, `WORK-ITEM-LEDGER.md` and `MEETING-READINESS.md`.
8. Reconcile the current Pilot repository head, current deployed Supabase/runtime state and exact latest CI/UAT runs before changing shared foundations.
9. Reconcile the current visible release/currentness authority and release record before any browser-visible fix.
10. If any test is red, classify it as implementation, data, UAT-contract, deployment/currentness, environment/configuration, governance drift or mixed before changing code/test/schema.

## Standing troubleshooting / bug-fix guardrails

For every bug, failed UAT, regression or large corrective fix:

- inspect exact failing evidence before changing implementation;
- verify the workflow resolver selected the intended suite;
- do not rerun repeatedly without a material fix or justified transient reason;
- do not weaken a correct security/authority/data rule merely to obtain PASS;
- change a UAT expectation only when repository/runtime evidence proves the old expectation stale or semantically invalid;
- preserve source grain, canonical identity, Evidence and null/zero/suppressed semantics;
- do not add canonical schema fields merely to mirror an Excel/CSV/API shape without first checking source-payload/indicator/attribute structures;
- apply the smallest safe fix first;
- use targeted validation → bounded integration → one nominated broader acceptance;
- keep the feature gate OPEN until the exact intended deployed acceptance passes;
- record exact failed/PASS run IDs, implementation refs, rollback and next action in repository continuity docs;
- do not promote a browser-visible version while its required functional gate is red, cancelled or unrun.

The authoritative detailed protocol is `docs/01-governance/coursefinder-troubleshooting-bugfix-recovery-protocol-v1.0.md` and must be inherited by every future troubleshooting/recovery chat.

## Recovery status at handoff

### CLOSED / proven

- Ranking dataset recovery gate: CLOSED after exact CF-097 deployed recovery PASS.
- Compare recovery functional gate: CLOSED after exact deployed run `34068759607` at commit `7c3022e72df0fcd6fcb0d312d106bb9349d3f6c2` passed all 3 CF-061 tests.
- Provider Compare aligned QILT rows / PRISMS context: PASS.
- Provider-first Course Compare: PASS.
- Course detail QILT Provider context → Course Compare: PASS.
- Role-safe Layer Status summary corrective migration applied and directly rechecked.

### Release/currentness promotion now in progress

Functional acceptance passed before version promotion.

Promotion commits in `msinghbs-ai/Coursefinder-Pilot`:

- `51c50d161705ab079b2d7204eb502826ecaf2597` — visible currentness authority promoted to v2.15.72.
- `2551bc883c16c4f043145cb1961566c3c78bed64` — browser title promoted to v2.15.72.
- `e205bc693c565f84f091de7745a613a09d00170a` — exact Compare deployed suite now requires v2.15.72 currentness.
- `ee4ca0bc8a05c285123365e36a2311e4928c61e1` — v2.15.72 release record marked accepted with run `34068759607` evidence.
- `8bc6960d05e5521ff6ae44ad0ee49e7c07ef80ff` — exact currentness/Compare proof rerun trigger.

**FIRST ACTION IN NEXT CHAT:** query workflows for head `8bc6960d05e5521ff6ae44ad0ee49e7c07ef80ff`. Do not create another rerun until those runs are inspected.

Current promotion acceptance rule:

- build/browser smoke must pass;
- exact deployed CF-061 suite must pass 3/3 against visible v2.15.72;
- no unexpected backend/server errors;
- only then mark v2.15.72 currentness proof CLOSED.

Known technical debt: `src/mature-main.jsx` still contains bootstrap `UI_VERSION='2.15.71'`; `src/release-currentness-entry.js` is the deployed visible-currentness reconciler and overrides the rendered version. This duplication must be normalised later in a bounded refactor; do not hide or silently ignore it.

## Next recovery gates after v2.15.72 currentness proof

Proceed feature-by-feature rather than running the old oversized integration matrix immediately:

1. H5/H6 manual PIM candidate + publication controls recovery/targeted gate.
2. Scholarship controls/runtime recovery gate.
3. Layer 4 mass operations/scope-rule regression gate.
4. Provider/Course logo surfaces regression gate.
5. Jobs/operational workspace recovery gate where still unproven.
6. Mobile/responsive nominated regression after targeted desktop gates are clean.
7. One nominated broader M2.4.5 acceptance only after targeted/bounded gates are green.

Do not infer acceptance merely because a feature exists in source or because a later version number is visible.

## M2.4.5 programme boundaries to preserve

- M2.4.4 remains CLOSED / PASS / FROZEN.
- M2.4.5 remains ACTIVE / PRE-PRODUCTION HARDENING until its remaining gates close.
- M2.5 remains PAUSED AT P0; do not create Production resources from this continuation.
- Production remains a separate trust boundary.
- Layer 1 identity/authority cannot be redefined by Layer 2/3/4 fixes.
- QILT/PRISMS/ranking observations retain their governed source grain.
- Search/Publication/Website/Zoho are derived consumers and require their own admission controls.
- Evidence, role/rank/RLS/private Storage and secret boundaries are never bypassed for troubleshooting convenience.

## New-chat pickup text

Use this at the start of the continuation if needed:

> Continue CourseFinder M2.4.5 from repository/runtime truth. Read `PROJECT_INSTRUCTIONS.md`, `docs/README.md`, `docs/01-governance/coursefinder-pim-operating-principles-v1.0.md`, `docs/01-governance/coursefinder-troubleshooting-bugfix-recovery-protocol-v1.0.md`, Milestone 2 Standing Instructions/addenda, Change Control register/owning records, and the active M2.4.5 RUNSHEET/CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT. First inspect build/deployed UAT for Pilot head `8bc6960d05e5521ff6ae44ad0ee49e7c07ef80ff`. Do not rely on chat memory, do not weaken governed semantics to make tests pass, use targeted → bounded → nominated acceptance, and keep release/version history synchronized only after functional gates pass.

## Before ending the next chat

- update owning Change Controls;
- update M2.4.5 RUNSHEET/CURRENT-STATE/FOLLOW-UPS/WORK-ITEM-LEDGER/NEXT-CHAT;
- record exact commits, runtime/migration evidence and failed/PASS UAT run IDs;
- keep release/version record synchronized where browser-visible behaviour changes;
- record rollback/reversion path;
- return concise Achieved / Failed or Blocked / Next / recommended continuation chat.
