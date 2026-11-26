<!-- Mirror of the Google Doc "StudySearch Portal - design decisions and plan" (M3 > Portal, id 1G67VeSMpwsTLCQjo0cP13XWa_beLfKwh7iVB5m3tSbo), mirrored 25 Nov 2026 by S1-API-Frontend-Delivery. This file is the source of truth once merged; the Drive copy is a mirror. Mockups 01 to 24 stay in Drive (M3 > Portal > Mockups). -->

> **Lane (Platform Admin brief, 25 Nov 2026 12:47 AEDT):** the Portal is Lane 1 work, `S1-API-Frontend-Delivery`, Release 1: read-only Portal, hybrid search and saved shortlists, first on the Worker's default `*.workers.dev` address. `portal.studysearch.ai` is connected later by the Platform Admin. The existing Admin Worker's build settings and watch paths are not touched. The search function `catalogue.portal_course_search_v1` is built by `S1-Build` (additive; G3 untouched).
>
> **Course visibility (Platform Admin, 25 Nov 2026 12:26 AEDT):** the full course search covers all active courses for now, because the published switch is not active yet (`portal_search.visibility_scope = active`). Providers and scholarships show published records only.

# StudySearch Portal: design decisions and plan
Prepared 25 Nov 2026 for the Platform Admin. Status: design only. Nothing has been built, deployed or migrated. This work still needs a lane assigned in the Continuous Delivery master plan before any build starts.

## Executive summary
Counsellors and Viewers get their own StudySearch Portal at **portal.studysearch.ai**, a separate Cloudflare Worker from the Admin UI, built from the same Pilot repository. Admin keeps managing users and roles; the portal only reads them. The portal opens on a Dashboard that greets the user by name and role and lets them resume where they left off. Counsellors can also build, edit, refresh and export student proposals as a PDF. Viewers can browse but cannot save courses or see proposals.  
The free Cloudflare plan works for the portal, with two constraints that shape the design: one build at a time across the account, and 10 minutes a day of server-side browser time for PDFs. The design handles both (path-limited builds, and an automatic fall-back to browser print).

## Decisions
| Topic | Decision | Why |
| :---- | :---- | :---- |
| Address | portal.studysearch.ai, its own Worker | Separate from Admin so a portal release can never disturb Admin, and the reverse. |
| Repository | Same Pilot repo, a second Worker with its own root directory and watch paths | Shares the Supabase client, themes, lookups and Counsellor screens. Cloudflare Workers Builds supports connecting one repo to several Workers. |
| Users and roles | Managed only in Admin (Users and Roles). Same Supabase project and user pool. | One place to grant or remove access. The portal never writes roles. |
| Who can use the portal | Counsellor (rank 2\) and above. Viewer (rank 1\) sees courses, providers and scholarships only. | Matches the Admin role descriptions. |
| Viewers | Cannot save courses or view proposals | Platform Admin decision, 25 Nov 10:37. |
| Student record | Reference (for example SS-000142), given name and family initial only | Enough to find and recognise a student. No full name, phone, email or passport number is held, which keeps privacy exposure low. |
| Proposal visibility | Every Counsellor and above sees every proposal (all counsellors treated as one team for now) | Platform Admin direction, 25 Nov 10:45. Row-level security is written so a partner-visibility rule can be added later without a rebuild. |
| Editing someone else's proposal | Allowed. Every save is a new version naming the editor. A soft note warns when someone else has it open or saved after you opened it. | Counsellors cover for each other. Versions mean nothing is lost. |
| Deleting | Proposals are archived, not deleted. Privacy deletions are done by a Platform Admin. | Matches the platform rule that no applied migration deletes data. |
| PDF | Made on the server with Cloudflare Browser Rendering; automatic fall-back to browser print when the free daily allowance is used up | Server PDFs look the same for every counsellor. Free-plan allowance is small, so a fall-back is built in. |

## Proposal lifecycle and refresh
> * Create a proposal from a shortlist: pick the student, choose courses, add next steps and student-facing notes, and an internal team note that never appears in the PDF.  
> * Statuses: Draft, Sent, Accepted, Archived.  
> * Refresh compares each saved course to the live catalogue (fees, intakes, availability). The counsellor sees a difference list and chooses Accept all or Keep my version. Refresh never changes a proposal on its own.  
> * The PDF holds the student reference and given name, the chosen courses with fees and intakes, next steps, and the student-facing notes. It excludes the team note, internal data-quality flags and other students.

## Cloudflare findings (free plan)
| Area | What the Cloudflare documentation says | Effect on this design |
| :---- | :---- | :---- |
| Builds | Free: 3,000 build minutes a month, 1 concurrent build, 20-minute timeout. Paid: 6,000 minutes and 6 concurrent builds. Concurrency is counted across the account. | Admin and portal builds queue behind each other. Watch paths keep a portal-only change from also rebuilding Admin. |
| Two Workers, one repo | Connect the repo to each Worker, set a root directory per Worker (where its Wrangler config sits), optional per-Worker build and deploy commands, and optional build watch paths so a Worker builds only when its paths change. | Supported. Portal gets its own directory, config, commands and watch paths. |
| Not stated in the docs | Whether the config file name must match the Worker name, and whether a non-default config file name is supported. | Test with a throwaway Worker before relying on either. Fallback: a portal config in its own directory with the default file name. |
| Workers runtime | Free: 100,000 requests a day, 10 ms CPU a request, 50 subrequests, 100 Workers an account. | Fine for a counsellor team. The Worker only serves the app and fetches proposal data with the user's own sign-in; the heavy PDF work is in the browser service. |
| Browser Rendering | Free: 10 minutes of browser time a day, 3 concurrent browsers. The docs do not say whether the Workers binding is available on Free. | Roughly dozens of PDFs a day, assuming about 10 seconds each (an assumption, to be measured). Check the binding on Free before Phase 5; if it is unavailable, PDFs are browser-print only until the plan is upgraded. |

One governance point: an admin runbook records the Admin Worker as a GitHub-connected Workers Builds deploy (main, npm run build, npx wrangler deploy) with the note "Do not reconfigure Cloudflare". Setting watch paths on the existing Admin Worker is a change to it, so the Platform Admin needs to approve that one setting. A Pilot repo marker file also mentions a past paid-plan retry; this plan assumes the Free plan as the Platform Admin stated.

## Phases and estimated hours
| Phase | Scope | Hours |
| :---- | :---- | :---- |
| 0 | Decisions, lane assignment, Cloudflare test with a throwaway Worker | 8 to 16 |
| 1 | Worker, domain, sign-in, role gate, security headers, deploy | 24 to 40 |
| 2 | Dashboard, last visited, name and role greeting, themes | 16 to 24 |
| 3 | Courses and Providers refresh (progressive filters, source country, sort) | 40 to 60 |
| 4 | Proposal tables, access rules, versions | 40 to 60 |
| 5 | Student PDF | 24 to 32 |
| 6 | Refresh and compare | 24 to 40 |
| 7 | Cutover, tests, documents | 16 to 24 |
| **Total** |  | **192 to 296** |

## Risks and hidden effort
> * Sign-in: invite and reset emails currently open the Admin sign-in. The portal needs its own redirect URL allowed in Supabase Auth and clear wording for counsellors.  
> * Build queue: one concurrent build on Free means a portal build and an Admin build wait for each other.  
> * PDF allowance: a busy day could exhaust 10 browser-minutes. Fall-back to browser print is part of the build, not an extra.  
> * Fonts: server PDFs must load their fonts at render time.  
> * Privacy: even a first name and initial is personal information. A privacy notice and an agreed retention period are needed before real use.  
> * Partner counsellors: all counsellors see every proposal for now. If partners are added later, visibility rules and a data review are needed.  
> * Frozen consumer API (G3): the portal only adds new objects and never changes the website or Zoho surface.

## Governance checklist before any build
> * A Platform Admin assigns this work a lane in the Continuous Delivery master plan; the lane's status table and log are updated in the same admin PR.  
> * Platform Admin approves any change to the existing Admin Worker's build settings.  
> * New portal API key registered per standing rule s935 (one key per consumer and version).  
> * Migration pre-flight, rehearsal, then the live-dry-run label; every number in a G2 setting; every new table commented; each spec starts with "Guards:".  
> * Admin repo documents updated in the same release cycle (design document, UI map, SOP mirror, test register, component register, CURRENT-STATE).

## Open items
> * Confirm whether the Browser Rendering binding works on the Free plan.  
> * Confirm the config file naming rules with a throwaway Worker.  
> * Agree retention and the privacy notice wording.  
> * Mirror this plan into docs/platform in the admin repository once a lane is assigned in CONTINUOUS-DELIVERY-MASTER-PLAN.md. Not done yet.

## Plain-English course search (hybrid pgvector)
Added 25 Nov 2026 from the pgvector brief. Design only: nothing has been built, migrated or deployed, and a Platform Admin still needs to assign a lane before any build. Screens 21 to 24 in the Mockups folder show the flow. Match scores on those screens are illustrative, because no course has an embedding yet.

### What the user sees
* Dashboard (screen 21): a large search bar under the greeting, with example prompts as chips, recent searches and the Counsellor quick actions. A Viewer sees the same bar with read-only actions. Searching opens Courses with the query carried across.  
* Results (screen 22): the query "Master of Data Science with internship in Sydney or Brisbane" turns into removable chips for Australia, Sydney / Brisbane and Master, plus one topic chip for Data Science and internship. Each course card shows a match badge with the reason, 2026 and 2027 annual and total fees, open intake pills, Save and Add to Proposal.  
* No exact match (screen 23): for "Bachelor of Nursing in Melbourne under $40,000 per year", a banner says no course matched exactly and offers one click to raise the budget to A$49,000, widen Melbourne to Victoria, or remove the budget. Near-miss nursing courses at A$42,000 to A$45,800 a year are listed underneath, each marked as a near miss.  
* Phone (screen 24): at 412 px the chips stack and can be removed one by one, and the result cards run in a single column with the same match badges.  
* Wording on screen is plain: "Understood as" for the parsed chips and "Topic match" for the meaning-based part. The words pgvector and embedding never appear.

### Embedding pipeline
* Reuse what is already live. The search schema already holds search.course_embeddings (vector(1536), HNSW index on cosine distance, 0 rows), search.embedding_jobs and search.query_embedding_cache (both 0 rows), and the fusion profiles website-default and zoho-default. pgvector 0.8.2 and pg_trgm are installed. No second embedding table or index is created.  
* Text embedded per course: title and field of education for all 36,052 active courses, even where enrichment_semantic_text is still empty. Description text is added where held, and a course is queued again automatically when a description or career outcome is admitted. Career outcomes are wired in as those rows admit; there is no course-level source today.  
* One-time backfill across the 36,052 active courses with text-embedding-3-small (1536 dimensions, matching search.course_embeddings), pinned in portal_search.embedding_model with provider data collection denied. The cost is about US$0.20 and counts against the US$5.00 a day cap.  
* Incremental updates: when a description or outcome is admitted, a trigger adds the course to search.embedding_jobs and the existing queue processes it. No new pg_cron job is added; active jobs are at 140, which is the ceiling.  
* Query embedding: SQL cannot call the model, so an edge function or the portal Worker embeds the typed query (cached in search.query_embedding_cache) and passes the vector to the search function.

### Two-stage search function
The function is named catalogue.portal_course_search_v1 in the brief. The API gateway serves only the public schema (s951), so a thin public entry point is added if the portal reads through it. Both are new and read-only. Stage 1 turns the typed words into filters and chips:

| Phrase in the query | Becomes | Valid values come from |
| :---- | :---- | :---- |
| Country | Country filter | Live ref country table |
| City or state | Campus city or subdivision filter | catalogue.campuses and subdivision codes, with city names normalised for case |
| Study level | Study level filter (Bachelor, Master and so on) | Live ref study levels |
| Maximum annual tuition | Annual fee at or under the amount, for the chosen fee year | provider_annual_tuition_amount, and course_fees where the year matters |
| Intake | Intake month or year filter | Course intake rows (active only), rolling years |
| IELTS or PTE score | English requirement at or under the score given | Course English requirements, where held |

Stage 2 ranks the courses that pass Stage 1:

* The remaining words are matched by cosine similarity to the course embeddings, combined with full-text rank as search.course_candidates_v1 already does (reciprocal rank fusion, k \= 60). The existing function is called, not changed.  
* A course with no embedding is ranked by trigram and full-text match instead, so nothing drops out of results while the backfill runs.  
* If fewer than 3 courses match exactly, relaxed passes run: the budget first, then the location. The function returns the exact matches, the near misses (each flagged with the filter it misses) and a relaxation block naming what changed, the suggested value and how many courses it would return. Filters are never relaxed silently; the original chips stay visible.  
* The suggested budget is the fee of the third-cheapest otherwise matching course, plus 5%, rounded up to the nearest A$1,000. For the sample nursing courses on screen 23 (third-cheapest fee A$45,800) that is A$49,000.

Settings follow G2 and are read with security.pipeline_num_v1 or the toolset reader. Names and defaults are proposed and are confirmed at build:

| Setting (proposed key) | Proposed default | What it controls |
| :---- | :---- | :---- |
| portal_search.relax_min_matches | 3 | Relaxation starts when fewer exact matches than this |
| portal_search.relax_budget_round_to | 1000 (A$) | Step the suggested budget is rounded up to |
| portal_search.relax_budget_headroom_pct | 5 | Percentage added to the third-cheapest matching fee before rounding |
| portal_search.relax_budget_max_raise_pct | 30 | Largest budget raise offered; beyond it only Remove the budget is offered |
| portal_search.result_page_size | 20 | Courses returned per page |
| portal_search.embedding_model | text-embedding-3-small | Model used for course and query vectors; changed only with a reason and a re-embed |
| portal_search.query_cache_hours | 24 | How long a typed query's vector is reused |
| portal_search.visibility_scope | active | Which courses are searched: active (all active courses) or published (published courses only). Set to published once publishing is live |

### Guardrails
* Strictly additive: one new function (and its public entry point), plus rows in existing settings tables. Nothing existing is altered or dropped, and the search schema is only read.  
* The consumer API stays frozen: 75 functions and 48 relations untouched, with the consumer-api guard run before merge.  
* The 7,585 manual locks are not touched. Search only reads.  
* Active cron jobs stay at 140 or below. This design adds none.  
* Model calls use a pinned, individually qualified model with provider data collection denied. Course page text is treated as untrusted. Spend is logged against the US$5.00 daily cap.  
* Migration pre-flight and a rolled-back live dry run before merge, a spec headed with its Guards line, and the admin repository documents (design, SOP mirror, UI map, test register, current state) updated in the same release.  
* Per the standing mandate, it goes live as soon as the backfill has finished, with no shadow period unless the Platform Admin asks for one.

### Checked against live data on 25 Nov 2026
* No course has an embedding yet, so every match score on screens 21 to 24 is illustrative.  
* "Internship" is not stated in the stored text of the sample data science courses. The card therefore says "internship not stated in the course text" instead of claiming a match, and a real internship filter needs a source for it.  
* The zero-match nursing example is a demonstration. On live data two Melbourne nursing courses are under A$40,000 (Institute of Health and Management, North Melbourne, A$20,000; Australian Catholic University, Fitzroy, A$39,672). The relaxation panel would still appear, because fewer than 3 courses match.  
* Some courses have no fee year or intake year set. The card shows "year not set" rather than guessing.  
* course_documents holds 34,362 rows, 25,558 with semantic text, against 36,052 active courses. The difference is checked before the backfill.  
* Parser vocabulary (cities, states, study levels, countries) is read from the live ref and campus tables, and fee and intake years roll with the calendar, as the dynamic-lookups rule (s930) requires.  
* The published switch is not active yet: 10 of the 36,052 active courses are published. Search therefore covers all active courses for now. Before visibility_scope is set to published, the source of the provider publish state is confirmed, because it was not found as a catalogue column.

### Estimated hours
Separate from the 192 to 296 hours in the phases above. These are estimates, not quotes.

* Embedding pipeline and backfill: 12 to 20  
* Query parser and live lookups: 16 to 24  
* Search function, relaxation and settings: 20 to 32  
* Portal screens (dashboard search, results, relaxation, phone): 16 to 24  
* Tests, security review and documents: 8 to 12  
* Total: 72 to 112

### Decisions confirmed 25 Nov 2026
* Embedding model: text-embedding-3-small, 1536 dimensions, pinned in portal_search.embedding_model.  
* Consumer API: catalogue.portal_course_search_v1 and its public entry point are strictly additive and are checked against the G3 guard (75 functions and 48 relations untouched) before merge.  
* Career outcomes and internships: Release 1 matches on title, field of education and existing descriptions, and never infers an internship the text does not state. Career outcomes are wired in automatically as those rows admit.  
* Visibility: Counsellors and Viewers search the active courses of published providers (34,362 on 25 Nov 2026; Platform Admin decision 22:43), the same scope as the shared search documents. The setting portal_search.visibility_scope moves the search to published courses only once publishing is live. Inactive, suspended and unknown-status courses are never searched.

## Contents of this folder
> * Combined mock-up PDF: not included. It was over the Drive connector's size limit, so only the individual images below were uploaded.  
> * Mockups folder: all 24 screens as individual images (courses in five colour themes, Dashboard for Counsellor and Viewer, Proposals, Proposal editor, the two PDF pages, Saved, Providers, Scholarships, phone views, architecture, and the four plain-English search screens 21 to 24).  
> * Live design canvas (editable): https\://claude.ai/artifact/Se7Yzvcd4Uq6NDzpYeWzNi  
> * DRAFT-portal-proposals-schema.sql: reference only, not applied.

## Release 1 data layer as built (Pilot s1143, 25 Nov 2026)

Added 25 Nov 2026 by S1-API-Frontend-Delivery. Built and rehearsed (rolled back, live); live once Pilot s1143 merges. All objects are new and read-through; nothing the website, Zoho or the Admin app reads is changed (G3: 75 functions and 48 relations checked before and after in the migration).

| Object | What it does | Who may call |
| :---- | :---- | :---- |
| `public.portal_settings_v1()` | The portal's limits (below) | Viewer (rank 1) and above |
| `public.portal_lookups_v1()` | Destination countries that have published providers (live) and every student market | Viewer and above |
| `public.portal_providers_v1(args)` | Published providers, paged on the server; filters: text, countries, provider types, states, Study Square route; the route is shown for the chosen student market | Viewer and above |
| `public.portal_scholarships_v1(args)` | Published scholarships, paged; filters: text, countries, status, intake; status worked out from the stated dates on today's Melbourne date | Viewer and above |
| `public.portal_saved_list_v1()` / `public.portal_saved_set_v1(course, saved)` | The person's own shortlist; the fee is the one the Admin app picks (`fee_used`) | Counsellor (rank 2) and above |
| `portal.saved_courses` | One row per person and course; closed to direct reads | Functions only |

**Publish rules (the same the website API v2 uses):** providers and scholarships are `lifecycle_status = 'active'` and `publication_status = 'published'` and are not in the Layer 4 blocked views. Live on 25 Nov 2026: 2,832 providers and 1,205 scholarships are published (providers: Australia 1,283, Canada 1,130, New Zealand 419). Courses on a shortlist are shown whatever their publish state, because Release 1 course search covers every active course.

**Honest labels:** Study Square route comes from `pipeline.provider_representation`, which holds no rows yet, so every provider reads "Status not recorded". A scholarship with neither an opening nor a closing date is "Dates not published" (741 of the 1,205). Scholarship value is shown from the structured award fields (`award_value_type`, amount, percentage); the free-text value is not shown because it often holds page text.

**Settings (toolset `portal`, G2, on Settings › Toolsets & limits):**

| Key | Default | Range | Used by |
| :---- | :---- | :---- | :---- |
| `providers_page_size` | 24 providers | 6 to 60 | Universities & Providers |
| `scholarships_page_size` | 20 scholarships | 5 to 50 | Scholarships |
| `saved_courses_max` | 50 courses | 10 to 200 | Saved courses (save) |
| `compare_courses_max` | 4 courses | 2 to 6 | Saved courses (compare) |
| `recent_searches_shown` | 5 searches | 1 to 10 | Dashboard |

**Course search contract the portal's Courses screen reads (for S1-Build, `catalogue.portal_course_search_v1` and its public entry `public.portal_course_search_v1(args jsonb)`):** returns `{understood: [{key, label, value, removable}], exact: [course], near_misses: [{course, misses: key}], relaxation: {key, label, from, to, would_return} | null, total}`; a course is `{course_id, title, provider_id, provider_name, level, country_code, state_code, city, duration_value, duration_unit, fee: {per_year, currency, year} | null, next_intake: {label, start_date} | null, topic_match: boolean, saved: boolean}`. A missing value is `null`, never a guess. Until the function is live the Courses screen says search is not switched on yet.


## Release 1 screens as built (Pilot s1144 to s1149, 25 Nov 2026)

Added 25 Nov 2026 by S1-API-Frontend-Delivery. All screens are in Pilot `portal/` and read only the `portal_*` functions above, plus `admin_read('context')` for the person's role.

| Screen | Route | Who | What it does |
| :---- | :---- | :---- | :---- |
| Dashboard | `#/` | Viewer and above | Greeting, plain-English search box, example searches, last and recent searches (count from setting `recent_searches_shown`), quick start; Counsellors also see a saved-courses panel (as many as `compare_courses_max`) |
| Courses | `#/courses` | Viewer and above; Save is Counsellor only | Plain-English search built to the contract below; "Understood as" chips (removable), "Topic match" badge, near misses, relaxation buttons; says "not switched on yet" until the function is live |
| Universities & Providers | `#/providers` | Viewer and above | Published providers, server-paged ("Show more"), filters from the returned facets, student-market select, Study Square route in plain words |
| Scholarships | `#/scholarships` | Viewer and above | Published scholarships, server-paged; status pills, intake select, value built from the structured award fields |
| Saved courses | `#/saved` | Counsellor and above | Own shortlist; tick up to `compare_courses_max` courses to compare side by side |

The "Study in" bar (All plus every destination the database says has published providers) sits at the top of Courses, Providers, Scholarships and Saved courses and is kept across them for the person on that browser. The student market is chosen on Universities & Providers and kept the same way.

**Honest labels.** "Not recorded" means the platform has not captured the value. "Not published" means the provider does not state it (scholarship dates). The two are never mixed. A route with no row in `pipeline.provider_representation` reads "Status not recorded"; no route is promised.

**Saved-course compare columns in Release 1:** tuition per year (with the lowest marked), total course cost (the yearly fee over the course length, marked "about"), duration, level, delivery, state and campus, next intake, last checked. Academic entry, English scores, scholarships per course and the Study Square route per course join the compare with the student profile in the next release; the saved-list function does not return them yet.

**Course search contract, as the portal reads it (supersedes the sketch in the data layer section).** Call `public.portal_course_search_v1(p_args jsonb)` (parameter named `p_args`, like the other portal functions).

| Part | Shape |
| :---- | :---- |
| `p_args` | `{ q: text, countries: [ISO code] (the Study in choice, empty for All), provider_id: uuid or null, removed: [chip key], relax: [{ key, to }] }`. `removed` lists chips the person took off; `relax` lists relaxations the person chose. Neither is ever applied by the function on its own. |
| `understood` | `[{ key, label, removable, kind }]`; `kind: "topic"` marks the topic chip. |
| `exact` | List of courses that match every filter, ranked. |
| `near_misses` | `[{ misses: chip key, miss_text: "A$2,000 over budget", course }]`, closest first. |
| `relaxations` (or one `relaxation`) | `[{ key, to, label, would_return, note }]`; the first is the suggested one. `note` carries the sentence that explains the figure. |
| `total` | How many courses match, if more than `exact` holds. |
| Course | `{ course_id, title, provider_name, level, state_code, city, duration_value, duration_unit, fee: { per_year, currency, year } or null, next_intake or `intakes[]`: { label, start_date }, topic_match, topic_score (0 to 1, optional), why: [text] (optional), course_url (optional) }` |

A value the function leaves out is shown as "Not recorded". The screen never works out a budget, a score or a relaxation itself; those numbers and their rounding are the function's settings (G2).

**Open for S1-Build:** build `catalogue.portal_course_search_v1` and the public entry to this shape, or tell this lane what differs. The Courses screen needs no further change when it goes live. `provider_id` is what "View courses" on a provider card sends.

**Data findings from the live read (for the data lanes, not screen work):** the scholarship intake list holds mixed wording ("Feb 2027", "February 2027", "Semester 1, 2027") and old years (2013 onwards), so the Eligible intake select is long; some provider names are in capitals and some providers have no type, state or city; 501 of 888 Australian scholarships have no published dates. The screens show these as they are held.

**Not in Release 1 screens (needs a data change first):** the City filter on Universities & Providers (the provider function has no city argument), "Only scholarships linked to a course" and "See the courses it applies to" on Scholarships (no link in the scholarship function), and Proposals, My reports and Guide from the mock-ups (later releases).

## Course search as built (Pilot s1153, 25 Nov 2026)

Added 25 Nov 2026 by S2-Build (Platform Admin 17:13). Built to the "Course search contract, as the portal reads it" above; the Courses screen needs no change. Pilot #1616, migration `20261127020000`, worker `coverage-sweep` v1.0.46 mode `portal_search_embed` (only the worker calls OpenRouter, Platform Admin 13 Nov 2026, so no separate edge function).

| Object | What it does |
| :---- | :---- |
| `public.portal_course_search_v1(p_args)` | The entry the screen calls (Viewer and above); passes to the catalogue function |
| `catalogue.portal_course_search_v1(p_args)` | Stage 1 filters, Stage 2 ranking, near misses and relaxations; returns `understood`, `exact`, `near_misses`, `relaxations` (and `relaxation`), `total` and `ranking` (meaning, words or title) |
| `search.profiles` row `portal-default` | Portal vectors live here only. `api.zoho_course_candidates_v1` (frozen G3) calls the same ranker under `zoho-default`, so Zoho and the website get no vectors and their results cannot change |
| Lane `portal-search-embed` (coverage-lane-dispatch) | Tops the embedding queue up by `enqueue_chunk` and starts the worker mode only when jobs wait; no pg_cron job |
| Trigger on `search.course_documents` | Re-queues a course whenever its semantic text changes (a description or career outcome admitted and projected) |
| Worker mode `portal_search_embed` (coverage-sweep v1.0.46) | Embeds courses in batches and typed topics on demand with `openai/text-embedding-3-small` (1536 dimensions) through OpenRouter, provider data collection denied; spend logged as `portal_search_embedding` |

**How words become filters (Stage 1).** Country (live countries that have courses; intersected with the Study in choice), state (live subdivisions, and Australian short codes such as VIC), campus city (live campus table). A city also matches campuses whose postcode lies mostly in that city's ABS urban area (`destination.abs_postcode_sua_shares`, read only), because campus cities are usually suburbs and no campus has coordinates: "Melbourne" finds ACU Fitzroy and IHM North Melbourne. Study level (live level codes; "Master" covers every masters code). Budget ("under $40,000", "40k"), compared with the provider's annual tuition in the budget's currency. Intake and English score are not parsed in Release 1.

**Topic.** What is left after the filters is the topic chip. A course counts as an exact match when it also matches the topic: at least half the topic words appear in its search text, or (once vectors exist) its meaning similarity is at least `topic_min_similarity`. Ranking is the existing `search.course_candidates_v1` (reciprocal rank fusion, k = 60): hybrid when the topic's vector is cached, keyword otherwise. A topic with no cached vector is embedded at once in the background and cached for `query_cache_hours`, so the first search ranks by words and repeat searches by meaning. "Internship" is never claimed when the text does not state it.

**Relaxation.** When fewer than `relax_min_matches` (3) courses match: the suggested budget is the third-cheapest course matching everything else, plus `relax_budget_headroom_pct` (5%), rounded up to `relax_budget_round_to` (A$1,000), and is offered only within `relax_budget_max_raise_pct` (30%); "Remove the budget" is always offered; a city can be widened to its state. Near misses say what they miss ("A$9,672 over budget"). Nothing is applied until the person chooses it (`removed`, `relax`).

**Settings (toolset `portal_search`, 15 rows, Settings › Toolsets & limits):** `result_page_size` 20, `relax_min_matches` 3, `relax_budget_headroom_pct` 5, `relax_budget_round_to` 1000, `relax_budget_max_raise_pct` 30, `city_postcode_min_share` 0.5, `topic_min_similarity` 0.35, `query_cache_hours` 24, `query_embed_daily_max` 5000, `embed_batch` 25 (150 timed out once the vector index passed about 21,000 rows), `enqueue_chunk` 1500, `embed_daily_ceiling_usd` 1, `embed_usd_per_mtok` 0.02, `embedding_model` openai/text-embedding-3-small, `visibility_scope` active.

**Rehearsed on live data (rolled back):** "Bachelor of Nursing in Melbourne under $40,000 per year": ACU Fitzroy (A$39,672) and IHM North Melbourne (A$20,000) first. At $30,000: 2 exact matches, near misses at A$9,672 over, "Remove the budget" (50 courses) and "Widen Melbourne to Victoria"; the A$42,000 suggestion is beyond the 30% cap so it is not offered. "Master of Data Science with internship in Sydney or Brisbane": QUT, CDU, Sydney, UTS and Western Sydney data science masters.

**Hardening (Pilot s1181, 26 Nov 2026).** Typed text and place names are folded one way (`security.portal_fold_v1`: case, accents, quotes, spacing, punctuation), so any spelling reads the same. Malformed request fields are ignored. The vector index is searched once per search, and the topic words through the text index. Filtering starts from the topic matches, and ranking is the shared fusion (k 60, words 1.0, meaning 0.55 from the `portal-default` profile) over them, so `search.course_candidates_v1` is no longer called. A search with nothing to go on returns no courses. A typed country outside Study in matches nothing. New settings: `query_max_chars` 200, `topic_max_words` 8, `topic_vector_pool` 100.

**Known limits.** 1,690 of the 36,052 active courses have no search document, because the shared document builder leaves out the courses of unpublished or archived providers (v2.15.236, Feature 4); there are 261 such providers. The portal does not search them, and they have no vector. Backfill finished 25 Nov 2026 20:27 AEDT: 34,362 of 34,362 documents embedded, 2,577,857 tokens, US$0.051567. Platform Admin decision, 25 Nov 2026 22:43 AEDT: the portal keeps this published-provider scope; a provider's courses enter the index automatically when it is published. The builder is unchanged, so website search and the frozen Zoho candidates are unaffected. Topic words also match provider names held in the search text (a provider called "... Nursing School" matches "nursing").

## Release 2 contract: student proposals (S1-API-Frontend-Delivery, 26 Nov 2026 07:15 AEDT)

The screens were built before the database functions, so this is the contract the screens call. `S1-Build` deploys functions that match it. Any difference is a change to one file, `portal/src/lib/proposalApi.js` (and the helpers in `portal/src/lib/proposals.js`), not to the screens. Every function takes one `p_args jsonb`, is a public SECURITY DEFINER function that checks the caller's role rank (Counsellor, rank 2 or above) and returns an error, not rows, for a Viewer. Until the functions exist each screen shows "Proposals are not switched on yet."

**Rules the screens already follow**

- A proposal holds a **student reference**, a **given name** and **one family initial**. No full family name, phone, email, passport or date of birth is asked for or sent. The reference is assigned by the server when blank.
- The screens send only course ids, positions, the counsellor's "why this course" lines, steps, documents and the two note fields. **The server builds and owns the course snapshots** (fees, intakes, entry, English, scholarships) and the version history. The screens never send a snapshot.
- Every limit (courses per proposal, message length, note length, "why" length) and the soft-lock window are server settings returned by `portal_proposal_get_v1`. The screens hold no number for any of them (G2). Settings go in `pipeline.platform_toolset_settings` with a label, range, unit and `used_by` line.
- Statuses: `draft`, `ready`, `sent`, `accepted`, `archived`. `ready` is new in the build ("Mark ready to send"); the first plan listed Draft, Sent, Accepted and Archived. If `ready` is not wanted, the status button is one line in `ProposalEditor.jsx`.
- The counsellor note (`internal_note`) is stored with the proposal and **never reaches the sheet**. The sheet reads only the saved proposal; the print rules hide the shell.

**Functions**

| Function | Arguments | Returns |
| :---- | :---- | :---- |
| `portal_proposal_list_v1` | `scope` (`mine` or `team`), `status` (`''`, `draft`, `needs_refresh`, `sent`, `archived`), `q` (student name or reference), `page` | `{items, total, page, page_size, facets:{counts:{mine, team}, needs_refresh_count}}`. An item: `id, title, status, needs_refresh, version, student{ref, given_name, source_country_name, qualification, result_text, english_text, preferred_intake}, courses[{course_id, title, provider_name}], change_note, updated_at, updated_by_name, updated_by_me, details_checked_at, last_pdf_version` |
| `portal_proposal_get_v1` | `id`, or `null` for a new proposal | `{proposal, defaults{steps, documents} (new only), limits{courses_max, message_max_chars, note_max_chars, why_max_chars}, others_recent[{name, opened_at}], soft_lock_minutes, counsellor{name, title, email, phone, office}}`. `others_recent` is already filtered to the soft-lock window (15 minutes by setting); the screens show whoever the server returns |
| `portal_proposal_save_v1` | `id` (null to create), `base_version`, `force`, `proposal` (title, status, student, courses[{course_id, position, why}], steps, documents, message_to_student, internal_note), `note`, `duplicate_of` | `{status:'saved', id, version, proposal}`, or `{status:'saved_after_other_edit', current_version, by_name, saved_at, changes[{label}], proposal}` when someone else saved after `base_version` (nothing is written unless `force` is true) |
| `portal_proposal_refresh_v1` | `id`, `base_version`, `decision` (`accept`, `keep`, or absent) | Absent: `{checked_at, built_at, changes[{course_id, course_title, provider_name, field, label, from_text, to_text}]}` and nothing changes. `accept`: `{status:'saved'` or `'saved_after_other_edit', proposal}`, a new version with the live values. `keep`: `{status:'kept', checked_at}`, no new version, the notice is cleared until the next change |

**Behaviour the server owns**

- Each save is a new version (`versions[{version, at, by_name, note}]`); a save by someone else is never overwritten without `force`.
- `needs_refresh` is true when the live catalogue differs from the saved snapshots in a fee, an intake or availability. A refresh never changes a proposal on its own.
- A counsellor can open and edit any proposal on the team (Platform Admin decision, 25 Nov). The list shows who saved last.
- Retention and the privacy notice wording are still the Platform Admin's decisions (see the build document, Outstanding dependencies).

## Release 2 screens as built (Pilot s1200 to s1202, 26 Nov 2026)

All three screens are Counsellor-only (a Viewer sees "Proposals are for Counsellors" and no function is called). They sit under the new **Proposals** menu item, after Courses. No migration, setting, consumer API, edge function or Admin screen was changed.

| Screen | Route | What it does |
| :---- | :---- | :---- |
| Proposals | `#/proposals` | Mine and Whole team tabs with counts, search by student name or reference, filters (All, Drafts, Needs refresh, Sent, Archived), a "built on details that have since changed" notice, and a card per proposal with status, student facts, course chips, what changed, who saved last and when, and Open, Refresh, Duplicate and PDF. Server-paged |
| Proposal editor | `#/proposals/new`, `#/proposals/:id` | Student block (minimal fields), courses with move up, move down, remove and a "why this course" line, "+ Add from saved courses", next steps, documents, a message to the student (printed) and counsellor notes (never printed), version history, Archive, and a save bar. Refresh from live data opens the difference list with Accept all changes and Keep my version, and says "Nothing changes in the PDF until you choose". It warns before leaving with unsaved changes |
| Student sheet | `#/proposals/:id/sheet` | Two A4 pages: study options side by side with fees, length, next intake, entry, English and scholarship, then next steps, documents, dates and the counsellor's details. **Save as PDF / Print** opens the browser's print window; no server renders anything, so no Cloudflare Browser Rendering quota is used and it works on desktop and phone. A missing fee or date says "Confirm with the provider", never a made-up figure |

Starting a proposal: **Saved courses** has "Create a proposal from the N ticked" (or all saved), and **Courses** has "+ Add to proposal" on each card; both fill a small session basket that the new proposal reads. A save the same moment another counsellor saves shows what they changed with "Use their version" and "Keep mine and save".

Checked on 26 Nov 2026 with the live screens against a mocked contract (the functions do not exist yet): desktop 1280 px and phone 412 px with no sideways scroll, every tap target 44 px or more on the phone, print preview exactly two A4 pages with the internal note and the shell absent, new, duplicate, conflict, up to date, keep, accept, missing-function and Viewer paths. Guards: `s1200` (helpers), `s1201` (sheet privacy and print), `s1202` (screen wiring, no hard-coded limits, no secrets). Live read-back before the PR: G3 75 functions and 48 relations, no drift; 7,585 manual locks; 138 active cron jobs; US$0.

## Release 2 data layer as built (Pilot s1210, S2-Build, 26 Nov 2026)

The functions the screens call, built to the contract above on pipeline tables (Platform Admin decisions, 26 Nov 2026 07:30; brief 07:37). Every function is a public SECURITY DEFINER function taking one `p_args jsonb` and checking the caller's own role.

| Function | Who | Arguments | Notes beyond the contract |
| :---- | :---- | :---- | :---- |
| `portal_proposal_list_v1` | Counsellor | `scope`, `status` (also `ready`, `accepted`, `all`), `q` (name, reference or title), `page` | Items also carry `expires_at`. `facets.counts` count proposals that are not archived |
| `portal_proposal_get_v1` | Counsellor | `id` or null | `counsellor` is the proposal's owner (the caller for a new one): name, work title, email, work phone, office. Opening records the open, which `others_recent` reads |
| `portal_proposal_save_v1` | Counsellor | as the contract, plus optional `refreshed_from` | Courses are kept in `position` order, each once; unknown ids are dropped. The reply also carries `saved_after_other_edit` (true when forced over a newer save). A status of `archived` archives (reason from `note`, else "Archived in the proposal editor"); saving an archived proposal with another status restores it |
| `portal_proposal_refresh_v1` | Counsellor | as the contract | Differences cover availability, fee, next intake, entry, English, scholarship and name; `needs_refresh` watches fee, intake and availability |
| `portal_proposal_archive_v1` | Counsellor | `id`, `reason` | Archives as a new version with the reason |
| `portal_activity_touch_v1` | Viewer | `kind` (`courses_search`, `proposal`, `provider`, `scholarship`), `ref`, `label`, `state` | Own rows; proposal items need Counsellor |
| `portal_activity_list_v1` | Viewer | `limit` | `{items}`, newest first, at most the setting `resume_items_shown` |
| `portal_prefs_save_v1` | Viewer | `theme`, `title`, `phone`, `office`; `{}` reads | Theme from the setting `themes`; title, phone and office print on the sheet |

**Data held.**
- `pipeline.portal_proposals` holds the student reference (assigned `SS-000001` onwards when blank; an existing reference is reused) and the given name and family initial. It also holds the academic facts: country of education, qualification, result, English result, destination, preferred intake and budget.
- It holds no family name, contact, passport or birth date.
- It also records the status, owner, last editor, current version, `expires_at` (last save plus `proposal_retention_months`, 12), `details_checked_at`, and `archived_at`, `archived_by` and `archived_reason`.
- `pipeline.portal_proposal_versions` is append only: a trigger refuses update and delete. Each version holds the whole content, `last_editor_id`, a note and `saved_after_other_edit`.

**Snapshots.** The server builds each course snapshot from live rows: title, provider, level, place, length, delivery, fee, next intake, entry (preferring the student's country of education), English, international scholarships and availability. An ordinary save keeps the snapshots already held, so nothing in the PDF changes until a refresh is accepted. A newly added course is snapshotted when it is added.

**Settings (portal toolset).** All appear on Settings › Toolsets & limits:
- `proposal_max_courses` 12, `proposal_message_max_chars` 3,000, `proposal_note_max_chars` 2,000, `proposal_why_max_chars` 300;
- `edit_lock_minutes` 15, `proposals_page_size` 20, `proposal_retention_months` 12, `resume_items_shown` 6;
- `themes`, `proposal_default_steps`, `proposal_default_documents`.

**Not in this change.**
- Removing expired or privacy-requested proposals: a Platform Admin paste file, because nothing is deleted by an applied migration.
- `portal_dashboard_v1`.

## Course details and Entry Requirements as built (Pilot s1215, S1-API-Frontend-Delivery, 26 Nov 2026)

Atlas brief 12:02 AEDT from the Platform Admin's live UAT. The screens (`portal/`) read S2-Build's s1214 functions; one small read is added. Nothing is written, calculated or dropped. Access is Viewer (rank 1) and above; execute is `authenticated` only.

**Reads used**
- `public.portal_course_detail_v1(p_course_id uuid)` (s1214): description, campuses, fee lines, upcoming intakes, academic entry and English requirements, the provider's QILT employment and salary figures for the course's cohort, official page, last checked. A course outside the portal's scope answers `P0002`, shown as "This course is no longer listed".
- `public.portal_aer_list_v1(p_args)` (s1214): `q`, `country` (taught in), `source_country` (student's country of education), `level` (a code or its family), `provider_id`, `has` (academic, english, both), `page`. Returns `items`, `total`, `page`, `page_size`, `facets`.
- `public.portal_study_levels_v1()` (s1215, migration `20261129090000`): `[{code, name}]`, the active top-level study levels that have courses; a top-level code also matches its children in the list. Keeps the Study level filter on the live table (s930).

**Rules in the screens**: a requirement that names no country applies to everyone, one that names a country applies to that country only (so the student's country adds to the shared lines). Fee lines are shown as recorded and never added together. Career outcomes are the provider's, labelled so. A value not held reads "Not recorded".

**Screens**: `components/CourseDetails.jsx` (panel, loaded when opened), `screens/EntryRequirements.jsx`, `components/ExtLink.jsx` (new tab, `noopener noreferrer`, web addresses only; a spec fails any other outside `href`). Menu: Dashboard, Courses, Entry Requirements, Universities & Providers, Scholarships, Saved courses, Proposals. Guards: Pilot specs `cf-247-s1215-portal-course-details-and-entry-requirements-contract` and `cf-247-s1215-portal-study-levels-migration-contract`.

**Lane note**: I first built a duplicate read layer under the same s1214 number; it was withdrawn before merge once S2-Build's PR was seen, and the screens were rebuilt on theirs.

## Course details and Entry Requirements fields added (Pilot s1216, S2-Build, 26 Nov 2026)

Additive keys on the s1214 reads (same names, arguments and privileges); null means the catalogue does not hold the value.

- `public.portal_course_detail_v1(p_course_id)`:
  - `provider_website`: the provider's website.
  - `entry_matrix`: an array of the provider's active country-by-country entry rows (`catalogue.provider_entry_matrix`, international or all applicants). Rows naming the course come first; then rows for the course's study level, or the level above or below it, that name no course; then provider-wide rows; by country within each. Each row holds `{country_code, country_name, qualification, min_grade, min_value, grade_scale, benchmark_band, level_label, course_label, for_this_course, audience, edition, intake_year, conditions, as_at, source_url}`. At most `portal.entry_matrix_max_rows` rows (300).
  - `entry_matrix_total`: the number of rows that matched before the cap.
- `public.portal_aer_list_v1(p_args)` items:
  - `city` and `state_code`: the course's primary campus, otherwise the provider.
  - `duration_value` and `duration_unit`: as in the detail read, for `durationText`.
  - `annual_tuition_fee`: `{amount, currency}`, the provider's annual tuition that the search shows.

## Course details and Entry Requirements screens show the s1216 fields (Pilot s1220, S2-Build, 26 Nov 2026)

- **Course details, Official source:** "Open the provider website" (new tab), or "Provider website: Not recorded".
- **Course details, "Entry requirements by country (provider)":** one item per matrix row.
  - Each item shows: the country (or "Every country"), "this course" when the row names it, the qualification, grade and band pills, the scale and the level or course, the conditions (best subjects, subject minimums, alternatives), the checked date, and a Source link.
  - When the student's country of education is chosen, the section shows that country's rows and the rows for every country, with "Show all N rows".
  - "Showing X of Y rows recorded for this provider" appears when `entry_matrix_total` is larger than the rows returned.
- **Entry Requirements cards:** Location, Length and Tuition per year (provider), each "Not recorded" when the read holds no value.

