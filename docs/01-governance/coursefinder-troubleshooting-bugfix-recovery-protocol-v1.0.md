# CourseFinder Troubleshooting, Bug-Fix & Recovery Protocol v1.0

**Status:** AUTHORITATIVE CROSS-CHAT TROUBLESHOOTING / RECOVERY PROTOCOL  
**Effective:** 7 September 2026  
**Applies to:** Every CourseFinder bug, regression, failed UAT, runtime incident, large corrective change, recovery effort and cross-chat troubleshooting continuation.

## Purpose

This protocol prevents implementation drift when a defect, failed UAT or large recovery spans multiple chats. Conversation history is never the sole source of project truth. Repository governance, current implementation state, deployed runtime state and retained UAT evidence must be reconciled before corrective work continues.

## Mandatory start for any bug / troubleshooting chat

Before changing code, schema, runtime configuration or UAT contracts:

1. Read `PROJECT_INSTRUCTIONS.md`.
2. Read `docs/README.md` and the current PIM operating principles.
3. For Milestone 2, read `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md` and applicable addenda.
4. Read this protocol.
5. Read `change-control/README.md`, `change-control/REGISTER.md` and the owning/relevant Change Control.
6. Read the active milestone `RUNSHEET.md`, `CURRENT-STATE.md`, `FOLLOW-UPS.md`, `WORK-ITEM-LEDGER.md` and `NEXT-CHAT.md` where present.
7. Reconcile current implementation repository head(s), current deployed Supabase/runtime state and the exact failing/passing CI/UAT runs.
8. Reconcile current visible release/version authority and release-history record before any browser-visible fix.
9. Do not assume a prior chat summary, old screenshot, old test expectation, earlier commit or highest-numbered file is current truth.

## Evidence-first defect classification

Every defect must be classified before the fix is accepted:

- **Implementation defect** — runtime/code/schema does not meet the governed contract.
- **Data defect** — governed source/identity/mapping/grain/completeness is wrong or incomplete.
- **Contract/UAT defect** — test expectation is stale, over-broad, under-specified or inconsistent with governed semantics.
- **Deployment/currentness defect** — correct source exists but deployed runtime/version does not match it.
- **Environment/config defect** — credential, secret, routing, quota, DNS, external provider or environment state is responsible.
- **Governance/documentation drift** — repository records no longer describe actual accepted behaviour.
- **Mixed defect** — more than one of the above; each cause must be separately recorded and closed.

Do not weaken a correct data/security/authority rule merely to obtain a PASS. Do not rewrite a test merely because it failed. A test may be corrected only when repository/runtime evidence proves the expectation is stale or semantically invalid.

## Troubleshooting sequence

Use this order unless safety requires an earlier stop:

1. **Reproduce / identify exact failure** — run or inspect the smallest reliable failing path.
2. **Collect evidence** — exact run/job/test, request/response, server/client errors, affected entity IDs, source/Evidence IDs, version and commit.
3. **Determine ownership** — frontend, RPC/API, schema, ingestion adapter, data mapping, deployment, configuration or test contract.
4. **Check accepted semantics** — source grain, authority, role boundary, canonical identity, null/zero/suppressed meaning and consumer boundary.
5. **Apply the smallest safe corrective change** — avoid opportunistic refactors while the gate is red.
6. **Run targeted validation** — static/build/schema/API/security/browser as applicable.
7. **Run bounded integration only when the change crosses surfaces.**
8. **Run one nominated broader acceptance only after targeted/bounded gates are clean.**
9. **Record PASS/FAIL/CANCELLED truth** — never infer acceptance from a version bump or generic green workflow.
10. **Close or hand off** — update Change Control, release history, continuity docs, rollback and exact next action.

## Failed UAT guardrails

When UAT fails:

- inspect the exact failed test and retained evidence before changing implementation;
- distinguish implementation failure from stale/incorrect UAT expectation;
- inspect server errors independently from the primary UI assertion;
- do not rerun repeatedly without a material corrective change or a justified transient-failure reason;
- do not substitute a generic suite for the intended feature suite;
- confirm workflow resolver/route actually selected the intended tests;
- record the failed run ID and root cause in the owning recovery/change record;
- keep the feature gate OPEN until the exact intended targeted acceptance passes;
- if a retry passes only after a test change, document why the old expectation was invalid and preserve the semantic evidence.

## Version and release discipline for fixes

A browser-visible change that warrants a visible version must follow this sequence:

1. create/update the owning Change Control or corrective batch;
2. document requested change / defect and semantic before/after;
3. implement the correction;
4. run targeted/bounded UAT against the pre-promotion version where practical;
5. only after the functional gate passes, promote the candidate release version;
6. synchronise all authoritative visible-version surfaces in the same promotion batch;
7. update the release-history/release-note record with implementation commits and exact PASS run IDs;
8. run a currentness/build smoke after promotion;
9. do not label a candidate as RELEASED/ACCEPTED while the required gate is red, cancelled or unrun.

Skipped version numbers or missing historic release evidence must be stated explicitly; never reconstruct invented accepted releases.

## Database and data-model troubleshooting guardrails

Before adding a column/table or altering canonical semantics because imported data appears not to fit:

- inspect the current canonical schema and staging/source-payload model first;
- preserve original source rows/Evidence and source-native vocabulary;
- promote only stable reusable concepts into canonical columns/tables;
- keep publisher/vendor/year-specific fields in governed source payload/indicator/attribute structures when appropriate;
- do not force provider/course canonical tables to mirror an Excel/CSV/API shape;
- do not manufacture mappings for ambiguous identities;
- migrations require repository record, deployed-state verification and rollback/reversion path.

## Large fix / recovery guardrails

For recoveries spanning multiple modules or many historical commits:

- first build a recovery inventory: accepted baseline, changed modules, known failures, unproven modules and required gates;
- recover feature-by-feature with targeted gates rather than immediately running the full matrix;
- distinguish "present in source" from "deployed", and "deployed" from "accepted";
- do not rebuild functionality already present until regression evidence proves it is broken;
- retain prior accepted gates unless a new change can reasonably regress them;
- if a broad integration suite contains stale tests and genuine failures, split them and return to targeted recovery;
- maintain an explicit OPEN/CLOSED recovery-gate list.

## Security and authority invariants during fixes

Troubleshooting never authorises bypassing:

- Layer 1 authority/identity;
- Layer 2 deterministic Evidence acquisition;
- Layer 3 Evidence-bound AI interpretation;
- Layer 4 governed human resolution;
- Publication/Search/Website/Zoho admission controls;
- role/rank/RLS/ACL boundaries;
- private Storage/Evidence controls;
- server/Edge secret boundaries.

A temporary diagnostic must not become a permanent browser-accessible bypass. Debug output must not leak secrets, credentials or private Evidence.

## Cross-chat continuity requirements

Before ending a substantial troubleshooting chat, repository truth must be sufficient for another chat to continue without relying on the previous conversation. Record:

- exact current repository head(s);
- current deployed/runtime version/state;
- defect classification and root cause(s);
- fixes already applied with commit/migration/function refs;
- exact failed and passing UAT run IDs;
- gates CLOSED and gates still OPEN;
- blockers/risks/known unrelated failures;
- rollback/reversion path;
- exact next action and intended targeted suite;
- recommended next-chat heading.

Update the active `NEXT-CHAT.md` with an "Immediate recovery pickup" section when the work remains open.

## Required new-chat prompt pattern

A new troubleshooting/recovery chat should start with:

> Continue CourseFinder from repository/runtime truth. Read `PROJECT_INSTRUCTIONS.md`, `docs/README.md`, the current PIM operating principles, `docs/01-governance/coursefinder-troubleshooting-bugfix-recovery-protocol-v1.0.md`, Milestone 2 Standing Instructions/addenda where applicable, Change Control register/owning record, and the active milestone RUNSHEET/CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT. Reconcile current implementation head, deployed Supabase/runtime state and exact CI/UAT evidence before changing anything. Do not rely on chat memory, do not weaken governed semantics to make tests pass, use targeted → bounded → nominated acceptance, and keep version/release history synchronized only after functional gates pass.

## Closure standard

A bug/recovery item is CLOSED only when the repository records:

- root cause;
- semantic before/after;
- implementation refs;
- deployed/runtime verification where applicable;
- exact targeted PASS evidence;
- security/authority checks where applicable;
- release/version state if browser-visible;
- rollback/reversion path;
- continuity/follow-up state.
