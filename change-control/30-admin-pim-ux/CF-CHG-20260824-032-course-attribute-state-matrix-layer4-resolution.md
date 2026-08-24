# CF-CHG-20260824-032 — Course Attribute State Matrix & Terminal Layer 4 Resolution

**Status:** BLOCKED — V2.15.1 DEPLOYED BROWSER RECOVERY UAT REQUIRED  
**Category:** 30-admin-pim-ux  
**Initiated:** 24 August 2026 16:16 AEST (+10:00)  
**Updated:** 24 August 2026 16:49 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — Layer 2 Platform / Course Detail human-resolution UX  
**Owner:** Admin/PIM UX with M2.1 Layer 2 and future Layer 3 integration  
**Related:** `CF-CHG-20260823-029`, `CF-CHG-20260824-031`

## Trigger

Manual Admin UAT showed that hiding empty Course attributes makes Layer 4 work ambiguous. Human resolution needs the governed field set visible even when a value is empty, while still preserving which automated layer owns the next action.

The requested outcome is a decision-oriented field matrix:

`Field → current value / blank → authority trail → next layer/action`.

## Decisions

1. All governed Course attributes remain visible, including empty values.
2. Empty values use a neutral `—` placeholder.
3. Layer progress is field-specific and Evidence-backed. A layer is struck only when that field/domain was actually attempted and remained unresolved.
4. Layer 1 identity/regulatory authority cannot be overwritten through Layer 4 enrichment. Missing Layer 1 data is labelled **Regulatory correction**.
5. Layer 4 controls appear only when the field is genuinely terminal for enrichment (`l4_input` / `awaiting_l4`) or revises an existing L4 resolution.
6. Direct PIM-managed fields such as Categories/Collections may legitimately begin as **L4 input** without fake L2/L3 attempts.
7. Compound facts (tuition, intakes, English) do not use unsafe free-text editing.
8. Search and Publication remain downstream governed states. L4 resolution does not automatically publish or mutate Search.

## Field-state vocabulary

| State | UI treatment | Meaning |
|---|---|---|
| `resolved` | Value + actual `L1/L2/L3/L4` badge | Current field is resolved by that authority layer |
| `source_missing` | struck `L1` + `Regulatory correction` | Layer 1 authoritative field is absent/invalid |
| `awaiting_l2` | `L2` + `Awaiting L2` | Layer 2 has not yet attempted this field/domain |
| `awaiting_l3` | struck `L2` → `L3` + `Awaiting L3` | Layer 2 attempted the field/domain and did not safely resolve it |
| `awaiting_l4` | struck `L2`, struck `L3` → `L4 input` | Both automated enrichment layers actually exhausted this field/domain |
| `l4_input` | `L4` + `L4 input` | Field is directly PIM/human managed |

There is currently no accepted Layer 3 persistence/execution table. Therefore enrichment fields must not show a struck Layer 3 / `awaiting_l4` state until real Layer 3 execution is implemented and persisted.

## Backend implementation

Live Supabase migrations applied:

- `m2_1_course_field_state_projection`;
- `m2_1_course_detail_field_states`;
- `m2_1_layer4_course_scalar_resolution`;
- `m2_1_course_field_state_attempt_precision`;
- `m2_1_layer4_resolution_provenance_precision`.

`security.admin_course_field_states(course_id)` builds the matrix from canonical data plus field-specific Layer 2 attempt evidence. Course Detail receives `field_states` through the governed read boundary; there is no per-field RPC pattern.

`pipeline.layer4_course_field_resolutions` retains terminal human-resolution audit/provenance. Browser writes now use JWT-protected Edge function `layer4-course-resolve`; the underlying mutation function is service-role-only. Search/publication are unchanged by L4 resolution.

## Pilot UI

### v2.15.0 — FAILED deployed manual UAT

The first v2.15 renderer introduced a blank Course drawer regression.

Root cause: `state_summary` may contain JSON objects. `OperationalState` rendered `s.search`, `s.canonical` and `s.admin_readiness` directly as React children. When one of those values was an object React threw `Objects are not valid as a React child`, collapsing the Course drawer although the Course-detail backend read itself remained valid.

This failure is an Admin renderer defect, not a canonical-data or Layer 2 ingestion failure.

### v2.15.1 — RECOVERY APPLIED

`src/CourseDetailPolish.jsx` was replaced with an object-safe renderer:

- every external/backend value passes through bounded primitive/object-safe display handling before React rendering;
- `state_summary` objects are summarised to scalar counts/labels rather than rendered directly;
- all 16 governed Course attributes remain visible;
- existing fee, English, Evidence and field-state semantics remain;
- L4 terminal-state gating remains;
- no new polling or MutationObserver behaviour was introduced.

Visible recovery version: **PIM Admin v2.15.1**.

Implementation refs:

- `f9c7f79cf950d47f36a4a9ac72b63c710ed6e987` — object-safe Course Detail renderer;
- `e85258a44afd09fa1bcf92b024c5bca1c67a01c7` — exact v2.15.1 visible version;
- `1a92714a36ab0531a86ec1e1a88078d633d7fff9` — v2.15.1 runtime marker/title;
- `4faf4fbdc7b8e6e114944774d4fed306285601bd` — deployed recovery + field-state UAT binding.

## Bounded technical UAT

### Backend field-state precision — PASS

Federation University Australia `Bachelor of Science (Honours)` / CRICOS `088661B` remains the unresolved-state reference:

- Delivery mode → `awaiting_l2`;
- Academic options → `awaiting_l2`;
- Current Provider tuition → `awaiting_l3`;
- English requirement → `awaiting_l3`;
- Categories → `l4_input`;
- Collections → `l4_input`;
- Official Course URL / Course description / Intakes → resolved L2;
- Campuses / regulatory identity → resolved L1.

### Layer 4 mutation contract — PASS, rollback-safe

A transactionally rolled-back delivery-mode test returned `layer=4`, `search_changed=false`, `publication_changed=false`, then restored the original NULL value after rollback.

### Security adviser — PASS for new v2.15 surfaces

The initial direct authenticated `SECURITY DEFINER` warnings for the Layer 4 write and field-state helper were removed. The remaining Layer 2 policy-update warning and Pilot leaked-password warning are pre-existing governed items.

### Deployed browser recovery UAT — PENDING

Desktop and mobile Chromium must now prove against **v2.15.1**:

1. exact `PIM Admin v2.15.1` marker;
2. Bachelor of Arts drawer renders rather than appearing blank;
3. `Operational state` renders without a React object-child error;
4. all 16 governed attribute labels remain visible;
5. Federation populated URL/English/fees remain correct;
6. Science (Honours) retains the exact 2 Awaiting L2 / 2 Awaiting L3 / 2 direct L4 state pattern;
7. Evidence drill-down remains responsive;
8. no browser/server runtime errors.

## Follow-on / deliberately not faked

- Layer 3 execution/persistence must exist before enrichment fields can legitimately show struck L3 → L4.
- Typed L4 editors remain required for tuition, intakes and English.
- Back-to-Course Evidence navigation remains deferred until the browser shell is consistently stable.

## Rollback

If v2.15.1 still fails deployed browser UAT, revert the Course drawer presentation to the last responsive v2.14.3 component while retaining the read-only field-state backend and Layer 2 canonical data. Do not weaken read/write security or publication controls to recover UI availability.

## Current gate

**BLOCKED — V2.15.1 DEPLOYED BROWSER RECOVERY UAT REQUIRED.**

M2.1 remains blocked until the deployed Admin runtime and parent Layer 2 acceptance gate pass.