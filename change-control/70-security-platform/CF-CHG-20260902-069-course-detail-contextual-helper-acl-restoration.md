# CF-CHG-20260902-069 — Course detail contextual helper ACL restoration

- **Initiated:** 2026-09-02T11:16:00+10:00
- **Origin:** CourseFinder — “Fix Courses- Details Blade Bug 2-09-2026 - no Course details showing”
- **Category:** 70-security-platform
- **Change class:** Corrective security/read-path defect
- **Status:** CLOSED / PASS

## Problem

Pilot Courses loaded correctly, but selecting a Course produced no details. The browser displayed:

`permission denied for function admin_contextual_insights_v2`

CF-061 changed `public.admin_read` to append `security.admin_contextual_insights_v2(...)` for Provider/Course details and route `contextual_compare` to `security.admin_contextual_compare(...)`. Both helpers were then explicitly revoked from `authenticated`, while `public.admin_read` remained intentionally `SECURITY INVOKER`. The authenticated browser role therefore could not complete the governed detail read.

## Root cause

- `public.admin_read(text,jsonb)` is the governed browser RPC and is intentionally SECURITY INVOKER.
- Existing `security.admin_contextual_insights(text,uuid)` had authenticated EXECUTE.
- CF-061's new `security.admin_contextual_insights_v2(text,uuid)` and `security.admin_contextual_compare(jsonb)` were granted only to `service_role`.
- An authenticated Course detail call therefore failed at the nested helper invocation before the blade could render.

## Correction

Restore only the function EXECUTE privileges required for the SECURITY INVOKER call chain:

- deny `public` and `anon`;
- grant `authenticated` and `service_role` EXECUTE on:
  - `security.admin_contextual_insights_v2(text,uuid)`;
  - `security.admin_contextual_compare(jsonb)`.

Both helpers remain read-only SECURITY DEFINER functions and retain explicit `auth.uid()` and role-rank enforcement. No Layer 1 identity, Course field semantics, Search, Publication, Evidence, Layer 4 or canonical mutation authority changes.

## Implementation

- Pilot Supabase applied migration version `20260902011913`, runtime name `cf_068_contextual_detail_invoker_acl_fix`.
  - The runtime migration was applied while a parallel workstream was already consuming CF-068; governance therefore records this defect under the next free Change ID, CF-069.
- Repository migration:
  - `Coursefinder-Pilot/supabase/migrations/20260902011913_cf_069_contextual_detail_invoker_acl_fix.sql`
  - commit `7e9fa8fa76d3b333c38f7ed934678eb2fb90793e`.

## UAT / evidence

Runtime rollback-only authenticated-role simulation using an existing rank-6 Pilot operator and a Federation University Australia Course:

- `public.admin_read('course_detail', ...)` returned a Course id;
- response contained `contextual_insights`;
- no permission-denied exception;
- transaction rolled back.

Privilege verification:
- authenticated EXECUTE on `admin_contextual_insights_v2`: restored;
- authenticated EXECUTE on `admin_contextual_compare`: restored;
- anon remains denied.

Post-change Supabase advisors:
- Security: 156 INFO / 0 WARN / 0 ERROR;
- Performance: 185 INFO / 0 WARN / 0 ERROR.

## UI version

No frontend asset or visual layout change was required. Existing deployed UI can consume the corrected backend immediately. Do not overwrite the parallel v2.15.27 release work.

## Rollback

Revoke authenticated EXECUTE on the two CF-061 helpers:

```sql
revoke execute on function security.admin_contextual_insights_v2(text,uuid) from authenticated;
revoke execute on function security.admin_contextual_compare(jsonb) from authenticated;
```

This rollback reintroduces the reported Course/Provider detail and Compare failure and is therefore only for emergency containment.

## Closure

**CLOSED / PASS** — 2026-09-02T11:22:00+10:00. Runtime detail read restored and security/performance advisers remain free of WARN/ERROR findings.
