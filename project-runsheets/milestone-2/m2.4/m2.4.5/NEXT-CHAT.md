# M2.4.5 NEXT CHAT

## Accepted active baseline — 11 September 2026

- Accepted Pilot `main`: **`643eef810ab10ab9679ab6687ee549b0664c5691`** after CF-093 functional PR #67 and v2.15.77 release-currentness PR #68.
- Visible Admin release: **v2.15.77**.
- CF-092 Scheduled Tasks configuration remains **CLOSED / PASS**. CF-093 Phase A — operator catalogue/search/attribution/existing-policy controls — is accepted; CF-093 Phase B target builder remains ACTIVE.
- PR #67 merge `912572203e4f53ac081617b0ea567c9298cab84d`; post-merge Release History `34550482710` PASS, Frontend Build `34550482729` PASS, Deployed UAT `34550482733` PASS.
- PR #68 merge `643eef810ab10ab9679ab6687ee549b0664c5691`; post-merge Release History `34553234972` PASS, Frontend Build `34553235073` PASS, Deployed UAT `34553235214` PASS.
- Deployed targeted desktop governed validation passed; mobile was intentionally skipped by validation-tier routing rather than failed.
- Pilot Security Advisor remains at the known **191 INFO / 0 WARN / 0 ERROR** baseline. RLS remediation remains a separate security task.
- Production remains unchanged and no Production Supabase project exists. M2.5 remains paused at P0.

## Active CF-093 target-builder work

Fresh Pilot branch: `m245/cf093-target-builder-20260911`  
Pilot PR: **#69 — CF-093: add governed Scheduled Tasks target-builder slice**  
Fresh Admin governance branch: `m245/cf093-target-builder-20260911`.

Pilot runtime has applied migration:

- **`20260911021144 cf_093_scheduler_workflow_builder_slice`**

The first executable builder slice is deliberately narrow:

- Dataset/workflow: AU Layer 2 Course Facts enrichment;
- server-authorised scopes: Country, State/Territory, University/Provider;
- required preview before consequential dispatch;
- executable processing mode: Acquisition + deterministic Layer 2 only;
- automatic generic L2 -> L3 -> L4 disabled;
- generic Evidence reprocessing disabled; use Layer 3 governed controls;
- country/state recurring schedule construction disabled;
- university recurring schedule creation also remains disabled until a verified one-profile resolver/constructor is accepted;
- Search/Publication remain separate downstream consequences.

The existing generic `refresh_policy_upsert_v2` must **not** be used as a universal target constructor: it proves a bounded identifier is supplied but does not prove worker qualification/scope enforcement. The builder must continue to fail closed for unsupported scopes.

## Current acceptance gate

Initial PR #69 head: `216c2854f2e9d53df723e5c038aa0a064999cfc4`.

- Runtime migration identity is represented in repository history.
- Security Advisor after the migration: 191 INFO / 0 WARN / 0 ERROR.
- Release History Contract `34553879983` — PASS.
- Pilot Frontend Build `34553880058` was in progress at the last continuity write.
- Codex exact-head review requested in PR #69 comment `5628435395`.

Immediate sequence:

1. Check exact PR #69 head, CI and Codex review.
2. Correct actionable findings only with smallest-safe forward changes; never retimestamp applied migration `20260911021144`.
3. Prove browser target selection + preview + unsupported-mode denial.
4. Prove negative unauthenticated/low-rank paths.
5. Run one nominated AU Layer 2 target through preview -> dispatch -> Job/Evidence follow-through, confirming no manufactured generic L3 or Publication work.
6. Only after functional acceptance, publish the next visible release and run release-currentness/deployed acceptance.
7. Reconcile Change Control, REGISTER, RUNSHEET, CURRENT-STATE, FOLLOW-UPS and NEXT-CHAT before closing the accepted slice.

## Roadmap / authority reminders

Generic dataset ETL/ARWU/Diversity remains parked unless separately re-authorised. Near-term ranking work remains QS-focused. CF-093 does not change this roadmap decision.

Layer 3 remains Evidence/profile/model/revalidation qualified. Layer 4 remains explicit human resolution. Scholarship Provider ownership cannot manufacture Course eligibility. Search/Publication cannot be implied by an ingestion action.

## Pickup text

> Continue CourseFinder M2.4.5 from repository/runtime truth. Accepted Pilot main is `643eef810ab10ab9679ab6687ee549b0664c5691`, visible Admin release v2.15.77. CF-093 Phase A is accepted; target-builder Phase B is active in Pilot PR #69. Pilot runtime migration `20260911021144 cf_093_scheduler_workflow_builder_slice` adds only AU Layer 2 Course Facts server-authorised Country/State/University preview and acquisition-only dispatch. Generic L3/L4 orchestration, Evidence reprocess and recurring scope construction remain disabled. Reconcile exact PR #69 CI/Codex/runtime before proceeding and do not expose a scope the worker cannot enforce.
