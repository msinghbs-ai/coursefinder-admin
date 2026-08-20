# CF-CHG-20260820-010 — Course taxonomy source lineage

**Status:** APPLIED / DB-RPC PASS — FRONTEND PRESENTATION PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 12:35 AEST (UTC+10)  
**Origin:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`

## Trigger

Canonical Study Level and Field of Study values were correct, but Course detail exposed only the normalised taxonomy labels. That hid the original source vocabulary/code and evidence required to audit how a regulatory value became a canonical taxonomy value.

## Reference case

Exact CRICOS Course `121174E`:

- CRICOS Course Level source value: `Bachelor Degree`;
- mapping status: `mapped`;
- canonical Study Level: `bachelor` / `Bachelor`;
- source Field code/name: `0201` / `Computer Science`;
- canonical Field: `asced-0201` / `Computer Science`;
- CRICOS source/evidence retained for both mappings.

## Decision

Normalisation does not remove source semantics. Admin must be able to answer:

**source value/code → mapping status → canonical taxonomy → source/evidence**.

Do not infer Study Level from title when CRICOS provides Course Level. Do not treat a marketing category as canonical Field of Study without a governed mapping.

## Applied correction

Pilot migration: `m1_pim_gov_taxonomy_semantics_v1`  
Repository mirror: `supabase/production-migrations/063_m1_pim_gov_taxonomy_semantics.sql`

New private role-checked helper `security.admin_course_taxonomy_summary(uuid)` supplies:

- `study_level_observations[]` with scheme, registration code, exact source value, mapping status, canonical level, validity/snapshot/verification, source and evidence;
- `field_observations[]` with exact source field code/name, canonical field, primary/status, observed time, source and evidence.

`public.admin_read('course_detail',...)` now appends this as `taxonomy_summary`.

No canonical Course/taxonomy row was changed.

## Frontend requirement

A future Course-detail semantic release must show a compact **Taxonomy & source mapping** section rather than only normalised labels. Source vocabulary/evidence should be drill-down information, not clutter the decision grid.

## UAT

Exact `121174E` role-context UAT passed:

- source `Bachelor Degree` retained;
- canonical Bachelor mapping retained;
- `mapping_status=mapped` retained;
- source Field `0201 / Computer Science` retained;
- canonical `asced-0201 / Computer Science` retained;
- regulatory source/evidence retained;
- no canonical mutation.

Detailed UAT: `docs/uat/coursefinder-m1-pim-gov-taxonomy-semantics-uat-2026-08-20.md`.

## Closure

**Final status:** OPEN — DB/RPC PASS / FRONTEND PRESENTATION PENDING  
**Closed at:** N/A
