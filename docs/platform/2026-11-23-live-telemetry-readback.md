# Live telemetry read-back for the architecture audit bundle (23 Nov 2026)

**Prepared by:** `S1-Build` (Platform Admin 23 Nov 2026 20:38 AEDT). **Fills:** the live gaps listed in section 0 of `coursefinder-architecture-audit-bundle.md` (Drive). **Method:** rolled-back reads through the shared dry-run workflow (`db-migration-dry-run.yml`, branch `s1-build-diag`), 23 Nov 2026 20:40 to 20:45 AEDT. No interactive SQL; nothing changed.

## 1. Guardrails and settings

| Measure | Live value | Note |
|---|---|---|
| Consumer API (G3) | 75 functions, 48 relations, no drift | `security.consumer_api_check_v1()` |
| Manual locks | 7,585 | `pipeline.manual_locks` |
| Active cron jobs | 135 of 226 scheduled | 140 or fewer |
| Migration head | `20261123210000` (s1010) | Before s1011 |
| `firecrawl.daily_budget_total` | 5 (credits a day) | s1010; the setting counts credits, not US$ |
| `firecrawl.daily_budget_on` | true | Budget guard on |
| `firecrawl.ondemand_credits_per_day` | 2,000 credits | On-demand work (not held by the scheduled budget) |
| `firecrawl.builder_ai_daily_usd` | US$5 | Adapter builder AI cap |
| `budgets.paid_daily_cap_usd` | US$5.00 | s997; Standing Authority Charter platform cap |
| `budgets.ai_daily_ceiling_usd` | US$14 | Above the US$5.00 platform cap; S3's enforced guard, not changed (decision for the Platform Admin) |

## 2. Row-level security

The audit counted 13 tables with row-level security off; the live catalogue holds **93** (all owned by `postgres`): 2 in `catalogue`, 79 in `pipeline`, 2 in `private` (the Zoho credential tables), 3 in `publishing`, 1 in `ranking`, 3 in `ref`, 2 in `scholarship`, 3 in `search`. Only `ref.nationality_terms` grants anything outside `postgres` and `service_role` (SELECT to `authenticated`); no other role holds a grant on any of them, and every reader is a `postgres`-owned security definer function, `service_role` or `postgres`. s1011 turns row-level security on for all 93 (0 left off in the rehearsal), with a read policy on `ref.nationality_terms`. The security advisor lists only the exposed `public` schema, which is why it did not show them.

## 3. Indexes

- Exact duplicates (same table, columns and WHERE clause; no constraint): `catalogue.courses_empty_reason_code_idx` = `idx_courses_empty_reason_code`; `catalogue.courses_study_load_idx` = `idx_courses_study_load`; `pipeline.aer_v2_shadow_results_version_course` = `aer_v2_shadow_results_course`. Dropped by `docs/paste/PASTE-20261123-s1011-duplicate-indexes-drop.sql`.
- Foreign keys without a leading index: `catalogue.course_entry_requirements (country_id)` (37,863 rows) and `catalogue.provider_entry_matrix (study_level_id)` (15,581 rows; held only third in `provider_entry_matrix_lookup_ix`). Added by s1011. `provider_entry_matrix (country_id)` has no leading index either; it was not in this slice.

## 4. Dead tuples (`pg_stat_user_tables`, top 45 by dead rows)

| Table | Live rows | Dead rows | Dead share | Last autovacuum (UTC) | Last autoanalyse (UTC) |
|---|---|---|---|---|---|
| `pipeline.course_attribute_coverage` | 530,347 | 96,793 | 15% | 11-23 09:01 | 11-23 09:37 |
| `pipeline.mode_outcome_ledger` | 478,466 | 93,283 | 16% | 11-19 14:46 | 11-22 12:52 |
| `pipeline.coverage_provider_urls` | 326,592 | 62,068 | 16% | 11-15 04:46 | 11-19 12:44 |
| `pipeline.field_enrich_items` | 279,377 | 46,135 | 14% | 11-20 00:54 | 11-21 20:56 |
| `pipeline.provider_discovery_links` | 215,708 | 30,831 | 13% | 11-17 14:11 | 11-19 14:10 |
| `scholarship.course_mappings` | 142,700 | 26,988 | 16% | 11-13 14:34 | 11-14 17:23 |
| `catalogue.course_fees` | 191,103 | 24,976 | 12% | 10-04 20:00 | 11-03 18:48 |
| `pipeline.evidence_entity_links` | 210,728 | 24,774 | 11% | 11-17 08:37 | 11-17 14:38 |
| `storage.objects` | 264,578 | 23,035 | 8% | 11-19 06:31 | 11-20 02:17 |
| `ranking.indicator_observations` | 264,902 | 18,853 | 7% | 11-22 01:26 | 11-22 04:40 |
| `pipeline.gap_cause_snapshots` | 98,112 | 17,546 | 15% | 11-20 18:56 | 11-23 01:55 |
| `pipeline.completeness_daily` | 104,889 | 15,102 | 13% | 11-23 05:52 | 11-23 08:54 |
| `pipeline.enrichment_flags` | 95,843 | 14,446 | 13% | 11-04 02:44 | 11-23 04:05 |
| `pipeline.coverage_ai_match` | 75,611 | 12,209 | 14% | 11-14 14:05 | 11-21 13:36 |
| `catalogue.course_study_level_observations` | 60,709 | 11,403 | 16% | 09-26 14:15 | 11-17 08:35 |
| `pipeline.enrich_ai_answers` | 120,326 | 10,881 | 8% | 11-18 22:34 | 11-21 20:00 |
| `pipeline.platform_edge_calls` | 60,717 | 9,235 | 13% | 11-23 01:46 | 11-23 07:44 |
| `catalogue.course_regulatory_observations` | 59,466 | 8,780 | 13% | 11-03 18:48 | 11-17 07:07 |
| `pipeline.evidence_storage_dedupe_log` | 47,169 | 7,538 | 14% | 10-19 11:09 | 10-19 11:09 |
| `pipeline.layer4_review_items` | 64,939 | 7,429 | 10% | 11-20 05:55 | 11-20 06:25 |
| `catalogue.course_entry_requirements` | 38,021 | 7,054 | 16% | 11-20 06:30 | 11-21 02:06 |
| `catalogue.course_registrations` | 34,752 | 6,543 | 16% | 10-30 11:49 | 11-16 20:09 |
| `pipeline.edge_request_log` | 50,000 | 6,413 | 11% | 11-23 04:28 | 11-23 07:36 |
| `search.course_documents` | 34,356 | 5,915 | 15% | 11-22 21:01 | 11-23 04:38 |
| `catalogue.course_campuses` | 55,921 | 5,792 | 9% | 11-17 07:03 | 11-17 08:42 |
| `pipeline.scholarship_ai_queue` | 88,552 | 5,326 | 6% | 11-21 11:24 | 11-22 11:34 |
| `ranking.observations` | 38,754 | 5,103 | 12% | 11-22 01:26 | 11-22 02:12 |
| `pipeline.zoho_sync_items` | 47,436 | 5,017 | 10% | 11-22 05:33 | 11-22 04:58 |
| `pipeline.scholarship_coverage_items` | 27,693 | 5,009 | 15% | 11-23 04:40 | 11-23 05:40 |
| `pipeline.evidence_lineage_stats` | 43,030 | 4,970 | 10% | 11-17 11:41 | 11-23 04:18 |
| `pipeline.scholarship_page_candidates` | 32,348 | 4,649 | 13% | 11-16 16:51 | 11-22 02:58 |
| `pipeline.coverage_course_pages` | 35,880 | 4,614 | 11% | 11-20 13:03 | 11-23 08:04 |
| `catalogue.course_intakes` | 37,994 | 4,517 | 11% | 11-11 04:31 | 11-15 20:27 |
| `pipeline.firecrawl_run_items` | 36,713 | 4,444 | 11% | 11-02 13:34 | 11-02 14:24 |
| `pipeline.course_description_machine_admissions` | 23,010 | 4,350 | 16% | 11-16 08:33 | 11-22 22:56 |
| `pipeline.website_sync_items` | 43,144 | 3,891 | 8% | 11-22 05:32 | 11-22 05:03 |
| `pipeline.pilot_edge_nonces` | 52,512 | 3,848 | 7% | 11-23 06:14 | 11-23 08:57 |
| `pipeline.layer1_register_row_state` | 32,415 | 3,823 | 11% | 11-17 07:57 | 11-17 11:41 |
| `pipeline.course_link_search` | 26,530 | 3,372 | 11% | 11-20 13:12 | 11-21 01:51 |
| `pipeline.course_intake_dates` | 17,905 | 3,228 | 15% | 11-23 04:17 | 11-23 05:04 |
| `pipeline.course_field_absence` | 59,322 | 2,995 | 5% | 11-20 06:25 | 11-21 19:54 |
| `pipeline.scholarship_ai_extractions` | 74,684 | 2,977 | 4% | 11-15 15:14 | 11-19 15:50 |
| `pipeline.aer_machine_admissions` | 17,199 | 2,965 | 15% | 11-21 16:52 | 11-23 04:18 |
| `pipeline.course_coverage_daily_by_country` | 26,914 | 2,770 | 9% | 11-19 00:38 | 11-23 09:29 |
| `catalogue.provider_entry_matrix` | 15,581 | 2,660 | 15% | 11-23 07:43 | 11-21 00:20 |

## 5. Largest tables (total size including indexes and TOAST, top 45)

| Table | Live rows | Dead rows | Total size |
|---|---|---|---|
| `storage.objects` | 264,578 | 23,035 | 741 MB |
| `pipeline.evidence_artifacts` | 236,101 | 1,377 | 497 MB |
| `pipeline.field_enrich_items` | 279,377 | 46,135 | 354 MB |
| `search.course_documents` | 34,356 | 5,915 | 253 MB |
| `pipeline.mode_outcome_ledger` | 478,466 | 93,283 | 246 MB |
| `pipeline.scholarship_ai_extractions` | 74,684 | 2,977 | 201 MB |
| `pipeline.enrich_ai_answers` | 120,326 | 10,881 | 193 MB |
| `pipeline.coverage_provider_urls` | 326,592 | 62,068 | 166 MB |
| `pipeline.course_attribute_coverage` | 530,347 | 96,793 | 145 MB |
| `catalogue.course_fees` | 191,103 | 24,976 | 143 MB |
| `pipeline.layer4_review_items` | 64,939 | 7,429 | 141 MB |
| `pipeline.scholarship_page_candidates` | 32,348 | 4,649 | 138 MB |
| `pipeline.admin_control_events` | 61,904 | 1,932 | 127 MB |
| `pipeline.coverage_ai_match` | 75,611 | 12,209 | 125 MB |
| `pipeline.layer4_decisions` | 31,096 | 247 | 113 MB |
| `pipeline.provider_discovery_links` | 215,708 | 30,831 | 113 MB |
| `pipeline.website_sync_items` | 43,144 | 3,891 | 108 MB |
| `pipeline.zoho_sync_items` | 47,436 | 5,017 | 107 MB |
| `pipeline.ai_eval_examples` | 76,112 | 0 | 103 MB |
| `scholarship.course_mappings` | 142,700 | 26,988 | 101 MB |
| `pipeline.coverage_vendor_usage` | 251,678 | 11 | 86 MB |
| `catalogue.courses` | 44,734 | 1,389 | 85 MB |
| `ranking.observations` | 38,754 | 5,103 | 83 MB |
| `pipeline.coverage_course_pages` | 35,880 | 4,614 | 78 MB |
| `ranking.indicator_observations` | 264,902 | 18,853 | 78 MB |
| `pipeline.evidence_entity_links` | 210,728 | 24,774 | 72 MB |
| `cron.job_run_details` | 139,640 | 0 | 70 MB |
| `pipeline.jobs` | 38,597 | 775 | 65 MB |
| `pipeline.enrichment_flags` | 95,843 | 14,446 | 64 MB |
| `pipeline.layer3_interpretations` | 19,126 | 0 | 54 MB |
| `pipeline.course_fact_source_records` | 42,151 | 95 | 54 MB |
| `pipeline.evidence_storage_dedupe_log` | 47,169 | 7,538 | 51 MB |
| `pipeline.course_description_machine_admissions` | 23,010 | 4,350 | 49 MB |
| `pipeline.enrichment_flag_events` | 145,211 | 1,827 | 48 MB |
| `pipeline.admin_jobs` | 24,841 | 1,450 | 46 MB |
| `pipeline.ai_spend_ledger` | 185,852 | 56 | 45 MB |
| `pipeline.provider_field_daily` | 64,297 | 0 | 45 MB |
| `pipeline.firecrawl_run_items` | 36,713 | 4,444 | 45 MB |
| `pipeline.ai_input_observations` | 33,828 | 3 | 42 MB |
| `scholarship.course_financial_calculations` | 33,464 | 0 | 42 MB |
| `catalogue.course_entry_requirements` | 38,021 | 7,054 | 41 MB |
| `pipeline.scholarship_coverage_items` | 27,693 | 5,009 | 40 MB |
| `pipeline.firecrawl_calls` | 52,316 | 0 | 40 MB |
| `pipeline.consumer_api_baselines` | 17,897 | 18 | 35 MB |
| `pipeline.boost_inbound_staging` | 27,417 | 1,613 | 35 MB |
