# StudySearch – Data pipeline operating model (Layers 1–4) and housekeeping standard

**Version:** 1.0 (15 Oct 2026) · **Change control:** CF-247 · **Decision:** 260
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

## 2. The four layers

| Layer | Job | Input | Output | Tools | Gate to the next layer |
|---|---|---|---|---|---|
| 1 Register | Who and what exists | Official provider and course registers | Providers, courses, campuses, codes, register facts | Register readers (one per source), Layer 1 operations | Source qualified (3.1); load reconciled |
| 2 Read | What the provider's own pages say | Provider websites | Course pages found and stored as evidence; values read by rules (adapters) | Site finder, course-page finder, reader (direct, then Firecrawl), adapters, central pages | Page proves identity (code or listed on own site); adapter qualified per field |
| 3 Interpret | What rules could not read | Stored pages | Values with a quote, from a pinned model | Enrich fields, central pages AI, scholarship AI | Quote on the page; daily guard; yield cap |
| 4 Admit and publish | What the website may show | Values from Layers 1–3 | Admitted catalogue values; website API | Admission rules, review only for conflicts, provider Published switch | Checks pass (3.4); country publish gate (3.5) |

## 3. Gates

Each gate is a set of settings (Pipeline settings) and a measurement. "Pass" moves on automatically; "Stop" records a flag (`pipeline.enrichment_flags`, reason code) and moves on. The Platform Admin can switch off any provider (Published) or any country gate at any time.

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

### 3.4 Admission gate (Layer 4, per value)

| Check | Rule |
|---|---|
| Fill | A value is written only where the course has none, unless the reader is cleared to replace (adapter) |
| Cross-checks | Fees against the registered total where one exists; English defaults against course pages (refused when most disagree) |
| Conflicts | A value that differs from the held one goes to review once; the same proposal is not raised again |
| Flip-flop | A value changed automatically more than the set number of times is frozen and flagged |

### 3.5 Country publish gate (automatic, Decision 260)

A country is returned by the website API when all of these hold (settings per country): providers loaded and published switch on; at least 60% of courses have a course page, study level and field of study; at least 40% have English (or the language of instruction) and an intake; no open source-gate stop. The gate is checked daily and recorded. The Platform Admin can close it at any time.

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
| 1.0 | 15 Oct 2026 | First issue: principles, layers, gates, country onboarding with the next seven countries' sources, assessment, housekeeping standard and starting point (Decision 260). |
