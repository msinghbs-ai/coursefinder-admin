# AU completion wave: check-ins

Mandate: Platform Admin, 26 Oct 2026 19:19 ("Heartbeat mandate — AU completion wave").
- **Cadence:** every 30 minutes, 07:00–19:00 AEDT. Overnight checks at 00:30 and 04:00.
- **Record:** `2026-10-26-au-completion-week.md`.
- **Definitions** (as in the 26 Oct workbooks): the 11 core fields; "automatic" = published provider, every missing core field in an automatic lane; "blocked" = everything else not complete.
- **Pace sources:** `pipeline.course_coverage_daily_by_country` (14 days) and today's observed change.

## 26 Oct 19:2x (first check-in, baseline for the next)

- **Values admitted since 17:00, AU:**

  | Field | Admitted | Note |
  |---|---|---|
  | Fees | +85 courses | another 371 fee rows written unverified; 400 of those await the re-apply paste |
  | English | 0 | |
  | Intakes | 0 | |
  | Links | 0 | |

- **Wave status:**
  - Published providers in lanes: 0 of 1,056 (paste not applied).
  - Courses touched: 0 of 9,454.
  - Fee schedules found / read: 243 / 0.
  - Entry-matrix first runs: none. The reader is staged and off, waiting for confirmation.
- **Queue health:**
  - `provider-facts` has not read the 243 AU schedule pages. Cause: the AU tuition proof list was empty until 19:1x. It is fixed; the next run is at 19:30.
  - `scholarship-course-attribute-full`: last run failed on a database deadlock (not an AU lane).
  - Other AU lanes moving. Fee reader queue: 348 done, 34 leased, 151 queued, 4 failed.
- **Spend:**
  - Firecrawl 961 / 25,000 today.
  - AI: fee reader US$1.24 / 5; enrich US$0.02 / 25; course match US$0.01 / 5; others US$0.
- **Gate:** 1 value admitted that failed a gate, which is red.
  - Course: Swinburne 087852C, Bachelor of Education. Fee US$36,300 for 2027, fee `ba434cf0…`.
  - Written live at 17:50 by the university adapter reading. The bound page's proof (`exact_title`) is not accepted for AU tuition.
  - It is the only such fee since R1 (24 Oct) in any country. The writer path is to be found.
- **ETA track** (snapshot 18:47: complete 5,439, automatic 310, blocked 20,354; target date Thu 29 Oct):

  | Outcome | Status | Arithmetic |
  |---|---|---|
  | All 11 fields ≥ 7,500 | **AT-RISK. MISSES: 7,500 by 29 Oct (projected at most 5,463)** | Needs +2,061 in 3 days (687 a day). The binding field is intakes: 14-day pace +111 (7.9 a day), today 0. Even if every new intake completed a course, that is at most +24 by Thursday. At that pace 7,500 is reached no earlier than mid-July 2027 |
  | Automatic ≥ 8,000 | **AT-RISK. MISSES: 8,000 by 29 Oct (projected about 515)** | 310 now; the paste adds 205 (the eligible courses whose missing fields are all in automatic lanes). 8,802 of the 9,454 eligible courses have a field marked "not on the course page": intakes 5,215, tuition 4,616, delivery 3,390, English 1,996. Publishing alone does not move them; only provider-level sources (fee schedules, calendars, English policies) and a delivery rule do. Delivery has no lane at all |
  | Blocked < 10,000 | **AT-RISK. MISSES: 10,000 by 29 Oct (projected about 20,150)** | 20,354 now; the paste moves about 205. Each remaining row carries a cause (workbook "Action needed" column). Owners are being added to the Thursday re-run |

- **Paste-ready files awaiting the Platform Admin:**
  - `docs/platform/pastes/PASTE-20261026-au-publish-eligible-providers.sql` (08:00);
  - the fee re-apply paste for the 400 held items, being prepared tonight.
