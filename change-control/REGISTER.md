# CourseFinder Change Control Register

**Status:** AUTHORITATIVE INDEX  
**Effective:** 29 August 2026

This file indexes material CourseFinder changes. Detailed records live in category folders under `/change-control/`.

## Current gate summary

> **M1:** CLOSED / PASS / FROZEN under `CF-CHG-20260823-028`.
>
> **M2.1-L2-PLATFORM:** `CF-CHG-20260823-029` is CLOSED / PASS.
>
> **M2.2:** `CF-CHG-20260825-032` through `-035` are CLOSED / PASS for accepted Pilot scope.
>
> **M2.3 COMPLETE LAYERS 1–4 GATE:** `CF-CHG-20260825-036`, `-037` and `-038` are CLOSED / PASS for accepted Pilot/UAT scope. NZ first-party Layer 2 Course enrichment remains DEFERRED to future source qualification/onboarding.
>
> **M2.4:** ACTIVE — M2.4.0 CLOSED / PASS; **M2.4.1 CLOSED / PASS; M2.4.2 CLOSED / PASS; M2.4.3 ACTIVE — A15 FIRST-PARTY ROLLOUT COMPLETE / POST-FREEZE ACCEPTANCE.** Stage B passed at Pilot marker `e2eec9b8de0187a5373b506342316ea457b79a0b`, run `33214733610`, desktop/mobile PASS. Historical Stage C `33215640328` remains immutable failed-gate evidence. After explicit governance reopening, corrective Stage C candidate `093010fada8391c93626b59e59c678064f4961c3` passed run `33219089690` with 45/45 desktop and 45/45 mobile. CF-CHG-044 is CLOSED/PASS. RMIT frozen 212-record canonical promotion remains separately BLOCKED; UQ refresh enabled, RMIT disabled, Federation disabled/paused/source-limited. The Layer 3 source-pattern benchmark remains blocked and carries into M2.4.3. A1–A15 / CF-CHG-042 remain standing governance. CF-CHG-20260829-046 is CLOSED / PASS for institute international contact intelligence.
>
> **A15 CONTACT INTELLIGENCE:** CF-CHG-20260829-046 is CLOSED / PASS. Frozen cohort: 60/60 AU/NZ profiles successful, 0 current errors, 31 current first-party contacts across 11 Providers, 17 territory/market contacts, 45 rejected/noisy observations retained; worker v1.3.2 / Edge v15. Final accepted Pilot `f6741a0cc29c5fea236e85b9042f8079762c6993`; acceptance run `33251745111` resolved the acceptance tier with 17 permanent suites and passed 48/48 desktop + 48/48 mobile. Apollo remains configuration-blocked/non-blocking. Broader M2.4.3 Layer 3 maturity remains active.
>
> **ZOHO PILOT:** CF-CHG-20260827-045 is ACTIVE / PARTIAL. Pilot read contract and the first Courses-screen HTTP gateway are deployed; Zoho Creator connection/structural build and bounded end-to-end integration UAT remain open; no Zoho cutover is authorised.
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
| CF-CHG-20260826-040 | 30-admin-pim-ux | Streamlined Data Operations Navigation & Visible Guides | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260826-040-data-operations-navigation-guides.md` |
| CF-CHG-20260826-041 | 00-governance-programme | Restore M2.2+ Standing Cross-Chat Instruction Contract | APPLIED — GOVERNANCE BASELINE | `00-governance-programme/CF-CHG-20260826-041-m2-standing-instructions-restoration.md` |
| CF-CHG-20260826-042 | 00-governance-programme | M2 Automated UAT, Navigation & Integration Discipline | APPLIED — GOVERNANCE BASELINE / VALIDATED BY M2.4.0 AND M2.4.1 | `00-governance-programme/CF-CHG-20260826-042-m2-automated-uat-integration-discipline.md` |
| CF-CHG-20260826-043 | 20-layer1-regulatory-ingestion | M2.4.1 Layer 1 Regulatory Operations Maturity & Automation | CLOSED / PASS | `20-layer1-regulatory-ingestion/CF-CHG-20260826-043-m2-4-1-layer1-operations-maturity.md` |
| CF-CHG-20260827-044 | 40-layer2-enrichment | M2.4.2 Layer 2 Full Enrichment, Operations Maturity & Performance | CLOSED / PASS — CORRECTIVE STAGE C DESKTOP+MOBILE PASS | `40-layer2-enrichment/CF-CHG-20260827-044-m2-4-2-layer2-full-enrichment-operations-maturity.md` |
| CF-CHG-20260827-045 | 60-zoho-integration | Zoho Creator Pilot Integration & UI/UX | ACTIVE / PARTIAL — COURSE HTTP GATEWAY DEPLOYED; ZOHO CONNECTION BLOCKED | `60-zoho-integration/CF-CHG-20260827-045-zoho-creator-pilot-integration-ui-ux.md` |

## Current programme baseline

- Master Project Plan: `docs/coursefinder-master-project-plan-v1.76.md`;
- M2→Production Delivery Plan / TSOW: `docs/coursefinder-m2-production-delivery-plan-tsow-v1.4.md`;
- Pilot-to-Production Plan: `docs/coursefinder-pilot-to-production-project-plan-v1.10.md`;
- Running Build: `docs/coursefinder-running-build-v2.76.md`;
- Current database architecture: `docs/coursefinder-database-architecture-v2.10.43.md` plus closed prior Change Controls;
- Admin/PIM design decisions: `docs/coursefinder-admin-pim-design-decisions-v1.19.md` plus accepted later Change Controls;
- Admin navigation / information architecture: `docs/coursefinder-admin-navigation-information-architecture-v1.4.md`;
- Data Operations guidance: `docs/coursefinder-m2-4-data-operations-admin-guide-v1.4.md` plus Operations Runbook v1.6 and PIM Admin Guide v1.21;
- M2 execution: `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md` + execution addenda A1–A14;
- M2.4 plan: M2.4.0 CLOSED/PASS, M2.4.1 CLOSED/PASS, M2.4.2 CLOSED/PASS, M2.4.3 NEXT/READY, then M2.4.4.

## Accepted runtime/source authority

- Frozen M1 browser/performance baseline: `msinghbs-ai/Coursefinder-Pilot@1bcb96d26f7c701ec6cf91d771016cb6405f51b2`.
- M2.1 accepted Pilot source: `msinghbs-ai/Coursefinder-Pilot@cba0e9ecd2f4878bfd51ad5278e60046b1fae581`.
- M2.2 accepted Pilot source: `msinghbs-ai/Coursefinder-Pilot@38ad08bb75ee7cf26a0a701a3ae008d1563b915b`.
- M2.3 accepted Pilot source: `msinghbs-ai/Coursefinder-Pilot@260ed6a0d19b80ad666d74b90aa13e735e802a6a`.
- M2.4.0 accepted Pilot source: `msinghbs-ai/Coursefinder-Pilot@ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`.
- **M2.4.1 accepted Pilot source:** `msinghbs-ai/Coursefinder-Pilot@ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`; build `32972106272`; Stage C deployed UAT `32972106291` desktop/mobile PASS.
- **M2.4.2 accepted Pilot source:** `msinghbs-ai/Coursefinder-Pilot@093010fada8391c93626b59e59c678064f4961c3`; Stage B `33214733610` desktop/mobile PASS; corrective Stage C `33219089690` 45/45 desktop and 45/45 mobile PASS.
- **M2.4.2 historical Stage C:** candidate `msinghbs-ai/Coursefinder-Pilot@91b115ddf64b020563c7ae6bbd1ea395db866d3f`; acceptance `33215640328` FAIL (45/46 desktop PASS, mobile skipped), retained permanently.
- **M2.4.2 corrective Stage C:** explicit governance reopening authorised one corrective run using corrected UAT; candidate `093010fada8391c93626b59e59c678064f4961c3`; acceptance `33219089690` desktop/mobile PASS.
- **A15 accepted Pilot source:** `msinghbs-ai/Coursefinder-Pilot@f6741a0cc29c5fea236e85b9042f8079762c6993`; final acceptance `33251745111`, 48/48 desktop and 48/48 mobile PASS. Functional contact freeze remains `f9e4e530462b49cf5a83ad8e0d5137631255028a`.

## Preserved technical/semantic baseline

- Layer 1 authoritative identity remains source-governed and cannot be overwritten by Layer 2/3/4 shortcuts;
- Layer 2 remains deterministic acquisition/extraction with native Evidence retained;
- Layer 3 consumes governed Evidence and cannot write canonical Course values directly;
- Layer 4 is terminal and uses the accepted canonical scalar-resolution authority;
- Search/Publication remain downstream and broad Publication is not authorised;
- QILT/PRISMS context preserves actual source grain/reporting period;
- Important Dates retain source date precision and must not fabricate times;
- refresh scheduling remains source/profile/entity bounded;
- AU CRICOS and NZ NZQA Layer 1 validation/variance/scheduling/housekeeping contracts are now accepted foundations;
- NZ first-party Layer 2 Course enrichment remains explicitly DEFERRED pending source qualification/onboarding.

## Next gate boundary

Proceed to M2.4.3 Layer 3 AI Operations Maturity from the accepted M2.4.2 baseline. Preserve Layer 1/2 authority, Evidence, A14 telemetry, the RMIT canonical-promotion block and the source-pattern model-quality threshold. Production cutover, broad Publication and Zoho cutover remain later gates.
| CF-CHG-20260829-046 | 40-layer2-enrichment | Institute International Contact Intelligence | CLOSED / PASS — FINAL ACCEPTANCE DESKTOP+MOBILE PASS | `40-layer2-enrichment/CF-CHG-20260829-046-institute-international-contact-intelligence.md` |
