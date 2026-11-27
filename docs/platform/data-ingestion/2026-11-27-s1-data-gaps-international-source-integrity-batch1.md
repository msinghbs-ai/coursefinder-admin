# International Course Source Integrity — S1-Data-Gaps Batch 1 (source coverage, course-link integrity, provider website evidence)

**Chat:** S1-Data-Gaps | **Model:** Claude Sonnet 5.5 | **Date:** 27 November 2026 | **Design:** [International Course Source Integrity](../2026-11-27-international-course-source-integrity-design.md) (Admin #1271)
**Assignment:** SS-Programme-Control, 27 Nov 2026 11:28 AEDT. **Status:** read-only batch 1. Nothing was written to a link, a recipe, a source profile or a value. No spec or migration was claimed. Spend: US$0 (no Firecrawl, no AI route).

## 1. What this batch is, and is not

- **Is:** exact counts for the four priority providers and the 33 suspect links; the navigation pattern each provider appears to use; the identity suspects; and what each needs before a link can change.
- **Is not:** page verification. No rendered page was opened. The shell cannot reach provider sites, no stored page text is readable from SQL (S1-Build, 27 Nov 11:40), and the page-fetch tool was declined. The pattern evidence below comes from public search extracts and the stored link URLs. It is **observed, not qualified**. Per design section 4, no recipe is claimed qualified.

## 2. Measured (live, read through the rolled-back rehearsal, 27 Nov 2026)

| Provider | Active | No current official link | Links by audience | Active recipe |
|---|---:|---:|---|---|
| Swinburne University of Technology | 411 | 172 | international 237, untagged 2 | yes, generic domain pattern |
| Charles Darwin University | 175 | 21 | international 154 (all `www.cdu.edu.au/study/course/`) | yes, generic |
| Kaplan Business School | 34 | 5 | international 29 | yes, generic |
| Western Sydney University | 306 | 29 | not split here | yes, generic |
| WSU International College | 15 | 6 | not split here | yes, generic |

All five recipes are domain-scoped regexes (host plus an exclusion list). None carries an audience marker, state predicate or identity anchor, so none is audience-qualified.

## 3. The 33 international-tagged links with a domestic URL path (raised by S1-Build, s1294)

| Provider | Links | Shape of the domestic signal |
|---|---:|---|
| The Canberra Training School | 17 | subdomain `domestic.cbtc.edu.au/courses/...` |
| Step Into Training Services | 5 | path `sits.edu.au/domestic/<course>/` |
| Global Institute of Education | 2 | slug suffix `-domestic` (one URL, two courses) |
| Academy of Hypnotic Science (sia.edu.au) | 2 | path `/domestic-courses/` (one URL, two courses) |
| Envirotech, Hashm (Northwood), Salford, SIBT, UNSW College, Alana Kaye | 1 each | slug `domestic`, or `?studentType=domestic` (UNSW College) |
| Toi Ohomai (NZ) | 1 | slug `...-domestic-maritime-crewing-level-3` |

**Status of each: suspect, not corrected.** A URL is a signal, not proof. For example, "Building (Domestic)" is a qualification name. Two things stand out. First, two links appear on two courses each, so the same page serves two records. Second, UNSW College carries an explicit audience parameter, so a candidate international form is `studentType=international`. That form is **unverified**.

## 4. Provider website behaviour observed (inputs for S1-Build and S2-Build recipes)

| Provider / template | Observed pattern (design section 4 class) | Evidence level | Student link treatment proposed |
|---|---|---|---|
| **Swinburne** `/study/course/...` | Two shapes seen in public results: a dedicated international path `/study/course/international/<course>/` (with major sub-paths, for example `bachelor-of-science/biotechnology/`), and shared pages `/course/<course>` with an international switch on the course banner. Year-suffixed legacy paths also exist (`...-2022/`). | Search extracts only | Prefer the dedicated international path where it exists for the exact course and major. Otherwise use the shared page with the banner instruction. Retire year-suffixed paths. |
| **CDU** `/study/course/<slug>-<code>` | Same URL for both audiences. The page header offers "viewing as Domestic / International". The international fee block is visible on the shared page. A `?year=` parameter selects the year. Mixed visible sections (Commonwealth supported place residency text and international tuition fees). | Search extracts only | Shared link with an honest audience label. Preserve `?year=` only where it is the meaningful year. Fee and entry reads need section isolation, not whole-page reads. |
| **WSU** handbook | `hbook.westernsydney.edu.au/programs/<course>` is the current handbook (carries CRICOS and program code). It states both local and international application routes in one page. `handbook.westernsydney.edu.au/<year>/...` is a retired year path. A PDF twin exists. Marketing pages under `/future/study/courses/` show an "Entry requirements for international students" section. | Search extracts only | Shared handbook page, with the PDF as supplemental evidence. A current-year handbook URL replaces the year path. |
| **Kaplan Business School** `kbs.edu.au/courses/<slug>` | One page per course; links exist for the 11 master's rows checked. No link for Diploma of Commerce, General English, IELTS Preparation, Postgraduate Qualifying Program and Undergraduate Qualifying Program. | Stored URLs only | No audience behaviour observed yet. The five need a page search, not a new course. |
| **Canberra Training School, Step Into, others in section 3** | Separate domestic path or subdomain, so a separate international counterpart is likely. | Stored URLs only | Discover the counterpart. If none, the honest fallback applies. |

## 5. Identity suspects found

1. **WSU Graduate Diploma in Health Service Management (CRICOS 0101796).** The one active link is `handbook.westernsydney.edu.au/2023-2024/...`, tagged international and not primary. The code matches the current handbook page (`hbook...`, program 4777), so the course is right and the **link is a stale year path**, not a missing or new course. Related: "Master of Health Science (Health Services Management)" is a separate award (CRICOS 064020M) with its own page. The two must not be merged. No new course is proposed.
2. **CDU Master of Engineering.** Four active records share the title: CRICOS 068567K (105 weeks), 107552A (156 weeks), 118194E (105 weeks) and 118196C (156 weeks). Three of them (068567K, 107552A, 118194E) point at one page, `master-engineering-seng02`. CDU's own public pages describe a 2-year 160-credit-point Master of Engineering and a separate 3-year 240-credit-point one. **Suspect:** 107552A (156 weeks, three years) points at the 2-year page. This is a duration mismatch, not proof. Verification needs the page's CRICOS and duration fields.
3. **CDU Bachelor of Medical Laboratory Science Honours** (110435B, 116458B) and **Bachelor of Health Science/Master of Occupational Therapy** (three records): each group shares one URL. That can be legitimate (one page, several campus or mode offerings) and must be checked per record.
4. **CDU Bachelor of Education Early Childhood Teaching** (085153B and 0101027): no current link; the page search has not bound either.
5. **Kaplan locality:** the four Kaplan providers carry different scopes (KBS 34 courses; Kaplan International NZ 1; two Kaplan International Languages providers with 0 active; the Murdoch College / Adelaide College / Kaplan International College Adelaide combined provider with 26). The campus-locality gap needs the Feedback master row for the exact complaint. I did not have it here.

## 6. Existing governed writers (confirmed live, no write made)

`public.admin_course_link_edit` (Curator+ person), `security.layer4_course_link_apply_impl` (Layer 4 reviewed), `security.cf245_admit_official_url_record_v1` (official URL admission with evidence), `security.coverage_apply_course_v1` and `security.link_refresh_tick_v1`. Guards on `catalogue.course_links`: `manual_lock_guard`, `reactivation_guard`, `course_links_no_page_reopen`. A link change must go through one of these, with page evidence that proves identity and audience.

## 7. Blockers and what each needs

| Blocker | Why it stops verification | Needed |
|---|---|---|
| Page text cannot be read from SQL | Audience and identity proof need the rendered page | The worker path (stored copy, then $0 HTTP, then qualified Firecrawl actions) from S1-Build Phase B |
| No audience-qualified recipe or state predicate | The five generic recipes cannot prove a view | S1-Build and S2-Build qualify Swinburne, CDU and WSU first (section 4) |
| Link writes for the 33 and the CDU suspects | A change needs verified evidence and a named owner | See Decision S1-DG-5 |

## 8. Decision S1-DG-5 (for Platform Admin and S1-Build)

**Request:** authorise this order of work, with no new spend.

1. S1-Build runs worker-path verification, stored copy first and $0 HTTP second, on these cohorts: the 33 suspect links; the WSU Graduate Diploma in Health Service Management; the CDU Master of Engineering and Medical Laboratory Science Honours records; the 5 Kaplan Business School rows with no link; and 10 Swinburne courses chosen to hold both the `/international/` path and the banner-switch shape.
2. S1-Data-Gaps then submits the verified corrections through `cf245_admit_official_url_record_v1` or the Layer 4 course-link route, never a bulk relabel, and routes affected fee, AER, ELR and intake values to their owners.
3. Firecrawl actions are used only where the stored copy and $0 HTTP cannot show the audience, within the existing 1,500 credits per day cap.

**Recommendation:** approve. It follows the design's acquisition order and the existing writers.
**Consumer API impact:** none until a correction is admitted; G3 stays 75/48. **Risk:** low; nothing changes until verified. **Rollback:** a corrected link keeps its previous row (status history), so a wrong correction can be restored.

## 9. Routing of possibly affected values (nothing changed)

- WSU Graduate Diploma in Health Service Management: if its fee, entry or intake values were read from the 2023-2024 handbook page, they are year-stale. Owners: fee owner, S2-AER, S1-ELR, S2-Intakes. Not yet traced to evidence.
- CDU Master of Engineering 107552A: if fee, duration or entry values were read from the 2-year page, they belong to a different course. Same owners.
- 33 suspect links: any value read from a domestic page is domestic evidence and must not stand as international. Trace through DR-19 once verification identifies the pages.

## 10. Entry for the Drive reference (the connector edits file metadata only, so paste this into the International Course Source Integrity document)

> **v1.1 | 27 Nov 2026 | S1-Data-Gaps batch 1.** Read-only. Swinburne 411 active, 172 without a current official link; CDU 175, 21; Kaplan Business School 34, 5; WSU 306, 29. 33 international-tagged links have domestic paths (Canberra Training School 17, Step Into 5, others 11), suspect only. Observed patterns, unqualified: Swinburne dedicated `/study/course/international/` plus banner switch; CDU shared URL with audience header and `?year=`; WSU shared handbook, current `hbook.` host, retired year paths. Identity suspects: WSU Graduate Diploma in Health Service Management (stale 2023-2024 path, same CRICOS); CDU Master of Engineering 107552A (3-year record on the 2-year page). No link or value changed; no spend. Next: worker-path verification (Decision S1-DG-5). Canonical record: `docs/platform/data-ingestion/2026-11-27-s1-data-gaps-international-source-integrity-batch1.md`.

## 11. Batch 2: S1-DG-5 disposition and executable recovery (27 Nov 2026, 12:00 to 12:45 AEDT)

**Disposition (SS-Programme-Control 12:00):** option A under the existing source-integrity mandate; not a new spending or activation approval. Stored page evidence first, then free HTTP, then existing Firecrawl only where necessary.

**What the stored worker data shows (read through the rolled-back rehearsal, $0).**

| Provider | Bound page state | Parked requests (`source_proof_requests`) |
|---|---|---|
| Swinburne (411 active) | read 238 (CRICOS-proved 189, exact title only 49); **fetch_failed 165, every one HTTP 404 (dead address)**; identity mismatch 5; no page 4 | 176 held `no_route`; 9 locked; 1 relink done |
| WSU (306 active) | read 265 (CRICOS-proved 241, title only 24); **fetch_failed 35, all HTTP 404 (retired year handbook paths)**; no page 5 | 38 held `no_route`; 9 locked |
| CDU (175 active) | read 153 (CRICOS-proved 124, title only 29); identity mismatch 10; page refused 11 | 9 held `no_route`; 17 exhausted; 1 Layer 4 |
| Kaplan Business School (34 active) | read 29; identity mismatch 3; page refused 2 | 4 held `no_route`; 5 relink done (`relink_absent`, 1 to 3 attempts) |

**Named Feedback cases, from stored evidence (no page opened):**
- **FB-6.C02-04 Swinburne Bachelor of Business 063366D and 088382J:** both are bound to one shared page, `/course/undergraduate/bachelor-of-business/` (088382J proved by CRICOS code, evidence ec75a7be; 063366D by exact title, e65252b3). Neither stored read proves the audience; the page is the shared form, not `/study/course/international/`. Verification pending.
- **FB-6.C03-01 WSU:** Master of Health Science 064020M is bound to its course page by CRICOS code (evidence fb458668). Graduate Diploma 0101796 is a separate course bound to the retired 2023-2024 handbook path (evidence 0eb83389, now 404 on the host `handbook.`). The existing year rollover cannot repair it: the path holds a year range and the current handbook is on a different host (`hbook.`), which the rule refuses (same host only). Specialisation capture for 064020M stays with its owner.
- **FB-6.C05-01 CDU Doctor of Pharmacy 111117H:** bound to `doctor-pharmacy-spha01` by CRICOS code (evidence b37f2c4b). The course exists and has its link; searching by provider code is a search request for Atlas and the frontend owner.
- **FB-4A.7-01 CDU Occupational Therapy 118219A, 108296D, 0101041:** all three keep their own record and share one page (evidence 3a01ed5b, read 2 Nov); 118219A is proved by CRICOS code, 108296D by title. Nothing merged or relabelled.
- **CDU Master of Engineering 107552A (156 weeks):** bound to `seng02` by exact title only, so its identity is unproven (not a proven mismatch).
- **FB-5.3-25 and FB-5.3-30 Kaplan:** the 34-course provider and the separate Kaplan entities are read live by S1-Build. The five Kaplan Business School courses with no link (Diploma of Commerce, General English, IELTS Preparation, Postgraduate Qualifying Program, Undergraduate Qualifying Program): the first three have a candidate page on `kbs.edu.au/courses/` that the worker read directly (HTTP 200) and called an identity mismatch; the last two were matched to policy documents and refused. Three relinks found nothing, so they are not requeued (no unchanged futile retry).
- **The 33 suspect links:** all 33 have a stored read (identity: 30 by exact title, 3 by CRICOS code); 11 are parked `no_route`. Their audience can be checked against the stored copy by S1-Build's worker verification. They are deliberately not requeued here.

**Executable recovery released: s1302** (migration `20261130134500`, Pilot branch `s1-data-gaps-s1302`). One counted update moves the 227 parked requests at these four providers (Swinburne 176, WSU 38, CDU 9, Kaplan Business School 4) from held / `no_route` to the existing course relink route, queued. Course relink reads plainly (no model, no Firecrawl by this change), proves the exact CRICOS code, takes no candidate on a retired host and leaves hand-locked pages alone. No link, page, value, lock, job or setting is written by the migration. Rehearsed rolled back on live: 227 queued, cron 135, locks 7,585, consumer API 75/48.
Limit: a relinked page is proved for identity, not audience. The audience proof remains S1-Build's worker verification (phase B).

**Finding for S1-Build (shared, not changed here):** 5,031 requests platform-wide are held `no_route`, and the year-rollover rule cannot follow a host change or a year range (WSU `handbook.` to `hbook.`). Both belong to the shared source-selection work.

**Access:** this session still cannot open provider pages (fetch approval unanswered; Swinburne's site returned an error). Public search extracts are used only to choose what to verify. No page was admitted from them.

## 12. Batch 3: why the 227 were not taken, the fix (s1306), no_route classification and WSU findings (27 Nov 2026, 13:07 to 13:30 AEDT)

SS-Programme-Control 13:07 AEDT: S1-DG-6 disposition A plus bounded C under #1271; B optional where access exists (it does not here). No new spend, no protected activation. Independent check at 13:05: 227 still queued, four later course-relink runs succeeded with no recovery, 265 relink requests queued platform-wide, 5,026 held `no_route`.

### 12.1 Trace (live reads through the rolled-back probe route, 13:15 to 13:30)

| Step | Function or object | Finding |
|---|---|---|
| Eligibility | `security.work_item_eligible_v1('course_relink', provider, 'relink')` | Not the cause. The four providers' `course_relink` work items are stage `done` (eligible); lane not paused; `wc.relink_fair_on` = 1. |
| Asked signal | `security.source_proof_relink_asked_v1(course, since)` | Not the cause. A queued relink request newer than the last relink decision counts as asked, so a course with an old row is selectable again. |
| Order | `security.course_relink_order_v1()` | Counts a provider's pages only when `read_status` is in `relink.statuses` (`identity_mismatch`, `identity_refused`, `page_refused`, `refused_host`, `not_course_page`) or the page is on a retired host. |
| Selection | `security.course_relink_provider_v1()` | Same page test. The cohort's pages are `fetch_failed`: 186 HTTP 404, 1 no status; plus 31 read HTTP 200 (the audience suspects) and 1 unread. A dead page is on no list, so nothing in the cohort was ever selected. |
| Settlement | `security.course_relink_tick_v1()` step 2 | 156 cohort courses already had a relink row `trying` (Swinburne 134, WSU 22, started 18 Oct to 18 Nov). Their search rows were reset to `queued`, cand_idx 0, candidates kept, on 12 Nov by a person's Find course pages task (`provider_task_prepare_v1`). Step 2 moves on only a search row in state `found`; the paid title search cannot send (course page search share left today: 0). Nothing could move them. |

Cohort page state (227): fetch_failed/404 186, read/200 31, fetch_failed/no status 1, unread 1 (the 8 not listed are courses with no page row). Swinburne's dead pages are 2020 course-planner PDFs (164, `/app/web-course-planners/files/...`); WSU's are `/future/study/courses/<level>/<slug>` addresses (35) where the level folder does not fit the course.

### 12.2 Fix: s1306 (Pilot, migration `20261130153000`; three existing functions, no new queue, job, scheduler, table or setting)

- A page whose read failed with HTTP 404 or 410 is due for relink while a relink request is queued for its course. The request is the owner's release, so nothing is taken in bulk (1,029 other gone-page courses stay parked until their owners release them).
- A course's relink does not bind an address its own earlier relink already tried (all candidates when it ended absent; otherwise those up to and including the page now bound), so a dead address is not bound again.
- The md5 of the three live sources equals the s1196 text (checked before replacing); only these two changes differ. Shared with S1-Build (s1196 owner): both parts are additive and keep the retired-host rule.
- Rehearsal (rolled back, live data, after the migration): Swinburne 105 courses given candidates, 15 absent (limit 120); WSU 24 trying, 2 absent (limit 60); CDU 0 and Kaplan Business School 0 (their pages are not gone pages; CDU 9 are held for other reasons). A page counts as recovered only when the reader proves the CRICOS code on a candidate page.

### 12.3 The 5,025 held `no_route` requests by root cause

| Root cause (page state) | Requests | Existing mechanism | Release rule |
|---|---|---|---|
| No page row | 1,686 | Site map and course page search (discovery, then search within its share) | Not relink; owners release by provider after the site map lists the provider's course pages |
| Page read with identity | 1,665 | Not a source problem; the page is proved. Audience proof (S1-Build phase B, Pilot #1722) and the owner of the value held | Wait for audience inspection |
| Page gone (HTTP 404/410) | 1,029 | Course relink (now able to take them, s1306) | Per provider in priority order, feedback institutes first; never all at once |
| Fetch failed, other | 212 | Reader retry within its attempts | Reader's own retry |
| Blocked / robots disallowed | 164 / 149 | Existing rendering or the provider's permitted route | Not relink; routed to S1-Build / S2-Build reader qualification |
| Unread / too thin / needs render | 95 / 13 / 9 | Reader | Reader's own queue |
| Inactive course / other | 3 | None | Leave |

### 12.4 WSU and Swinburne findings (stored worker data)

- WSU has three handbook shapes in stored data: `handbook.westernsydney.edu.au/<YYYY-YYYY>/programs/<slug>/` (2021-2022 to 2024-2025; 104 bound pages, 103 read HTTP 200 and proved by CRICOS code, so stale-year, not dead), the older `handbook.westernsydney.edu.au/hbook/course.aspx?course=` form, and the current `hbook.westernsydney.edu.au/programs/<slug>/` seen in provider-published links (one program page, plus the root). The year rollover (`course_relink_year_url_v1`) matches a single four-digit segment only, so a year range is never rolled; it also keeps the same host.
- hbook is on the provider's own domain, but it is not on the provider's site map: discovery maps the recorded website host only (WSU mapped 29 Oct, 9,826 addresses, 53 course-like stored). No `provider_extra_domains` row exists for any of the four providers. Mapping hbook is the existing mechanism that lets relink find the current address from the provider's own list, with no URL guessing and no host replacement. Decision S1-DG-7.
- Swinburne's recorded website is `https://www.swinburne.edu.au/international` (map 157 addresses, 69 kept). Stored verified pages show the current course form `/course/<level>/<slug>/` (188 `degree-pathway` and others proved by CRICOS code; 49 by exact title). Stored lists hold a title match for only 9 of the 176 courses, so relink depends on learnt forms (3 forms, rehearsed above).
- CDU: 692 stored course-like addresses of the form `/study/course/<slug>-<code>?year=2026`; the 9 cohort courses are not gone pages (held for other reasons). Kaplan Business School: 48 stored addresses, `/courses/<slug>`; 4 courses, no title match.

### 12.5 Decision S1-DG-7 (raised in the reply to SS-Programme-Control)

Approve `hbook.westernsydney.edu.au` as an extra domain of Western Sydney University (`pipeline.provider_extra_domains`, a logged Platform Admin action), so discovery maps the current handbook and relink can take program pages from the provider's own list. No code change; withdraw by setting the row to `withdrawn`.

### 12.6 Handed on

- S1-Build: s1306 shares three of its functions (additive); phase B audience inspection (#1722) is the gate for every international or shared page; the `no_route` classification above; blocked and robots_disallowed pages (313) belong to reader qualification.
- S2-Build: Swinburne `/course/<level>/<slug>/` (with banner switch), CDU shared selector with `?year=`, WSU handbook (`handbook.` year ranges, `hbook.` `/programs/<slug>/`), Kaplan `/courses/<slug>`: observed in stored worker data, unqualified.
- Not done, with reason: no audience proof (needs #1722 or a person's access), so no link was corrected and no field recovery was routed yet.

### 12.7 Read-back after deploy (27 Nov 2026, 13:37 to 13:47 AEDT)

- **Live:** Pilot #1726 merged and deployed (merge `b2aac678`); migration head `20261130153000`; the three relink functions carry the gone-page and tried-address changes; audit event `relink_gone_pages` once; consumer API 75/48; locks 7,585; active cron 136 (other lanes; this change adds none).
- **Consumption (course-relink runs at :04, :14, ...; first run after deploy 13:44):** by 13:46 relink had taken 96 of the 227: Swinburne 58 trying and 14 absent, WSU 20 trying and 2 absent. Cohort search rows moved from 18 found to 71 found (165 queued to 99). The reader had read 17 of the first candidates, all HTTP 404 (Swinburne 9, WSU 7) or an identity mismatch (WSU 1). **Verified recoveries so far: 0.** A page counts only when the reader proves the CRICOS code on the candidate page; the next runs take the rest (up to 200 a run).
- **Wave 2 is not released.** Gone-page requests still held `no_route`, by provider: University of Sydney 240 (105 absent, 135 trying), Adelaide University 215 (retired host, s1196 route), University of Alberta 155 (CA), Torrens University 46, UNSW Sydney 29, Southern Institute of Technology 24, University of Western Australia 19, Bond 17. They are released per provider after the first wave's yield is read, so no unchanged futile retry is made (relink now leaves out addresses it already tried).

### 12.8 Audience signals from stored copies (S1-Build Phase B, `audience-inspect` run 45929486962, read only: no fetch, no model, no write; 100 pages)

| Provider and template (courses with a page) | View on the stored copy | Code on page | Reading |
|---|---|---|---|
| CDU `/study/course/*` (158) | international and domestic toggle on every page sampled (4/4) | 3 of 4 | One shared page for both audiences; needs an explicit audience instruction (selector and `?year=`), not a swap of address |
| WSU `/future/study/courses/{undergraduate,postgraduate,research}/*` (177) | toggle on all 11 sampled | 10 of 11 | Shared page with a toggle; same instruction rule |
| WSU `handbook.` `/YYYY-YYYY/programs/*` (about 104) | international or mixed words, no toggle | 24 of 25 | Stale-year handbook copies; the current handbook is on `hbook.` (S1-DG-7) |
| Swinburne `/course/{undergraduate,postgraduate,research,degree-pathway,tafe,inbound}/*` (233) | mixed (both audiences named), no toggle | 18 of 24 | Shared page; the international banner switch is not visible in the stored markup, so an instruction is needed |
| Kaplan Business School `/courses/*` (32) | mixed 2, international 1, none 1 | 3 of 4 | Shared; thin |

No sampled template exposes an audience query parameter, so no international address can be derived from a domestic one. Link integrity for these four providers is therefore "official, identity-proved, shared page" until S2-Build qualifies a template instruction; no link was changed on this evidence.

### 12.9 Lessons retained (operational learning)

- A relink selection list that omits gone pages starves exactly the courses that most need relink; a failed (404) page is a stronger reason to relink than a refused one.
- A person's Find course pages task resets a search row to queued and silently strands a relink row in trying; relink must re-select such a course rather than wait on the search.
- A repeat relink must leave out addresses it already tried, or a dead pattern guess is bound again.
- Stored discovery lists cover the provider's website host only; a sibling subdomain the provider links to (WSU `hbook.`) needs the approved extra-domain route to be mapped.
- Template audience on these four providers is shared (toggle or mixed); the audience instruction belongs to the template qualification (S2-Build), not to a per-course link swap.
