# NZ enrichment brief: assessment against the live platform

**Date:** 23 Oct 2026 (Fri, Melbourne), 20:10
**Requested by:** Platform Admin (attached brief "senior data engineer and NZ international-education domain expert")
**Scope:** the brief's Steps 0 and 1 (introspection, pipeline audit, key integrity, gap analysis, proposals). Nothing created. Step 2 (interview) follows once this is read.
**Source of figures:** the live Supabase project, read at 20:10 through the connected Supabase tool. Active NZ courses only (`lifecycle_status = 'active'`).

## 1. Short answer

Most of what the brief asks to build already exists on this platform, under different names. The brief was written for a database with no pipeline; this one has a catalogued pipeline (135 scheduled jobs, 70 edge functions, 888 registered components), provenance on every admitted value (a stored copy of the page, the quote, the model, the job), a review queue (Layer 4), a change log (20,429 logged changes in 30 days), and AI readers that never overwrite a held value. The useful parts of the brief are the NZ-specific risks (the NZIST transition, EER ratings ending, the Code-signatory hard filter, fee sanity rules) and a handful of gaps in coverage and governance listed in section 6. Building a second enrichment layer beside this one would break the platform's own rules (G1, G2, G3, housekeeping) and is not recommended.

## 2. Where the platform already covers the brief

| The brief asks for | What exists | Where |
|---|---|---|
| Immutable provider key, never name or URL | `catalogue.providers.id` (uuid) with `stable_key`; the NZQA organisation code is held in `catalogue.provider_identifiers` (scheme `nzqa`, 415 of 415 NZ providers) | Layer 1 register |
| `source_provenance` per record | Every admitted value points to `evidence_id` (the stored page copy in the `evidence` bucket, 168,684 files), `source_id`, and for AI readings the quote and model on `pipeline.field_enrich_items` | Layer 2 |
| `extraction_runs` | `pipeline.admin_jobs` (tasks), `pipeline.edge_request_log` (50,000 worker calls in 30 days, each with its answer), `pipeline.uni_adapter_results`, Firecrawl `svc_fc_call_log` | Scheduled jobs |
| `field_change_log` | `pipeline.admin_control_events` for every setting, decision and admission; `pipeline.enrich_value_retractions` for values taken back; `status` and `valid_to` on fee, intake and English rows (old values are closed, not deleted) | Operations |
| `enrichment_review_queue` (quarantine) | Layer 4 review (fees below the confidence setting, campus names on too few pages, English rules a person approves) | Layer 4 |
| `last_verified_at` | Present on courses, providers, campuses, fees, English requirements, links | catalogue |
| Raw payloads in Storage, parsed values through a QA gate, never raw to canonical | Pages stored as gzip HTML; values admitted only through `security.coverage_apply_course_v1` and `security.enrich_apply_v1`, which write only where the field is empty; a person's value is locked (`pipeline.manual_locks`, 7,264 locks) | Layer 2 |
| Confidence threshold routing | `fees.confidence` setting; AI readings must quote the page and the quote is checked on the page; English rules auto-approved only when every score is quoted | Settings |
| Firecrawl: map first, never blind-crawl | Source finder (worker v0.40.x) reads robots.txt and site maps, uses Firecrawl map, keeps a source only when it covers known pages; direct read first, scraper only when blocked or needs a browser; daily credit budget by purpose (`svc_fc_spend`) | Layer 2 |
| OpenRouter cheap models, pinned | Pinned model per task (`pipeline.central_ai_settings`), `require_parameters`, returned model checked against the pinned one; cost recorded per call | Toolsets |
| NZQA backbone, weekly diff | Layer 1 register batches (NZQA pages read as `nz_cop_reads`), Code-signatory status per provider (`pipeline.nz_cop_status`, last read 20 Oct) | Layer 1 |
| Monitoring and alerts | Hourly gap-cause snapshots (`pipeline.gap_cause_snapshots`), hourly report, Task manager live line with OpenRouter results (v2.15.333), `hygiene-check`, `consumer-api-guard` | Operations |
| robots.txt, no page copy served | robots.txt honoured (`robots_disallowed` is a recorded cause); stored copies are evidence, the website reads facts only | G3 |

## 3. Introspection summary (ERD at schema level)

| Schema | Tables | Approx. rows | RLS on | Role |
|---|---|---|---|---|
| catalogue | 29 | 624k | 28 of 29 | Canonical: providers, courses, campuses, fees, intakes, English, links, identifiers, register facts |
| pipeline | 333 | 3.56m | 293 of 333 | Everything that finds, reads, admits and reviews: pages, evidence, jobs, items, queues, settings, logs |
| scholarship | 17 | 232k | 15 | Scholarship pages, readings, links |
| ranking | 8 | 283k | 8 | Rankings and observations |
| search | 10 | 36k | 7 | Website read model (refreshed, not written by hand) |
| ref | 21 | 323 | 19 | Countries, subdivisions, study levels, fields |
| pim, publishing, workflow, integration, security, private | 39 | small | mostly | Admin, exports, Zoho, roles |

Key relationships: `providers 1-n courses 1-n (course_fees, course_intakes, course_english_requirements, course_campuses, course_links)`; `providers 1-n campuses`; `providers 1-n provider_identifiers`; every course has at most one bound page in `pipeline.coverage_course_pages`, which points to `pipeline.evidence_artifacts`.

Tables without RLS: 40 in pipeline (worker-only tables reached through `security definer` functions), 3 in publishing, 3 in search, 2 in private. The website never reads tables directly (G3: it reads the frozen `website_*` functions), so the brief's concern "if students will query the DB" does not apply as written. Worth a pass anyway (section 6, item 7).

## 4. NZ field coverage matrix (6,474 active courses, 287 providers)

| Field | Populated | Freshness | Notes |
|---|---|---|---|
| Study level (NZQF-mapped) | 96.4% | all updated in last 30 days | From the register and titles |
| Field of study | 95.2% | | |
| Own course page bound | 53.5% | | The ceiling for every page-read field below |
| Delivery mode | 38.1% | | |
| English requirement | 35.5% | | 1,416 pages state no IELTS; needs university rules (71 central pages attached today, 14 rules approved automatically) |
| Duration | 35.1% | | |
| Campus | 34.7% | | 868 pages state no campus |
| Intakes | 32.6% | | NZ pages name semesters; calendar mapping added today |
| Open to international | 23.6% | | |
| International fee | 19.5% | | Fee reader reads course pages since today; 52 fees in Layer 4 |
| Course URL on the course row | 13.9% | | The bound page lives in `coverage_course_pages`, not on the course; see item 5 |
| Scholarship link | 100% | | Provider-level links; course-level scholarship matching is separate |

Quality flags found:
- 0 NZ international fees in a currency other than NZD.
- 22 NZ international fees under NZ$8,000 a year (the brief's quarantine rule): MITO, Tai Poutini, Te Wānanga o Aotearoa, The Learning Connexion, Waikato and two PTEs. Some are real (short certificates, wānanga); some are likely per-paper or domestic figures. Listed for review in section 6, item 4.
- 62 duplicate titles within a provider (same title, different course rows): mostly level or campus variants; a merge-proposal pass is item 6.
- 3,369 + 3,462 values taken from another course's page were found and taken back today (migrations 017000 and 019000); the reader now reads only the course's own page.

## 5. Pipeline audit

- **Inbound:** 135 pg_cron jobs, all catalogued (G1: 0 uncatalogued); 70 edge functions registered; the `coverage-sweep` worker (v0.43.0) does the reading in 40-odd modes; no foreign data wrappers; manual edits through the admin app only (logged, and locked against later automatic writes).
- **Provenance:** present on every admitted value (section 2). This is not a finding.
- **Write path:** canonical tables are written by `security.*` functions only; the website read model (`search.*`) is refreshed from them; triggers: `manual_lock_guard` on courses and providers keeps a person's values.
- **Recent activity:** all 6,474 NZ courses updated in the last 30 days; 50,000 worker calls; 20,429 logged control events.
- **Key integrity:** provider key is the uuid, not the name or domain; NZQA code held for every NZ provider. Course pages are keyed by course, with the URL as an attribute that can change (a changed URL is re-read and re-identified). This meets the brief's NZIST-transition requirement, with two gaps noted in section 6 (items 1 and 2).
- **Code signatory:** read from the NZQA register for 415 providers on 20 Oct. 171 PTEs, 17 polytechnics and 1 wānanga are signatories; 212 PTEs, 2 wānanga and 4 GTEs are not. The 8 universities' register pages do not carry the signatory sentence (found 20 Oct), so they are marked as enrolling international students on the basis "NZ university (must be a signatory)", a Platform Admin decision, not a register fact. See item 3.

## 6. Gap analysis and proposals (wait for approval)

| # | Gap | Proposal | Effort |
|---|---|---|---|
| 1 | **NZIST transition (to 31 Mar 2027).** The register read gives each provider's NZQA type (`UNI`, `POLLY`, `PTE`, `WANA`, `GTE`) but nothing records which polytechnics are still inside NZIST (NorthTec, Tai Poutini, WITT, Whitireia/WelTec) or when they leave. Domains and brands will move. | Add `transition_risk` (none / nzist_until_2027 / re-established_2026) and `transition_note` on NZ providers, seeded from the Government's published list, with a quarterly re-read job for those providers' sources (the source finder already re-learns a site; this schedules it). | Small |
| 2 | **Course pages keyed by URL inside a provider.** When a polytechnic's domain changes, bound pages go `fetch_failed` and are re-searched. That works but is slow and spends search credits. | A provider-level "domain moved" action (Adapter builder › Change website already exists for the home page) that rewrites the host of bound pages and re-reads them, keeping their identity proof. | Small |
| 3 | **Universities' Code-signatory status is a decision, not a register fact.** The NZQA provider page for universities lacks the sentence. | Read the NZQA Code signatory list page (one page, all signatories) as the authority instead of the per-provider page; record `signatory_basis` and `signatory_as_at`. Keep the hard filter: a provider that is not a signatory is never shown as open to international students. | Small |
| 4 | **Fee sanity rules are partial.** Confidence and quote checks exist; there is no "international fee under NZ$8,000 a year goes to review" rule, and no per-country floor setting. | Setting `fees.min_annual_international` per country (NZ 8,000; AU and CA to be set), applied at admission: below the floor goes to Layer 4 with the reason, never admitted silently. Review the 22 existing rows. | Small |
| 5 | **Course URL on the course row is 13.9%** while 53.5% have a bound page. The website and Zoho read `course_url` from the course row (G3), so students see no link for 40% of courses that have one. | Decision needed: fill `course_url` from the bound page (final address) where empty, as a logged admission, or leave the consumer shape alone. Either way, no change to the API shape. | Small, but a G3 decision |
| 6 | **Duplicates and rebrands.** 62 same-title course pairs within a provider; no merge-proposal path for rebranded or transitioned providers. | A merge-proposal table (`pipeline.merge_proposals`: kind, left, right, reason, decided_by) filled by a weekly job (same title and level and campus, or same NZQA course code), decided by a person in Layer 4. Nothing merges by itself. | Medium |
| 7 | **RLS pass.** 40 pipeline tables and 3 search tables have RLS off. They are not reachable from the website, but the brief is right that this should be deliberate and documented. | One migration enabling RLS with a service-only policy on each, after checking nothing reads them with the anon or authenticated role. | Small |
| 8 | **EER category / iQAF.** No EER field exists, so nothing stale is presented. If ratings are ever added (for the INZ 2026 work-rights rule), they need `eer_as_at_date` and `rule_version`. | Do not add EER now. Note it in the register design for when the work-rights field is built. | None now |
| 9 | **Work rights, cost of living (Tier 3 computed).** Not held. | Out of scope for data admission; a later product decision. | None now |
| 10 | **NZ proof names.** NZ pages bound by their programme code are labelled `cricos_code` (an AU name); 79 English and 88 intake gaps are blocked because that proof is not admitted for the field in NZ. | Admit the code proof for English and intakes in NZ (as was done for tuition on 23 Oct), and rename the proof label for NZ to `nzqa_code` in the UI only (no column change). | Small; a settings change plus a label |

### Top 10 empty fields by value to a prospective student (NZ)

| Rank | Field | Empty | Why it matters | Fastest route |
|---|---|---|---|---|
| 1 | International fee | 80.5% | The first question asked | Fee reader on course pages (running since today); central fee pages for universities |
| 2 | Intakes | 67.4% | Decides the application window | Calendar mapping (today); university calendars for the 439 "not found" |
| 3 | English requirement | 64.5% | Eligibility | University rules (central pages; 429 universities without one) |
| 4 | Campus and city | 65.3% | Where they will live | Existing-campus link from one page (today); 868 pages name none |
| 5 | Duration | 64.9% | Visa length and cost | Labelled page data (today) |
| 6 | Open to international | 76.4% | Hard filter | Provider rule where the page is silent (signatory + course level) |
| 7 | Delivery mode | 61.9% | Visa eligibility (online-only is not) | Page data labels |
| 8 | Course page link on the course | 86.1% | Where to apply | Item 5 above |
| 9 | Entry requirements (academic) | not held | Eligibility | New field; AI reader with quote (Tier 1 in the brief) |
| 10 | Scholarship deadlines per course | provider-level only | Money and timing | Scholarship reader already holds deadlines per scholarship; course matching is the gap |

The 46.5% of NZ courses with no bound page cap every field from 1 to 7. The gap engine shows the causes (1,693 "search and AI page match found none", 1,056 "web search queued"); the source finder and programme reader are the route, not a new crawler.

## 7. What not to do

- Do not build a parallel `staging → QA gate → canonical` path, a second `extraction_runs` table or a second review queue: they exist, and a second set would break G1/G2 and the housekeeping rules.
- Do not switch to Firecrawl JSON-schema scraping for Tier 1 pages: the platform reads pages directly (free) and uses the AI only on stored copies with on-page quote checks; the scraper is reserved for blocked or browser-only pages within a daily budget.
- Do not key anything on provider name, domain or URL (the platform does not).
- Do not add Pydantic schemas or an external runner: the delivery pattern is migrations, edge functions and pg_cron, which is what the brief's default pattern asks for.

## 8. Interview (one question at a time, per the brief)

The first question is in the chat reply: whether to proceed with items 1, 3, 4 and 10 (small, no consumer-API change) as one release, and to park 2, 5, 6 and 7 for separate decisions.
