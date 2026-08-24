# CF-CHG-20260824-032 — Course Attribute State Matrix & Terminal Layer 4 Resolution

**Status:** APPLIED — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 24 August 2026 16:16 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — Layer 2 Platform / Course Detail human-resolution UX  
**Owner:** Admin/PIM UX with M2.1 Layer 2 and future Layer 3 integration  
**Related:** `CF-CHG-20260823-029`, `CF-CHG-20260824-031`

## Trigger

Manual Admin UAT showed that hiding empty Course attributes makes Layer 4 work ambiguous. Human resolution needs the governed field set visible even when a value is empty, while still preserving which automated layer owns the next action.

The requested outcome is not a raw editable form. It is a decision-oriented field matrix that tells an operator:

`Field → current value / blank → authority trail → next layer/action`.

## Decisions

1. **All governed Course attributes remain visible**, including empty values.
2. Empty values use a neutral placeholder (`—`); prose such as `Not captured` is not repeated on every field.
3. Layer progress is **field-specific and Evidence-backed**. A layer is struck only when that field/domain was actually attempted and remained unresolved.
4. Layer 1 identity/regulatory authority cannot be overwritten through Layer 4 enrichment. Missing Layer 1 data is labelled **Regulatory correction**.
5. Layer 4 controls appear only when the field is genuinely terminal for enrichment (`l4_input` / `awaiting_l4`) or is revising an existing L4 resolution. A blank field does not itself authorise human bypass of L2/L3.
6. Direct PIM-managed fields such as Categories/Collections may legitimately begin as **L4 input** without pretending L2/L3 were attempted.
7. Compound facts (tuition, intakes, English) do not use unsafe free-text editing. They route to typed Layer 4 review/editor work; the current increment enables only safe scalar Course resolution.
8. Search and Publication remain downstream governed states. L4 resolution does not automatically publish or mutate Search.

## Field-state vocabulary

| State | UI treatment | Meaning |
|---|---|---|
| `resolved` | Value + actual `L1/L2/L3/L4` badge | Current field is resolved by that authority layer |
| `source_missing` | struck `L1` + `Regulatory correction` | Layer 1 authoritative field is absent/invalid and must be corrected at source/governed regulatory workflow |
| `awaiting_l2` | `L2` + `Awaiting L2` | Layer 2 has not yet attempted this field/domain |
| `awaiting_l3` | struck `L2` → `L3` + `Awaiting L3` | Layer 2 actually attempted the field/domain and did not safely resolve it |
| `awaiting_l4` | struck `L2`, struck `L3` → `L4 input` | Both automated enrichment layers actually exhausted this field/domain |
| `l4_input` | `L4` + `L4 input` | Field is directly PIM/human managed and does not require fake L2/L3 attempts |

There is currently no accepted Layer 3 persistence/execution table in the deployed schema. Therefore enrichment fields must not show a struck Layer 3 / `awaiting_l4` state until real Layer 3 execution is implemented and persisted.

## Backend implementation

Live Supabase migrations applied:

- `m2_1_course_field_state_projection`;
- `m2_1_course_detail_field_states`;
- `m2_1_layer4_course_scalar_resolution`;
- `m2_1_course_field_state_attempt_precision`;
- `m2_1_layer4_resolution_provenance_precision`.

### Governed read

`security.admin_course_field_states(course_id)` builds the field-state matrix from canonical data plus field-specific Layer 2 attempt evidence. `public.ui_course_detail(course_id)` includes `field_states`, so Course Detail does not issue one RPC per field.

Current Course matrix includes:

- Provider;
- CRICOS / Course code;
- Study level;
- Field of study;
- Duration;
- Delivery mode;
- Official Course URL;
- Course description;
- Current Provider tuition;
- Intakes;
- English requirement;
- Campuses;
- Academic options;
- Categories;
- Collections;
- Regulatory facts.

### Terminal Layer 4 scalar resolution

Created `pipeline.layer4_course_field_resolutions` with RLS enabled and no direct `anon`/`authenticated` table access.

`public.layer4_course_scalar_resolve(...)` requires Curator rank 3 or higher and currently supports only:

- Course description;
- official Course URL;
- delivery mode;
- duration.

Every resolution requires a reason, preserves prior/new value in an audit record, supersedes an earlier active L4 resolution for the same field, and returns `publication_changed=false` / `search_changed=false`.

Layer 4 provenance remains visible after application: a human-resolved scalar reports `resolved_layer=4` rather than being mislabelled according to the canonical storage column.

## Pilot UI

Visible UI: **PIM Admin v2.15.0**.

Course Detail now starts with a `Course attributes` matrix. Every governed attribute is visible whether populated or empty. Empty fields expose the layer trail and next action instead of disappearing.

Role-sensitive L4 actions are terminal-state gated:

- safe scalar terminal fields → `L4 edit`;
- compound terminal fields → `L4 review`;
- awaiting L2/L3 fields → no L4 button;
- Layer 1 fields → no L4 override.

Implementation refs:

- `src/CourseDetailPolish.jsx`;
- `src/layer4-course-resolution.js`;
- `src/pim-version-entry.js`;
- `index.html`;
- `tests/uat/course-detail-polish-deployed.spec.mjs`.

Current Pilot head at this update: `effa55f60974e27ad3f27fcd74543f2785fb91ce`.

## Bounded technical UAT

### Backend field-state precision — PASS

Federation University Australia `Bachelor of Science (Honours)` / CRICOS `088661B` is the reference unresolved Course.

Expected exact states:

- Delivery mode → `awaiting_l2`;
- Academic options → `awaiting_l2`;
- Current Provider tuition → `awaiting_l3` because L2 attempted/rejected an unsafe fee candidate;
- English requirement → `awaiting_l3` because L2 attempted but did not extract a requirement;
- Categories → `l4_input`;
- Collections → `l4_input`;
- Official Course URL → resolved L2;
- Course description → resolved L2;
- Intakes → resolved L2;
- Campuses/Regulatory identity → resolved L1.

This proves that a generic Course-level L3 flag is not used to strike L2 for unrelated fields.

### Deployed browser UAT — PENDING

Desktop and mobile Chromium must prove:

1. exact `PIM Admin v2.15.0` marker;
2. Course Detail remains responsive;
3. all 16 governed attribute labels are visible even when empty;
4. Federation Bachelor of Arts continues to show populated English/URL/fees correctly;
5. Federation Science (Honours) shows exactly two `Awaiting L3`, two `Awaiting L2` and two direct `L4 input` states in the attribute matrix;
6. L4 controls do not appear on awaiting L2/L3 fields;
7. Evidence drill-down remains responsive after the v2.14 recovery incident;
8. no browser/server runtime errors.

SHA-bound deployed status has not yet appeared for current Pilot head, so browser acceptance is not claimed.

## Follow-on / deliberately not faked

- Layer 3 execution/persistence must be implemented before any enrichment field can legitimately show struck L3 → L4.
- Typed Layer 4 editors are still required for tuition, intakes and English. These must preserve their semantic dimensions rather than becoming free text.
- Back-to-Course Evidence navigation remains deferred until the recovered browser shell is stable.

## Rollback

- Revert PIM v2.15 UI commits to the responsive v2.14.3 presentation if browser UAT regresses.
- Remove/disable the Layer 4 scalar RPC if mutation UAT exposes an authority issue; canonical Layer 1 and M1 Search/publication state do not depend on this capability.
- Field-state projection is read-only and can be removed from Course Detail without altering canonical data.

## Current gate

**APPLIED — DEPLOYED BROWSER UAT PENDING.**

M2.1 remains blocked until the deployed Admin runtime and the parent Layer 2 acceptance gate pass.