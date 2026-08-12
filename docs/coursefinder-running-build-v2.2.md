# Coursefinder Running Build v2.2

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.0.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.1.md`

## Current programme position

- Phase 1 Layer 1: AU PASS; NZ PASS; CA ACTIVE; GB/US/IE queued; DE deferred/blocked.
- Phase 2 Admin/PIM UX: production information architecture approved; implementation pending.
- Phase 3A Layer 2A: AU QILT/ComparED structured-outcomes database foundation applied.
- Phase 7 hardening: ongoing.

## Database changes applied

### Migration 044 — QILT provider outcomes foundation

Created:
- `ref.outcome_surveys`
- `ref.outcome_metrics`
- `ref.external_study_areas`
- `ref.external_study_area_mappings`
- `pipeline.source_provider_mappings`
- `catalogue.provider_outcomes`

Seeded survey families only:
- QILT SES
- QILT GOS
- QILT GOS-L
- QILT ESS

No outcome observations or invented metric definitions were inserted.

Identity boundary:
- QILT cannot create or merge regulatory Provider/Course identity from names.
- external institution mappings attach QILT/source identifiers to existing canonical Provider UUIDs.
- study-area mappings crosswalk source-native areas to CourseFinder fields of study.
- observations preserve Provider + survey + metric + study area + study level + audience + collection period + source/evidence.

### Migration 045 — FK index hardening

Added covering indexes identified by Supabase Performance Advisor for the new outcome/mapping foreign keys.

Post-hardening Performance Advisor no longer reports unindexed foreign keys for the new tables. Remaining notices are unused-index INFO, expected before the new workload is populated.

## Security posture

All new tables:
- RLS enabled;
- direct `anon`/`authenticated` table access revoked;
- service-role ingestion explicitly granted;
- no browser CRUD contract added.

Security Advisor reports `rls_enabled_no_policy` INFO for internal deny-by-default tables, consistent with current architecture. Existing authenticated SECURITY DEFINER UI RPC warnings and leaked-password protection warning remain Phase 7 items.

## Admin UX design decision

Navigation target:
- Overview
- Catalogue
- Data Quality
- Data Operations
- PIM
- Insights
- Administration

Operational rules:
- Pipeline executes ingestion/enrichment/projection work.
- Settings/Administration configures Countries, Sources, ETL/Workers, Integrations, Search and Roles.
- Source Mappings manages external Provider and study-area reconciliation.
- Insights owns Outcomes & Comparisons and Rankings.
- Dashboard will combine global statistics with expandable country cards.
- Catalogue will gain country/state/provider/level/field/completeness/source/review filters and governed manual creation.

Design contract:
- `docs/coursefinder-admin-ux-information-architecture-v1.0.md`

## QILT next gate

1. discover latest official QILT structured resources;
2. validate source institution/study-area/metric identifiers;
3. configure QILT source(s) and `qilt-au-etl` worker contract;
4. establish Provider mappings for a bounded AU university pilot set;
5. establish study-area crosswalk;
6. dry-run SES/GOS;
7. bounded APPLY/idempotency/integrity UAT;
8. add curated outcome/comparison RPC/read projection;
9. implement Admin Outcomes UI;
10. only then enable consumer multi-provider comparison.

QILT work may proceed in parallel but does not change the active CA Layer 1 production-gate sequence.
