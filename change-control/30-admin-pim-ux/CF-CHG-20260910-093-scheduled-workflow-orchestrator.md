# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE — EXACT-HEAD REVIEW + DEPLOYED CURRENTNESS CLEAN / UQ ACCEPTANCE DISPATCH PENDING  
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

PR #72 remains OPEN / DRAFT / UNMERGED. Exact-head technical gates are clean and Codex submitted a current-head review against `4e67e322...` on 2026-09-13 with no new actionable findings. Pilot worker deployed-currentness is now clean: `layer2-scope-discover-scheduled-v1.3.10` is Edge v30, SHA `a1037f04b5ea2a0d5300a900148b725632123b57c349308e8437a7995951560e`, with `verify_jwt=false` and the existing custom one-time nonce boundary preserved.

Consequential acceptance is now blocked only by starting a **new** maintained `CF-093 UQ Corrective Acceptance` `workflow_dispatch`. The connected GitHub toolset exposes workflow reads/reruns but no new dispatch action; direct SQL/RPC is not an acceptable substitute.

## Current exact-head evidence

- Candidate head `4e67e32289235a88297502e90c8181f25639f300`.
- CF-093 Targeted Recovery `34743276597`: **PASS**.
- CF-093 Fresh Reconstruction `34743276592`: **PASS**, through authoritative applied migrations `20260913063252` and `20260913063321`.
- Pilot Frontend Build `34743276603`: **PASS**, including local browser smoke/evidence.
- Cloudflare preview: **PASS / deployed at `4e67e322`**.
- Codex review submission against reviewed commit `4e67e32289`: **CLEAN / no new findings**.
- All previous actionable inline P1/P2 threads: **RESOLVED**.
- Pilot discovery worker: **Edge v30 deployed-current**, SHA `a1037f04b5ea2a0d5300a900148b725632123b57c349308e8437a7995951560e`, `verify_jwt=false`.

## Reconciled forward hardening

Authoritative applied Pilot migrations:

- `20260913063252_cf_093_bound_resolution_identity_freshness_reconcile.sql` — exact Preview-token provenance for resolved candidates and Layer 1 identity-aware terminal freshness.
- `20260913063321_cf_093_bound_handoff_queueable_provenance_reconcile.sql` — exact-token provenance for discovery-subset outcomes while retaining pre-existing queueable URLs already protected by the binding queueable fingerprint.

Repository worker hardening retains unresolved `failed`/nonterminal `candidate` outcomes in bounded continuation and aborts exact-binding identity drift before candidate writes while preserving bounded recovery for genuine provider/network verification failure.

No applied migration was rewritten, removed, renamed or retimestamped. Temporary source-only aliases `20260913062000...` and `20260913064500...` remain removed.

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

1. Start a **new** `CF-093 UQ Corrective Acceptance` `workflow_dispatch` on reviewed/deployed head `4e67e322...` using the maintained GitHub workflow or equivalent normal authenticated Admin/PIM scheduler path. Do not rerun an older SHA and do not use direct SQL/RPC.
2. Reconcile new deterministic UQ Layer 2 evidence and prove exact-token/fingerprint/dedupe/cancel behaviour plus zero generic L3/L4/Search/Publication side effects.
3. Run bounded RMIT corrective acceptance only after UQ is clean.
4. Recalculate Layer 3 eligibility only after deterministic Layer 2 acceptance closes.
5. Merge/release only after every runtime, UAT, security/authority and governance gate is clean, then verify main CI/deployment/deployed UAT before closure.

Historical UQ/RMIT batches remain forensic evidence only. Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW remains deferred until CF-093 closes.