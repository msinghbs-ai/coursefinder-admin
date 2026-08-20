# CourseFinder PIM Admin Guide v1.6

**Status:** LIVING GOVERNANCE GUIDE — ADMIN OPERATIONS ROLE-BOUNDARY UPDATE  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.5.md`  
**Change Control:** `CF-CHG-20260820-001`, `008`, `009`, `010`, `011`, `012`, `013`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`

All unchanged v1.0-v1.5 rules remain in force. v1.6 defines the browser role and payload contract for Review Queue, Pipeline Jobs and Regulatory Sources.

## 1. Browser security boundary

Normal Admin browser reads must use:

`public.admin_read(...)`

Internal/public compatibility `ui_*` projection functions are not alternative browser APIs merely because they exist in PostgreSQL.

A `SECURITY DEFINER` function must never rely on frontend menu visibility as its access control.

## 2. Review Queue

**Minimum role:** Curator / rank 3.

Purpose:

- semantic/data-quality review;
- exception resolution;
- field/entity review workflow.

Rules:

- authentication alone is insufficient;
- an empty current Review Queue does not reduce the required role;
- direct public projection execution should remain closed to normal authenticated browser users;
- review status/priority/reason must not be inferred from absence of rows.

## 3. Pipeline Jobs

**Minimum role:** Pipeline Operator / rank 4.

Purpose:

- ingestion/execution visibility;
- operational status and errors;
- bounded troubleshooting.

Rules:

- job history may contain operational/error context and is not Viewer/Editor data;
- normal browser reads must remain behind the role-aware dispatcher;
- direct execution of legacy `ui_jobs_list` is not authorised for generic authenticated users;
- frontend hiding is not security.

## 4. Regulatory Sources — operational browser view

**Minimum role:** Pipeline Operator / rank 4.

Purpose:

- source health/validation/ingestion status;
- current snapshot/freshness awareness;
- automation/refresh operational decisions.

The normal browser payload may expose:

- source ID/label/type;
- country;
- public source URL;
- official-source flag;
- ingestion enabled;
- validation status/message;
- lifecycle/status;
- current snapshot timestamp;
- refresh cadence;
- priority;
- automation eligibility;
- whether authentication is required;
- expected format.

## 5. Source configuration is not the same as source operations

The following are **not** part of the Pipeline Operator browser Sources payload merely because internal tables/projections contain them:

- source metadata blobs;
- system configuration;
- source configuration IDs;
- adapter implementation/config identifiers;
- secret-bearing or implementation-specific integration configuration.

If a future Platform Admin workspace needs those details, expose them through a separately governed private/admin contract with explicit labels and redaction rules.

Never rely on a React table omitting a JSON property to protect that property. If the browser receives it, it is exposed to that browser identity.

## 6. Governed role contract

| Workspace / operation | Minimum role | Rank | Governing browser operation |
|---|---|---:|---|
| Review Queue | Curator | 3 | `admin_read('reviews')` |
| Pipeline Jobs | Pipeline Operator | 4 | `admin_read('jobs')` |
| Regulatory Sources — operational | Pipeline Operator | 4 | `admin_read('sources')` |
| Full source/integration configuration | Platform Admin/private tooling | 6 / separately governed | not normal Sources payload |

## 7. Public helper functions

Compatibility/internal projection functions such as:

- `ui_review_queue`;
- `ui_jobs_list`;
- `ui_regulatory_sources_list`

may continue to exist for service/internal composition, but normal `authenticated` EXECUTE should remain revoked where the governed browser wrapper owns access.

## 8. Role testing

Role-aware UAT should test both:

- authorised success;
- unauthorised failure.

A synthetic/unassigned authenticated JWT is a useful negative test because it proves that authentication does not accidentally equal authorisation.

Do not create persistent production users solely to manufacture role coverage. If a role has no active assigned account, record deployed browser UAT as pending.

## 9. Reference security incident avoided

Before `CF-CHG-20260820-013`, an authenticated identity with no CourseFinder role could directly read 1,000 Pipeline Job rows through `ui_jobs_list(1000)`, while the governed `admin_read('jobs')` correctly denied the same identity.

This is the reference example for why browser-facing PostgreSQL function grants are part of Admin semantics/governance, not merely infrastructure detail.

## 10. Consumer boundary

Review Queue, Jobs and internal source operations are not part of the normal Zoho/Website consumer contract.

Do not expose these operational surfaces downstream unless a separate operational integration contract is explicitly authorised.
