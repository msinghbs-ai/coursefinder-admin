# Orphaned Layer 3 items and the delivery silent sample (27 Oct 2026)

Platform Admin mandate 27 Oct 2026 08:15, item 7. Read only; nothing was changed by this record.

## 1 The 19 English and intake items "awaiting Layer 3" (top-five universities)

**Finding:**
- **These 19 are not waiting for anything.** Each course's field was already read by the current governed path: the Enrich fields AI reader of the bound course page, on 23 Oct 2026.
- **Why the coverage build still shows them as "awaiting Layer 3":** it counts any `pipeline.layer3_work_items` row in `pending`, `reserved`, `failed` or `retry` as waiting. Their only such rows are `failed`. They date from 29 Sep–4 Oct and were released by the OpenRouter weekly limit, an Admin-control "send back", or a stale claim. Layer 3 was retired on 15 Oct.
- So the label hides each course's real state.
- **Disposition:**
  - each is given a named owner and reason (below);
  - no Layer 3 is recreated;
  - no status is invented;
  - nothing is moved to Layer 4, because there is no proposed value to review.

| Field | Course | Current-path result (23 Oct) | Owner and reason |
|---|---|---|---|
| English | UNSW: B Applied Exercise Science / M Clinical Exercise Physiology | page bound and read; "the page does not state it" | UNSW English decision (UNSW Bengaluru containment, item 6): source problem |
| English | UNSW: B Engineering (Hons) / M Engineering (Electrical) | page bound and read; "the page does not state it" | Same |
| Intakes | ANU: Bachelor of Arts; Flexible Double Degree – Engineering; Master of Demography; Master of Engaging Asia; MPhil School of Engineering | page bound and read; "the page does not state it" | Calendar decision path (MARK-FILE): ANU has no approved calendar. Source |
| Intakes | ANU: Bachelor of Economics | "the quote is not on the page" | Reader retry when the page changes. Reader |
| Intakes | ANU: B Finance, Economics and Statistics (Hons); GC Nuclear Science and Technology; GC Pacific Studies; Master of Contemporary Art Practices | "only a site-wide line mentions international" | Calendar decision path (MARK-FILE). Source |
| Intakes | ANU: Diploma of Liberal Studies; Master of Asian Studies; Master of Economic Policy; Master of Technology Governance | "the quote names no start month or semester" | Calendar decision path (MARK-FILE). Source |
| Intakes | Sydney: Bachelor of Science and Doctor of Medicine | page bound and read; "the page does not state it" | Calendar decision path (MARK-FILE). Source |
| Intakes | Sydney: Graduate Diploma in Rehabilitation Counselling | the page is a 2012 archive handbook, not the course page (mismatch) | Page lanes (official page search). Identity |
| Intakes | UNSW: Bachelor of Social Science | the handbook page failed to fetch; "no allowed source had a value" | Page lanes (re-read on schedule). Page |

**Wider effect, for a Platform Admin decision (not changed):**
- Across all countries, 449 course fields show "awaiting Layer 3" for the same reason: 330 intakes and 119 English.
- The underlying failed rows are 2,295 AU rows on 936 + 284 courses, plus CA and NZ.
- Correcting the label needs a decision to do one of two things:
  - stop the coverage build counting `failed` Layer 3 rows as waiting (a code change); or
  - park those rows (an existing status, `parked`) by a count-guarded paste.
- **Neither is done here.** Admitted values do not change either way; only the gap labels become true.

## 2 Delivery: the 20-page "genuinely silent" sample

Pool: 1,476 AU courses whose bound course page was read and judged "the page does not state it". The sample is fixed-seed: `md5(course_id || 'cf247-silent-sample')`.

**6 are page and identity work, not silent sources** (classified from the bound address):

| Course | Bound address | Why |
|---|---|---|
| USC: B Engineering (Mechanical) (Hons) | usc.edu.au/international/programs-and-fees/2026-international-student-tuition-fees | provider fee list |
| UMA College: Cert IV Community Services | uma.edu.au/fees/ | general fees page |
| George Brown College: Diploma of HRM | elearning.georgebrown.nsw.edu.au/course/index.php?categoryid=24 | learning-system category |
| John Paul College: Junior Secondary Years 7–10 | lms.jpic.com.au/topic/monitoring-course-progress/ | learning-system topic |
| Envirotech: Cert II Aquaculture | envirotech.edu.au/marine-courses | multi-course listing |
| Envirotech: Cert III Conservation and Ecosystem Mgmt | envirotech.edu.au/conservation-courses | multi-course listing |

**14 need actual page inspection.** Assigned to browser review by a person, because:
- the existing stored-page inspection route (`entry_inspect`) serves only entry-requirements sources;
- web reads of these addresses are blocked from the agent session.

The group is **not** declared exhausted. Each page is to be checked for a delivery statement. If one is found, it goes back to the reader as a reader miss; if not, it is a silent source.

| # | Provider: course | Bound address |
|---|---|---|
| 1 | IBMA: Diploma of Business | https://ibma.edu.au/product/bsb50120-diploma-of-business |
| 2 | Canterbury Technical Institute: Advanced Diploma of Business | https://cti.qld.edu.au/courses/business/advanced-diploma-of-business/ |
| 3 | Macquarie: Graduate Certificate of Business Administration | https://coursehandbook.mq.edu.au/2026/courses/C000387 |
| 4 | JCU: B Sport and Exercise Science (Hons) [End-on] | https://handbook.jcu.edu.au/course/2025/70609 |
| 5 | Envirotech: Diploma of Conservation and Ecosystem Management | https://www.envirotech.edu.au/international-diploma-of-conservation |
| 6 | Britts College: Certificate IV in Business | https://brittscollege.edu.au/certificate-iv-in-business |
| 7 | TAFE NSW: Bachelor of 3D Art and Animation | https://www.tafensw.edu.au/international/courses/bachelor-of-3d-art-and-animation--HE20620 |
| 8 | Australian University College of Divinity: Grad Dip Theological Studies | https://aucd.edu.au/courses/graduate-diploma-of-theological-studies/ |
| 9 | Macquarie: Master of Combined Studies in Creative Industries / Management | https://coursehandbook.mq.edu.au/2026/doubledegree/d001003 |
| 10 | Macquarie: Grad Cert of Research in Medicine, Health and Human Sciences | https://coursehandbook.mq.edu.au/2026/courses/C000414 |
| 11 | American College: Certificate III in Individual Support | https://americancollege.edu.au/cert-iii-individual-support-american-college-brisbane/ |
| 12 | Queen Anne Business College: Cert IV in HRM | http://jeg.nsw.edu.au/certificate-iv-in-human-resource-management |
| 13 | Workforce Education Institute: Adv Dip Leadership and Management | http://www.workforce.edu.au/bsb60420-advanced-diploma-of-leadership-and-management |
| 14 | Macquarie: Master of Combined Studies | https://coursehandbook.mq.edu.au/2026/doubledegree/d008520 |

No new delivery reader, and no inference from CRICOS locations.
