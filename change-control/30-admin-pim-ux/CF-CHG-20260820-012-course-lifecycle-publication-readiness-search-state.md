# CF-CHG-20260820-012 — Course lifecycle, publication, readiness and Search state

**Status:** APPLIED / DB-RPC-SECURITY + FRONTEND SOURCE PASS — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 13:38 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Course state semantics / Search projection read contract / Admin presentation / operational defect correction

## Trigger

The planned lifecycle/publication/readiness/Search audit found a live defect in the governed Course catalogue read path:

`security.admin_course_page_search_state(jsonb)` referenced `search.course_documents.status`, but the production Search projection stores `publication_status`.

Authenticated `public.admin_read('courses_page',...)` therefore failed with:

`column d.status does not exist`

The failure also exposed a broader semantic risk: Course lifecycle, canonical publication, Admin canonical-presence readiness, per-channel publication and Search projection/admission were not presented as clearly separate states.

## Semantic decision

CourseFinder treats the following as independent concepts:

1. **Canonical lifecycle** — whether the canonical Course is active/inactive/suspended/etc.
2. **Canonical publication** — the canonical entity's publication state; it does not itself prove publication to a specific consumer channel.
3. **Admin canonical-presence readiness** — display-only six-signal operational presence across registration, structure, fee, intake, English and description.
4. **Consumer-channel publication state** — rows in `publishing.entity_states`, scoped by channel/locale.
5. **Search projection presence/state** — whether a derived Search Course Document exists and its own `publication_status`.
6. **Search enrichment admission** — Search-document flags such as `has_fee`, `has_intake`, `has_english` and `has_scholarship`.

Rules:

- `active` does not mean published;
- canonical `unpublished` does not mean a Search document cannot exist;
- `search_projected=true` does not mean published to Website/Zoho or even published within Search;
- Admin readiness does not grant publication;
- canonical enrichment presence does not mean Search enrichment was admitted;
- no `publishing.entity_states` row means **no channel publication state recorded**, not published, rejected or incomplete;
- `last_verified_at` remains verification, not approval.

## Defect correction — Course page Search state

Pilot migration:

`m1_pim_gov_course_state_semantics_v1`

Repository mirror:

`supabase/production-migrations/066_m1_pim_gov_course_state_semantics.sql`

The corrected wrapper uses `search.course_documents.publication_status` and emits explicitly Search-prefixed operational fields:

- `search_projected`;
- `search_projection_status`;
- `search_projection_completeness`;
- `search_projection_version`;
- `search_catalogue_generation`;
- `search_projection_updated_at`;
- `search_projection_generated_at`;
- `search_has_fee`;
- `search_has_intake`;
- `search_has_english`;
- `search_has_scholarship`.

This prevents Search state from being mistaken for canonical state by naming it at the boundary.

## Governed Course-detail state summary

Pilot migration:

`m1_pim_gov_course_state_detail_v1`

Repository mirror:

`supabase/production-migrations/067_m1_pim_gov_course_state_detail.sql`

Private helper:

`security.admin_course_state_summary(uuid)`

It returns:

### `canonical`

- lifecycle status;
- canonical publication status;
- last verified timestamp.

### `admin_readiness`

- current six-signal score;
- registration/structure/fee/intake/English/description signals;
- explicit definition: `display-only six-signal canonical presence readiness; not truth, approval, freshness or publication`.

### `consumer_channels`

Rows from `publishing.entity_states` with channel/locale/publication/completeness/check timestamps. An empty list is retained as an explicit absence of channel state.

### `search`

- projected/not projected;
- Search publication status;
- Search completeness;
- projection version;
- catalogue generation;
- projection/generated/source-update timestamps;
- Search admission flags for fee/intake/English/scholarship;
- global Search projection metadata from `search.projection_state`.

`public.admin_read('course_detail',...)` appends this `state_summary` while retaining Fee, Campus, Entry and Taxonomy semantic summaries.

## Reference A — CRICOS 121174E

Authenticated governed page/detail UAT shows simultaneously:

- canonical lifecycle: `active`;
- canonical publication: `unpublished`;
- Admin readiness: **50.00%**;
- canonical fee presence: true;
- canonical Intake presence: false;
- canonical English presence: false;
- consumer channel states: **0**;
- Search document exists: true;
- Search publication: `unpublished`;
- Search fee admitted: false.

The exact Course remains discoverable by CRICOS code after the live wrapper defect was repaired.

## Reference B — CRICOS 102784C

Authenticated governed detail UAT shows simultaneously:

- canonical lifecycle: `active`;
- canonical publication: `unpublished`;
- Admin readiness: **83.33%**;
- canonical signals: registration true, structure true, fee true, intake true, English true, description false;
- consumer channel states: **0**;
- Search projected: true;
- Search publication: `unpublished`;
- Search fee/intake/English admitted: false/false/false;
- Search projection version: `course-v2`;
- Search generation: 12.

This is the bounded proof that accepted canonical Provider-current enrichment can exist while Search enrichment remains deliberately unadmitted.

## Global Search state at audit

`search.projection_state` for `courses`:

- generation: 12;
- row count: 33,105;
- projection version: `course-v2`;
- enrichment gate: `explicit`;
- coverage with fee: 0;
- coverage with intake: 0;
- coverage with English: 0;
- coverage with scholarship: 0.

This state is operational Search metadata, not canonical Course truth.

## Publishing channel state at audit

`publishing.entity_states` currently contains zero rows. Therefore the reference Courses have no channel-specific publication state recorded.

This is deliberately represented as an empty channel-state collection rather than coerced to `unpublished`, `published`, `rejected` or incomplete.

## Security

`security.admin_course_state_summary(uuid)`:

- is in the non-exposed `security` schema;
- is `SECURITY DEFINER` with restricted search path;
- requires authentication and an assigned CourseFinder role;
- denies `anon` EXECUTE;
- permits `authenticated`/`service_role` execution so the invoker `public.admin_read` can dispatch to it.

No canonical Course or Search document row was rewritten by either migration.

## Frontend release — PIM Admin v2.9.0

The v2.9 source adds `src/CourseStatePanel.jsx` and keeps the existing v2.8 semantic Course/Scholarship views.

### Course grid

The Course decision grid now explicitly labels:

- **Admin readiness** instead of generic `Complete`;
- **Canonical publication**;
- **Search** as `Projected · <Search publication state>` or `Not projected`;
- Lifecycle remains separate.

### Course detail

The **State & publication** panel displays:

- Canonical lifecycle;
- Canonical publication;
- Admin canonical-presence readiness;
- Consumer channel state count/absence;
- Search projection presence;
- Search publication;
- each six-signal readiness component;
- canonical presence versus Search-admitted fee/intake/English/scholarship state;
- Search projection version/generation/timestamps/global row count;
- explicit empty-state language when no channel publication state exists.

Initial branch comparison against v2.8 showed the intended narrow source delta:

- `src/CourseStatePanel.jsx` added;
- `src/main.jsx`: 5 additions / 4 deletions;
- `package.json`: one version-line change;
- migrations 066 and 067 mirrored separately.

## UAT

Detailed evidence:

`docs/uat/coursefinder-m1-pim-gov-state-model-v2.9.0-uat-2026-08-20.md`

Technical/authenticated UAT passed for the repaired Course page and state detail on `121174E` and `102784C`.

A fresh Vite dependency/bootstrap build and deployed Cloudflare browser observation remain unavailable from the current execution environment and are not represented as PASS.

## Consumer consequence

A downstream system must not collapse lifecycle, publication, readiness and Search state into one generic `Status` field.

Search operational fields are not the authority for Website/Zoho publication. Consumer admission remains separately governed.

## Rollback

Frontend rollback removes the v2.9 State & publication presentation and restores v2.8 grid labels. Backend rollback restores the prior Search-state wrapper/detail summary only if necessary; canonical Course, `publishing.entity_states` and Search-document data must not be modified as rollback for an Admin read/presentation change.

## Decision / status history

| Timestamp | Status | Event |
|---|---|---|
| 20 Aug 2026 13:38 AEST | DEFECT FOUND / OPEN | Authenticated Course page failed because Search wrapper referenced nonexistent `course_documents.status`; state-model ambiguity confirmed |
| 20 Aug 2026 | APPLIED / TECHNICAL PASS | Search-state wrapper repaired and explicit Search fields added |
| 20 Aug 2026 | APPLIED / TECHNICAL PASS | Course-detail canonical/readiness/channel/Search summary applied and authenticated UAT passed |
| 20 Aug 2026 | FRONTEND SOURCE PASS | PIM Admin v2.9.0 state panel/grid semantics staged with narrow frontend diff |

## Closure

**Final status:** OPEN — DB/RPC/SECURITY + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING  
**Closed at:** N/A  
**Outcome:** The live Course-page blocker is repaired and lifecycle/publication/readiness/channel/Search states now have separate governed meanings through DB/RPC and v2.9 source presentation. Closure requires deployed authenticated browser UAT.
