# CourseFinder Running Build v2.55

**Status:** CURRENT GOVERNED SOURCE BUILD — OPERATIONS ROLE-BROWSER UAT PENDING  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.54.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.51.md`  
**Operations UAT:** `docs/uat/coursefinder-m1-pim-gov-operations-role-boundary-uat-2026-08-20.md`

## Build delta

v2.55 preserves PIM Admin **v2.9.0** and all accepted semantic/source state through v2.54. It adds backend/security governance only for `CF-CHG-20260820-013`: Review Queue, Pipeline Jobs and Regulatory Sources role boundaries.

No frontend version bump is required.

## Security defect repaired

Before remediation, the public `SECURITY DEFINER` helpers for Review Queue and Pipeline Jobs were directly executable by any Postgres `authenticated` identity and checked only authentication internally.

A synthetic authenticated identity with no CourseFinder role assignment successfully read **1,000 Pipeline Job rows** directly through `public.ui_jobs_list(1000)`, while the governed `public.admin_read('jobs',...)` correctly rejected the same identity.

This proved a real browser-role bypass rather than a theoretical ACL concern.

## Migration 069 — governed Operations dispatcher

Pilot migration:

`m1_pim_gov_operations_acl_v1`

Repository mirror:

`supabase/production-migrations/069_m1_pim_gov_operations_acl.sql`

The migration:

- creates role-checked `security.admin_operations_read(text,jsonb)`;
- routes Reviews/Jobs/Sources through `public.admin_read`;
- enforces Curator+ for Review Queue;
- enforces Pipeline Operator+ for Pipeline Jobs;
- revokes direct `authenticated` execution from the legacy public Review/Jobs/Sources projections;
- retains service-role access for internal composition.

## Migration 070 — safe Pipeline Operator Sources payload

Pilot migration:

`m1_pim_gov_sources_operator_safe_view_v1`

Repository mirror:

`supabase/production-migrations/070_m1_pim_gov_sources_operator_safe_view.sql`

The existing rank-4 Sources workspace remains available to Pipeline Operators, but the browser now receives only curated operational source fields.

Explicitly excluded from the normal browser payload:

- `source_metadata`;
- `system_config`;
- source configuration IDs;
- adapter/configuration identifiers.

Frontend column hiding is no longer relied upon as a security boundary.

## Governed role contract

| Workspace | Minimum role | Rank |
|---|---|---:|
| Review Queue | Curator | 3 |
| Pipeline Jobs | Pipeline Operator | 4 |
| Regulatory Sources — operational view | Pipeline Operator | 4 |
| Full source/integration configuration | Platform Admin/private tooling | 6 / separately governed |

## Post-remediation UAT

Direct `authenticated` EXECUTE is false for:

- `public.ui_review_queue(integer)`;
- `public.ui_jobs_list(integer)`;
- `public.ui_regulatory_sources_list()`.

Assigned Platform Admin remains able to read Reviews, Jobs and Sources through `public.admin_read`.

The curated Sources payload retains operational status while excluding hidden configuration fields.

There are currently no active users assigned exactly Pipeline Operator rank 4, so a real deployed rank-4 browser walkthrough is not claimed. The backend enforces rank >= 4 and that role-browser UAT remains pending.

## Admin Guide

PIM Admin Guide advances to **v1.6** with explicit browser role/payload semantics for Review Queue, Jobs and Sources.

Zoho Consumer Contract does not change because these are internal Admin/operations surfaces, not normal consumer fields.

## Preserved programme baselines

- PIM Admin source version: v2.9.0;
- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- AU Course Facts: RMIT + UQ qualified / 10 bounded Courses;
- Search Course Documents: 33,105;
- Fee/Intake/English/Scholarship Search enrichment admission remains 0;
- vector Search remains not admitted;
- architecture remains v2.10.37.

## Change Control

`CF-CHG-20260820-013` — DB/RPC/SECURITY PASS / deployed role-browser UAT pending.

Earlier open PIM semantic records remain unchanged and retain their deployed-browser acceptance gates.

## Next work

1. publish migrations 069–070 and governance records by non-force history-preserving integration;
2. complete Pipeline Operator deployed role-browser UAT when an appropriate assigned account exists;
3. continue the semantic/security audit into PIM Attributes/options/completeness-profile surfaces;
4. retain separation between internal Admin operations and curated consumer contracts.
