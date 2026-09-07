# CF-CHG-20260907-240 — M2.4.5 v2.15.71 Baseline Recovery and Post-Baseline Supersession

**Status:** APPLIED — SOURCE BASELINE RESET / RUNTIME RECONCILIATION OPEN  
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

A fresh push-triggered Frontend Build and deployed UAT were automatically started for the restored head. Their new run IDs must be recorded before Stage 0 can be declared green.

## Runtime reconciliation boundary

The Pilot Supabase runtime still contains migrations applied after v2.15.71, including CF-235, CF-236 and CF-239 recovery migrations. Therefore:

- source recovery is APPLIED;
- database/runtime recovery is **OPEN**;
- no Stage 0 PASS may be claimed until runtime behaviour is reconciled and proven against the restored baseline;
- no destructive migration-history deletion is authorised;
- no Production environment may be touched;
- M2.5 remains paused.

Runtime recovery must preserve data/evidence and use an explicit governed rollback/reconciliation plan rather than deleting migration history.

## Rebuild rule from this point

The only accepted starting source is `c9dbbfb...` / v2.15.71. After fresh baseline proof, later work may be reintroduced one material feature/change at a time using targeted → bounded integration → nominated acceptance discipline. A failed delta stops progression and is diagnosed in isolation.

## Rollback / forensic recovery

If the source reset itself must be reversed for investigation only, restore a temporary branch from `forensic/post-v2-15-71-scrapped-20260907`. Do not move `main` forward to that forensic head without a new explicit governed decision.
