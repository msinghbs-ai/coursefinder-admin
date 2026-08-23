# CourseFinder Change Control Register

**Status:** AUTHORITATIVE INDEX  
**Effective:** 23 August 2026

This file indexes material CourseFinder changes. Detailed records live in category folders under `/change-control/`.

## Current gate summary

> **M1-PIM-FINALISATION:** controls `001`, `005`–`015` are **CLOSED / PASS**. Accepted PIM Admin remains v2.12.
>
> **M1-PIPELINE-OPS:** `CF-CHG-20260821-016` is **CLOSED / PASS**. Pipeline Ops v1.0 remains accepted.
>
> **M1-EVIDENCE-UX:** `CF-CHG-20260821-017` is **CLOSED / PASS**. Evidence v1.0 remains the accepted private Evidence/provenance workspace.
>
> **M1-DATA-QUALITY-READINESS:** `CF-CHG-20260821-018` is **CLOSED / PASS**. Data Quality v1.0 semantics remain accepted.
>
> **M1-UAT-HARNESS:** `CF-CHG-20260822-019` is **CLOSED / PASS**. Final deployed run `32600027592` passed 3/3 tests on both desktop and mobile and publishes SHA-bound commit statuses.
>
> **ACCESS ADMIN:** `CF-CHG-20260822-020` is **CLOSED / PASS**. Access Admin v1.0 is accepted for create/invite, role replacement, non-Platform-Admin expiry, disable/re-enable, audit and lockout protection.
>
> **DATA QUALITY CONCURRENT HARDENING:** `CF-CHG-20260823-021` is **CLOSED / PASS**. Aggregate readiness uses private timestamped snapshots refreshed every 15 minutes; exceptions remain live/paged; mobile Data Quality scrolling is accepted.
>
> **LEAKED PASSWORD PROTECTION:** `CF-CHG-20260823-022` is **DEFERRED FOR PILOT — MANDATORY PRODUCTION GO-LIVE GATE**. Pilot may retain the documented Free-plan warning as a bounded non-production exception. Production must use an eligible Supabase plan, enable leaked-password protection and pass Auth/RBAC UAT before production security sign-off/cutover.
>
> **M1-SEARCH-ENRICHMENT:** `CF-CHG-20260823-023` is **CLOSED / PASS**. The accepted 33,105-document Search projection is deterministic `course-v3`: CRICOS registered tuition remains separate from Provider-current tuition, only UAT-approved RMIT/UQ Course Facts are admitted, and the final native full-refresh APPLY/replay is 0 changed / 33,105 unchanged for both base and enrichment. M1-SEARCH-VECTOR remains rejected/not admitted.
>
> **M1-PUBLICATION-UAT:** `CF-CHG-20260823-024` is **CLOSED / PASS**. Governed publication was proven on an explicit two-Course AU/NZ Pilot allowlist across canonical → readiness → Search → Website/Zoho, including internal/blocked/unpublished states, enrichment invalidation, permission/leakage checks and exact rollback. Broad catalogue publication remains unauthorised and final Pilot state is all unpublished.
>
> **M1-GUIDES-OPS-HANDOVER:** `CF-CHG-20260823-025` is **CLOSED / PASS**. User Guide v2.0, PIM Admin Guide v1.15 and Operations Runbook v1.0 are reconciled to deployed PIM Admin v2.12, live role ranks, `course-v3`, current unpublished Pilot state and the Production leaked-password gate.
>
> **M1-PERFORMANCE-RESPONSIVENESS:** `CF-CHG-20260823-026` is **CLOSED / PASS**. Full-scale deployed Admin/Search performance passed on desktop and mobile; duplicate hidden Pipeline reads were removed and the final accepted deployed performance run is `32622164346` against Pilot `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`.
>
> **M1-SECURITY-RELEASE:** `CF-CHG-20260823-027` is **CLOSED / PASS** for the Pilot release baseline. Browser RPC exposure is reduced to governed `public.admin_read`, diagnostic/UAT/probe Edge surfaces are JWT-protected 410 tombstones, `pilot-reset` is Platform-Admin/JWT hardened, retained custom-auth ingestion workers are service-control-plane scoped and time-bounded, and no unexplained Critical/Error security finding remains. `CF-CHG-20260823-022` remains a mandatory Production gate.
>
> **M1-ACCEPTANCE:** `CF-CHG-20260823-028` is **CLOSED / PASS**. CourseFinder Milestone 1 is complete and frozen for the governed Pilot baseline. Production readiness is not implied; explicit post-M1 and Production gates are preserved.

| Change ID | Category | Title | Initiated | Status | UI / capability | Record |
|---|---|---|---|---|---|---|
| CF-CHG-20260820-001 | 30-admin-pim-ux | PIM field semantics, fee presentation and Admin Guide | 20 Aug 2026 | CLOSED / PASS | PIM semantics retained through v2.12 | `30-admin-pim-ux/CF-CHG-20260820-001-pim-field-semantics-fees-admin-guide.md` |
| CF-CHG-20260820-002 | 40-layer2-enrichment | UQ Course Facts coverage expansion | 20 Aug 2026 | CLOSED / PASS | N/A | `40-layer2-enrichment/CF-CHG-20260820-002-uq-course-facts-coverage-expansion.md` |
| CF-CHG-20260820-003 | 40-layer2-enrichment | QUT Course Facts acquisition deferred | 20 Aug 2026 | DEFERRED | N/A | `40-layer2-enrichment/CF-CHG-20260820-003-qut-course-facts-acquisition-deferred.md` |
| CF-CHG-20260820-004 | 40-layer2-enrichment | UQ Course Facts coverage expansion v3 | 20 Aug 2026 | CLOSED / PASS | N/A | `40-layer2-enrichment/CF-CHG-20260820-004-uq-course-facts-coverage-expansion-v3.md` |
| CF-CHG-20260820-005 | 30-admin-pim-ux | Restore Insights / Enrichment and governed read boundary | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-005-restore-insights-enrichment-governed-read.md` |
| CF-CHG-20260820-006 | 30-admin-pim-ux | Evidence provenance workspace completeness/semantics | 20 Aug 2026 | CLOSED / PASS | Evidence baseline | `30-admin-pim-ux/CF-CHG-20260820-006-evidence-provenance-workspace.md` |
| CF-CHG-20260820-007 | 30-admin-pim-ux | Catalogue paging and exact identity search | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-007-catalogue-paging-exact-identity-search.md` |
| CF-CHG-20260820-008 | 30-admin-pim-ux | Provider / Course / Campus geography semantics | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-008-provider-course-campus-geography-semantics.md` |
| CF-CHG-20260820-009 | 30-admin-pim-ux | Intake and English requirement semantics | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-009-intake-english-requirement-semantics.md` |
| CF-CHG-20260820-010 | 30-admin-pim-ux | Course taxonomy source lineage | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-010-course-taxonomy-source-lineage.md` |
| CF-CHG-20260820-011 | 30-admin-pim-ux | Scholarship compound eligibility/cycle/scope semantics | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-011-scholarship-compound-semantics.md` |
| CF-CHG-20260820-012 | 30-admin-pim-ux | Course lifecycle, publication, readiness and Search state | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-012-course-lifecycle-publication-readiness-search-state.md` |
| CF-CHG-20260820-013 | 30-admin-pim-ux | Admin operations role boundary and safe Sources projection | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-013-operations-role-boundary.md` |
| CF-CHG-20260820-014 | 30-admin-pim-ux | PIM Attribute Options and Completeness Profile governance | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-014-pim-attribute-option-completeness-governance.md` |
| CF-CHG-20260820-015 | 30-admin-pim-ux | PIM operational UI/browser acceptance finalisation | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-015-pim-operational-ui-browser-acceptance.md` |
| CF-CHG-20260821-016 | 80-uat-release-operations | M1 Pipeline Operations governance/acceptance | 21 Aug 2026 | CLOSED / PASS | Pipeline Ops v1.0 | `80-uat-release-operations/CF-CHG-20260821-016-m1-pipeline-ops-governance-baseline.md` |
| CF-CHG-20260821-017 | 30-admin-pim-ux | M1 Evidence UX operational workspace | 21 Aug 2026 | CLOSED / PASS | Evidence v1.0 | `30-admin-pim-ux/CF-CHG-20260821-017-m1-evidence-ux-operational-workspace.md` |
| CF-CHG-20260821-018 | 30-admin-pim-ux | M1 Data Quality Readiness operational gate | 21 Aug 2026 | CLOSED / PASS | Data Quality v1.0 | `30-admin-pim-ux/CF-CHG-20260821-018-m1-data-quality-readiness.md` |
| CF-CHG-20260822-019 | 80-uat-release-operations | M1 UAT Harness automated operational acceptance | 22 Aug 2026 | **CLOSED / PASS** | UAT Harness v1.0 | `80-uat-release-operations/CF-CHG-20260822-019-m1-uat-harness.md` |
| CF-CHG-20260822-020 | 70-security-platform | Admin user and role management | 22 Aug 2026 | **CLOSED / PASS** | Access Admin v1.0 | `70-security-platform/CF-CHG-20260822-020-admin-user-role-management.md` |
| CF-CHG-20260823-021 | 80-uat-release-operations | Data Quality overview snapshot and concurrent UAT hardening | 23 Aug 2026 | **CLOSED / PASS** | Data Quality v1.0 operational hardening | `80-uat-release-operations/CF-CHG-20260823-021-data-quality-overview-snapshot.md` |
| CF-CHG-20260823-022 | 70-security-platform | Supabase leaked password protection | 23 Aug 2026 | **DEFERRED FOR PILOT — PRODUCTION GATE** | Supabase Auth hardening | `70-security-platform/CF-CHG-20260823-022-supabase-leaked-password-protection.md` |
| CF-CHG-20260823-023 | 50-search-api-consumers | M1 governed Course-Fact Search admission | 23 Aug 2026 | **CLOSED / PASS** | Search `course-v3` / Website Search v2 | `50-search-api-consumers/CF-CHG-20260823-023-m1-search-enrichment-admission.md` |
| CF-CHG-20260823-024 | 50-search-api-consumers | M1 governed publication and consumer positive-path UAT | 23 Aug 2026 | **CLOSED / PASS** | Publication Governance v1.0 / Website + Zoho positive path | `50-search-api-consumers/CF-CHG-20260823-024-m1-publication-uat.md` |
| CF-CHG-20260823-025 | 80-uat-release-operations | M1 Guides, Operations & Handover Finalisation | 23 Aug 2026 | **CLOSED / PASS** | User Guide v2.0 / PIM Admin Guide v1.15 / Operations Runbook v1.0 | `80-uat-release-operations/CF-CHG-20260823-025-m1-guides-ops-handover.md` |
| CF-CHG-20260823-026 | 80-uat-release-operations | M1 Performance & Responsiveness Gate | 23 Aug 2026 | **CLOSED / PASS** | Full-scale Admin/Search performance gate | `80-uat-release-operations/CF-CHG-20260823-026-m1-performance-responsiveness.md` |
| CF-CHG-20260823-027 | 70-security-platform | M1 Security, ACL & Release Readiness Gate | 23 Aug 2026 | **CLOSED / PASS** | Security/ACL/Edge release closure | `70-security-platform/CF-CHG-20260823-027-m1-security-release-readiness.md` |
| CF-CHG-20260823-028 | 80-uat-release-operations | M1 Final Acceptance & Baseline Freeze | 23 Aug 2026 | **CLOSED / PASS** | Milestone 1 complete / frozen Pilot baseline | `80-uat-release-operations/CF-CHG-20260823-028-m1-final-acceptance-baseline-freeze.md` |

## Current programme baseline

- Master Project Plan: `docs/coursefinder-master-project-plan-v1.65.md`;
- Pilot-to-Production Plan: `docs/coursefinder-pilot-to-production-project-plan-v1.10.md`;
- Running Build: `docs/coursefinder-running-build-v2.67.md`;
- Architecture: `docs/coursefinder-database-architecture-v2.10.40.md`;
- Frozen M1 architecture baseline: `docs/coursefinder-m1-frozen-architecture-baseline-v1.0.md`;
- Admin/PIM design decisions: `docs/coursefinder-admin-pim-design-decisions-v1.13.md`;
- User Guide: `docs/coursefinder-user-guide-v2.0.md`;
- Admin operating guide: `docs/coursefinder-pim-admin-guide-v1.15.md`;
- Operations Runbook: `docs/coursefinder-operations-runbook-v1.0.md`;
- Data Quality semantic contract: `docs/coursefinder-data-quality-readiness-contract-v1.0.md`;
- Publication governance contract: `docs/coursefinder-publication-governance-contract-v1.0.md`;
- Final M1 acceptance: `docs/uat/coursefinder-m1-final-acceptance-technical-acceptance-2026-08-23.md`;
- Guides/Ops handover acceptance: `docs/uat/coursefinder-m1-guides-ops-handover-technical-acceptance-2026-08-23.md`;
- Publication technical acceptance: `docs/uat/coursefinder-m1-publication-uat-technical-acceptance-2026-08-23.md`;
- Search enrichment technical acceptance: `docs/uat/coursefinder-m1-search-enrichment-admission-technical-acceptance-2026-08-23.md`;
- UAT Harness technical acceptance: `docs/uat/coursefinder-m1-uat-harness-technical-acceptance-2026-08-22.md`;
- Access Admin technical UAT: `docs/uat/coursefinder-access-admin-v1-technical-acceptance-2026-08-22.md`;
- Performance technical acceptance: `docs/uat/coursefinder-m1-performance-responsiveness-technical-acceptance-2026-08-23.md`;
- Security release technical acceptance: `docs/uat/coursefinder-m1-security-release-technical-acceptance-2026-08-23.md`;
- Production leaked-password gate decision: `docs/uat/coursefinder-supabase-leaked-password-protection-production-gate-2026-08-23.md`.

## Accepted runtime/source authority

Deployed browser performance acceptance remains bound to:

`msinghbs-ai/Coursefinder-Pilot@1bcb96d26f7c701ec6cf91d771016cb6405f51b2`

Subsequent security-only Pilot source updates, which do not alter the accepted Admin UI semantics, are:

- `208b42cf0b65beb59d909eac97a6212d46335d53` — retired diagnostic Edge sources;
- `b100340a2dd2187993523215c815b5276d7d000f` — hardened `pilot-reset` source;
- `133b81734e435f9dea5ffb3ddd943e71d2930696` — narrowed automation bridge migration mirror and Pilot main at M1 freeze.

Live Supabase security migrations include:

- `20260823062726_m1_security_release_remove_legacy_provider_rpc`;
- `20260823095439_m1_security_release_edge_allowlist_cleanup`.

Runtime marker remains:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · Access Admin v1.0 · Publication Governance v1.0 · governed`

## Preserved technical/semantic baseline

- AU: 1,546 Providers / 26,648 Courses;
- NZ: 409 Providers / 6,457 Courses;
- AU+NZ: 1,955 Providers / 33,105 Courses;
- all-country Courses: 43,461;
- all-country Providers currently live: 3,085;
- Search projection: 33,105 Course documents (`course-v3`);
- accepted Search base hash: `cd2c8422da31f2fa298053a40563c947780ebdaf09d7b41ff983bc6ef9649d9b`;
- accepted enrichment hash: `fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`;
- accepted combined Search hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`;
- current Search generation: 22; generation is operational, while accepted content hashes remain stable;
- final publication state: 43,461 canonical Courses unpublished / 33,105 Search documents unpublished / 0 consumer channel-state rows;
- publication profile `pilot-course-positive-v1` remains a private bounded Pilot capability and does not authorise broad publication;
- regulatory fee: 26,326 present / 191 source-null / 6,457 not-applicable / 131 zero;
- Provider-current Search tuition: 10 Courses, 9 annual-comparable;
- official URL / Intake / English admitted: 10 / 10 / 10 Courses;
- browser read boundary: `public.admin_read(text,jsonb)`;
- Evidence minimum rank 3; Pipeline minimum rank 4; PIM Configuration rank 5; Access Admin/Settings rank 6;
- Search readiness remains distinct from publication and channel visibility;
- M1-SEARCH-VECTOR remains rejected/not admitted;
- no PIM v2.13 release is claimed;
- Milestone 1 is complete/frozen for the governed Pilot baseline under `CF-CHG-20260823-028`.

## Security release residuals

- Retired diagnostic/UAT/probe Edge slugs may still appear ACTIVE in Supabase because the connected management surface does not expose physical deletion; they are JWT-protected HTTP 410 tombstones with no privileged/data-access logic.
- Retained `verify_jwt=false` ingestion workers are server control-plane functions protected by one-time function-bound nonces or the time-bounded Pilot automation key. The current automation key expires 30 September 2026 and this pattern must be reassessed for Production.
- The Pilot Supabase leaked-password-protection warning remains explicitly governed under `CF-CHG-20260823-022`. It is **not resolved and not transferable to Production**. Production security sign-off/cutover requires the feature to be enabled and UAT-proven.

## Explicit post-M1 boundary

- QUT Course Facts acquisition remains deferred.
- Vector/hybrid Search remains rejected/not admitted unless a new later gate is opened.
- Broad catalogue publication and Production channel cutover remain separately governed.
- Additional country expansion and wider enrichment coverage are post-M1 work.
- INFO-only performance-advisor cleanup is not an M1 blocker unless future measured workloads regress.