# CF-247 Scholarship Coverage Recovery — Workstream B: provider-wide coverage baseline (read only)

**Date:** 2 November 2026, live reads 17:42–18:08 AEDT.
**Authority:** Platform Admin mandate *CF-247 Scholarship Coverage Recovery* (2 Nov 2026 17:41, `2026-11-02-scholarship-coverage-recovery-mandate-1741.md`), §3 and delivery order P1 (Australia), with NZ and CA counted for P3.
**Inputs read:** `../../scholarships/SCHOLARSHIP-MECHANISM.md` (v2.9), `../../scholarships/scholarship-module-plan-v1.md`, `../../scholarships/scholarship-countries-v1.md`, `../../scholarships/scholarship-operations-v1.md`, `../PIPELINE-LINEAGE.md`, `2026-11-02-firecrawl-unlimited-authority-1639.md`; pattern mirrored from `2026-11-02-aer-catalogue-provider-coverage-reconciliation.md` and `2026-11-02-aer-phase-a-baseline.md`.
**Code:** Pilot `main` `a0e54a76` (v2.15.407), read only. Worker seen live: `coverage-sweep-worker-v0.57.0`, extractor `scholarship-sweep-v0.7.3`.
**Method and load:** `SELECT`s only on `fxcwkweaxjtknorudmwp`; `statement_timeout` 8 s; per-country reads in the 17:56–17:57 and 18:06–18:07 windows; no writes, AI, Firecrawl or edge-function calls. One per-country read hit the 8 s limit inside `security.scholarship_university` (per-row group lookup) and was re-run without it; the university flag was then computed set-wise with the same rule (§1.2). Figures are observations at the time stated, not targets.
**Per-provider file:** `ui-audit/scholarship-provider-coverage-2026-11-02.csv` (2,606 rows, one per eligible provider; column notes in §9).

**What this document is not:** no decision, no schema, no production change. Items for the Platform Admin are in §8.

---

## 1. Denominator

### 1.1 Rule

Built from the canonical catalogue, as the mandate requires, not from the discovery queue:

1. `catalogue.providers.country_id` → `ref.countries`, with `scholarship_ingestion_enabled = true` (live: AU, NZ, CA only);
2. `lifecycle_status = 'active'`;
3. `publication_status = 'published'`;
4. `enrols_international is true` (same international-intent field as the AER baseline).

No restriction by course count, onboarding cohort or prior discovery.

### 1.2 University / non-university split

The live rule is `security.scholarship_university(p)`:
- AU: `security.australian_university` — an active university-group membership, or a canonical name containing "university" that does not also contain college, pathway, language centre, senior, theology or divinity.
- NZ and CA: the same test, with "université/universite" accepted.

Computed set-wise (same predicates). Side effects of the name rule worth knowing: Torrens University Australia is **not** a university under it, because its canonical name includes associated colleges. The University of Newcastle and UNSW Sydney count only through their group membership.

### 1.3 Live count (17:43 AEDT)

| Country | Eligible | Universities | Non-university | Outside the denominator (reported separately) |
|---|---:|---:|---:|---|
| AU | **1,279** | 40 | 1,239 | 261 active but unpublished; 16 archived |
| NZ | **197** | 8 | 189 | 219 with `enrols_international` null (unknown) |
| CA | **1,130** | 95 | 1,035 | — (659 of the 1,130 have no website on record) |
| **Total** | **2,606** | **143** | **2,463** | |

### 1.4 Documents and code disagree about who is eligible

| Source | Rule it states |
|---|---|
| `scholarship-countries-v1.md` §1 (9 Oct) | AU provider pages: "universities (admission universities only)"; NZ and CA: universities |
| `SCHOLARSHIP-MECHANISM.md` §7 and §9 (v2.9, 13 Oct) | Searched: AU providers with at least 30 active CRICOS courses (setting `scholarship_min_courses`), plus overseas universities. Smaller providers, schools and pathway colleges are not searched |
| Live queue (`security.scholarship_discovery_refill_v1`) | Queues AU providers of **any** type with active courses that pass `fc_sch_eligible_v1` (AU needs ≥ `scholarship_min_courses` CRICOS courses). Outside AU, it queues **universities only** |
| Live admission (`security.scholarship_admit_from_provider_page_v1`) | Refuses every candidate whose provider fails `security.scholarship_university` ("not a university provider in a scholarship country") |
| Live settings tonight | `firecrawl.scholarship_min_courses` = **0** and `scholarship_cap_per_uni` = **5000**, both set under the 16:39 Firecrawl authority and this mandate, with the note "restore after 3 Nov 02:57 AEDT". `firecrawl.daily_budget_on` = **false** (same authority). The rows' `updated_at` still shows 12 Oct, so the change is recorded only in `reason` (an audit gap) |
| Mandate §3 | All active universities **and eligible non-university providers**; no restriction by course count |

**Live rule today:**
- Discovery is open to all AU providers until about 02:57 (min-courses 0, budget off).
- Admission accepts universities only.
- NZ and CA non-university providers are never queued.

The 30-course rule also lives in code as a literal in `security.fc_provider_tier_v1` (`fc_courses_v1(...) >= 30`), which sets the processing order. That is a G2 item.

---

## 2. Coverage state per provider

### 2.1 How a state is assigned

These are report dispositions only. They are not new canonical statuses.

| State | Rule (from live tables) |
|---|---|
| blocked | Scholarship search switched off (`provider_scholarship_search.enabled = false`, directory-only website), discovery row `directory_site` or `failed`, or no website on record |
| not discovered | No discovery row, no candidates, no scholarships, no listing page |
| source present never crawled | A discovery row exists (website known), but the row is still `pending` and no candidate or listing page has been read |
| partial | Anything crawled that is not proven complete |
| complete-verified | Every active listing page read, a person's coverage check (`scholarship_coverage_checks`) whose `item_hash` matches the current listing, no unread candidates and no Layer 4 pending |
| verified zero | As complete-verified, with zero listing items and zero active scholarships |

Two things stop any provider reaching complete-verified or verified zero today:
- pagination is not tracked anywhere (no column, no reader support);
- `pipeline.scholarship_coverage_checks` has **0 rows** for eligible providers.

A discovery result of `empty` is never treated as evidence of zero.

### 2.2 Counts

| Country / type | Eligible | not discovered | source present never crawled | partial | complete-verified | verified zero | blocked |
|---|---:|---:|---:|---:|---:|---:|---:|
| AU universities | 40 | 0 | 0 | 40 | 0 | 0 | 0 |
| AU non-university | 1,239 | 0 | 696 | 540 | 0 | 0 | 3 |
| NZ universities | 8 | 0 | 0 | 8 | 0 | 0 | 0 |
| NZ non-university | 189 | 30 | 0 | 157 | 0 | 0 | 2 |
| CA universities | 95 | 56 | 0 | 22 | 0 | 0 | 17 |
| CA non-university | 1,035 | 363 | 0 | 30 | 0 | 0 | 642 |
| **Total** | **2,606** | **449** | **696** | **797** | **0** | **0** | **664** |

CA "blocked" is almost entirely "no website on record" (659 providers).

---

## 3. §3 measures by country (eligible providers only)

| Measure | AU | NZ | CA | Source |
|---|---:|---:|---:|---|
| Providers with a discovery row | 1,279 | 165 | 52 | `pipeline.scholarship_discovery_providers` |
| … pending, never run (attempts 0) | 1,107 | 0 | 1 | same |
| … `empty` | 106 | 103 | 2 | same |
| … `mapped` | 65 | 62 | 49 | same |
| Discovery last run (range of `discovered_at`) | 29 Sep – 28 Oct | 3 – 30 Oct | 3 – 23 Oct | same |
| Listing pages active and read (providers) | 15 | 2 | 0 | `pipeline.scholarship_listing_pages` |
| Listing pages only "suggested", never activated (rows / providers) | 68 / 33 | 61 / 5 | 3 / 3 | same |
| Pagination complete | not tracked | not tracked | not tracked | no column or reader support |
| Candidates discovered | 15,151 | 2,618 | 2,596 | `pipeline.scholarship_page_candidates` |
| Candidates screened (read or decided) | 14,855 | 2,555 | 2,596 | same |
| Candidates unread | 296 | 63 | 0 | same (`read_status` null) |
| Candidate read failures (scrape_failed, gone, blocked) | 107 | 22 | 11 | same |
| Candidates admitted | 1,046 | 181 | 99 | `admit_status = 'admitted'` |
| Candidates refused (rejected, duplicate, withdrawn, skipped) | 13,765 | 2,353 | 2,486 | same |
| Scholarships stored | 1,797 | 183 | 120 | `scholarship.scholarships` |
| Valid (active) records | 1,220 | 181 | 99 | `lifecycle_status = 'active'` |
| Published | 892 | 151 | 65 | `publication_status = 'published'` |
| Domestic-only (active) | 13 | 0 | 0 | `audience = 'domestic'` |
| International-eligible (active) | 1,150 | 181 | 96 | `international`, `international_and_domestic` |
| Audience not stated (active) | 57 | 0 | 3 | |
| Expired or closed (active, close date passed) | 380 | 75 | 25 | `application_close_date < today` |
| … of which published | 296 | 70 | 15 | |
| Layer 4 › AI could not decide, pending | 128 | 0 | 9 | `pipeline.scholarship_ai_reviews` |
| Open publication holds | 135 | 0 | 3 | `pipeline.scholarship_publication_holds` (released_at null) |
| Firecrawl refusals for scholarships, last 30 days | share 12,950; directory_site 4,085; university_cap 1,317 | cap 15; share 1 | cap 15; share 1 | `pipeline.firecrawl_refusals_by_provider` |
| Last full scan | discovery `discovered_at` per provider (CSV) | | | |
| Next scheduled scan | **none for discovery**: it runs once per provider, and no job puts a mapped or empty provider back in the queue. Listing pages are re-read every 7 days (`pipeline.reread.scholarship_listing_days`), but only for the 17 providers with an active listing page | | | |

Rows held for scholarships across the whole table: 2,126 (2,100 at eligible providers; 26 at providers outside the denominator or with no provider).

**Domestic-only scholarships are mostly refused before they become records.**
- The "domestic-only" row above counts records only.
- At the candidate stage, 3,358 AU, 438 NZ and 197 CA pages were refused as `domestic_only`.
- Those refused pages are kept in the candidate census, not as scholarship records.

### 3.1 UNSW (diagnostic case for Workstream A, not this workstream's boundary)

| Item | Value |
|---|---|
| Provider | `22657140-1cb0-4fa7-91df-90518ea8b35b`, university (by group membership only) |
| Discovery | Status `empty`, method `map:budget`, 12 Oct. The last site map was **refused by the Firecrawl budget** and recorded as empty. 322 candidates are kept from an earlier map |
| Candidates | 322: 321 screened, 12 admitted, 307 refused, 1 unread, 3 read failures |
| Records | 18 stored; 14 active (all international-eligible); **9 published**; 6 with a passed close date (3 of them published); 4 inactive |
| Layer 4 and holds | 3 pending in AI could not decide; 2 open publication holds |
| Listing page | 1 active and read 27 Oct with **0 items**, plus 1 suggested and never activated. The JS-rendered catalogue yields nothing to the one-page listing reader |
| Firecrawl | 194 scholarship-share refusals in the last 30 days |

The Platform Admin's "about five" is below the 9 published and 14 active. The gap between the catalogues and 14 is Workstream A's to count.

---

## 4. Mechanism audit

### 4.1 Scheduled jobs (cron, 7-day window; run history is kept about 3.6 days)

| Job | Schedule (UTC) | Runs / failed (7 d) | Real outcome |
|---|---|---|---|
| scholarship-discover | `*/10` | 514 / 0 | **Stalled.** Cron "succeeds" because it only posts to the worker. Worker responses: until 16:40 AEDT `discover: []` (every queued provider held). Since 16:50, **HTTP 500 `svc_scholarship_discover_next: canceling statement due to statement timeout`** every run (one 503 BOOT_ERROR at 17:00). No discovery row has changed since 31 Oct 00:01. Queue watchdog: `scholarship_discover` **stuck**, "1106 waiting and nothing finished since 31 Oct" |
| scholarship-discover-refill | `23 * * * *` | 86 / 0 | Tops up only while fewer than `refill_keep` (30) are pending. With 1,108 stuck pending it adds nothing, so overseas universities are starved |
| scholarship-listing | `7-59/15` | 344 / 0 | Reads the 17 active listing pages; one page each, no pagination |
| scholarship-read | `*/5` | 1,020 / 0 | Running; watchdog `done` |
| scholarship-ai-extract | `* * * * *` | 5,159 / 0 | Running; AI admission on (chain qwen3-30b → gpt-4.1-mini, second-model confirm on) |
| scholarship-ai-backfill | `13 15 * * *` | 3 / 0 | Nightly. The queue holds **21,163 failed `directory site` items at 77 providers** (last 02:13 today) and 202 "no scraper credit after 3 tries" (5 providers) |
| scholarship-recheck | `*/2` | 2,580 / 0 | Running |
| scholarship-auto-publish | `29 * * * *` | 86 / 0 | Running. Last publish batch **30 Oct 23:29 AEDT** (54 batches, 1,201 IDs in all); nothing newly publishable since |
| scholarship-publication-review | `17 20 * * *` | 4 / 0 | Last withdraw batch 31 Oct 07:17 (22 batches, 90 IDs) |
| scholarship-audience / -nationality / -course-attribute(-full) / -fee-alignment / -reread-cadence / -savings | as catalogued | 0 failures | Running |

Candidate lane watchdog `scholarship_candidates`: **stuck**, "84 waiting and nothing finished since 30 Oct 05:35". It runs inside the discover call, so the same timeout stops it.

Job commands such as `security.scholarship_setting('discover_limit',6)` carry literal defaults. They should be checked against G2.

### 4.2 Caps, refusals and settings

| Setting / control | Live value | Effect |
|---|---|---|
| `firecrawl.daily_budget_on` | false (until about 02:57 AEDT 3 Nov) | `fc_sch_held_v1` returns false, so no per-university cap and no min-courses hold |
| `firecrawl.scholarship_min_courses` | 0 (documented 30; "restore after expiry") | At 30, it holds every AU provider with fewer than 30 CRICOS courses, which is most of the 1,107 queued. **Conflicts with mandate §3** |
| `firecrawl.scholarship_cap_per_uni` | 5,000 (documented 150) | At 150 per 30 days, it caused 1,317 AU refusals (RMIT 251, Sydney 113, UQ 14) |
| `firecrawl.daily_share_scholarships` | 3,500 | 12,950 AU `share` refusals in 30 days at 34 providers, including every large university |
| `scholarship_layer_settings.firecrawl_cap` (all-time) | 60,000; worker reports 29,412 left | A further all-time ceiling. It will bind during a full AU sweep |
| Directory sites | 85 providers switched off automatically; 4,085 AU `directory_site` refusals in 30 days | By design (v2.15.265/271) |
| `pipeline.reread.scholarship_page_days` | 90 | Mechanism v2.9 says 30 days. `scholarship_layer_settings.reread_days` (30) also exists: two settings for one rule |
| `firecrawl_budget_refusals` (group level) | Scholarships appear only as `university_cap` 96 on 26 and 27 Oct | The provider-level table holds the real totals above |

### 4.3 Layer 4 scholarship holds, by root cause

| Queue | Count (all / eligible) | Root cause |
|---|---|---|
| AI could not decide, pending | 137 / 137 (AU 128, CA 9) | 116 "the model's reply failed: the page could not be read" (stored copy unreadable; technical, not ambiguity); 11 audience not proven by a quote; 8 value not proven; 2 `svc_scholarship_ai_record` cancel errors |
| … at non-university providers | 84 pending at 27 AU non-university providers | **Can never be admitted:** the admission rule refuses non-university providers, so a person's approval cannot publish them |
| Publication holds, open | 140 (AU 135, CA 3 in the denominator) | 85 refused in Layer 4 › AI could not decide (L4B batches 26 and 30 Oct); 21 "research and undergraduate levels together, re-read"; 11 not open to applicants; 8 failed a check after publishing; 7 prize or award; 5 English bursary linked to degrees; 3 AI admission paused 11 Oct |
| `pipeline.layer4_review_items` (scholarship) | 6 `scope_resolution`, all superseded | none open |

### 4.4 Publication and consumer visibility

| | AU | NZ | CA | Total |
|---|---:|---:|---:|---:|
| Stored (eligible providers) | 1,797 | 183 | 120 | 2,100 |
| Active | 1,220 | 181 | 99 | 1,500 |
| Published | 892 | 151 | 65 | **1,108** |
| Returned by `website_edge_scholarship_search_v1` (active, published, not blocked) | 892 | 151 | 65 | **1,108** |
| Returned by `api.zoho_scholarship_search_v1` | 892 | 151 | 65 | **1,108** |
| Published with at least one `course_mappings` row | 756 | 80 | 36 | 872 |
| Published with a passed close date | 296 | 70 | 15 | 381 (at 42 providers) |

**Stored, published and API-visible numbers agree.** None of the 277 Layer 4-blocked providers or 7 blocked scholarships hides a published record. The losses all happen upstream of publication.

Publication rules: as in mechanism §5. The rules do not test the close date. The website API reports a passed close date as `deadline_status: closed`, but nothing separates an expired award from a closed round (mandate §7).

---

## 5. Root causes (one per systemic defect)

| # | Defect | Evidence | Affected providers |
|---|---|---|---:|
| RC1 | **Discovery picker stalled.** `svc_scholarship_discover_next` orders every pending row by `fc_provider_tier_v1` (a CRICOS course count per row) and calls `fc_sch_held_v1` per row. Before 16:39 every queued AU provider was held, so the picker returned []. Since the holds were lifted it times out on every run. Cron reports success throughout | Worker responses §4.1; watchdog "stuck"; 0 attempts on all pending rows | **1,108** (AU 1,107, CA 1) |
| RC2 | **A refused site map is recorded as a final `empty`.** A `map:budget` (or `map:403`) refusal is written as status `empty`, with `url_count` overwritten to 0. Nothing re-queues it | 26 of 40 AU universities (UNSW, Sydney, Melbourne, Monash, UQ, ANU, RMIT and others) were last mapped on 12 Oct with `map:budget`; NZ 2, CA 1; another 28 AU pending rows and 1 `directory_site` row carry `map:budget` | **29** recorded as empty (plus 29 in the queue) |
| RC3 | **Firecrawl scholarship share and per-university cap starved the large providers.** 3,500 credits a day, 150 per university in 30 days, and the 60,000 all-time cap (29,412 left) | 30-day refusals: AU share 12,950, cap 1,317 | **34** AU (every university with volume), NZ 2, CA 2 |
| RC4 | **Admission is university-only.** `scholarship_admit_from_provider_page_v1` refuses non-universities. This conflicts with mandate §3 | 754 candidates refused with that reason; 8,915 candidates at 548 non-university providers, **0 admitted**; 84 Layer 4 items that cannot be admitted | **2,463** non-university providers (AU 1,239, NZ 189, CA 1,035) |
| RC5 | **Overseas non-universities are never queued, and the queue starves overseas universities.** The refill queues only universities outside AU, and adds nothing while 30 or more are pending (the stuck AU backlog counts) | 73 CA universities have no discovery row; NZ 32 and CA 1,005 non-universities likewise | **1,110** (CA 73 universities + CA 1,005 + NZ 32 non-universities) |
| RC6 | **Catalogue and listing pages are refused, not enumerated.** Discovery keeps only detail-like URLs (`keepScholarshipUrl` drops `SCH_LISTING` paths and `?q/page/filter` queries). Listing candidates are rejected as `listing_page`. Listing sources are 150 rows (132 "suggested", never activated). The listing reader reads one rendered page, with no pagination, load-more or JS-catalogue support. Pagination is not tracked | `listing_page` rejections: AU 8,669 (491 providers), NZ 1,474, CA 1,663; 17 providers with a read listing; UNSW listing read gives 0 items | **2,606** (no provider can be verified complete); 2 listings read with 0 items |
| RC7 | **No re-discovery cadence (mandate Stage F).** `mapped`/`empty` are final. Only listing pages are re-read | No job re-queues; discovery dates 29 Sep – 30 Oct | **all crawled providers** (AU 172, NZ 165, CA 51) |
| RC8 | **Tasks report "done" without the work being done.** 1,602 `scholarship_provider_scan` tasks are done; 791 say "0 of 0 done … the rest wait their turn". The discovery rows they queued (`on_demand`) are still pending, so the task log hides RC1 | `pipeline.admin_jobs` | **~1,100** (the on_demand pending rows) |
| RC9 | **Unreadable stored copies stall Layer 4.** 116 of 137 pending AI reviews are "page could not be read" | §4.3 | ~45 AU and 4 CA providers (pending at 49 providers in all) |
| RC10 | **Closed and expired published records.** Publication does not test the close date, and nothing separates an expired award from a closed round | 381 published with a passed close date | **42** |
| RC11 | **Backfill churn on directory sites.** The nightly AI backfill re-queues directory-site pages that then fail | 21,163 failed queue items | **77** |

Not a root cause, but material: CA has 659 eligible providers with no website on record, so they cannot be searched. This is a catalogue (Layer 1) gap.

---

## 6. What "complete" needs (for Workstreams C and F)

A provider can only move to complete-verified once all of the following are in place:
- (a) its official listing or catalogue sources are recorded as active, not "suggested";
- (b) each source's result total is enumerated, with pagination recorded;
- (c) every listing item has a classified candidate;
- (d) a coverage check (automatic or by a person) matches the current listing fingerprint.

A provider can only move to verified zero with the same evidence and zero items. Nothing in the live schema records (b) today.

---

## 7. Independence of the baseline

The population here comes from `catalogue.providers` × `ref.countries`, not from `scholarship_discovery_providers`. That keeps the denominator independent of the ingestion mechanism (mandate §8).
- The discovery queue covers every AU provider only because the on_demand tasks queued them.
- It covers 165 of 197 NZ providers and 52 of 1,130 CA providers.

---

## 8. Settings and decisions for the Platform Admin

1. **`scholarship_min_courses`.** It is due to be restored to 30 after 02:57 AEDT on 3 Nov. That conflicts with mandate §3 ("do not restrict to providers with many courses"). Decide whether 0 stays permanently. The literal 30 in `security.fc_provider_tier_v1` (ordering only) needs a G2 setting either way.
2. **Admission for non-university providers.** The documented and live rule is universities only (countries v1 §1; `scholarship_admit_from_provider_page_v1`); the mandate includes eligible non-university providers. Decide the policy and which provider types are eligible. If it changes:
   - the 84 Layer 4 items at non-university providers can then be decided;
   - 8,915 non-university candidates would need re-screening.
3. **Firecrawl after expiry.** Decide the values to restore for:
   - `daily_budget_on`;
   - the scholarship share (3,500 a day);
   - the per-university cap (150; 5,000 tonight);
   - the all-time scholarship cap (60,000; 29,412 left).

   At the documented values the large universities stay refused (RC3). A provider-wide AU recovery needs a sized allowance.
4. **Denominator choices:**
   - include or exclude the 219 NZ providers with unknown international intent;
   - treat CA's 659 providers with no website as "blocked — catalogue gap" (as here), or route them to Layer 1 source finding.
5. **Expired versus closed round.** Decide whether a published scholarship whose close date has passed (381) stays published as "closed", or is withdrawn until its next round is evidenced.
6. **Audit gap.** `pipeline.platform_toolset_settings.updated_at` was not updated by tonight's value changes (it still shows 12 Oct). The change is recorded only in `reason`.

Routine, non-destructive fixes covered by standing authority are not listed here:
- RC1 picker query plan;
- RC2 refused map not final;
- RC5 refill counting only pickable rows;
- RC8 task completion truth;
- RC6 listing activation and pagination;
- RC7 cadence.

They go to Workstreams C, E and F through the integrator.

---

## 9. CSV columns (`ui-audit/scholarship-provider-coverage-2026-11-02.csv`)

Rows are sorted by country (AU, NZ, CA), then universities first, then by name.

| Column(s) | What it holds |
|---|---|
| `provider_type` | §1.2 rule |
| `coverage_state` | §2.1 |
| `sources_identified` | 1 if discovery mapped or empty, plus the number of active listing pages |
| `discovery_*` and `last_full_scan_discovered_at` | `scholarship_discovery_providers` |
| `map_urls`, `map_kept` | `url_count`, `kept_count` (`url_count` is overwritten by a refused map) |
| `listing_*` | `scholarship_listing_pages` |
| `pagination_complete` | always "not tracked" |
| `candidates_*` | `scholarship_page_candidates`. Unread = `read_status` null; failures = scrape_failed, gone, blocked; refused = any decided status other than admitted |
| Scholarship counts | `scholarship.scholarships`, active records unless named otherwise |
| `published_visible_website_api` / `_zoho_api` | The two functions' predicates applied per provider (no API call made) |
| `layer4_ai_pending` / `_refused` | `scholarship_ai_reviews` |
| `publication_holds_open` | Open `scholarship_publication_holds` |
| `firecrawl_refusals_30d` | `firecrawl_refusals_by_provider`, scholarship group |
| `person_coverage_check` | `scholarship_coverage_checks` |
| `next_scheduled_discovery` | §3 |
| `gaps` | Semicolon list of report gap codes |

Measured, not inferred. Course counts per provider were not read, to keep the load low.
