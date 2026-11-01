# Provider-level bulk review: design, scope assessment and approval pack (Priority 1A)

**Direction:** Platform Admin, 1 Nov 2026 19:42 (verbatim: `2026-11-01-provider-bulk-review-direction.md`).
**Status:** design only. Nothing is built, deployed or switched on. Activation waits for the decisions in section 9.
**Register:** SS-016 enhancement **UR-18** (Layer 4 operability), linked to UR-04 to UR-07.
**Measured:** 1 Nov 2026, 19:45–19:55 AEDT, live project `fxcwkweaxjtknorudmwp`.

## 1. What the live data says (baseline)

| Measure | Count | What it means for the design |
|---|---:|---|
| Active courses | 35,690 at 1,881 providers | The scale bulk review has to work at |
| Active courses with no campus link (`catalogue.course_campuses`) | 5,870 | Campus and location are the largest low-risk gap |
| Active courses with no active intake (`catalogue.course_intakes`) | 22,478 | Intake gap is large, but intake dates vary by programme (section 3) |
| Active courses with no active English requirement | 14,982 | 14 providers have 100 or more such courses |
| Active campuses without a country or state | 26 | Region fixes are small and campus-level, not course-level |
| Manual locks (`pipeline.manual_locks`) | 7,561 (course URL 3,016, official URL 3,016, provider website 361, campus city 65) | Locks already exist and must be honoured |
| Pending Layer 4 items for intake or English | 1 (`course_english`) | Today's queue has almost no intake or English items, because earlier items were superseded (intake 10,931, English 6,047). Bulk review would close **gaps**, not clear the current queue |

Bulk review would therefore not reduce the 1,376 pending items much. Its value is in filling catalogue gaps with less repeated work, using evidence that applies to a whole group of courses. Projected savings are not counted as realised (direction §7).

## 2. Existing components reused (no second admission system)

| Need | Existing component | Use in bulk review |
|---|---|---|
| Review screen grouped by provider | Layer 4 Review, **university view** (`#layer-4-review?provider=<id>`, `src/Layer4Inbox.jsx`, `admin_layer4_inbox('universities')`) | Bulk mode is a panel inside this view. No new screen |
| Per-course decision and admission | `security.layer4_review_decide_impl` and the field apply functions (course link, tuition, English, intake) | Each selected course is decided through the same function, one course at a time inside a bounded batch |
| Effective-value override history | `pipeline.layer4_override_decisions` (A16, append-only) | Records the bulk value per course with the operation key; rollback is a new superseding event |
| Manual values | `pipeline.manual_locks`, `security.manual_lock_set` | Locked courses are listed as protected and never written |
| Evidence and provenance | `evidence_id` / `source_id` on campus, intake and English rows; `admin-evidence-access` | Shared evidence is shown with its capture date; each course row records the same evidence id |
| Audit | `pipeline.admin_control_events`, `pipeline.layer4_decisions` | One event per course outcome, plus one for the operation |
| Settings (G2) | `pipeline.platform_toolset_settings`, `security.pipeline_num_v1` | Batch size, maximum group size and the on/off switch are settings, not code |

New objects (written beside the consumer API, G3-safe): `pipeline.layer4_bulk_operations` (one row per previewed operation: provider, field, evidence, value, operation key, state) and `pipeline.layer4_bulk_operation_items` (one row per course: eligibility class, before value, outcome). Each new table gets a `comment on table`. The migration carries `-- Replaces:` and `-- Retires:` lines. No catalogue table, consumer view or edge function changes shape.

## 3. Eligible-field policy (proposed for approval, D-B1)

| Field | Risk | Bulk allowed when | Never |
|---|---|---|---|
| Country | Low | The campus is official, its country is known, and the course is linked to that campus | Inferring from the provider's registered address |
| State / territory / region | Low | Official campus address maps to one subdivision. Campus-level, so a fix applies to the campus once, not per course | Mapping from city name alone where it is ambiguous |
| Campus | Low | Official campus list and an official course-to-campus statement (course page or provider programme list) for each included course | Linking every course to every campus |
| Course location | Low–medium | The delivery campus or mode is stated for the course (on-campus, online, mixed) | Using headquarters as the location |
| Intake | Medium | An official calendar names the year, term and campus, **and** each included course is stated to follow it (course page or programme-group statement) | Assuming all courses share dates; mixing annual dates with recurring terms; carrying a past year forward |
| English requirements | High | A provider policy table gives test, overall score, band minimum and level, **and** the course page has no course-specific English rule, **and** the course is not in an accredited profession (nursing, teaching, medicine, law, psychology, etc.) | One IELTS/PTE/TOEFL score across levels, faculties or accredited programmes |
| AER (academic entry) | — | **Excluded.** One item at a time stays in force (v5 playbook §6) | Bulk approval of AER rows, matrices or interpretation-sensitive scores |

A course goes into the preview only if the evidence covers it. It is then put in one of six classes: **eligible**, **unchanged** (already holds the value), **protected** (manual lock or manually approved value), **excluded – exception** (a course-specific rule or another level), **excluded – conflict** (a different current value that evidence does not resolve) and **excluded – unsupported** (no evidence for this course).

## 4. Reviewer flow and preview contract (UI)

Inside the university view, a **Bulk review** panel opens for one provider and one field:

1. **Group:** provider, field and the shared evidence, with its stored copy, capture date and source link.
2. **Proposed value:** for example "Campus: City campus (Melbourne, VIC, Australia)" or "IELTS Academic 6.5, no band below 6.0, undergraduate".
3. **Summary counts:** candidate courses, eligible, unchanged, protected, excluded (each class), proposed changes and expected downstream actions. The heading says "Candidate courses", never "eligible", for the first count.
4. **Course list:** code, title, study level, campus, current value, class and the reason for the class. It can be sorted and filtered, and is paged with stable references (UR-04 traversal: every course reachable beyond 200).
5. **Select or exclude:** only eligible rows can be ticked; the others show why not.
6. **Preview:** the exact list that will be written, the count, and the operation key.
7. **Confirm:** a reason is required (the existing reason field), and the confirmation states the count.
8. **Result:** applied, unchanged, excluded, conflicted and failed, each with its count and course list. Destination values are read back. A partial result is shown as partial, never as done.

**Preview contract (RPC, read-only):** `admin_layer4_inbox('bulk_preview', {provider_id, field, evidence_id, value})` returns `{operation_key, evidence:{id, captured_at, url}, value, counts:{candidate, eligible, unchanged, protected, excluded_exception, excluded_conflict, excluded_unsupported}, courses:[{course_id, code, title, level, campus, current, class, reason}], expires_at}`. The list is deterministic: same inputs give the same ordered list and the same operation key.

**Apply contract:** `admin_layer4_inbox('bulk_apply', {operation_key, course_ids, reason})` does the following:
- re-checks every selected course against the current state (value, lock, evidence version);
- applies in batches of `layer4.bulk_batch_size` through the existing decide path;
- records one outcome per course;
- returns the five outcome counts.

The same key is safe to retry: a course already applied under the key is reported **unchanged** and is not written twice. If the shared evidence has a newer version than the one previewed, the apply stops and the reviewer must preview again.

## 5. Safety rules carried into the build

- Platform Admin role only at first (D-B2). A reviewer role sees the preview but cannot apply.
- The on/off setting `layer4.bulk_review_enabled` is 0 by default. Passing tests does not turn it on.
- Never more than `layer4.bulk_max_courses` (proposed 500) in one operation; batches of `layer4.bulk_batch_size` (proposed 50).
- One controller per provider and field. A second preview for the same provider and field while one is open is refused; the first expires after `layer4.bulk_preview_ttl_minutes`.
- No direct SQL path: apply only through the RPC, which calls the existing decide functions.
- Rollback: per operation key, a superseding override event per course restores the before value recorded in `layer4_bulk_operation_items`. This runs through the same RPC with confirmation; nothing is deleted.

## 6. Affected components and estimate

| Work | Where | Estimate |
|---|---|---|
| Two new tables, three settings, catalogue and housekeeping rows | `supabase/migrations/…_cf247_ur18_bulk_review.sql` | 0.5 day |
| `bulk_preview` (eligibility classes per field, deterministic key) | `admin_layer4_inbox` (md5-guarded edit) plus a `security.layer4_bulk_preview_v1` helper | 1.5 days |
| `bulk_apply` (revalidate, batch, idempotent, read back) and rollback | `security.layer4_bulk_apply_v1` calling `layer4_review_decide_impl` | 1.5 days |
| Bulk panel in the university view | `src/Layer4Inbox.jsx` (new component file beside it) | 1.5 days |
| Contract spec and browser specs; isolated fixture | `tests/uat/cf-247-s205-bulk-review-contract.spec.mjs` (with `// Guards:` line) plus TEST-REGISTER | 1 day |
| Guides: SOP and Platform guide entries; release ceremony | `src/guide/sops.js`, `platformGuide.js`, CHANGELOG | 0.5 day |
| **Total** | | **About 6.5 working days**, low-risk fields first (country, state, campus, location); intake and English follow in a second release once D-B1 confirms them |

## 7. Test plan (direction §6)

All tests run against an isolated fixture: seeded provider, campuses and courses in the test schema, not the live catalogue. Production activation is a separate step.

| Case | Expected |
|---|---|
| Provider with 100+ eligible courses | Preview lists all; apply in batches; read-back equals the preview |
| Multiple campuses and states | Each course gets only its stated campus; no cross-linking |
| Online and on-campus delivery | Online courses not given a physical campus location |
| Mixed undergraduate and postgraduate English | Postgraduate courses excluded from an undergraduate policy |
| Course-specific English exception | Course excluded with the reason "course-specific rule" |
| Intake dates differing by programme | Only courses stated to follow the calendar are eligible |
| Manual values and locks | Listed as protected; never written |
| Concurrent reviewer change | Course changed after preview is reported as conflicted |
| Partial failure, then retry with the same key | First run reports partial; retry writes only the rest; no duplicates |
| Stale shared evidence | Apply stops; a new preview is required |
| Consumer visibility | After apply, the website API returns the new value for the applied courses only (read through the frozen API, no shape change) |

## 8. Metrics (direction §7)

From `layer4_bulk_operations` and `_items`: the following figures go in the Monday line, measured only:
- providers reviewed;
- candidate and eligible courses;
- fields admitted;
- exceptions excluded;
- locks protected;
- minutes per 100 records (preview opened to result shown);
- error or rollback rate;
- manual decisions avoided (applied courses minus operations).

## 9. Decisions needed from the Platform Admin

| # | Decision | Recommended |
|---|---|---|
| D-B1 | Eligible-field policy in section 3 (low-risk fields first; intake and English with the stated limits; AER excluded) | Approve as written |
| D-B2 | Role boundary: Platform Admin applies; reviewers preview only | Approve |
| D-B3 | Build and test against the isolated fixture, with `layer4.bulk_review_enabled` = 0 in production | Approve |
| D-B4 | Activation in production, field by field, after the fixture tests and one supervised provider | Separate decision after D-B3 |

Until these are recorded, settlement continues one item at a time under the v5 playbook, and nothing in this design is built.

## 10. Admission contract for catalogue gaps (resolved 1 Nov 2026 20:18 AEDT; direction 20:08 §1)

The direction asked whether the bulk path can reuse the existing admission and audit functions for courses that have no pending Layer 4 item, without assuming it. The live definitions say what follows.

| Existing function | Needs a pending review item? | Writes the consumer tables? | Use for bulk |
|---|---|---|---|
| `admin_layer4_inbox('decide')` → `security.layer4_review_decide_impl(item, action, reason, value)` | **Yes**: it loads `pipeline.layer4_review_items` by id and routes on its `field_code` | Through the field's apply function | Only after an item exists |
| `security.layer4_course_english_apply_impl(item, …)` | Yes | `catalogue.course_english_requirements` | English, through an item |
| `security.layer4_tuition_apply_impl`, `layer4_course_link_apply_impl` | Yes | Fees, course links | Not bulk fields |
| `security.layer4_override_apply_impl(entity, field, …)` | **No**: it works on the entity through `pipeline.layer4_field_registry` | **No**: it is an effective-value overlay (`pipeline.layer4_override_decisions`), read only by `layer4_effective_entity_read` and `layer4_effective_field_read`. The search projection and consumer API do not read it | Not suitable: a bulk value would not reach the website. Only `course.delivery_mode` and the campus address fields are registered; campus links, campus country or state, intake and English are not |
| Course–campus link, campus country or state, intake | No apply function exists for a Layer 4 decision | — | A new apply function is needed for each |
| Provider English policy: `pipeline.provider_policy_proposals` with `security.english_policy_in_force_v1` (Decision 262: one English policy in force per university and level) | Creates its own review items | `course_english_requirements` | **English bulk must use this existing policy path, not a new one** |

**Decision on the contract (proposed for D-B1 and D-B3):**
1. **The current decision RPC does not support gap records.** The bulk apply step must first create one review item per selected course, then decide it.
   - The item carries the field code, the shared evidence id, the before value and the proposed value, with `change_control_ref` = the operation key.
   - It is decided at once through `layer4_review_decide_impl('approve', …)` in the same transaction.
   - This follows the existing pattern of `security.coverage_admission_apply_v1`, which records admissions as decided review items.
   - Admission, `layer4_decisions`, `admin_control_events` and the search refresh signal are therefore the existing ones. No second admission system is built.
2. **New apply functions are needed**, written beside the existing ones and routed by `layer4_review_decide_impl` on new field codes. Each honours `pipeline.manual_locks` and the existing triggers. No catalogue table changes shape (G3):
   - `course_campus_link` writes `catalogue.course_campuses`;
   - `campus_region` writes `catalogue.campuses.country_id` and `subdivision_id`, campus-level and once per campus;
   - `course_intake` writes `catalogue.course_intakes`; the field code exists, with 10,931 superseded items, but there is no Layer 4 apply function today.
3. **Course location** (on-campus, online or mixed) writes `catalogue.courses.delivery_mode` through a new apply function. The override overlay is not used, because it does not reach the website.
4. **English** is not built as a new bulk path. Its group preview reads the provider policy proposals already in force (Decision 262) and lists the courses each would cover, with the section 3 exclusions. Applying them stays with the existing policy path.
5. **First release scope (D-B3):** country and state (campus-level), campus link and course location. Intake follows once its course-group evidence rule is tested. English is preview-only on the existing policy path.

**Estimate change:** add about 1.5 days for three apply functions and item creation. The total is about **8 working days**. Nothing is built until D-B1 to D-B3 are ratified.
