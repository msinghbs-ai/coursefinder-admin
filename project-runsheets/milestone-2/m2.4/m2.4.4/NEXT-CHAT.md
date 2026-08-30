# Next Chat — M2.4.4 Cross-layer Checkpoint

## Status

M2.4.4 is ACTIVE under `CF-CHG-20260830-048`.

Material implementation and targeted runtime reconciliation are complete. Bounded integration is the next gate.

## Accepted/reconciled state

- M2.4.3 accepted source: `96de9add3762a0594ebc371fba49d4d990ff4b45`.
- M2.4.4 initial corrective source: `29cffeb1ad3824f7569d4b597e0103e3c880bb8a`.
- L1 recovery deployed ledger version: `20260830021159`; repository mirror filename: `20260830021400...`; same accepted function body.
- L3 alert migration: `20260830071523_m2_4_4_layer3_operational_alerts`.
- L3 Admin-read bridge: `20260830072215_m2_4_4_layer3_alert_admin_read_bridge`.
- all seven active operational cron jobs latest-success.
- Security 135 INFO / 0 WARN / 0 ERROR.
- Performance 169 INFO / 0 WARN / 0 ERROR.
- current L3 alert-condition count: 0.
- no queued/running L1–L3 refresh duplication.
- A14 telemetry continuity reconciled; unavailable usage not invented.
- Guides: Operations Runbook v1.8; Data Operations Admin Guide v1.6; PIM Admin Guide v1.22.
- permanent M2.4.4 UAT added to targeted/integration/acceptance tiers.

## Follow-up disposition

M244-FU-001–005 COMPLETE.
M244-FU-006 remains OPEN / NON-BLOCKING UAT hygiene.
Apollo credential, A15 frozen baseline, RMIT 212 promotion block and NZ L2 defer remain unchanged.

## Exact next action

1. Reconcile latest Admin/Pilot heads.
2. If no parallel work superseded the lineage, nominate exactly one M2.4.4 bounded integration candidate using the latest Pilot head.
3. Record candidate SHA/run ID and both desktop/mobile outcomes here and in CURRENT-STATE.
4. If both PASS, nominate exactly one final M2.4.4 pre-blackout acceptance candidate.
5. If either fails, retain immutable evidence and correct only the exact defect/contract.
6. On final desktop+mobile PASS, close CF-CHG-20260830-048 and M2.4.4, reconcile REGISTER/Master Plan/Running Build and assess the next authorised milestone without starting it automatically.

## Boundaries

Production, broad Publication, Website/Zoho cutover, RMIT 212 promotion and deferred NZ L2 first-party enrichment remain outside this gate.


## Bounded integration candidate nominated — 30 August 2026

- candidate SHA: `55f867bc371fb961f38631129e746fad9d9ec00b`;
- implementation source before marker: `7ef74a0b787e50e46d4cf11300a0e27391f13e54`;
- stage: bounded integration desktop/mobile;
- decision rule: both commit-status contexts must be success before one final acceptance marker is created;
- duplicate candidate rule: do not create another integration marker while this candidate is active;
- workflow run ID: pending GitHub Actions publication at this checkpoint.


## Bounded integration failure evidence — run 33299250997

Candidate `55f867bc371fb961f38631129e746fad9d9ec00b` is terminal FAIL and remains immutable evidence.

Desktop:
- 44 passed;
- 2 failed after retry;
- M2.4.4 source-contract test failed because its checked-in assertion searched for unescaped `p_operation='layer3_ops_alerts'` while the migration correctly stores the PL/pgSQL replacement string using doubled SQL quotes;
- inherited performance test also exceeded the unchanged 3,000 ms Course-page interaction budget: 3,313 ms, then 3,962 ms on retry.

Mobile:
- skipped because desktop failed;
- published integration mobile context is failure/skipped, not an independently executed product failure.

Corrective source:
- `8494293f118bb9f8f3a5884ca4bde1a3331831f1`;
- correction changes only the M2.4.4 checked-in test assertion to verify the stable `layer3_ops_alerts` contract token;
- no runtime, authority, Security, Evidence, Course-path or 3,000 ms performance budget was weakened.

The inherited Course performance failure is preserved and must be re-tested under the unchanged budget before promotion.


## Replacement bounded integration candidate — 30 August 2026

- corrective source: `8494293f118bb9f8f3a5884ca4bde1a3331831f1`;
- targeted deployed UAT: `33300234103` PASS;
- replacement integration candidate: `a256283bb5751dda727d8a6e4ae057abbffdcbbf`;
- decision rule: desktop and mobile must both PASS under unchanged budgets;
- first candidate/run `55f867bc... / 33299250997` remains immutable FAIL evidence;
- do not create another integration candidate while `a256283b...` is active.


## Active long-running gate handoff

Replacement bounded integration `a256283bb5751dda727d8a6e4ae057abbffdcbbf` is the **only active candidate**.

At handoff:
- GitHub has not yet published terminal integration desktop/mobile commit-status contexts;
- workflow run ID is therefore not yet trustworthy/available through the connected status surface;
- do not create another integration candidate;
- first inspect this exact SHA;
- if desktop+mobile both PASS, record its run ID/results then nominate one final acceptance candidate;
- if either fails, retain the run as immutable evidence and correct only the exact defect/contract.


## Replacement bounded integration — PASS

Candidate `a256283bb5751dda727d8a6e4ae057abbffdcbbf` completed as PASS in deployed UAT run `33300281890`.

- desktop: PASS;
- mobile: PASS;
- corrective targeted run `33300234103`: PASS;
- first candidate `55f867bc371fb961f38631129e746fad9d9ec00b` / run `33299250997` remains immutable FAIL evidence;
- unchanged 3,000 ms Course interaction budget was retained.

Post-integration runtime reconciliation:
- all seven active operational cron jobs latest-success;
- Security Advisor: 135 INFO / 0 WARN / 0 ERROR;
- Performance Advisor: 169 INFO / 0 WARN / 0 ERROR;
- no active Layer 1–3 refresh requests; seven retained Layer 4 human-resolution requests remain queued;
- Layer 3 stale reserved/calling executions: 0.

Decision: bounded integration gate PASS. Exactly one final M2.4.4 acceptance candidate is authorised next under CF-CHG-20260830-048.


## Final acceptance candidate — nominated

- marker: `6c480ed3b248f3b118f21dea80bb4d742ab8c282`;
- source lineage: replacement integration `a256283bb5751dda727d8a6e4ae057abbffdcbbf`;
- integration run `33300281890`: desktop PASS / mobile PASS;
- decision rule: final acceptance requires desktop PASS + mobile PASS plus clean closing reconciliation;
- do not create another acceptance candidate while this marker is active.


## Final acceptance active run

- candidate `6c480ed3b248f3b118f21dea80bb4d742ab8c282`;
- GitHub Actions run `33303037986`;
- current stage at checkpoint: desktop acceptance in progress, mobile pending;
- no second acceptance candidate is permitted while this run is active.

## A16 continuation requirement

Before attempting M2.4.4 closure, read:
- `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A16-L3-CONTACT-COVERAGE-L4-GOVERNED-INTERVENTION.md`;
- `docs/coursefinder-layer4-governed-intervention-design-v0.1.md`.

Then continue:
1. inspect current A15/L2 Evidence and define the 60-Provider Layer 3 contact-disposition/extraction implementation;
2. inspect existing Layer 4 scalar-resolution structures before introducing any new persistence;
3. implement the smallest compatible override-ledger/effective-value architecture, preserving existing accepted Layer 4 behaviour;
4. classify fields as editable / elevated approval / immutable;
5. implement field-level L4 marker, audit drawer, reason/comment and revert/supersede behaviour;
6. keep publication decision separate and role-gated;
7. add targeted security/RBAC/audit/replay UAT;
8. run bounded integration then one final desktop/mobile acceptance.

The earlier final candidate `6c480ed3b248f3b118f21dea80bb4d742ab8c282` / run `33303037986` predates A16 and must not be treated as the M2.4.4 closing gate.


## A16 implementation + targeted validation PASS — 30 August 2026

A16 implementation is complete at Pilot source `44960cc8a61c4ee743840bd5aca3cf25f7c10094`.

Runtime/state proof:
- explicit AU/NZ contact disposition: 60/60 Providers = 11 `published_contact_found` + 49 `not_found_in_qualified_evidence`; no synthetic contact values;
- dedicated Layer 3 international-contact profile enabled/unpaused after benchmark run `b16d1801-977e-4aaf-84da-e3b2726ac7ba` PASS (3/3 retained first-party Evidence cases + 3/3 controls; exact model; 8 calls; 16,702 input / 3,761 output tokens; recorded USD 0);
- Layer 4 append-only effective-value override ledger covers Provider, Course, Campus, Scholarship and Provider-contact fields;
- field registry: 50 governed fields / 21 immutable;
- publication override remains a separate rank-5+ audited decision;
- browser-facing A16 RPCs are SECURITY INVOKER through non-exposed `l4_api`; anon execute denied;
- Security Advisor: 139 INFO / 0 WARN / 0 ERROR;
- Performance Advisor: 175 INFO / 0 WARN / 0 ERROR;
- all seven active operational cron jobs latest-success;
- no active L1-L3 refresh work; seven intentional queued L4 human-resolution requests retained.

Validation evidence:
- contact benchmark failed runs remain immutable evidence before corrective qualification;
- frontend import failure run `33308697271` retained; corrected frontend build `33308932790` PASS;
- targeted selector-only failure run `33308781849` retained; corrected targeted A16 deployed UAT run `33308932765` PASS.

Decision: M244-FU-011 through M244-FU-015 are complete. Exactly one new A16-aware bounded integration candidate is authorised next. The pre-A16 final acceptance candidate/run remains evidence only and cannot close M2.4.4.
