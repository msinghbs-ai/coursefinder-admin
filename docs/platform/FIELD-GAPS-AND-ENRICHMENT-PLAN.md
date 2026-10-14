# StudySearch – Field gaps by country and the field enrichment job (plan)

**Version:** 1.1 (14 Oct 2026, platform release v2.15.273) · **Status:** job built (section 8) · **Change control:** CF-CHG-20260915-247

Raised by the Platform Admin (14 Oct 2026, 10:41): "We need to cover the address and also include the campuses with address to be read if not available. Assign them to courses in specific countries/unis. Use already scraped pages. Find out how many can be filled. Eventually to be controlled and defined by UI. Same things goes for rest of fields which is not getting captured by layer 1. Find the gaps. Additionally plan the feature to create a job to enrich data for specific or multiple fields across uni or countries using scraper and ai in layer 2 and layer 3. Keep it simple."

All figures were read live on 14 Oct 2026 and cover active courses only.

## 1. What Layer 1 gives each country

| Country | Register | Provider address | Campuses | Course facts from the register |
|---|---|---|---|---|
| Australia | CRICOS (providers, locations, courses) | Street, postcode, city, state | Yes (3,984), linked to courses | Level, field, duration, registered fee, campus |
| New Zealand | NZQA | City; region for 402 of 415 | None | Title, level, NZQA number |
| Canada | IRCC list of approved institutions, provincial portals | City and province; no street | None | Title, program or portal code; level for half |

## 2. Field coverage today (share of active courses)

| Field | Australia (26,103) | New Zealand (6,474) | Canada (4,723) | How it is filled today |
|---|---|---|---|---|
| Own course page stored | 88% | 86% | 95% | Coverage sweep and adapters |
| Official course link | 70% | 46% | 57% | Coverage sweep |
| Study level | 100% | 95% | **50%** | Register; adapters (not admitted) |
| Field of study | 100% | **0%** | **0%** | Register (Australia only) |
| Duration | 100% | **0%** | **0%** | Register (Australia only) |
| Delivery mode | 37% | 17% | 15% | Register and course page |
| Open to international students | 100% | **0%** | **0%** | Register (Australia only) |
| Campus linked to the course | 100% | **0%** | **0%** | Register (Australia only) |
| Tuition fee | 100% | 15% | 7% | Register (Australia); adapters |
| Intakes | 36% | 30% | 18% | Adapters, central calendars |
| English requirement | 53% | 28% | 34% | Adapters, central policies |
| Description | 1% | 0% | 0% | Not collected |

Provider street address: Australia 100%, New Zealand 0%, Canada 0%.

The gaps are the fields only a register gives (campus, address, duration, field, international) in the countries whose register does not give them.

## 3. What the pages already stored can fill (no new credits)

University adapters read more from each course page than is admitted. Values they read but never write are kept as "extra" on each read (`pipeline.uni_adapter_results`). The latest read per course gives:

| Field | New Zealand | Canada | Notes |
|---|---|---|---|
| Campus or location named on the page | 1,286 courses, 50 universities, 183 raw names | 522 courses, 13 universities, 28 raw names | Names need tidying into one campus list per university (e.g. AUT "City Campus North", "North Campus") |
| Duration | 1,174 courses | 402 courses | Short values such as "3 years" |
| Study level (where missing) | 38 courses | 192 courses | |
| Delivery mode | 1,061 courses | 906 courses | Text such as "Online", "100% online"; mapped to the four modes |
| Field of study code | – | 204 reads hold a Canadian CIP code | CIP maps to a field of study |

Pages stored but never read by an adapter: **3,003 courses in New Zealand** and **2,790 in Canada**. These can be read again for any field, from the stored copy, by the rule reader or the AI reader, at no Firecrawl cost.

**Campus addresses.** The stored pages are course pages. They name the campus but rarely give its street address. Contact pages are stored for 7 New Zealand universities and no Canadian ones. Addresses therefore need one new read per university: its contact or campuses page, found the same way central fee and English pages are found today. That is about 290 universities in New Zealand and Canada (242 + 52 with stored course pages), roughly 2 Firecrawl credits each, so **about 600 credits**, from the central pages share.

**Field of study.** Nothing stored states it for New Zealand. Canada has CIP codes for some courses. For the rest it is a classification from the title and level. The AI reader can do it in batches from the database alone, with no page read.

## 4. How many can be filled, in order

| Step | Source | NZ courses | CA courses | Credits |
|---|---|---|---|---|
| 1 Campus list per university, then course links | Adapter campus text (stored) | ~1,290 | ~520 | 0 |
| 2 Duration, missing level, delivery | Adapter text (stored) | ~1,170 / 40 / 1,060 | ~400 / 190 / 900 | 0 |
| 3 Same fields from pages never read by an adapter | Stored copy, rule or AI reader | up to 3,000 | up to 2,790 | 0 (AI cost only) |
| 4 Campus and provider street addresses | Contact or campus page, one per university | ~240 universities | ~50 universities | ~600 |
| 5 Field of study | CIP code, else AI from title and level | ~6,470 | ~4,720 | 0 (AI cost only) |
| 6 Open to international | Rule: an IRCC-listed institution (Canada) or NZQA code-of-practice signatory (New Zealand) teaches international students; course pages that say "domestic only" stay a person's call | ~6,470 | ~4,720 | 0 |

Steps 1–3 are upper bounds until a sample is checked. Each value is admitted only with its quote from the stored page (the rule already used for intakes and English). Anything unclear goes to Layer 4.

## 5. The field enrichment job (plan, kept simple)

One job kind, `enrich_fields`, started from the screen and listed in Task manager like any other task.

**What a person chooses**

| Choice | Options |
|---|---|
| Scope | One or more countries, or one or more universities |
| Fields | Any of: campus, provider address, duration, level, delivery, field of study, international, fee, intakes, English |
| Sources allowed | Stored pages only (default) · plus the AI reader (Layer 3) · plus new reads through the scraper (Layer 2), with a credit limit |
| Size | Courses or universities a run (a setting, as in G2) |

Before it starts, the screen shows a preview: how many courses are missing each field in the scope, how many can be filled from stored pages, and the credit estimate if new reads are allowed.

**What the job does, for each course and field, in this order**
1. **Stored adapter value.** Use what the university adapter already read, if the field is missing.
2. **Stored page.** Read the stored copy with the rule reader; if the rule reader finds nothing and AI is allowed, the pinned Layer 3 model reads it and must quote the page.
3. **New read.** Only when allowed and the course or university has no usable stored page: one Firecrawl read within the chosen credit limit and the existing caps.
4. **Admit or review.** A value with its quote is admitted under the existing admission rules; anything else becomes a Layer 4 item. Values entered by hand are never changed.

Campuses work per university, not per course. The AI reader turns the university's campus names (from course pages, plus its contact page) into one campus list with addresses. A person approves that list once. The course links are then made from each course's own page.

**Where it lives on screen**
- **Start.** Layer 2 › Jobs gets "Enrich fields", with the choices above and the preview.
- **Rules.** Settings gets a "Field sources" card: for each country, which sources may fill each field and in what order. This is how it is "controlled and defined by UI". It starts with today's order.
- **Results.** Progress and results go to Task manager, with filled, sent to review and skipped (with the reason) per field.

**Reused, not new:** the job and task system, the stored evidence copies, adapters and their extra values, central page finding, the pinned Layer 3 model and its quote check, the Firecrawl budget and shares, and Layer 4 review.

**New:** the job kind and its worker step, the field-source rules table and card, the campus list proposal and approval, and the preview read.

## 6. Suggested order of work

| Release | What | Credits |
|---|---|---|
| 1 | Campus lists from stored campus text (NZ and Canada), person approves per university, course links made; duration, level and delivery admitted from adapter values with their quotes | 0 |
| 2 | `enrich_fields` job with stored pages and AI only; Field sources card; field of study and international rule | AI only |
| 3 | Contact and campus page reads for addresses; the scraper option in the job | ~600 for addresses |

## 7. Decisions needed

1. Start with release 1 (stored data only, no credits)?
2. Campus lists: approved by a person per university (recommended), or admitted when the AI and the course pages agree?
3. Open to international students: use the institution rule (IRCC list, NZQA code of practice), or only what each course page states?

## 8. Built in v2.15.273 (14 Oct 2026)

Decisions (Platform Admin, 14 Oct 2026): build the full job first; campus lists admitted when the AI list and the course pages agree; open to international by the institution rule.

| Part | As built |
|---|---|
| Screen | Layer 2 › Enrich fields: scope (countries or universities), fields, AI on or off, scraper on or off, preview, start with a reason (Pipeline Operator and above); tasks with results by field and each value with its source and quote. Field sources is a card on the same tab (Platform Admin), not on Settings. |
| Rules | `pipeline.field_source_rules`, one row per field for All countries, a country row replaces it. Changes are logged. |
| Task | Job kind `enrich_fields`, one item per course and missing field (`pipeline.field_enrich_items`), settled each minute through the job system. Only missing values are written; hand locks are respected. |
| AI | Worker v0.22.0 mode `enrich_ai`, the pinned central-pages model (gpt-4.1-mini). Each value read from a page must quote it. Titles are classified to the ASCED narrow fields. Spend shows as "Enrich fields with AI" with its own daily guard (US$2 to start). |
| Scraper | Course pages without a stored copy are asked to be read again; a provider's address may use one read of its home page (purpose `enrich_address`, the "other" Firecrawl share). |
| Campuses | One AI list per university from its campus names; a campus is admitted when at least `enrich.campus_min_pages` (2) course pages name it; course links follow. |
| International | Canada: IRCC-listed institution. New Zealand: no code-of-practice record is held yet, so the course page decides (adapter or AI). |
| Settings | `batch.enrich_fields`, `enrich.ai_calls_at_once`, `enrich.ai_items_per_call`, `enrich.campus_min_pages`, `enrich.wait_page_hours`. |

Not in this release: fee, intakes and English (the adapters and central pages already fill them); campus and address review screens (items marked "For review" are listed in the task results).

**Live trial (University of Waikato, 278 courses, AI US$0.44):** campus 162 courses linked to Hamilton and Tauranga; duration 153; field of study 264; international 144 (39 footer-based values undone, rule tightened in worker v0.22.2); delivery 48; address 0 (no street on the stored contact page; scraper off). About US$0.0016 a course for six fields.
