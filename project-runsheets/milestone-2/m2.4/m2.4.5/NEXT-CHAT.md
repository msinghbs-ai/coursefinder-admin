# M2.4.5 NEXT CHAT

## Accepted active baseline — 11 September 2026

- Accepted Pilot `main`: **`cfc4702ba57a58ea31936dcabbd96fdd765194e2`**.
- Visible PIM Admin release: **v2.15.78**.
- CF-092 remains **CLOSED / PASS**.
- **CF-CHG-20260910-093 is CLOSED / PASS at the accepted AU Course Facts target-builder boundary.**
- Functional target-builder PR #69 merged as `85bc068d379ed3fc9231d167cf524e56419e80f9`.
- v2.15.78 release-currentness PR #70 merged as `cfc4702ba57a58ea31936dcabbd96fdd765194e2`.
- Post-merge Release History Contract `34579029903` — **PASS**.
- Post-merge Pilot Frontend Build `34579029934` — **PASS**.
- Post-merge CourseFinder Deployed UAT `34579029850` — **PASS**.
- Production remains unchanged; no Production Supabase project exists; M2.5 remains paused at P0 unless the current router says otherwise.

## Accepted CF-CHG-20260910-093 boundary

Scheduled Tasks now has the accepted Phase A operator controls plus the bounded Phase B target-builder slice.

Phase A includes business-readable labels, server-side search, durable creator/owner attribution, personal column preferences, bounded schedule edit, bounded Layer 1–2 Run on demand and Jobs/Evidence follow-through.

Phase B accepts only:

- AU Course Facts Layer 2;
- server-authorised Country / State-Territory / University-Provider targets;
- Acquisition + deterministic Layer 2 only;
- mandatory server preview before consequential dispatch;
- valid current profile version, deterministic Layer 2 execution policy and <=1,000 courses per scoped profile;
- dispatch-time live-scope revalidation, cross-operator exact-scope dedupe/reuse and atomic empty-start rejection;
- underlying Layer 2 Jobs/Evidence as authoritative processing truth.

Applied Pilot runtime lineage is immutable through:

- `20260911021144 cf_093_scheduler_workflow_builder_slice`
- `20260911021847 cf_093_scheduler_workflow_bridge_acl_fix`
- `20260911022312 cf_093_scheduler_workflow_preview_token_idempotency`
- `20260911023721 cf_093_scheduler_workflow_codex_second_pass`
- `20260911025332 cf_093_scheduler_workflow_codex_third_pass`
- `20260911031554 cf_093_scheduler_workflow_codex_fourth_pass`
- `20260911052952 cf_093_scheduler_execution_policy_qualification`
- `20260911065626 cf_093_scheduler_policy_and_scope_limit_qualification`

## Final acceptance evidence

The final consequential acceptance used a policy-qualified AU Course Facts UQ scope, not the known-ineligible RMIT UP/Nova candidates. Preview covered **382 courses**. One governed dispatch was accepted; a same-token retry and a second fresh-preview dispatch reused the original recent dispatch rather than creating duplicate paid acquisition. The underlying Layer 2 batch progressed and produced governed Evidence. No generic Layer 3 interpretation, Layer 4 resolution, Search admission or Publication side effect was observed from the builder run.

RMIT UP and Nova remain valid negative examples: missing deterministic Layer 2 execution policy must fail closed before acquisition rather than having policy manufactured for UAT.

## UAT recovery reconciliation

The first post-functional-merge deployed UAT failure was traced to stale test currentness: CF-097 still asserted historical `v2.15.74`, and its retry also observed a transient dashboard 500. The v2.15.78 release follow-up changed only the stale release-currentness assertion to derive the expected value from the maintained currentness source. Server-error detection and authority/security rules were not relaxed. Post-merge deployed UAT `34579029850` passed.

## Still not authorised

- generic automatic L2 -> L3 -> L4 orchestration;
- generic Layer 3 Evidence reprocess;
- arbitrary Layer 1 target construction;
- NZ Layer 2 Course enrichment;
- recurring country/state target construction;
- recurring university target construction without a separately accepted enforceable contract;
- implicit Search or Publication actions.

## Exact next gate

1. Merge the reconciled Admin governance PR #34 only after its fresh exact-head Codex review is clean and all review findings are resolved.
2. After merge, verify `docs/README.md` routing, Change Control register and M2.4.5 RUNSHEET/CURRENT-STATE/FOLLOW-UPS remain consistent with Pilot main `cfc4702...` / v2.15.78.
3. Do not reopen CF-CHG-20260910-093 to add broader generic orchestration. Any additional dataset/layer/recurring-scope capability requires a new governed change or explicit reopening with executable server contracts.
4. Continue M2.4.5 from the exact next open gate shown by the current router; keep M2.5 paused unless governance explicitly advances it.

## Pickup text

> Continue CourseFinder from repository/runtime truth. Accepted Pilot main is `cfc4702ba57a58ea31936dcabbd96fdd765194e2`, visible v2.15.78. CF-CHG-20260910-093 is CLOSED/PASS at the bounded AU Course Facts Scheduled Tasks target-builder boundary. Post-merge Release History `34579029903`, Frontend Build `34579029934` and Deployed UAT `34579029850` all PASS. Preserve mandatory Preview before consequential dispatch, execution-policy/profile/scope qualification, exact-scope dedupe and Layer 2 Jobs/Evidence truth. Generic L3/L4 orchestration, Evidence reprocess, unsupported recurring scope construction and implicit Search/Publication remain unavailable. Reconcile Admin PR #34, router and continuity before selecting the next open M2.4.5 gate.
