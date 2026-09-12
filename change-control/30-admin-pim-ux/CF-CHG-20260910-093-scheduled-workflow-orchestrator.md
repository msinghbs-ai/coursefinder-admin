# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE — LARGE-UNIVERSITY L2 ACCEPTANCE PASS / AUTHENTICATED L3 + CODEX GATES PENDING  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-12 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Active Pilot PR:** #72 (`m245/cf093-async-discovery-20260912`)  
**PR head:** `a7283139a9e6088933be68fa69f75d2e9eb71fbe`  
**Visible accepted release:** v2.15.78

## Objective

Complete the bounded Scheduled Tasks run-on-demand contract for large AU Course Facts scopes without weakening Layer 1 authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model/revalidation governance, Layer 4 human resolution, Search/Publication separation or rank/ACL boundaries.

## Preserved authority and security boundaries

- Browser scheduler reads/actions remain rank-gated governed RPCs.
- Layer 1 identity/source authority remains unchanged.
- Layer 2 discovery/acquisition is deterministic and Evidence-preserving.
- Terminal discovery negatives are accepted only as `current_page_not_found`, `ambiguous` or `identity_mismatch`; no URL is manufactured.
- `layer3_required` is an L2 terminal disposition only; generic scheduler Layer 3 remains prohibited.
- Layer 3 live interpretation remains JWT/user-identity protected through the accepted `layer3-interpret` Edge contract.
- Search/Publication remains a separate governed boundary.
- No execution policy, source profile, route or identity threshold was fabricated/relaxed for acceptance.
- Applied migration history was not rewritten or retimestamped.

## Repository / CI / deployment truth

PR #72 remains OPEN / DRAFT / mergeable against accepted main `63c7107...`.

- Exact PR head: `a7283139a9e6088933be68fa69f75d2e9eb71fbe`.
- Exact-head Pilot Frontend Build `34681032426`: **PASS**.
- Cloudflare exact-head branch/commit preview: **deployment successful**.
- Intermediate head `eec6fbbf...` / run `34677940824` failed because CF-093 freshness UAT referenced nonexistent migration alias `20260912032000...`; exact-head correction now references applied `20260912031356...` and passes.
- Codex exact-head review is **blocked by the account code-review usage limit**. This is not approval or a technical review finding; merge remains blocked on the governed review gate.
- Visible accepted release remains v2.15.78; no Production deployment.

PR source now retains immutable applied migration identities, including `20260912035500_cf_093_scheduler_completion_anchored_dedupe`; no applied runtime history was rewritten or retimestamped.

## UQ 382-course acceptance — PASS

Corrected governed scope: 251 executable deterministic Layer 2 targets + 131 fresh terminal negatives.

Final original bound discovery history: 245 CRICOS-verified selected current URLs + 131 governed terminal negatives, with 0 transient/unattempted outcomes.

Corrected rerun batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f` terminalised with:

- 248 `resolved_l2`;
- 3 `layer3_required`;
- 0 failed/outstanding;
- same-token replay PASS (`idempotent_replay=true`);
- fresh-Preview completion-anchored dedupe PASS.

A pre-correction duplicate UQ batch was cancelled through the governed lifecycle with 0 processed items and no Evidence/canonical consequence. No generic Layer 3 or Search/Publication side effect was produced.

## RMIT 500-course acceptance — L2 PASS

Fresh Preview token: `c3e73796-d2d3-486e-b3a4-83afc54b806d`.

Preview:

- scope: 500 Courses;
- queueable: 261;
- Preview-bound discovery: 239;
- executable: true;
- profile/policy/route/oversize/discovery-config gaps: 0;
- scope fingerprint: `14ff4e15dd39bc46f785f4e03ca3b3dc`.

Discovery initially terminated fail-closed on pg_net request `5965` with 15 courses still transient/unattempted. The accepted active-binding retry contract redispatched exactly those 15 under request `5966`; no source profile, threshold or identity rule changed.

Final discovery:

| Discovery outcome | Courses |
|---|---:|
| CRICOS-verified selected current URL | 2 |
| Governed terminal negative | 237 |
| Transient / unattempted | 0 |
| **Total** | **239** |

Deterministic batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f` targeted 263 = 261 prior queueable + 2 selected discovery URLs and terminalised at `2026-09-12 06:11:31.218367Z`:

| L2 item status | Count |
|---|---:|
| `resolved_l2` | 213 |
| `layer3_required` | 50 |
| **Total** | **263** |

There were 263 succeeded `layer2_acquisition_v2` jobs, no generic Layer 3 jobs and zero Search refresh signals in the deterministic batch window. Handoff metadata explicitly records `canonical_mutation_authorised=false` and `search_publication_authorised=false`.

RMIT live replay/dedupe was not executed before its 30-minute completion-anchored window elapsed. Do not launch another 500-course run solely to recreate an expired timing proof. The corrected UQ acceptance provides live same-token and fresh-Preview dedupe evidence for this scheduler contract, and PR #72 carries targeted completion-dedupe UAT. Repeat naturally on a future governed run if it falls inside the live window.

## Layer 3 gate — qualified contract confirmed, authenticated execution pending

Owning Change Control `CF-CHG-20260825-038` is CLOSED/PASS and explicitly accepted the Layer 3 execution boundary and pinned real-provider benchmark.

Current runtime profile `openrouter-free-router-v1`:

- profile id `0b02920e-a021-48f5-ba47-75082fdcce13`;
- aggregator OpenRouter;
- pinned model `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`;
- enabled=true, paused=false;
- Pilot environment gate `pilot_qualified`, enabled=true;
- quality benchmark `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407`: PASS, 5/5 provider semantic cases + 13/13 controls, 5 calls, 315 input / 462 output tokens, observed cost USD 0, max latency 2811ms;
- rate limits 20 requests/minute and 50 requests/day; retry ceiling 1; timeout 30s; cost ceiling USD 0;
- allowed task classes: `course_description`, `official_course_url`, `delivery_mode`, `duration`.

The environment/profile `uat_ref` value `pending-live-provider-uat` is stale relative to the CLOSED/PASS owning Change Control and accepted benchmark. It should be reconciled as metadata through governed forward change; it is not authority to weaken the current accepted profile or bypass authentication.

The accepted UQ/RMIT L2 batches contain exactly 53 `layer3_required` items. All 53 have a current Evidence artifact and none has an existing Layer 3 interpretation.

Runtime Edge `layer3-interpret` v9 is ACTIVE with `verify_jwt=true` and validates the caller token through `auth.getUser()` before `layer3_reserve_interpretation_service`. The current repository/database connector session does not expose a legitimate browser user JWT. Therefore no live interpretation was invoked through service-role SQL or another identity bypass merely to obtain a PASS.

## Remaining acceptance gates

1. Perform a deliberately bounded Layer 3 live-provider acceptance through the authenticated `layer3-interpret` user surface against eligible UQ/RMIT Evidence; preserve existing profile/model/revalidation/rate/cost controls.
2. Record calls, tokens, cost, latency, validator disposition and Evidence lineage in `SYSTEM-METRICS.md`.
3. Keep generic scheduler Layer 3 disabled and preserve Layer 4/Search/Publication separation.
4. Reconcile the stale `pending-live-provider-uat` metadata only through an appropriate governed forward change; do not directly mutate privileged runtime state as a shortcut.
5. Obtain exact-head Codex review when code-review quota permits and retain exact-head CI/UAT/runtime green before merge.
6. Only after those gates are clean may PR #72 be merged or a new accepted visible release be considered.

## Next AU qualification wave

After CF-093 closes, qualify through normal source-profile / execution-policy / discovery-config governance: Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW. Cohort membership is not authority to manufacture missing configuration.

## Rollback / recovery

- Retain all failed/retry Evidence and immutable migration history.
- Any further runtime correction must be a new forward migration.
- PR #72 remains unmerged and draft.
- Accepted Pilot main and visible release remain unchanged.
- M2.5 remains paused; no Production Supabase project exists.
