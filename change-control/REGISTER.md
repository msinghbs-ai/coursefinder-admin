# CourseFinder Change Control Register

**Status:** AUTHORITATIVE INDEX  
**Effective:** 30 August 2026

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
> **M2.4:** CLOSED / PASS — M2.4.0 through M2.4.4 are CLOSED/PASS.
>
> **M2.5:** ACTIVE / READINESS under `CF-CHG-20260901-049`. Platform foundation `CF-CHG-20260901-051` and CF-052 are IMPLEMENTED / TARGETED PASS. CF-053 is IMPLEMENTED / RUNTIME PASS and CF-054 is IMPLEMENTED / SOURCE+ROLLBACK TARGETED PASS, their earlier deployed UI block was caused by Worker v2.15.14 drift; user UAT now proves the Worker reached v2.15.19. Source has advanced to v2.15.21 under CF-061, so deployed currentness must be rechecked rather than treated as a persistent external-control-plane failure. CF-055 Evidence-lineage classification/duplicate prevention is IMPLEMENTED / TARGETED PASS; CF-056 Backup/PITR control-plane reconciliation is RECONCILED / PLATFORM PROOF PARTIAL with the executed restore gate still OPEN; CF-057 universal Layer 4 block enforcement is IMPLEMENTED / TARGETED PASS; CF-058 Platform maturity Administration surface is IMPLEMENTED / SOURCE+BUILD TARGETED PASS with deployed UI blocked by FU-015; CF-059 Evidence-lineage reconciliation/contact claim hardening is IMPLEMENTED / RUNTIME PASS with targeted CI pending. CF-060 Jobs workspace read-path restoration is IMPLEMENTED / SOURCE CI PENDING with deployed UAT pending. Raw Evidence lineage remains visible while the currently known unresolved integrity count is 0 / severity OK. No Production Supabase project exists; provisioning still requires explicit organisation, quoted-cost and region confirmation.
>
> **M2.4.4 FINAL ACCEPTANCE:** accepted Pilot `95f2991e97e76e644bd74f73512b8bf2725fd4b7`; build `33468512538` PASS; deployed acceptance `33468512515` PASS — desktop 75, mobile 76; Security 146 INFO / 0 WARN / 0 ERROR; Performance 172 INFO / 0 WARN / 0 ERROR. M2.4 is CLOSED/PASS.
>
> **A15 CONTACT INTELLIGENCE:** `CF-CHG-20260829-046` remains CLOSED/PASS and frozen. It does not reopen M2.4.
>
> **ZOHO PILOT:** CF-CHG-20260827-045 is ACTIVE / PARTIAL. Zoho Creator bridge lookup/search/filter/provider reads are proven end-to-end. Developer Console's documented 50 External Calls/day limit is now a bounded Pilot constraint; quota-safe Widget v3.1 and one-call `reference_bundle` cache refresh are the active corrective path. No Zoho Production cutover is authorised.
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
| CF-CHG-20260827-045 | 60-zoho-integration | Zoho Creator Pilot Integration & UI/UX | ACTIVE / PARTIAL — CREATOR E2E READ PROVEN; QUOTA/CACHE HARDENING ACTIVE | `60-zoho-integration/CF-CHG-20260827-045-zoho-creator-pilot-integration-ui-ux.md` |
| CF-CHG-20260829-046 | 40-layer2-enrichment | A15 Provider International Contact Intelligence | CLOSED / PASS | `40-layer2-enrichment/CF-CHG-20260829-046-a15-provider-international-contact-intelligence.md` |
| CF-CHG-20260829-047 | 00-governance-programme | M2.4.3 Layer 3 AI Operations Maturity | CLOSED / PASS | `00-governance-programme/CF-CHG-20260829-047-m2-4-3-layer3-ai-operations-maturity.md` |
| CF-CHG-20260830-048 | 00-governance-programme | M2.4.4 Cross-layer Operations, Housekeeping, Scheduling & Pre-blackout Acceptance | CLOSED / PASS | `00-governance-programme/CF-CHG-20260830-048-m2-4-4-cross-layer-checkpoint.md` |
| CF-CHG-20260901-049 | 70-security-platform | M2.5 Clean Production Stack Establishment, Restore & Security Acceptance | ACTIVE / READINESS — PRODUCTION NOT PROVISIONED | `70-security-platform/CF-CHG-20260901-049-m2-5-clean-production-stack-establishment.md` |
| CF-CHG-20260901-050 | 00-governance-programme | Post-M2.4 Platform Maturity Design & Implementation Backlog | APPLIED — DESIGN BASELINE | `00-governance-programme/CF-CHG-20260901-050-platform-maturity-design-backlog.md` |
| CF-CHG-20260901-051 | 70-security-platform | M2.5 Platform Operations Maturity Foundation | IMPLEMENTED / TARGETED PASS — FOLLOW-UPS OPEN | `70-security-platform/CF-CHG-20260901-051-m2-5-platform-operations-maturity-foundation.md` |
| CF-CHG-20260901-052 | 40-layer2-enrichment | M2.5 Layer 2 Run Observability Correction | IMPLEMENTED / TARGETED PASS | `40-layer2-enrichment/CF-CHG-20260901-052-m2-5-layer2-run-observability-correction.md` |
| CF-CHG-20260901-053 | 40-layer2-enrichment | M2.5 Layer 2 Qualification Finalizer Fairness & Historical Wave Classification | IMPLEMENTED / RUNTIME PASS — DEPLOYED BROWSER BLOCKED | `40-layer2-enrichment/CF-CHG-20260901-053-m2-5-layer2-qualification-finalizer-fairness.md` |
| CF-CHG-20260901-054 | 40-layer2-enrichment | M2.5 Layer 3 Source-Pattern Operator Execution & Deterministic Layer 2 Hand-back | IMPLEMENTED / SOURCE+ROLLBACK TARGETED PASS — DEPLOYED UI PENDING | `40-layer2-enrichment/CF-CHG-20260901-054-m2-5-layer3-source-pattern-operator-execution-handback.md` |
| CF-CHG-20260901-055 | 70-security-platform | M2.5 Evidence Lineage Classification & Duplicate Upload Prevention | IMPLEMENTED / TARGETED PASS | `70-security-platform/CF-CHG-20260901-055-m2-5-evidence-lineage-classification-duplicate-upload-prevention.md` |
| CF-CHG-20260901-056 | 70-security-platform | M2.5 Backup / PITR Control-Plane Reconciliation | RECONCILED / PLATFORM PROOF PARTIAL — RESTORE GATE OPEN | `70-security-platform/CF-CHG-20260901-056-m2-5-backup-pitr-control-plane-reconciliation.md` |
| CF-CHG-20260901-057 | 70-security-platform | M2.5 Universal Layer 4 Block Enforcement | IMPLEMENTED / TARGETED PASS | `70-security-platform/CF-CHG-20260901-057-m2-5-universal-layer4-block-enforcement.md` |
| CF-CHG-20260901-058 | 30-admin-pim-ux | M2.5 Platform Maturity Administration Surface | IMPLEMENTED / SOURCE+BUILD TARGETED PASS — DEPLOYED UI BLOCKED BY FU-015 | `30-admin-pim-ux/CF-CHG-20260901-058-m2-5-platform-maturity-administration-surface.md` |
| CF-CHG-20260901-059 | 70-security-platform | M2.5 Evidence Lineage Reconciliation & Provider-Contact Claim Hardening | IMPLEMENTED / RUNTIME PASS — TARGETED CI PENDING | `70-security-platform/CF-CHG-20260901-059-m2-5-evidence-lineage-reconciliation-contact-claim-hardening.md` |
| CF-CHG-20260901-060 | 30-admin-pim-ux | M2.5 Jobs Workspace Read-Path Restoration | IMPLEMENTED / SOURCE CI PENDING — DEPLOYED UAT PENDING | `30-admin-pim-ux/CF-CHG-20260901-060-m2-5-jobs-workspace-read-path-restoration.md` |
| CF-CHG-20260901-061 | 30-admin-pim-ux | QILT / PRISMS Provider & Course Comparison Experience | IMPLEMENTED / TARGETED PASS | `30-admin-pim-ux/CF-CHG-20260901-061-qilt-prisms-provider-course-comparison-experience.md` |
| CF-CHG-20260901-062 | 10-architecture-data-model | Course Skills, Career Pathways & Labour-Market Intelligence | DESIGN ACCEPTED / IMPLEMENTATION PENDING | `10-architecture-data-model/CF-CHG-20260901-062-course-skills-career-labour-market-intelligence.md` |

| CF-CHG-20260902-063 | 10-architecture-data-model | QS / THE World University Ranking Layer 1 Context | SCHEMA / READ FOUNDATION IMPLEMENTED — DATA INGESTION PENDING | `10-architecture-data-model/CF-CHG-20260902-063-qs-the-world-ranking-layer1-context.md` |

| CF-CHG-20260902-064 | 30-admin-pim-ux | Statistics, Rankings, Comparison & Manual Publisher Import UX | IMPLEMENTED / TARGETED UAT ACTIVE | `30-admin-pim-ux/CF-CHG-20260902-064-statistics-rankings-comparison-manual-import-ux.md` |

| CF-CHG-20260902-065 | 30-admin-pim-ux | Layer 1 Authority & Statistical Ingestion Operations v2 | IMPLEMENTED / TARGETED PASS | `30-admin-pim-ux/CF-CHG-20260902-065-layer1-authority-statistical-ingestion-operations-v2.md` |

| CF-CHG-20260902-066 | 50-search-api-consumers | Website / Wix Pilot Search Integration v3 | IMPLEMENTED / DB TARGETED PASS — WIX HTTP E2E PENDING | `50-search-api-consumers/CF-CHG-20260902-066-website-wix-pilot-search-integration-v3.md` |
| CF-CHG-20260902-067 | 20-layer1-regulatory-ingestion | QS / THE Layer 1 Ranking Ingestion Operations | IMPLEMENTED / TARGETED UAT ACTIVE | `20-layer1-regulatory-ingestion/CF-CHG-20260902-067-qs-the-layer1-ranking-ingestion-operations.md` |
| CF-CHG-20260902-069 | 70-security-platform | Course detail contextual helper ACL restoration | CLOSED / PASS | `70-security-platform/CF-CHG-20260902-069-course-detail-contextual-helper-acl-restoration.md` |
| CF-CHG-20260902-070 | 30-admin-pim-ux | Provider Compare Interaction & Theme Correction | IMPLEMENTED / TARGETED UAT PENDING | `30-admin-pim-ux/CF-CHG-20260902-070-provider-compare-interaction-theme-correction.md` |
| CF-CHG-20260902-071 | 30-admin-pim-ux | Layer 1 Operations Admin naming alignment | APPLIED / TARGETED UAT ACTIVE | `30-admin-pim-ux/CF-CHG-20260902-071-layer1-operations-admin-naming-alignment.md` |
| CF-CHG-20260902-072 | 30-admin-pim-ux | Layer 1 source configuration card UI restoration | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260902-072-layer1-source-configuration-card-ui-restoration.md` |
| CF-CHG-20260902-073 | 30-admin-pim-ux | Administration Acquisition route render-crash correction | IMPLEMENTED / TARGETED PASS | `30-admin-pim-ux/CF-CHG-20260902-073-administration-acquisition-route-render-crash-correction.md` |

| CF-CHG-20260902-068 | 20-layer1-regulatory-ingestion | QS Direct XHR / JSON Layer 1 Acquisition Qualification | IMPLEMENTED / TARGETED PASS | `20-layer1-regulatory-ingestion/CF-CHG-20260902-068-qs-direct-xhr-json-layer1-acquisition.md` |

| CF-CHG-20260902-074 | 20-layer1-regulatory-ingestion | Native THE Historical JSON Ranking Ingestion | IMPLEMENTED / SOURCE+RUNTIME PASS / BATCH EVIDENCE PENDING | `20-layer1-regulatory-ingestion/CF-CHG-20260902-074-the-native-json-historical-ranking-ingestion.md` |

| CF-CHG-20260902-075 | 20-layer1-regulatory-ingestion | Compact Multi-Year Ranking Dataset Families | IMPLEMENTED / TARGETED PASS | `20-layer1-regulatory-ingestion/CF-CHG-20260902-075-compact-multi-year-ranking-dataset-families.md` |

| CF-CHG-20260902-077 | 20-layer1-regulatory-ingestion | Statistical Provider Equivalence Fan-out | IMPLEMENTED / TARGETED DATA CONTRACT PASS | `20-layer1-regulatory-ingestion/CF-CHG-20260902-077-statistical-provider-equivalence-fanout.md` |
| CF-CHG-20260902-080 | 30-admin-pim-ux | Provider Contact Database Management | IMPLEMENTED / TARGETED PASS | `30-admin-pim-ux/CF-CHG-20260902-080-provider-contact-database-management.md` |

| CF-CHG-20260902-078 | 70-security-platform | Users & Roles / PIM Operator Restoration | IMPLEMENTED / TARGETED VERIFICATION ACTIVE | `70-security-platform/CF-CHG-20260902-078-users-roles-pim-operator-restoration.md` |
| CF-CHG-20260902-079 | 30-admin-pim-ux | Course Comparison Provider Coverage Correction | IMPLEMENTED / TARGETED UAT ACTIVE | `30-admin-pim-ux/CF-CHG-20260902-079-course-comparison-provider-coverage-correction.md` |

## Current programme baseline

- Master Project Plan: `docs/coursefinder-master-project-plan-v1.81.md`;
- M2→Production Delivery Plan / TSOW: `docs/coursefinder-m2-production-delivery-plan-tsow-v1.4.md`;
- Pilot-to-Production Plan: `docs/coursefinder-pilot-to-production-project-plan-v1.10.md`;
- Running Build: `docs/coursefinder-running-build-v2.81.md`;
- Platform maturity design: `docs/coursefinder-platform-maturity-design-v1.0.md`;
- UAT/performance baseline: `docs/coursefinder-uat-performance-baseline-v1.1.md`;
- Platform maturity implementation backlog: `project-runsheets/milestone-2/m2.5/PLATFORM-MATURITY-IMPLEMENTATION-BACKLOG.md`;
- M2.5 platform operations readiness: `docs/coursefinder-m2-5-platform-operations-readiness-v1.0.md`;
- Current database architecture: `docs/coursefinder-database-architecture-v2.10.49.md` plus closed prior Change Controls;
- Admin/PIM design decisions: `docs/coursefinder-admin-pim-design-decisions-v1.30.md`;
- Admin navigation / information architecture: `docs/coursefinder-admin-navigation-information-architecture-v1.6.md`;
- Data Operations guidance: `docs/coursefinder-m2-4-data-operations-admin-guide-v1.6.md` plus Operations Runbook v1.8 and PIM Admin Guide v1.22;
- M2 execution: `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md` + current execution addenda through A32 (as applicable);
- M2.4 plan: M2.4.0–M2.4.4 CLOSED/PASS; M2.5 ACTIVE/READINESS under `CF-CHG-20260901-049`.

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
- **M2.4.3 accepted Pilot source:** `msinghbs-ai/Coursefinder-Pilot@96de9add3762a0594ebc371fba49d4d990ff4b45`; bounded integration `33285703513` desktop/mobile PASS; replacement final acceptance `33286437795` desktop/mobile governed status PASS.
- **M2.4.4 accepted Pilot source:** `msinghbs-ai/Coursefinder-Pilot@95f2991e97e76e644bd74f73512b8bf2725fd4b7`; build `33468512538` PASS; final acceptance `33468512515` desktop 75 / mobile 76 PASS; Security 146 INFO / 0 WARN / 0 ERROR; Performance 172 INFO / 0 WARN / 0 ERROR.
- **M2.5 foundation Pilot source:** `msinghbs-ai/Coursefinder-Pilot@dac23d68e6df230bc30c306fa7b61e720ecb431c`; targeted deployed UAT `33476711758` / job `99757413769` PASS; post-change Security 146 INFO / 0 WARN / 0 ERROR; Performance 174 INFO / 0 WARN / 0 ERROR. This does not replace the frozen M2.4 acceptance baseline.
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

M2.4.3 and M2.4.4 are CLOSED / PASS. M2.4 is CLOSED / PASS.

Preserve Layer 1/2 authority, Layer 3 Evidence/provenance/A14 telemetry, Layer 4 terminal human resolution, A8/A10/A12/A13/A15 standing behaviour, the RMIT canonical-promotion block and NZ Layer 2 source-qualification deferral. Production cutover, broad Publication and Zoho cutover remain later gates.


### Governance collision note — 2 September 2026
CF-076 is already used by ranking-import UX/UAT. CF-077 is the deployed Statistical Provider Equivalence Fan-out authority. Provider Contacts therefore uses **CF-CHG-20260902-080 / A30** as its final authority. The CF-076 and contact-specific CF-077 files are retained only as void collision evidence.

| CF-CHG-20260902-081 | 40-layer2-enrichment | Consolidated Layer 2 Acquisition, Scholarship Seed & Provider Assets | APPLIED / TARGETED VERIFICATION ACTIVE | `40-layer2-enrichment/CF-CHG-20260902-081-layer2-consolidated-acquisition-scholarship-assets.md` |

| CF-CHG-20260902-082 | 40-layer2-enrichment | Provider Page Fan-out Extraction | IMPLEMENTED / TARGETED PASS — CONTROLLED DATA POPULATION CONTINUES | `40-layer2-enrichment/CF-CHG-20260902-082-provider-page-fanout-extraction.md` |

| CF-CHG-20260903-083 | 40-layer2-enrichment | Scholarship Catalogue→Detail Acquisition & Provider Asset Promotion | IMPLEMENTED / TARGETED PASS — CONTROLLED DATA POPULATION CONTINUES | `40-layer2-enrichment/CF-CHG-20260903-083-scholarship-catalogue-detail-provider-asset-promotion.md` |
