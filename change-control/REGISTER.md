# CourseFinder Change Control Register

**Status:** AUTHORITATIVE INDEX  
**Effective:** 20 August 2026

This file indexes material CourseFinder changes. Detailed records live in category folders under `/change-control/`.

> **M1-PIM-FINALISATION runtime / UX gate:** Admin/PIM controls `001`, `005`–`015` are not generically “browser UAT pending”. Their technical/source/security gates have passed to the extent recorded below. The deployment-source / legacy-RPC incident is now **resolved and proven in the real browser**: post-recovery telemetry uses governed `/rpc/admin_read` with HTTP 200. PIM Admin v2.11 maturity remediation is applied to the actual `Coursefinder-Pilot` deployment source. Final closure remains **BLOCKED only until the Cloudflare-served v2.11 visual/interaction acceptance gate passes**. Do not close these controls from SQL/source/CI evidence alone.

| Change ID | Category | Title | Origin | Initiated | Status | UI version | Record |
|---|---|---|---|---|---|---|---|
| CF-CHG-20260820-001 | 30-admin-pim-ux | PIM field semantics, fee presentation and Admin Guide | M1-PIM — Admin/PIM UX & Governance → M1-PIM-GOV | 20 Aug 2026 10:30 AEST | TECHNICAL/SEMANTIC PASS — **BLOCKED by deployed v2.11 visual/browser acceptance gate** | v2.3.0 semantics retained through v2.11.0 | `30-admin-pim-ux/CF-CHG-20260820-001-pim-field-semantics-fees-admin-guide.md` |
| CF-CHG-20260820-002 | 40-layer2-enrichment | UQ Course Facts coverage expansion | M1-L2-AU-COURSE-FACTS | 20 Aug 2026 10:33 AEST | CLOSED / PASS | N/A | `40-layer2-enrichment/CF-CHG-20260820-002-uq-course-facts-coverage-expansion.md` |
| CF-CHG-20260820-003 | 40-layer2-enrichment | QUT Course Facts acquisition deferred | M1-L2-AU-COURSE-FACTS | 20 Aug 2026 | DEFERRED | N/A | `40-layer2-enrichment/CF-CHG-20260820-003-qut-course-facts-acquisition-deferred.md` |
| CF-CHG-20260820-004 | 40-layer2-enrichment | UQ Course Facts coverage expansion v3 | M1-L2-AU-COURSE-FACTS | 20 Aug 2026 | CLOSED / PASS | N/A | `40-layer2-enrichment/CF-CHG-20260820-004-uq-course-facts-coverage-expansion-v3.md` |
| CF-CHG-20260820-005 | 30-admin-pim-ux | Restore Insights / Enrichment workspaces and governed read boundary | M1-PIM-GOV | 20 Aug 2026 11:05 AEST | DB/RPC/SECURITY + SOURCE PASS — **BLOCKED by deployed v2.11 visual/browser acceptance gate** | v2.4.0 semantics retained through v2.11.0 | `30-admin-pim-ux/CF-CHG-20260820-005-restore-insights-enrichment-governed-read.md` |
| CF-CHG-20260820-006 | 30-admin-pim-ux | Evidence provenance workspace completeness and semantics | M1-PIM-GOV | 20 Aug 2026 11:28 AEST | DB/SECURITY + bounded Evidence operational path PASS — **BLOCKED by deployed v2.11 visual/browser acceptance gate** | v2.5.0 semantics retained through v2.11.0 | `30-admin-pim-ux/CF-CHG-20260820-006-evidence-provenance-workspace.md` |
| CF-CHG-20260820-007 | 30-admin-pim-ux | Catalogue paging and exact identity search | M1-PIM-GOV | 20 Aug 2026 11:37 AEST | DB/RPC/SECURITY/PERFORMANCE PASS — **BLOCKED by deployed v2.11 visual/browser acceptance gate** | v2.6.0 semantics retained through v2.11.0 | `30-admin-pim-ux/CF-CHG-20260820-007-catalogue-paging-exact-identity-search.md` |
| CF-CHG-20260820-008 | 30-admin-pim-ux | Provider / Course / Campus geography semantics | M1-PIM-GOV | 20 Aug 2026 12:35 AEST | DB/RPC/SECURITY PASS — **BLOCKED by deployed v2.11 visual/browser acceptance gate** | v2.7.0 semantics retained through v2.11.0 | `30-admin-pim-ux/CF-CHG-20260820-008-provider-course-campus-geography-semantics.md` |
| CF-CHG-20260820-009 | 30-admin-pim-ux | Intake and English requirement semantics | M1-PIM-GOV | 20 Aug 2026 12:35 AEST | DB/RPC/SECURITY PASS — **BLOCKED by deployed v2.11 visual/browser acceptance gate** | v2.7.0 semantics retained through v2.11.0 | `30-admin-pim-ux/CF-CHG-20260820-009-intake-english-requirement-semantics.md` |
| CF-CHG-20260820-010 | 30-admin-pim-ux | Course taxonomy source lineage | M1-PIM-GOV | 20 Aug 2026 12:35 AEST | DB/RPC/SECURITY PASS — **BLOCKED by deployed v2.11 visual/browser acceptance gate** | v2.7.0 semantics retained through v2.11.0 | `30-admin-pim-ux/CF-CHG-20260820-010-course-taxonomy-source-lineage.md` |
| CF-CHG-20260820-011 | 30-admin-pim-ux | Scholarship compound eligibility, cycle and scope semantics | M1-PIM-GOV | 20 Aug 2026 13:26 AEST | DB/RPC/SECURITY PASS — **BLOCKED by deployed v2.11 visual/browser acceptance gate** | v2.8.0 semantics retained through v2.11.0 | `30-admin-pim-ux/CF-CHG-20260820-011-scholarship-compound-semantics.md` |
| CF-CHG-20260820-012 | 30-admin-pim-ux | Course lifecycle, publication, readiness and Search state | M1-PIM-GOV | 20 Aug 2026 13:38 AEST | DB/RPC/SECURITY PASS — **BLOCKED by deployed v2.11 visual/browser acceptance gate** | v2.9.0 semantics retained through v2.11.0 | `30-admin-pim-ux/CF-CHG-20260820-012-course-lifecycle-publication-readiness-search-state.md` |
| CF-CHG-20260820-013 | 30-admin-pim-ux | Admin operations role boundary and safe Sources projection | M1-PIM-GOV | 20 Aug 2026 | DB/RPC/SECURITY + ROLE ALIGNMENT PASS — **BLOCKED by deployed v2.11 visual/browser acceptance gate** | v2.11.0 | `30-admin-pim-ux/CF-CHG-20260820-013-operations-role-boundary.md` |
| CF-CHG-20260820-014 | 30-admin-pim-ux | PIM Attribute Options and Completeness Profile governance | M1-PIM-GOV | 20 Aug 2026 | DB/RPC/SECURITY + PRESENTATION SOURCE PASS — **BLOCKED by deployed v2.11 visual/browser acceptance gate** | v2.11.0 | `30-admin-pim-ux/CF-CHG-20260820-014-pim-attribute-option-completeness-governance.md` |
| CF-CHG-20260820-015 | 30-admin-pim-ux | PIM operational UI and browser acceptance finalisation | M1-PIM-FINALISATION | 20 Aug 2026 15:04 AEST | **GOVERNED RPC RUNTIME PASS; V2.11 DB/SECURITY/BUILD + UX MATURITY APPLIED at `b3867cc`; BLOCKED pending deployed visual/browser acceptance** | v2.11.0 | `30-admin-pim-ux/CF-CHG-20260820-015-pim-operational-ui-browser-acceptance.md` |

## Runtime / UX gate evidence

- the original deployed v1.7.2 bundle called direct legacy `ui_*` RPCs and returned 403 after legacy SECURITY DEFINER browser execution was retired;
- root cause was deployment-source mismatch: the live Worker is `coursefinder-pilot` from `msinghbs-ai/Coursefinder-Pilot`, not the separate `coursefinder-admin` Worker target;
- governed recovery PR `Coursefinder-Pilot#12` passed build run #84 and `Coursefinder-Pilot/main` was published at `a27c74543456f73be9159ea8b1772188da3330fc` without ACL rollback;
- fresh real-browser telemetry after recovery proved `/rest/v1/rpc/admin_read` HTTP 200 traffic, so the permission/deployment-source incident is **resolved**;
- visual review then identified a separate maturity gap: flat Dashboard, no recent operational activity, empty governed Provider/Course filter option sets and sidebar scroll reachability;
- production migration `20260820121633 — m1_pim_ux_maturity_filters_dashboard_v1` added role-checked `provider_filters`, `course_filters` and enhanced Dashboard operations behind `admin_read` only;
- bounded UAT returned AU State/Region options = 8, AU Course Providers = 1,546, Study Levels = 20 and Fields = 79; exact Provider `00025B` and Course `121174E` remain 1 each;
- measured DB-side: AU Course filter options ~234.6 ms; enhanced Dashboard ~51.2 ms;
- security remains: `admin_read` SECURITY INVOKER / authenticated yes / anon no; public SECURITY DEFINER executable by authenticated = 0; legacy `ui_*` SECURITY DEFINER executable by authenticated = 0;
- PIM Admin v2.11 maturity PR `Coursefinder-Pilot#13` passed `Pilot Frontend Build` run #86 with Node 22.23.2, Vite 6.4.3 and 0 reported vulnerabilities;
- `Coursefinder-Pilot/main` was fast-forwarded without force to `b3867cc89bbfd3f76def01993a70868318016ef0` at approximately 20 August 2026 22:24 AEST;
- final status remains **BLOCKED until a fresh Cloudflare-served authenticated browser shows `PIM Admin v2.11 · governed` and passes Dashboard/filter/navigation/responsive visual acceptance while continuing to use `/rpc/admin_read`**.

## Maintenance rule

Update this index whenever a Change Control record is created, materially reclassified, closed, rejected or superseded. Do not duplicate the full investigation here.
