# CF-CHG-20260820-013 — Admin operations role boundary and safe Sources projection

**Status:** APPLIED / DB-RPC-SECURITY PASS — DEPLOYED ROLE-BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** browser ACL hardening / role contract / safe operational source projection

## Trigger

The post-v2.9 governance audit reviewed Review Queue, Pipeline Jobs and Regulatory Sources.

The browser navigation/admin wrapper intended role boundaries were:

- Review Queue — Curator or higher;
- Jobs — Pipeline Operator or higher;
- Sources — Pipeline Operator or higher in the UI.

However, the underlying public `SECURITY DEFINER` helper ACLs did not consistently enforce those boundaries.

## Defects proven

### 1. Review Queue direct browser bypass

`public.ui_review_queue(integer)` was executable by `authenticated` and internally checked only that `auth.uid()` was non-null.

Any authenticated account could invoke the helper directly, bypassing the Curator role gate in `public.admin_read`.

The current Review Queue happened to contain zero rows; zero current rows does not make the ACL safe.

### 2. Pipeline Jobs direct browser bypass

`public.ui_jobs_list(integer)` was executable by `authenticated` and internally checked only authentication.

A synthetic authenticated JWT subject with **no CourseFinder role assignment** successfully read **1,000 Pipeline Job rows** directly before remediation.

The same unassigned identity was correctly rejected by `public.admin_read('jobs',...)` with the assigned-role requirement.

This is the strongest bounded proof of a real role-bypass surface.

### 3. Sources role mismatch / payload overexposure risk

`public.ui_regulatory_sources_list()` had a stricter internal Platform Admin check, while the navigation/admin wrapper treated Sources as Pipeline Operator functionality.

The public helper also returns source/configuration structures such as source metadata/system configuration that the generic frontend merely hides visually. Visual omission is not a security boundary because the browser still receives the payload.

## Governed role contract

### Review Queue

**Curator+ (rank 3)**

Purpose: semantic/data-quality review work.

### Pipeline Jobs

**Pipeline Operator+ (rank 4)**

Purpose: ingestion/job operational visibility.

### Sources — operational view

**Pipeline Operator+ (rank 4)**

Purpose: safe operational source status only.

Allowed browser fields include:

- source ID/label/type/country;
- public source URL;
- official-source flag;
- ingestion enabled;
- validation status/message;
- lifecycle/status;
- current snapshot time;
- refresh cadence;
- priority;
- automation eligibility;
- authentication-required flag;
- expected format.

Excluded from the rank-4 browser payload:

- `source_metadata`;
- `system_config`;
- source configuration IDs;
- adapter/configuration implementation identifiers;
- other hidden integration configuration.

Full source/integration configuration remains outside the normal Pipeline Operator browser contract and may be exposed only through separately governed Platform Admin/private tooling.

## Migration 069 — private operations dispatcher

Pilot migration:

`m1_pim_gov_operations_acl_v1`

Repository mirror:

`supabase/production-migrations/069_m1_pim_gov_operations_acl.sql`

Created:

`security.admin_operations_read(text,jsonb)`

The private helper:

- requires authentication;
- enforces Curator+ for Reviews;
- enforces Pipeline Operator+ for Jobs;
- initially preserved the stricter source role while the source contract was resolved;
- is invoked through `public.admin_read`;
- uses a restricted search path.

Direct browser execution was revoked from:

- `public.ui_review_queue(integer)`;
- `public.ui_jobs_list(integer)`;
- `public.ui_regulatory_sources_list()`.

Those legacy public projections remain service-role callable only.

## Migration 070 — safe Pipeline Operator Sources projection

Pilot migration:

`m1_pim_gov_sources_operator_safe_view_v1`

Repository mirror:

`supabase/production-migrations/070_m1_pim_gov_sources_operator_safe_view.sql`

The private operations dispatcher now provides a curated rank-4 `sources` payload directly from governed source records and does not call the full configuration-bearing public helper.

This resolves the UI/backend role mismatch without widening access to sensitive/implementation configuration.

## Post-remediation ACL state

For role `authenticated`:

- direct `ui_review_queue` EXECUTE: false;
- direct `ui_jobs_list` EXECUTE: false;
- direct `ui_regulatory_sources_list` EXECUTE: false;
- `security.admin_operations_read` is callable for the invoker wrapper but enforces assigned CourseFinder role internally;
- `public.admin_read` remains the browser API boundary.

## Post-remediation functional UAT

Assigned Platform Admin can still read through `public.admin_read`:

- Reviews;
- Jobs;
- Sources.

The safe Sources payload contains operational fields only. UAT confirmed the returned source object does **not** contain:

- `source_metadata`;
- `system_config`;
- `source_config_id`;
- `adapter_code`.

There are currently no active users assigned exactly Pipeline Operator rank 4, so a real rank-4 account browser walkthrough is not fabricated. The helper code enforces rank >= 4 and deployed role-browser UAT remains open.

## Frontend decision

No frontend version bump is required for this change.

PIM Admin remains **v2.9.0** because:

- Review Queue is already visible at Curator+;
- Jobs is already visible at Pipeline Operator+;
- Sources is already visible at Pipeline Operator+;
- migration 070 makes that existing Sources visibility safe and functional at the intended role without changing navigation or presentation.

## UAT evidence

`docs/uat/coursefinder-m1-pim-gov-operations-role-boundary-uat-2026-08-20.md`

## Consumer / Zoho impact

None. Review Queue, Pipeline Jobs and internal source operations are Admin operational surfaces and are not part of the curated Zoho/Website consumer contract.

## Rollback

Rollback should restore only the Admin operations dispatcher/ACL contract if required. Do not expose full source configuration to Pipeline Operators as a rollback shortcut. Do not modify workflow review records, pipeline jobs or source records to roll back a read-security change.

## Status history

| Timestamp | Status | Event |
|---|---|---|
| 20 Aug 2026 | AUDITED / DEFECT FOUND | Review/Jobs public definer bypass and Sources role/payload mismatch confirmed |
| 20 Aug 2026 | APPLIED / SECURITY PASS | Migration 069 closed direct authenticated public helper execution and added role dispatcher |
| 20 Aug 2026 | APPLIED / SECURITY PASS | Migration 070 restored safe Pipeline Operator Sources visibility without configuration leakage |

## Closure

**Final status:** OPEN — DB/RPC/SECURITY PASS / DEPLOYED ROLE-BROWSER UAT PENDING  
**Closed at:** N/A  
**Outcome:** Direct authenticated Operations bypasses are closed and Pipeline Operators receive a curated operational Sources payload rather than full configuration-bearing source records. Final closure requires deployed role-browser verification when an appropriate account is available.
