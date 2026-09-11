# M2.4.5 NEXT CHAT

## Active baseline — 11 September 2026

- Accepted deployed Pilot `main`: **`cfc4702ba57a58ea31936dcabbd96fdd765194e2`**, visible **v2.15.78**.
- Functional target-builder PR #69 merged as **`85bc068d379ed3fc9231d167cf524e56419e80f9`**; release-currentness PR #70 merged as `cfc4702...`.
- **CF-CHG-20260910-093 is REOPENED.** Do not describe it as CLOSED/PASS while the post-merge corrective gate is active.
- Corrective Pilot PR #71 (`m245/cf093-postmerge-codex-20260911`) remains **draft/open and unmerged**.
- Current exact corrective head: **`00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575`**.
- Exact-head Pilot Frontend Build **`34597632959` — PASS**.
- Production is unchanged; M2.5 remains paused at P0.

## Preserved CF-093 authority boundary

The Scheduled Tasks builder remains deliberately narrow:

- AU Course Facts Layer 2 only;
- server-authorised Country / State-Territory / University-Provider scopes;
- Acquisition + deterministic Layer 2 only;
- mandatory server Preview before consequential dispatch;
- authenticated rank-4 execution only;
- valid current profile version, deterministic execution policy, bounded profile size, worker-compatible route/credential/budget/cost and URL allowlist checks;
- exact Preview fingerprint/revalidation before and after start;
- Layer 1 authority unchanged;
- Layer 3 remains Evidence/profile/model/revalidation governed;
- Layer 4 remains human/exception resolution;
- Search and Publication remain separately governed downstream actions.

Generic asynchronous discovery-backed Scheduled Tasks are intentionally fail-closed until a separately accepted Preview-bound worker/continuation contract exists. Generic L3/L4 orchestration, Evidence reprocess, NZ Layer 2 Course enrichment, recurring country/state construction, unsupported recurring university construction and implicit Search/Publication remain disabled.

## Immutable Pilot runtime lineage

Applied identities must not be retimestamped or rewritten. Latest CF-093 corrective migrations are:

- `20260911085724 cf_093_scheduler_postmerge_codex_finalizer`
- `20260911095142 cf_093_scheduler_exact_scope_codex_finalizer`
- `20260911095420 cf_093_scheduler_runtime_route_credential_finalizer`
- `20260911103931 cf_093_scheduler_runtime_semantics_finalizer`
- `20260911105517 cf_093_scheduler_browser_bridge_and_scope_binding_finalizer`
- `20260911111431 cf_093_scheduler_query_binding_and_ipv4_finalizer`
- `20260911114056 cf_093_scheduler_discovery_failclosed_and_runtime_parser_finalizer`
- **`20260911120131 cf_093_scheduler_operator_reason_and_route_chain_finalizer`**

Repository source is reconciled to the actual applied `20260911120131` identity. The pre-apply source alias `20260911115830` was removed without changing migration semantics, and the maintained CF-093 UAT contract references the immutable runtime identity.

## Latest correction and evidence

Codex review of `f3622ff516...` returned three P2 findings. They are corrected forward-only in runtime/source migration `20260911120131`:

1. discovery-backed scopes expose a distinct truthful `unsupported_discovery_count` and operator block reason rather than a false configuration diagnosis;
2. deterministic provider-route qualification respects worker route order and blocking/fallback semantics;
3. queueable URL allowlist references are parsed literally, matching `layer2-acquire-v2`, without scheduler-only `{query}` substitution.

All three review threads were answered and resolved. Exact-head build `34597632959` passed after source/runtime migration-name reconciliation. Security Advisor at 2026-09-11 12:12 UTC remains the known **191 INFO / 0 WARN / 0 ERROR** RLS-no-policy inventory; no new CF-093 warning/error was introduced.

Runtime target inventory is intentionally not manipulated for acceptance:

- University of Queensland: **382 courses / 156 queueable / 226 discovery** — discovery-backed and therefore intentionally non-executable in generic Scheduled Tasks.
- Nova Higher Education: **1 queueable / 0 discovery**, route gaps 0, URL gaps 0, but **execution-policy gap 1**.
- Stamford International College: **1 queueable / 0 discovery**, route gaps 0, URL gaps 0, but **execution-policy gap 1**.
- No currently identified AU State scope is fully queueable; state scopes remain discovery-backed and contain policy gaps.

Do **not** manufacture an execution policy, source profile, route or runtime configuration merely to force a consequential acceptance pass.

## Exact next gate

1. Inspect the exact-head Codex result requested in Pilot PR #71 comment **`5634267079`** for head `00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575`.
2. If actionable, correct only forward and repeat exact-head CI/review; never rewrite an applied migration.
3. If Codex is clean, reconcile the acceptance requirement against current runtime truth: there is presently no genuinely policy-qualified fully queueable University target. Do not weaken or fabricate authority to create one.
4. Merge PR #71 only if the governed acceptance requirement is satisfied or explicitly reconciled by governance as a fail-closed corrective acceptance. Otherwise retain the exact blocker.
5. After any merge, verify main CI, Cloudflare/deployed currentness and deployed UAT before returning CF-093 to CLOSED/PASS.
6. Reconcile CURRENT-STATE, RUNSHEET, FOLLOW-UPS and CF-093 Change Control so their older CLOSED/PASS text cannot override this reopened state; then obtain final Admin PR #34 Codex review and merge.
7. Once CF-093 is truly closed, resume the **QS-focused** M2.4.5 continuation; stale ARWU/Diversity immediate-next pointers remain superseded.

## Pickup text

> Continue CF-093 from repository/runtime truth. Deployed Pilot main remains `cfc4702ba57a58ea31936dcabbd96fdd765194e2` / v2.15.78. CF-CHG-20260910-093 is REOPENED and corrective Pilot PR #71 is draft/open at exact head `00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575`. Latest immutable Pilot migration is `20260911120131 cf_093_scheduler_operator_reason_and_route_chain_finalizer`; source and runtime identities are aligned. Pilot Frontend Build `34597632959` PASS; Security Advisor remains 191 INFO / 0 WARN / 0 ERROR. Exact-head Codex re-review request is comment `5634267079`. Generic async discovery remains fail-closed. Nova and Stamford are fully queueable but each lacks the governed execution policy; do not manufacture policy/config for UAT. Preserve Layer 1 authority, deterministic Layer 2 Evidence truth, Layer 3 profile/model governance, Layer 4 human resolution, Search/Publication separation and rank/ACL boundaries. Do not merge until Codex and the governed acceptance gate are clean or explicitly reconciled without weakening controls.
