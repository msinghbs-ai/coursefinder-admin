# Course Link admission: investigation, backlog classes and reconciliation (mandate 16:32 §3)

4 November 2026, development agent for the Integration Controller. Scope: Platform Admin mandate 4 Nov 2026 16:32 AEDT §3 (Course Link admission, first simplification pilot), the §10 Course Link tests, the Course Link row of §11, and the §9 rule (a new automatic rule is a separate decision). Production `fxcwkweaxjtknorudmwp` was read only. Nothing was written, switched on, decided or spent.

Branch `cf247-course-link-simplify` (Pilot), migration `20261104570000_cf247_course_link_simplify.sql`, spec s284, fixture `tests/fixtures/course-link-simplify/`.

## 1. Why new Course Links enter Layer 4 (trace)

| Stage | What happens | Code (live md5) |
|---|---|---|
| Discovery | The course-relink job (`course-relink`, every 10 minutes, `batch.course_relink` 200) and the coverage sweep search for a course's page (title, CRICOS, Firecrawl and AI-match lanes). Link refresh on Coverage › Courses runs the same lanes by hand. | `security.course_relink_tick_v1`; coverage sweep |
| Official-source validation and course identity | The binding check (E16, Platform Admin 2 Nov 07:21) tests the found page: level, award version, handbook year, shared page, another course's address, domestic page, provider host (with `binding.provider_host_aliases`). | `security.course_page_check_v1` (c8bf35fe) |
| Existing binding | A refused page is recorded in `pipeline.page_rejections` and never bound again. | `security.binding_refusal_route_v1` (717fb44d) |
| Authorised admission rule | Only the three Decision 263 rules (Adelaide keep held, Canberra no year, Simon Fraser no term), executed item by item by the Integration Controller. No rule settles an item on arrival. | `security.layer4_course_link_rule_execute_v1` (cafae1b6), validator (0cf77b67) |
| Layer 4 | Raised when: the binding check refuses a page and the course **has** a page (held page in dispute); the coverage sweep finds the CRICOS page at a different address; housekeeping H13 (old year in the held address) and H05 (course record names another page); E16 unclear (two pages). Since v2.15.447 a refusal for a course with **no** page goes to Course page needed instead (`layer4.page_needed_on` 1). | `binding_refusal_route_v1`; housekeeping; coverage sweep |
| Active link | A Layer 4 approval (or a rule) writes `catalogue.course_links` through `security.layer4_review_decide_impl` → `layer4_course_link_apply_impl`; a manual lock or hand-set binding is refused. | decide_impl (55353f19) |
| Website and Zoho | The search projection and the consumer API read the active official link (unchanged, G3). The admission check (`layer4_admission_check_v1`) verifies approvals reached the catalogue and projection. | consumer API frozen |

**Is any approved rule allowing automatic settlement?** Two existing authorities, neither automatic on arrival:

1. **Decision 179** (Platform Admin 3 Nov 2026 20:29; `nz-enrichment-brief/2026-11-03-layer4-course-link-growth-review.md` lines 45–46): "Refused pages with no held page: one needed list. They move to one "Course page needed" list grouped by university … The refused page stays recorded and history is kept. Items where a held page is in dispute stay in Layer 4." The approved recommendation (line 41) names the backlog: "The 2,252 existing items convert to it, keeping their history." Decision pack 2150 item 3 and its 07:05 reconciliation (line 67): "convert historical Course Link refusals to Course page needed, one university at a time, through `course_page_needed_convert_v1`. This runs after the Inbox performance release, with a review pause per university." The Inbox performance release is v2.15.462 (08:08). **Not yet run** (0 conversion calls at 17:22). This is a move to a needed list, not an admission.
2. **Decision 263** logged rules for Adelaide (207), Canberra (100) and Simon Fraser (59), already executed (338 decided). The growth review says "Do not act on the remaining Simon Fraser items merely because the first 59 pass."

The mandate grants no new authority (§2 A, §9).

## 2. The 2,958 waiting items, classified (production 17:18–17:28 AEDT, checked again at 17:56)

FINAL_CLASS_TABLE

### Per university (universities and institutes of technology with Course Link items)

PER_UNI_TABLE

## 3. What the reconciliation does, and under which authority

`security.course_link_reconcile_v1(provider, limit, apply)`: one university per call, `apply = false` counts and writes nothing. The Integration Controller runs it and pauses for review per university (Decision 179 condition).

| Class | Action | Authority |
|---|---|---|
| Course or provider retired, repeat, decided before, already the active page | Superseded with the reason in `pipeline.layer4_supersessions` (mode reconcile), reversible by `security.layer4_supersession_reverse_v1`. Not an approval or refusal. | Mandate 16:32 §3 (close with a recorded reason); the reasons of `security.layer4_resolution_for_v1` |
| Refused page, no page held when raised and none now | `security.course_page_needed_convert_v1` (existing; its own checks and audit) | Decision 179, decision pack item 3 |
| Stored copy exists but is not linked | `evidence_id` linked (records only, as `security.layer4_evidence_backfill_v1`) | `layer4.evidence_link_on` (on), mandate 3 Nov 20:47 §5 |
| Approved rule item that passes the validator | Counted only; the Integration Controller runs `layer4_course_link_rule_execute_v1` | Decision 263 (per rule) |
| Everything else | Stays in Layer 4 with class, reason and recommendation | — |

No manual lock, hand-set binding, page or consumer object is written. No AI confidence is used.

**Stopping new arrivals of these classes:**
- Decision 179 arrivals already stop (`layer4.page_needed_on` 1).
- `binding_refusal_route_v1` now compares page keys for "decided before" (717fb44d → 54070a80), so an http/https, www or slash variant of a decided page is not raised again.
- Repeats, decided-before, already-active and retired arrivals are stopped by the existing arrival guard (`layer4.arrival_guard_on`, off). It was **not safe** to switch on for Course Link: its "already active" reason would have closed 252 genuine questions (55 refused active pages, 188 old-year addresses, 9 E16 cases). `layer4_resolution_for_v1` is corrected (487fc2ec → c5ec24cb) so these stay with a person. After release, switching on the arrival guard and `layer4.reconcile_supersede_on` for Course Link is a separate Integration Controller or Platform Admin choice; this change switches nothing on.

## 4. What stays with a person

STAYS_TABLE

## 5. Proposed Platform Admin decision (§9; not implemented, nothing active)

DECISION_SECTION

## 6. Verification

- Fixture (PostgreSQL 16, production-shaped backlog of 165 items in production proportions; ten live definitions rebuilt from the repository and matched to the live md5s): C1 and R1–R9 pass; the migration applied twice changes nothing.
- Specs: s284, s32, s42, s57, s120, s273, `cf-247-course-links-contract`, s258, s267, s268, s269.
- Before → after: `security.layer4_resolution_for_v1(...)` 487fc2ec6283c95c4961255a860aa9fa → c5ec24cb4c1be5cc8d832a6c9e89dc19; `security.binding_refusal_route_v1(...)` 717fb44dd693550cb58f41a400aff455 → 54070a80e26df9c7aed12deb0c50bec7. New: `course_link_route_class_v1` ROUTE_MD5, `course_link_reconcile_v1` RECON_MD5, `course_link_backlog_report_v1` REPORT_MD5, `course_link_site_v1` 9f493d7e.
- Before merge, the Integration Controller re-checks both live md5s.

## 7. §11 Course Link row (before reconciliation, 17:56)

ROW11

## 8. Query log and load windows

QUERY_LOG
