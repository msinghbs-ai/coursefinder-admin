# Scholarship and AER discovery completeness audit: AU, NZ, CA

**Read:** Thu 19 Nov 2026, about 11:30 to 11:55 AEDT, live project `fxcwkweaxjtknorudmwp`. S2-BOOST-Discovery, read-only.
**Method:** `select` statements only. No table, column, function, job or setting was added or changed (G3 stays 75 functions and 48 relations). No Firecrawl search, map or scrape was run, and no on-demand window was opened. Counts are as read; check the live system before relying on a figure older than a day.
**Cached sources and their build times:** `pipeline.course_attribute_coverage` built 10:58 AEDT; `pipeline.scholarship_provider_coverage` refreshed 10:29; `pipeline.aer_provider_coverage` updated 10:27. Everything else is read from the base tables at the time above.

## 1. Definitions used

| Term | Rule |
|---|---|
| Active provider | `catalogue.providers.lifecycle_status = 'active'`, country AU, NZ or CA, with at least one active course. |
| Provider with international courses (headline) | At least one active course with `open_to_international = true`. |
| Provider with courses not recorded as domestic-only (sensitivity) | At least one active course with `open_to_international` not false. In NZ 211 of the 290 active providers have no course marked international (flag unset), so the headline understates NZ. Both are shown. |
| (a) Official website | `catalogue.providers.website` holds an `http(s)` address. There is no "verified" flag on the provider. Evidence of verification is the discovery row: `search_verified_*` (found and checked by a search rule), `manual` (entered by a person), or neither (register value, not flagged). |
| (b) Scholarship crawled or published | A read scholarship listing page, a read scholarship page candidate, a read `scholarship_pages` row for one of its scholarships, or at least one active and published scholarship. |
| Scholarship hub discovered | Any active listing page, any page candidate, or any active scholarship record. |
| (c) Entry requirements read | An entry-matrix source with status `read`, a verified AER source inventory row, an active `provider_entry_matrix` row, or an active `course_entry_requirements` row for one of its courses. |
| Entry-requirements source discovered | Any non-inactive entry-matrix source, any AER inventory row, any matrix row, or any course entry requirement row (active or proposed). |
| (d) Zero discovered pages | No `provider_discovery_links`, `kept_count` 0, no scholarship listing page, candidate or record, no entry-matrix source, AER inventory row, matrix row or entry requirement, and no `coverage_course_pages` row. |
| No site | Zero discovered pages and no homepage. |
| No page | Zero discovered pages with a homepage held (the Coverage & completeness state `site_known`). |
| No reader | Coverage & completeness shows `no_reader` where the field register says a field has reader `none`. See section 4: this is a course-level state and applies to every course for academic entry. In this report a provider-level "pages found, nothing read" count is shown beside it. |

## 2. Denominator reconciliation (headline: `open_to_international = true`)

| Measure | AU | NZ | CA | Total |
|---|---:|---:|---:|---:|
| Active providers with international courses | 1,544 | 79 | 52 | **1,675** |
| Their active courses (all active courses of those providers) | 25,703 | 4,836 | 3,814 | 34,353 |
| (a) Homepage held | 1,440 | 79 | 52 | **1,571** |
| (a) of which verified by search | 193 | 0 | 27 | 220 |
| (a) of which entered by a person | 335 | 2 | 25 | 362 |
| (a) of which register value, not flagged | 912 | 77 | 0 | 989 |
| No homepage | 104 | 0 | 0 | 104 |
| (b) At least one scholarship page crawled or record published | 614 | 44 | 50 | **708** |
| (b) of which a published scholarship record | 64 | 12 | 15 | 91 |
| (c) At least one entry-requirements read | 751 | 46 | 0 | **797** |
| (b) and (c) both | 243 | 32 | 0 | 275 |
| (d) Zero discovered pages | 90 | 0 | 0 | **90** |
| (d) No site | 26 | 0 | 0 | 26 |
| (d) No page | 64 | 0 | 0 | 64 |
| Pages found but nothing read for scholarships or entry requirements ("No reader" at provider level) | 332 | 21 | 2 | 355 |
| Lacking a scholarship hub or an entry-requirements source | 1,288 | 45 | 52 | **1,385** |
| Lacking both | 400 | 19 | 2 | 421 |

Of the 1,675 providers, 275 have both a scholarship page crawled or published and an entry-requirements read, 955 have exactly one of the two, and 445 have neither. Of those 445, 90 have no discovered pages and 355 have pages but nothing read.

### Sensitivity: courses not recorded as domestic-only

| Measure | AU | NZ | CA | Total |
|---|---:|---:|---:|---:|
| Active providers | 1,544 | 290 | 52 | 1,886 |
| (a) Homepage held | 1,440 | 289 | 52 | 1,781 |
| (b) Scholarship page crawled or published | 614 | 86 | 50 | 750 |
| (c) Entry requirements read | 751 | 61 | 0 | 812 |
| (d) Zero discovered pages | 90 | 12 | 0 | 102 |
| (d) No site / No page | 26 / 64 | 0 / 12 | 0 / 0 | 26 / 76 |
| Pages found but nothing read | 332 | 167 | 2 | 501 |
| Lacking a hub or an entry-requirements source | 1,288 | 252 | 52 | 1,592 |
| Lacking both | 400 | 174 | 2 | 576 |

## 3. What the numbers say

1. **Canada has no entry-requirements source at all.** None of the 52 Canadian providers has a matrix, an AER source or a course entry requirement, and `aer_provider_coverage` holds no Canadian row (AU and NZ only). This is the reason Canada fills most of the list in section 5. It is a scope gap in the AER programme, not a discovery miss at 52 sites.
2. **Scholarships are the better covered side in Canada (50 of 52) and the weaker in AU (614 of 1,544).** In AU, 691 providers sit in the scholarship coverage state `empty` with disposition `searched_none_evidenced`, and 91 more in `empty` with `evidence_insufficient` (`pipeline.scholarship_provider_coverage`, all AU rows, read 10:29 AEDT).
3. **Most AU and NZ providers already have pages.** Only 90 providers (AU) have zero discovered pages. The larger group is 355 providers that have discovered pages and no scholarship or entry-requirements read, so the next crawl is a read job, not a discovery job.
4. **The 104 AU providers without a homepage** are the only ones where nothing can be crawled until a site is found: 26 have nothing else either (No site), and 78 have pages from other routes (33 have discovery links without a homepage held).
5. **Only 220 of 1,571 homepages carry search-verification evidence**, and 362 were entered by a person. The 989 register values are not flagged either way, so "verified official website" cannot be counted exactly from the provider record. A flag would need a column, which this audit did not add.

## 4. Coverage & completeness as the screen shows it (course level, all active courses)

| Field | State | AU | NZ | CA |
|---|---|---:|---:|---:|
| Academic entry | Admitted | 919 | 481 | 0 |
| Academic entry | **No reader** | 24,784 | 6,033 | 3,814 |
| Official course page | Admitted | 18,263 | 3,066 | 2,737 |
| Official course page | **No page** (`site_known`) | 5,077 | 3,137 | 775 |
| Official course page | **No site** (`no_website`) | 326 | 0 | 0 |
| English | Admitted | 16,425 | 2,392 | 2,017 |
| English | No page / No site | 3,862 / 326 | 2,726 / 0 | 331 / 0 |

- The register reader for `academic_entry` is `none`, so every course without an admitted entry-requirement record shows **No reader**, whatever the provider's discovery state. The screen therefore cannot tell a provider with no source from one whose source is read but not yet admitted. The provider-level counts in section 2 are the better measure of discovery; the AER Coverage panel (`aer_provider_coverage`) remains the measure of admission. This is recorded in `docs/platform/2026-11-12-aer-admission-mechanism.md` and is unchanged.
- No site and No page here are course counts, so they do not equal the provider counts in section 2. A provider with a homepage and no discovered course page is No page for its courses.

## 5. Top 30 uncovered providers (headline denominator)

Ranked by active course count among providers lacking a scholarship hub or an entry-requirements source. `Hub` is the scholarship hub, `AER src` the entry-requirements source. `Kept` is `coverage_provider_discovery.kept_count`; `Links` is the number of `provider_discovery_links`. Course counts are active courses; the international course count is in brackets where it differs.

| # | Country | Provider | Courses | Hub | AER src | Kept | Links | Scholarship coverage | AER state | Homepage |
|---:|---|---|---:|---|---|---:|---:|---|---|---|
| 1 | CA | University of British Columbia (UBC) | 575 | found | **missing** | 239 | 0 | published | none | https://www.ubc.ca |
| 2 | CA | University of Alberta | 379 | found | **missing** | 1,247 | 0 | published | none | https://www.ualberta.ca |
| 3 | NZ | University of Canterbury | 282 (202) | found | **missing** | 1,339 | 3,929 | published | not_discovered | https://www.canterbury.ac.nz |
| 4 | CA | Conestoga College | 270 | found | **missing** | 0 | 0 | evidence_insufficient | none | https://www.conestogac.on.ca |
| 5 | CA | University of Victoria | 234 | found | **missing** | 111 | 0 | published | none | https://www.uvic.ca |
| 6 | CA | Simon Fraser University (SFU) | 208 | found | **missing** | 113 | 0 | published | none | https://www.sfu.ca |
| 7 | CA | University of Lethbridge | 199 | found | **missing** | 690 | 0 | published | none | https://www.ulethbridge.ca |
| 8 | CA | University of Calgary | 179 | found | **missing** | 115 | 0 | published | none | https://www.ucalgary.ca |
| 9 | CA | Durham College | 144 | found | **missing** | 83 | 0 | protected_hold | none | https://durhamcollege.ca |
| 10 | NZ | Whitireia and WelTec | 116 (30) | **missing** | found | 218 | 535 | searched_none_evidenced | awaiting_layer4 | https://www.whitireia.ac.nz |
| 11 | CA | College of the North Atlantic | 105 | found | **missing** | 0 | 0 | evidence_insufficient | none | https://www.cna.nl.ca |
| 12 | CA | Sheridan College | 105 | found | **missing** | 437 | 0 | evidence_insufficient | none | https://www.sheridancollege.ca |
| 13 | CA | Camosun College | 91 | found | **missing** | 302 | 0 | evidence_insufficient | none | https://camosun.ca |
| 14 | CA | University of Manitoba | 88 | found | **missing** | 109 | 0 | published | none | https://umanitoba.ca |
| 15 | CA | Okanagan College | 80 | found | **missing** | 241 | 0 | evidence_insufficient | none | https://www.okanagancollege.ca |
| 16 | NZ | New Zealand Management Academies Limited | 77 (8) | found | **missing** | 121 | 84 | evidence_insufficient | not_discovered | https://www.nzma.ac.nz |
| 17 | CA | University of Northern British Columbia | 76 | found | **missing** | 937 | 0 | evidence_insufficient | none | https://www.unbc.ca |
| 18 | CA | Thompson Rivers University | 76 | found | **missing** | 2,066 | 0 | published | none | https://www.tru.ca |
| 19 | CA | Cambrian College of Applied Arts and Technology | 69 | found | **missing** | 122 | 0 | evidence_insufficient | none | https://cambriancollege.ca/ |
| 20 | NZ | Te Wānanga o Raukawa | 63 (3) | found | **missing** | 66 | 61 | evidence_insufficient | none | https://www.wananga.com |
| 21 | CA | La Cité collégiale | 61 | found | **missing** | 79 | 0 | evidence_insufficient | none | https://www.collegelacite.ca/ |
| 22 | CA | Algonquin College | 59 | **missing** | **missing** | 0 | 0 | not_yet_attempted_or_vendor_failure | none | https://www.algonquincollege.com/ |
| 23 | CA | Loyalist College | 57 | found | **missing** | 132 | 0 | evidence_insufficient | none | https://loyalistcollege.com/ |
| 24 | CA | Canadore College | 52 | found | **missing** | 54 | 0 | evidence_insufficient | none | https://www.canadorecollege.ca/ |
| 25 | CA | Athabasca University | 50 | found | **missing** | 864 | 0 | evidence_insufficient | none | https://www.athabascau.ca |
| 26 | CA | George Brown College | 49 | found | **missing** | 0 | 0 | evidence_insufficient | none | https://www.georgebrown.ca |
| 27 | CA | University of the Fraser Valley | 44 | found | **missing** | 697 | 0 | published | none | https://www.ufv.ca |
| 28 | CA | MacEwan University | 44 | found | **missing** | 60 | 0 | evidence_insufficient | none | https://www.macewan.ca/ |
| 29 | AU | George Brown College (NSW; not the Canadian college) | 44 | **missing** | **missing** | 53 | 585 | searched_none_evidenced | not_discovered | https://www.georgebrown.nsw.edu.au |
| 30 | CA | Vancouver Island University | 44 | found | **missing** | 53 | 0 | evidence_insufficient | none | https://www.viu.ca |

25 of the 30 are Canadian, 4 are NZ and 1 is AU. 29 lack an entry-requirements source, 3 lack a scholarship hub (rows 10, 22 and 29), and 2 lack both (Algonquin College and George Brown College NSW). For the Canadian rows the hub "found" comes from active scholarship records or candidates: 14 of the 25 are still `evidence_insufficient`, 9 are published, 1 is `protected_hold` and 1 (Algonquin) has not been attempted, so a hub is held but little is evidenced.

### Top 20 in AU and NZ only (where the AER programme runs)

| # | Country | Provider | Courses | Hub | AER src | Kept | Links | Scholarship coverage | AER state |
|---:|---|---|---:|---|---|---:|---:|---|---|
| 1 | NZ | University of Canterbury | 282 (202) | found | **missing** | 1,339 | 3,929 | published | not_discovered |
| 2 | NZ | Whitireia and WelTec | 116 (30) | **missing** | found | 218 | 535 | searched_none_evidenced | awaiting_layer4 |
| 3 | NZ | New Zealand Management Academies Limited | 77 (8) | found | **missing** | 121 | 84 | evidence_insufficient | not_discovered |
| 4 | NZ | Te Wānanga o Raukawa | 63 (3) | found | **missing** | 66 | 61 | evidence_insufficient | none |
| 5 | AU | George Brown College (NSW) | 44 | **missing** | **missing** | 53 | 585 | searched_none_evidenced | not_discovered |
| 6 | NZ | New Zealand School of Education Limited | 44 (11) | **missing** | **missing** | 55 | 64 | searched_none_evidenced | not_discovered |
| 7 | AU | Greenwich English College, Greenwich Management College | 42 | **missing** | **missing** | 0 | 64 | not_yet_attempted_or_vendor_failure | none |
| 8 | AU | Australian University College of Divinity | 41 | found | **missing** | 174 | 32 | evidence_insufficient | not_discovered |
| 9 | AU | Academy of Interactive Technology | 41 | found | **missing** | 33 | 19 | evidence_insufficient | not_discovered |
| 10 | AU | Canberra Institute of Technology | 38 | **missing** | found | 31 | 68 | searched_none_evidenced | awaiting_layer4 |
| 11 | AU | Box Hill Institute | 37 | **missing** | found | 35 | 216 | searched_none_evidenced | course_only |
| 12 | AU | Reach Community College Pty Ltd | 37 | **missing** | found | 46 | 102 | searched_none_evidenced | course_only |
| 13 | AU | York Business Institute Pty. Ltd. | 36 | **missing** | found | 56 | 34 | searched_none_evidenced | course_only |
| 14 | AU | Aventia Institute Pty Ltd | 36 | **missing** | found | 51 | 27 | searched_none_evidenced | course_only |
| 15 | AU | AAPoly, AMI Education | 36 | **missing** | **missing** | 44 | 56 | searched_none_evidenced | not_discovered |
| 16 | AU | Gold Coast Learning Centre | 36 | **missing** | found | 43 | 82 | searched_none_evidenced | course_only |
| 17 | AU | Australian College of Business Intelligence | 34 | **missing** | found | 78 | 92 | searched_none_evidenced | course_only |
| 18 | AU | Lead College Pty Ltd | 34 | **missing** | found | 63 | 109 | searched_none_evidenced | course_only |
| 19 | AU | Sydney Metro College | 34 | **missing** | found | 91 | 108 | searched_none_evidenced | course_only |
| 20 | AU | Macquarie English, Macquarie Institute | 34 | **missing** | found | 38 | 5 | searched_none_evidenced | course_only |

Provider ids for the 30 are in the appendix. The ranking changes as discovery proceeds, so re-run the section 1 rules before using it.

## 6. Limits of this audit

- **"International courses"** is the flag as held. 10,393 courses (all lifecycles and countries) have the flag unset. In NZ, 211 of the 290 active providers have no course marked international. The sensitivity table shows the difference.
- **"Verified website"** is inferred from discovery evidence, not a provider field (section 3, point 5).
- **A discovered hub is not a read hub.** The hub test is deliberately wide (any listing page, candidate or active scholarship record) so the list names providers with nothing found, not providers with little evidenced.
- **Course entry requirements count as an entry-requirements source** even when only proposed (9,107 proposed rows exist), so providers with proposed rows are not on the list and may still have nothing admitted.
- **Not measured:** page quality, whether a discovered scholarship page is current, domestic-only awards, and providers whose courses are all inactive.
- **No change was made** to any setting, job, table or function; no Firecrawl credit was used.

## Appendix: provider ids for the top 30 (same order as section 5)

1. `175462f3-59ea-4370-9c80-e7a06b100137`
2. `db436563-4650-4820-bd76-0695afcc953d`
3. `db910e88-67d1-4d2b-a65c-cea290aa0692`
4. `7b35d38d-08da-4aec-9110-c60e29dc0b45`
5. `98e591df-d272-481e-9054-2b85a66261be`
6. `d47b6006-396a-4785-b2ae-15186c3e7709`
7. `b509ab5c-87b2-4040-8385-d1ce610c7263`
8. `ad7bb2f7-ed12-4181-b5c4-d071db14bfda`
9. `c79c40ee-0939-4e2e-b9b3-b4e2d772e667`
10. `40f9891f-c8da-45cc-aced-154e63d41cff`
11. `4812a855-4fbc-43ce-9029-137c80327361`
12. `cc24d184-d9e1-4d8a-b6e5-812b3578d7ac`
13. `30f2a374-62e8-4be5-81fd-b94f033ea937`
14. `cffa9cab-0a3b-458b-8383-483ce622c9c3`
15. `5b6ad653-99f7-4347-a56e-f0d2928bd34d`
16. `5e1a25b3-94d3-4e9a-8cc1-98dacd3bfd62`
17. `0d47cf4f-7389-4d92-b7a7-8a2eba6ea1e6`
18. `7b493f26-269e-4d7e-94ae-ede842d96335`
19. `e924fe06-feb7-472b-9035-4ccebdf9fe67`
20. `f145b8e9-36dd-4f96-b1f5-bb453ced3a45`
21. `5675f806-596a-4982-bd4a-f068e013f974`
22. `4682bc05-a9de-44bb-ae66-ad02c9717a2d`
23. `6907453a-faa4-4c60-bc64-e2f2ea476a15`
24. `425b1fad-a4ef-4a21-8590-c7fa9b671107`
25. `e450a320-27d7-4ca2-8ad6-cafa266df869`
26. `dc671c35-5660-48ff-bb3b-31be971c0d9f`
27. `3273618f-8b4c-4584-bead-3ba193d84b1e`
28. `50efbfe2-b917-4cf7-be50-4a53c9a718d7`
29. `80e8f5fd-1b38-4292-90ab-adafc9884381`
30. `fd7048c4-9a0c-4c6f-818b-94ab6f6d809d`
