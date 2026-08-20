# CF-CHG-20260820-012 — Course lifecycle, publication, readiness and Search state

**Status:** APPLIED / DB-RPC-SECURITY + FRONTEND SOURCE PASS — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 13:38 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Course state semantics / Search projection read contract / Admin presentation / operational defect correction

## Trigger

The lifecycle/publication/readiness/Search audit found a live failure in the governed Course catalogue read path:

`security.admin_course_page_search_state(jsonb)` referenced `search.course_documents.status`, but the production Search projection stores `publication_status`.

Authenticated `public.admin_read('courses_page',...)` failed with:

`column d.status does not exist`

The audit also confirmed a broader semantic risk: Course lifecycle, canonical publication, Admin readiness, channel publication and Search projection/admission were not sufficiently separated in Admin presentation.

## Governed state model

CourseFinder treats these as independent state classes:

1. **Canonical lifecycle** — canonical entity operating/existence state.
2. **Canonical publication** — publication state on the canonical entity record.
3. **Admin canonical-presence readiness** — display-only six-signal presence across registration, structure, fee, intake, English and description.
4. **Consumer-channel publication** — channel/locale state in `publishing.entity_states`.
5. **Search projection presence/publication** — derived `search.course_documents` state.
6. **Search enrichment admission** — Search flags for Fee/Intake/English/Scholarship.

Rules:

- active does not mean published;
- canonical unpublished does not mean no Search document exists;
- Search projected does not mean Website/Zoho published or even Search-published;
- Admin readiness does not grant approval/publication;
- canonical enrichment presence does not mean Search enrichment admission;
- no `publishing.entity_states` row means no channel publication state recorded, not an invented status;
- `last_verified_at` remains verification, not approval.

## Migration 066 — live Course-page repair

Pilot migration:

`m1_pim_gov_course_state_semantics_v1`

Repository mirror:

`supabase/production-migrations/066_m1_pim_gov_course_state_semantics.sql`

The corrected wrapper uses `search.course_documents.publication_status` and returns explicitly Search-prefixed fields:

- projected state;
- Search publication/completeness;
- projection version/generation/timestamps;
- Search Fee/Intake/English/Scholarship admission flags.

Exact authenticated Course search works again after this repair.

## Migration 067 — Course-detail state summary

Pilot migration:

`m1_pim_gov_course_state_detail_v1`

Repository mirror:

`supabase/production-migrations/067_m1_pim_gov_course_state_detail.sql`

Private helper:

`security.admin_course_state_summary(uuid)`

The helper exposes:

- canonical lifecycle/publication/verification;
- six-signal Admin readiness with explicit non-publication definition;
- consumer-channel states with empty-list semantics;
- Search projection/admission state;
- global Search projection metadata.

`public.admin_read('course_detail',...)` appends `state_summary` without altering canonical/Search data.

## Migration 068 — explicit canonical Scholarship relationship presence

Final source review caught a false-negative risk before publication: the staged state panel compared Search Scholarship admission to `data.has_scholarship`, but Course detail did not expose that top-level field.

Scholarship relationship presence is also deliberately **outside** the six-signal readiness score.

Pilot migration:

`m1_pim_gov_course_state_scholarship_presence_v1`

Repository mirror:

`supabase/production-migrations/068_m1_pim_gov_course_state_scholarship_presence.sql`

The state summary now exposes:

`canonical_presence.scholarship`

and the frontend consumes that explicit value.

## Reference — CRICOS 121174E

Authenticated governed page/detail state:

- exact Course result: 1;
- lifecycle: active;
- canonical publication: unpublished;
- Admin readiness: 50.00%;
- canonical fee present: true;
- consumer-channel states: 0;
- Search projected: true;
- Search publication: unpublished;
- Search fee admitted: false.

This proves lifecycle, canonical publication, Search presence and Search publication are independent meanings even where textual values happen to match.

## Reference — CRICOS 102784C

Authenticated governed detail state:

- lifecycle: active;
- canonical publication: unpublished;
- Admin readiness: 83.33%;
- canonical registration/structure/fee/intake/English: true/true/true/true/true;
- description: false;
- consumer-channel states: 0;
- Search projected: true;
- Search publication: unpublished;
- Search Fee/Intake/English admitted: false/false/false;
- projection version: `course-v2`;
- generation: 12.

This is the primary bounded proof that canonical Provider-current enrichment may be accepted while Search enrichment remains deliberately unadmitted.

## Positive Scholarship admission-isolation reference

RMIT Course:

- Course Code `006591A`;
- UUID `147a6114-ad07-46ab-af77-b46998856e69`.

Authenticated governed state after migration 068:

- canonical Scholarship relationship: **true**;
- Search Scholarship admitted: **false**.

A negative case (`102784C`) also returns false/false.

This proves the UI comparison does not infer Scholarship presence from a missing frontend field.

## Global Search state at audit

`search.projection_state` for `courses`:

- generation 12;
- row count 33,105;
- projection version `course-v2`;
- enrichment gate `explicit`;
- Fee/Intake/English/Scholarship admitted coverage 0.

This is operational Search metadata, not canonical Course truth.

## Consumer-channel state at audit

`publishing.entity_states` contained zero rows.

Therefore the correct semantic state for the references is:

**No consumer-channel publication state recorded.**

It is not coerced to published, unpublished, rejected, blocked or incomplete.

## Security after-state

`security.admin_course_state_summary(uuid)`:

- remains in non-exposed `security`;
- uses `SECURITY DEFINER` with restricted search path;
- requires authentication and an assigned CourseFinder role;
- denies `anon` EXECUTE;
- permits authenticated/service execution so the invoker `public.admin_read` may dispatch.

Security Advisors were rerun after migrations 066–068. No new public-schema warning was introduced for the state helper. Pre-existing legacy `public.ui_*` SECURITY DEFINER findings, RLS/no-policy informational findings and leaked-password-protection configuration debt remain separate work.

## Frontend release — PIM Admin v2.9.0

### Course grid

- generic `Complete` → **Admin readiness**;
- Lifecycle remains separate;
- **Canonical publication** is visible separately;
- **Search** displays `Projected · <Search publication>` or `Not projected`.

### Course detail

The new **State & publication** panel shows:

- canonical lifecycle/publication;
- Admin readiness and six signals;
- consumer-channel states or explicit absence;
- Search projected/publication state;
- canonical-vs-Search Fee/Intake/English/Scholarship admission comparison;
- Search version/generation/freshness metadata.

Initial branch comparison against v2.8 showed a narrow source delta: `src/CourseStatePanel.jsx` added, `src/main.jsx` 5 additions / 4 deletions, one package version line, plus migrations 066/067. The final correction changes only `CourseStatePanel.jsx` and adds migration 068.

## UAT evidence

Primary UAT:

`docs/uat/coursefinder-m1-pim-gov-state-model-v2.9.0-uat-2026-08-20.md`

Final regression addendum:

`docs/uat/coursefinder-m1-pim-gov-state-model-v2.9.0-final-regression-2026-08-20.md`

Technical/authenticated/source semantic gates pass. Independent fresh Vite bootstrap/build and deployed Cloudflare browser observation remain unavailable from the current execution environment and are not represented as PASS.

## Consumer consequence

A downstream system must not collapse lifecycle, canonical publication, channel publication, Admin readiness and Search operational state into one generic `Status` field.

Search operational state is not the authority for Website/Zoho publication. Admin readiness is diagnostic unless separately admitted.

## Rollback

Rollback the Admin state wrapper/panel independently. Do not alter canonical Course lifecycle/publication, `publishing.entity_states`, canonical enrichment or Search documents merely to roll back a read/presentation change.

## Status history

| Timestamp | Status | Event |
|---|---|---|
| 20 Aug 2026 13:38 AEST | DEFECT FOUND / OPEN | Course page failed on nonexistent Search `status`; state-model ambiguity confirmed |
| 20 Aug 2026 | APPLIED / TECHNICAL PASS | Migration 066 repaired the Course page and explicit Search state |
| 20 Aug 2026 | APPLIED / TECHNICAL PASS | Migration 067 added governed detail state summary |
| 20 Aug 2026 | SOURCE REGRESSION FOUND / REPAIRED | Missing explicit canonical Scholarship presence corrected by migration 068 before publication |
| 20 Aug 2026 | FRONTEND SOURCE PASS | PIM Admin v2.9.0 state grid/panel passed bounded source/authenticated regression |

## Closure

**Final status:** OPEN — DB/RPC/SECURITY + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING  
**Closed at:** N/A  
**Outcome:** The live Course-page blocker is repaired and the complete Course state model is separately governed through DB/RPC and v2.9 source presentation. Closure requires deployed authenticated browser UAT.
