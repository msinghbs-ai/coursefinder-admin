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
