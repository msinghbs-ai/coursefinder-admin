# CourseFinder M1-PIM-GOV Operations Role Boundary UAT

**Date:** 20 August 2026  
**Change Control:** `CF-CHG-20260820-013`  
**Workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Frontend version:** PIM Admin v2.9.0 unchanged  
**Status:** **DB/RPC/SECURITY PASS — DEPLOYED ROLE-BROWSER UAT PENDING**

## Purpose

Prove that Review Queue, Pipeline Jobs and Regulatory Sources are reachable only through the governed role-aware browser boundary and that Pipeline Operators receive a safe operational source payload rather than hidden configuration.

## Pre-remediation findings

The public functions were `SECURITY DEFINER` and executable by `authenticated`:

- `public.ui_review_queue(integer)`;
- `public.ui_jobs_list(integer)`;
- `public.ui_regulatory_sources_list()`.

Review Queue and Jobs checked only authentication internally. Sources used a stricter Platform Admin check, creating a mismatch with the rank-4 Sources workspace.

## Unassigned-identity bypass proof

Synthetic JWT subject:

`11111111-1111-1111-1111-111111111111`

Role: Postgres `authenticated`  
CourseFinder role assignment: none.

Before remediation:

- direct `public.ui_jobs_list(1000)` returned **1,000 rows**;
- direct Review Queue invocation succeeded even though the current queue had zero rows;
- governed `public.admin_read('jobs',...)` rejected the same identity because no CourseFinder role was assigned.

**Verdict:** real browser-role bypass CONFIRMED.

## Migration 069

Pilot migration:

`m1_pim_gov_operations_acl_v1`

Repository mirror:

`supabase/production-migrations/069_m1_pim_gov_operations_acl.sql`

After migration 069:

- direct authenticated Review helper execute = false;
- direct authenticated Jobs helper execute = false;
- direct authenticated Sources helper execute = false;
- private `security.admin_operations_read(text,jsonb)` enforces role before reading;
- `public.admin_read` routes Reviews/Jobs/Sources through the private dispatcher.

## Migration 070

Pilot migration:

`m1_pim_gov_sources_operator_safe_view_v1`

Repository mirror:

`supabase/production-migrations/070_m1_pim_gov_sources_operator_safe_view.sql`

Sources role contract becomes Pipeline Operator+ with a curated operational payload.

## Safe Sources payload UAT

Authenticated Platform Admin read through:

`public.admin_read('sources',...)`

returned operational source rows successfully.

The first returned object contained only curated operational fields and explicitly did **not** contain:

- `source_metadata`;
- `system_config`;
- `source_config_id`;
- `adapter_code`.

The normal browser contract therefore no longer relies on frontend column hiding to protect source configuration.

## Governed Platform Admin regression

Using assigned Platform Admin subject:

`63ba56cb-48d4-4169-98c2-7c4d1f72925b`

The following remain readable through `public.admin_read`:

- Reviews;
- Jobs;
- Sources.

**Verdict:** PASS.

## Role contract

| Operation | Minimum CourseFinder role | Browser path |
|---|---:|---|
| Review Queue | Curator / rank 3 | `public.admin_read('reviews')` |
| Pipeline Jobs | Pipeline Operator / rank 4 | `public.admin_read('jobs')` |
| Sources operational view | Pipeline Operator / rank 4 | `public.admin_read('sources')` |
| Full source/config implementation | Platform Admin/private tooling | not part of normal browser Sources payload |

## Pipeline Operator browser limitation

At the time of UAT there were **no active users assigned exactly Pipeline Operator rank 4**.

The backend contract explicitly enforces rank >= 4, but a real deployed rank-4 browser walkthrough cannot be claimed without an assigned account.

This limitation is kept open rather than creating/persisting a production user solely for UAT.

## Security Advisor state

The new private dispatcher is under `security`, uses a restricted search path and enforces role internally.

Legacy public helpers no longer provide direct authenticated execution.

Pre-existing unrelated Security Advisor/RLS/Auth findings remain separately governed and are not closed by this change.

## Frontend impact

No frontend change required:

- existing Review Queue visibility already begins at rank 3;
- existing Jobs visibility already begins at rank 4;
- existing Sources visibility already begins at rank 4;
- migration 070 aligns the backend payload and security to that existing UX contract.

PIM Admin stays at **v2.9.0**.

## Final verdict

**Direct authenticated Operations bypass:** FIXED / PASS  
**Review role contract:** PASS  
**Jobs role contract:** PASS  
**Safe Sources payload:** PASS  
**Platform Admin regression:** PASS  
**Pipeline Operator deployed browser:** PENDING — no active rank-4 account  
**Canonical/workflow/job/source data mutation:** NONE
