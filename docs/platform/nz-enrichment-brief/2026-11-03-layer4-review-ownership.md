# Layer 4 review ownership register (single source; mandate 3 Nov 2026 20:47 §3)

**Integration Controller:** this Claude session. **Parallel reviewer:** the ChatGPT browser session reviewing and admitting Course Link items university by university.

## Rules

1. **Claim before you write.** Before any Layer 4 decision or logged-rule execution, the writer:
   - pulls this file;
   - confirms that the university and kind belong to it (or to no one, and claims them by adding a row);
   - reloads the item's live state (still pending, not claimed or changed elsewhere).
2. **Never write to another owner's items.** Claude never decides on a ChatGPT-owned item. ChatGPT never decides on a Claude-owned or engineering-only item.
3. **Every decision goes in the decision CSV.** Record it in `2026-11-03-layer4-university-review.csv`, append-only, with a stable batch ID, item ref and decision ID.
4. **Pause for deploys that change review behaviour.** When a deployment changes review controls, evidence interpretation, admission functions or manual-lock behaviour, the Integration Controller adds a pause row below. Review writes on the affected kinds stop until compatibility is validated and the pause row is closed.

## Ownership

| Since (AEDT) | Owner | University / scope | Kind | Refs | Basis | Status |
|---|---|---|---|---|---|---|
| 3 Nov 19:10 | ChatGPT browser reviewer | University-by-university Course Link review (batch L4B-20261103-1900 onward). It declares each university here before starting it | official_course_url | as declared | Mandate 20:47 §3 | Active |
| 3 Nov 21:00 | Claude (Integration Controller) | Adelaide University | official_course_url, approved address rule (207 candidates) | from the validation output | Platform Admin decision 20:29; Decision 263 logged rule | Validating. Executes only after item-level validation, with failed items left pending |
| 3 Nov 21:00 | Claude (Integration Controller) | University of Canberra | official_course_url, approved address rule (100 candidates) | as above | as above | Validating |
| 3 Nov 21:00 | Claude (Integration Controller) | Simon Fraser University | official_course_url, approved address rule (59 candidates only) | as above | as above | Validating. The remaining SFU items are not covered |
| 3 Nov 21:00 | Claude (Integration Controller) | The 24 audited refs (decisions 19:22 §1) | mixed | CSV batch L4B-20261103-1900 | Platform Admin approves item by item | Waiting for an approved list. Nothing submitted |
| 3 Nov 21:00 | Engineering only (no person decision) | Fee rows with the credit-point defect (IQ-00111); fee cards | provider_current_tuition* | per IQ-00111 | Mandate 20:47 §2 | Contained 21:10 (Platform Admin paste, 13 rows inactive); fix v2.15.442 releasing |
| 3 Nov 21:00 | Engineering only | Refused proposals with no held page → "Course page needed" (Decision 179) | official_course_url | about 2,252 | Platform Admin 20:29 | In development (branch `cf247-l4-course-link`). Not yet converted |
| 3 Nov 21:00 | Engineering only | VU 1323, Bond 1230 (approved reads); Macquarie 1184 duplicate; Prime 1176/1177 ownership | held_scholarship | 1323, 1230, 1184, 1176, 1177 | Mandate 20:47 §6 | In development (branch `cf247-sch-reads-ownership`) |

## Pauses

| From | To | Kinds | Reason |
|---|---|---|---|
| 3 Nov 23:30 | **Closed 3 Nov 23:38**: v2.15.447 verified live (md5s e79ce181, 4fc05d14, 1fb97548, 717fb44d; StudySearch Deployed UAT passed); Course Link reviewing may resume | official_course_url (Course Link), held_scholarship, provider_current_tuition* | **v2.15.447 deploy**: replaces `admin_layer4_inbox` and the inbox item/kind functions (stored-copy links, Course page needed pill, Refuse this proposal, duplicate route, Course code wording). Pause Course Link review writes until this row is closed. Keep, Use and Enter are unchanged in key, label and effect |
| 3 Nov 21:30 | v2.15.442 verified live | provider_current_tuition* (fee cards) | v2.15.442 changes fee admission (fee holds now stop the AI fee reader; unit counts no longer divided blindly). Fee cards are engineering-only; Course Link is not affected |
