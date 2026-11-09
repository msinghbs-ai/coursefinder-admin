# CourseFinder project status review — 31 October 2026

## Evidence and scope
Read-only review of the admin INDEX, 30 October live-database throughput diagnostic and recent Pilot PR descriptions. This review did not independently query the live database or verify current deployment status. Source: docs/platform/nz-enrichment-brief/2026-10-30-field-report-throughput-diagnostic.md; Pilot PRs #754–#765.

## Executive judgement
Operational platform, with ongoing release delivery and governed AI enrichment. Principal blocker is page-to-course identity and stored-copy availability, not scheduling or AI budget. Do not equate successful jobs or net populated-field movement with successful admissions.

## Live diagnostic baseline (30 October)
| Measure | AU | NZ | CA |
|---|---:|---:|---:|
| Active courses | 25,380 | 6,474 | 3,814 |
| Valid page | 19,674 (77.5%) | 3,231 (49.9%) | 3,060 (80.2%) |
| Valid page with stored copy | 18,216 (71.8%) | 3,012 (46.5%) | 2,735 (71.7%) |
| Mismatch | 3,890 | 2,568 | 749 |
| Enrich filled/full-window items | 811/34,429 (2.4%) | 1,034/22,169 (4.7%) | 4,184/14,012 (29.9%) |

On the report day, page reads ended mismatch in AU 748/1,745, NZ 89/118 and CA 94/95. The daily field reports show net stock movement, not gross new admissions. Major negative deltas reflect approved retractions, archive/scope changes and policy withdrawals; the promised recovery of retracted values has been weak.

## Delivery progress
Recent Pilot PR descriptions record admin snapshot acceleration (PR #757), AU 500-course and NZ 421-course bounded entry reads (#754–#759), long-page probes and QUT reads (#760–#762), AER review safety and role checks (#763–#764), and an additive scale-stated marker (#765). PR #765 reports local suite 1,271 passed, zero failed/skipped. These are PR-reported results, not independent live deployment verification.

## Key risks and priorities
1. TD1: Audit 50 shared-URL and unproven bindings; require stronger course-specific proof before increasing spend.
2. TD2: Stop failed mismatch/no-copy candidate reads from creating futile Enrich attempts; report as held.
3. TD3: Count-guarded re-read of retracted course-fields only after valid binding and stored copy.
4. TD4/TD5: Separate gross admissions, replacements, withdrawals, course population and page mismatch/no-copy/page-silent states in reporting.
5. TD6: Complete event lineage and stale fee outcome reconciliation.
6. Human decisions: 85 NZ and 24 CA provider campus lists; 189 tuition pending and 985 campus review items at the diagnostic snapshot.
7. Monitor scheduled job failures and deploy health; verify actual live release, CI and worker version before production-readiness claims.

## Assessment
Engineering and governance: progressing. Data integrity: improved by approved take-backs, but recovery incomplete. Data throughput: constrained by binding quality. Consumer readiness: cannot be certified from this review alone. Recommended next gate: TD1 precision audit, followed by bounded fixes and a measured 7-day admission-yield comparison.

No production mutation performed by this review.
