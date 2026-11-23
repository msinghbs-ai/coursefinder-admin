# S2-CF: official course URL and course description, baseline and findings

**Lane:** S2-CF (plan section 3a). **Spec:** s991 (claimed, Admin #825). **Date:** 23 Nov 2026, read-only measurements 14:30 to 18:20 AEDT on the live project, head `20261123100000`. **Nothing was changed in Pilot or on the live database. No coverage gain is claimed.**

## 1. Baseline (live)

| Measure | Courses | Share of 36,046 active |
|---|---|---|
| Active official course URL (`catalogue.course_links`, `official_course`, `active`) | 24,089 | 66.8% |
| Course description | 15,967 | 44.3% |
| No active official URL | 11,957 | 33.2% |
| No description | 20,079 | 55.7% |

## 2. The 11,957 courses with no active official URL (exclusive buckets, sum exact)

| Cause | Courses |
|---|---|
| Identity mismatch, page read (HTTP 200) | 4,491 |
| Page refused before identity could be checked | 1,362 |
| Failed fetch (404, blocked, robots) | 1,592 |
| Ambiguous shared page | 1,574 |
| No source found | 2,443 |
| Bound, not yet read | 281 |
| Bound, read, page check passes, not admitted | 50 (29 with no link, 19 with an inactive link) |
| Confirmed no page exists | 164 |

## 3. Findings that change the plan

1. **The identity matcher is right; it is not loosened (Platform Admin decision 23 Nov 2026).** In the 4,491 bucket the pages are mostly search results that are not the course page: aggregators (oneuedu, findthecourses, topaustraliauniversities), another provider's page, enrolment or admissions pages, a different qualification, and UTS `url_pattern` pages that return "Course not found" with HTTP 200 (150 soft-404 rows). Of 109 courses whose stored page title equals the course title, 0 are on a host the provider's own accepted links use. 4,986 of the page records carry no identity basis.
2. **About 8% of the accepted official URLs fail the platform's own current page check** (`security.course_page_check_v1`). Sample of 1,455 active links (md5 prefix): 117 refused, 8 unproven, 1,330 pass; scaled, about 1,900 of 24,089. Reasons: shared fee, application or list page; address names another course; older handbook year; another version of the award. Platform Admin decision: **keep the links as served and hold descriptions only** (no demotion, so the 66.8% headline is unchanged and includes these). Open: whether to demote later is the Platform Admin's call.
3. **Description gap, 20,079 courses:** 8,151 already hold an active URL; 6,452 of those have never had a machine admission attempt (none has a `course_description_first_read` item). Their latest description reading is skipped: "no proven course page" 1,873 (the page check refuses the linked page, item 2), insufficient verified facts 1,516, copied sentence 1,013, no reading at all 659, unsupported sentence 415, another course's page 252, earlier-prompt reread 226, no answer after 3 tries 92. Gap picker: `security.enrich_course_text_gaps_v1` (daily cap, 60 day recheck, per-provider pending cap). The s822 reread already marked 1,895 "no proven page" readings on 20 Nov; they were skipped again because the page check refuses them.
4. **Not a deterministic gain at $0:** 281 bound-unread pages are mostly fetch_failed, robots or blocked (a fetch, not an admission); the 4,491 identity mismatches are mostly genuinely wrong pages.

## 4. Batch 1 (claimed, Admin #825)

UBC (229 missing URLs, 501 missing descriptions), UTS (169, 289), Waikato (170, 183). Larger gaps at 17:55: Sydney 251, Newcastle 250, Adelaide 242, UNSW 199, Monash 181, Swinburne 172, Alberta 157. REQ-114 items for S2-CF: La Trobe 8 unpublished Nursing, James Cook Nursing discovery: not started.

## 5. Next build (s991, in order)

1. Persist a non-null `identity_basis` on every newly admitted link and refuse admission when the page record has none (the write paths found: `security.coverage_apply_course_v1`, `security.layer4_course_link_apply_impl`, `security.link_refresh_tick_v1`, `security.cf245_admit_official_url_record_v1`; the main read to link path still to be confirmed). 133 of 1,455 sampled active links have no basis on their page record.
2. Soft-404 guard on the read recorder (h1 or title "not found" with HTTP 200 is a failed fetch, not a mismatch), then re-pattern UTS-style URLs.
3. Admit the 50 pass-and-basis pages through the existing route (rolled-back rehearsal first).
4. Reason-coded gap codes on the 1,873 stuck descriptions (read-only report; a classification is not a gain).
5. Description: reread the 659 with no reading and the pass-page courses through the existing picker and rule chain; AI reads at the measured about US$0.00044 each, inside the existing cdesc ceiling; open an on-demand run with `security.on_demand_open_v1` and report actual cost.

## 6. Guardrails at measurement time
G3 untouched, manual locks untouched, no cron change, $0 Firecrawl, $0 AI spent by this lane (read-only SQL only).
