# CourseFinder M1-PIM-GOV Course State Model UAT — PIM Admin v2.9.0

**Date:** 20 August 2026  
**Executed:** 20 August 2026 13:38 AEST (UTC+10)  
**Change Control:** `CF-CHG-20260820-012`  
**Workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Frontend release:** `PIM Admin v2.9.0`  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Feature branch:** `m1-pim-gov-state-model-v2-9-20260820`  
**Status:** **DB/RPC/SECURITY + FRONTEND SOURCE UAT PASS — DEPLOYED AUTHENTICATED BROWSER UAT PENDING**

## 1. Purpose

Prove a governed separation between canonical lifecycle, canonical publication, Admin canonical-presence readiness, consumer-channel publication and Search projection/admission state, while repairing the live Course-page Search-state defect found during the audit.

## 2. Live defect reproduced

Before correction, authenticated `public.admin_read('courses_page',...)` failed because `security.admin_course_page_search_state` referenced:

`search.course_documents.status`

The actual Search projection column is:

`search.course_documents.publication_status`

Observed failure:

`column d.status does not exist`

**Defect verdict:** CONFIRMED.

## 3. Course-page repair

Pilot migration:

`m1_pim_gov_course_state_semantics_v1`

Repository mirror:

`supabase/production-migrations/066_m1_pim_gov_course_state_semantics.sql`

The wrapper now returns explicitly Search-namespaced state:

- projected/not projected;
- Search publication status;
- Search completeness;
- projection version/generation/timestamps;
- Search-admitted fee/intake/English/scholarship flags.

**Authenticated Course-page regression:** PASS.

## 4. Course-detail state summary

Pilot migration:

`m1_pim_gov_course_state_detail_v1`

Repository mirror:

`supabase/production-migrations/067_m1_pim_gov_course_state_detail.sql`

Private role-checked helper:

`security.admin_course_state_summary(uuid)`

It exposes independent:

- canonical state;
- Admin readiness;
- consumer-channel state;
- Search projection/admission state.

ACL assertions:

- `anon` helper execute: false;
- `authenticated` helper execute: true for the governed invoker path;
- `authenticated` `public.admin_read`: true.

**Security/browser-call contract:** PASS.

## 5. Exact reference — CRICOS 121174E

Authenticated Course page after repair:

- exact result total: 1;
- Course Code: `121174E`;
- Search projected: true;
- Search publication: `unpublished`.

Authenticated Course detail:

- canonical lifecycle: `active`;
- canonical publication: `unpublished`;
- Admin readiness: `50.00`;
- canonical fee presence: true;
- canonical Intake presence: false;
- canonical English presence: false;
- consumer channel states: 0;
- Search projected: true;
- Search publication: `unpublished`;
- Search fee admitted: false.

**Verdict:** PASS.

This proves that `active`, canonical `unpublished`, Search projected and Search `unpublished` are compatible simultaneous states and are not synonyms.

## 6. Exact reference — CRICOS 102784C

Authenticated state summary:

- canonical lifecycle: `active`;
- canonical publication: `unpublished`;
- Admin readiness: `83.33`;
- canonical signals:
  - registration true;
  - structure true;
  - fee true;
  - intake true;
  - English true;
  - description false;
- consumer channel states: 0;
- Search projected: true;
- Search publication: `unpublished`;
- Search projection version: `course-v2`;
- Search catalogue generation: 12;
- Search fee admitted: false;
- Search Intake admitted: false;
- Search English admitted: false;
- global Search Course Documents: 33,105.

**Verdict:** PASS.

This is the key admission-isolation reference: accepted canonical Provider-current Fee/Intake/English observations are present while the current Search document deliberately does not admit them.

## 7. Global Search projection reference

`search.projection_state` for `courses` at audit:

- generation: 12;
- row count: 33,105;
- projection version: `course-v2`;
- enrichment gate: `explicit`;
- `with_fee`: 0;
- `with_intake`: 0;
- `with_english`: 0;
- `with_scholarship`: 0.

This metadata is operational Search state only.

## 8. Consumer-channel publication reference

`publishing.entity_states` contained zero rows at audit.

For both exact reference Courses, the correct semantic result is:

**No consumer-channel publication state recorded.**

The absence is not converted into `published`, `unpublished`, `rejected`, `incomplete` or any other invented state.

## 9. Frontend source UAT — PIM Admin v2.9.0

Initial branch comparison against PIM Admin v2.8 base `f9fe8e72fb636145cda44adde20b369536fd4704` after backend/source staging showed:

- branch ahead 5 / behind 0;
- `src/CourseStatePanel.jsx`: added;
- `src/main.jsx`: 5 additions / 4 deletions;
- `package.json`: one version-line change;
- migrations 066 and 067 added.

Frontend semantics:

### Course grid

- `Complete` renamed **Admin readiness**;
- Lifecycle remains separate;
- **Canonical publication** is a separate column;
- **Search** is a separate column displaying `Projected · <Search publication status>` or `Not projected`.

### Course detail

`State & publication` panel explicitly states the five state classes are independent and shows:

- canonical lifecycle/publication;
- readiness score and six signals;
- channel-state presence/absence;
- Search projected/publication state;
- canonical presence vs Search admission for Fee/Intake/English/Scholarship;
- Search projection metadata;
- explicit empty channel-state meaning.

**Frontend source semantic verdict:** PASS.

## 10. Build/runtime limitation

The current execution environment cannot independently bootstrap a fresh Vite build because external DNS is unavailable and cannot independently observe the Cloudflare Worker runtime.

Therefore:

- source semantic UAT = PASS;
- authenticated DB/RPC UAT = PASS;
- independent clean-bundle proof = NOT OBSERVED;
- deployed browser UAT = PENDING.

## 11. Deployed browser UAT required for closure

1. visible `PIM Admin v2.9.0`;
2. Course grid exact `121174E` loads successfully with no Search-state RPC error;
3. `121174E` shows Admin readiness 50%, Lifecycle Active, Canonical publication Unpublished and Search `Projected · Unpublished` as separate columns;
4. Course detail State & publication panel repeats those meanings without collapsing them;
5. no consumer-channel state is shown as `No channel publication state recorded`, not as an invented status;
6. `102784C` shows 83.33% Admin readiness with canonical Fee/Intake/English present;
7. `102784C` Search admission comparison shows Fee/Intake/English not admitted;
8. Search metadata shows `course-v2`, generation 12 and the current projection state;
9. regression-check v2.7 Course details, v2.8 Scholarship logic, QILT/PRISMS, Evidence and full-catalogue paging.

## 12. Final verdict

**Live Course-page defect:** FIXED / PASS  
**State semantic contract:** PASS  
**Authenticated DB/RPC/security:** PASS  
**Frontend source semantics:** PASS  
**Canonical/Search data rewrite:** NONE  
**Consumer publication/admission change:** NONE  
**Deployed authenticated browser UAT:** PENDING
