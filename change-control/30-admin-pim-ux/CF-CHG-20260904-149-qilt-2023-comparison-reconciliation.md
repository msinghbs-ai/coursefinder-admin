# CF-CHG-20260904-149 — QILT 2023 Comparison Reconciliation

**Status:** IMPLEMENTED / RUNTIME PASS — BOUNDED 2023 DATA, DEPLOYED UI VERIFICATION PENDING  
**Milestone:** M2.4.5  
**Initiated:** 2026-09-04 Australia/Melbourne  
**Primary category:** 30 — Admin/PIM UX  
**Affected surfaces:** Layer 1 statistics, QILT contextual read, Provider/Course Compare  
**Related:** CF-061, CF-070, A12

## Origin

Meeting-preparation UAT compared CourseFinder Provider comparison against the public ComparED/QILT presentation for Monash University, RMIT University and La Trobe University.

Observed defects:
- QILT SES undergraduate and postgraduate coursework rows were both stored with `study_level_id = null`; the browser therefore presented them as `All study levels` and could align the wrong cohort across institutions.
- `confidence_high` and `national_benchmark` are absent on the existing 2024 import, but the comparison numeric helper converted JavaScript `null` to zero, producing false `CI ... – 0.0%` and `National benchmark 0.0%` output.
- the Pilot retained 2024 SES observations but did not retain the 2023 SES institution comparison rows required for historical comparison.

## Correction

Pilot runtime migration `cf_149_qilt_2023_comparison_reconciliation`:

1. Retains a governed source-reference Evidence record for the official QILT 2023 Student Experience Survey National Report.
2. Adds a bounded official 2023 SES reconciliation for the meeting trio:
   - Monash University;
   - RMIT University (RMIT);
   - La Trobe University.
3. Retains both QILT source cohorts independently:
   - `UG` → Undergraduate;
   - `PGC` → Postgraduate coursework.
4. Adds the six SES comparison measures per cohort:
   - skills development;
   - peer engagement;
   - teaching quality and engagement;
   - student support and services;
   - learning resources;
   - quality of entire educational experience.
5. Retains the published 2023 lower/upper confidence bounds and national benchmark at the compatible cohort/metric grain.
6. Does not manufacture response counts where they were not captured in the bounded source extraction.
7. `admin_contextual_insights_v2` now derives display study level from the governed `source_cohort_code` when `study_level_id` is absent and strips null JSON fields before browser delivery.

## Runtime result

Authenticated `admin_read('contextual_compare', ...)` for Monash + RMIT + La Trobe passes after migration.

The result now contains:
- existing 2024 SES observations preserved;
- 2023 SES observations for both UG and PGC;
- explicit `study_level` / `study_level_code` for source-cohort rows;
- 2023 confidence lower + upper bounds;
- 2023 national benchmarks;
- null 2024 benchmark/high-CI fields omitted rather than represented as false zeros.

Example 2023 undergraduate overall educational experience:
- Monash: 73.1%, CI 72.6–73.7%, benchmark 76.5%;
- RMIT: 73.9%, CI 73.0–74.8%, benchmark 76.5%;
- La Trobe: 73.8%, CI 73.0–74.6%, benchmark 76.5%.

## Important interpretation

ComparED commonly presents a pooled/public comparison period such as 2023–2024. CF-149 does **not** manufacture that pooled value from two single-year observations. CourseFinder now retains the official 2023 and existing 2024 source years independently. A later full QILT historical/backfill or publisher-provided pooled edition may be ingested through the same governed year/cohort/metric grain.

## Authority boundary

No Provider/Course identity, Scholarship, PRISMS, ranking, Search, Publication, Website or Zoho authority changed. QILT remains contextual/statistical and `identity_authority=false`.

## Implementation evidence

- live Pilot migration: `cf_149_qilt_2023_comparison_reconciliation`;
- repository migration: `supabase/migrations/20260904075532_cf_149_qilt_2023_comparison_reconciliation.sql`;
- Pilot commit: `8b0c5d57aad1324a192ea29e62355515361ac8ed`.

## Remaining fast-follow before closure

- browser source guard so null/blank numeric values can never be converted to zero independently of server JSON stripping;
- semantic QILT display order/profile rather than alphabetic metric ordering;
- deployed browser validation for 2023 UG/PGC switching and no false 0.0 benchmark/CI;
- full historical QILT ingestion beyond the bounded meeting trio through the existing Layer 1 statistical-ingestion process.
