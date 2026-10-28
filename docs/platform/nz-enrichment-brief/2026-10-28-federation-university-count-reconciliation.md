# Federation University Australia — course-count and KBE reconciliation

Date: 28 October 2026  
Scope: review of KBE batch `L4B-20261028-1752`, the Layer 4 `195 active courses` figure and the Courses UI `229 matching` figure. Read-only live verification; no catalogue, queue or schema writes.

## Conclusion

There is no 34-course discrepancy at Federation University Australia. The Layer 4 figure of **195** is the university's current active-course count. The Courses UI figure of **229** is the result of the broader free-text search `fed` with Country = Australia and the default active-course filter:

| Provider matched by `fed` | Active courses |
|---|---:|
| Federation University Australia | 195 |
| Australian Federation College | 16 |
| Federation Academy | 12 |
| Federation Technology Institute | 6 |
| **Total shown in Courses UI** | **229** |

The live course-page read path, `security.admin_course_page_fast_base`, searches course title, display title, provider name, course code, stable key and StudySearch identifier. It is therefore not a provider-exclusive search. `src/mature-main.jsx` (`buildCatalogueArgs`) separately supports the exact `provider_id` filter and applies `lifecycle_status = active` by default. `src/Layer4Inbox.jsx` prints the selected university's `pick.courses` value as active courses.

**Operational answer:** in Courses, set **Provider = Federation University Australia** rather than relying on Search = `fed`. That returns the comparable 195-course scope. No recount, re-import or KBE retry is needed.

The UI caption `matching · any status` is only a label consequence of the default lifecycle filter not being present in the visible filter state; the request still applies active status. It did not cause the 229 figure.

## KBE batch review

The attached run report is internally consistent with the screenshots and live decision records:

- Three Course-link items were decided, all with reasons beginning `L4B-20261028-1752` and an evidence basis.
- The three review items are now `approved`; their recorded final values are the official Federation course URLs.
- Current course-entity review records for Federation University Australia contain no pending items: 3 approved and 67 superseded. The supplied Layer 4 screenshot also shows the provider queue empty.
- The reported operator error on `117557B` did not create a second decision. Exactly one decision exists for that review item.

| CRICOS | Course | Recorded final page | Review outcome |
|---|---|---|---|
| 117557B | Bachelor of Nursing | `/courses/dnn5-bachelor-of-nursing/` | Approved once |
| 088144A | Bachelor of Nursing | `/courses/dnn5-bachelor-of-nursing/` | Approved once |
| 107828M | Bachelor of Education (Early Childhood Education) | `/courses/dtk5-bachelor-of-education-early-childhood-education/` | Approved once |

For all three courses, `catalogue.courses.course_url` and `pipeline.coverage_course_pages.url` currently hold the new course page. The binding is `bound`, `read_status = read`, HTTP 200, with `identity_basis = exact_title`.

**Batch disposition:** close `L4B-20261028-1752` as complete. Do not replay the three items and do not continue to another provider under this batch.

## Separate apply-path finding — not a count problem

The audit found a separate Layer 4 hygiene issue that should not be conflated with the count reconciliation:

1. Each of the three courses still has the replaced scholarship URL as a second **active** `official_course` row in `catalogue.course_links`; the new reviewer-confirmed URL is also active. None is marked primary.
2. The existing canonical binding and read evidence predate the KBE decisions: the three coverage rows were bound and read on 22 October. Their `read_at` values did not change on 28 October.
3. The live `security.layer4_course_link_apply_impl` inserts or reactivates the reviewer URL and refreshes search. It does not retire the replaced URL, bind the page or request a fresh read. This is narrower than the Layer 4 choice text in `src/Layer4Inbox.jsx`: “The new page becomes the official page … it is read again and the adapter applies.”

This does **not** alter the conclusion that the three canonical course URLs are currently correct and readable. It does mean the generic apply behaviour and its UI promise need review, and the old scholarship links remain active-link hygiene exceptions.

## Next steps

1. **Now, no write work:** close the Federation KBE batch and use the exact Provider filter for future count checks.
2. **Decision before code:** open a small Layer 4 course-link apply follow-up. Define how an accepted replacement retires or supersedes the previous non-manual active link without deletion, how the accepted page is bound and queued for reading, and how existing manual bindings remain untouched. Include the UI wording and acceptance evidence in the same decision record.
3. **Data clean-up only after that decision:** assess the three old scholarship URL rows through the governed non-destructive path. Do not run ad hoc SQL, delete links or bulk-change active flags.
4. **Regression evidence:** the eventual Pilot change should prove one effective official page, preservation of the audit trail, no overwrite of manual bindings, and an actual read/adapter return path. Update `PIPELINE-LINEAGE.md` sections 1–2 if the write path changes.

## Evidence used

- Attached `Reconcile Federation University-20261028-2014.md`, including the batch checkpoint.
- Supplied Layer 4 Review and Courses UI screenshots, PIM Admin v2.15.360.
- Live read-only checks against project `fxcwkweaxjtknorudmwp`: provider/course counts, Layer 4 decisions and review status, canonical course URLs, active course links and coverage binding/read state.
- Coursefinder-Pilot: `src/mature-main.jsx`, `src/Layer4Inbox.jsx`; live functions `security.admin_course_page_fast_base`, `security.layer4_review_decide_impl` and `security.layer4_course_link_apply_impl`.
- `docs/platform/PIPELINE-LINEAGE.md` sections 1–2 for the canonical official-page binding and read model.
