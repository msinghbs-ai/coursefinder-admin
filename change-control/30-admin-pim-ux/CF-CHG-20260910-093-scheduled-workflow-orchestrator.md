# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE — EXACT-HEAD RECOVERY CLEAN / CODEX + CONSEQUENT ACCEPTANCE PENDING  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-13 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Active Pilot PR:** #72 (`m245/cf093-async-discovery-20260912`)  
**Candidate head:** `af5f97981cbb44ef157876552500c1404d15c9fd`  
**Visible accepted release:** v2.15.78

## Objective

Complete the bounded Scheduled Tasks run-on-demand contract for large AU Course Facts scopes without weakening Layer 1 authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model/revalidation governance, Layer 4 human resolution, Search/Publication separation or rank/ACL boundaries.

## Current decision

PR #72 remains OPEN / DRAFT and governance-blocked. Two exact-head P1 defects raised after the prior candidate have been corrected forward-only: discovery continuation no longer consumes unresolved `failed`/nonterminal `candidate` outcomes, and the Fresh Reconstruction gate now replays the final immutable CF-093 migrations against the verified accepted-main dependency contracts. Exact-head CI/reconstruction/Cloudflare currentness is green at `af5f9798...`; a fresh Codex review and consequential UQ/RMIT acceptance remain required. Layer 3, merge and release remain paused until deterministic corrective acceptance closes.

## Current exact-head evidence

- Candidate head `af5f97981cbb44ef157876552500c1404d15c9fd`.
- CF-093 Targeted Recovery `34741811302`: **PASS**.
- CF-093 Fresh Reconstruction `34741811307`: **PASS** — ordered CF-093 migration replay now includes `20260913015530`, `20260913020222`, and `20260913020646` against verified accepted-main fixture contracts.
- Pilot Frontend Build `34741811348`: **PASS**.
- Cloudflare preview: **PASS/deployed at `af5f9798`**.
- Fresh exact-head Codex review requested in PR comment `5651547613`; result pending at this reconciliation point.
- PR remains draft/unmerged; accepted main and visible release are unchanged.

## Corrective recovery classification

The latest recovery cycle had two distinct causes:

1. **Runtime worker continuation defect:** `layer2-scope-discover-scheduled` previously used all attempted results as consumed continuation items. A transient `failed` result or nonterminal `candidate` could therefore be removed from the continuation set before a governed selected/terminal outcome existed. The repository worker now consumes only `exact_match`, `likely_match`, `ambiguous`, `identity_mismatch`, or `current_page_not_found`; unresolved `failed`/`candidate` items remain in bounded continuation/recovery.
2. **Fresh-reconstruction harness drift:** after the final immutable migrations were added to the replay, the hand-built accepted-main fixture was missing contracts already present on accepted main. The fixture was reconciled, not the migrations: six-column `public.layer2_scope_courses`, Layer 2 acquisition provider/provider-route contracts, `public.layer2_provider_runtime_config(uuid)`, and accepted v1/v2 scheduler Run Now signatures required by the final ACL reconciliation. No provider/route/runtime rows were manufactured.

Applied migration identities remain immutable. No applied migration was rewritten, deleted, renamed or retimestamped.

## Forward runtime hardening retained

Applied/checked-in hardening through the current runtime migration lineage includes `20260912232827_cf_093_preview_provenance_terminal_dedupe_hardening` and the subsequent immutable CF-093 optimisation/ACL migrations through `20260913020646_cf_093_scheduler_run_bridge_acl_reconcile`.

The currently deployed worker before this repository continuation correction remains:

- `layer2-scope-discover-scheduled-v1.3.10`;
- Edge version 29;
- existing custom nonce/auth boundary (`verify_jwt=false`) retained.

Repository exact head contains the bounded continuation correction. Deployment/currentness must be performed only after exact-head review remains clean; the custom nonce/auth boundary must not be changed.

## Authority boundaries retained

- Layer 1 identity/source authority unchanged.
- Layer 2 deterministic Evidence truth preserved and fail-closed.
- Exact Preview token/fingerprint/binding provenance remains required for governed async continuation and handoff.
- `layer3_required` is an L2 disposition only; generic scheduler Layer 3 remains prohibited.
- Layer 4 human resolution remains separate.
- Search/Publication remains separately governed.
- No URL/profile/route/zero-result marker/identity/Evidence or migration-history row may be manufactured for acceptance.
- Direct ad-hoc mutation of Supabase migration history remains prohibited.

## Historical large-university evidence

Retain for evidence only:

- UQ batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`.
- RMIT batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required`.

Previous hardened snapshots remain forensic only. No corrective UQ/RMIT acceptance run has been dispatched during this recovery cycle. New counts must come from new authenticated Previews after exact-head currentness closes.

## Exact next gates

1. Obtain a clean Codex review of exact head `af5f9798...`.
2. Deploy the exact-head worker continuation correction to Pilot, preserving the existing custom nonce/auth boundary, and verify deployed source/currentness.
3. Dispatch the maintained `CF-093 UQ Corrective Acceptance` workflow on the current branch/head, or use the equivalent normal authenticated Admin/PIM scheduler path; direct database execution is not an acceptable substitute.
4. Reconcile only newly selected/changed deterministic UQ Layer 2 work and prove exact-token/fingerprint/dedupe/cancel behaviour plus zero generic Layer 3/Layer 4 auto-approval/Search/Publication side effects.
5. Run bounded RMIT corrective acceptance only after UQ is clean.
6. Recalculate Layer 3 eligibility only after deterministic Layer 2 acceptance closes.
7. Merge/release remains prohibited until every runtime, UAT, security/authority and governance gate is clean; after merge verify main CI, Cloudflare/deployed currentness and deployed UAT before closure.

## Next AU qualification wave

Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW remains deferred until CF-093 closes. Cohort membership is not authority to manufacture configuration.