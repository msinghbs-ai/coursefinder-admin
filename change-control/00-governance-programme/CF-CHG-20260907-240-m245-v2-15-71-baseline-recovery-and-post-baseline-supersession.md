# CF-CHG-20260907-240 — M2.4.5 v2.15.71 Baseline Recovery and Post-Baseline Supersession

**Status:** APPLIED — SOURCE BASELINE RESET / FRESH UI PASS / RUNTIME RECONCILIATION OPEN  
**Milestone:** M2.4.5  
**Date:** 7 September 2026  
**Authority:** User-directed recovery decision

## Decision

CourseFinder Pilot source is recovered to the last independently evidenced stable visible release before the subsequent recovery chain:

- visible release: **v2.15.71**;
- baseline commit: `c9dbbfb0f1bdbe63c28d68a27077357797b2ae84`;
- baseline change: `CF-228 align deployed release currentness to v2.15.71`;
- historical Frontend Build `34033957287`: PASS;
- historical deployed UAT `34033957268`: PASS.

The prior restart target `8bc6960d05e5521ff6ae44ad0ee49e7c07ef80ff` / v2.15.72 is superseded by this decision.

## Fresh restored-source proof

After restoring Pilot `main` to `c9dbbfb...`:

- Frontend Build `34085535964`: **PASS**;
- deployed targeted UAT `34085535954`: **PASS**;
- deployed head: `c9dbbfb0f1bdbe63c28d68a27077357797b2ae84`;
- visible/source release target: **v2.15.71**.

This proves the restored UI/source is deployable and functionally passes the current targeted gate. It does not prove database migration parity because the Pilot database still contains later migrations.

## Preserved forensic history

The former Pilot main head was preserved before reset:

- former head: `fbf7cca96d9f64d1d95db4ccc780399549ebde4d`;
- forensic branch: `forensic/post-v2-15-71-scrapped-20260907`;
- previously retained recovery branch: `recovery/cf238-cf239-forensic-20260907`;
- previously retained v2.15.72 baseline branch: `recovery/m245-stable-baseline-20260907`;
- previously retained v2.15.66 investigation branch: `recovery/m245-v2-15-66-20260907`.

No forensic branch or failed UAT evidence is to be deleted or rewritten.

## Superseded post-v2.15.71 source range

Git comparison from `c9dbbfb...` to `fbf7cca...` reports **54 commits ahead / 0 behind**. All 54 commits are now **SUPERSEDED FOR REBUILD PURPOSES**. They remain available only as forensic/reference material and are not accepted as current M2.4.5 implementation.

The superseded range starts with:

- `0e1e1e4069945565d74f47aba2261e9cb1885a8d` — CF-228 deployed v2.15.71 verification update, which exposed the ranking URL/file semantic mismatch;

and extends through:

- `fbf7cca96d9f64d1d95db4ccc780399549ebde4d` — CF-239 bounded integration re-nomination.

## Superseded feature/recovery groups

The following work performed after the stable v2.15.71 baseline is not current and must be reconsidered one governed item at a time before any reintroduction:

1. CF-228 post-release verification changes and ranking-currentness test adjustments.
2. CF-229 through CF-234 ranking/Compare/QILT recovery and v2.15.72 promotion work.
3. CF-230 ranking Layer 1 Evidence changes.
4. CF-231 ranking edition/evidence-completeness changes.
5. CF-232 role-safe Layer Status summary changes.
6. CF-235 Layer 4 public-wrapper security hardening.
7. CF-236 Scholarship/statistics RPC and search-path hardening.
8. CF-238 bounded integration candidate and retained failure evidence.
9. CF-239 Evidence/Layer 2 performance, helper ACL and index recovery work.
10. Any associated H11 Provider-logo reproof or post-baseline navigation/test-contract adjustments that occurred inside the superseded range.

This supersession does **not** declare those designs invalid. It declares that they no longer form part of the accepted baseline and must be requalified individually if needed.

## Superseded changed surface

The comparison identifies post-baseline changes across release/currentness, Compare/ranking UI, ranking acquisition functions, database migrations, UAT routing and performance recovery. Important affected files include:

- `src/release-currentness-entry.js`;
- `src/CompareRecovery.js`;
- `src/RankingStatisticsRecovery.js`;
- `src/RankingDatasetViewer.js`;
- `src/ranking-layer1-evidence-ui.js`;
- ranking publisher / QS / THE Edge Functions;
- CF-231, CF-232, CF-235, CF-236 and CF-239 migrations;
- Compare/ranking deployed UAT suites;
- shared navigation UAT helper;
- bounded integration/performance candidate markers.

The full immutable diff remains reconstructable from the preserved forensic branch.

## Source recovery action

Pilot `main` was force-moved from `fbf7cca...` to exactly `c9dbbfb...` only after creating the forensic preservation branch.

This reset intentionally restores source/UI behaviour and visible release **v2.15.71**. It does not by itself roll back the Supabase Pilot database.

## Database drift beyond v2.15.71

The current Pilot Supabase migration history contains the following migrations that are absent from the restored v2.15.71 source baseline:

- `20260906205708` — `cf231_qs_inline_evidence_context`;
- `20260906235448` — `cf_232_layer_status_summary_role_safe_layer3_count`;
- `20260907002955` — `cf_235_layer4_public_wrapper_security_hardening`;
- `20260907003322` — `cf_236_preproduction_rpc_security_hardening`;
- `20260907023220` — `cf_239_m245_bounded_runtime_performance_recovery`;
- `20260907024414` — `cf_239_targeted_performance_recovery_followup`;
- `20260907024936` — `cf_239_layer2_overview_index_headroom`.

Therefore the current database is not migration-parity-equivalent to v2.15.71 even though the restored UI currently passes targeted deployed UAT.

## CF-239 thorough inspection

### Migration 1 — bounded runtime performance recovery

`cf_239_m245_bounded_runtime_performance_recovery` introduced:

- seven general supporting indexes covering Evidence chronology, Layer 2 provider attempts, Layer 3 interpretations, Jobs, and Scholarship mapping state/status;
- new private helper `security.admin_evidence_page_default_fast(jsonb)`;
- a replacement definition of `public.admin_read(text,jsonb)` routing default `evidence_page` requests through the new fast helper while preserving filtered/non-default Evidence requests through the prior `security.admin_evidence_page` path.

The helper is `SECURITY DEFINER`, enforces authenticated identity and minimum curator rank, and preserves the prior Evidence status/freshness/conflict/lineage/storage projection for the bounded default page. It changes execution strategy, not intended business semantics.

### Migration 2 — targeted performance recovery follow-up

`cf_239_targeted_performance_recovery_followup` introduced:

- authenticated/service-role EXECUTE on the new Evidence helper after the first deployed run exposed an HTTP 403 ACL-chain defect;
- two additional indexes, including a first Layer 2 Evidence partial index using `(metadata->>'layer')='2'`;
- new helper `security.admin_layer2_ops_overview_fast()` with `jit=off`;
- a guarded rewrite of `public.admin_read` so only `layer2_ops_overview` routes through that helper while `layer2_ops_run_detail` remains on the original implementation.

This migration is operationally significant because it changes the dispatcher/helper call chain and ACL surface even though the intended payload semantics remain unchanged.

### Migration 3 — exact-predicate index headroom

`cf_239_layer2_overview_index_headroom` introduced three indexes only:

- exact `coalesce(metadata->>'layer','')='2'` Evidence overview index;
- selected Layer 2 course-discovery URL/course index;
- covering Layer 2 provider-attempt overview index.

This migration does not alter data or function semantics.

### Current runtime confirmation

Current Pilot runtime confirms:

- `public.admin_read` remains `SECURITY INVOKER`, authenticated executable, anon denied;
- `security.admin_evidence_page_default_fast` exists as `SECURITY DEFINER`, authenticated executable, anon denied;
- `security.admin_layer2_ops_overview_fast` exists as `SECURITY INVOKER` with `jit=off`, authenticated executable, anon denied;
- all twelve CF-239-created indexes are currently present.

### Observed index use

Current `pg_stat_user_indexes` shows that several CF-239 indexes are materially used, including:

- `evidence_artifacts_captured_nulls_last_idx`;
- `evidence_artifacts_created_at_idx`;
- `jobs_job_type_status_created_idx`;
- `layer2_provider_attempts_created_at_idx`;
- `evidence_artifacts_layer2_overview_coalesce_idx`;
- `layer2_provider_attempts_overview_cover_idx`;
- Scholarship mapping state/status indexes.

Other CF-239 indexes currently report zero scans, including the first non-coalesced Layer 2 Evidence partial index, `courses_provider_with_url_idx`, `layer2_course_discovery_selected_url_course_idx`, and `layer3_interpretations_created_at_idx`. Zero scan count alone is not authority to remove them; it is only evidence that they have not contributed to recorded plans since statistics reset/start.

## CF-239 acceptance history and safe-boundary decision

CF-239 was created because CF-238 bounded integration `34070394953` had already failed with Evidence latency, HTTP 500 statement timeouts and a stale navigation expectation.

CF-239 first targeted proof `34076738567` also failed: Evidence returned HTTP 403 and Layer 2 overview remained over budget.

The later targeted proof `34077761500` passed the intended performance suite, but retained a first-attempt `course_detail` measurement of `3022 ms` before retry success.

Most importantly, the re-nominated bounded desktop/mobile integration run `34077935830` ultimately completed **FAILURE**.

Therefore:

- **CF-239 is NOT an accepted stable baseline.**
- **The runtime immediately before CF-239 is also NOT to be marked safe merely because it predates CF-239; CF-238 had already failed there.**
- The only currently proven safe source/UI baseline is **v2.15.71 / `c9dbbfb...`**, with fresh Build `34085535964` PASS and deployed UAT `34085535954` PASS.
- Database safe parity remains **OPEN** until the post-v2.15.71 migrations are individually reconciled.

### Marked checkpoints

**SAFE SOURCE/UI BASELINE:** `c9dbbfb0f1bdbe63c28d68a27077357797b2ae84` / v2.15.71.  
**PRE-CF-239 RUNTIME CHECKPOINT:** retained for forensic comparison only — **NOT ACCEPTED / NOT SAFE**.  
**CF-239 RUNTIME:** **SUPERSEDED / NOT ACCEPTED** despite targeted performance PASS because bounded integration later failed.  

This classification prevents rollback work from accidentally promoting the pre-CF-239 state as an accepted runtime baseline.

## Runtime reconciliation boundary

Source recovery is APPLIED and fresh UI proof is PASS. Database/runtime recovery remains **OPEN**.

No Stage 0 database-parity PASS may be claimed until CF-231, CF-232, CF-235, CF-236 and CF-239 runtime deltas are explicitly retained or reverted with governed proof.

No destructive migration-history deletion is authorised. Any database reconciliation must preserve canonical data and Evidence and use explicit forward reconciliation/reversion migrations where required.

Production remains untouched and M2.5 remains paused.

## Rebuild rule from this point

The only accepted starting source is `c9dbbfb...` / v2.15.71. Later work may be reintroduced one material feature/change at a time using targeted → bounded integration → nominated acceptance discipline. A failed delta stops progression and is diagnosed in isolation.

## Rollback / forensic recovery

If the source reset itself must be reversed for investigation only, restore a temporary branch from `forensic/post-v2-15-71-scrapped-20260907`. Do not move `main` forward to that forensic head without a new explicit governed decision.
