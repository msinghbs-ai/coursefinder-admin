# SS-015 accelerated acceptance: stream B (Gate B, data integrity)

- **Date:** 2 Nov 2026, about 05:50 to 06:20 AEDT. The database clock read 1 Nov 18:52 UTC (05:52 AEDT) mid-run.
- **Scope:** read-only SQL on `fxcwkweaxjtknorudmwp`, plus calls to the read functions `public.website_v2_course` and `public.zoho_edge_course_lookup_v1`.
- **What was not done:** no writes, no AI or Firecrawl calls, no page fetches, no PRs.
- **Migration head:** `20261101120000`, the same as the E1/E14/E15 record.
- **Function md5s at the time of the checks:**
  - `website_v2_course(text)`: `50d22c3c…`
  - `website_v2_course(text,text)`: `1c10b34f…`
  - `zoho_edge_course_lookup_v1`: `f13164e5…`
- **Publication model:** every course row has `publication_status = 'unpublished'`, so the provider Published switch decides what is shown. All 34,042 search documents belong to published providers (`provider_hidden_v1` matches none). In this report, "published" means a course that has a search document.

## Overall Gate B verdict: **FAIL** (one line Fail, one line Insufficient Evidence)

| # | Gate B line | Verdict |
|---|---|---|
| 1 | No known uncontained P0 incorrect published data | **Pass**. No P0 is confirmed. See the dependency in P1-A: 31 fees are read from a sibling programme's page |
| 2 | E1, E14 and E15 remediation remains verified | **Pass** |
| 3 | E13 prevents incomplete academic-entry reads from being admitted | **Insufficient Evidence**. The gate is not live, and 162 incomplete reads can still be approved |
| 4 | Incorrect provider, course, variant and audience bindings are blocked | **Fail**. Sibling-variant official links are published and are not blocked (P1-A) |
| 5 | Representative country and provider validation passes | **Pass**. 18 of 18 sampled courses are consistent and sourced |
| 6 | Held enrichment gaps are distinguished from published defects | **Pass** |

---

## Line 2: E1, E14 and E15 (Pass)

**E1:**
- `catalogue.course_fees where notes like '%E1 withdrawn%'` returns 41 rows: all `inactive`, 41 courses.
- md5 of the sorted ids is `3a9fd3758f1e4f989425478265f68618`, which matches the approved pack.
- All 41 have `valid_to` set.
- The 5 kept fees (`4cef7c53`, `86782081`, `f11e1411`, `467f5d48`, `cf286581`) are all `active`.
- On the 41 courses:
  - the only active fees are 114 CRICOS rows (`tuition`, `non_tuition` and `estimated_total_course_cost` on 38 courses);
  - 0 search documents have `has_provider_current_tuition`;
  - 0 search documents show a withdrawn amount.
- All active fees: 91,901, unchanged since 05:30.

**E14:**
- `pipeline.manual_edit_log` with a reason starting 'E14 (Platform Admin approval 2 Nov 2026 05:18)' holds 105 entries (`course_entry`/`withdraw`) on 105 distinct rows.
- md5 of the entity ids is `23488f75ba7972f42126852e89292af2`, which matches the pack.
- All 105 rows are `inactive`, on 18 courses.
- The 18 courses have 0 active entry rows.
- All active entry rows: 1,304, as recorded.
- 0 other `course_entry` edits since 05:34.

**E15:** each of the 6 courses has exactly 1 active `official_course` link. That link is primary, equals `courses.course_url`, and equals `search.course_documents.official_course_url`.

| Course | Provider |
|---|---|
| 084563C | TAFE NSW |
| 092518G | TAFE NSW |
| 108538B | TAFE NSW |
| 107862J | TAFE Queensland |
| 4226 | MITO |
| WI0194 | Waikato |

(The other course coded 4226, at NZIST Work-Based Learning, is a different course. It has no active official link and is not part of E15.)

## Line 3: E13 (Insufficient Evidence)

**Source:** `pipeline.field_enrich_items` (field `entry_requirements`) rows whose `value->'dropped'` contains `reason='over_row_limit'`, joined to `pipeline.layer4_review_items` through `value->>'review_item_id'`.

| Enrich state | Layer 4 status | Items (= courses) | Rows dropped at the cap | Courses with active entry rows now |
|---|---|---:|---:|---:|
| review | **pending** (`course_entry_first_read`) | **162** | **2,842** | 0 |
| filled | approved, decided 30 Oct 15:04 UTC to 1 Nov 08:47 UTC | 63 | 347 | **46** |

- **The gate is not live:** the only function that mentions `over_row_limit` is the recorder, `security.enrich_entry_record_v1`. Nothing on the approval path refuses an incomplete read, and the migration head is still `20261101120000` (branch `cf247-e13-completeness-gate` not deployed).
- **The exposure is real:** any of the 162 pending items can be approved today. Since the 05:18 decision, 0 `course_entry_first_read` items have been approved (only about 35 minutes of observation).
- **Incomplete reads already admitted:**
  - 63 were approved. 17 of them are E14 courses (now withdrawn).
  - That leaves **46 published courses with 276 active entry rows** (44 with a score). They are at Monash, University of Auckland, MIT/Unitec and NMIT.
  - md5 of the sorted course ids: `5a2250f86fc6d4aa5fcd6e573edfc1f9`.
  - These are retained by the Platform Admin's E13 decision ("Retain the 59 previously approved reads unless they are independently identified as incorrect"), so they are **not** reopened here.
  - **Reconcile:** the live count is 63 approved minus 17 withdrawn (E14) = 46 still active. The decision text says 59. The basis for 59 should be confirmed.

## Line 4: bindings (Fail)

### 4a. SS-007 holds: contained
- `pipeline.course_remediation_holds`: 177 open, all `re_role`, 0 lifted.
- On held courses:
  - 0 active official links;
  - 168 official links are `unverified`;
  - 0 search documents with `official_course_url`;
  - 0 with `has_link`;
  - 0 courses with `course_url` filled.
- API checks on 10 held courses: website `official_url` null 10 of 10; Zoho returns a URL 0 of 10.
- The 34.1 regression has not recurred.

### 4b. Courses with more than one active official link (the E15 catalogue-wide figure)

**Now:** 239 courses (243 at E15, less the 4 TAFE courses repaired), 491 links.

**What consumers see:** the website and Zoho show one URL per course, from `search.refresh_course_enrichment_core_v1`. The order is `is_primary desc, last_verified_at desc, updated_at desc, id`.

| Cohort | Courses | What the website shows |
|---|---:|---|
| With a reviewer link (`layer4_human_review`) | 165 | The reviewer's link on 164 (1 has no search document). **None of the 165 has a primary link**: the reviewer link wins only because it was verified most recently, and the old sweep link stays `active` |
| No reviewer link, with a primary | 23 | The primary link on 23 of 23 |
| No reviewer link, no primary, same page spelled differently | 18 | Harmless |
| **No reviewer link, no primary, different pages** | **33** | Whichever link was verified most recently. **10 of 10 sampled are a sibling programme's or an older year's page** (see P1-A) |

- No search document shows a URL that is not one of its course's active links (0).
- `security.layer4_course_link_apply_impl` now applies E15: it makes the old links inactive, sets the approved link primary and updates `course_url`. The 165 earlier decisions were made before that fix and have not been repaired. This is the "169 catalogue-wide" item that the E15 note left for the Platform Admin to scope (now 165).

### 4c. Variant bindings: **not blocked** (P1-A below)

**Method:** compare the course title's level (Graduate Certificate, Graduate Diploma, Master, Bachelor; combined bachelor/master titles excluded) with the level in the published URL. This is a heuristic, so it has false positives (for example, Lennox 108224J: the slug says "graduate-certificate" but BSB80120 is the Graduate Diploma).

**Result:**
- 159 raw mismatches; 61 after excluding combined degrees and hand-entered (`manual_entry`) links.
- All 61 are AU courses on `provider_course_page_sweep` links, at 15 or more providers.
- Union with the 33 courses in 4b: **77 courses**, of which **53 show a provider fee**.
- md5 of the 77 sorted course ids: `1374432181aca2abb3ec525448b66923`.
- None of the 61 courses was in the SS-007 TD1 dry-run list (7 checked by code: 0 hits), so this cohort has never been in the SS-007 remediation hold.

### 4d. Provider binding: no systematic defect
- The published URL's host differs from the provider's website host on 1,112 of 23,466 URLs. On inspection these are almost all rebrands or second domains of the same provider:
  - Monash `monash.edu`;
  - Adelaide University `adelaide.edu.au`;
  - USC `unisc.edu.au`;
  - Whitireia and WelTec;
  - UBSS on `gca.edu.au` (Group Colleges Australia).
- **Single suspects for a person to check:**
  - HILTON ACADEMY 112517F on `lesuisse.edu.au` (a fee is shown);
  - UNSW Sydney 102393G, 095863M and 000725G on `unswcollege.edu.au` (UNSW College; no fee shown);
  - Humber 01008 and 01009 on `guelphhumber.ca` (no fee shown).

### 4e. Audience
- **Fees:** every active fee row is `audience='international'`:
  - 26,726 `tuition`;
  - 11,537 `provider_current_tuition`;
  - 26,726 `non_tuition`;
  - 26,912 `estimated_total_course_cost`.
- Among the 11,537 provider fees: 0 have `is_csp`, and 0 have a note, basis or key that mentions domestic, HECS, CSP or residency.
- The projection and `tuition_history` both filter on `audience in ('international','all')`.
- **Scholarships:** 78,153 published options on 871 scholarships. Audience is `international` (42,508) or `international_and_domestic` (35,645); none is domestic-only.
- **Entry (P2, not a gate failure):** on published courses:
  - `security.entry_course_payload_v1` sets `entry.min_score` from a **domestic** row on 64 of the 133 courses with a score (mostly ATAR);
  - 144 domestic-audience text rows (prerequisites and notes) appear unlabelled in `prerequisites` and `requirements_note` on 110 courses.
- Developer guide §7.9 documents this: `min_score_basis` is shown with the number ("ATAR 75"), and `min_scores[]` carries `audience`. So it is labelled presentation, not a domestic value disguised as international. It is a candidate for normal operations; a change would need G3 approval.

## Line 5: representative validation (Pass)

**Sample:** deterministic (`md5(id||'ss015B')`). The catalogue holds only AU, NZ and CA; no UK or other country is published. The sample was 3 published providers per country with a fee and a URL, and 2 courses each: 18 courses in all.

- AU: Education Queensland International, Monash, Western Sydney University International College.
- CA: Cambrian, Conestoga, Mohawk.
- NZ: MIT/Unitec, Nelson Aviation, Whitecliffe.

For each course, `website_v2_course(stable_key)` was compared with the catalogue:

| Check | Result |
|---|---|
| Tuition amount equals an active fee row | 18/18 |
| That fee has an evidence artefact with a `source_url` | 18/18 |
| `official_url` equals the projection's chosen active link | 18/18 |
| Each course has exactly 1 active official link | 18/18 |
| Intake count matches the active intakes, which are sourced | 18/18 |
| English count matches the active rows, which are sourced | 18/18 |
| Entry scores ≤ active entry rows | 18/18 (Monash 080585G: 5 scores from 6 rows, one without a score) |

Every sampled fee's evidence URL is the course's own page.

**Observations:**
- **Flat rates:** some providers show the same amount on many courses, each read from its own course page (Unitec 27,207.20 on 29 of 47; Conestoga 15,476.78 on 11 of 16; Whitecliffe 27,000 on 8 of 19). This is consistent with flat international rates; it cannot be confirmed without a page read.
- **Course codes (P2):** Mohawk courses carry the codes "Plumbing" and "Transportation", and Georgian College has 22 four-letter codes. These are identifier quality issues.

## Line 6: held versus published (Pass)

| Held value | Count | Published? |
|---|---|---|
| Scholarships held (`scholarship_publication_holds`, not released) | 140 | 0 appear in any search document's `scholarship_options`. Status: unpublished 108, withdrawn 32 |
| Fees held for review (Layer 4 pending `provider_current_tuition`/`_validation`) | 30 | 0 of the proposed amounts is in an active fee row or a search document |
| Entry reads held (Layer 4 pending `course_entry_first_read`) | 499 | 0 of these courses has an active entry row |
| No tuition (no provider fee, regulatory fee under 1,000 or absent) | 8,562 search documents | API sample: `tuition` null on 40 of 40, `tuition_history` empty on 40 of 40. The 74 regulatory fees under 1,000 are suppressed by `website_v2_tuition` |
| SS-007 held links | 177 | 0 shown (4a) |

**One consistency gap (P2):**
- `public.website_v2_course.tuition_history` reads `catalogue.course_fees` directly and **does not apply `search.enrichment_source_gates`**.
- 29 active provider fees from sources without an approved gate (27 `provider_course_page_sweep`, 2 `provider_course_page`; 2 of them are E1 kept fees) appear in `tuition_history` on 29 courses.
- 16 of those amounts are not in the gated `tuition` field.
- These are active, admitted rows, not held values, so this does not break line 6. It is an inconsistency between the gated projection and the history. Any change touches the frozen consumer API (G3).

---

## P1 found

### P1-A: published official links point to a sibling programme or an older year, with fees read from that page

**Severity:** P1. It becomes P0 if the Platform Admin treats a fee taken from another programme's page as incorrect published data, as was done for the E1 unsupported fees.

**Consumer impact:** on the website course detail and in Zoho, the "official page" link sends a student to a different programme's page. The website and Zoho show the same URL; checked on 103222G.

**Examples:**

| Course | Shown page | Shown tuition |
|---|---|---|
| RMIT Graduate Diploma of Advertising (103222G) | `…/master-of-advertising-mc249` | AUD 45,120 a year |
| Griffith Graduate Certificate in Professional Accounting (107421A) | `…/master-of-professional-accounting-5683` | AUD 42,500 a year, the Master's (088233M) rate |
| Melbourne GC TESOL (095993A) | `…/mc-tesol` | |
| La Trobe Graduate Diploma in Financial Analysis (107089H) | `handbook…/2021/LMFAN` | |
| Bond Graduate Certificate in International Relations (107662F) | `…/bachelor-of-global-studies-sustainability/graduate_outcomes` | |

**Fees from the sibling page:**
- 31 courses (31 fees) in the level-mismatch cohort have a provider tuition whose evidence `source_url` is the sibling page itself.
- Each sampled amount equals the sibling programme's annual rate. For nested awards the per-year rate is often the same, so the number may be right, but it is not supported for this course.

**Cohort:**
- **77 courses** (ids md5 `1374432181aca2abb3ec525448b66923`), 53 with a provider fee shown:
  - 61 by the level heuristic, a mix of confirmed and possible cases (the Lennox 108224J false positive is included);
  - 33 by multi-link selection;
  - 17 in both.
- All are AU, on links from the `provider_course_page_sweep` lane.
- Codes for the 61 are in the query evidence (string `000723J … 121356K`).

**Root-cause hypothesis:**
1. The provider course-page sweep binds a page by title similarity without a qualification-level or variant check. A Graduate Certificate or Diploma matches its parent Master's page, and an older handbook year matches the current one.
2. The projection's link choice has no tie-break for identity. With no primary link, the most recently verified link wins.
3. The SS-007 TD1 audit covered `coverage_course_pages` (unproven bindings, or pages shared by 3 or more courses). It did not cover 1:1 sweep links in `catalogue.course_links`, so the remediation hold never applied to them.
4. E13's "sibling programme variant" check covers entry reads only.

**Suggested containment** (needs Platform Admin approval; nothing done):
1. Confirm the 77 with a person-check list. The URL code shows whether a link is a Master's page (for example `mc249`, `-5683`), so this takes about an hour.
2. For confirmed cases, use the existing SS-007 route: `security.binding_remediation_apply_v1`, or set the link `unverified` as D1 did, then run a scoped search refresh. The website and Zoho then show `official_url` null, which the API already supports ("null means not held"). No consumer API change is needed.
3. Withdraw the 31 sibling-page fees through the E1 pattern (a count-guarded paste plus a rollback) until a checked fee for the right course is admitted.
4. Engineering:
   - add a level/variant guard to the sweep binder and to `coverage_admission_plan_v1`;
   - make the E15 data repair for the 165 reviewer-link courses (set the reviewer link primary and the old one inactive). This removes their dependence on `last_verified_at` ordering.

### Not raised as P0/P1 (P2, for normal operations)
- `entry.min_score` taken from a domestic row on 64 courses, and 144 unlabelled domestic text rows on 110 courses (documented and labelled by basis and `min_scores[].audience`).
- `tuition_history` bypasses the source gate (29 rows).
- Identifier quality: Mohawk and Georgian codes.
- Provider host suspects: Hilton/Le Suisse 1, UNSW→UNSW College 3, Humber→Guelph-Humber 2.
- E13 count: 59 in the decision text against 46 active (63 approved minus 17 E14).

## Query evidence
All of the following ran live and read only, around 05:50 to 06:20 AEDT:
- **E1:** count, md5 and status of `course_fees` with the E1 note; the 5 kept ids; active fees on E1 courses; search documents with provider tuition.
- **E14:** `manual_edit_log` reason prefix, joined to `course_entry_requirements`; status counts; active rows on the 18 courses; edits since 05:34.
- **E15:** `course_links` (`official_course`) on the 7 course ids, compared with `courses.course_url` and `course_documents.official_course_url`.
- **E13:** `field_enrich_items` `value->'dropped'` with `over_row_limit`, joined to `layer4_review_items` on `value->>'review_item_id'`; a function-body search for `over_row_limit`.
- **SS-007:** open holds; links, search documents and `course_url` on held courses; the website and Zoho on 10 held courses.
- **Multi-link:** links grouped by course having more than one active link; reviewer source `pipeline.sources.source_type='layer4_human_review'`; the projection's link lateral read from `pg_get_functiondef`.
- **Variant:** the title-level against URL-level heuristic on all 23,466 published URLs; fee evidence through `pipeline.evidence_artifacts.source_url`.
- **Audience:** `course_fees` and `course_entry_requirements` by type and audience; `scholarship_options` audience; the definition of `entry_course_payload_v1`.
- **Sample:** the 18-course comparison query; the provider fee-repetition query.
- **Held:** `scholarship_publication_holds` against `scholarship_options`; Layer 4 pending fee amounts against fees and search documents; a 40-course API sample with no tuition; the ungated `tuition_history` check.

## Integrator verification (2 Nov 06:30 AEDT)

Two P1-A examples were checked independently and confirmed:
- **103222G RMIT Graduate Diploma of Advertising:** two active non-primary official links: its own page (= course_url) and the Master of Advertising page. The website shows the Master's URL and fee 45,120.
- **107421A Griffith Graduate Certificate in Professional Accounting:** the only active official link is the Master of Professional Accounting page. The website shows that URL and fee 42,500.

**Two causes:**
1. Linking does not check the qualification level.
2. Where a course has more than one active official link and none is primary, the projection may choose a link other than course_url. This is the same class as E15; there are 239 such courses.

**Containment is not authorised by the 2 Nov 05:18 decisions.** A decision pack follows (E16) for the Platform Admin.
