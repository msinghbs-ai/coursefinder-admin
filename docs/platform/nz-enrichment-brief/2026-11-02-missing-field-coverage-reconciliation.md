# Missing-field enrichment: coverage reconciliation, reader map and extension plan (steps 1–3)

**Mandate:** Platform Admin, 2 Nov 2026 10:28 (`2026-11-02-missing-field-enrichment-mandate.md`), §9 steps 1–3.
**Input:** Wix developer hand-off, snapshot 2 Nov 2026 India time (`docs/integrations/wix/2026-11-02-AUSTRALIA_DATA_TEAM_HANDOFF.txt`).
**Prepared:** 2 Nov 2026, read-only workstream. No writes, AI calls, Firecrawl calls or commits.
**Code read:** Coursefinder-Pilot `main` at `d797a06b` (v2.15.402).

**How the live figures were taken (load policy, `PRODUCTION-VALIDATION-LOAD-POLICY.md`):**
- Read-only SQL on `fxcwkweaxjtknorudmwp`, run in the 10:45–10:47 and 10:55 AEDT windows.
- Each query took under 2 seconds. No failed or timed-out job runs in the 15 minutes before the first query.
- Sources were mainly precomputed tables: `pipeline.course_coverage_daily_by_country`, `pipeline.gap_cause_snapshots`, `search.course_documents` (the search projection), `pipeline.aer_course_outcomes`, `pipeline.field_register`, `pipeline.automation_catalogue` and `pipeline.component_register`.
- One query is **sampled**: AI cost per item uses a 5% `tablesample` of `pipeline.field_enrich_items` from the last 30 days.
- Consumer API: 3 single calls only, to confirm JSON paths: `website_v2_provider` for UQ, `website_v2_course` for one UQ course, and `website_v2_course_search` with page size 1.

**Scope words used below:**
- **Search scope:** the 23,732 Australian rows in `search.course_documents`, which is the population the Wix list audit saw. NZ has 6,495 rows and CA has 3,815.
- **Active scope:** the 25,380 active Australian courses in `catalogue.courses`, which the hourly coverage build measures (`course-coverage-build`, :47). 1,648 active AU courses are not in the search projection, so active-scope and search-scope counts differ.
- **University subset:** the 45 AU providers whose `ref.provider_types.code = 'university'`. They have 11,744 courses, which matches the hand-off.

---

## 1. Live coverage reconciliation (step 1)

### 1.1 Field table

"Proposed" means pending `pipeline.layer4_review_items` rows of that field code, across all countries; the table has no country column. "Held" means the coverage build state `blocked` (page blocked, robots or refused) in active scope, plus states noted in the cell. "Diff" is live missing minus the PDF figure.

| Field (mandate §4) | AU present (search scope) | AU missing | Proposed (Layer 4 pending) | Held / in progress (active scope) | NZ / CA present | Source table.column | Website API v2 path | Diff vs PDF and why |
|---|---:|---:|---|---|---|---|---|---|
| University description | 0 of 45 | 45 | none (no Layer 4 kind exists) | none: no reader (`field_register.p_description` reader `none`) | 0 of 8 NZ universities; 0 of all 1,279 AU, 289 NZ and 52 CA providers | `catalogue.providers.description` | Provider **detail only**: `item.description` (key present, value `null`). Not in `providers` list items | 0. The PDF read all 45 detail responses, so it is a true census |
| Course description | 163 (UQ 153, Federation 10) | 23,569 | none | none: no reader (`field_register.description` reader `none`); active scope 163 `admitted`, 25,217 `no_reader` | 0 / 0 | `catalogue.courses.description` (copied to `search.course_documents.description` for search text) | Course **detail only**: `item.description`. Not in search items (confirmed: no key) | PDF: 26 of 26 sampled empty. Consistent: none of the 163 is in the sampled providers. University subset: 163 of 11,744 |
| Course official URL | 17,735 | 5,997 | 50 `official_course_url` | blocked 397; candidate 170; page found 613; site known, no page 5,472; no website 308 | 3,045 / 2,669 | `catalogue.course_links` (`link_type='official_course'`, active), projected as `search.course_documents.official_course_url` | List and detail: `official_url` | +17. Live drift since the snapshot (links withdrawn under E15 and E16). University subset: 2,937 missing (PDF 2,920) |
| Intake month | 9,404 | 14,328 | 0 `course_intake` | in review 327 (Layer 3 or Enrich review, not Layer 4); awaiting Layer 3 299; candidate 99; blocked 405; page does not state it 8,239 | 2,154 / 1,614 | `catalogue.course_intakes.intake_label` (month) | List and detail: `intakes[].label`, `intakes[].month` | 0. University subset 5,097 (=) |
| Intake year | 0 | 23,732 | 0 | none | 0 / 0 | `catalogue.course_intakes.intake_year`: **null on all 31,516 active intake rows** | List and detail: `intakes[].year` (always null) | 0. The column exists, but no reader writes it |
| Exact start date | 0 | 23,732 | 0 | none | 0 / 0 | `catalogue.course_intakes.start_date`: 0 rows set | `intakes[].start_date` | 0. The column exists, but no reader writes it |
| Application deadline | 0 | 23,732 | 0 | none: `field_register.deadline` reader `none` | 0 / 0 | `catalogue.course_intakes.application_deadline`: 0 rows set | `intakes[].application_deadline` | 0 |
| Fee year | 8,385 | 15,347 | 29 `provider_current_tuition_validation`, 1 `provider_current_tuition` | provider tuition: in review 405; candidate 669; blocked 384; page does not state it 8,913 | 1,421 / 685 | `catalogue.course_fees.fee_year` where `fee_type='provider_current_tuition'` | List and detail: `tuition.year`; every year in detail `tuition_history[].year` | +9 (drift). `tuition.year` comes only from provider-current tuition. A course with only registered (CRICOS) tuition shows an amount with year `null`, because the register states no year. University subset 5,857 (PDF 5,848) |
| English requirements | 16,044 | 7,688 | 1 `course_english` | in review 55; awaiting Layer 3 114; blocked 125; page does not state it 3,976 | 2,364 / 2,010 | `catalogue.course_english_requirements` (active) | List and detail: `english_requirements[]` | 0. University subset 2,002 (=) |
| English minimum band | 8,594 | 15,138 | (as above) | (as above) | 2,177 / 1,612 | `catalogue.course_english_requirements.component_scores` | `english_requirements[].min_band_score` | 0. Band is null whenever the requirement row holds no component scores. University subset 5,218 (=) |
| Academic entry summary in search | 0 (by design) | 23,732 | 499 `course_entry_first_read` (Platform Admin, rank 6) | AER register, AU active: admitted course 243; admitted by provider table 2,207; awaiting review 3,613; identity unresolved 7,555; no course URL 1,669; excluded 10,042; no requirement published 45; unreadable 6 | n/a | `catalogue.course_entry_requirements`, `catalogue.provider_entry_matrix`; register `pipeline.aer_course_outcomes` | Search: `entry_requirements{summary, basis}` is English-only by contract (`basis: english_only`). Academic entry is **detail only**: `entry` (and `entry.resolution` with `edu_country`) | Not a data gap in search. The search projection never carries academic entry (developer guide 7.2). Coverage should be measured on detail `entry` |
| University academic entry matrix | 5 of 45 (active rows) | 40 | 34 AU universities pending `entry_matrix_first_run` (40 in all countries) | providers with rows by status: proposed 10, superseded 8, inactive 4, unverified 1 | n/a | `catalogue.provider_entry_matrix` (status `active`) | Provider detail: `entry_matrix[]` | 0. **34 of the 40 missing are read and waiting for the Platform Admin in Layer 4** |
| Scholarship structured amount | 858 of 892 | 34 | none | the 34 are `award_value_type='text_only'` | NZ 151 and CA 65 published, all classified | `scholarship.scholarships.award_value_type / award_amount / award_percentage` | `amount_type`, `amount_value`, `scholarship_percentage`, `value_classification` | 0 |
| Scholarship nationality restrictions | 60 of 892 | 832 | none | n/a | NZ 9, CA 2 | `scholarship.scholarships.nationalities` | `citizenship_eligibility[]` (filter `nationality_codes`) | 0. Empty means "not stated", not "open to all" |
| Scholarship application details | close date 474; open date 351 | close 418; open 541 | none | `application_required` null on 805 | NZ open date missing 73, CA 65 | `application_close_date`, `application_open_date`, `application_required`, plus `*_precision` | `application_deadline`, `application_open_date`, `deadline_is_rolling`, `automatic_consideration` | Close and open dates equal the PDF (418 and 541). The PDF's "automatic consideration unstated 624" is derived in the projection, not from `application_required` alone (805 null); not reconciled in this pass |

### 1.2 Descriptions in detail

| Measure | AU | NZ | CA | Notes |
|---|---:|---:|---:|---|
| Course description column exists | yes | yes | yes | `catalogue.courses.description` (text), copied into `search.course_documents.description` |
| Courses with a description (search scope) | 163 of 23,732 | 0 of 6,495 | 0 of 3,815 | AU: The University of Queensland 153 of 383; Federation University 10 of 195; the other 43 universities 0; all non-university providers 0 |
| Length of held course descriptions | 53–282 characters, average 137 | – | – | Short page summaries, apparently page meta descriptions captured by adapters. **No evidence ID, source URL or verification date is held for them**, so their provenance cannot be shown |
| Courses on a stored, bound, identity-proved page (`coverage_course_pages` bound, read, `identity_basis` set) | 16,650 (70%) | 2,812 | 2,726 | AU university subset 8,302 of 11,744 (71%). These pages can be re-read with no Firecrawl spend |
| Provider description column exists | yes | yes | yes | `catalogue.providers.description` |
| Providers with a description | 0 of 1,279 (0 of 45 universities) | 0 of 289 | 0 of 52 | |
| Stored provider About or Overview page | none | none | none | No About kind in `provider_fact_sources` (kinds: fee_schedule, english_policy, intake_calendar). `provider_central_search` keeps only the chosen candidate links, not the whole site map. All 45 AU universities have a `provider_central_search` row and a website |

AU university course counts and descriptions by provider (search scope; provider description is 0 for all 45):

| University | Courses | With description | With official URL |
|---|---:|---:|---:|
| UNSW Sydney | 667 | 0 | 467 |
| The University of Sydney | 655 | 0 | 403 |
| Monash University | 582 | 0 | 392 |
| University of Technology Sydney | 530 | 0 | 362 |
| RMIT University | 507 | 0 | 403 |
| Adelaide University | 498 | 0 | 257 |
| Flinders University | 476 | 0 | 394 |
| The University of Newcastle | 457 | 0 | 207 |
| The University of Melbourne | 441 | 0 | 382 |
| Swinburne University of Technology | 410 | 0 | 238 |
| The University of Queensland | 383 | **153** | 355 |
| Macquarie University | 380 | 0 | 232 |
| Australian National University | 374 | 0 | 372 |
| Curtin University | 373 | 0 | 302 |
| The University of Western Australia | 327 | 0 | 285 |
| Western Sydney University | 297 | 0 | 273 |
| Griffith University | 297 | 0 | 262 |
| Queensland University of Technology | 294 | 0 | 212 |
| Victoria University (main) | 279 | 0 | 133 |
| Murdoch University | 267 | 0 | 224 |
| University of Wollongong | 256 | 0 | 256 |
| Deakin University | 252 | 0 | 212 |
| La Trobe University | 248 | 0 | 242 |
| University of Tasmania | 221 | 0 | 123 |
| Federation University Australia | 195 | **10** | 114 |
| Torrens University Australia | 182 | 0 | 121 |
| University of Canberra | 182 | 0 | 126 |
| Bond University | 180 | 0 | 164 |
| Charles Darwin University | 175 | 0 | 154 |
| Edith Cowan University | 171 | 0 | 155 |
| Southern Cross University | 153 | 0 | 132 |
| Australian Catholic University | 149 | 0 | 142 |
| University of the Sunshine Coast | 148 | 0 | 108 |
| The University of Notre Dame Australia | 131 | 0 | 106 |
| University of New England | 130 | 0 | 105 |
| James Cook University | 127 | 0 | 122 |
| Central Queensland University | 106 | 0 | 88 |
| Charles Sturt University | 67 | 0 | 44 |
| University of Southern Queensland | 62 | 0 | 56 |
| Victoria University (second record) | 35 | 0 | 25 |
| Australian University of Theology | 29 | 0 | 11 |
| Avondale University | 21 | 0 | 20 |
| University of Divinity | 17 | 0 | 16 |
| USQ – Sydney Education Centre | 9 | 0 | 6 |
| UQ College | 4 | 0 | 4 |
| **Total (45)** | **11,744** | **163** | **8,807** |

### 1.3 Why live and PDF figures differ, or appear to

| Cause | Fields affected | Explanation |
|---|---|---|
| List versus detail | descriptions, academic entry, `tuition_history`, `entry_matrix` | `description` and `entry` are detail-only. A list audit cannot see them, and the hand-off rightly sampled detail for courses |
| Scope | every course field | The PDF counts the search projection (23,732). Coverage › Attributes counts active courses (25,380). 1,648 active AU courses are not projected to search |
| Null semantics | intake year, start date, deadline, band, nationality, scholarship flags | `null` means "not held". It is never "not offered", and it is never shown as an empty list. This matches the hand-off's reading |
| Projection gate | fee year | `tuition.year` comes from provider-current tuition only; registered (CRICOS) tuition has no year by source. Separately, the outcomes block depends on `search.enrichment_gates` (`provider_outcomes` approved) |
| Live drift | official URL (+17), fee year (+9) | E15 and E16 link withdrawals and normal admission between the India-time snapshot and 10:45 AEDT |
| Not yet admitted | entry matrix, academic entry | 34 university matrices and 499 course entry reads are pending in Layer 4 (Platform Admin, rank 6) |

---

## 2. Reader and job map (step 2)

Status column: catalogue job active or inactive in `cron.job`; component state from `pipeline.component_register`.

| Field | Existing reader or job (schedule) | coverage-sweep mode / function | AI prompt or field registry | Layer 4 kind | Status | Settings and limits | What extending it to the field would take |
|---|---|---|---|---|---|---|---|
| University description | **No reader.** Nearest: Enrich fields provider address (`field-gap-queue`, 23 */6; `enrich_ai` worker), `central-find` (2-59/5), `provider-facts` (*/10), `provider-contact-page` (*/3) | `enrich_ai` addresses branch: stored contact page, else the home page scraped once, then an AI quote check. `central_find` rules in `central.ts` | `field_register.p_description` reader `none`. `security.enrich_fields_v1` has no provider description. No `field_source_rules` row | none | all active | `gaps.scraper_reads_per_day` 200; `firecrawl.daily_share_central` 2,500; `firecrawl.daily_share_other` 1,000; `batch.central_find` 4; `enrich.page_chars` 24,000 | Add an About/Overview kind to `central.ts` RULES and a `provider_fact_sources` kind, so the existing `provider-facts` read stores the page. Add a `provider_description` branch to `enrich_ai` beside addresses. Add the field to `enrich_fields_v1` and `field_source_rules` (`ai_stored`, `scraper`). Register reader → `enrich` |
| Course description | **No reader.** Nearest: Enrich fields course page call (`field-gap-queue`; Enrich fields tasks), `coverage-read`, `coverage-reextract` | `enrich_ai` course_fields call (one call per stored page, quote must be on the page). The E16 guard (`course_page_check_v1` trigger) already stops refused pages from being read | `field_register.description` reader `none` | none | active | `enrich.ai_items_per_call` 40; `enrich.ai_pages_at_once` 10; `enrich.ai_calls_at_once` 20; `batch.enrich_fields` 1,200 items a minute; `gaps.items_per_run` 30,000; `gaps.recheck_days` 60 | Add `description` to the course_fields schema and prompt (verbatim overview quote, length bounds, no sibling award). Add the field to `enrich_fields_v1`, `field_source_rules` (`adapter`, `ai_stored`) and `svc_enrich_ai_record` / `enrich_apply_v1`. Register reader → `enrich`. The adapter-captured meta descriptions (163) need provenance or replacement |
| Course official URL | `course-link-search` (* * * * *), `course-link-search-worker`, `coverage-bind` (*/5), `coverage-ai-match-prepare` (*/2), `course-relink` (4-59/10), `course-url-fill` (daily 02:23), `link-refresh` (*/10), `coverage-admit` (*/10). `coverage-discover`, `coverage-discover-2`, `coverage-ai-match` and `course-link-reverse` are **inactive** | `link_search`, `ai_match`, `discover`, `reidentify`, `read` | E16 binding validation (`course_page_check_v1`) | `official_course_url` (kind course_link) | active (four jobs paused) | `batch.course_link_search_queue` 20; `batch.coverage_bind` 30; `batch.course_relink` 200; `firecrawl.daily_share_course_search` 13,000 | None needed. Coverage is limited by "site known, no page" (5,472 active) and "search and AI page match found none" (3,107). This is a capacity and pause decision, not a new reader |
| Intake month | `coverage-admit-intakes` (8-59/10), Enrich fields `intakes` (ai_stored), `central-ai` (*/5), `central-attach` (48) | `enrich_ai` intakes; `provider_facts` intake_calendar → `calendarStarts`; `security.enrich_parse_intakes_v1` | `field_source_rules.intakes` = ai_stored | `course_intake` (none pending) | active. `provider-calendar-intakes` and `provider-calendar-defaults` are **inactive**; `semester_intake_apply_v1` and `calendar_default_intakes_apply_v1` are **retiring** | `batch.coverage_admit_intakes` 300 | Biggest gap causes: "page gives no start dates; university calendar not found" 3,585 and "calendar approved but not for this study level" 1,729, both marked not automatic. Extension: level-aware calendar rules (below) |
| Intake year and exact start date | **No writer.** `calendarStarts` (`policy.ts`) already parses the year and day of each period start, but keeps only months and years | `provider_facts` intake_calendar; `enrich_ai` intakes | none | none | n/a | as above | Keep the year and the day `calendarStarts` already finds (day, month, year → `start_date`, `intake_year`). Have the course-page AI read return a year when the page prints one. Write to the existing columns only when the source prints them |
| Application deadline | **No reader** (`field_register.deadline` `none`) | `calendarStarts` explicitly skips closing and deadline rows | none | none | n/a | – | Teach the calendar parser to record "applications close" rows per period as `application_deadline`, with rolling-date wording kept as text, not as a date |
| Fee year | `fee-reader` (* * * * *), `fee-period-settle` (5-59/10), `provider-basis-rule-admit` (3-59/10), `fee-wording-rules` (37), `l4-rule-fee-year-align` (daily 03:27), `provider-fee-profiles-apply` (26), `provider-document-check-*` | `fee_ai`, `fees.ts` (`fee_year` in the row schema), `tuition_handoff` | `fees.ts` prompt (fee_year integer or null) | `provider_current_tuition_validation`, `provider_current_tuition` | active | `security.fee_reader_in_scope_v1` scope; Firecrawl shares | Already year-aware. The gap is provider-current tuition coverage (8,913 "page does not state it", 5,378 "site known, no page"), not year extraction. Registered tuition will always have year null |
| English requirements and minimum band | Enrich fields `english` (ai_stored), `coverage-admit` (*/10), `provider-english-defaults` (3-59/10), `policy-auto-approve` (5-59/10), `policy-add-tests` (17), `central-attach` (48) | `enrich_ai` english ('overall/lowest band'); `provider_facts` english_policy → `englishPolicy` | `field_source_rules.english` = ai_stored | `course_english` | active | `batch.coverage_admit` 500 | Band: the AI already returns "overall/lowest band", but rows from university policies often carry overall only. Extend `englishPolicy` to keep component minimums. Applicability: the "rule approved but not for this level" cause (1,076) needs level-scoped rules |
| Academic entry (course) | AER: `course_entry_*`, `entry_ai`, `aer-outcome-register` (*/5) | `entry_ai`, `course-entry.ts` (pinned model, sliced reads) | Enrich field `entry_requirements` (AU, NZ) | `course_entry_first_read` (rank 6) | active, **ingestion held** by the AER closure mandate (30 Oct) | `enrich.course_entry_*` | Not a reader gap. Release depends on Platform Admin review of 499 items and the AER hold |
| University entry matrix | `entry-matrix-read` (4-59/5) | `svc_entry_matrix_*` | — | `entry_matrix_first_run`, `entry_matrix_change` (rank 6) | active | — | Not a reader gap. 34 AU universities are waiting in Layer 4 |
| Scholarship structured amount | `scholarship-ai-extract` (* * * * *), `scholarship-recheck` (*/2), `scholarship-ai-backfill` (15:13), `scholarship-reread-cadence` (19:37) | `scholarship_ai`, `scholarship_reextract`, `scholarship.ts` | `pipeline.scholarship_ai_prompts` / `scholarship_ai_models` | none (held scholarships show in the Inbox as "Held scholarship") | active | `scholarship_setting(...)`; `firecrawl.daily_share_scholarships` 3,500; `scholarship_cap_per_uni` 150 | Queue the 34 `text_only` awards for `scholarship_reextract`, with a mixed-benefit outcome (tiers plus note) rather than forcing one value |
| Scholarship nationality | `scholarship-nationality` (3-59/10), `scholarship-audience` (41) | `scholarship_nationality_read_v1` (wording); `scholarship.ts` nationality rule ("citizens of", "nationals of") | — | none | active | — | It reads wording that is already stored. Extension: record "no restriction stated" versus "open to all stated" so an empty list is not read as worldwide |
| Scholarship application details | `scholarship-read` (*/5), `scholarship-recheck`, `scholarship-publication-review` (20:17) | `scholarship_read`, `scholarship_ai` | as above | none | active | as above | Status/date conflicts (three "open" awards past a 1 Nov deadline) belong to `scholarship-publication-review`. Make the nightly run date-aware |
| Coverage reconciliation (mandate §5 D) | `course-coverage-build` (47), `gap-causes` (55), `enrich-coverage-snapshot` (7), `provider-field-daily` (19:55), `aer-outcome-register` (*/5), `consumer-api-guard` (18:23), `website-sync-check` (* * * * *) | `security.course_coverage_build_v1`, `public.admin_field_coverage` | `pipeline.field_register` | n/a | active | `gaps.cause_keep_days` 14 | Already the D job. Add provider fields and the projection columns (search versus detail) to the existing build. No new job |
| Dispatcher (mandate §5 C) | `field-gap-queue` (standing "Fill the gaps", every 6 h), `enrich-plan-auto` (41), `enrich-plan-run` (*/5) | `security.field_gap_queue_tick_v1`, `enrich_plan_*` | `field_register`, `field_source_rules` | n/a | active; gap queue switched on since 21 Oct | `plans.priority_countries` = ["NZ"]; `plans.auto_open_max` 40; `plans.auto_per_run` 20; `gaps.*` | Already the C job. It picks up any field the register marks `enrich`. Adding AU to `plans.priority_countries` is a setting change with a reason |

---

## 3. Extension plan (step 3)

### 3.1 Per field

Cost basis:
- **AI:** measured average cost per item (5% sample of `field_enrich_items`, last 30 days):
  - course page fields US$0.0005–0.0011 (delivery 0.0007–0.0009, intakes 0.0008–0.0010, English 0.0005–0.0007);
  - provider address US$0.0014–0.0016;
  - course entry US$0.004–0.013;
  - title classification US$0.0001.
- **Firecrawl:** `coverage_vendor_usage`, last 30 days:
  - provider_facts_scrape 2,405 credits over 1,386 reads (1.7 credits a document);
  - central_map 1 credit a provider;
  - enrich_address 1 credit a home page.
- These are estimates from existing measured costs, not quotes.

| Field | Smallest extension | `-- Replaces:` / `-- Retires:` intent | New job? | Admission | AU volume | Estimated cost per 100 records |
|---|---|---|---|---|---:|---|
| University description | Add an About/Overview kind to `central.ts` (`CentralKind`), read by `provider-facts`. Add a `provider_description` branch to `enrich_ai` modelled on addresses: stored page first, home page once only if needed. Prompt: factual, from the page only, no rankings or claims not on the page, every sentence quoted. Add to `enrich_fields_v1` and `field_source_rules` | Replaces: `security.enrich_fields_v1` (one field), `svc_enrich_ai_next`, `svc_enrich_ai_record`, `field_register` reader for `p_description` (none → enrich). Retires: "No reader yet" for `p_description` | **No.** `field-gap-queue` and `enrich-plan-run` dispatch it | **Layer 4, new provider kind** (proposed `provider_description`): every first proposal per provider is reviewed. 45 items is a bounded queue | 45 (then 1,234 other AU providers by setting) | about 100 map + 170 scrape credits; AI about US$0.15–0.30 |
| Course description | Add `description` to the existing `enrich_ai` course_fields call on the stored, identity-proved page (16,650 AU pages, no Firecrawl). Prompt: the course's own overview paragraph quoted verbatim, minimum and maximum length, refuse text naming another award level. Quote must be on the page (existing check). Never overwrite a value locked by hand | Replaces: `security.enrich_fields_v1`, `svc_enrich_ai_next` / `svc_enrich_ai_record` / `security.enrich_apply_v1` (description branch), `field_register.description` (none → enrich). Retires: nothing. The 163 adapter descriptions are kept until replaced by an evidenced value | **No** | **Existing policy** (page-proof admission as for English and intakes: bound page, E16 pass, verbatim quote), plus a **first-run sample per provider in Layer 4** (pattern of `no_page_first_run`, with sampling audit 1 in `layer4.auto_admit_sample_rate`) | 23,569 missing; 16,650 have a stored page now | AI about US$0.05–0.10 when added to a call already made for that page, or up to US$0.10–0.15 alone; Firecrawl 0 on stored pages |
| Official URL | No reader change. Decide whether to resume `coverage-discover` / `coverage-ai-match` within `daily_share_course_search` | Replaces: nothing. Retires: nothing | No | Existing (`official_course_url`, E16) | 5,997 | Search: about 2 credits a course |
| Intake month | Level-aware calendar rules: let an approved university calendar apply to the study levels it names. This answers the 1,729 "calendar approved but not for this level" | Replaces: `security.english_level_apply_all_v1`-style level rule for calendars (the intake twin). Retires: `semester_intake_apply_v1`, `calendar_default_intakes_apply_v1` (already retiring) | No | Existing calendar proposals (`provider_policy_proposals`), `policy-auto-approve` | 14,328 | Stored calendar documents: 0 credits; AI about US$0.08 |
| Intake year, exact start date | Keep the day and year `calendarStarts` already matches; write `intake_year` and `start_date` only when printed. Course-page AI returns a year only when printed | Replaces: `calendarStarts` output shape (months → dated periods), `security.enrich_parse_intakes_v1`. Retires: nothing | No | Existing calendar approval (a person approves a university calendar once, `provider_policy_proposals`) | 23,732 (bounded by calendars found: 413 read documents, 188 providers) | 0 credits (413 stored calendars) |
| Application deadline | The same parser records "applications close" rows per period, with rolling or "check with provider" wording as text, never as a date | Replaces: `calendarStarts`. `field_register.deadline` none → coverage | No | Existing calendar approval | 23,732 | 0 credits |
| Fee year | No new extraction. Raise provider-current tuition coverage through `fee-reader`. Show registered tuition's year as not stated by the register | Replaces: nothing | No | Existing (`provider_current_tuition_validation`, `l4-rule-fee-year-align`) | 15,347 | Fee reader measured cost not taken in this pass |
| English, minimum band | `englishPolicy` keeps component minimums. Level-scoped university rules for the 1,076 "rule approved but not for this level" | Replaces: `englishPolicy` output, `english_level_apply_all_v1`. Retires: nothing | No | Existing policy approval (`policy-auto-approve`, Layer 4 › Attributes) | 7,688 / 15,138 | Stored policies: 0 credits |
| Academic entry, entry matrix | None. Release the 34 AU matrix items and 499 course entry items through Layer 4 | – | No | Existing AER kinds (rank 6) | 40 / 23,732 | already spent |
| Scholarship amount | Queue the 34 `text_only` for `scholarship_reextract` with a mixed-benefit outcome | Replaces: nothing | No | Existing scholarship publication rules | 34 | Small: re-reads of stored pages |
| Scholarship nationality | Record "restriction stated / none stated / open to all stated" | Replaces: `scholarship_nationality_read_v1` output | No | Existing | 832 | 0 (stored wording) |
| Scholarship application details | Date-aware status in `scholarship-publication-review` (deadline passed → `closed` or `check_provider`) | Replaces: `scholarship_publication_review_v1` (status rule) | No | Existing | 418 / 541 | 0 |

A new job is **not** needed for any field. Mandate §5 A–D map to existing jobs:
- A (provider descriptions) and B (course descriptions): `field-gap-queue` and `enrich-plan-*`, with new Enrich fields.
- C (dispatcher): `field-gap-queue`.
- D (coverage reconciliation): `course-coverage-build`, `gap-causes` and `provider-field-daily`.

### 3.2 Field-state mapping (mandate §6)

| State | Existing status and evidence that supports it | Gap | Exposing it to Wix |
|---|---|---|---|
| `available` | Value present: `course_attribute_coverage.state='admitted'`; active row in `course_links`, `course_fees`, `course_intakes` or `course_english_requirements`; scholarships `publication_status='published'` | none | Today implied by a non-null value |
| `not_provided` | `course_attribute_coverage.state='not_on_page'`; `field_enrich_items` skipped with "the page does not state it"; gap cause "AI: the page does not state it"; no-page record "not published by the provider" (`no_page_trust`) | not distinguished from "not checked" in the API | **G3: a new field** (proposal only) |
| `processing` | `in_queue`, `awaiting_l3`, `candidate`, `page_found`, `site_known`; `field_enrich_items` queued, waiting, ai or leased; `coverage_course_pages.read_status` not yet read | none internally | G3 new field (proposal) |
| `under_review` | **Only** a pending `pipeline.layer4_review_items` row for the entity and field code | The coverage build's `in_review` also counts Enrich-field `review` and Layer 3 `layer4_required`. **Neither is a Layer 4 item.** The state must be built from `layer4_review_items` alone | G3 new field (proposal) |
| `held_quality` | `enrichment_flags` (raised flags), `security.enrich_item_held_v1` hard holds, `page_rejections` and `identity_refused` (E16), fee `held_partial`, scholarship `unpublished` or `withdrawn`, the SS-007 remediation hold | none internally | G3 new field (proposal) |
| `not_applicable` | Partly: registered tuition outside AU (coverage `l1` rule); conjoint or double degree with no page of its own; `international=false` for international-only fields | **No general column.** It needs a rule table per field and audience (e.g. a deadline for rolling-admission courses, nationality for domestic-only awards) | G3 new field (proposal) |
| `confirmed_negative` | Partly: AER outcome `no_requirement_published` (45 AU); scholarship `application_required=false`; `open_to_international=false` | **No general column.** It must be an explicit statement quoted from the page, never derived from absence | G3 new field (proposal) |

Raw null semantics stay as they are: numbers, dates, URLs, booleans and arrays are never replaced by text. Any field-state metadata for Wix would be a new detail key (for example `field_states{}`). That is a consumer API change, so it needs the G3 process: Platform Admin approval recorded in the migration, baseline re-take and developer guide section 13. **It is a proposal only.** Internally, the same mapping can be built into `public.admin_field_coverage` and the operational dashboard with no consumer change.

---

## 4. Prioritised backlog

| # | Group | Item | Extends | Admission | Volume (AU) | Blocking decision |
|---|---|---|---|---|---:|---|
| 1 | Providers | University description: About/Overview kind in `central-find` / `provider-facts`; `provider_description` branch in `enrich_ai`; register reader → enrich | `central.ts`, `enrich_ai`, `enrich_fields_v1`, `field_register` | New Layer 4 kind `provider_description` (needs a decide branch; internal, not consumer API) | 45 | Platform Admin: approve the new Layer 4 kind and the prompt |
| 2 | Providers | Release the 34 AU university entry matrices waiting in Layer 4 | – | Existing `entry_matrix_first_run` (rank 6) | 34 | Platform Admin review |
| 3 | Providers | Add AU to `plans.priority_countries` (now ["NZ"]) so `enrich-plan-auto` schedules AU universities | setting | – | 45 | Setting change with a reason |
| 4 | Courses | Course description from stored identity-proved pages, added to the existing `enrich_ai` call | `enrich_ai`, `enrich_apply_v1`, `field_register` | Existing page-proof policy plus Layer 4 first-run sample per provider | 23,569 (16,650 with stored pages) | Platform Admin: the admission policy (policy versus all to Layer 4) |
| 5 | Courses | Provenance for the 163 existing adapter descriptions (or re-read them) | same as 4 | same as 4 | 163 | none |
| 6 | Courses | Year- and day-aware calendar parsing → `intake_year`, `start_date`; "applications close" → `application_deadline` | `calendarStarts`, `enrich_parse_intakes_v1` | Existing calendar approval | 23,732 | none (stored documents, no spend) |
| 7 | Courses | Level-aware calendar and English rules (1,729 intake and 1,076 English courses where the approved rule names other levels) | `english_level_apply_all_v1` and its intake twin | Existing policy approval | 2,805 | none |
| 8 | Courses | English component minimums from university policies | `englishPolicy` | Existing | 15,138 | none |
| 9 | Courses | Course entry reads waiting in Layer 4 | – | `course_entry_first_read` (rank 6) | 499 (all countries) | AER hold and review |
| 10 | Courses | Official URL capacity: decide on resuming the paused discovery and AI-match jobs | – | Existing | 5,997 | Platform Admin: cost and pause |
| 11 | Rest | Scholarships: re-extract 34 `text_only`; nationality "stated / none stated"; date-aware status | `scholarship_reextract`, `scholarship_nationality_read_v1`, `scholarship_publication_review_v1` | Existing | 34 / 832 / 3 | none |
| 12 | Rest | Coverage reconciliation: provider fields and search-versus-detail projection columns in `course-coverage-build` / `admin_field_coverage`; `under_review` from `layer4_review_items` only | `course_coverage_build_v1`, `admin_field_coverage` | – | – | none |
| 13 | Rest | Field-state metadata for Wix (`field_states{}` in detail) | consumer API | G3 approval | – | Platform Admin: G3 consumer change (proposal only) |

---

## 5. Notes for the integrator

- `catalogue.courses.description` holds 163 values with no evidence, source URL or verification date. Mandate §2 item 7 and §7 require provenance. Item 5 above covers it.
- The hourly coverage build (`course-coverage-build` at :47) truncates and rebuilds `pipeline.course_attribute_coverage`. Queries against that table should avoid :47–:48. This pass used `course_coverage_daily_by_country` instead.
- `pipeline.course_coverage_daily_by_country.snapshot_date` is the UTC date (2026-11-01 at 10:45 AEDT). It is rebuilt every hour.
- Live-only objects found while reading: `pipeline.automation_catalogue`, `pipeline.course_attribute_coverage`, `pipeline.course_coverage_daily_by_country` and the base bodies of `public.website_v2_course` / `website_v2_provider` have no `create` in checked-in migrations; migrations edit them in place under md5 guards. This is not new, but worth keeping in the governance log. Live md5 values, read 10:45:
  - `website_v2_course(text)` `50d22c3c…`
  - `website_v2_provider(text)` `0894cdb1…`
  - `website_v2_course(text,text)` `1c10b34f…`
  - `website_v2_provider(text,text)` `3f622be6…`
