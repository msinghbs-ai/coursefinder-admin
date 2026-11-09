# Field-report throughput diagnostic: why reads are not becoming admitted data (AU, NZ, CA)

30 Oct 2026, data-engineering agent, at the Platform Admin's request after the 30 Oct daily field reports.
**Read-only:** no writes, no code, no paid reads. Every figure below comes from the live database (`fxcwkweaxjtknorudmwp`), queried 30 Oct 2026 about 08:30–10:00 AEDT.
Objects cited exist live (AGENT-OPERATING-MODEL rule 7). Decision labels here are **TD1–TD6** so they do not collide with the AER D1–D9 series.

Windows used:
- **Report day** = the 24 hours the 30 Oct report compares: snapshot 29 Oct 06:55 AEDT → 30 Oct 06:55 AEDT (28 Oct 19:55 → 29 Oct 19:55 UTC).
- **Full window** = the report's start line → the 30 Oct snapshot: NZ from 21 Oct 00:00 AEDT (reconstructed start); AU and CA from the first job snapshot (21 Oct 18:37 AEDT).

Correction to the 30 Oct run summary: "Nothing went wrong" described the report build only (query, workbook, recalculation, push). It said nothing about the pipeline, and should not be read that way. Section 5 separates the two.

---

## 1. What the "+" and "−" figures measure

**Source chain:** `security.course_coverage_build_v1()` (job `course-coverage-build`, hourly at :47) truncates and rebuilds `pipeline.course_attribute_coverage`, with one row per **active** course (`catalogue.courses.lifecycle_status = 'active'`) and field. `security.provider_field_daily_record_v1()` (job `provider-field-daily`, 06:55 AEDT) counts the rows with `state = 'admitted'` per provider. The builder then subtracts one day's count from another.

| Question | Answer |
|---|---|
| Gross new values? | **No.** It is a stock count, not a flow. |
| Changed existing values? | **Not visible.** Replacing a value with another leaves the count unchanged. On the report day, 23 AU delivery values and 54 AU fees were replaced (`pipeline.adapter_overwrite_changes`), and none of that shows. |
| Removed or withdrawn values? | **Netted in.** A removal and an addition cancel. |
| Activated or deactivated courses? | **Netted in.** A course leaving `active` removes every one of its filled fields, and a course becoming active adds them. |
| Course population changes? | Yes. The daily "Courses" column is the active count. Movement in register-held fields (AU level, field of study, duration, international, campus) is almost entirely population. |
| Official-page rebinding? | Only the official-link field (`catalogue.course_links` active `official_course`). A rebinding to another URL does not move it. A retraction of the link does. |
| Publication? | **Not measured.** Unpublished providers' courses are counted. The 27 Oct publication of 1,056 AU providers (9,454 courses) did not move any figure. |
| What it is | **Net change in currently populated fields on active courses**, from any source: register, adapter, AI reader, a person or a paste. |

So a "+" is not ingestion, admission or a successful read. It is net populated-field movement.

**Two builder quirks change the published numbers:**
- "Change since start" sums only providers that still exist in today's snapshot. Six AU providers that lost every course are dropped, so the published AU figures understate the loss by 30 courses. Country totals are delivery −2,693 (published −2,689) and the register fields −723 (published −693). The same applies to any other departed provider.
- Field states in `course_attribute_coverage` label a missing field whose latest Enrich item was skipped as `not_on_page`. That includes "no correct course page" (wrong page) and "no allowed source had a value" (no stored copy). Binding failures therefore show as "page does not state it" on the coverage panels (NZ delivery `not_on_page` 3,911 on 29 Oct). See TD5.

---

## 2. Read-to-admission funnel

Counts are distinct courses unless marked *items*. Enrich items come from `pipeline.field_enrich_items`: one item is one course × field attempt, and a course-field can have several attempts. Page states come from `pipeline.coverage_course_pages` (one row per course). Reads are the latest page touch per course in the window (deduplicated by course). Gross page-read volume across all countries is in the ledger (section 5).

### 2.1 Australia

| Stage | Now / report day | Full window |
|---|---|---|
| Active courses | 25,380 | 26,103 → 25,380 (−723 population) |
| …at a published provider | 23,732 | +9,454 published 27 Oct |
| Page row exists | 23,564 (1,816 have none) | |
| Valid page (bound + ambiguous) | 19,674 (77.5%) | |
| …found to be another course's page (mismatch) | 3,890 (15.3%) | |
| Valid page **with a stored copy** | 18,216 (71.8%) | 1,458 valid pages have no copy |
| Page reads, latest touch per course | 1,745: 595 read OK, **748 ended mismatch**, 402 failed; 281 via Firecrawl | 4,623: 1,045 OK, 2,469 mismatch, 1,108 failed |
| Enrich attempts (*items*) | 2,297 | 34,429 |
| …no correct course page (mismatch) | 1,815 (79%) | 11,794 (34%) |
| …no stored copy or source | 55 | 6,079 (18%) |
| …AI read the page and it does not state the value | 184 | 12,421 (36%) |
| …refused by a gate (quote, proof, country rule) | 37 | 3,011 (9%) |
| Proposed into review (entry requirements) | 183 | 184 |
| **Filled by Enrich** | **23** | **811 (2.4% of items)** |
| Adapter writes, new values (`adapter_overwrite_changes`) | delivery 40, intakes 4, English 2, fee 4 | delivery 84, intakes 38, English 20, fee 25 |
| Adapter writes, replacements (not counted) | delivery 23, intakes 6, English 1, fee 54 | delivery 52, intakes 29, English 8, fee 63 |
| Official links created | 14 | (url fills; see 4) |
| Layer 4 approved / rejected / superseded (course) | 0 / 0 / 22 | 381 / 40 / 321 (372 = identity-held fees re-applied 27 Oct) |
| Withdrawn | — | 2,619 wrong-page AI values (23 Oct; 2,595 cleared); 422 courses' English (UNSW Bengaluru policy, 27 Oct); calendar intakes (22 Oct) |
| Net populated movement | delivery +44, intakes +21, official page +14, English +8, fee +6 | see section 4 |

**Where volume stops (AU):** at **binding and stored copy**. Of 34,429 Enrich items, 52% never reached a usable page (11,794 wrong page, 6,079 no copy). Another 36% read a correct page that does not state the value, which is the honest gap of the source. Only 9% were refused by a gate. Delivery is the clearest case: 68% of its items hit a wrong page and 20% had no copy. Intakes and English are mostly "page silent".

### 2.2 New Zealand

| Stage | Now / report day | Full window |
|---|---|---|
| Active courses | 6,474 | 6,474 (no population change) |
| Page row exists | 5,799 (675 have none) | |
| Valid page (bound + ambiguous) | 3,231 (49.9%) | |
| …mismatch (another course's page) | **2,568 (39.7%)** | |
| Valid page with a stored copy | 3,012 (46.5%) | 219 valid pages have no copy |
| Page reads, latest touch per course | 118: 19 read OK, **89 ended mismatch**, 10 failed; 106 via Firecrawl | 3,029: 841 OK, 1,976 mismatch, 202 failed |
| Enrich attempts (*items*) | 286 | 22,169 |
| …no correct course page | **278 (97%)** | 3,197 (14%) |
| …no stored copy or source | 0 | 2,691 (12%) |
| …page does not state it | 3 | 9,332 (42%) |
| …refused by a gate | 1 | 4,666 (21%; 2,293 campus) |
| Held for a person (campus not in the admitted list) | 0 | 243 |
| **Filled by Enrich** | **4** (international 3, campus 1) | **1,034 (4.7%)** |
| Withdrawn | — | 4,280 wrong-page values (23 Oct): delivery 1,256, campus 1,112, duration 1,102, international 810 |
| Fees re-admitted after re-binding | 3 (AUT, same amounts) | |
| Net populated movement | fee +3, international +3, campus +1, city +1 | see section 4 |

**Where volume stops (NZ):** at **binding**. Two in five NZ courses have only a page that belongs to another course, and 675 have none. On the report day, 89 of the 118 pages touched (75%) ended as another course's page; 88 of those were fetched through Firecrawl. 97% of the Enrich items that day went to courses with no correct page.

### 2.3 Canada

| Stage | Now / report day | Full window |
|---|---|---|
| Active courses | 3,814 | 4,723 → 3,814 (−909: scope change, see 4) |
| Valid page (bound + ambiguous) | 3,060 (80.2%) | |
| …mismatch | 749 (19.6%) | |
| Valid page with a stored copy | 2,735 (71.7%) | 325 valid pages have no copy |
| Page reads, latest touch per course | 95: **1 read OK, 94 ended mismatch** (91 via Firecrawl) | 1,721: 1,105 OK, 546 mismatch, 70 failed |
| Enrich attempts (*items*) | 420 | 14,012 |
| …no correct course page | **416 (99%)** | 1,018 (7%) |
| …no stored copy | 0 | 1,050 (7%) |
| …page does not state it | 3 | 5,808 (41%) |
| …refused by a gate | 1 | 1,511 (11%) |
| Held for a person (campus) | 0 | 135 |
| **Filled by Enrich** | **0** | **4,184 (30%)** |
| Official link created | 1 (UVic Climate Science, `course-url-fill`, adapter_title proof) | |
| Withdrawn | — | 1,952 wrong-page values (23 Oct): delivery 749, campus 770, duration 433 |
| Net populated movement | official page +1 | see section 4 |

**Where volume stops (CA):** on the report day, at **binding**. Every candidate read except one was a wrong page. Over the window, CA converted best of the three countries (30% of items filled), mainly international (1,005 of 1,005 items filled) and campus (1,256 of 2,385). 2,642 of 2,998 English items (88%) found nothing on the page.

---

## 3. The small daily gains, traced

| Figure | Records behind it | What made it small |
|---|---|---|
| NZ international +3 | Enrich items (standing gap queue): Waikato MBA ("full-time MBA in Tauranga is the only option open to international students"), VUW BBiomedSci Hons, both `ai_stored` on bound pages; Auckland conjoint BCom/BGlobalStudies, `provider_facts` ("an international fee is on record") | 49 of the 52 NZ international items that day were "no correct course page". |
| NZ campus +1, city +1 | Lincoln Certificate in Academic English, `provider_facts` ("the provider has one campus") | 47 of the 49 campus items were wrong page. Separately, 702 NZ campus items (456 courses) wait on 85 providers' campus-list decisions (section 6.3). |
| NZ tuition +3 | Three AUT science fees (44,659.68 / 44,459.67 / 47,959.67 NZD). They were quarantined 24 Oct by the identity re-verification and re-admitted at 05:52 AEDT 30 Oct (18:52 UTC 29 Oct) by the fee reader (`fee_reader_queue`, gpt-4.1-mini) once the pages were re-bound with an NZQA-code proof. The amounts are unchanged. | **These are restorations, not new data.** `pipeline.fee_course_requests.outcome` still says `not_admitted` for all three (stale; TD6). |
| CA official page +1 | UVic Climate Science BSc, link created 21:50 AEDT 29 Oct; page bound by title search with an adapter_title proof | 94 of the 95 CA candidate pages read that day failed identity. |
| AU delivery +44 | 40 new values from `adapter_overwrite_changes` (32 at CQU, 14:40–14:50 AEDT 29 Oct) and 4 from Enrich; also 23 replacements not counted | 739 of 788 AU delivery Enrich items were wrong page. |
| AU official page +14 | 14 links created by `course-url-fill` (e.g. Goldstone, Brunswick, UQ). Some are generic pages: `rivertonenglish.com.au/enrolment` serves 3 courses, plus `aeta.vic.edu.au/apply-now/` (CRICOS-code proof) | See TD1. |

**Measured primary constraint per country (report day):** for NZ and CA, **binding**: candidate pages that fail the identity check, followed by a gap queue that re-queues those courses into Enrich only for them to be skipped. Volume was not limited by spend (0 Enrich cost on skipped items, and no read-budget refusals beyond 32 target-list refusals), by Layer 4 (no pending items for these fields) or by scheduling (all lanes ran).

**Was the gap queue starving real work?** No. `security.field_gap_queue_tick_v1()` re-queues a missing field whenever the course's page row has `read_at` later than its last item. A candidate page that fails identity still updates `read_at`, so the course is re-queued and skipped "no correct course page". Since 25 Oct, 9,241 of 19,139 standing-queue items (48%) ended that way and 1,868 (10%) ended "no stored copy". These cost no AI spend and did not crowd out other items (the run cap is 30,000). The harm is noise: they inflate attempt counts and hide the binding constraint behind Enrich numbers (TD2).

---

## 4. The large negative movements, reconciled

Country totals come from `pipeline.provider_field_daily`. Components are measured from the named records. "Unattributed" is the remainder: there is no per-value event log yet (Track B item 2.1), so some writes cannot be tied to a source.

### 4.1 AU register fields −723 (published −693): level, field of study, duration, international, campus

| Component | Courses | Record | Assessment |
|---|---|---|---|
| CRICOS register departures, run b8a541af (30 Sep edition) | −563 | `pipeline.layer1_course_retirements` ("Not in the register as of 01 Oct 2026"); paste PASTE-20261027-au-register-retirements.sql, Platform Admin 26 Oct 21:12 | Legitimate. The courses left the register. |
| Layer 4 archive decisions (ANU 111 + UOW 49) | −160 | `pipeline.manual_edit_log` lifecycle archive, 27 Oct 22:01–22:09 AEDT: "Course code is on none of the current course pages…" / "No 2026 handbook page…" | Legitimate person decisions. |
| Data loss | 0 | — | None. Every one of these fields still holds 100% of active courses (register-held). |

### 4.2 AU delivery −2,693 (published −2,689)

| Component | Values | Record |
|---|---|---|
| Wrong-page AI values taken back, 23 Oct | −2,590 cleared (24 more not cleared because the field had already changed) | `pipeline.enrich_value_retractions`: 1,208 read from a page now known to be another course's; 460 from an earlier page of such a course; 922 from an earlier, different page, to be read again (migrations 20261023017000 and 019000; Platform Admin 23 Oct "Take them all back" and 16:02 "re-read") |
| Population (563 + 160 courses) | −444 | as 4.1 |
| Enrich fills | +164 | `field_enrich_items` filled |
| Adapter new values | +84 | `adapter_overwrite_changes` |
| Unattributed | +93 | no per-value log |

**Quality judgement:** the take-back improved accuracy. Each value was quoted from a page other than the course's own (sample: SCU Bachelor of Engineering Systems (Honours) (Mechanical) held "blended" from the general Bachelor of Engineering (Honours) handbook page). But the re-read promised for the 922 "read again" values **did not deliver**. All 946 were re-attempted, on 23 Oct only, and 451 ended "no allowed source had a value" because the course's bound page had **no stored copy** at that moment (cost 0). 398 more now end "no correct course page" because the page was later found to be another course's. Only 55 (5.8%) were refilled by AI, plus 38 through the adapter. Nothing re-queues them when a copy appears, other than the gap queue's `read_at` rule, which needs the page to be read first (TD3).

### 4.3 NZ delivery −880, duration −789 (also international −509, campus −609)

| Field | Net | Taken back 23 Oct (cleared) | Enrich fills | Adapter new | Population | Unattributed |
|---|---|---|---|---|---|---|
| Delivery | −880 | −1,256 | +129 | +7 | 0 | +240 |
| Duration | −789 | −1,102 | +119 | 0 | 0 | +194 |
| International | −509 | −810 | +113 | 0 | 0 | +188 |
| Campus | −609 | −1,112 (links removed by paste) | +272 | 0 | 0 | +231 |

The NZ start line (20 Oct) is reconstructed, not measured. The first job snapshot (21 Oct) already differs by +82 delivery and +64 duration, so part of the unattributed figure is baseline error.

Samples (`enrich_value_retractions`): Waikato BBus/BE(Hons) conjoint held "4 years" read from the Bachelor of Engineering with Honours page, and BBus/LLB conjoint "4 years" from the Bachelor of Laws page. Both pages are still bound as `mismatch`, and the fields are empty now. These are correct take-backs. Conjoint courses have no page of their own (SP-1 conjoint rule).

Re-read outcome for NZ "read again" values: delivery 2 of 119 refilled, duration 5 of 100, international 3 of 99, campus 8 of 150.

**Judgement:** the drop is a legitimate quality correction (Platform Admin approved), not a regression. The failure is that 40% of NZ courses still have only a wrong page, so the values cannot come back.

### 4.4 CA field of study −850, international −909

| Component | Field of study | International | Courses | Record |
|---|---|---|---|---|
| Scope gate hid courses (`ca-intl-college-plus-v2`, rule `no_level` 1,136 + `level_out_of_scope` 33) | −1,132 | −1,166 | −1,166 net still hidden | `pipeline.course_scope_changes` 22 Oct; migration 20261022034000; Platform Admin 22 Oct "Widen to colleges, level required" |
| Scope gate showed courses (`level_in_scope`) | +255 | +256 | +256 | same table, 22–24 Oct |
| Other fills on courses that stayed active | +26 | 0 | | `field_enrich_items` |
| Net | −850 (reconciles to ±1) | −909 (reconciles to ±1) | | |

**Judgement:** this is a population (scope) change approved by the Platform Admin, not data loss. The hidden courses are college courses without a source-given level.

One side effect: **569 of the 772 CA delivery values and 136 of the 425 duration values the AI filled in the window are on courses that are now inactive.** AI reads were spent on courses that the scope gate then hid.

### 4.5 Other AU movements

| Field | Net | Main components |
|---|---|---|
| English | −478 | UNSW Bengaluru policy withdrawn from 422 courses (1,688 rows; paste 27 Oct, Platform Admin: "India-campus page is not UNSW Sydney English evidence"); population −367; gains about +311 |
| Intakes | −550 | Calendar intakes withdrawn 22 Oct (2,166 rows, all countries; "Page-only months"); the AU snapshot stepped −918 that day; population −111 |
| Tuition | +272 | 372 identity-held fees re-applied (paste 27 Oct; snapshot +199); population −115; adapter +25 new / 63 replaced |
| Official page | −319 | Population −490; gains about +171 |

**Overall:** none of the large negative movements is an unexplained withdrawal. Each traces to an approved take-back, withdrawal or population decision. The regression is downstream: values taken back for re-reading have not come back.

---

## 5. Pipeline health, separated from report health

| Question | Evidence | Status |
|---|---|---|
| Did the scheduled jobs run? | `cron.job_run_details` for the window: failures are low but not zero. coverage-ai-match-prepare 11 of 2,254 (statement timeout), enrich-plan-auto 9 of 75 (12%), coverage-admit 5 of 451 (one inside `zoho_course_search_v2`), adapter-overwrite 4, coverage-admit-intakes 4, waste-guard 3, l4-rule-low-agreement 2 of 3, course-relink 1 deadlock | **Mostly yes** |
| Did they do useful work? | Ledger, 29 Oct (AEDT day), all countries: read 4,101 calls with 3,488 items (3,385 OK); enrich_ai 478 items; ai_match 1,968; link_search 1,516. But `discover` was empty on 2,824 of 2,847 calls, and `reextract` was empty on 1,407 of 1,407. In NZ and CA, 75–99% of the pages touched on the report day ended mismatch | **Partly**: high activity, low yield |
| Did readers succeed? | Fetch success is high (97% of read items OK). Per course, the binding result is poor: report-day AU 34%, NZ 16%, CA 1% of touched courses ended with a valid read page | **Fetch yes, binding no** |
| Were usable proposals produced? | Full window: AU 811 / 34,429 items filled (2.4%), NZ 1,034 / 22,169 (4.7%), CA 4,184 / 14,012 (30%) | **Low** |
| Did reviewers admit them? | For delivery, duration, international, intakes and English, nothing waits in Layer 4. Tuition: 189 pending. Campus: 985 items (695 courses) wait in **Enrich review, outside Layer 4** (section 6.3) | **Not the constraint**, except campus |
| Did consumer-active data improve? | AU: yes in reach (1,056 providers / 9,454 courses published 27 Oct) and in accuracy (wrong-page values removed), but field fill fell. NZ: fewer filled fields than at the start, all through approved take-backs. CA: smaller, cleaner scope | **Accuracy up, completeness down** |

---

## 6. Constraints and actions

### 6.1 Top constraints by blocked courses (now)

| # | Constraint | AU | NZ | CA | Stage | Evidence |
|---|---|---|---|---|---|---|
| C1 | Only page found is another course's (mismatch) | 3,890 | 2,568 | 749 | Binding | `coverage_course_pages.status` |
| C2 | No page row at all | 1,816 | 675 | 5 | Binding / search | same |
| C3 | Bound page with no stored copy (404 pattern guesses, 403 blocks, needs_render, robots) | 1,458 | 219 | 325 | Read | 1,082 / 243 / 332 bound pages have **no identity proof** (TD1) |
| C4 | Page read but silent on the field | per field (AU intakes 7,791 items; English 4,386; NZ delivery 1,052; duration 1,228; CA English 2,642) | | | Source | accepted truth (PIPELINE-LINEAGE section 3) |
| C5 | "Read again" values never re-read with a copy | 946 delivery | 318 (delivery, duration, international) + 150 campus | 384 (delivery, duration) + 224 campus | Re-read | TD3 |
| C6 | Campus decisions waiting on a person | 5 providers | 85 providers / 456 courses | 24 providers / 238 courses | Review | 6.3 |
| C7 | Needs a rendered read (Firecrawl), not due | about 484 | 0 | 61 | Spend policy | 6.4 |

### 6.2 Layer 4 pending (course and provider), classified

| Item kind | AU | NZ | CA | Actionable | Stale or superseded in effect |
|---|---|---|---|---|---|
| Course entry first read (AER, new 28–30 Oct) | 608 | 348 | 0 | 956: belongs to the AER programme; not a reported field | 0 |
| Tuition validation / held fee | 127 | 24 | 38 | 189 | 30 already hold an active fee (superseded in effect); 40 now have a mismatch page (stale proof); 151 are older than 3 days |
| Official URL (alternative address) | 21 | 1 | 0 | 22 | All 22 already hold a link: a check, not a gap |
| Course English (two approved policies) | 3 | 0 | 0 | 3 | All 3 hold a value and have mismatch pages |
| No-page first run / conjoint rule (provider) | 39 | 21 | 0 | 60 | Opened 25 Oct |
| Entry matrix first run / change (provider) | 43 | 15 | 0 | 58 | AER programme |

There are no pending Layer 4 items for delivery, duration, international, intakes or field of study. **Layer 4 is not what holds those fields back.** No bulk approval is recommended. The stale and superseded tuition items (about 70) are the only ones that look closable without judgement, and even those need a person's confirmation.

### 6.3 Human review outside Layer 4 (Enrich review)

| Country | Provider campus-list decisions ("named on too few course pages: a person decides") | Course campus items waiting | Oldest | Note |
|---|---|---|---|---|
| NZ | 85 providers (265 items across 69 jobs: duplicates) | 702 items / 456 courses | 14 Oct | all older than 3 days |
| CA | 24 providers (43 items) | 282 items / 238 courses (85 now inactive: stale) | 14 Oct | |
| AU | 5 providers (9 items) | 1 | 20 Oct | |

These do not appear in Layer 4 (`layer4_review_items` has no campus kind). A person must decide the campus lists before about 456 NZ courses can take a campus.

### 6.4 Spend-limited work (separate decision)

- About 545 bound pages (AU about 484, CA 61) wait in `needs_render`. A rendered (Firecrawl) read is gated by the target rules. Job `coverage-read-2` has been paused since 12 Oct ("Firecrawl credits"). The ledger shows about 322,000 Firecrawl credits above the reserve, so **the gate is policy, not balance**.
- Read-budget refusals are small: target-list refusals totalled 128 over the window.
- Firecrawl spend lands on candidates that turn out to be wrong pages. On the report day, 91 of 91 CA and about 88 of 106 NZ Firecrawl reads ended mismatch. A precision fix (TD1) should come before any spend increase.

### 6.5 Decisions required (evidence lodged; nothing changed)

| ID | Finding | Evidence | Decision needed | Recommended next action |
|---|---|---|---|---|
| **TD1** | Binding defect: pages are marked **bound with no identity proof and no readable copy**. These include pattern-guessed URLs that return 404 (`url_pattern`: AU 100, CA 168, NZ 121 unproven), and title-search pages that are not course pages: SCU's policy download `policies.scu.edu.au/download.php?id=244…` bound to 3 courses; TAFE NSW `…/Account/LogOff/165/11877791` bound to Certificate IV in Hospitality. Separately, CRICOS-code proof binds generic apply or enrolment pages (`rivertonenglish.com.au/enrolment` for 3 courses), and AU has 1,021 bound rows on URLs shared by 3 or more courses (690 with a CRICOS proof) | `coverage_course_pages` (status, basis, identity_basis, evidence_id, url) | Should `bound` require an identity proof (or a stored copy), with unproven, unreadable bindings returned to search? Should a page shared by several courses need a course-specific check? | Audit sample of 50 shared-URL bindings, then a gate change through the normal decision → PR path. No mass change |
| **TD2** | Gap-queue defect: a failed candidate read re-queues mismatch courses into Enrich, where they are skipped. 48% of standing-queue items since 25 Oct, and 97–99% on the report day in NZ and CA | `field_gap_queue_tick_v1` `read_at` rule; `field_enrich_items` reasons | Approve holding a course out of the gap queue while its page is `mismatch` or has no copy (extend `security.enrich_item_held_v1`) | Small held-rule change; it makes attempt counts honest. No throughput change expected |
| **TD3** | 23 Oct "read again" values not re-read: 1,648 values (AU 946, NZ 318, CA 384) plus 375 campus; 2–10% refilled | `enrich_value_retractions` × later `field_enrich_items` | Approve a targeted re-queue of exactly these course-fields once each has a bound page with a stored copy (and prioritise reading the bound-without-copy pages among them) | Count-guarded re-queue after TD1, so wrong pages are not re-read |
| **TD4** | Report metric is net stock, and the builder drops departed providers | section 1 | Approve adding to the daily workbook: population in/out, withdrawals and replacements alongside net. A report-format change (Platform Admin's report, 21–22 Oct) | Builder change in the admin repo after approval |
| **TD5** | Coverage labels count binding failures as "not on page" | `course_coverage_build_v1` state CASE | Approve splitting `not_on_page` into "page silent", "wrong page" and "no copy". Additive states; check any consumer of these labels first (G3: confirm none is consumer API) | Change under the lineage rule (section 7) |
| **TD6** | Lineage gaps: no per-value event log, so AU delivery +93 and NZ +188 to +240 per field are unattributed; `fee_course_requests.outcome` stays `not_admitted` after a re-admission (3 AUT fees) | sections 3 and 4 | None new: Track B item 2.1 (`pipeline.course_events`) covers it. Fix the stale outcome with it | Note on the Track B record |

### 6.6 Per constraint: next action

| Constraint | Next action | Owner |
|---|---|---|
| C1 mismatch (NZ 40%) | Not more reads. Continue SP-1 no-page / conjoint decisions (21 NZ provider first runs pending) and the Defect 1 title-verify batch. Measure binding % daily against the 25 Oct tracker (NZ 47.0%) | Platform Admin (Layer 4 first runs); agent (measure) |
| C2 no page row | Search lane is gated by R2 caps. Leave as is until TD1 shows binding precision | — |
| C3 bound, no copy | TD1 decision | Platform Admin |
| C4 page silent | Accepted. Report it as "source silent", not as a pipeline failure (TD5) | — |
| C5 re-read not delivered | TD3 after TD1 | Platform Admin |
| C6 campus decisions | 85 NZ + 24 CA + 5 AU provider campus-list decisions; deduplicate the 265 NZ items first | Reviewer |
| C7 needs render | Separate spend decision after TD1 | Platform Admin |

---

## 7. Method notes and limits

- No paid reads, no writes, no code. All queries were read-only `select` statements.
- Values on exited courses are their current values: deactivation does not clear fields, and the 23 Oct take-back came before the 27 Oct exits.
- Enrich bucket shares are of **items**, not distinct course-fields. For distinct counts by reason, see `field_enrich_items`; the diagnostic SQL can be re-run on request.
- The ledger (`mode_outcome_ledger`) only holds rows from 24 Oct (R1). Read volumes before that come from page rows.
- Live definitions checked: `security.provider_field_daily_record_v1` md5 f1d5a93c…, `security.course_coverage_build_v1` md5 f698bf7f…, `security.field_gap_queue_tick_v1` md5 d909e54d…
