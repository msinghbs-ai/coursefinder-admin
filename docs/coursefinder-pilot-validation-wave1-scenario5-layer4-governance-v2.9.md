# Coursefinder Pilot-to-Production Validation — Wave 1 Scenario 5 v2.9

**Scenario:** Layer 4 governance, conflict resolution and scholarship review

**Environment:** Existing `coursefinder-demo` project

**Status:** Validation complete. No production schema changes applied.

---

## 1. Objective

Validate whether the approved production design can support human curation and governance for:

- approving correct Layer 2 values;
- rejecting incorrect extraction;
- Layer 1 vs Layer 2 conflicts;
- Course Collection vs Academic Option reclassification;
- scholarship scope approval/exclusion;
- undergraduate-vs-postgraduate scholarship eligibility;
- append-only audit history;
- reopening/reviewing a prior decision when source evidence changes.

The purpose is to separate limitations of the current demo resolver from limitations of the target database design.

---

## 2. Current demo Layer 4 implementation assessment

The active `layer4-resolve` Edge Function is authenticated at the gateway (`verify_jwt=true`) but currently uses the service-role client internally and does not perform an application-role check or write the authenticated actor to the decision record.

The resolver currently supports only two first-class approval paths:

- `english_requirement`;
- `description`.

For all other fields it can close a queue item and write a generic `field_values` row, but it does not apply a complete domain-specific canonical write.

It also does not currently:

- use `review_actions` as the primary durable human audit trail;
- populate the richer `review_queue` decision/current/proposed-value fields;
- implement annual-fee conflict resolution correctly;
- implement Course Collection or Academic Option reclassification;
- implement scholarship approval/scope/criteria actions;
- implement explicit reopen lineage after evidence changes;
- enforce curator/PIM-admin/platform-admin role checks inside the resolver.

**Classification:** `IMPLEMENTATION_GAP`.

This confirms that the production Layer 4 service should be rebuilt against the v2.9 contracts rather than porting the current resolver unchanged.

---

## 3. Schema capability tests

### 3.1 Proposed vs current values

`review_queue` already contains fields for:

- `review_type`;
- `proposed_changes`;
- `current_values`;
- `decision`;
- `resolution_payload`;
- `reviewed_by`;
- `reviewed_at`;
- assignment and due-date metadata.

This is sufficient to present side-by-side source conflicts in the admin UI.

**Result:** PASS.

### 3.2 Append-only review actions

`review_actions` supports explicit actions including:

- approve;
- correct;
- reject;
- map_attribute;
- create_attribute;
- merge;
- split;
- link_course;
- change_scope;
- verified_none;
- expire;
- needs_research;
- suggest;
- comment.

This is a good production pattern for auditable human decisions.

**Result:** PASS with one refinement below.

### 3.3 Evidence-change reopening

The current action constraint does **not** contain an explicit `reopen` action and `review_queue` does not currently expose an obvious parent/superseded-review lineage column.

A source-change event can technically be represented using a comment plus status transition or by creating a new queue item, but that weakens the ability to answer:

> Which prior human decision was reopened or superseded by this new evidence?

**Classification:** `DESIGN_GAP` — minor physical-model refinement.

**Production requirement:** support explicit review lineage. Recommended implementation:

- add `reopen` / `supersede` action types to `workflow.review_actions`;
- add `supersedes_review_id` or `reopened_from_review_id` nullable FK on `workflow.review_queue`;
- preserve the prior resolved item rather than mutating/deleting its history.

---

## 4. Layer 1 vs Layer 2 conflict scenario

Example:

- Layer 1 regulatory/canonical record provides a protected registration or fee-related fact;
- Layer 2 website evidence proposes a different value.

Expected production workflow:

1. create a review item with `current_values` and `proposed_changes`;
2. show source priority and evidence side-by-side;
3. reviewer approves, corrects, rejects or marks needs-research;
4. authoritative Layer 1 identity/regulatory data is not silently overwritten;
5. append `review_actions` record with actor, payload and evidence;
6. publish only the approved preferred fact.

The current schema can represent this cleanly.

**Result:** PASS — resolver implementation incomplete.

---

## 5. Course Collection vs Academic Option reclassification

Scenario #2 established that a major/specialisation/stream inside a degree must not become a standalone course or provider Course Collection.

Scenario #3 established that provider study-area verticals such as Information Technology are valid Course Collections.

Layer 4 therefore needs explicit reclassification actions such as:

- proposed Course Collection -> approve;
- proposed Course Collection -> reclassify as Course Academic Option;
- proposed course -> reclassify as Course Academic Option;
- proposed taxonomy mapping -> correct category;
- link option to one or more parent courses.

Current `review_actions` already provides `correct`, `link_course`, `merge`, `split`, `map_attribute` and `comment`, which can support the workflow at a generic level.

However, the first-class **Course Academic Option** entity identified in Scenario #2 remains a pending v2.9 schema addition.

**Result:** PASS once the Scenario #2 physical-model addition is consolidated.

---

## 6. Scholarship governance validation

### 6.1 Scholarship eligibility criteria

The current scholarship criteria model supports controlled criteria including:

- study level;
- field of study;
- faculty;
- specific course;
- nationality/citizenship/country;
- international status;
- English requirement;
- enrolment/offer status;
- academic metrics;
- financial/equity/leadership/research and other criteria.

This is sufficient to model the Scenario #4 examples:

- Monash International Merit Scholarship -> undergraduate-only;
- UTS Academic Excellence International Scholarship -> undergraduate/postgraduate coursework with international/full-time/on-campus conditions.

**Result:** PASS.

### 6.2 Scholarship include/exclude logic

`scholarship_scopes` supports explicit `include` and `exclude`, while `course_scholarships.relationship` supports `explicitly_eligible`, `explicitly_excluded`, `inferred_from_scope` and `human_verified`.

This is sufficient for Layer 4 to confirm an inclusion or exclusion without deleting the source evidence.

**Result:** PASS.

### 6.3 Course Collection scholarship scope

The approved architecture allows scholarships to apply to a provider Course Collection where the source rule is expressed at a provider vertical/faculty/programme-group level.

The current demo `scholarship_scopes.scope_type` constraint includes provider-wide, all courses, study level, faculty, field of study, course family, specific course, country and campus — but not Course Collection.

**Classification:** `DESIGN_GAP` — small physical-model refinement.

**Production requirement:** add `course_collection` as a valid scholarship scope type, preferably referencing the canonical Course Collection ID rather than storing only free text.

---

## 7. Actor and authorization requirements

A production human-review decision must answer:

- who made the decision;
- what role they held;
- what evidence was visible;
- previous value;
- proposed value;
- final value;
- decision type;
- notes/reason;
- timestamp.

The current `review_actions.actor_id` is nullable and the demo resolver does not populate it.

**Classification:** `IMPLEMENTATION_GAP` for the demo, with a production constraint recommendation:

- require authenticated actor for human actions;
- permit null/system actor only for explicitly typed automated system events;
- authorization must be checked server-side before service-role writes.

---

## 8. Scenario results

| Test | Result | Classification |
|---|---|---|
| Approve correct value | Model PASS | Resolver implementation gap |
| Reject incorrect value | PASS | Current resolver supports closure but audit should move to `review_actions` |
| Layer 1 vs Layer 2 conflict | PASS | Implementation gap in resolver/UI |
| Collection vs Academic Option reclassification | PASS after Scenario #2 addition | Pending Course Academic Option design addition |
| Scholarship scope approval | PASS | Implementation gap |
| Scholarship exclusion | PASS | No design gap |
| Undergraduate scholarship vs postgraduate course | PASS | Criteria model supports deterministic exclusion |
| Append-only audit | PASS | Demo resolver does not currently use it |
| Changed evidence reopening | PARTIAL | `DESIGN_GAP`: explicit reopen/supersede lineage required |
| Scholarship scoped to Course Collection | PARTIAL | `DESIGN_GAP`: add Course Collection scope type |
| Role/actor attribution | PARTIAL | Implementation/security gap; enforce in production |

---

## 9. Consolidated design changes discovered through Wave 1 so far

Do not modify the production schema mid-wave. Carry these into the final v2.9 consolidation:

1. **Course Academic Options** — first-class child structure for major/minor/specialisation/stream/concentration/research pathway.
2. **Review reopening lineage** — explicit reopen/supersede action and FK lineage between review items.
3. **Scholarship Course Collection scope** — allow scholarship scope to reference a provider Course Collection.

These are bounded refinements. They do not invalidate the v2.8.1 architecture or the core v2.9 relational design.

---

## 10. Production Layer 4 service requirement

The production service should not replicate the current `layer4-resolve` function verbatim.

Recommended workflow:

```text
Authenticated reviewer
  -> server-side role validation
  -> load queue + evidence + current/proposed values
  -> validate requested action against entity/review type
  -> domain-specific canonical write in one transaction
  -> append review_actions
  -> mark queue resolved/rejected/superseded
  -> write change/audit event
  -> refresh completeness/search state when relevant
```

No browser should receive service-role credentials.

---

## 11. Scenario 5 conclusion

Layer 4 validates the overall production architecture but demonstrates that the demo resolver is only a proof-of-concept implementation.

The production data model is suitable for human governance after three bounded Wave 1 refinements are consolidated. No broader redesign is required.

**Next recommended scenario:** Adelaide provider identity transition plus source/evidence supersession, then consolidate all confirmed v2.9 design refinements before production project creation.
