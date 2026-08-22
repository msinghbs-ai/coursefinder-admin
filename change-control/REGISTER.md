# CourseFinder Change Control Register

**Status:** AUTHORITATIVE INDEX  
**Effective:** 22 August 2026

This file indexes material CourseFinder changes. Detailed records live in category folders under `/change-control/`.

> **M1-PIM-FINALISATION final state:** the shared Admin/PIM browser gate for controls `001`, `005`–`015` is **CLOSED / PASS**. PIM Admin v2.11 semantics remain retained in the accepted v2.12 shell.
>
> **M1-PIPELINE-OPS final state:** `CF-CHG-20260821-016` is **CLOSED / PASS**. Pipeline Ops v1.0 remains accepted with Layer 1 → Layer 4 → Search → Publication operations, safe Source metadata projection, bounded paging/filtering and no generic retry/replay/reset mutation.
>
> **M1-EVIDENCE-UX final state:** `CF-CHG-20260821-017` is **CLOSED / PASS**. Evidence v1.0 remains the accepted private Evidence/provenance workspace.
>
> **M1-DATA-QUALITY-READINESS final state:** `CF-CHG-20260821-018` is **CLOSED / PASS**. The deployed Worker proves Data Quality v1.0, `Legacy presence` relabelling, the AU+NZ domain/state model, regulatory-fee Source-null = 191, all four exception pages, canonical Course navigation and a real `evidence_id` drill-down to the CRICOS Regulatory Snapshot/private Evidence detail workspace. The accepted Pilot baseline is now `72721c57d2a11a5fb79288c9eadf4e14602a2e14`.

| Change ID | Category | Title | Origin | Initiated | Status | UI version | Record |
|---|---|---|---|---|---|---|---|
| CF-CHG-20260820-001 | 30-admin-pim-ux | PIM field semantics, fee presentation and Admin Guide | M1-PIM — Admin/PIM UX & Governance → M1-PIM-GOV | 20 Aug 2026 10:30 AEST | **CLOSED / PASS — deployed v2.11 browser gate complete** | v2.3.0 semantics retained through v2.12.0 | `30-admin-pim-ux/CF-CHG-20260820-001-pim-field-semantics-fees-admin-guide.md` |
| CF-CHG-20260820-002 | 40-layer2-enrichment | UQ Course Facts coverage expansion | M1-L2-AU-COURSE-FACTS | 20 Aug 2026 10:33 AEST | CLOSED / PASS | N/A | `40-layer2-enrichment/CF-CHG-20260820-002-uq-course-facts-coverage-expansion.md` |
| CF-CHG-20260820-003 | 40-layer2-enrichment | QUT Course Facts acquisition deferred | M1-L2-AU-COURSE-FACTS | 20 Aug 2026 | DEFERRED | N/A | `40-layer2-enrichment/CF-CHG-20260820-003-qut-course-facts-acquisition-deferred.md` |
| CF-CHG-20260820-004 | 40-layer2-enrichment | UQ Course Facts coverage expansion v3 | M1-L2-AU-COURSE-FACTS | 20 Aug 2026 | CLOSED / PASS | N/A | `40-layer2-enrichment/CF-CHG-20260820-004-uq-course-facts-coverage-expansion-v3.md` |
| CF-CHG-20260820-005 | 30-admin-pim-ux | Restore Insights / Enrichment workspaces and governed read boundary | M1-PIM-GOV | 20 Aug 2026 11:05 AEST | **CLOSED / PASS — deployed v2.11 browser gate complete** | v2.4.0 semantics retained through v2.12.0 | `30-admin-pim-ux/CF-CHG-20260820-005-restore-insights-enrichment-governed-read.md` |
| CF-CHG-20260820-006 | 30-admin-pim-ux | Evidence provenance workspace completeness and semantics | M1-PIM-GOV | 20 Aug 2026 11:28 AEST | **CLOSED / PASS — retained as Evidence provenance/private-boundary baseline** | v2.5.0 semantics retained through Evidence v1.0 | `30-admin-pim-ux/CF-CHG-20260820-006-evidence-provenance-workspace.md` |
| CF-CHG-20260820-007 | 30-admin-pim-ux | Catalogue paging and exact identity search | M1-PIM-GOV | 20 Aug 2026 11:37 AEST | **CLOSED / PASS — deployed browser gate complete** | v2.6.0 semantics retained through v2.12.0 | `30-admin-pim-ux/CF-CHG-20260820-007-catalogue-paging-exact-identity-search.md` |
| CF-CHG-20260820-008 | 30-admin-pim-ux | Provider / Course / Campus geography semantics | M1-PIM-GOV | 20 Aug 2026 12:35 AEST | **CLOSED / PASS — deployed browser gate complete** | v2.7.0 semantics retained through v2.12.0 | `30-admin-pim-ux/CF-CHG-20260820-008-provider-course-campus-geography-semantics.md` |
| CF-CHG-20260820-009 | 30-admin-pim-ux | Intake and English requirement semantics | M1-PIM-GOV | 20 Aug 2026 12:35 AEST | **CLOSED / PASS — deployed browser gate complete** | v2.7.0 semantics retained through v2.12.0 | `30-admin-pim-ux/CF-CHG-20260820-009-intake-english-requirement-semantics.md` |
| CF-CHG-20260820-010 | 30-admin-pim-ux | Course taxonomy source lineage | M1-PIM-GOV | 20 Aug 2026 12:35 AEST | **CLOSED / PASS — deployed browser gate complete** | v2.7.0 semantics retained through v2.12.0 | `30-admin-pim-ux/CF-CHG-20260820-010-course-taxonomy-source-lineage.md` |
| CF-CHG-20260820-011 | 30-admin-pim-ux | Scholarship compound eligibility, cycle and scope semantics | M1-PIM-GOV | 20 Aug 2026 13:26 AEST | **CLOSED / PASS — deployed browser gate complete** | v2.8.0 semantics retained through v2.12.0 | `30-admin-pim-ux/CF-CHG-20260820-011-scholarship-compound-semantics.md` |
| CF-CHG-20260820-012 | 30-admin-pim-ux | Course lifecycle, publication, readiness and Search state | M1-PIM-GOV | 20 Aug 2026 13:38 AEST | **CLOSED / PASS — deployed browser gate complete** | v2.9.0 semantics retained through v2.12.0 | `30-admin-pim-ux/CF-CHG-20260820-012-course-lifecycle-publication-readiness-search-state.md` |
| CF-CHG-20260820-013 | 30-admin-pim-ux | Admin operations role boundary and safe Sources projection | M1-PIM-GOV | 20 Aug 2026 | **CLOSED / PASS — safe Sources contract enforced by 016 post-closure hardening** | v2.11.0+ | `30-admin-pim-ux/CF-CHG-20260820-013-operations-role-boundary.md` |
| CF-CHG-20260820-014 | 30-admin-pim-ux | PIM Attribute Options and Completeness Profile governance | M1-PIM-GOV | 20 Aug 2026 | **CLOSED / PASS — presentation + deployed browser gate complete** | v2.11.0 semantics retained through v2.12.0 | `30-admin-pim-ux/CF-CHG-20260820-014-pim-attribute-option-completeness-governance.md` |
| CF-CHG-20260820-015 | 30-admin-pim-ux | PIM operational UI and browser acceptance finalisation | M1-PIM-FINALISATION | 20 Aug 2026 15:04 AEST | **CLOSED / PASS — DB/RPC/security/build/deployed browser/visual UAT complete** | v2.11.0 baseline retained in v2.12.0 | `30-admin-pim-ux/CF-CHG-20260820-015-pim-operational-ui-browser-acceptance.md` |
| CF-CHG-20260821-016 | 80-uat-release-operations | M1 Pipeline Operations governance baseline and operational acceptance | M1-PIPELINE-OPS | 21 Aug 2026 09:04 AEST | **CLOSED / PASS — post-closure safe-Sources server hardening complete** | PIM v2.12 + Pipeline Ops v1.0 | `80-uat-release-operations/CF-CHG-20260821-016-m1-pipeline-ops-governance-baseline.md` |
| CF-CHG-20260821-017 | 30-admin-pim-ux | M1 Evidence UX operational Evidence workspace | M1-EVIDENCE-UX | 21 Aug 2026 09:40 AEST | **CLOSED / PASS — implementation, current-volume/security/browser UAT and promotion complete** | PIM v2.12 + Pipeline Ops v1.0 + Evidence v1.0 | `30-admin-pim-ux/CF-CHG-20260821-017-m1-evidence-ux-operational-workspace.md` |
| CF-CHG-20260821-018 | 30-admin-pim-ux | M1 Data Quality Readiness operational gate | M1-DATA-QUALITY-READINESS | 21 Aug 2026 14:47 AEST | **CLOSED / PASS — technical/build/security/performance and deployed end-to-end browser UAT complete** | Data Quality v1.0 on PIM v2.12 + Pipeline Ops v1.0 + Evidence v1.0 | `30-admin-pim-ux/CF-CHG-20260821-018-m1-data-quality-readiness.md` |

## Current programme baseline

- Master Project Plan: `docs/coursefinder-master-project-plan-v1.59.md`;
- Running Build: `docs/coursefinder-running-build-v2.62.md`;
- Architecture: `docs/coursefinder-database-architecture-v2.10.38.md`;
- Admin/PIM design decisions: `docs/coursefinder-admin-pim-design-decisions-v1.12.md`;
- Admin operating guide: `docs/coursefinder-pim-admin-guide-v1.13.md`;
- Pipeline Ops UAT: `docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-v1.1-2026-08-21.md`;
- Evidence UAT: `docs/uat/coursefinder-m1-evidence-ux-technical-acceptance-2026-08-21.md`;
- Data Quality semantic contract: `docs/coursefinder-data-quality-readiness-contract-v1.0.md`;
- Data Quality technical UAT: `docs/uat/coursefinder-m1-data-quality-readiness-technical-acceptance-2026-08-21.md`;
- Data Quality deployed-browser UAT: `docs/uat/coursefinder-m1-data-quality-readiness-browser-evidence-2026-08-21.md`;
- current fully browser-accepted Pilot baseline: `msinghbs-ai/Coursefinder-Pilot@72721c57d2a11a5fb79288c9eadf4e14602a2e14`;
- deployed runtime: PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0 + Data Quality v1.0;
- authenticated Catalogue regression: 26,648 AU Courses / 43,461 all-country Courses;
- Data Quality end-to-end path proven: domain aggregate → 191-record Exception population → all four pages → canonical Course → real CRICOS Regulatory Snapshot Evidence detail;
- browser read boundary: `public.admin_read(text,jsonb)`; Data Quality assigned-role reads use `data_quality_overview` / `data_quality_exceptions`; Evidence requires Curator rank 3; Pipeline Control / Jobs / Sources require Pipeline Operator rank 4;
- final 13:29–13:30 AEST Evidence interaction completed with repeated `admin_read` HTTP 200 calls; earlier 13:24/13:26 statement timeouts are retained as unattributed operational evidence and an input to automated UAT work;
- Data Quality live migrations: `20260821050044`, `20260821050313`, `20260821050457`, `20260821050825`, `20260821050846`;
- Pipeline safe Source metadata projection: `20260821025059 — m1_pipeline_ops_safe_source_projection_v1`;
- Evidence Country-aware Source metadata: `20260821021205 — m1_evidence_ux_country_source_filter_v1`;
- no generic retry/replay/reset mutation is authorised by controls `016`, `017` or `018`.

## Maintenance rule

Update this index whenever a Change Control record is created, materially reclassified, closed, rejected or superseded.