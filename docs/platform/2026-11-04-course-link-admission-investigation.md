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

| Group | Class | Items | What it is | Next step |
|---|---|---:|---|---|
| A | Decision 179: refused page, no page held or active | **2,323** | The binding check refused the page found; the refusal is recorded; the course has no page | Move to Course page needed (existing conversion), one university at a time |
| A | Course or provider retired | **28** | All Humber College (provider no longer active) | Supersede with the reason (reversible) |
| A | Duplicate pending | 0 | One item per course (the advisory lock holds) | — |
| A | Already identical to the active page (true no-op) | 0 | See note 1 | — |
| A | Decided before, no new evidence | 0 | One item re-proposes a page approved earlier, but with a new stored copy, so it is not settled | — |
| A | Decision 263 rule passes now | 0 | Adelaide 34 and Canberra 10 fail the validator (title-only, no held copy, pattern); Simon Fraser 47 fail (two pages held 29, pattern 18) | — |
| B | Stored copy exists, not linked | **153** | Mostly University of Auckland (115) and RMIT (10): binding refusals with a held page that arrived before evidence linking | Link the copy (records only); then the item is a person's (held page in dispute) |
| B | No stored copy | **13** | No copy of the proposed page | A read or a person; nothing automatic is started (no spend) |
| C | Old year in the held address (H13) | **187** | Melbourne 27, Macquarie 51, ANU 34, Sydney 19, La Trobe 18, Southern Cross 14, Queensland 10 and others | Keep if current, otherwise Enter the current page |
| C | Approved-rule university, item fails the rule | **91** | Adelaide 34, Canberra 10, Simon Fraser 47 | Decide by hand with the validator's reasons |
| C | CRICOS page differs from the held page (other universities) | **69** | Auckland 11, Whitireia, WITT, Victoria (CA), La Cité and others | Keep unless the new page is the course's own |
| C | Binding check refused the page the course shows | **52** | 44 exact, 8 differing only in case or trailing slash (e.g. Flinders `PHD`/`phd`, Wollongong slash) | Check the page; Enter the correct one if wrong |
| C | Held page in dispute (new page refused, held kept) | **14** | Plus the 153 in B once their copy is linked | Keep the page we hold |
| C | Refused page; the course has since got another page | **12** | | Refuse this proposal |
| C | E16 two pages | **9** | Melbourne 5 and others | Keep the page that names the award |
| C | Manual binding or lock | **5** | Adelaide 2, La Trobe, MacEwan, Waikato | Never touched by the platform |
| C | Proposed page off the provider's site | **2** | Whitireia `moodle.whitireia.ac.nz` (Monash `monash.edu` and Whitireia `whitireiaweltec.ac.nz` are listed aliases, so not counted) | Keep the page we hold |
| D | Information needed | 0 | A person supplies a page through Course page needed or Enter | — |
| | **Total** | **2,958** | A 2,351 · B 166 · C 441 · D 0 | |

Note 1. 63 items look like no-ops (the proposed page is the active page, or differs only in http/https, www, case or slash). None is: 52 are pages the binding check refused although the course still shows them, and the rest are E16 or H13 questions about the held page. The existing settlement reason `covered_by_active` (live, off) would have closed **252** such questions; this change corrects it.

Note 2. The off-domain split (2) and Whitireia counts are from the 17:56 host check; the remaining class split is from the 17:26 per-item read with the function's order replayed. The function itself gives the exact class per item once released (`security.course_link_backlog_report_v1()`).

Note 3. No item is claimed by a reviewer. The 10 UNSW refs the ChatGPT reviewer audited (batch L4B-20261103-1900, "left pending", awaiting an approved list) were not checked one by one here; the conversion skips only claimed items, so run UNSW last or after that list is settled.

### Per university (universities and institutes of technology with Course Link items)

| University / institute | Pending | A: Decision 179 | A: retired | B: technical | C: person | Main person classes |
|---|---:|---:|---:|---:|---:|---|
| Adelaide University | 205 | 164 | 0 | 0 | 41 | rule d263 fail 34, held page dispute 5, manual binding 2 |
| University of Auckland | 197 | 71 | 0 | 115 | 11 | cricos page differs 11 |
| Victoria University | 89 | 89 | 0 | 0 | 0 | — |
| University of Technology Sydney (UTS) | 89 | 87 | 0 | 2 | 0 | — |
| Swinburne University of Technology | 85 | 85 | 0 | 0 | 0 | — |
| Victoria University of Wellington | 76 | 73 | 0 | 2 | 1 | refused page course has page 1 |
| The University of Melbourne (UniMelb) | 72 | 32 | 0 | 0 | 40 | old year address 27, active page refused 7, e16 unclear 5, cricos page differs 1 |
| NorthTec | 72 | 70 | 0 | 2 | 0 | — |
| RMIT University (RMIT) | 71 | 60 | 0 | 11 | 0 | — |
| Eastern Institute of Technology | 66 | 64 | 0 | 2 | 0 | — |
| Universal College of Learning (UCOL) | 63 | 63 | 0 | 0 | 0 | — |
| Manukau Institute of Technology and Unitec - MIT | 62 | 62 | 0 | 0 | 0 | — |
| Whitireia and WelTec | 61 | 50 | 0 | 0 | 11 | cricos page differs 11 |
| Macquarie University | 61 | 7 | 0 | 0 | 54 | old year address 51, active page refused 3 |
| UNSW Sydney | 52 | 46 | 0 | 0 | 6 | cricos page differs 5, old year address 1 |
| University of Tasmania (UTas) | 49 | 44 | 0 | 4 | 1 | cricos page differs 1 |
| University of Waikato | 48 | 44 | 0 | 0 | 4 | cricos page differs 3, manual binding 1 |
| The University of Sydney | 48 | 26 | 0 | 1 | 21 | old year address 19, refused page course has page 1, cricos page differs 1 |
| Simon Fraser University (SFU) | 47 | 0 | 0 | 0 | 47 | rule d263 fail 47 |
| Massey University | 41 | 41 | 0 | 0 | 0 | — |
| Flinders University | 39 | 25 | 0 | 2 | 12 | active page refused 5, refused page course has page 2, held page dispute 2, cricos page differs 2, old year address 1 |
| University of Canberra | 38 | 23 | 0 | 2 | 13 | rule d263 fail 10, held page dispute 2, e16 unclear 1 |
| Otago Polytechnic | 37 | 36 | 0 | 0 | 1 | cricos page differs 1 |
| Federation University Australia | 37 | 37 | 0 | 0 | 0 | — |
| University of Calgary | 35 | 35 | 0 | 0 | 0 | — |
| Australian National University | 35 | 1 | 0 | 0 | 34 | old year address 33, active page refused 1 |
| Western Institute of Technology at Taranaki (WITT) | 34 | 29 | 0 | 0 | 5 | cricos page differs 5 |
| Monash University | 34 | 30 | 0 | 1 | 3 | cricos page differs 3 |
| Nelson Marlborough Institute of Technology (NMIT) | 33 | 32 | 0 | 0 | 1 | cricos page differs 1 |
| University of Alberta | 31 | 31 | 0 | 0 | 0 | — |
| Humber College | 29 | 0 | 28 | 0 | 1 | cricos page differs 1 |
| Griffith University | 29 | 25 | 0 | 2 | 2 | refused page course has page 1, active page refused 1 |
| Queensland University of Technology | 28 | 27 | 0 | 1 | 0 | — |
| Ara Institute of Canterbury | 28 | 25 | 0 | 1 | 2 | cricos page differs 2 |
| Waikato Institute of Technology | 27 | 26 | 0 | 0 | 1 | cricos page differs 1 |
| Southern Cross University | 27 | 11 | 0 | 2 | 14 | old year address 14 |
| Auckland University of Technology | 27 | 19 | 0 | 3 | 5 | active page refused 3, held page dispute 1, cricos page differs 1 |
| University of Canterbury | 26 | 23 | 0 | 3 | 0 | — |
| La Trobe University | 25 | 2 | 0 | 0 | 23 | old year address 18, e16 unclear 3, manual binding 1, cricos page differs 1 |
| Australian Catholic University | 23 | 1 | 0 | 1 | 21 | active page refused 21 |
| Torrens University Australia | 22 | 21 | 0 | 1 | 0 | — |
| The University of Queensland | 22 | 12 | 0 | 0 | 10 | old year address 10 |
| Southern Institute of Technology | 20 | 19 | 0 | 1 | 0 | — |
| Manukau Institute of Technology and Unitec - Unitec | 18 | 18 | 0 | 0 | 0 | — |
| University of the Sunshine Coast | 16 | 12 | 0 | 0 | 4 | cricos page differs 4 |
| Lincoln University | 16 | 16 | 0 | 0 | 0 | — |
| Curtin University | 16 | 14 | 0 | 0 | 2 | cricos page differs 2 |
| Toi Ohomai Institute of Technology | 15 | 15 | 0 | 0 | 0 | — |
| The University of Notre Dame Australia | 14 | 13 | 0 | 0 | 1 | refused page course has page 1 |
| Murdoch University | 14 | 14 | 0 | 0 | 0 | — |
| Central Queensland University | 14 | 8 | 0 | 0 | 6 | old year address 6 |
| Western Sydney University | 13 | 12 | 0 | 0 | 1 | held page dispute 1 |
| The Open Polytechnic of New Zealand | 12 | 12 | 0 | 0 | 0 | — |
| The University of Newcastle | 10 | 9 | 0 | 0 | 1 | active page refused 1 |
| Deakin University (Deakin) | 10 | 10 | 0 | 0 | 0 | — |
| Charles Darwin University | 10 | 10 | 0 | 0 | 0 | — |
| Charles Sturt University | 9 | 6 | 0 | 0 | 3 | held page dispute 2, old year address 1 |
| Melbourne Polytechnic | 8 | 8 | 0 | 0 | 0 | — |
| University of British Columbia (UBC) | 7 | 7 | 0 | 0 | 0 | — |
| Edith Cowan University | 7 | 6 | 0 | 1 | 0 | — |
| Bond University Limited | 7 | 7 | 0 | 0 | 0 | — |
| University of Otago | 6 | 5 | 0 | 1 | 0 | — |
| University of New England | 6 | 6 | 0 | 0 | 0 | — |
| University of Manitoba | 6 | 6 | 0 | 0 | 0 | — |
| Tai Poutini Polytechnic | 6 | 6 | 0 | 0 | 0 | — |
| University of Victoria | 5 | 1 | 0 | 0 | 4 | cricos page differs 4 |
| Kwantlen Polytechnic University | 5 | 5 | 0 | 0 | 0 | — |
| University of Northern British Columbia | 3 | 2 | 0 | 1 | 0 | — |
| British Columbia Institute of Technology | 3 | 3 | 0 | 0 | 0 | — |
| MacEwan University | 2 | 1 | 0 | 0 | 1 | manual binding 1 |
| University of the Fraser Valley | 1 | 1 | 0 | 0 | 0 | — |
| Thompson Rivers University | 1 | 1 | 0 | 0 | 0 | — |
| Mount Royal University | 1 | 1 | 0 | 0 | 0 | — |
| Other providers (colleges, schools, private) | 457 | 420 | 0 | 4 | 33 | — |

A = settled or moved under existing authority; B = technical; C = a person decides (with the class's recommendation). Decision 179 moves are not admissions: the course waits on Course page needed for a person to add the page, search again or record that no page exists.

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

441 items stay in Layer 4 now (C), plus the 153 B items once their stored copy is linked (most become "held page in dispute", recommendation Keep the page we hold), and 13 with no stored copy. Every card carries the class, a plain reason, the recommended decision and the evidence (official site, proposed site, held and active pages, refusal and its reason, binding basis and identity, stored copy and its identity basis, CRICOS or course code, manual lock). The 2,323 Decision 179 courses also still need a person, on Course page needed rather than in Layer 4.

Expected Layer 4 Course Link count after the reconciliation of every university: 2,958 → about 607 (−2,351), of which 166 are technical until linked.

## 5. Proposed Platform Admin decision (§9; not implemented, nothing active)

**Proposed rule CL-R1: keep the held page when the binding check refused a new page and the held page is proved by its registry code.** Ships as a Decision 263-style logged rule (`pipeline.layer4_course_link_rules` row and the existing executor), not as an automatic rule on arrival, until approved.

*Criteria (all must hold, checked again at execution):*
1. Raised by the binding check; exactly one page held when raised; that page is still the course's only active official page.
2. The proposed page is refused for the course in `pipeline.page_rejections`; the held page is not.
3. The course's binding (`pipeline.coverage_course_pages`) is the held page with identity basis `cricos_code` (Australia) or `nzqa_code` (New Zealand).
4. Course and provider active; no manual lock; binding not set by hand; item not claimed; university not owned by the parallel reviewer.

*Decision:* "Keep the page we hold" (reject), through `layer4_review_decide_impl` under the system automation account, the rule and approval named in the reason. Nothing changes on the website or Zoho (the held page stays).

*Exclusions:* Canada and other countries without a registry code; title-only, adapter-title, degree-name or AI-match bindings; any refused held page; two pages held; H13, H05, E16 and CRICOS-differs items.

*Expected impact (17:56):* **14 items** (University of Auckland 10; Ara, AUT, Flinders, Griffith 1 each). Small, because most held pages were bound by title or AI match, not by code.

*Option CL-R1b (not recommended yet):* drop criterion 3 (held page not refused and the only active page is enough): about **136** items. Risk: in the 3 Nov sample about 3 in 12 refused pages could be the course's own page, so a wrongly held page would stay. Recommend a 20-item sampled review first.

*Verification controls:* validator per item at execution; counting run first; per-university review pause; every decision in `pipeline.layer4_course_link_rule_run_items` and the decision CSV; `layer4_admission_check_v1` confirms the catalogue and projection are unchanged; reversible through the decision history.

**Not proposed:** an "exact CRICOS and title match on the official domain" rule that would *use* a proposed page. At 17:56 it would cover **0** items outside the rule universities (no waiting CRICOS-differs item has a code-based stored copy for its course against a title-bound held page), and among the Decision 179 refusals it would overrule the binding check, which the growth review found right in about 9 of 12 samples.

**Next candidate (needs reads, so a spend decision):** H13 old-year addresses (187): a no-year or current-year page check per university, like the Canberra rule.

## 6. Verification

- Fixture (PostgreSQL 16, production-shaped backlog of 165 items in production proportions; ten live definitions rebuilt from the repository and matched to the live md5s): C1 and R1–R9 pass; the migration applied twice changes nothing.
- Specs: s284, s32, s42, s57, s120, s273, `cf-247-course-links-contract`, s258, s267, s268, s269.
- Before → after: `security.layer4_resolution_for_v1(...)` 487fc2ec6283c95c4961255a860aa9fa → c5ec24cb4c1be5cc8d832a6c9e89dc19; `security.binding_refusal_route_v1(...)` 717fb44dd693550cb58f41a400aff455 → 54070a80e26df9c7aed12deb0c50bec7. New: `course_link_route_class_v1` 3eaaabca, `course_link_reconcile_v1` 47a94753, `course_link_backlog_report_v1` ad95e7c8, `course_link_site_v1` 9f493d7e.
- Before merge, the Integration Controller re-checks both live md5s.

## 7. §11 Course Link row (before reconciliation, 17:56)

| Kind | Pending | Automatically resolved | Technical holds | Human input | Review-ready | Decided | Admitted | Published |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| Course Link (`official_course_url`) | 2,958 | 0 so far; 2,351 available under existing authority (2,323 moves to Course page needed, 28 retired) | 166 | 0 | 441 | 338 rule decisions since 3 Nov (prior work) | 155 links changed (prior work) | 155 of 155 on Website v2, Zoho and Wix (morning measures) |

A move to Course page needed is not an admission and is not counted as one.

## 8. Query log and load windows

All times AEDT (Sydney). Heavy reads only at :x6–:x8; none at :35–:42 or :47–:48.

- 17:10:26 Q1 light: md5s of 10 functions + pending count (2958)
- 17:10:36 Q2 light: pending by source/reason
- 17:10:47 Q3 light: one sample per source
- 17:10:56 Q4 light: binding_refusal_route_v1 def
- 17:11:44 Q5 light: columns
- 17:11:52 Q6 light: metadata keys, owners, locks
- 17:13:08 Q7 light: settings
- 17:16:0x Q8 heavy: classification v1 -> statement timeout (cancelled by server)
- 17:18:45-17:20:41 Q9 heavy: classification v2 (2,958 items) -- SLIP: started in window, ran 1m41s past :18 (ended 17:20:41)
- 17:21:58 Q10 light: course_page_needed / supersession counts
- 17:27:27 Q12 light: md5s of 7 functions + Adelaide/Canberra validator (44 items, 0 pass)
- 17:27:39 Q13 light: held-page identity for binding/coverage items
- 17:26:13-17:26:15 Q11 heavy (in window): per-item dump of 607 non-Decision-179 items
- 17:56:22-17:56:23 Q14 heavy (in window): totals, Decision 179 per provider, resolution reasons (607), SFU validator, rule candidates, hosts, live md5s

**Slip:** Q9 started at 17:18:45 inside the window but ran until 17:20:41 (1 min 41 s past :18). Q8 (17:16) was cancelled by the server's statement time-out. No reads at :35–:42 or :47–:48.
