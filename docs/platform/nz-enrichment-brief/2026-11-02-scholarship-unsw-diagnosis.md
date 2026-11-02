# CF-247 Scholarship Coverage Recovery — Workstream A: UNSW diagnosis and recovery plan (P0, first execution under §4)

**Mandate:** `2026-11-02-scholarship-coverage-recovery-mandate-1741.md` (Platform Admin, 2 Nov 2026 17:41), §4 and §14 P0.
**Prepared:** 2 Nov 2026, 17:42–18:10 AEDT, by Workstream A (development agent). Read-only: no production writes, no Layer 4 decisions, no AI calls, no Firecrawl calls. Database reads on `fxcwkweaxjtknorudmwp` only, `statement_timeout 8s`, keyed by provider; the heavier reads ran at :56–:58.
**For:** the Integration Controller, who commits this file and runs §6 through the existing platform paths.
**Companion data:** `docs/platform/nz-enrichment-brief/ui-audit/scholarship-unsw-reconciliation-2026-11-02.csv` (one row per known UNSW opportunity: 328 platform candidates, 2 stored records without a candidate, 8 awards found on the official source only).

---

## 1. The answer in brief

| Measure | UNSW Sydney | UNSW College |
|---|---|---|
| Stored scholarship records | **18** | 0 |
| Published (active, `publication_status = published`) | **9** | 0 |
| Returned by the consumer API (`website_v2_scholarships`, provider `provider:cricos:00098g`) | **9** (all 9; `student_types=international` also 9; `open_only` 0) | 0 |
| Published with at least one course link (what course pages, Zoho and course search show) | **6** | 0 |
| Candidate pages ever found | 322 | 6 |
| Candidate pages found since 11 Oct 2026 | **0** | 0 |
| Last scholarship discovery (site map) | 12 Oct 2026 — refused for budget, recorded as `empty`, never re-queued | never run (`pending`, 0 attempts, since 1 Oct) |
| Official listing totals | **not published by either catalogue in readable form** (both are JavaScript search applications; see §4) | not checked |

The Platform Admin's "about five" matches what a person sees on course pages: 6 of the 9 published UNSW scholarships carry a course link, and the consumer API returns all 9. Nothing published is being lost in the API. The gap is upstream: **UNSW has not been searched for scholarships since 12 Oct 2026**, the two official catalogues were never registered as sources, and the platform has no way to turn a listing or umbrella page into separate awards.

One official page read today proves the gap without needing a total: *UNSW Scholarships for International Students Commencing Term 1, 2027* lists 10 international awards (13 award codes). The platform holds 2 of them as published records (PUCA1026, International Student Award) and 1 as an inactive retired-register record (PUCA1024). The other **8 international awards are not discovered**, including the International Scientia Coursework Scholarship (PUCA1025: full tuition or A$20,000 a year).

## 2. Provider identities

| Identity | Provider id | Stable key | Website | Notes |
|---|---|---|---|---|
| UNSW Sydney | `22657140-1cb0-4fa7-91df-90518ea8b35b` | `provider:cricos:00098g` | https://www.unsw.edu.au | Tier 0 (top-50 cohort). Holds all 18 records. |
| UNSW College | `93c852cf-6df7-4161-82bd-ca95941cc227` | `provider:cricos:01020k` | https://www.unswcollege.edu.au | Pathway college, tier 3. Its candidates are refused by the "not a university provider" rule. |
| UNSW Canberra | — | — | — | **No separate provider identity.** It is a campus of UNSW Sydney (CRICOS 00098G). Its scholarship pages (`www.unsw.edu.au/canberra/...`) are candidates of UNSW Sydney: 6 found, 2 stored (KoSASA published; UNSW International Postgraduate Research Scholarship held). No mis-association found. |

`public.providers` has no UNSW row (it is not the canonical catalogue); `catalogue.providers` is.

## 3. Live state (read 2 Nov 2026, 17:42–17:58 AEDT)

### 3.1 Discovery (`pipeline.scholarship_discovery_providers`)

| Provider | status | method | url_count | kept | attempts | discovered_at (UTC) | reason |
|---|---|---|---|---|---|---|---|
| UNSW Sydney | `empty` | `map:budget` | 0 | 322 | 1 | 2026-10-12 13:07 | on_demand |
| UNSW College | `pending` | `sitemap(1)` | 222 | 4 | 0 | 2026-10-01 23:10 | on_demand |

The last UNSW Sydney map was refused by the scholarship budget of that day; the worker records a refused map as `empty` (no candidates), and the picker (`svc_scholarship_discover_next`) only takes `pending` rows, so UNSW was never searched again. On 13 Oct a further 194 UNSW scholarship calls were refused (`firecrawl_refusals_by_provider`, group `scholarships`, reason `share`). There have been no UNSW scholarship refusals since, because nothing has been attempted.

### 3.2 Listing pages (`pipeline.scholarship_listing_pages`)

| id | URL | source | active | status | items |
|---|---|---|---|---|---|
| 8 | https://www.unsw.edu.au/study/your-future/international-scholarships | auto | yes | read 27 Oct | **0** |
| 65 | https://scholarships.online.unsw.edu.au/scholarship/sc_al_search.search | suggested | no | suggested (never read) | 0 |

Neither official catalogue named by the Platform Admin is a source. The one active listing page reads 0 items.

### 3.3 Candidates (`pipeline.scholarship_page_candidates`)

UNSW Sydney, 322 candidates (found 29 Sep–11 Oct; last read 11 Oct, one 27 Oct):

| Outcome | Count |
|---|---|
| Admitted → stored | 12 (+1 matched to an existing record, +3 admitted then withdrawn) |
| Duplicate of a stored record | 1 |
| Rejected | 303 |
| Page gone | 3 (2 never classified) |

By host: `www.unsw.edu.au` 271, `www.scholarships.unsw.edu.au` 45 (of which only 26 are `/scholarships/id/N` pages, all legacy addresses), `scholarships.online.unsw.edu.au` 3, other UNSW sub-sites 3. The largest group is 123 pages under `/arts-design-architecture/our-schools` (staff, news and school pages that mention "scholarship").

AI (`pipeline.scholarship_ai_extractions`, run_kind `admit`): 314 of the 328 UNSW candidates were read by the active chain (Qwen3 30B, then GPT-4.1 mini). Latest verdict per candidate (both providers, 328): `not_scholarship` 229, `listing` 37, `scholarship` 45 (8 admitted, 1 admitted then withdrawn, 36 refused by the fixed rules, the provider-type rule or a person), none 17 (read before AI admission, matched, gone or human-decided). **AI queue: 0 pending** (`scholarship_ai_queue` 451 rows, all `done`). Nothing is waiting for AI interpretation.

UNSW College, 6 candidates: 2 international merit scholarships (`2023-unsw-college-merit-scholarship`, `regional-merit-scholarship`) read by the AI as international scholarships but refused with "not a university provider in a scholarship country" (`security.scholarship_admit_from_provider_page_v1` → `security.scholarship_university`); 1 domestic only; 1 not a scholarship; 2 PDFs (`not_html`).

### 3.4 Stored records (`scholarship.scholarships`, UNSW Sydney)

| # | Scholarship | Audience | Status | Why not published (if not) |
|---|---|---|---|---|
| 1 | Scientia Scholarship (`/scholarships/id/102`) | intl + domestic | **published** | — (source is a legacy address; see RC6) |
| 2 | International Student Award | international | **published** | — |
| 3 | Australia's Global University Award (PUCA1026) | international | **published** | — |
| 4 | ARC Laureate Fellowship: PhD Scholarships on Evacuations | intl + domestic | **published** | closes 18 May 2026 (round closed) |
| 5 | Green Fellow PhD Scholarship in Comparative Constitutional Law | intl + domestic | **published** | closes 21 Aug 2026 (round closed) |
| 6 | Scientia PhD scholarship – identifying healthy burning practices | intl + domestic | **published** | — |
| 7 | UNSW PhD Scholarship program for KoSASA (Canberra) | international | **published** | page re-read gives `name_mismatch` |
| 8 | Michael Tallis PhD Research Travel Award | international | **published** | closes 28 Jan 2026 (round closed); a travel award |
| 9 | NDARC postgraduate scholarships | intl + domestic | **published** | — |
| 10 | AGSM Women in Leadership Scholarship | intl + domestic | unpublished | no stated award value |
| 11 | Global Taste of Research – India Summer Practicum (UGVC1062) | international | unpublished | no stated award value |
| 12 | Scientia PhD scholarship – ecosystem restoration through rewilding | intl + domestic | unpublished | no stated award value |
| 13 | UNSW Swimming Safe Grant | intl + domestic | unpublished | no stated award value; not a study scholarship |
| 14 | SAM Alumni Creative Residency and Grant | international | unpublished | Layer 4 refusal L4B-20261030-1138 (international not proven) |
| 15 | UNSW International Postgraduate Research Scholarship (Canberra) | intl + domestic | inactive | hold "AI admission paused 11 Oct 2026" (audience quote did not prove who it is for) |
| 16 | ARC Future Fellowship PhD Scholarships … Military and the Constitution in Asia | domestic | inactive | domestic only |
| 17 | UNSW scholarships for international students (a listing page) | international | inactive | listing page admitted in error, withdrawn |
| 18 | UNSW Business School International Scholarship (PUCA1024) | not stated | inactive | Study Australia register record (register retired 11 Oct); never got a provider page, although the award is on the official Term 1 2027 page |

Course links: 6 of the 9 published have mapped course links (International Student Award 450, PUCA1026 450, Scientia Scholarship 249, Scientia PhD burning 34, Green Fellow 4, ARC Laureate 4); KoSASA, NDARC and Michael Tallis have none (allowed: Platform Admin 11 Oct 2026). Layer 4 search blocks: 0.

### 3.5 Firecrawl for UNSW scholarship work

`pipeline.coverage_vendor_usage`, purposes `sch_*`, UNSW Sydney all time: `sch_scrape` 398 credits (last 27 Oct, listing page re-read), `sch_map` 1 (11 Oct), `sch_search` 4 (29 Sep). UNSW College: 3 scrape credits. Refusals: 13 Oct `scholarships/share` 194 (UNSW Sydney); central-page `not_due` refusals 13–22 Oct are course work, not scholarships. `pipeline.firecrawl_calls` holds no scholarship use case for UNSW (the scholarship worker logs only to `coverage_vendor_usage`); its UNSW rows are course work: `read_page` 477 credits and `find_page` search 446 credits (6 Oct–2 Nov), `adapter_builder` 3 (UNSW College 2).

Platform scholarship Firecrawl, all providers: lifetime `sch_*` 30,596 credits; last 7 days 1,367 (13 maps); last 24 h 10. The burn authorised at 16:39 has not reached scholarships at all.

## 4. Source analysis (official UNSW catalogues)

Fetched read-only through WebFetch (9 fetches, 3 refused by the session allowlist and not retried). No Firecrawl, no endpoint guessing, no authentication.

| Catalogue | What it is | Total published? | Pagination | Detail pages |
|---|---|---|---|---|
| General: https://www.scholarships.unsw.edu.au/scholarships/search (home: https://scholarships.unsw.edu.au/) | Coursework (UG and PG) scholarship search. Facets: keyword or scholarship code, education level, faculty, residency status, study area, specific criteria, "only display open scholarships". Results render in the browser; none are in the served HTML. | **No total is readable** in the served page. Not established. | Not visible in served HTML (JavaScript application). | Two address styles. Current: slug pages `www.scholarships.unsw.edu.au/<slug>` (e.g. `/international-student-award`, `/australias-global-university-award-puca1026`). Legacy: `/scholarships/id/N` — some still render (e.g. `/id/1988`, the Term 1 2027 international umbrella page), others now show the catalogue home (`/id/1895`) or old test pages (`/id/1589`, H1 "TEST"). Applications go through `scholarships.online.unsw.edu.au` (login). |
| HDR: https://www.unsw.edu.au/research/hdr/scholarships (the Platform Admin's link adds `#search=&filters=residency:International funding_type:Living Allowance&sort=relevance&startRank=1&numRanks=10`) | Research scholarship finder with "Personalise" and "Show filters". The fragment parameters (`startRank`, `numRanks`, `filters`, `sort`) are the browser search application's state; the fragment is never sent to the server, so a scrape of this URL returns the unfiltered shell. | **No total is readable** in the served page. Not established. | Ranked pages of `numRanks` results from `startRank`, driven by script; the underlying search request is not exposed in the served HTML, and the browser network view is needed to see it (not available to this agent). | Not visible in served HTML. |
| HDR projects: https://www.unsw.edu.au/research/hdr/find-a-project (+ `/scientia-phd-projects`) | Database of supervisor projects, some funded with a scholarship; the Scientia PhD scheme says "A total of 20 scholarships will be available for commencement in 2027" (domestic applicants, per its heading). | Projects: not readable. Scientia PhD: 20 awards (one scheme, not 20 records). | Script-driven. | Project pages under `/research/hdr/our-projects/...` and faculty sites; the platform found 3 of them. |

Other official UNSW scholarship directories identified (from the platform's own candidate set and search results; each is an entry point for Stage A, not counted):
- Faculty and school pages: Business (`/business/study-with-us/postgraduate-research/postgraduate-research-scholarships/...`, AGSM scholarships), Science (`/science/study-with-us/postgraduate-research/...`, school pages under `/science/our-schools/*/student-life-resources/scholarships`), Engineering (`/engineering/study-with-us/...`), Medicine and Health (`/medicine-health/our-schools/*/postgraduate-research/scholarships`, population health HDR scholarships), Law and Justice (`/law-justice/study/postgraduate-research/...`), Arts, Design and Architecture.
- Research-centre pages: NDARC, Centre for Ecosystem Science graduate projects (`/research/ecosystem/study-us/graduate-projects/...`), CHeBA, SPRC, plus `research.unsw.edu.au`.
- UNSW Canberra: `/canberra/study-with-us/scholarships` (international PhD programmes: KoSASA, Maharashtra–UNSW, CSC-sponsored).
- International umbrella pages per intake (Term 1 2027: `/scholarships/id/1988`; earlier intakes at other ids). One page lists many coded awards, mostly without their own link.
- Indigenous: `indigenous.unsw.edu.au` scholarship opportunities. Equity, exchange and refugee scholarships: on the general catalogue (domestic or exchange; out of international scope but kept in the census).
- UNSW College: `unswcollege.edu.au` merit scholarships (pathway provider).

**Not established, deliberately:** a total for either catalogue. Neither served page states one, and the mandate forbids inventing one. The total is to be read by a rendered Firecrawl acquisition (§6, step 6) and recorded as observed, with the pagination stop condition.

## 5. Classification against mandate §2 (UNSW, scholarship by scholarship in the CSV)

| # | Mandate §2 category | UNSW count | Evidence |
|---|---|---|---|
| 1 | Not discovered | **≥ 8** awards proven (Term 1 2027 umbrella: PUCA1025, PUCA1028, PUCA1023, UGCA1603, UGCA1606, PUCA1027, PGCA1107, UGCA1815/1817/1818/1825); rest of both catalogues **unknown** (no total) | §1, §4 |
| 2 | Discovered but not crawled | 0 (1 candidate unread but matched to the stored Scientia Scholarship) | candidates |
| 3 | Crawled but not converted into candidates | **31** listing and umbrella pages read and refused as `listing_page`; their listed awards were never turned into candidates | CSV |
| 4 | Candidates refused incorrectly | **2** (UNSW College merit scholarships, provider-type rule; a policy question, see RC9). No UNSW Sydney refusal found to contradict both the AI and the fixed rules. | CSV |
| 5 | Awaiting AI interpretation | **0** | AI queue all done |
| 6 | Missing verified international eligibility or value | **19** candidates (AI: a scholarship; page does not state international eligibility) + **4** stored without a stated value | CSV; §3.4 rows 10–13 |
| 7 | Held in Layer 4 | **3** (SAM Alumni L4B-20261030-1138; 2 candidates refused by a person) | §3.4 |
| 8 | Stored but unpublished | **8** (rows 10–13 and 15–18 of §3.4: 4 active without a stated value, 4 inactive; row 14 is under category 7) | §3.4 |
| 9 | Published but not returned by the APIs | **0** (consumer API returns 9 of 9; 3 lack course links, so they do not appear on course pages, by policy) | §3.4 |
| 10 | Incorrectly associated with a provider | 0 found (Canberra pages correctly on UNSW Sydney) | §2 |
| 11 | Deduplicated into unrelated records | 0 (1 correct duplicate: International Student Award) | CSV |
| 12 | Excluded by search filters | 0 at the API (`open_only` returns 0 because no UNSW record has an open window — 3 published ones have past close dates, the rest have none) | §1 |
| 13 | Stalled (scheduler, adapter, budget, queue) | **UNSW as a whole**: discovery refused 12–13 Oct, recorded as `empty`, never re-queued; since 16:50 AEDT today every `scholarship_discover` run fails (RC1) | §3.1, RC1 |
| — | Legitimately excluded (kept in census) | 254 UNSW Sydney (228 not scholarship pages; 13 domestic only; 9 legacy addresses; 3 gone; 1 correct duplicate) + 4 UNSW College | CSV |

## 6. Root causes (one per defect) and likely reach beyond UNSW

Counts are live (2 Nov 2026 17:45–17:58) from `scholarship_discovery_providers` (1,860 rows), `scholarship_listing_pages` (150) and candidates.

| RC | Defect | Evidence | Providers likely affected |
|---|---|---|---|
| **RC1** | **Discovery picker times out; discovery is stalled platform-wide.** `svc_scholarship_discover_next` orders every `pending` row by `security.fc_provider_tier_v1()` and filters with `fc_sch_held_v1`, `provider_sch_search_off_v1`, `third_party_host_v1` per row. With 1,138 pending rows and tonight's load it exceeds the service statement timeout: the same selection, run read-only as a plain query at 17:56, took **6.8 s** to return 6 rows. Earlier today (00:50–05:40 UTC) it returned nothing at all (`discover: []`, 28 runs) while `daily_budget_on` and the 30-course rule still held everything; since 05:50 UTC every run returns HTTP 500 "canceling statement due to statement timeout" (5 of 5) and one BOOT_ERROR. `cron.job_run_details` shows "succeeded" because the cron only posts the request; the failure is visible only in `net._http_response`. | 1,137 AU + 1 CA providers `pending`, 0 attempts. Scholarship Firecrawl in the last 24 h: 10 credits. |
| **RC2** | **A refused or empty map is terminal.** The worker records a refused map (`map:budget`, `map:scholarship_share`, `map:credits_refused`) as status `empty`; the picker takes only `pending`, and the refill job only inserts providers never queued. There is no re-discovery cadence for `empty` or `mapped`. | UNSW since 12 Oct. AU `empty` 225 (35 last refused by budget; 212 older than 14 days; 25 of them hold published scholarships, so "empty" is wrong); NZ `empty` 201; AU `mapped` 75 (64 older than 14 days). |
| **RC3** | **One entry point per provider.** Discovery maps only `website` (`site.origin`) with `search: "scholarship"`. Separate catalogues (scholarship subdomains, HDR finders, faculty and research-centre directories) are never sources. `scholarship_listing_pages` is the only place a second URL can live, and it is read for comparison only. | UNSW (2 catalogues + faculty). Platform: only 18 active listing pages for 17 providers; 132 suggested listing pages never activated; 7 new candidates found platform-wide in the last 7 days. |
| **RC4** | **Listing-only capture (no fan-out).** `scholarshipListing()` (`coverage-sweep/scholarship.ts`) extracts up to 80 `{name,url}` items, `svc_scholarship_listing_record` stores them as `items` for the coverage comparison, and nothing turns them into candidates. Umbrella pages that list several awards are refused as `listing_page` by `admissionCheck()` and by the AI (`listing`), so their awards are never separate records. | UNSW: 31 listing/umbrella pages; 8+ awards proven missing. Platform: 11,806 candidates refused with `listing_page` at 616 providers (an upper bound: it includes pages that are not scholarship lists). |
| **RC5** | **JavaScript catalogues and pagination are not enumerated.** `readSch()` scrapes with `waitFor: 1500` (hard-coded), takes `rawHtml`, follows no pagination, and keeps no stop condition. Fragment-state URLs (`#search=…&startRank=…`) return the unfiltered shell. | UNSW both catalogues; any provider using a script search (Funnelback/Squiz-style finders are common in AU universities). |
| **RC6** | **Stale addresses are not detected.** Legacy `/scholarships/id/N` addresses now open the catalogue home or old umbrella/test pages; the reader records `read` and the page is refused as `listing_page` or `not_a_scholarship`, with no "redirected away" outcome. The stored Scientia Scholarship's source is such an address. | UNSW 26 legacy candidates; any provider that migrated its scholarship site. |
| **RC7** | **Hidden lifetime cap.** `svc_scholarship_fc_budget()` returns `firecrawl_cap` (60,000, all time, `scholarship_layer_settings`) and the worker refuses `sch_*` calls as `scholarship_share` once lifetime use passes it. Lifetime use is 30,596, so about 29,400 remain before every scholarship read stops, independent of tonight's Firecrawl authority. | All providers, once crossed. |
| **RC8** | **Per-university cap and 30-course rule held the top universities from 13 Oct to tonight.** `scholarship_cap_per_uni` 150/30 days (`svc_fc_spend`, `fc_sch_held_v1`) and `scholarship_min_courses` 30 kept UNSW and the other large universities out (96 `university_cap` refusals a day on 25–27 Oct). Both were raised tonight (now 5,000 and 0, `daily_budget_on` false) but RC1 and RC2 stop the effect. | The top-50 cohort and small AU providers. |
| **RC9** | **Provider-type admission rule.** `scholarship_admit_from_provider_page_v1` refuses every candidate of a non-university (`security.scholarship_university`), even when the AI reads an international scholarship with a value. Discovery policy (v2.15.265) excludes pathway colleges; admission policy is stricter than the mandate's "eligible non-university providers". | UNSW College (2); all pathway colleges and private providers with scholarships. **Needs a Platform Admin policy decision.** |
| **RC10** | **Closed round versus ended scholarship.** Publication checks "currently offered" from wording but not the application window, so 3 UNSW records with past close dates stay published, and `open_only` returns none. The mandate (§7) requires the platform to tell a closed round from an expired scholarship. | Platform-wide; measure in Workstream E. |
| **RC11** | **Hard-coded operational values in the scholarship path (G2).** `security.scholarship_task_fire_v1` (6, 30, 40), worker `Math.min(…, 6)`, `slice(0, 6000)`, listing `slice(0, 80)`, `waitFor: 1500`, pool sizes. | Platform-wide; release item. |

Dedupe (`url_norm` unique per provider; one correct duplicate) and audience filtering (domestic-only kept out; 13 UNSW) behaved correctly on the evidence. The `international_not_stated` refusals (19 at UNSW; 2,898 at 252 providers platform-wide) are the rule working as written; a share of them are HDR project scholarships that UNSW opens to all applicants without saying "international" on the page, which is for Workstream D's evidence review, not a bulk override.

## 7. Recovery tonight (Integration Controller; existing paths only)

Authority: Firecrawl unlimited until 3 Nov 02:57 AEDT (`2026-11-02-firecrawl-unlimited-authority-1639.md`). AI is **not** unlimited: US$14/day platform total, scholarship AI guard US$20 (Observe), AI admission rules unchanged. Today's scholarship AI spend at 17:56 (Sydney day): **US$0.00, 0 calls** (`scholarship_ai_extractions`); the integrator checks the platform total on Models & services › AI & OpenRouter before step 3. Each UNSW page costs about US$0.0003 (Qwen3 30B) plus US$0.0014 (GPT-4.1 mini confirmation on admissions); 1,000 new candidate pages ≈ US$0.5–2. Stop the burn of AI if the platform total reaches US$12 today (keep US$2 headroom).

Run writes only in the load-policy windows (:x6–:x8 Sydney, never :35–:42 or :47–:48), each statement with `set statement_timeout = '8s'`. Record every before value in the authority record; restore after expiry.

**Step 1 — Lift the hidden lifetime cap (RC7).** Before: `firecrawl_cap = 60000` (max 100000), lifetime used 30,596.
```sql
update pipeline.scholarship_layer_settings set value = 100000, updated_at = now(),
       reason = 'CF-247 scholarship recovery 2 Nov 2026: Firecrawl authority 16:39; restore to 60000 after 3 Nov 02:57'
 where key = 'firecrawl_cap';  -- before 60000
```

**Step 2 — Let the discovery picker answer (RC1).** Park the non-UNSW pending rows behind a lease that expires by itself, so the picker evaluates only a few rows. Nothing is deleted; status and attempts are untouched; at expiry every row is back exactly as it was. Before: 1,138 `pending`, none leased.
```sql
-- capture first: select provider_id from pipeline.scholarship_discovery_providers where status='pending' and leased_until > now();  -- expect 0
update pipeline.scholarship_discovery_providers set leased_until = now() + interval '90 minutes'
 where status = 'pending'
   and provider_id not in ('22657140-1cb0-4fa7-91df-90518ea8b35b');
```
Workstream B can release its own batches by setting `leased_until = null` for the providers it wants next (≤ 30 at a time keeps the picker fast). Check that the next `scholarship_discover` run answers 200: `select l.created_at, r.status_code, left(r.content::text,300) from pipeline.edge_request_log l join net._http_response r on r.id = l.request_id where l.mode = 'scholarship_discover' order by l.created_at desc limit 3;`

**Step 3 — UNSW pass A: map the general catalogue sub-site (RC2, RC3).** Before (UNSW Sydney row): `website https://www.unsw.edu.au`, `status empty`, `method map:budget`, `attempts 1`, `priority 0`, `reason on_demand`, `allowed_hosts {}`.
```sql
update pipeline.scholarship_discovery_providers
   set website = 'https://www.scholarships.unsw.edu.au', status = 'pending', attempts = 0, priority = 0, leased_until = null, updated_at = now()
 where provider_id = '22657140-1cb0-4fa7-91df-90518ea8b35b';
```
Then start **Provider record › UNSW Sydney › Find scholarships now** (task `scholarship_provider_scan`; it keeps the website above, re-queues unread candidates, re-reads the 18 stored pages and drives map → candidates → read). The map uses `map_limit_scholarships` (now 100,000) with sub-domains and site maps. Expected: new `map` candidates on `www.scholarships.unsw.edu.au` slug pages. Watch: `select source, read_status, admit_status, count(*) from pipeline.scholarship_page_candidates where provider_id = '22657140-1cb0-4fa7-91df-90518ea8b35b' and found_at > now() - interval '3 hours' group by 1,2,3;`

**Step 4 — UNSW pass B: map the main site again with the larger limit** (HDR, faculty and research-centre pages; last mapped 11 Oct at the old 5,000 limit). After pass A's task finishes:
```sql
update pipeline.scholarship_discovery_providers
   set website = 'https://www.unsw.edu.au', status = 'pending', attempts = 0, leased_until = null, updated_at = now()
 where provider_id = '22657140-1cb0-4fa7-91df-90518ea8b35b';
```
and press **Find scholarships now** again. Leave `website` at `https://www.unsw.edu.au` afterwards (its before value).

**Step 5 — Register the official catalogues as listing sources (Stage A; coverage anchors).** Before: only ids 8 (active) and 65 (suggested, inactive).
```sql
insert into pipeline.scholarship_listing_pages(provider_id, url, url_norm, source, active, status, next_read_at, added_at)
select '22657140-1cb0-4fa7-91df-90518ea8b35b', u, security.scholarship_url_norm(u), 'manual', true, 'waiting', now(), now()
  from unnest(array[
    'https://www.scholarships.unsw.edu.au/scholarships/search',
    'https://www.unsw.edu.au/research/hdr/scholarships',
    'https://www.unsw.edu.au/research/hdr/find-a-project',
    'https://www.scholarships.unsw.edu.au/scholarships/id/1988',
    'https://www.unsw.edu.au/canberra/study-with-us/scholarships'
  ]) u
on conflict (provider_id, url_norm) do update set active = true, source = 'manual', next_read_at = now();
```
The job `scholarship-listing` (every 15 min) reads them through the scraper. Expect the two script catalogues to read few or no items (RC5) — that result is the evidence for the release, not a failure to chase tonight. The Term 1 2027 umbrella should list its award names; they become the reconciliation list for Scholarships › Coverage.

**Step 6 — Observed totals, by hand, read-only.** After step 5, record what the scraper saw: `select id, url, status, jsonb_array_length(items) n, read_at from pipeline.scholarship_listing_pages where provider_id = '22657140-1cb0-4fa7-91df-90518ea8b35b';` and keep the stored copies. A total is recorded only if the rendered page states one.

**Step 7 — Re-screen the 19 "international not stated" UNSW pages with the AI only if Workstream D changes the evidence rule.** Not tonight under the current rule; the refusals are correct as written.

**Not tonight (needs a decision or a release):** the 8 umbrella-only awards (RC4: no own page to read; needs fan-out); UNSW College (RC9: policy decision); closed rounds still published (RC10).

**After expiry (3 Nov 02:57):** restore `firecrawl_cap` to 60000 unless the Platform Admin decides otherwise; the step 2 lease has already expired; leave the listing sources (they are correct sources, read once a week).

**Verification for the integrator:** UNSW candidates found today > 0; `scholarship_discover` responses 200; new UNSW scholarships `created_at > now() - interval '6 hours'`; AI queue drains; `website_v2_scholarships('{"provider_ids":["provider:cricos:00098g"]}')->'total'` rises from 9 only through the hourly auto-publish.

## 8. Code fixes for a release (file and function)

| Fix | Where | What |
|---|---|---|
| F1 (RC1) | migration replacing `public.svc_scholarship_discover_next`, `public.svc_scholarship_candidate_next`, `security.scholarship_discovery_refill_v1` | Store the tier on the discovery row (or a small table refreshed hourly) and order by the column; evaluate the per-provider guards only on the chosen batch; partial index `(priority, tier, provider_id) where status = 'pending'`. Move the skip-rule `update` out of `candidate_next` into its own job. |
| F2 (RC1 visibility) | job catalogue + `security.controls_check_v1` / Progress | Treat a worker 500/timeout in `net._http_response` as a failed run of the job (today cron says "succeeded"). |
| F3 (RC2) | `supabase/functions/coverage-sweep/index.ts`, mode `scholarship_discover` (record call after the map); `public.svc_scholarship_discover_record` | A refused map records `deferred` with a retry time, never `empty`; `empty` only when the map ran and found nothing. Add a re-discovery cadence for `empty` and `mapped` (setting `pipeline.reread.scholarship_discovery_days`). |
| F4 (RC3) | `scholarship_discover` mode; `svc_scholarship_discover_next` | Map every active source of the provider (website plus each `scholarship_listing_pages` row with `source in ('manual','auto')`, by origin and path), not only `website`. Activate reviewed `suggested` rows. |
| F5 (RC4) | `coverage-sweep/scholarship.ts` `scholarshipListing`; `public.svc_scholarship_listing_record`; candidate `source` check (additive value `listing`) | Fan out listing items into candidates with listing membership kept. For umbrella pages, split award sections (code such as PUCA1025, name, value, eligibility) into separate candidates that point at the umbrella page's stored copy, so the AI reads one award at a time. Item cap from a setting. |
| F6 (RC5) | `coverage-sweep/index.ts` `readSch`; listing mode | Rendered acquisition for script catalogues (longer wait as a setting, or Firecrawl actions/crawl through the approved integration), follow pagination until no new item, record `partial` with a continuation, never `complete` without the stop condition. |
| F7 (RC6) | `svc_scholarship_candidate_record`, `svc_scholarship_read_record` | When `final_url` is the catalogue home or a different page, record `redirected_away`; drop the source; flag stored records whose source redirects (Scientia Scholarship). |
| F8 (RC7) | `public.svc_scholarship_fc_budget`, worker `useFcWhy` | Retire the all-time `firecrawl_cap` in favour of the daily and monthly budgets in `svc_fc_spend` (Replaces/Retires lines). |
| F9 (RC10) | publication checks (`security.scholarship_auto_publish_v1`, `security.scholarship_publication_review_v1`) | Distinguish "round closed, recurs" from "ended"; data-level only, no consumer API shape change (G3). |
| F10 (RC11) | `security.scholarship_task_fire_v1`; worker limits | Settings with label, range, unit, `used_by` (G2, guarded by `s32`). |
| Test | central, parameterised (G4; mandate §13 item 15) | One UNSW regression fixture: Term 1 2027 umbrella → 10 award candidates; legacy `/scholarships/id/1895` → `redirected_away`; refused map → `deferred`. No per-provider spec sprawl. |

## 9. Limits of this diagnosis

- No catalogue total is established (§4). The "≥ 8 not discovered" figure is a floor from one official page.
- `international_not_stated` (19) and `not_scholarship` (228) rest on the AI and the fixed rules agreeing; they were not re-read by hand.
- Before values of the settings already raised tonight (`daily_budget_on`, `scholarship_cap_per_uni`, `scholarship_min_courses`, `map_limit_scholarships`) are the integrator's record under the authority file, not re-derived here.
- Three official pages were refused by the session's fetch allowlist and not retried.

## 10. Sources

Official pages read: [scholarships.unsw.edu.au](https://scholarships.unsw.edu.au/), [Term 1 2027 international umbrella (id 1988)](https://www.scholarships.unsw.edu.au/scholarships/id/1988), [id 1895](https://www.scholarships.unsw.edu.au/scholarships/id/1895), [id 1589](https://www.scholarships.unsw.edu.au/scholarships/id/1589), [node 342 (Term 1 2024 umbrella)](https://www.scholarships.unsw.edu.au/node/342), [HDR scholarships](https://unsw.edu.au/research/hdr/scholarships), [HDR find a project](https://www.unsw.edu.au/research/hdr/find-a-project). Live tables and functions as named in §3 and §6.
