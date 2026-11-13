# StudySearch – Data pipeline operating model (Layers 1–4) and housekeeping standard

**Version:** 1.8 (13 Nov 2026) · **Change control:** CF-247 · **Decisions:** 260, 261, 277
**Owner:** Platform Admin. **Applies to:** every country, every change to the pipeline, every change to code, jobs, screens or database.
**Asked by:** Platform Admin, 15 Oct 2026: "There will be new countries onboarding ... We need to settle on approach between layer1-layer4 ... stop, move on gates and steps defined ... housekeeping is very important so we are not increasing code liabilities ... always keep the snapshot/documentation what corresponds to what and decommission as we create new approach. Outcome is code/platform and database are always streamlined and secure."
**Decisions (15 Oct 2026, multiple choice):** next countries United Kingdom, Ireland, Germany, France, Sweden, Finland, Netherlands; the old approach is retired in the same change, its data kept 14 days; gates pass automatically everywhere, including a country's first publish; the record of what corresponds to what is a live register with a generated document.

## 1. Principles

1. **Register first.** A course or provider exists because an official register says so (Layer 1). Websites fill in details; they do not create identities.
2. **Rules before AI, AI only with a quote.** A reader written as rules (an adapter) is used where it qualifies; AI fills what rules cannot, from a pinned model, and every value must be quoted on the page.
3. **Measure, then pass or stop.** Every step has a measured gate. A step that passes moves on by itself; a step that fails is flagged with its reason and the pipeline moves on. Nothing is retried unless retrying still pays (yield rule).
4. **Null means not held.** Nothing is filled by default, estimate or another record.
5. **Replace means retire.** A change that brings a new way of doing something switches the old way off in the same change and records it.
6. **Everything is registered.** Every job, function, edge function, table, screen and setting is in the component register with its layer, purpose and status.
7. **Secure by default.** Row-level security on every table, no public execute, pinned search paths, keys stored as hashes, no secrets in the repositories.
8. **Consumer API versions: the live one is frozen, the next one is open until it goes live (Decision 277).** The version the website reads today (Website API v2) is frozen (G3, Decision 266). New consumer work goes into the next version (Website API v3), a separate copy reading the same data. The next version takes additions freely until the website goes live on it; at go-live it joins the frozen surface and the version after it becomes the open one.

## 2. The four layers

| Layer | Job | Input | Output | Tools | Gate to the next layer |
|---|---|---|---|---|---|
| 1 Register | Who and what exists | Official provider and course registers | Providers, courses, campuses, codes, register facts | Register readers (one per source), Layer 1 operations | Source qualified (3.1); load reconciled |
| 2 Read | What the provider's own pages say | Provider websites | Course pages found and stored as evidence; values read by rules (adapters) | Site finder, course-page finder, reader (direct, then Firecrawl), adapters, central pages | Page proves identity (code or listed on own site); adapter qualified per field |
| 3 Interpret | What rules could not read | Stored pages | Values with a quote, from a pinned model | Enrich fields, central pages AI, scholarship AI | Quote on the page; daily guard; yield cap |
| 4 Admit and publish | What the website may show | Values from Layers 1–3 | Admitted catalogue values; website API | Admission rules, review only for conflicts, provider Published switch | Checks pass (3.4); country publish gate (3.5) |

## 3. Gates

Each gate is a set of settings (Pipeline settings) and a measurement. "Pass" moves on automatically; "Stop" records a flag (`pipeline.enrichment_flags`, reason code) and moves on. The Platform Admin can switch off any provider (Published) or any country gate at any time.

### 3.0 Flags: stop, record, move on, re-join (Decision 261, v2.15.282)

Platform Admin, 15 Oct 2026: "we don't keep burning the toolset on repetitive waste and produce nothing ... have flag unit that can be removed or raised manually and automatically by tried burn ... the said entry or provider get re-entered in queue."

| What is held | Hard reasons (held at once) | Soft reasons (held after 2 tries) | Released and re-queued when |
|---|---|---|---|
| Provider | Website does not answer; central pages not due; no credit today; held by a person | Logo not on the home page | A free check (direct read, no Firecrawl, no AI) finds the site answering: after 3, 7, 14, then every 30 days; or its due date comes; or a person releases it |
| Course field | Held by a person | The stored page gives no value (Enrich fields); a second try is made only on new input | The course page is read again with new content; or a value is found; or a person releases it |
| Job | Its last 30 runs found nothing to do; held by a person | — | A trial run after 1, 2, 4, then every 6 hours; or a person releases it |

Every flag keeps who or what raised and released it, why, and the evidence (Coverage & completeness › Flags; settings in Pipeline settings › Flags). A person's release is not undone by an automatic job.

### 3.1 Source gate (Layer 1, once per source)

| Check | Pass | Stop |
|---|---|---|
| Publisher | Government, regulator or statutory body | Commercial directory: not a Layer 1 source |
| Terms of reuse | Open licence (OGL, CC BY, Licence Ouverte) or written permission | Restricted or unknown: recorded; provider sites used instead until permission |
| Format | Download or API, stable identifiers | HTML only: a reader is built only if no other source covers it |
| Sample check | 50 records against provider sites: at least 95% same provider and course | Below: source used for providers only, or not at all |
| Reconcile | Each load compared with the last: removals over 5% held for review | Held load is not applied |

### 3.2 Provider gates (Layer 2, per provider)

| Step | Pass | Stop (flag and move on) |
|---|---|---|
| Website | Listed by the register, or the provider's code is on its home page | Not found by register and search: `no_website` |
| Focus | Provider is in the focus list (top N by gaps, per country) | Outside focus: register data only (`outside_focus`) |
| Course page | Found by its register code, or listed on the provider's own site | AI match attempts beyond the yield cap: `page_not_found` |
| Central pages | English policy, calendar, fee page found and read | None found after one map of the site |
| Adapter, per field | Sample of pages: at least 90% correct against a check (register value, quote, or cross-check) | Below: field not admitted from the adapter (`adapter_*_fails_check`) |
| Re-read | Only when due by cadence or the page changed | — |

### 3.3 AI gate (Layer 3, per task)

| Check | Rule |
|---|---|
| Model | One pinned, qualified model per task; no "auto" routing |
| Proof | Every value has a quote that is on the page; an unproven value is not stated |
| Cost | Daily guard per task; the credit floor stops all AI |
| Retry | A further attempt only while it still succeeds in at least the set share of cases |
| Activation | A passing qualification never switches a task on by itself in production; switching on is a separate, recorded step |

### 3.3.1 AI-written text: prompt-based, on demand and regular scan (Platform Admin 11 Nov 2026 14:51 and 14:57; first applied to provider descriptions)

Text that AI writes from an official page (first: a provider's description, `20261112010000`, worker `coverage-sweep` v0.69.0) follows these rules.

| Part | Rule |
|---|---|
| Wording | Set by a **prompt** kept in the database (provider descriptions: `pipeline.provider_description_prompts`), versioned, one active. The Platform Admin edits it on the screen (Models & services › AI & OpenRouter › Provider description prompt) with a reason; a save is a new version, never an edit in place. A switch (`pdesc.prompt_on`) returns to the built-in prompt. |
| Checks | Only checks a machine applies reliably stay as rules: the provider's own site and identity before any AI call; every supporting passage on the page; every number in its passage; complete sentences supported by their passages; a short list of words the text never carries (rankings, awards, outcomes, promotion, fees, visas); the first sentence names the provider; length; not a copy of another provider's text. Style is the prompt's job, not a rule's. |
| Automatic admission | With the prompt, admission without a person applies the same reliable checks again (lineage, identity, validation) and sends to a person only what the prompt must never carry (refused topics such as rankings, outcomes, fees and visas), marketing wording, and words kept for human eyes (provider descriptions: "accredited"). Figures pass when the validation has proved each one in its passage. Word lists used only by a built-in prompt do not decline prompt-written text (`20261112034500`). |
| A new prompt | Is new knowledge: each read records the prompt version, and answers that failed under an older version are read again once by the self-heal job. |
| On demand | An operator's one-click **Fill** (no reason to type) starts a read at once. It is not held by the task's own AI ceiling, daily guard, Firecrawl allowance or daily share, or by the "same page already failed" memory. It still stops for a manual lock, the identity proof, the platform-wide AI rule (credit floor, platform daily ceiling) and the account's own limits (Firecrawl monthly plan, credit reserve). Its priority lasts a set number of minutes, so the regular scan never waits behind it. |
| Regular scan | Runs by itself on its schedule and honours every limit of the task (AI ceiling and daily guard, Firecrawl allowance and daily share). |
| Written by hand | A value entered by hand sets a manual lock; neither Fill, the scan nor the record replaces it. |
| Visible | AI spend against the ceiling and daily guard, Firecrawl use against allowance and share, progress (admitted in 24 hours, described, waiting, held, written by hand) and the jobs' last runs are shown on the screen that holds the prompt and on the task's own card. |

**Scholarships (F-SCH production redesign, 12 Nov 2026; `docs/scholarships/SCHOLARSHIP-MECHANISM.md` v3.0 section 13).** The same pattern extracts structured facts, not only text: one versioned prompt (`pipeline.scholarship_ai_prompts` version 3, sch-extract-v3) reads one official evidence bundle; every field is kept only when its passage is on the evidence and carries the value; the summary is AI-written text under the rules above (no copied run, no number the evidence does not print); the fill writes only empty, unlocked canonical fields and never admits or publishes. Reconciling G2 with directive §11 ("internal queue sizes, leases, retries, model routing parameters, extraction heuristics and technical thresholds should be software-managed"): extraction heuristics and quality thresholds of the evidence checks stay in code with their reason, while every limit an operator steers (enable or pause, batch, spend, scope, refresh) stays a setting.

### 3.3.2 On demand and scheduled work: who obeys the toolset limits (Platform Admin 12 Nov 2026 21:07)

Platform Admin, 12 Nov 2026 21:07: "toolset limit should be waved when doing on demand, only scheduled tasks should obey toolset limits. especially when requested to execute from claude session it should display estimated toolset value adn then after finsih display actual used or credit left on toolset".

| Part | Rule |
|---|---|
| Scheduled work | Every job and task that runs on its own schedule obeys every toolset limit: the Firecrawl daily total, daily shares, per-university caps, refresh intervals, cost breakers and campaign ceilings, and the AI daily ceiling and lane guards. |
| On-demand work | Work a person starts (Run now, Fill, Read now) or a Claude session asks for is **not held by toolset limits**. It stops only at the account's own limits (Firecrawl monthly plan and credit reserve; OpenRouter credit floor), and at rules that are policies rather than limits (directory sites, robots.txt, manual locks, identity proof). Its use is counted as on demand and never takes room from the scheduled shares. |
| The request | An on-demand request names its providers and its reason and is recorded in `pipeline.on_demand_requests`, open for `ondemand.window_hours` (6) or until closed. A Claude session opens one with `security.on_demand_open_v1('claude_session', reason, providers, estimate)` before it starts the work. |
| Before | The estimate (Firecrawl units, AI US$) and the credit left on each toolset are shown: on the screen for Run now, and in the Claude session's reply. |
| After | `security.on_demand_close_v1(id)` records and shows the actual use (Firecrawl units by purpose; AI spend in the window) and the credit left on each toolset; the Claude session reports both. |
| Allowances | The earlier on-demand allowances (`firecrawl.ondemand_credits_per_day`, `openrouter.ondemand_usd_per_day`) stay on screen for reference and no longer hold a run. |
| Scope | A request names the Firecrawl purpose groups it covers (`security.on_demand_scope_v1`); scheduled work of the same providers keeps every limit (Pilot #1117). |
| Target list | `firecrawl.target_only` holds scheduled work only. A spend an open request covers is not refused for a provider off the target list; course page searches of covered providers are picked first and are not cut by the course-search share or the daily picked cap (Pilot #1125). |
| Built | Pilot #1083 (`20261113153100`): Firecrawl spends and Run now. Phase 2: the AI daily ceiling and lane guards for on-demand AI calls (they need the request passed with the call); until then on-demand AI still meets them. |

### 3.3.3 Evidence first (Platform Admin 13 Nov 2026 15:31)

Platform Admin, 13 Nov 2026 15:31: "We should use firecrawl for maximize crawling and storing the evidence for layer 3 data admission. the attaching to the course, nationality and other AI prompt based enrichment can take place".

| Step | Rule |
|---|---|
| 1. Crawl and store | Firecrawl is used to find and store official pages (course page searches, site maps, entry-requirement and scholarship sources) as Layer 3 evidence. Each page is fetched directly first; Firecrawl reads only what a direct read cannot (blocked, needs rendering, PDF). A stored official copy is never fetched again for the same purpose. |
| 2. Enrich from stored evidence | Course attachment (which page is the course's own), nationality (scholarship and entry-requirement country scope) and the other prompt-based readers run on the stored pages, with a pinned model and a quote for every value. |
| 3. Admit | Layer 4 gates are unchanged: identity, evidence quotes and study levels are proved, never assumed. |
| Run | On demand (3.3.2) with an estimate and credit left before and the actual use after; policies (robots.txt, directory sites, the search stop gate, identity) hold. |

### 3.4 Admission gate (Layer 4, per value)

| Check | Rule |
|---|---|
| Fill | A value is written only where the course has none, unless the reader is cleared to replace (adapter) |
| Cross-checks | Fees against the registered total where one exists; English defaults against course pages (refused when most disagree) |
| Conflicts | A value that differs from the held one goes to review once; the same proposal is not raised again |
| Flip-flop | A value changed automatically more than the set number of times is frozen and flagged |

### 3.5 Country publish gate (automatic, Decision 260)

A country is returned by the website API when all of these hold (settings per country): providers loaded and published switch on; at least 60% of courses have a course page, study level and field of study; at least 40% have English (or the language of instruction) and an intake; no open source-gate stop. The gate is checked daily and recorded. The Platform Admin can close it at any time.

### 3.6 Consumer API versions (Decision 277, Platform Admin 12 Nov 2026 21:00)

| Version | State | Changes allowed |
|---|---|---|
| Website API v2 (`website-search-v2`, `website_v2_*`, `api.*`, Zoho functions) | Live, frozen (G3) | None without the Platform Admin's recorded approval and a re-baseline |
| Website API v3 (`website-api-v3`, `public.website_v3_*`) | Open, not yet used by the website | Additions (fields, filters, actions, behaviour), recorded in the developer requirements register and the v3 guide; nothing in v2 touched |

- The Layer 4 admission gate and the country publish gate feed both versions equally; a version decides only what it returns, never what is admitted.
- **Go-live of v3:** the Platform Admin records the date the website switches. In the same change v3 is added to the frozen surface (CLAUDE.md G3, the consumer API baseline, the `s57` guard). From then v3 follows G3.
- v2 keeps running until the Platform Admin decides to retire it; a retirement is a paste file, never an applied migration.
- First v3 addition: R28, `intakes[].start_date_status` (why an intake has no exact start date).
- **A held v2 draft moves to v3, it is not merged into v2.** A consumer change drafted for v2 and still waiting for its approval or its developer notice is rebuilt as a `website_v3_*` change and the v2 draft is closed unmerged (done for R23/R24, Pilot #945 and #954, and the scholarship fields, Pilot #1077). The v3 change is md5-guarded, dry-run on live in a rolled-back transaction, and v2 keys always win over a v3 key of the same name.
- **One PR per v3 item.** Two sessions must not build the same item: the first PR to pass on its final head is merged, and the other is closed as a duplicate with what it had that the merged one lacks written on it (O22: Pilot #1097 merged, #1094 closed).
- **Reference data is not a version.** A new reference row (an English test) is data: it appears in v2 and v3 alike and needs no consumer approval, because no key, type or shape changes (OET and CELPIP, Pilot #1099).
- v3 additions live on 12 Nov 2026: R23, R24, R28, R29, R31, O20, O22, O26 and the scholarship detail fields. The list of record is `docs/integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md`.

## 4. Onboarding a new country

| Stage | What is done | Done when |
|---|---|---|
| C0 Profile | Currency; regulator and registers; study levels mapped to StudySearch levels (EQF/ISCED); regions; intake terms; language tests; fee audiences (for Europe: EU/EEA and non-EU) | Profile approved by the country gate settings |
| C1 Registers | Readers for the chosen sources (3.1); providers and courses loaded with their codes | Source gate passed; first load reconciled |
| C2 Websites | Provider websites found and verified | 90% of providers with courses have a website, others flagged |
| C3 Focus | Focus list set (top providers by courses and international intake) | List recorded |
| C4 Pages and adapters | Course pages found for focus providers; adapters built and qualified per field; central pages read | Per field: adapters admitted or flagged |
| C5 AI fill | Enrich fields and central pages AI for what is still missing | Yield falls below the retry rule, or the field is full |
| C6 Publish | Country publish gate (3.5) | Gate passes; website API returns the country |
| C7 Keep current | Register reload cadence; re-read cadence; scorecard (5) | Ongoing |

**Lessons carried over from Australia, New Zealand and Canada:** values such as English and intakes are usually on central university pages, not course pages; a page found by title search is often the wrong page (read only pages found by code or listed by the provider); one adapter per university, qualified per field; universities' calendars are not every course's intakes; small providers rarely repay page hunting.

### 4.0 How the provider list is built (Decision 261, 15 Oct 2026: "Registers first, search fills gaps")

The official register is the master list: downloaded where it is published as data, otherwise its institution pages are read (Firecrawl map, then crawl of the detail pages with a fixed schema: about 2,000–5,000 credits for 400–1,000 institutions). Firecrawl search limited to the country (`country`, `location`; up to 100 results per query, 2 credits per 10 results) is used only to find providers the register misses, and each one found passes the source gate (3.1) before entry. The Firecrawl agent (`/agent`, which replaces `/extract`; about 150–200 rows a run) is not used for the master list, because its documentation describes results as best-effort and they may be missing rows. Its rows may enrich a record but never create one. Firecrawl's crawl follows robots.txt; reuse of a register's data still needs its licence or permission (3.1).

### 4.1 The next countries: Layer 1 sources (research 15 Oct 2026; licences to confirm before use)

| Country | Provider register | Course register | Gaps |
|---|---|---|---|
| United Kingdom | UKVI register of licensed student sponsors (daily CSV); OfS Register (England); UKPRN as the key | Discover Uni (HESA, CC BY 4.0, weekly): undergraduate only | Postgraduate has no open register; fees on provider sites |
| Ireland | TrustEd Ireland providers (QQI); HEA list | ILEP and the TrustEd eligible-programmes lists (Excel): programmes open to non-EU students | Terms not stated |
| Germany | Hochschulkompass (HRK): 427 institutions | Hochschulkompass: 22,143 programmes, 2,212 English-taught; DAAD international programmes | Reuse only under an HRK partnership: ask HRK before building |
| France | Higher-education ministry institutions list (Licence Ouverte) | Parcoursup map (undergraduate) and Mon Master (8,167 master's), Licence Ouverte, API | Language of instruction only from Campus France (no feed) |
| Netherlands | DUO "Overzicht erkenningen HO" (daily CSV; institution, campus and programme codes) | DUO plus the Studiekeuzedatabase API (language, fees, start dates) | Licences to confirm |
| Sweden | UHR list of institutions (2023 page) | Susa-navet API (Skolverket) to verify; universityadmissions.se has the catalogue with fees but no feed | Course feed for higher education unverified |
| Finland | Ministry lists of universities and universities of applied sciences | Studyinfo (Opintopolku) APIs: teaching language, intakes | Terms to confirm |

**New for Europe:** pages in German, French, Dutch, Swedish and Finnish (read the English version where the provider has one; quotes in the page's language); EU/EEA and non-EU fees (the website API needs an additive fee audience before these countries publish); state or nation-level regulators (Germany, UK).

## 5. Continuous assessment

A weekly scorecard per country and layer (generated, admin repo `docs/platform/scorecards/`):

- Coverage per field (course page, level, field, English, intakes, fee, campus) and the change in the week.
- Each method's yield and cost: values filled, credits and AI spend per filled value, retries, stops by reason.
- Waste signals: paused jobs, frozen values, repeated review items, deadlocks, jobs that ran without output.
- Methods below their yield floor for 14 days are paused and listed for decision (keep, change, retire).

## 6. Housekeeping standard

### 6.1 Component register (live table, generated document)
`pipeline.component_register` holds one row per component: kind (job, database function, edge function, table, view, screen, setting, document), name, layer, countries, purpose, status (active, retiring, retired), replaces, replaced by, introduced in (migration or release), retire after (date), last used (measured), and the evidence. `docs/platform/COMPONENT-REGISTER.md` is generated from it (daily workflow, branch `component-register-snapshot`) and copied here with each change-control entry. Built in v2.15.280 (System reference §4e).

### 6.2 Rules for every change
1. A migration names what it **replaces** and what it **retires** in its header (or "nothing"); a test fails the build without it.
2. A new job, function, edge function, table or screen is added to the register in the same change; the weekly check lists anything live that is not registered.
3. The old way is switched off in the same change: jobs paused, functions no longer called, screens removed. Its status becomes retiring with a date 14 days ahead.
4. After 14 days, if nothing has read it, its tables, functions and edge functions are dropped by a paste file the Platform Admin runs; evidence data is exported to Storage first when it holds evidence.
5. One-off investigation scripts (probes, audits) are not left deployed; if one must run as an edge function, it is retired within 7 days.
6. Documents: one current file per topic. A superseded version moves to `docs/archive/` in the same change; the router lists current documents only.

### 6.3 Weekly hygiene check (job, notices)
- Register against live: unregistered or missing components.
- Unused: jobs with no output, edge functions with no calls, tables with no reads or writes, indexes never scanned, for 14 days.
- Security: tables without row-level security, functions without a pinned search path or with public execute, Supabase security advisors.
- Size: largest tables and their growth; retired data still held.

### 6.4 Where we start (15 Oct 2026)

| Area | Today | First clean-up |
|---|---|---|
| Edge functions | 81 in the repository, about 10 called a day | Canadian probes and audits, retired Layer 3 functions, unused contact and ranking scripts |
| Scheduled jobs | 101 | Jobs with no output (watched by the waste guard) |
| Tables | 491, 94 empty; about 132 untouched in a day | Retired features and trials (usage audit day 2 list) |
| Retired Layer 3 data | 306 MB, still read by 8 jobs | Rewire those reads, then retire |
| Indexes never scanned | 180 (13 MB) | Drop those on retired tables first |
| Tables without row-level security | 37 | Enable, with service-only access |
| Database functions | 1,397 | Retire with their features; versioned families (8) to one version |
| Admin documents | 875 files; 81 versions of the master project plan, 37 of the design decisions | Move superseded versions to `docs/archive/` |

The usage audit's final report (15 Oct, evening) gives the first retire list. Retirement then follows 6.2.

## History
| Version | Date | Change |
|---|---|---|
| 1.8 | 13 Nov 2026 | 3.3.2 adds Scope (purpose groups, Pilot #1117) and Target list (scheduled only, Pilot #1125); 3.3.3 Evidence first: Firecrawl crawls and stores official pages, AI enrichment runs on the stored evidence, Layer 4 gates unchanged (Platform Admin 13 Nov 2026 15:31). |
| 1.7 | 12 Nov 2026 | 3.6 Consumer API versions: a held v2 draft moves to v3 and is closed unmerged; one PR per v3 item; reference rows are data in both versions; v3 additions live on 12 Nov listed (Platform Admin 12 Nov 2026 22:03 and 22:37). |
| 1.6 | 12 Nov 2026 | 3.3.2 On demand and scheduled work: on-demand work (a person or a Claude session) is not held by toolset limits, only by the account; scheduled work obeys every limit; a request shows its estimate and credit left before, and its actual use and credit left after (Platform Admin 12 Nov 2026 21:07; Pilot #1083). |
| 1.5 | 12 Nov 2026 | Principle 8 and 3.6 Consumer API versions: v2 frozen, v3 open to additions until the website goes live on it, then frozen (Decision 277, Platform Admin 12 Nov 2026 21:00). |
| 1.4 | 12 Nov 2026 | 3.3.1 adds scholarships (F-SCH production redesign: sch-extract-v3 structured extraction, evidence checks, fill of empty unlocked fields) and how G2 and directive §11 divide settings from software-managed extraction heuristics. |
| 1.3 | 11 Nov 2026 | 3.3.1 adds Automatic admission: the prompt profile's checks again, refused topics, marketing words and words kept for human eyes to a person; figures proved in their passages pass (Pilot #1031). |
| 1.2 | 11 Nov 2026 | 3.3.1 AI-written text: prompt-based wording maintained on screen, one-click on demand outside the task's own limits, regular scan within them, hand-entered values never replaced (Platform Admin 11 Nov 2026 14:51, 14:57; provider descriptions first). |
| 1.1 | 15 Oct 2026 | 3.0 Flags (Decision 261, v2.15.282); 4.0 how the provider list is built for new countries (registers first, search fills gaps). |
| 1.0 | 15 Oct 2026 | First issue: principles, layers, gates, country onboarding with the next seven countries' sources, assessment, housekeeping standard and starting point (Decision 260). |
