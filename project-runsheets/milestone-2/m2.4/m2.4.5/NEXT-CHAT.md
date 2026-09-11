# M2.4.5 NEXT CHAT

## Active baseline — 12 September 2026

- Current Pilot `main`: **`63c7107cfce2d8f607fc378af4881d0ba28ca879`**.
- Visible PIM Admin release remains **v2.15.78**; no browser UI source changed in the corrective reconciliation merge.
- Functional target-builder PR #69 merged as `85bc068d379ed3fc9231d167cf524e56419e80f9`; release-currentness PR #70 merged as `cfc4702ba57a58ea31936dcabbd96fdd765194e2`.
- Corrective PR #71 exact clean head `00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575` merged to Pilot `main` as `63c7107c...` solely to reconcile repository source with already-applied Pilot runtime migrations and maintained UAT contracts.
- Post-merge Pilot Frontend Build **`34655200676` — PASS**.
- Post-merge CourseFinder Deployed UAT **`34655200754` — PASS**; targeted desktop governed validation passed and the mobile gate was intentionally skipped by targeted-tier routing.
- Cloudflare Workers build **`50ce255a-8c17-4319-a649-ef2113178254` — PASS**, Worker version **`529075ea-affa-4a5e-951a-15e53689c8e2`**.
- Pre-merge exact-head Codex review was clean in PR #71 comment `5634309865`.
- **CF-CHG-20260910-093 remains REOPENED.** Source/runtime reconciliation is PASS; consequential acceptance remains blocked.
- Production is unchanged; M2.5 remains paused at P0.

## Preserved authority boundary

- AU Course Facts Layer 2 only.
- Server-authorised Country / State-Territory / University-Provider scopes only.
- Acquisition + deterministic Layer 2 only.
- Mandatory actor-bound server Preview before consequential dispatch.
- Authenticated rank-4 execution only; private helpers remain protected.
- Valid profile version, deterministic execution policy, bounded scope, worker-compatible route/credential/budget/cost and URL allowlist checks.
- Exact Preview fingerprint and dispatch revalidation before/after start.
- Layer 1 authority unchanged.
- Layer 3 remains Evidence/profile/model/revalidation governed.
- Layer 4 remains audited human/exception resolution.
- Search and Publication remain separately governed downstream actions.

Generic async discovery-backed Scheduled Tasks remain fail-closed until a separately accepted Preview-bound async worker/continuation contract exists. Generic L3/L4 orchestration, Evidence reprocess, NZ Layer 2 Course enrichment, recurring country/state construction, unsupported recurring university construction and implicit Search/Publication remain disabled.

## Immutable Pilot runtime/source lineage

Latest corrective identities remain:

- `20260911085724 cf_093_scheduler_postmerge_codex_finalizer`
- `20260911095142 cf_093_scheduler_exact_scope_codex_finalizer`
- `20260911095420 cf_093_scheduler_runtime_route_credential_finalizer`
- `20260911103931 cf_093_scheduler_runtime_semantics_finalizer`
- `20260911105517 cf_093_scheduler_browser_bridge_and_scope_binding_finalizer`
- `20260911111431 cf_093_scheduler_query_binding_and_ipv4_finalizer`
- `20260911114056 cf_093_scheduler_discovery_failclosed_and_runtime_parser_finalizer`
- `20260911120131 cf_093_scheduler_operator_reason_and_route_chain_finalizer`

Pilot `main` now carries the exact source for these already-applied runtime migrations. Never rewrite or retimestamp them.

## Current consequential-target truth

- RMIT University: **500 total / 261 queueable / 239 discovery**; governed execution policy exists, but generic async discovery is fail-closed.
- University of Queensland: **382 / 156 / 226**; governed execution policy exists, but generic async discovery is fail-closed.
- Nova Higher Education: **1 queueable / 0 discovery**, execution-policy gap 1; qualification-only profile.
- Stamford International College: **1 queueable / 0 discovery**, execution-policy gap 1; qualification-only profile.
- Every inspected AU State/Territory scope remains discovery-backed and contains execution-policy gaps.

Do not manufacture an execution policy, source profile, route or runtime configuration merely to force consequential acceptance.

## Exact next gate

1. Finalise Admin PR #34 governance to record Pilot merge `63c7107c...`, Frontend Build `34655200676`, Deployed UAT `34655200754`, Cloudflare build `50ce255a-8c17-4319-a649-ef2113178254`, and v2.15.78 unchanged.
2. Request a fresh exact-head Codex review on the final Admin PR #34 head because the governance branch changed after the prior clean review.
3. Merge Admin PR #34 only when exact-head Codex and current Admin CI/Cloudflare checks are clean. That merge is governance reconciliation only; it must keep CF-CHG-20260910-093 REOPENED.
4. Keep consequential acceptance blocked until a legitimate operational lifecycle produces a policy-qualified fully queueable deterministic Layer 2 target; then run Preview → dispatch → duplicate/retry → Jobs/Evidence/no-unintended-side-effect acceptance.
5. Once CF-CHG-20260910-093 is genuinely CLOSED/PASS, resume the **QS-focused** M2.4.5 continuation. H12 ARWU/Diversity immediate-next pointers remain superseded/parked.

## Pickup text

> Continue CF-CHG-20260910-093 from repository/runtime truth. Pilot main is `63c7107cfce2d8f607fc378af4881d0ba28ca879`, visible v2.15.78. Corrective PR #71 source/runtime reconciliation is PASS: Frontend Build `34655200676`, Deployed UAT `34655200754`, Cloudflare build `50ce255a-8c17-4319-a649-ef2113178254`, Worker version `529075ea-affa-4a5e-951a-15e53689c8e2`. Runtime/source lineage is aligned through immutable `20260911120131`. CF-CHG-20260910-093 remains REOPENED solely because no legitimate policy-qualified fully queueable deterministic Layer 2 target currently exists for consequential Preview→dispatch→Jobs/Evidence acceptance. RMIT/UQ are discovery-backed; Nova/Stamford are qualification-only and lack execution policies. Do not fabricate configuration. Finalise Admin PR #34, request exact-head Codex review, merge governance only if clean, and preserve the blocker/authority boundaries.
