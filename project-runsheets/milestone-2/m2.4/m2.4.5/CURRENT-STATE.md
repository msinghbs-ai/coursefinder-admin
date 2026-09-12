# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 LARGE-UNIVERSITY L2 PASS; AUTHENTICATED L3 + CODEX GATES OPEN  
**Reconciled:** 2026-09-12 AEST  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Visible accepted release:** v2.15.78  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Active implementation candidate

- Pilot PR #72: `CF-093: complete Preview-bound async Layer 2 discovery`.
- Branch: `m245/cf093-async-discovery-20260912`.
- Exact head: `a7283139a9e6088933be68fa69f75d2e9eb71fbe`.
- Base main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- PR state: OPEN / DRAFT / mergeable.
- Exact-head Pilot Frontend Build `34681032426`: PASS.
- Cloudflare exact-head commit/branch preview: PASS/deployed.
- Exact-head Codex review: blocked by code-review usage quota; no technical review result exists.
- PR description is reconciled to current UQ/RMIT/runtime truth.

## Repository/runtime reconciliation

PR #72 now carries immutable Pilot-applied migration identities; no applied migration was rewritten or retimestamped. Exact-head commit `a7283139...` corrects the freshness UAT reference to applied migration `20260912031356_cf_093_scheduler_terminal_negative_freshness_dedupe.sql`. Intermediate failed run `34677940824` is superseded by green exact-head run `34681032426`.

## UQ 382-course Layer 2 acceptance — PASS

Corrected scope: 251 executable Layer 2 targets + 131 fresh governed terminal negatives. Original discovery evidence established 245 CRICOS-verified selected current URLs + 131 terminal negatives with zero unresolved/transient outcomes.

Corrected rerun batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`, zero failure/outstanding. Same-token replay PASS and completion-anchored fresh-Preview dedupe PASS. A pre-correction duplicate was governed-cancelled with zero processed items. No generic Layer 3/Search/Publication side effects.

## RMIT 500-course Layer 2 acceptance — PASS

Preview `c3e73796-d2d3-486e-b3a4-83afc54b806d`: 500 scoped, 261 queueable, 239 discovery, zero qualification gaps. The first chain failed closed with 15 unresolved/transient items; a bounded retry of exactly those 15 completed without profile/threshold relaxation.

Final discovery: 2 CRICOS-verified selected current URLs + 237 governed terminal negatives = 239/239.

Deterministic batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required` = 263/263, zero queued/acquiring/failure states. There were 263 succeeded `layer2_acquisition_v2` jobs, no generic Layer 3 jobs and zero Search refresh signals. Runtime handoff records canonical mutation and Search/Publication authority as false.

RMIT replay/dedupe was not re-invoked inside its 30-minute completion window. Do not launch another 500-course run solely to reproduce expired timing; UQ supplies live proof for the corrected common contract and targeted UAT covers completion dedupe.

## Layer 3 gate — contract qualified, authenticated bounded run pending

Owning `CF-CHG-20260825-038` is CLOSED/PASS and accepted the Layer 3 execution boundary and real-provider benchmark.

Current runtime profile:

- code `openrouter-free-router-v1`;
- id `0b02920e-a021-48f5-ba47-75082fdcce13`;
- OpenRouter pinned model `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`;
- enabled=true, paused=false;
- Pilot environment `pilot_qualified`, enabled=true;
- benchmark `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407`: PASS (5/5 provider semantic, 13/13 controls, 5 external calls, 315 input / 462 output tokens, USD 0 observed cost, 2811ms max latency);
- allowed Course task classes: `course_description`, `official_course_url`, `delivery_mode`, `duration`;
- limits: 20 requests/minute, 50/day, retry ceiling 1, timeout 30s, cost ceiling USD 0.

Large-university L2 output contains exactly 53 `layer3_required` items (3 UQ + 50 RMIT). All 53 have current Evidence artifacts and none already has a Layer 3 interpretation.

`layer3-interpret` Edge v9 is ACTIVE with `verify_jwt=true` and calls `auth.getUser()` before reserving an interpretation. The available repository/database connector session does not provide a legitimate current browser user JWT. A live call was therefore not simulated with service-role/direct SQL, because doing so would bypass the accepted identity boundary.

Runtime `uat_ref=pending-live-provider-uat` is stale relative to the CLOSED/PASS owning Change Control and accepted benchmark. Reconcile this metadata through a governed forward change; do not directly mutate privileged runtime state as a shortcut.

## Exact next gate

1. Use an authorised authenticated Layer 3 user/session surface for a deliberately bounded live-provider acceptance against eligible UQ/RMIT Evidence.
2. Record calls, tokens, cost, latency, validator outcome and Evidence lineage in `SYSTEM-METRICS.md`.
3. Preserve Layer 4 and Search/Publication separation; generic scheduler Layer 3 remains disabled.
4. Reconcile stale Layer 3 UAT metadata through governed forward change if required by acceptance.
5. Obtain exact-head Codex review when quota permits; quota exhaustion is not approval.
6. Keep exact-head CI/UAT/runtime green; merge PR #72 only after all required gates pass.
7. Accepted main/release remain unchanged until merge/release governance completes.

After CF-093 closes, normal AU qualification order remains Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW. No missing policy/profile/config may be fabricated.

M2.4.4 remains CLOSED/PASS/FROZEN and M2.5 remains paused.
