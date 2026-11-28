# ELR correction capability and IQ-00615 lookup: two scoped decisions (S1-Build, 28 Nov 2026)

**Status:** proposals for the Platform Admin. Nothing is built or changed. Instructions: PC-20261128-ELR-REFRESH-REVIEW (12:48), PC-20261128-NO-ROUTINE-DATA-PR, PC-20261128-FEEDBACK-TARGETED. Evidence: rolled-back reads of the live definitions and data, 28 Nov 2026 12:45 to 13:00 AEDT.

## 1. ELR correction capability inside the existing writer

### Where things stand

| Route | What it does to an existing active English row |
|---|---|
| `security.elr_det_record_v1`, `security.elr_band_record_v1` (deterministic course-page and band readers) | Refuse the course ("course already holds an English requirement (no overwrite)") |
| `security.layer4_course_english_apply_impl` (Layer 4 approval) | Inserts only, and sets an English manual lock |
| `public.admin_course_edit` (Curator, Catalogue course edit) | Inserts and updates; sets an English manual lock; deactivates active tests left out of the submitted set |
| Provider policy writers (`provider_english_*_v1`, `english_level_apply_v1`, `english_policy_in_force_v1`) | Policy-level updates, not course corrections |

So today a verified correction of an existing course row reaches production only as a data migration (s1330, s1336, s1346) or by a person. The person route suits governed exceptions, not routine refreshes, because it locks the field and can deactivate tests it was not asked about.

### Proposed capability: one correction mode in the existing ELR writer

The deterministic readers gain a `correct` outcome for a course that already holds an active row **for the same test**. Each reading is sorted into exactly one class:

| Class | When | What happens |
|---|---|---|
| **A. Automatic correction** | All of: a deterministic reading (`stated_minimum`, not a pathway); the course's bound, read page with an allowed identity; the same test; the same audience (international); the source is newer than the row's evidence (edition or capture date); the change is **only** (a) filling component minima the row does not hold, or (b) a value change where the row's own evidence is an earlier copy of the **same page**; no manual lock; no pending English Layer 4 item; no earlier person decision on the field (approved, edited or rejected) | In one transaction: the row is checked against its exact current value (precondition), marked superseded, and its verified successor inserted with the new evidence, a `replaces` link and an audit row; other tests untouched; search document refreshed; read back |
| **B. Person decision** | The source differs from the row's source; audience or scope is unclear; a regulated discipline; a page shared by several courses; more than one band named; a value would go down for an English test other than the one read | A Layer 4 `course_english` item with `before_value` (the current row), `proposed_value` and evidence; on approval the same precondition-checked replacement runs (the apply learns to replace a row only if it still equals `before_value`) |
| **C. Protected** | A manual lock; an earlier person decision on the field; a row written by provider policy in force | Held with its reason; never changed by the machine |

Duplicate protection: one correction per (course, test, evidence); a replay finds the successor and writes nothing. Nothing is deleted: the old row is kept as superseded.

### The decision requested

**Decision ELR-1:** grant the deterministic ELR writer authority to replace an active course English row **in class A only**, as specified above, live on release (no shadow), with `elr_det.audit_pct` audit sampling unchanged and class B going to the existing Layer 4 queue.

Until the decision, S1-Build builds nothing in this area; S1-ELR's verified corrections go to a Curator (Catalogue course edit) as governed exceptions, not as data PRs.

## 2. IQ-00615: the frozen course lookup

### Finding

`public.website_v2_course` (frozen, G3) finds the course twice per call with one query of the form `lower(course_stable_key) = k or lower(course_code) = k or course_id in (select … course_identifiers … upper(identifier) = k)`. Each arm has its own index (`course_documents_stable_key_lower_idx`, `course_documents_course_code_lower_idx`, `idx_course_identifiers_studysearch`), but the OR with a sub-select makes the planner read the whole of `search.course_documents` (34,361 rows removed, 14,037 buffers, 193 ms warm per query). No index can change that; only rewriting the query can.

### Parity proof (rolled back, 12:57 AEDT)

The rewrite: the same three lookups as a `union` of indexed queries (course stable key, course code, studysearch identifier joined to the documents), then the same count and the same order (`stable-key match first, then course_stable_key`).

| | Identifiers | Mismatches (count or chosen course) | Time |
|---|---|---|---|
| Current query | 89 (stable keys, course codes upper and lower case, studysearch identifiers plain and upper case with spaces, 4 that match nothing) | 0 | 41,857 ms in all (about 470 ms per call, two queries) |
| Rewrite | the same 89 | 0 | 191 ms in all (about 2 ms per call) |

### The decision requested

**Decision IQ-00615-1 (G3):** approve replacing only the two lookup statements inside `public.website_v2_course` with the proven union form (identical results, identical payload; consumer API baseline re-taken with `security.consumer_api_rebaseline_v1`, recorded as `-- Consumer API change approved: <who, when, why>`), and the same in any frozen sibling that holds the same statement. `website_v3_course` and Zoho v3 call v2 and gain the same speed. Notice to the website developer and Zoho: none needed for the contract (no field, value or behaviour changes); a one-line performance note is optional.
