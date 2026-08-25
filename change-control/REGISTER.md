# CourseFinder Change Control Register

**Status:** AUTHORITATIVE INDEX  
**Effective:** 26 August 2026

This file indexes material CourseFinder changes. Detailed records live in category folders under `/change-control/`.

## Current gate summary

> **M1:** CLOSED / PASS / FROZEN under `CF-CHG-20260823-028`.
>
> **M2.1-L2-PLATFORM:** `CF-CHG-20260823-029` is **CLOSED / PASS**. Final deployed authenticated desktop/mobile UAT passed on Pilot SHA `cba0e9ecd2f4878bfd51ad5278e60046b1fae581`, run `32795496640`.
>
> **M2.2:** `CF-CHG-20260825-032` through `-035` are **CLOSED / PASS** for their accepted Pilot scope. Final accepted M2.2 Pilot SHA remains `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`.
>
> **M2.3 COMPLETE LAYERS 1–4 GATE:** `CF-CHG-20260825-036`, `-037` and `-038` are **APPROVED / IN PROGRESS**. M2.3 is not accepted merely because Layer 3/4/refresh foundations exist. Layer 1/2 production-grade operations, onboarding, complete terminal review UX, Important Date source-precision UX, Course/QILT/PRISMS/Scholarship intelligence, Scholarship Selection, guides and full automated regression remain acceptance dependencies.
>
> **M2.3 L3/L4/REFRESH:** last fully reconciled semantic Pilot runtime is SHA `400e06d26cb7147a14971af578607816b0aca342`; Frontend Build `32854071358` PASS; deployed UAT `32854071828` PASS; desktop `97821647704` PASS; mobile `97821647394` PASS. Exact deployed migration `20260825133749_m2_3_important_dates_source_precision` was restored to source without semantic change in SHA `3858a8f9bf4ccfb7bb5aec89fbc239420718e47e`; build `32894556070` PASS and deployed UAT `32894556145` was still executing at the 26 August reconciliation checkpoint.
>
> **M2.3 L3 PROVIDER:** `openrouter-free-router-v1` remains enabled but PAUSED. The authorised management surface cannot verify `OPENROUTER_API_KEY` presence. Gate remains **BLOCKED — CREDENTIAL REQUIRED / AUTHORISED SERVER SECRET NOT VERIFIED**; no provider/model profile may be unpaused by inference.
>
> **M2.3 ONBOARDING:** `CF-CHG-20260825-037` is **IN PROGRESS — IMPLEMENTATION REQUIRED**. No reusable Onboarding workspace/table/function foundation existed at reconciliation.
>
> **M2.4:** planned optimisation/regression/residual-risk/freeze work only. **DO NOT START** until the M2.3 acceptance boundary is established.
>
> **PRODUCTION:** separate Production establishment/cutover, broad Publication, Zoho cutover and final handover remain later governed gates and are not authorised by current M2.3 work.

| Change ID | Category | Title | Status | Record |
|---|---|---|---|---|
| CF-CHG-20260820-001 | 30-admin-pim-ux | PIM field semantics, fee presentation and Admin Guide | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260820-001-pim-field-semantics-fees-admin-guide.md` |
| CF-CHG-20260820-002 | 40-layer2-enrichment | UQ Course Facts coverage expansion | CLOSED / PASS | `40-layer2-enrichment/CF-CHG-20260820-002-uq-course-facts-coverage-expansion.md` |
| CF-CHG-20260820-003 | 40-layer2-enrichment | QUT Course Facts acquisition deferred | DEFERRED | `40-layer2-enrichment/CF-CHG-20260820-003-qut-course-facts-acquisition-deferred.md` |
| CF-CHG-20260820-004 | 40-layer2-enrichment | UQ Course Facts coverage expansion v3 | CLOSED / PASS | `40-layer2-enrichment/CF-CHG-20260820-004-uq-course-facts-coverage-expansion-v3.md` |
| CF-CHG-20260820-005 | 30-admin-pim-ux | Restore Insights / Enrichment and governed read boundary | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260820-005-restore-insights-enrichment-governed-read.md` |
| CF-CHG-20260820-006 | 30-admin-pim-ux | Evidence provenance workspace completeness/semantics | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260820-006-evidence-provenance-workspace.md` |
| CF-CHG-20260820-007 | 30-admin-pim-ux | Catalogue paging and exact identity search | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260820-007-catalogue-paging-exact-identity-search.md` |
| CF-CHG-20260820-008 | 30-admin-pim-ux | Provider / Course / Campus geography semantics | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260820-008-provider-course-campus-geography-semantics.md` |
| CF-CHG-20260820-009 | 30-admin-pim-ux | Intake and English requirement semantics | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260820-009-intake-english-requirement-semantics.md` |
| CF-CHG-20260820-010 | 30-admin-pim-ux | Course taxonomy source lineage | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260820-010-course-taxonomy-source-lineage.md` |
| CF-CHG-20260820-011 | 30-admin-pim-ux | Scholarship compound eligibility/cycle/scope semantics | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260820-011-scholarship-compound-semantics.md` |
| CF-CHG-20260820-012 | 30-admin-pim-ux | Course lifecycle, publication, readiness and Search state | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260820-012-course-lifecycle-publication-readiness-search-state.md` |
| CF-CHG-20260820-013 | 30-admin-pim-ux | Admin operations role boundary and safe Sources projection | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260820-013-operations-role-boundary.md` |
| CF-CHG-20260820-014 | 30-admin-pim-ux | PIM Attribute Options and Completeness Profile governance | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260820-014-pim-attribute-option-completeness-governance.md` |
| CF-CHG-20260820-015 | 30-admin-pim-ux | PIM operational UI/browser acceptance finalisation | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260820-015-pim-operational-ui-browser-acceptance.md` |
| CF-CHG-20260821-016 | 80-uat-release-operations | M1 Pipeline Operations governance/acceptance | CLOSED / PASS | `80-uat-release-operations/CF-CHG-20260821-016-m1-pipeline-ops-governance-baseline.md` |
| CF-CHG-20260821-017 | 30-admin-pim-ux | M1 Evidence UX operational workspace | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260821-017-m1-evidence-ux-operational-workspace.md` |
| CF-CHG-20260821-018 | 30-admin-pim-ux | M1 Data Quality Readiness operational gate | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260821-018-m1-data-quality-readiness.md` |
| CF-CHG-20260822-019 | 80-uat-release-operations | M1 UAT Harness automated operational acceptance | CLOSED / PASS | `80-uat-release-operations/CF-CHG-20260822-019-m1-uat-harness.md` |
| CF-CHG-20260822-020 | 70-security-platform | Admin user and role management | CLOSED / PASS | `70-security-platform/CF-CHG-20260822-020-admin-user-role-management.md` |
| CF-CHG-20260823-021 | 80-uat-release-operations | Data Quality overview snapshot and concurrent UAT hardening | CLOSED / PASS | `80-uat-release-operations/CF-CHG-20260823-021-data-quality-overview-snapshot.md` |
| CF-CHG-20260823-022 | 70-security-platform | Supabase leaked password protection | CLOSED / PASS | `70-security-platform/CF-CHG-20260823-022-supabase-leaked-password-protection.md` |
| CF-CHG-20260823-023 | 50-search-api-consumers | M1 governed Course-Fact Search admission | CLOSED / PASS | `50-search-api-consumers/CF-CHG-20260823-023-m1-search-enrichment-admission.md` |
| CF-CHG-20260823-024 | 50-search-api-consumers | M1 governed publication and consumer positive-path UAT | CLOSED / PASS | `50-search-api-consumers/CF-CHG-20260823-024-m1-publication-uat.md` |
| CF-CHG-20260823-025 | 80-uat-release-operations | M1 Guides, Operations & Handover Finalisation | CLOSED / PASS | `80-uat-release-operations/CF-CHG-20260823-025-m1-guides-ops-handover.md` |
| CF-CHG-20260823-026 | 80-uat-release-operations | M1 Performance & Responsiveness Gate | CLOSED / PASS | `80-uat-release-operations/CF-CHG-20260823-026-m1-performance-responsiveness.md` |
| CF-CHG-20260823-027 | 70-security-platform | M1 Security, ACL & Release Readiness Gate | CLOSED / PASS | `70-security-platform/CF-CHG-20260823-027-m1-security-release-readiness.md` |
| CF-CHG-20260823-028 | 80-uat-release-operations | M1 Final Acceptance & Baseline Freeze | CLOSED / PASS | `80-uat-release-operations/CF-CHG-20260823-028-m1-final-acceptance-baseline-freeze.md` |
| CF-CHG-20260823-029 | 40-layer2-enrichment | M2.1 Layer 2 enrichment/source/provider/completeness platform | CLOSED / PASS | `40-layer2-enrichment/CF-CHG-20260823-029-m2-1-layer2-platform-foundation.md` |
| CF-CHG-20260823-030 | 30-admin-pim-ux | Data Enrichment navigation replan | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260823-030-data-acquisition-navigation-replan.md` |
| CF-CHG-20260825-031 | 00-governance-programme | M2 consolidated review, Production operating model and security-first milestone governance | APPLIED — GOVERNANCE BASELINE | `00-governance-programme/CF-CHG-20260825-031-m2-review-production-operating-model.md` |
| CF-CHG-20260825-032 | 00-governance-programme | M2.2 Search / Showcase Acceleration | CLOSED / PASS | `00-governance-programme/CF-CHG-20260825-032-m2-2-search-showcase-acceleration.md` |
| CF-CHG-20260825-033 | 50-search-api-consumers | M2.2 Bounded Search / pgvector Showcase | CLOSED / PASS — VECTOR DEFERRED | `50-search-api-consumers/CF-CHG-20260825-033-m2-2-search-pgvector-showcase.md` |
| CF-CHG-20260825-034 | 70-security-platform | M2.2 Security & Production Foundation | CLOSED / PASS — PILOT FOUNDATION | `70-security-platform/CF-CHG-20260825-034-m2-2-security-production-foundation.md` |
| CF-CHG-20260825-035 | 80-uat-release-operations | M2.2 Consolidated Automated UAT & Release Gate | CLOSED / PASS | `80-uat-release-operations/CF-CHG-20260825-035-m2-2-consolidated-uat-release.md` |
| CF-CHG-20260825-036 | 00-governance-programme | M2.3 Production-Grade Data Operations, Scale Enrichment & Decision UX | **APPROVED / IN PROGRESS** | `00-governance-programme/CF-CHG-20260825-036-m2-3-l2-scale-enrichment-ux.md` |
| CF-CHG-20260825-037 | 10-architecture-data-model | Country / Provider / Course Onboarding Framework | **APPROVED / IN PROGRESS — IMPLEMENTATION REQUIRED** | `10-architecture-data-model/CF-CHG-20260825-037-country-provider-course-onboarding-framework.md` |
| CF-CHG-20260825-038 | 00-governance-programme | M2.3 Layer 3/4 Launch, Refresh Intelligence & Important Dates | **APPROVED / IN PROGRESS — PROVIDER BENCHMARK BLOCKED** | `00-governance-programme/CF-CHG-20260825-038-m2-3-layer3-layer4-refresh-intelligence.md` |

## Current programme baseline

- Master Project Plan: `docs/coursefinder-master-project-plan-v1.71.md`;
- M2→Production Delivery Plan / TSOW: `docs/coursefinder-m2-production-delivery-plan-tsow-v1.4.md`;
- Pilot-to-Production Plan: `docs/coursefinder-pilot-to-production-project-plan-v1.10.md`;
- Running Build: `docs/coursefinder-running-build-v2.71.md`;
- Current database architecture: `docs/coursefinder-database-architecture-v2.10.42.md` plus active M2.3 Change Controls;
- Admin/PIM design decisions: `docs/coursefinder-admin-pim-design-decisions-v1.14.md` plus active M2.3 Change Controls;
- Admin navigation / information architecture: `docs/coursefinder-admin-navigation-information-architecture-v1.3.md` plus M2.3 target IA;
- Current User Guide: `docs/coursefinder-user-guide-v2.3.md` pending M2.3 reconciliation;
- Current PIM/Admin operating guide: `docs/coursefinder-pim-admin-guide-v1.17.md` plus applicable M2 addenda;
- Current Operations Runbook: `docs/coursefinder-operations-runbook-v1.3.md` plus applicable M2 addenda;
- Data Flow & Feature Atlas: `docs/coursefinder-data-flow-feature-atlas-v1.1.md`;
- M2.3 governance: `CF-CHG-20260825-036`, `CF-CHG-20260825-037`, `CF-CHG-20260825-038`.

## Accepted runtime/source authority

- Frozen M1 browser/performance baseline: `msinghbs-ai/Coursefinder-Pilot@1bcb96d26f7c701ec6cf91d771016cb6405f51b2`.
- M2.1 accepted Pilot source: `msinghbs-ai/Coursefinder-Pilot@cba0e9ecd2f4878bfd51ad5278e60046b1fae581`; run `32795496640`.
- M2.2 accepted Pilot source: `msinghbs-ai/Coursefinder-Pilot@38ad08bb75ee7cf26a0a701a3ae008d1563b915b`; build `32840377937`; deployed UAT `32840377935`.
- M2.3 last fully reconciled semantic Pilot runtime: `msinghbs-ai/Coursefinder-Pilot@400e06d26cb7147a14971af578607816b0aca342`; build `32854071358`; deployed UAT `32854071828`; desktop `97821647704`; mobile `97821647394`.
- M2.3 exact deployed migration-source synchronisation: `msinghbs-ai/Coursefinder-Pilot@3858a8f9bf4ccfb7bb5aec89fbc239420718e47e`; build `32894556070` PASS; deployed UAT `32894556145` pending at reconciliation time.

## Preserved technical/semantic baseline

- Layer 1 authoritative identity remains source-governed and cannot be overwritten by Layer 2/3/4 shortcuts;
- Layer 2 remains deterministic acquisition/extraction with native Evidence retained;
- Layer 3 consumes governed Evidence and cannot write canonical Course values directly;
- Layer 4 is terminal and uses the existing canonical scalar-resolution authority;
- Search/Publication remain downstream and broad Publication is not authorised;
- QILT/PRISMS context must preserve actual source grain/reporting period;
- Important Dates retain source date precision and must not fabricate times;
- refresh scheduling must remain source/profile/entity bounded;
- M2.3 provider profile remains PAUSED until explicit benchmark PASS;
- M2.4 remains blocked by the M2.3 acceptance boundary.

## Next gate boundary

Continue M2.3 only. Implement and prove the remaining CF-CHG-036/037/038 acceptance criteria, update governance to deployed reality, and establish a complete M2.3 PASS/BLOCKED/DEFERRED classification before any M2.4 optimisation/freeze work begins.