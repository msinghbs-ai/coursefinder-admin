# CF-CHG-20260820-010 — Course taxonomy source lineage

**Status:** APPLIED / DB-RPC-SECURITY + FRONTEND SOURCE PASS — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 12:35 AEST (UTC+10)  
**Origin:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`

## Trigger

Canonical Study Level and Field of Study values were correct, but Course detail exposed only normalised taxonomy labels. That hid the original source vocabulary/code and evidence required to audit how a regulatory value became a canonical taxonomy value.

## Reference case — CRICOS 121174E

Study Level:

- source scheme: `cricos`;
- registration code: `121174E`;
- source value: `Bachelor Degree`;
- mapping status: `mapped`;
- canonical Study Level: `bachelor` / `Bachelor`;
- evidence ID: `522c1103-47d2-42d8-af4f-21e93fb1acfc`.

Field of Study:

- source code/name: `0201` / `Computer Science`;
- canonical Field: `asced-0201` / `Computer Science`;
- primary: true;
- evidence ID: `721e46ca-a27f-4df1-b515-71056c71eae7`.

## Decision

Normalisation does not remove source semantics. Admin must be able to answer:

**source value/code → mapping status → canonical taxonomy → source/evidence**.

Do not infer Study Level from title when CRICOS supplies Course Level. Do not treat a marketing category as canonical Field of Study without governed mapping.

## Applied correction

Pilot migration: `m1_pim_gov_taxonomy_semantics_v1`  
Repository mirror: `supabase/production-migrations/063_m1_pim_gov_taxonomy_semantics.sql`

`security.admin_course_taxonomy_summary(uuid)` supplies `taxonomy_summary` through the governed Course-detail response.

No canonical Course, Study Level or Field row was changed.

## Authenticated-call ACL correction

The authenticated v2.7 regression showed the invoker `public.admin_read` could not call the private taxonomy helper while authenticated EXECUTE was revoked.

Pilot repair: `m1_pim_gov_course_detail_helper_acl_fix_v1`  
Repository mirror: `supabase/production-migrations/064_m1_pim_gov_course_detail_helper_acl_fix.sql`

The helper remains in the non-exposed `security` schema, retains its internal CourseFinder-role check and safe search path, denies `anon`, and is callable by `authenticated` only so the governed invoker wrapper can reach it. Legacy public Course-detail direct execution remains revoked.

## Frontend release — PIM Admin v2.7.0

A dedicated **Taxonomy & source mapping** section now presents:

### Study Level

- exact source vocabulary;
- scheme and registration code;
- mapping status;
- canonical code/name;
- source snapshot / observation / verification context;
- source/evidence drill-down.

### Field of Study

- exact source field code/name;
- canonical code/name;
- primary/status context;
- source/evidence drill-down.

Source lineage is kept in Course detail rather than cluttering the decision grid.

## UAT

Technical taxonomy UAT: `docs/uat/coursefinder-m1-pim-gov-taxonomy-semantics-uat-2026-08-20.md`  
Combined v2.7 UAT: `docs/uat/coursefinder-m1-pim-gov-course-detail-v2.7.0-uat-2026-08-20.md`

Authenticated `121174E` Course-detail UAT confirms:

- source `Bachelor Degree`;
- canonical `Bachelor`;
- source Field code `0201`;
- canonical Field code `asced-0201`;
- Campus/fee regressions remain intact through the same governed browser response.

**Technical/frontend source verdict:** PASS.

## Rollback

Frontend rollback restores the previous Course-detail presentation. Backend rollback restores the prior taxonomy helper/wrapper ACL. Do not rewrite canonical taxonomy or Course values.

## Decision / status history

| Timestamp | Status | Event |
|---|---|---|
| 20 Aug 2026 12:35 AEST | OPEN / AUDITED | Missing source-to-canonical taxonomy lineage in Admin identified |
| 20 Aug 2026 | APPLIED / TECHNICAL PASS | Taxonomy summary read contract applied and reference mapping validated |
| 20 Aug 2026 13:01 AEST | DEFECT FOUND / REPAIRED | Authenticated invoker helper ACL corrected by migration 064 |
| 20 Aug 2026 13:01 AEST | FRONTEND SOURCE PASS | PIM Admin v2.7.0 Taxonomy & source mapping presentation passed authenticated regression UAT |

## Closure

**Final status:** OPEN — DB/RPC/SECURITY + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING  
**Closed at:** N/A  
**Outcome:** Original regulatory taxonomy vocabulary remains auditable through governed read and v2.7 source presentation. Closure requires deployed authenticated browser UAT.
