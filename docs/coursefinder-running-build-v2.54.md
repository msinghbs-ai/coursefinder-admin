# CourseFinder Running Build v2.54

**Status:** CURRENT GOVERNED SOURCE BUILD — CLOUDFLARE RUNTIME OBSERVATION PENDING  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.53.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.50.md`  
**State-model UAT:** `docs/uat/coursefinder-m1-pim-gov-state-model-v2.9.0-uat-2026-08-20.md`

## Build delta

v2.54 preserves the accepted Layer 1, Layer 2, Search-isolation, Fee, Campus, Entry, Taxonomy, Insights, Evidence, Catalogue and Scholarship semantic state and adds `CF-CHG-20260820-012`: the explicit Course lifecycle/publication/readiness/channel/Search state model in **PIM Admin v2.9.0**.

## Live Course-page blocker repaired

During the state audit, authenticated `courses_page` failed because `security.admin_course_page_search_state` referenced nonexistent `search.course_documents.status` instead of `publication_status`.

Pilot migration:

`m1_pim_gov_course_state_semantics_v1`

Repository mirror:

`supabase/production-migrations/066_m1_pim_gov_course_state_semantics.sql`

The repaired wrapper now returns explicit Search-prefixed projection fields and exact Course search works again.

## Course-detail state model

Pilot migration:

`m1_pim_gov_course_state_detail_v1`

Repository mirror:

`supabase/production-migrations/067_m1_pim_gov_course_state_detail.sql`

`security.admin_course_state_summary(uuid)` separates:

- canonical lifecycle/publication;
- six-signal Admin canonical-presence readiness;
- consumer-channel publication rows;
- Search projection presence/publication;
- Search enrichment admission;
- global Search projection metadata.

### Scholarship-presence correction

Source review caught one frontend comparison using a Course-detail field that did not exist. Scholarship relationship presence is useful for canonical-vs-Search comparison but is intentionally outside the six-signal readiness score.

Pilot migration:

`m1_pim_gov_course_state_scholarship_presence_v1`

Repository mirror:

`supabase/production-migrations/068_m1_pim_gov_course_state_scholarship_presence.sql`

The state summary now exposes:

`canonical_presence.scholarship`

and v2.9 consumes that explicit value rather than guessing from an absent field.

## PIM Admin v2.9.0

### Course decision grid

- generic `Complete` is relabelled **Admin readiness**;
- Lifecycle remains separate;
- **Canonical publication** is visible separately;
- **Search** displays `Projected · <Search publication state>` or `Not projected`.

### Course detail

The new `src/CourseStatePanel.jsx` presents:

- Canonical lifecycle;
- Canonical publication;
- Admin readiness and its six canonical signals;
- consumer-channel publication state/explicit absence;
- Search projection/publication;
- canonical-vs-Search admission comparison for Fee/Intake/English/Scholarship;
- Search version/generation/freshness/global row-count metadata.

The panel explicitly states these states are independent.

## Reference state — CRICOS 121174E

Authenticated governed reads after repair show:

- exact Course page result: 1;
- Lifecycle: active;
- Canonical publication: unpublished;
- Admin readiness: 50.00%;
- channel-state records: 0;
- Search projected: true;
- Search publication: unpublished;
- canonical fee present: true;
- Search fee admitted: false.

## Reference state — CRICOS 102784C

Authenticated Course detail shows:

- Lifecycle: active;
- Canonical publication: unpublished;
- Admin readiness: 83.33%;
- canonical Fee/Intake/English: true/true/true;
- channel-state records: 0;
- Search projected: true;
- Search publication: unpublished;
- Search Fee/Intake/English: false/false/false;
- projection version: `course-v2`;
- catalogue generation: 12.

This remains the primary proof that canonical enrichment presence and Search enrichment admission are separate gates.

## Global Search state

At the audit:

- Course Documents: 33,105;
- projection generation: 12;
- projection version: `course-v2`;
- enrichment gate: explicit;
- admitted Fee/Intake/English/Scholarship coverage: 0.

`publishing.entity_states` currently contains zero rows, so the reference Courses have **no consumer-channel publication state recorded**. This is not coerced into another status.

## Source integrity

Initial v2.9 branch comparison against v2.8 showed a narrow frontend delta:

- `src/CourseStatePanel.jsx` added;
- `src/main.jsx`: 5 additions / 4 deletions;
- package version only;
- migrations 066/067.

The final pre-publication correction adds migration 068 and changes the state panel only to consume explicit `canonical_presence.scholarship`.

No canonical Course, publishing-channel or Search-document data was rewritten.

## Governance outputs

- `CF-CHG-20260820-012`;
- State-model v2.9 UAT;
- PIM Admin Guide v1.5;
- Zoho Consumer Contract v1.3;
- migrations 066–068;
- central Change Control register through 012.

## Preserved programme baselines

- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- AU Course Facts: RMIT + UQ qualified / 10 bounded Courses;
- QUT source-specific blocker: deferred HTTP 403;
- QILT/PRISMS/Scholarship accepted canonical/source states unchanged;
- Search Course Documents: 33,105;
- Fee/Intake/English/Search Scholarship enrichment admission remains 0;
- vector Search remains not admitted.

## Deployment/build boundary

Source/DB/RPC UAT is not represented as Cloudflare runtime/browser PASS. The current environment cannot independently observe the Worker runtime and does not provide a reliable external-DNS path for an independent fresh Vite bootstrap/build.

## Current PIM governance position

`CF-CHG-001`, `005`, `006`, `007`, `008`, `009`, `010`, `011` and `012` have passed their applicable DB/RPC/security/frontend-source gates but remain open where deployed authenticated browser UAT is required.

Database Architecture remains v2.10.37 because no canonical relational model changed.
