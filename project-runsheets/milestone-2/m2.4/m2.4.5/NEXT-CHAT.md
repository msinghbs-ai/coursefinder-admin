# M2.4.5 NEXT CHAT

## Current pickup — 12 September 2026

- Milestone: **M2.4.5 ACTIVE / PRE-PRODUCTION HARDENING**.
- M2.5 remains PAUSED at P0; no Production Supabase project exists.
- Accepted Pilot `main`: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: **v2.15.78**.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Active change: `CF-CHG-20260910-093`.
- Active Pilot PR #72: `m245/cf093-async-discovery-20260912` at `a7283139a9e6088933be68fa69f75d2e9eb71fbe`.
- Exact-head Frontend Build `34681032426`: PASS.
- Cloudflare exact-head preview: PASS/deployed.
- Exact-head Codex review: **BLOCKED BY CODE-REVIEW USAGE LIMIT**; no technical review result is present.

## Large-university Layer 2 acceptance

### UQ — PASS

Corrected UQ scope is 382 Courses with 251 executable deterministic L2 targets and 131 governed terminal negatives. Final corrected discovery history contains 245 CRICOS-verified selected URLs + 131 terminal negatives. Corrected rerun batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f` completed 248 `resolved_l2` + 3 `layer3_required`, no failed items.

Same-token replay passed with `idempotent_replay=true`. Fresh-Preview completion-anchored dedupe also passed after the forward correction. No generic Layer 3, Search refresh, publication decision/event/approval or unauthorised canonical mutation was produced.

### RMIT — PASS

Fresh Preview token `c3e73796-d2d3-486e-b3a4-83afc54b806d`: 500 Courses, 261 queueable, 239 Preview-bound discovery, zero profile/policy/route/oversize/discovery-config gaps.

The first discovery chain failed closed at request `5965` with 15 unresolved/transient courses. A bounded retry of those exact 15 under the same binding completed without relaxing profile or identity rules.

Final discovery: 2 selected CRICOS-verified URLs + 237 governed terminal negatives = 239/239.

Deterministic batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f` targeted 263 Courses and terminalised at `2026-09-12 06:11:31.218367Z` with 213 `resolved_l2` + 50 `layer3_required`, zero queued/acquiring/failure states. Runtime recorded `canonical_mutation_authorised=false` and `search_publication_authorised=false`; 263 succeeded `layer2_acquisition_v2` jobs and zero Search refresh signals were observed.

RMIT elapsed metrics: discovery ~1h54m55s / ~2.08 Courses/min; deterministic L2 ~20m34s / ~12.79 items/min. L2 vendor units 263; recorded vendor cost USD 0; average response 1647ms (p95 1884ms); average extraction 1731ms (p95 2115ms). These are observed run metrics, not SLAs.

RMIT live replay/dedupe was not performed before the 30-minute completion-anchored window elapsed. Do not launch a duplicate 500-course run merely to recreate this expired timing proof. UQ provides live replay/dedupe evidence and PR #72 contains targeted contract UAT.

## Repository / CI recovery

PR #72 now carries the applied migration identities rather than timestamp aliases. Intermediate head `eec6fbbfe04709d81150825fe70e31eb3cc8f7f9` failed Frontend Build `34677940824` because `cf-093-terminal-negative-freshness-dedupe.spec.mjs` still referenced nonexistent migration alias `20260912032000...`. Commit `a7283139a9e6088933be68fa69f75d2e9eb71fbe` changed that UAT reference to applied migration `20260912031356...`; exact-head run `34681032426` passes.

The failed intermediate run also displayed stale unrelated historical UAT assertions for older visible versions/navigation/API syntax. Do not opportunistically rewrite those under CF-093; route separately if they become a release blocker.

## Exact next gate

1. Reconcile PR #72 description and remaining CF-093 governance/metrics to exact head `a7283139...`.
2. Inspect current Course Layer 3 profile/provider/model/revalidation/live-provider state and the 53 total `layer3_required` UQ/RMIT dispositions.
3. Run only bounded eligible Evidence through the existing qualified Layer 3 contract if prerequisites are current. Generic scheduler Layer 3 remains prohibited.
4. Obtain exact-head Codex review when usage quota permits. Quota exhaustion is not approval.
5. Keep exact-head CI/UAT/runtime clean and merge PR #72 only after all governed gates pass.
6. Accepted main/release remain unchanged until merge/release governance completes.
7. After CF-093 closes, continue normal qualification: Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW.

## Pickup text

> Continue CF M2.4.5 / CF-CHG-20260910-093 from repository/runtime truth. Accepted Pilot main is `63c7107cfce2d8f607fc378af4881d0ba28ca879`, visible release v2.15.78. PR #72 is open/draft/mergeable at exact head `a7283139a9e6088933be68fa69f75d2e9eb71fbe`; Frontend Build `34681032426` and Cloudflare preview PASS. Codex review is blocked by the account code-review usage limit, with no technical review result. UQ 382-course Layer 2 acceptance is PASS (corrected rerun 248 resolved_l2 + 3 layer3_required; replay and fresh-preview dedupe PASS). RMIT 500-course Layer 2 acceptance is PASS: discovery 2 selected + 237 terminal negatives, deterministic batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f` 213 resolved_l2 + 50 layer3_required, no generic L3 or Search side effects. Do not recreate expired RMIT replay timing by launching another 500-course run. Next inspect the existing qualified Layer 3 Evidence/profile/model/revalidation contract for the 53 eligible dispositions, run only bounded acceptance if qualified, then obtain exact-head Codex and merge only if all gates remain clean.
