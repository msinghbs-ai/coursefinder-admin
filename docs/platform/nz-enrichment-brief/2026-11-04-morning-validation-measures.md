# StudySearch — morning validation measures (4 November 2026)

**What this is:** the factual morning measurement for §10 of the Platform Admin mandate of 4 Nov 2026 05:08 (`2026-11-04-independent-validation-recovery-mandate-0508.md`) and the morning report measures of §5 of the overnight mandate of 3 Nov 21:59.

**How it was measured:** read-only SQL against production (`fxcwkweaxjtknorudmwp`) between 05:10 and 05:30 AEDT, 4 Nov 2026. Calls to consumer API functions ran inside `begin transaction read only`, and each one was first checked to contain no insert, update or delete. Nothing was written to production.

**Window:** 3 Nov 2026 21:00 AEDT (10:00 UTC) to the time of each read (about 05:15–05:28 AEDT, 4 Nov). The 24 hours before (2 Nov 21:00 to 3 Nov 21:00) is shown as "previous 24 h" where it helps.

**Load windows:** the two heavier reads (155 course items, and 30 courses across three consumer functions) were bounded.
- The 30-course read ran at 05:26:14, inside the :x6 slot.
- The 155-item link read ran at 05:15:25. That is outside the :x6–:x8 slot: a slip, recorded here. It finished in a few seconds.
- Nothing ran at :35–:42 or :47–:48.

"Not measured" means the figure could not be read with the access or time available. It is not a defect.

---

## Headline

| Area | Overnight result (21:00 → about 05:20) |
|---|---|
| AER | 64 scheduled course reads; 132 course entry rows proposed; 48 Layer 4 items raised; **0 admitted; 0 consumer changes**. Reading stopped at 03:13 on the daily cap (200) and back-pressure (605 waiting, limit 600). No new matrix source, matrix read or matrix row. |
| Scholarships | 5 admitted (UWA 3, UNSW 2), 4 newly published and returned by both Website API v2 and Zoho; 21 D4 refusals recorded; 1,130 directory-site enqueues skipped; Bond read done, VU read failed; **8 Macquarie re-reads still unread** (next read date 13 Nov). |
| Rankings | No publication change (no ranking row created or changed since 8 Oct). |
| Course links | 338 decided (134 approved, 21 edited, 183 kept held page); 155 links changed. **155 of 155 match on Website API v2.** |
| Consistency | 30 of 30 links agree across Website v2, Zoho and Wix v2. 8 of 8 provider tuition figures agree on amount, currency and year. The 6 UNSW courses are held as decided. |
| Spend | Firecrawl about 706 credits by the ledger (vendor balance 2,608 → 2,099 of 5,000); OpenRouter US$0.76 by the ledger (balance US$79.79 → US$78.91). |
| Health | 4.66 GB database; 33 of 120 connections. 13 cron failures in the window, all before 23:00; **0 failures from 23:00 to 05:20** (about 10,700 runs). |
| Job changes | No job disabled or restored. 3 new jobs started (ai-eval, work-continuity, work-continuity-lanes). 11 jobs inactive. |
| Migrations | Live and Pilot `origin/main` match from `20261010006400` on (413 versions), apart from one known no-op file. Website frontend serves **v2.15.458**. |
| Layer 4 | 4,226 pending (about 4,464 at 21:00). 338 decisions overnight, all Course Link rules. 0 AER, fee or description decisions. |
| Continuity | course-relink 39 of 39 and provider-identity-check 7 of 7 since their fixes. 2,301 field reads wait for AI recovery, which is switched off (D9). Unattended window: about 3 h 20 min of 24 h (first green hour 02:00). |

---

## 1. AER

### 1.1 Overall movement

| Measure | Window | Previous 24 h | Source |
|---|---:|---:|---|
| Matrix sources added (`entry_matrix_sources`) | 0 | 4 | created_at |
| Matrix sources read | 0 | 4 | read_at |
| Source inventory rows recorded / attached (`aer_source_inventory`) | 0 / 0 | 8 / 4 | recorded_at |
| Matrix runs created / done (`entry_matrix_runs`) | 0 / 0 | 4 / 4 | — |
| Matrix rows created (`catalogue.provider_entry_matrix`) | 0 | 41 (CDU, proposed) | created_at |
| Scheduled AER runs (`aer_schedule_runs`) | 8 | 4 (first run 17:13) | ran_at |
| Scheduled course reads | 64 | 43 | course_reads |
| Course entry rows proposed (`course_entry_requirements`, status proposed) | 132 | 82 | created_at |
| Course entry rows made inactive (replaced) | 31 (RMIT 27, AUT 4) | — | updated_at |
| Course entry rows admitted (status active) | **0** | — | — |
| Layer 4 AER items raised (`course_entry_first_read`) | 48 | 27 | created_at |
| Layer 4 AER items decided | 8 (all superseded) | 2 | decided_at |
| Consumer-published AER changes | **0** (nothing admitted) | — | inferred from 0 admissions |

**Why reading stopped:** runs at 03:13 and 04:13 recorded `back_pressure = true`, room 0, "the daily cap is reached" (200 courses a day, `aer.schedule_daily_max`). Layer 4 AER waiting was 605, over the 600 limit (`aer.schedule_layer4_max`). The 05:13 run also ran and succeeded. Its row was not read.

### 1.2 By university

Reads come from `aer_schedule_runs.detail.new`. Rows and items were created in the window. Totals are as at about 05:15.

| University | Reads | Rows proposed | L4 items raised | Matrix sources (total) | Active matrix rows | Active course rows | Proposed course rows (total) | L4 AER pending |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| CDU | 6 | **0** | 0 | 1 | 0 | 0 | 2 | 1 |
| UniSQ | 6 | 18 | 6 | 1 | 0 | 0 | 22 | 7 |
| UNE | 6 | 5 | 1 | 1 | 0 | 0 | 11 | 2 |
| Torrens | 6 | 11 | 5 | 1 | 0 | 0 | 16 | 7 |
| UWA | 6 | 11 | 6 | 1 | 0 | 0 | 13 | 7 |
| RMIT | 6 | 42 (27 older rows made inactive) | 10 | 36 | 380 | 1 | 1,363 | 303 |
| Deakin | 6 | 15 | 4 | 0 | 0 | 0 | 23 | 6 |
| JCU | 6 | 10 | 6 | 0 | 0 | 0 | 12 | 8 |
| CQU | 6 | 5 | 3 | 0 | 0 | 0 | 5 | 3 |
| ACU | 3 | 2 | 2 | 0 | 0 | 0 | 2 | 2 |
| Others (Sydney 2, UNSW 2, WSU 1, Flinders 1, Macquarie 1) | 7 | 11 | 4 | — | — | — | — | — |
| AUT (no read in window) | 0 | 2 | 1 | — | — | — | — | — |

CDU still has 41 matrix rows proposed (from 3 Nov), with 0 active. The 8 missing universities (CDU, Deakin, UNE, Torrens, ACU, JCU, CQU, UniSQ) all had course reads overnight. None has an admitted row. Four of them (Deakin, ACU, JCU, CQU) still have no matrix source.

**CDU, 6 reads and 0 rows:** the read outcomes were not traced to their jobs. Not measured.

---

## 2. Scholarships

### 2.1 Register and movement

| Measure | Total now | Window | Previous 24 h |
|---|---:|---:|---:|
| Registered: active and published | 1,151 | +4 created | +38 |
| Registered: active and unpublished | 370 | +1 | +8 |
| Registered: active and withdrawn | 41 | 1 changed (UWA duplicate, 22:30) | 0 |
| Registered: inactive (unpublished 614, withdrawn 9) | 623 | 0 | 0 |
| Admission log: admitted | 1,892 | **5** (UWA 3 at 01:32, UNSW 2 at 01:12) | 46 |
| Admission log: rejected | 22,325 | 22 (21 D4 by a person; 1 UWA listing page by AI) | 113 |
| Admission log: skipped (directory-site gate, IQ-00132) | 1,130 | 1,130 (one pass at 02:13) | 0 |
| AI reviews: pending (held for a person) | 132 | 0 new | — |
| AI reviews: refused | 815 | 21 decided (D4) | — |
| Owner proposals (`scholarship_owner_proposals`) | 21 decided | 21 | — |
| Publication holds open | 141 | +1 | — |
| Discovery candidates (`layer2_scholarship_discovery_candidates`) | 1,946 | 0 created, 0 classified | — |

"Eligible" is not stored as one figure. **Not measured.** The admission and AI-review states above are the nearest measured states.

### 2.2 Named requests

| Item | Requested | Result | Evidence |
|---|---|---|---|
| Request 1: VU review 1323 | 23:10:25 | **read_failed** at 23:10:35, "the page could not be read" (model qwen3-30b) | `scholarship_read_requests` id 1, queue 56195 |
| Request 2: Bond review 1230 (fresh) | 23:10:25 | **read** at 23:11:13; "The Abedian Foundation Master of Architecture Scholarship" | id 2, queue 56196 |
| D4: 21 held items refused | 23:10:42 | 21 rejected by a person: Lexis TESOL 9, Marriott Academy 5, Kangaroo International 3, Prime Education 3, Victorian Skills College 1 (all state-government listing pages); 21 owner proposals decided; nothing reassigned | admission log, owner proposals |
| D5: 8 Macquarie re-reads | 23:11:05 | **Still unread at about 05:15.** `read_at` is still 14 Oct; `next_read_at` is **13 Nov 2026 00:00**. | `scholarship_pages` |

**Why the Macquarie re-reads have not run:** the reader `public.svc_scholarship_read_next` only takes a page when `next_read_at <= now()`. The request set `requested_at`, which lets a page pass the cap hold, but it did not bring `next_read_at` forward. As things stand, these pages will be read on 13 Nov. This is read from the live function definition and the row values. It was not changed. D6 holds: all 7 published Macquarie records stay published.

### 2.3 Consumer check of overnight scholarship changes

| Scholarship | Status | Website API v2 (`api.website_v2_scholarship_item`) | Zoho (`api.zoho_scholarship_lookup_v1`, by stable key) |
|---|---|---|---|
| UNSW College Award (PUCA1027) | published | returned | returned |
| International Scientia Coursework Scholarship (PUCA1025) | published | returned | returned |
| UWA Global Alumni Pathway Scholarship | published | returned | returned |
| ASEAN Scholarship (UWA) | published | returned | returned |
| Australia Awards (UWA) | unpublished | not returned (correct) | not returned (correct) |
| UWA GLOBAL ALUMNI PATHWAY SCHOLARSHIP (duplicate) | withdrawn | not returned (correct) | not returned (correct) |

---

## 3. Rankings and course links

### 3.1 Rankings

| Measure | Window | Previous 24 h | Last change |
|---|---:|---:|---|
| `ranking.observations` created | 0 | 0 | 28 Sep 2026 |
| `ranking.observation_provider_links` created | 0 | 0 | 8 Oct 2026 |
| `ranking.editions` changed | 0 | 0 | 28 Sep 2026 |

There was no ranking publication change overnight. (`catalogue.provider_rankings` is empty. The website reads the `ranking` schema.)

### 3.2 Course Link rules (Decision 179, overnight mandate D1/D2)

| Rule | Applied runs | Decided | Action | Links changed | On Website API v2 after search refresh |
|---|---:|---:|---|---:|---|
| canberra_no_year | 3 | 97 | approve | 97 | **97 of 97** `official_url` equals the decided address |
| sfu_no_term | 7 | 58 | 37 approve, 21 edit and approve (http → https) | 58 | **58 of 58** equal |
| adelaide_keep_held | 9 | 183 | reject (keep the held page) | 0 | not re-checked (no change) |
| **Total** | 19 | **338** | | **155** | **155 of 155** |

All 155 courses also have an active official link in `catalogue.course_links`. The register's 338 and 155 are confirmed.

---

## 4. Consistency: Website API v2, Zoho and Wix (30 changed courses)

**Sample:** 30 courses read at 05:26:14 (inside the :x6 slot):
- the 19 courses whose fee rows were changed by control events in the window (Murdoch, VIT, the 6 UNSW short courses, the D12 courses and the contained AI fee rows);
- 6 Canberra and 5 Simon Fraser courses whose links changed, picked at random by hash.

**Functions compared:**
- Website API v2: `api.website_v2_course_item`.
- Zoho: `api.zoho_course_lookup_v1`, which `public.zoho_edge_course_lookup_v1` wraps, read by stable key.
- Wix: the `wix-course-api` edge function's v2 `course` action calls the database function `public.website_v2_course`, and its legacy `lookup` action calls `zoho_edge_course_lookup_v1`. Both were therefore covered.

### 4.1 Summary

| Check | Agree | Differ | Note |
|---|---:|---:|---|
| Official course link: Website v2 = Zoho | 30 | 0 | |
| Official course link: Website v2 = Wix v2 | 30 | 0 | |
| Provider current tuition: Website v2 = Zoho = Wix v2 (amount, currency, fee year) | 8 of 8 that have it | 0 | |
| Courses with no provider tuition: website shows the CRICOS annual figure, and Zoho shows the CRICOS total under `regulatory_tuition` | 10 | 0 | Different basis by contract (annual against course total), and the totals line up (for example 51,000 = 3 × 17,000) |
| UNSW short courses held (D11) | 6 | 0 | Website and Wix v2: no tuition (null, not held). Zoho: CRICOS total 31,000–31,500 only. No inferred annual figure. |
| SFU courses (no fees held) | 5 | 0 | No tuition on any of the three |

### 4.2 Fee courses

| Course | Website v2 | Zoho provider tuition | Wix v2 | Zoho CRICOS total |
|---|---|---|---|---:|
| 096011C Murdoch | 37,800 AUD 2027, provider | 37,800 AUD 2027 | 37,800 | 28,920 |
| 117633F VIT | 16,000 AUD **2025**, provider | 16,000 AUD 2025 | 16,000 | 46,500 |
| 072350D NTI (D12) | 23,800 AUD 2027 | 23,800 AUD 2027 | 23,800 | 19,200 |
| 093282D UTas (D12) | 18,167 AUD 2027 | 18,167 AUD 2027 | 18,167 | 85,905.63 |
| 114382M UTas (D12) | 27,338 AUD 2027 | 27,338 AUD 2027 | 27,338 | 74,722.50 |
| 105389A Reach (D12) | 11,500 AUD 2026 | 11,500 AUD 2026 | 11,500 | 30,000 |
| 107010J AIH (D12) | 15,000 AUD 2026 | 15,000 AUD 2026 | 15,000 | 44,000 |
| 114579J | 24,000 AUD 2026 | 24,000 AUD 2026 | 24,000 | 48,000 |
| 085576A, 102291B, 106655B, 114822C, 121432C | CRICOS annual 17,000 / 24,600 / 17,000 / 24,000 / 26,526 | none | same as website | 51,000 / 49,200 / 34,000 / 48,000 / 53,052 |
| 0100702, 0100908, 052690E, 080476A, 108475A, 121321K (UNSW, held) | none | none | none | 31,000–31,500 |

**Observation, not a defect:** the VIT 117633F figure on all three consumers carries fee year **2025**. The register (22:20) records the value as 16,000 from AI row a805b998, but does not record the year. Whether a 2025 fee should still be shown was not assessed here.

---

## 5. Spend

| Measure | Window | Previous 24 h | Remaining / limit |
|---|---:|---:|---|
| Firecrawl ledger units (`coverage_vendor_usage`) | **706** (course_link_search 504, scrape 150, map 29, sch_scrape 14, list_scrape 9) | 13,370 (fc_read 9,072, course_link_search 3,190, scrape 713, other 395) | — |
| Firecrawl vendor balance (`vendor_credit_observations`) | 2,608 at 20:45 → **2,099** at 05:15 (−509) | — | Plan 5,000 credits; period ends 3 Dec 02:57 AEDT |
| Firecrawl since Sydney midnight | 357 | — | Daily budget setting 25,000 (shares: course search 13,000; reads 5,000; scholarships 3,500; central 2,500; other 1,000) |
| OpenRouter ledger (`ai_spend_ledger`) | **US$0.757** (enrich_fields 0.724 / 315 calls; course_match 0.024 / 188; scholarship_ai 0.009 / 13) | US$12.894 (enrich_fields 11.31; fee_ai 1.22; course_match 0.26; other 0.10) | — |
| OpenRouter balance (`layer3_openrouter_observations`) | US$79.79 at 20:45 → **US$78.91** at 05:15 (−0.88) | — | AI daily ceiling US$14 (`budgets.ai_daily_ceiling_usd`); floor US$5 |
| OpenRouter since Sydney midnight | US$0.33 | — | of US$14 |
| Fee reader (`fee_reader_queue`) | **0 reads**, US$0 | 511 reads | — |
| AER matrix runs | US$0 | US$0.02 | — |

Notes:
- The ledger (706) and the vendor balance (509) differ by about 200 credits. The ledger records units at request time, and the vendor reports what it charged. The two were not reconciled call by call. **Not measured.**
- The vendor plan has 2,099 credits left for the next 29 days. The internal daily budget setting (25,000) is far above the plan. The plan, not the setting, is the real limit.
- The `page_find` lane has been paused as `budget_exhausted` (purpose course_link_search) since 01:13, with recheck at 11:00. Course link search used 200 units since Sydney midnight, against a 13,000 share. The budget that tripped was not identified. **Not measured.**

---

## 6. Health

### 6.1 Database

| Measure | Value |
|---|---|
| Database size | 4,660 MB (4.89 GB) |
| Largest tables | storage.objects 651 MB; pipeline.evidence_artifacts 389 MB; search.course_documents 233 MB; pipeline.coverage_provider_urls 145 MB; catalogue.course_fees 135 MB; pipeline.field_enrich_items 118 MB |
| Connections | 33 of 120 (6 active, 0 idle in transaction) at about 05:17 |
| Size 24 h earlier | Not measured (no earlier size snapshot was read) |

### 6.2 Scheduled job failures (`cron.job_run_details`)

| Job | Runs in window | Failed | Last failure | Cause |
|---|---:|---:|---|---|
| course-relink | 50 | 11 | 22:44 | statement time-out in `course_relink_url_norm_v1` (before v2.15.445, merged 22:49) |
| provider-identity-check | 8 | 2 | 22:16 | check constraint `integration_issues_root_cause_class_check` (before v2.15.444, merged 22:26) |
| All other jobs | — | 0 | — | — |

**By hour (AEDT):** 21:00 had 7 failures and 22:00 had 6. Every hour from 23:00 to 05:00 had 0, in 1,646–1,782 runs an hour. For comparison, 3 Nov 14:00–20:00 had 3–7 failures an hour.

---

## 7. Job changes

| Measure | Window | Previous 24 h |
|---|---|---|
| Jobs disabled or restored (`admin_control_events` pause/enable/activate actions) | **none** | aer-scheduled-read activated; integration-validate activated; ranking-edition-check activated; coverage-discover and coverage-discover-2 paused |
| New jobs first run in window | ai-eval (21:07), work-continuity (22:08), work-continuity-lanes (01:13) | — |
| One-off job starts (`jobs/job_start`) | 17 (22:45–03:45) | 42 |
| Jobs active / inactive now (`cron.job`) | 158 / 11 | — |
| Inactive jobs | course-link-reverse, coverage-discover, coverage-discover-2, coverage-reextract, cron-history-retention, cron-history-trim, l4-rule-low-agreement, onboarding-pilot-snapshot, provider-calendar-defaults, provider-calendar-intakes, worker-outcome-check | — |

Other control events in the window: fee withdraw pastes 15 (21:10–22:01), Murdoch correction 1 (21:43), `fees.course_pages` changed twice (21:01, 21:47), fee re-check paste 1 (00:54), Layer 4 rule counts 3 and executions 19, zero-yield detections 8, housekeeping 1, scholarship nationality read 1.

Settings changed in the window: the switches recorded with v2.15.441–458 (for example `wc.*` at 22:01 and 01:10, `layer4.*` at 23:34 and 01:28, `scholarship.*` at 23:08 and 23:10, and `binding.cricos_identity_guard_on` = 0 at 05:10). `wc.ai_recovery_on` stays 0 (D9). `fees.respect_all_exclusions_on` stays 0 (D10). `aer.schedule_daily_max` stays 200, unchanged since 3 Nov 16:18.

---

## 8. Migrations and release

| Check | Result |
|---|---|
| Live migrations (`supabase_migrations.schema_migrations`) | 1,760 versions; head `20261104360000` |
| Pilot `origin/main` (`66ac60f3`, v2.15.458, merged 05:09) | 414 migration files; head `20261104360000` |
| From `20261010006400` on (the repo's first file) | 413 live = 413 repo, apart from one file |
| In repo, not live | `20261031090000`: refused by its own md5 guard on 31 Oct and kept as a no-op. Re-issued as `20261031091000`, which is live. Known (record 31 Oct). |
| Live, not in repo | 1,347 versions, all before 10 Oct 2026 (the known pre-git history) |
| Overnight merges | v2.15.441 (21:04) to v2.15.458 (05:09): 18 releases |
| Frontend served | Release Currentness Deployed run 41691052944 on `66ac60f3`: "Deployed frontend serves v2.15.458 (attempt 1/80)"; release-notes check passed. Deploy on merge, Frontend Build, Deployed UAT and Release History Contract all succeeded on the same commit. |
| v2.15.457 | Served before v2.15.458 replaced it: Release Currentness run 41688178116 on `725fc7f6` succeeded |

Edge function versions and checksums were not read. **Not measured.**

---

## 9. Layer 4

### 9.1 Backlog by kind (`pipeline.layer4_review_items`, status pending)

| Kind | Pending | Raised in window | Decided in window |
|---|---:|---:|---:|
| Course link (`official_course_url`) | 2,958 | 63 | 338 |
| AER course first read (`course_entry_first_read`) | 564 | 48 | 8 (superseded) |
| Course description first read | 458 | 37 | 0 |
| Provider tuition validation | 135 | 0 | 0 |
| Provider no-page first run | 55 | 0 | 0 |
| AER matrix first run | 41 | 0 | 0 |
| Conjoint rule first run | 5 | 0 | 0 |
| Provider current tuition | 5 | 0 | 0 |
| Provider description | 4 | 0 | 0 |
| Course English | 1 | 0 | 0 |
| **Total** | **4,226** | 148 | 346 |

At 21:00 about 4,464 were pending. This is estimated from creation and decision times. None is claimed, and none is older than 14 days. Scholarship AI reviews held for a person: 132 (a separate queue).

The 5 D12 fee re-check items were raised in `pipeline.enrichment_flags` (paste at 00:54), not as Layer 4 review items. Their state was not read. **Not measured.**

### 9.2 Decisions and admissions overnight (`pipeline.layer4_decisions`)

| Action | Field | Window | Previous 24 h |
|---|---|---:|---:|
| approve | official_course_url | 134 | 0 |
| edit_and_approve | official_course_url | 21 | 0 |
| reject (keep held page) | official_course_url | 183 | 1 |
| Any other field | — | **0** | 0 |

Admissions reaching the catalogue overnight: 155 course links, 5 scholarships, 0 entry rows and 0 fees by Layer 4. The fee corrections were done by paste.

### 9.3 Technical blockers

| Blocker | Measure |
|---|---|
| AER back-pressure | 605 waiting against a limit of 600; daily cap 200 reached; no AER reads after 02:13 |
| AER technical holds | 27 Layer 4 items parked as `technical_hold` (issue 203), **no next eligible time** |
| AER duplicates | 22 parked as `duplicate` (issue 176), **no next eligible time** |
| Course page find | lane paused `budget_exhausted` (issue 178), recheck 11:00; 10 finds deferred; 1 parked for Platform Admin authority (issue 177) |
| Field reads | 2,301 `ai_incomplete` field reads eligible since 00:18; AI recovery off (`wc.ai_recovery_on` = 0, D9) |
| Fee reader | 0 reads overnight, so v2.15.442 has had no production fee read |

---

## 10. Continuity

### 10.1 `pipeline.work_items` by lane and stage

| Lane | Stage | Items | Created in window | Recovered in window | Note |
|---|---|---:|---:|---:|---|
| ai_extraction | done | 207 | 207 | 207 | |
| ai_extraction | eligible | 2,302 | 2,302 | 0 | 2,301 `field_read` / `ai_incomplete`, next eligible 00:18 (now overdue); waiting on D9 |
| course_relink | done | 163 | 163 | 1 | |
| course_relink | eligible | 1 | 1 | 0 | attribution item, no next time |
| aer_technical | parked | 49 | 49 | 0 | 27 technical hold, 22 duplicate; no next time |
| page_find | deferred | 10 | 10 | 0 | budget; next 11:00 |
| page_find | lane_paused | 1 | 1 | 0 | budget; next 11:00 |
| page_find | parked | 1 | 1 | 0 | authority; no next time |

Recovered items in the window: 208 (ai_extraction 207, course_relink 1). The 05:08 mandate asks for a next recovery time on every unresolved case. **52 unresolved items have none:** aer_technical 49, page_find 1 and the 2 controller items. This is measured, not judged.

### 10.2 Runs since the fixes

| Job | Since | Runs | Succeeded | Average / max seconds |
|---|---|---:|---:|---|
| course-relink (v2.15.445) | 22:54 | 39 | 39 | 20.2 / 52.9 |
| provider-identity-check (v2.15.444) | 23:16 | 7 | 7 | 38.2 / 43.4 |
| work-continuity | 22:08 | 30 | 30 | 5.6 / 89.7 |
| work-continuity-lanes | 01:13 | 25 | 25 | 0.6 / 1.6 |
| aer-scheduled-read | 21:13 | 9 | 9 | 13.3 / 23.5 |
| consumer-api-guard (daily, 05:23) | — | last run 3 Nov 05:23, succeeded | — | today's run falls after this read |

### 10.3 Towards the 24-hour unattended window

| Measure | Value |
|---|---|
| v2.15.450 merged | 01:10 AEDT, 4 Nov (`6a92ac55`) |
| First full clock hour after it with 0 cron failures | **02:00–03:00** (01:00–02:00 was also clean but began before the merge) |
| Clean hours since | 02:00, 03:00, 04:00 complete; 05:00 clean so far |
| Elapsed | about 3 h 20 min of 24 h. The window closes 5 Nov 02:00 if it stays clean. |
| Basis | Cron failures only. "Fully green" may also need processing, recovery and publication outcomes (05:08 mandate §9 and §11), which this measure does not cover. |

---

## Differences from the register

Each item compares a register claim with what production shows now.

1. **D5 Macquarie (register 23:20, "8 staging pages requested for re-read"):** the request was recorded, but no page has been read. `next_read_at` is 13 Nov, and the reader needs `next_read_at <= now()`. As built, the re-read will not happen overnight or this week.
2. **"Readiness-aware queue selection so technical holds and duplicates do not stop other providers" (overnight P1):** 49 parked AER items have no next eligible time. AER reading stopped at 03:13 on back-pressure (605 of 600) and the daily cap, and Layer 4 decided 0 AER items to release room. `wc.aer_fair_on` is 0.
3. **"Observe the first production fee reads under v2.15.442" (overnight P0):** there were 0 fee reader reads in the window. IQ-00111 cannot close on new reads yet. The live issue says deployed / verifying.
4. **Page find:** the lane has been paused as budget-exhausted since 01:13. Measured usage for that purpose is far below its daily share, and the vendor plan has 2,099 credits left.
5. **Register 01:20, "5 fee re-check items raised in Layer 4":** they are in `pipeline.enrichment_flags`. The Layer 4 review table shows no new fee items in the window.
6. **Confirmed as claimed:** Course Link 338 decided, 155 changed and 155 of 155 served; relink and identity check clean since their fixes; Murdoch 096011C 37,800 for 2027 on Website API v2, Zoho and the Wix v2 course call; VIT 117633F 16,000 on all three (fee year 2025, see §4); the 6 UNSW courses held; D4 21 refusals; Bond read and VU failure; v2.15.457 served, then v2.15.458; no job disabled; migrations consistent.
