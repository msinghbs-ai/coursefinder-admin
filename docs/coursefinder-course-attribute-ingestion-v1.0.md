# CourseFinder course and scholarship attributes: sources, deterministic ingestion and refresh (v1.0)

**Status:** Current — Decision 162 (28 September 2026) · **Change control:** CF-CHG-20260915-247 · **Scope:** Australia first; other countries follow the same model as country adapters.

This document redefines, from what is live on 28 September 2026, where each course and scholarship attribute comes from, how it is ingested without guesswork, how often it is refreshed, and how the admin screens show which layer supplied it. Where it conflicts with older runsheet wording, this document prevails.

---

## 1. Principles

1. **The regulator comes first.** Anything a national register publishes is taken from the register (Layer 1) and never re-collected from provider websites. For Australia this is CRICOS.
2. **International applicability is a Layer 1 fact.** A course is offered to international students when it has an active CRICOS course registration. No website reading is needed to decide this.
3. **One provider document before many course pages.** When a provider publishes a whole-of-provider list (an international fee schedule, an English-requirements table), it is read once and applied to all matching courses. Course pages are read only for what is not in such a document.
4. **Layer 2 is deterministic.** Values are taken by written, per-provider rules from stored evidence (the fetched page or file, with its hash), and bound to a course only by exact identity (CRICOS course code, or title plus code where the page shows both). No AI in Layer 2.
5. **Layer 3 is the exception path, not the default.** The AI only checks a value when a Layer 2 rule has found candidates but cannot pick one safely. It must be a pinned, qualified model (Decision 160); unsure answers go to Layer 4.
6. **Refresh follows how often the fact changes**, not a fixed weekly rhythm. Pages are re-read in full only when they have changed or their fact is due.
7. **Provenance is stored, not guessed.** Every admitted value records the layer, rule or model, and evidence that produced it. The screens show that stored record.

## 2. Attribute catalogue (courses)

Coverage is for the 25,978 active Australian courses on 28 September 2026.

| Attribute | Authority (layer) | How it is ingested | Changes | Refresh | Coverage today |
|---|---|---|---|---|---|
| Provider, CRICOS course code, title | CRICOS (L1) | Weekly register comparison; changes applied, departures retired (Decision 159) | Rarely | Weekly register check | 100% |
| International availability | CRICOS registration status (L1) | Active registration = offered to international students; expiry retires it | Rarely | Weekly register check | 100% |
| Study level, field of study | CRICOS (L1) | Register codes mapped to reference lists | Rarely | Weekly register check | 100% |
| Duration | CRICOS duration in weeks (L1) | Register value | Rarely | Weekly register check | 100% |
| Campuses / locations | CRICOS course locations (L1) | Register value | Occasionally | Weekly register check | 99.9% |
| Work component, language of instruction, dual qualification, foundation studies | CRICOS (L1) | Register value (regulatory facts) | Rarely | Weekly register check | 100% |
| **International tuition — registered total course** | CRICOS (L1) | Register value, audience international, basis "registered total course" | Once a year or less | Weekly register check | 99.3% (25,795) |
| Non-tuition fee, estimated total course cost | CRICOS (L1) | Register value | Once a year or less | Weekly register check | 99.3%–100% |
| **International tuition — provider current annual (fee year)** | Provider fee schedule or course page (L2); L3 only where a rule is ambiguous | Per-provider rule reads the provider's published international fee schedule for the fee year; else the course page. Bound by course code. One current value per course (Decision 132) | Once a year (new fee year, usually published July–October) | Once per fee year, plus the change check (§5) | ~408 courses (UQ, RMIT, Federation) |
| Official course URL | Provider site (L2) | Discovery from the provider's sitemap/course list, bound by course code or exact title plus code | Occasionally (site changes) | Link check each term; rediscovery when a link breaks | ~537 courses |
| Intakes / start dates | Provider page (L2) | Per-provider rule on the course or dates page | About twice a year | Each term, and before published application closing dates (important-dates rule) | 497 courses |
| English requirements | Provider English-requirements table (L2); course page overrides | Provider-wide table by study level, then course-specific exceptions | Once a year | Annual, plus the change check | 529 courses |
| Course description | Provider page (L2) | Per-provider rule, first-party text only | Rarely | Annual | 163 courses |
| Academic options (majors, streams) | Provider page (L2) | Per-provider rule | Once a year | Annual | small |
| Academic entry requirements | Provider page (L2) | **Not yet modelled** — gap | Once a year | Annual | 0 |
| Categories, collections | CourseFinder PIM (L4) | Set by people | As needed | — | as set |
| Outcomes and flows (QILT, PRISMS) | National statistics (L1) | Edition discovery and Apply (Decision 134) | Annual editions | Monthly edition discovery | provider/state level |

**Consequence for tuition.** Every Australian course already has an international tuition fee from CRICOS. Provider-page tuition is a refinement (annual, fee-year specific), not the only source. Screens and Search must show the CRICOS figure where no provider figure exists, and must not show "awaiting" for tuition on those courses.

## 3. Scholarships

| Attribute | Authority | How it is ingested | Changes | Refresh |
|---|---|---|---|---|
| Scholarship, provider, value, dates | Study Australia national scholarship catalogue (government); provider scholarship pages (L2) | Deterministic rules on the catalogue listing and detail pages; provider pages by per-provider rule | Several times a year (rounds open and close) | Change check weekly; accelerated to daily inside 45 days of an open or close date (existing domain policy) |
| International eligibility | Source statement | Study Australia lists scholarships for international students; provider pages must state international eligibility explicitly, otherwise the scholarship is not marked international | With the listing | With the listing |
| Course / provider scope | Source statement | Scope rows only where the page names the provider, level or course | With the listing | With the listing |

Today: 292 scholarships, all international, 200 from Study Australia and the rest from provider pages (Monash, UTS, Griffith, CSU, Melbourne and others). None are published yet (publication gate, Decision 138).

## 4. Deterministic Layer 2 ingestion method

For each provider source a profile holds the rules; each run stores evidence and records every value with the rule that produced it.

1. **Discover URLs** from the provider's sitemap or course list (never from search-engine results). Store the list as a dated snapshot. Discovered URLs carry forward to a new profile version when discovery settings are unchanged (fixed 28 September 2026).
2. **Fetch** each URL fresh (no cached copy), store the raw HTML and its hash as evidence.
3. **Bind identity** by exact CRICOS course code on the page, or exact title plus code; anything else is not bound.
4. **Extract** with the provider's written rule (selectors or table positions). Fee rules must capture amount, currency, fee year and basis (per year or total). PDF and spreadsheet schedules are parsed as tables.
5. **Admit** when the rule finds exactly one safe value; send to Layer 3 only when candidates exist but are ambiguous; send to Layer 4 when there is nothing safe.
6. **Record provenance** with the value (§6).

## 5. Refresh model

| Tier | What | When |
|---|---|---|
| Register | CRICOS and other national registers | Weekly comparison (existing, Decision 159) |
| Fee year | Provider international fee schedules and fee pages | Once per fee year, in the provider's publication window (default 1 August–31 October) |
| Change check | Every stored provider page | A cheap check each term (90 days); only pages that changed are re-extracted |
| Date-driven | Intakes, scholarship rounds | Accelerated inside published date windows (important-dates rule) |
| Link check | Official course URLs | Each term |

Interim until the change check is built: UQ and RMIT course-page refreshes run every 90 days (changed from weekly on 28 September 2026). The RMIT run started on 28 September goes ahead as the first run under Decision 161.

## 6. Layer badges on course attributes — current engine and redefinition

**Current engine.** The badges on the course page come from `security.admin_course_field_states(course_id)`. It does not read stored provenance; it infers a layer from whether a value exists:

- any provider tuition present → badge "L2", including the 242 courses whose tuition was admitted by the Layer 3 AI;
- CRICOS registered tuition is ignored, so courses with CRICOS tuition show tuition as "Awaiting L2";
- "Awaiting L3" is shown for URL, description, intakes and English whenever the last Layer 2 read contained a candidate, although Layer 3 only handles tuition;
- the last Layer 2 read is found by course code alone, not scoped to the provider or country (Decision 149).

**Redefinition.**

1. Each admitted value stores: layer (1–4), rule or model, evidence id, admitted at.
2. The badge shows that stored layer. For tuition, CRICOS registered tuition shows "L1 Regulatory"; provider annual tuition shows L2, or L3 with the model name when the AI admitted it; a Layer 4 decision shows L4.
3. "Awaiting L3" appears only for attributes that have a qualified Layer 3 task (today: provider tuition).
4. The Layer 2 record is looked up by provider and course identity, not course code alone.

## 7. Firecrawl — what we use and what we do not

Firecrawl stays a fetcher, not an extractor. Our own rules extract facts.

| Use | Firecrawl feature | Why |
|---|---|---|
| Discover course and scholarship URLs | `/map` with `sitemap`, or `/crawl` with `includePaths`/`excludePaths` and `sitemap: "only"` | Sitemap-based and repeatable |
| Fetch pages as evidence | `/scrape` or `/batch/scrape` with `rawHtml`, `links`, `maxAge: 0`, `location: AU` | Raw HTML kept with its hash; no stale cache |
| Change check | `changeTracking` in `git-diff` mode (no extra credit), optionally scheduled with `/monitor` without `goal` | Re-extract only pages whose status is `changed` |
| Fee schedules and scholarship rules in PDF | PDF parser, `mode: "fast"` | Deterministic text and tables |
| Pages that hide fees behind an "International" toggle | Scripted `actions` (click, wait) | Deterministic |

Not used for admission: `json` extraction, `/extract`, `/agent`, `summary`, `question`, `highlights`, `/monitor` `goal`, `/crawl` `prompt`. These use an AI model that cannot be pinned or qualified, so they conflict with Decision 160. At most they may suggest where to look, reviewed by a person. Sources: docs.firecrawl.dev (scrape, change-tracking, monitor, map, crawl, batch-scrape, llm-extract, agent) and firecrawl.dev/pricing, checked 28 September 2026.

## 8a. Progress

- **Step 1 done (28 Sep 2026, v2.15.102, Pilot PR #158).** `security.admin_course_field_states` reads stored provenance: Layer 3 from the admitted work item matching the fee's evidence (model shown), Layer 4 from applied resolutions, CRICOS sources as Layer 1; "Awaiting L2" only where the provider has a qualified Layer 2 source; "Awaiting L3/L4" only from open Layer 3 work items; new states "CRICOS tuition applies" and "Not collected"; lookups scoped to the course's provider. Consumer endpoints unchanged.
- **Step 2 research (28 Sep 2026)** — whole-of-university international fee schedules:

| University | Schedule | CRICOS code in it | Latest year seen |
|---|---|---|---|
| Western Sydney | PDF per level (UG, PG), archive 2020–2027 | Yes | 2027 |
| Federation | PDF (commencing; continuing separate) | Yes | 2026 |
| Charles Darwin | PDF | Yes | 2026 |
| Charles Sturt | HTML tables (per 8-point subject) | Yes | 2026 |
| RMIT | PDF (`2027-inton-fees.pdf`) | Unverified | 2027 |
| Swinburne | PDF UG and PG | Unverified | 2027 |
| Wollongong | PDF (URL id changes yearly) | Unverified | 2027 |
| UQ | PDF (per unit, UQ program code) | No — bind via program code | 2026 |
| UWA | HTML table by year parameter | No — bind via course code | 2026 |
| Melbourne | PDF fee tables (robots-restricted) | Unverified | 2026 |
| UNSW, ANU, UTS, Macquarie, Curtin, QUT, Monash, Deakin, Griffith | No single per-course schedule (fee bands, calculators or course pages only) | — | — |

  Order for adapters: Western Sydney and Federation first (CRICOS-keyed), then Charles Darwin and Charles Sturt, then RMIT and Swinburne once the CRICOS column is confirmed. Schedules for the next fee year appear around August–September.

## 8. Gaps and build order

| Step | Work | Outcome |
|---|---|---|
| 1 | Badge engine on stored provenance (§6); show CRICOS tuition as L1 | Correct badges; no false "awaiting" |
| 2 | Provider international fee-schedule adapters (one document per provider per fee year), starting with the universities that publish one | Tuition for whole providers in one read, annually |
| 3 | Change check with Firecrawl `changeTracking` git-diff; replace the interim 90-day full refresh | Only changed pages re-read |
| 4 | Provider English-requirements tables by study level | English for whole providers |
| 5 | Academic entry requirements attribute | Closes the modelling gap |
| 6 | Extend Layer 2 fee rules beyond UQ, RMIT and Federation using the provider sources already found by onboarding | Coverage beyond three providers |
