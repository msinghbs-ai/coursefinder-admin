# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE — EXACT-HEAD TECHNICAL GATES CLEAN / CODEX ENVIRONMENT + CONSEQUENT ACCEPTANCE PENDING  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-13 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Active Pilot PR:** #72 (`m245/cf093-async-discovery-20260912`)  
**Candidate head:** `4e67e32289235a88297502e90c8181f25639f300`  
**Visible accepted release:** v2.15.78

## Objective

Complete the bounded Scheduled Tasks run-on-demand contract for large AU Course Facts scopes without weakening Layer 1 authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model/revalidation governance, Layer 4 human resolution, Search/Publication separation or rank/ACL boundaries.

## Current decision

PR #72 remains OPEN / DRAFT / UNMERGED. The current exact head is technically clean across Targeted Recovery, full Fresh Reconstruction, Frontend Build/local browser smoke and Cloudflare currentness. Pilot runtime/source migration identity is reconciled to immutable applied migrations `20260913063252` and `20260913063321`; all previously actionable inline review threads are resolved. Consequential acceptance remains blocked because the required fresh exact-head Codex verdict has not returned: the Codex connector reports that a repository environment must be created. Worker redeployment, UQ/RMIT acceptance, Layer 3, merge and release remain paused rather than bypassing that governance gate.

## Current exact-head evidence

- Candidate head `4e67e32289235a88297502e90c8181f25639f300`.
- CF-093 Targeted Recovery `34743276597`: **PASS**, including bound identity-freshness and handoff queueable-provenance regressions.
- CF-093 Fresh Reconstruction `34743276592`: **PASS**, replaying the complete CF-093 chain through authoritative applied runtime identities `20260913063252` and `20260913063321`.
- Pilot Frontend Build `34743276603`: **PASS**, including local browser smoke and evidence upload.
- Cloudflare preview: **PASS / deployed at `4e67e322`**.
- All previously actionable inline Codex P1/P2 threads are resolved against current source/runtime/CI evidence.
- Fresh exact-head Codex review requested in PR comment `5651716801`; **verdict unavailable because the Codex repo-environment prerequisite is not satisfied**.
- PR remains draft/unmerged; accepted main and visible release are unchanged.

## Reconciled forward hardening

Authoritative applied Pilot migrations:

- `20260913063252_cf_093_bound_resolution_identity_freshness_reconcile.sql` — exact Preview-token provenance for resolved candidates and Layer 1 identity-aware terminal freshness.
- `20260913063321_cf_093_bound_handoff_queueable_provenance_reconcile.sql` — exact-token provenance for discovery-subset outcomes while retaining pre-existing queueable URLs already protected by the binding queueable fingerprint.

Temporary source-only aliases `20260913062000...` and `20260913064500...` were removed after runtime reconciliation. No applied migration was rewritten, removed, renamed or retimestamped.

Repository worker hardening additionally retains unresolved `failed`/nonterminal `candidate` outcomes in bounded continuation and aborts exact-binding identity drift before candidate writes while preserving bounded recovery for genuine provider/network verification failure.

## Pilot worker currentness

Pilot still runs `layer2-scope-discover-scheduled-v1.3.10`, Edge v29, SHA `665c56ade30fa89b517255bb023c8ce1a15f88df3935845baeeba17cca21c051`, with `verify_jwt=false` and the existing custom one-time nonce boundary. Edge29 predates the latest repository worker fixes and is intentionally not redeployed until the required fresh exact-head Codex verdict is available.

## Authority boundaries retained

- Layer 1 identity/source authority unchanged.
- Layer 2 deterministic Evidence truth preserved and fail-closed.
- Exact Preview token/fingerprint/binding provenance remains required.
- `layer3_required` is an L2 disposition only; generic scheduler Layer 3 remains prohibited.
- Layer 4 human resolution remains separate.
- Search/Publication remains separately governed.
- Rank/ACL/private-helper/service-role boundaries remain unchanged.
- No URL/profile/route/zero-result marker/identity/Evidence or migration-history row may be manufactured for acceptance.
- Direct ad-hoc database execution is not an acceptable substitute for authenticated UQ acceptance.

## Exact remaining gates

1. Satisfy the Codex repository-environment prerequisite and obtain a clean exact-head review of `4e67e322...`.
2. Deploy the exact repository discovery worker to Pilot with `verify_jwt=false`; verify deployed source/SHA and custom nonce boundary.
3. Start a **new** `CF-093 UQ Corrective Acceptance` `workflow_dispatch` on that reviewed/deployed exact head. The currently connected GitHub toolset exposes workflow reads/reruns but no new workflow-dispatch operation, so this may require an authorised GitHub UI/API dispatch; do not substitute direct SQL/RPC execution.
4. Reconcile new deterministic UQ Layer 2 evidence and prove zero generic L3/L4/Search/Publication side effects.
5. Run bounded RMIT corrective acceptance only after UQ is clean.
6. Recalculate Layer 3 eligibility only after deterministic Layer 2 acceptance closes.
7. Merge/release only after every runtime, UAT, security/authority and governance gate is clean, then verify main CI/deployment/deployed UAT before closure.

Historical UQ/RMIT batches remain forensic evidence only. Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW remains deferred until CF-093 closes.