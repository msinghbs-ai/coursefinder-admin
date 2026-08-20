# CourseFinder Change Control Register

**Status:** AUTHORITATIVE INDEX  
**Effective:** 20 August 2026

This file indexes material CourseFinder changes. Detailed records live in category folders under `/change-control/`.

> **M1-PIM-FINALISATION runtime gate:** Admin/PIM controls `001`, `005`–`015` are not generically “browser UAT pending”. Their technical/source gates have passed to the extent recorded below, but final closure is **BLOCKED until the deployed authenticated browser is proven against the governed RPC boundary after the 20 August 2026 redeploy trigger**. Do not close them from SQL/source/CI evidence alone.

| Change ID | Category | Title | Origin | Initiated | Status | UI version | Record |
|---|---|---|---|---|---|---|---|
| CF-CHG-20260820-001 | 30-admin-pim-ux | PIM field semantics, fee presentation and Admin Guide | M1-PIM — Admin/PIM UX & Governance → M1-PIM-GOV | 20 Aug 2026 10:30 AEST | TECHNICAL/SEMANTIC PASS through v2.10 candidate — **BLOCKED by deployed authenticated browser/runtime gate** | v2.3.0 semantics retained through v2.10.0 | `30-admin-pim-ux/CF-CHG-20260820-001-pim-field-semantics-fees-admin-guide.md` |
| CF-CHG-20260820-002 | 40-layer2-enrichment | UQ Course Facts coverage expansion | M1-L2-AU-COURSE-FACTS | 20 Aug 2026 10:33 AEST | CLOSED / PASS | N/A | `40-layer2-enrichment/CF-CHG-20260820-002-uq-course-facts-coverage-expansion.md` |
| CF-CHG-20260820-003 | 40-layer2-enrichment | QUT Course Facts acquisition deferred | M1-L2-AU-COURSE-FACTS | 20 Aug 2026 | DEFERRED | N/A | `40-layer2-enrichment/CF-CHG-20260820-003-qut-course-facts-acquisition-deferred.md` |
| CF-CHG-20260820-004 | 40-layer2-enrichment | UQ Course Facts coverage expansion v3 | M1-L2-AU-COURSE-FACTS | 20 Aug 2026 | CLOSED / PASS | N/A | `40-layer2-enrichment/CF-CHG-20260820-004-uq-course-facts-coverage-expansion-v3.md` |
| CF-CHG-20260820-005 | 30-admin-pim-ux | Restore Insights / Enrichment workspaces and governed read boundary | M1-PIM-GOV | 20 Aug 2026 11:05 AEST | DB/RPC/SECURITY + v2.10 SOURCE PASS — **BLOCKED by deployed authenticated browser/runtime gate** | v2.4.0 semantics retained through v2.10.0 | `30-admin-pim-ux/CF-CHG-20260820-005-restore-insights-enrichment-governed-read.md` |
| CF-CHG-20260820-006 | 30-admin-pim-ux | Evidence provenance workspace completeness and semantics | M1-PIM-GOV | 20 Aug 2026 11:28 AEST | DB/SECURITY + bounded Evidence operational path PASS — **BLOCKED by deployed authenticated browser/runtime gate** | v2.5.0 semantics retained through v2.10.0 | `30-admin-pim-ux/CF-CHG-20260820-006-evidence-provenance-workspace.md` |
| CF-CHG-20260820-007 | 30-admin-pim-ux | Catalogue paging and exact identity search | M1-PIM-GOV | 20 Aug 2026 11:37 AEST | DB/RPC/SECURITY/PERFORMANCE + v2.10 SOURCE PASS — **BLOCKED by deployed authenticated browser/runtime gate** | v2.6.0 semantics retained through v2.10.0 | `30-admin-pim-ux/CF-CHG-20260820-007-catalogue-paging-exact-identity-search.md` |
| CF-CHG-20260820-008 | 30-admin-pim-ux | Provider / Course / Campus geography semantics | M1-PIM-GOV | 20 Aug 2026 12:35 AEST | DB/RPC/SECURITY + v2.10 SOURCE PASS — **BLOCKED by deployed authenticated browser/runtime gate** | v2.7.0 semantics retained through v2.10.0 | `30-admin-pim-ux/CF-CHG-20260820-008-provider-course-campus-geography-semantics.md` |
| CF-CHG-20260820-009 | 30-admin-pim-ux | Intake and English requirement semantics | M1-PIM-GOV | 20 Aug 2026 12:35 AEST | DB/RPC/SECURITY + v2.10 SOURCE PASS — **BLOCKED by deployed authenticated browser/runtime gate** | v2.7.0 semantics retained through v2.10.0 | `30-admin-pim-ux/CF-CHG-20260820-009-intake-english-requirement-semantics.md` |
| CF-CHG-20260820-010 | 30-admin-pim-ux | Course taxonomy source lineage | M1-PIM-GOV | 20 Aug 2026 12:35 AEST | DB/RPC/SECURITY + v2.10 SOURCE PASS — **BLOCKED by deployed authenticated browser/runtime gate** | v2.7.0 semantics retained through v2.10.0 | `30-admin-pim-ux/CF-CHG-20260820-010-course-taxonomy-source-lineage.md` |
| CF-CHG-20260820-011 | 30-admin-pim-ux | Scholarship compound eligibility, cycle and scope semantics | M1-PIM-GOV | 20 Aug 2026 13:26 AEST | DB/RPC/SECURITY + v2.10 SOURCE PASS — **BLOCKED by deployed authenticated browser/runtime gate** | v2.8.0 semantics retained through v2.10.0 | `30-admin-pim-ux/CF-CHG-20260820-011-scholarship-compound-semantics.md` |
| CF-CHG-20260820-012 | 30-admin-pim-ux | Course lifecycle, publication, readiness and Search state | M1-PIM-GOV | 20 Aug 2026 13:38 AEST | DB/RPC/SECURITY + v2.10 SOURCE PASS — **BLOCKED by deployed authenticated browser/runtime gate** | v2.9.0 semantics retained through v2.10.0 | `30-admin-pim-ux/CF-CHG-20260820-012-course-lifecycle-publication-readiness-search-state.md` |
| CF-CHG-20260820-013 | 30-admin-pim-ux | Admin operations role boundary and safe Sources projection | M1-PIM-GOV | 20 Aug 2026 | DB/RPC/SECURITY + v2.10 ROLE ALIGNMENT PASS — **BLOCKED by deployed role-browser/runtime gate** | v2.10.0 | `30-admin-pim-ux/CF-CHG-20260820-013-operations-role-boundary.md` |
| CF-CHG-20260820-014 | 30-admin-pim-ux | PIM Attribute Options and Completeness Profile governance | M1-PIM-GOV | 20 Aug 2026 | DB/RPC/SECURITY + v2.10 PRESENTATION PASS — **BLOCKED by deployed authenticated browser/runtime gate** | v2.10.0 | `30-admin-pim-ux/CF-CHG-20260820-014-pim-attribute-option-completeness-governance.md` |
| CF-CHG-20260820-015 | 30-admin-pim-ux | PIM operational UI and browser acceptance finalisation | M1-PIM-FINALISATION | 20 Aug 2026 15:04 AEST | **TECHNICAL UAT + PRODUCTION BUILD PASS — BLOCKED: post-trigger deployed authenticated browser acceptance not proven** | v2.10.0 candidate | `30-admin-pim-ux/CF-CHG-20260820-015-pim-operational-ui-browser-acceptance.md` |

## Runtime gate evidence

- pre-trigger real Chrome traffic still used legacy direct `ui_*` RPCs and produced 403s after the legacy browser ACL was retired;
- governed no-content `coursefinder-admin/main` redeploy trigger: `494a6ddcc18671abd492370410a94212c9c21deb` at 20 August 2026 07:04:28 UTC;
- the latest available browser API event is 07:00:57 UTC, before the trigger;
- therefore post-trigger deployment/browser state is currently **unproven**, not failed and not passed.

## Maintenance rule

Update this index whenever a Change Control record is created, materially reclassified, closed, rejected or superseded. Do not duplicate the full investigation here.
