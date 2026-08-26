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
> **M2.3 COMPLETE LAYERS 1–4 GATE:** `CF-CHG-20260825-036`, `-037` and `-038` are **CLOSED / PASS** for accepted Pilot/UAT scope. Final accepted Pilot SHA is `260ed6a0d19b80ad666d74b90aa13e735e802a6a`; build `32917685085` PASS; deployed UAT `32917685022` PASS; desktop `98024710961` PASS; mobile `98024711090` 29/29 PASS.
>
> **M2.3 L3/L4:** Layer 3 is ACTIVE only after benchmark PASS on pinned model `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`; benchmark `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407` passed 5/5 provider semantic cases and 13/13 controls at USD 0 observed cost. Layer 4 all-six-action rollback UAT passed with Search signalling only after accepted canonical change.
>
> **M2.3 NZ L2 DEFERRAL:** NZ authoritative Layer 1 is accepted. Dedicated NZ first-party Layer 2 Course enrichment is **DEFERRED** to future source qualification/onboarding.
>
> **M2.4:** **ACTIVE — M2.4.0 CLEANUP / INTEGRATION REBASE REQUIRED BEFORE M2.4.1.** Go 7 working UI/navigation exists but full permanent UAT exposed stale distributed navigation/floating-launcher test dependencies. Post-Go7 Pilot commits through `c63442ea9ae44382b88f17fd0e01974cf5c6b469` are unaccepted working state until M2.4.0 nominates one accepted SHA. A1–A6 now govern targeted → integration → one full acceptance matrix.
>
> **PRODUCTION:** separate Production establishment/cutover, broad Publication, Zoho cutover and final handover remain later governed gates.

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
| CF-CHG-20260825-036 | 00-governance-programme | M2.3 Production-Grade Data Operations, Scale Enrichment & Decision UX | CLOSED / PASS — NZ L2 EXPANSION DEFERRED | `00-governance-programme/CF-CHG-20260825-036-m2-3-l2-scale-enrichment-ux.md` |
| CF-CHG-20260825-037 | 10-architecture-data-model | Country / Provider / Course Onboarding Framework | CLOSED / PASS | `10-architecture-data-model/CF-CHG-20260825-037-country-provider-course-onboarding-framework.md` |
| CF-CHG-20260825-038 | 00-governance-programme | M2.3 Layer 3/4 Launch, Refresh Intelligence & Important Dates | CLOSED / PASS | `00-governance-programme/CF-CHG-20260825-038-m2-3-layer3-layer4-refresh-intelligence.md` |
| CF-CHG-20260826-039 | 00-governance-programme | Repository run-sheet / cross-chat continuity | APPLIED — GOVERNANCE BASELINE | `00-governance-programme/CF-CHG-20260826-039-repository-run-sheet-cross-chat-continuity.md` |
| CF-CHG-20260826-040 | 30-admin-pim-ux | Streamlined Data Operations Navigation & Visible Guides | ACCEPTANCE REBASE REQUIRED | `30-admin-pim-ux/CF-CHG-20260826-040-data-operations-navigation-guides.md` |
| CF-CHG-20260826-041 | 00-governance-programme | Restore M2.2+ Standing Cross-Chat Instruction Contract | APPLIED — GOVERNANCE BASELINE | `00-governance-programme/CF-CHG-20260826-041-m2-standing-instructions-restoration.md` |
| CF-CHG-20260826-042 | 00-governance-programme | M2 Automated UAT, Navigation & Integration Discipline | APPLIED — GOVERNANCE BASELINE | `00-governance-programme/CF-CHG-20260826-042-m2-automated-uat-integration-discipline.md` |

## Current programme baseline

- Master Project Plan: latest `docs/coursefinder-master-project-plan-*.md` (v1.73 published for active M2.4 working state);
- M2→Production Delivery Plan / TSOW: `docs/coursefinder-m2-production-delivery-plan-tsow-v1.4.md`;
- Pilot-to-Production Plan: `docs/coursefinder-pilot-to-production-project-plan-v1.10.md`;
- Running Build: last accepted M2.3 `docs/coursefinder-running-build-v2.73.md` until M2.4.0 acceptance nominates a new runtime;
- Current database architecture: `docs/coursefinder-database-architecture-v2.10.42.md` plus closed M2.3 Change Controls;
- Admin/PIM design decisions: `docs/coursefinder-admin-pim-design-decisions-v1.14.md` plus current M2.4 Change Controls;
- Admin navigation / information architecture: `docs/coursefinder-admin-navigation-information-architecture-v1.4.md` as M2.4 working design;
- M2 execution: `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md` + `project-runsheets/milestone-2/EXECUTION-ADDENDA-A1-A6.md`;
- M2.4 plan: mandatory M2.4.0 cleanup, then M2.4.1 Layer 1, M2.4.2 Layer 2, M2.4.3 Layer 3, M2.4.4 cross-layer acceptance.

## Accepted runtime/source authority

- Frozen M1 browser/performance baseline: `msinghbs-ai/Coursefinder-Pilot@1bcb96d26f7c701ec6cf91d771016cb6405f51b2`.
- M2.1 accepted Pilot source: `msinghbs-ai/Coursefinder-Pilot@cba0e9ecd2f4878bfd51ad5278e60046b1fae581`; run `32795496640`.
- M2.2 accepted Pilot source: `msinghbs-ai/Coursefinder-Pilot@38ad08bb75ee7cf26a0a701a3ae008d1563b915b`; build `32840377937`; deployed UAT `32840377935`.
- M2.3 accepted Pilot source: `msinghbs-ai/Coursefinder-Pilot@260ed6a0d19b80ad666d74b90aa13e735e802a6a`; build `32917685085`; deployed UAT `32917685022`; desktop `98024710961`; mobile `98024711090` 29/29 PASS.
- M2.3 accepted Layer 3 benchmark: `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407`; pinned model `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`.
- Current M2.4 Pilot main through `c63442ea9ae44382b88f17fd0e01974cf5c6b469` is **working/unaccepted** until M2.4.0 PASS.

## Preserved technical/semantic baseline

- Layer 1 authoritative identity remains source-governed and cannot be overwritten by Layer 2/3/4 shortcuts;
- Layer 2 remains deterministic acquisition/extraction with native Evidence retained;
- Layer 3 consumes governed Evidence and cannot write canonical Course values directly;
- Layer 3 provider/model changes require governed revalidation/benchmark before resume;
- Layer 4 is terminal and uses the existing canonical scalar-resolution authority;
- Search/Publication remain downstream and broad Publication is not authorised;
- QILT/PRISMS context must preserve actual source grain/reporting period;
- Important Dates retain source date precision and must not fabricate times;
- refresh scheduling remains source/profile/entity bounded;
- NZ first-party Layer 2 Course enrichment remains explicitly DEFERRED pending source qualification/onboarding.

## Next gate boundary

Execute M2.4.0 only. Reconcile the current Pilot working state, remove stale/floating permanent-test dependencies, establish shared primary-navigation adapters, run targeted desktop/mobile and bounded integration, then run one complete deployed acceptance matrix on one nominated SHA. M2.4.1 begins only after that PASS.
