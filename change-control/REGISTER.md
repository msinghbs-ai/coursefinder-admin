# CourseFinder Change Control Register

**Status:** AUTHORITATIVE INDEX  
**Effective:** 25 August 2026

This file indexes material CourseFinder changes. Detailed records live in category folders under `/change-control/`.

## Current gate summary

> **M1:** CLOSED / PASS / FROZEN under `CF-CHG-20260823-028`.
>
> **M2.1-L2-PLATFORM:** `CF-CHG-20260823-029` is **CLOSED / PASS**. Final deployed authenticated desktop/mobile UAT passed on Pilot SHA `cba0e9ecd2f4878bfd51ad5278e60046b1fae581`, run `32795496640`.
>
> **M2.2 SECURITY / PRODUCTION / SEARCH SHOWCASE:** `CF-CHG-20260825-032` is **CLOSED / PASS** for the implemented Pilot scope. Final Pilot SHA `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`, build run `32840377937`, deployed desktop/mobile UAT run `32840377935` PASS.
>
> **SUPABASE PRO / LEAKED PASSWORD:** `CF-CHG-20260823-022` is **CLOSED / PASS** for Pilot. Organisation Pro entitlement is verified, leaked-password protection is enabled, and the live Security Advisor no longer reports the previous leaked-password WARN. Production must independently repeat the control under its own Auth authority.
>
> **M2.2 SEARCH:** `CF-CHG-20260825-033` is **CLOSED / PASS** for exact lookup + deterministic FTS + structured filters + bounded server-side DTO. pgvector/vector/hybrid remains **DEFERRED / NOT ACCEPTED** until a governed embedding profile/corpus is approved and benchmarked.
>
> **M2.2 SECURITY FOUNDATION:** `CF-CHG-20260825-034` is **CLOSED / PASS — PILOT SECURITY FOUNDATION**. Direct privileged browser RPC exposure is removed, managed Auth hardening is verified, and current browser/server boundaries remain intact.
>
> **M2.2 CONSOLIDATED UAT:** `CF-CHG-20260825-035` is **CLOSED / PASS** for implemented scope with SHA-bound desktop/mobile artifacts.
>
> **PRODUCTION:** clean Production establishment, protected Production deployment, backup/PITR/restore execution, Production security regression, broad Publication, Zoho cutover and final Production handover remain separately governed and are **NOT AUTHORISED** by M2.2 closure.

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
| CF-CHG-20260823-022 | 70-security-platform | Supabase leaked password protection | **CLOSED / PASS** | `70-security-platform/CF-CHG-20260823-022-supabase-leaked-password-protection.md` |
| CF-CHG-20260823-023 | 50-search-api-consumers | M1 governed Course-Fact Search admission | CLOSED / PASS | `50-search-api-consumers/CF-CHG-20260823-023-m1-search-enrichment-admission.md` |
| CF-CHG-20260823-024 | 50-search-api-consumers | M1 governed publication and consumer positive-path UAT | CLOSED / PASS | `50-search-api-consumers/CF-CHG-20260823-024-m1-publication-uat.md` |
| CF-CHG-20260823-025 | 80-uat-release-operations | M1 Guides, Operations & Handover Finalisation | CLOSED / PASS | `80-uat-release-operations/CF-CHG-20260823-025-m1-guides-ops-handover.md` |
| CF-CHG-20260823-026 | 80-uat-release-operations | M1 Performance & Responsiveness Gate | CLOSED / PASS | `80-uat-release-operations/CF-CHG-20260823-026-m1-performance-responsiveness.md` |
| CF-CHG-20260823-027 | 70-security-platform | M1 Security, ACL & Release Readiness Gate | CLOSED / PASS | `70-security-platform/CF-CHG-20260823-027-m1-security-release-readiness.md` |
| CF-CHG-20260823-028 | 80-uat-release-operations | M1 Final Acceptance & Baseline Freeze | CLOSED / PASS | `80-uat-release-operations/CF-CHG-20260823-028-m1-final-acceptance-baseline-freeze.md` |
| CF-CHG-20260823-029 | 40-layer2-enrichment | M2.1 Layer 2 enrichment/source/provider/completeness platform | CLOSED / PASS | `40-layer2-enrichment/CF-CHG-20260823-029-m2-1-layer2-platform-foundation.md` |
| CF-CHG-20260823-030 | 30-admin-pim-ux | Data Enrichment navigation replan | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260823-030-data-acquisition-navigation-replan.md` |
| CF-CHG-20260825-031 | 00-governance-programme | M2 consolidated review, Production operating model and security-first milestone governance | APPLIED — GOVERNANCE BASELINE | `00-governance-programme/CF-CHG-20260825-031-m2-review-production-operating-model.md` |
| CF-CHG-20260825-032 | 00-governance-programme | M2.2 Search / Showcase Acceleration | **CLOSED / PASS** | `00-governance-programme/CF-CHG-20260825-032-m2-2-search-showcase-acceleration.md` |
| CF-CHG-20260825-033 | 50-search-api-consumers | M2.2 Bounded Search / pgvector Showcase | **CLOSED / PASS — VECTOR DEFERRED** | `50-search-api-consumers/CF-CHG-20260825-033-m2-2-search-pgvector-showcase.md` |
| CF-CHG-20260825-034 | 70-security-platform | M2.2 Security & Production Foundation | **CLOSED / PASS — PILOT FOUNDATION** | `70-security-platform/CF-CHG-20260825-034-m2-2-security-production-foundation.md` |
| CF-CHG-20260825-035 | 80-uat-release-operations | M2.2 Consolidated Automated UAT & Release Gate | **CLOSED / PASS** | `80-uat-release-operations/CF-CHG-20260825-035-m2-2-consolidated-uat-release.md` |

## Current programme baseline

- Master Project Plan: `docs/coursefinder-master-project-plan-v1.68.md`;
- M2→Production Delivery Plan / TSOW: `docs/coursefinder-m2-production-delivery-plan-tsow-v1.1.md`;
- Pilot-to-Production Plan: `docs/coursefinder-pilot-to-production-project-plan-v1.10.md`;
- Running Build: `docs/coursefinder-running-build-v2.70.md`;
- M2.2 architecture: `docs/coursefinder-m2-2-security-production-search-showcase-architecture-v1.0.md`;
- Production Build & Operations Guide: `docs/coursefinder-production-environment-build-operations-guide-v1.1.md`;
- Website Developer Search/read contract: `docs/coursefinder-website-developer-search-read-contract-v1.0.md`;
- Milestone Governance Standard: `docs/coursefinder-milestone-governance-standard-v1.0.md`;
- Current M2.1 layer/authority contract: `docs/coursefinder-m2-1-layer1-4-architecture-contract-v1.0.md`;
- Current database architecture: `docs/coursefinder-database-architecture-v2.10.42.md`;
- Frozen M1 architecture baseline: `docs/coursefinder-m1-frozen-architecture-baseline-v1.0.md`;
- Admin/PIM design decisions: `docs/coursefinder-admin-pim-design-decisions-v1.14.md`;
- Admin navigation / information architecture: `docs/coursefinder-admin-navigation-information-architecture-v1.3.md`;
- Current User Guide: `docs/coursefinder-user-guide-v2.3.md`;
- Current PIM/Admin operating guide: `docs/coursefinder-pim-admin-guide-v1.17.md` plus applicable M2 addenda;
- Current Operations Runbook: `docs/coursefinder-operations-runbook-v1.3.md` plus applicable M2 Production addenda;
- Data Flow & Feature Atlas: `docs/coursefinder-data-flow-feature-atlas-v1.1.md`;
- M2.2 technical UAT: `docs/uat/coursefinder-m2-2-security-search-showcase-2026-08-25.md`;
- Friday M2.2 milestone record: `docs/coursefinder-milestone-meeting-2026-08-28-m2-2-showcase.md`.

## Accepted runtime/source authority

- Frozen M1 browser/performance baseline: `msinghbs-ai/Coursefinder-Pilot@1bcb96d26f7c701ec6cf91d771016cb6405f51b2`.
- M2.1 accepted Pilot source: `msinghbs-ai/Coursefinder-Pilot@cba0e9ecd2f4878bfd51ad5278e60046b1fae581`; run `32795496640`.
- M2.2 accepted Pilot source: `msinghbs-ai/Coursefinder-Pilot@38ad08bb75ee7cf26a0a701a3ae008d1563b915b`; build `32840377937`; deployed desktop/mobile UAT `32840377935`.

## Preserved technical/semantic baseline

- AU Search documents: 26,648;
- NZ Search documents: 6,457;
- AU+NZ Search documents: 33,105;
- all-country Courses: 43,461;
- all-country Providers: 3,085;
- Search Projection: `course-v3`, generation 22;
- Search hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`;
- final broad publication state: 0 published entities;
- M2.2 embeddings/jobs/query cache: 0 / 0 / 0;
- Evidence minimum rank 3; pipeline/layer operations minimum rank 4; PIM Configuration rank 5; Access Admin/Settings rank 6;
- Layer 2 does not redefine Layer 1 identity;
- Search/Publication do not become authority layers;
- QILT/PRISMS context preserves actual source grain/reporting period;
- Layer 4 is terminal; there is no Layer 5;
- CourseFinder remains discovery/comparison, not admissions/application/offer/visa processing.

## Next gate boundary

M2.2 closure authorises progression to the next clean Production establishment/release-readiness gate only. It does not authorise in-place Pilot promotion, broad Publication, Production website exposure, Zoho cutover or final Production handover.