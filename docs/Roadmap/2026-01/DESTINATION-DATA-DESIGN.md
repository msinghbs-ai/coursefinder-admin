# StudySearch destination data design

**Version 1.8 · 17 November 2026 AEDT · Proposed production design · RM0–RM6** (v1.8 records [decisions G-1 to G-5 as approved](#decisions-g-1-to-g-5-approved-17-november-2026); v1.7 added the companion [Admin UI fitout, API v3 blueprint and bulk ingestion plan](DESTINATION-DATA-UI-AND-INGESTION-SPEC.md) with its [wireframe](mockups/destination-data-admin-fitout-mockup.html), and proposes the career outcomes grain, decision G-1; v1.6 recorded the [roadmap schema pack shipped before the squash](#roadmap-schema-pack-before-the-squash-17-november-2026), which supersedes the Wave 2 schema hold and the M3 and M4 table names; v1.5 recorded the [ABS source approvals for RM1B and the Wave 2 schema hold](#abs-source-approvals-and-wave-2-schema-hold-17-november-2026); v1.4 added [Platform state, Wave 1B delivery and Wave 2 readiness](#platform-state-wave-1b-delivery-and-wave-2-readiness-17-november-2026); v1.3 added [Roadmap alignment and Wave 1 delivery](#roadmap-alignment-and-wave-1-delivery-16-november-2026); v1.2 the [RM delivery plan](#rm-delivery-plan--database-design-source-data-and-admin-module-by-roadmap-item-13-november-2026); v1.1 the [S1-RM-Design database design and v3 handoffs](#s1-rm-design--database-design-and-v3-delivery-handoffs-13-november-2026); v1.0, 11 November 2026)

## Scope and release order

Build **Study rules**, **Cities and costs**, and **Careers and labour market** once and configure them for all six destinations. Add official-source provider, campus and course integrations for the **UK, Ireland and USA**. Australia, Canada and New Zealand reuse their existing catalogue and publication paths. The scope includes data ingestion, verification, Admin operations and a versioned data handoff for Study Square.

| RM | Destination | Catalogue action | Production scope |
|---|---|---|---|
| RM0 | Shared foundation | Reuse L1–L4, identifiers, source/evidence, jobs and Data Delivery | Shared canonical tables, validators, refresh jobs and approved read model |
| RM1 | Australia · AU | Reuse CRICOS and provider facts | All three modules. Australia is the first production release and sets the acceptance fixtures. |
| RM2 | Canada · CA | Reuse Canadian catalogue and reconcile DLI/campus identities | All three modules. Preserve provincial coverage and programme-specific policy conditions. |
| RM3 | UK · GB | New catalogue adapter and first-party enrichment | Catalogue plus all three modules, covering all four nations under their applicable authorities |
| RM4 | New Zealand · NZ | Reuse NZQA and existing lifecycle paths | All three modules. Preserve dated qualification and provider transitions. |
| RM5 | Ireland · IE | New provider and programme adapters | Catalogue plus all three modules. Track Irish recognition and recruitment permissions independently. |
| RM6 | USA · US | New campus, institution and programme adapters | Catalogue plus all three modules. Use an approved set of institutions and campuses, with state/local coverage shown explicitly. |

Read-only production check on 11 November 2026 confirmed lifecycle-active provider/course counts of AU **1,540 / 25,380**, CA **1,130 / 3,814** and NZ **417 / 6,495**. GB, IE and US each returned **0 / 0**, and all six already had country references. These are active catalogue counts before eligibility, publication and country-release filtering. Confirm source-native counts independently for each release.

Study Square receives structured facts and official source links. The website team owns page design and editorial copy. Initial new-catalogue scope is internationally recruitable, full-time, physically attended degree programmes at bachelor level and above. Record explicit local exceptions in the country scope. Preserve catalogue coverage for pre-existing programmes. Full country-wide long-tail acquisition, rankings, outcomes and scholarships are outside this work package. The December handoff for fields already available via Website v2 remains a separate delivery slice of RM1.

## Existing foundations and proposed Supabase model

Reuse `ref.countries`, `ref.subdivisions`, `ref.currencies`, existing study-level references, `catalogue.providers`, `catalogue.provider_identifiers`, `catalogue.provider_registrations`, `catalogue.campuses`, `catalogue.courses`, `catalogue.course_registrations`, `catalogue.course_campuses`, `pipeline.city_regions`, `pipeline.sources`, `pipeline.evidence_artifacts`, `pipeline.evidence_entity_links`, `pipeline.important_dates`, `pipeline.statistics_dataset_registry` and `pipeline.statistics_edition_candidates`. Store only stable source and evidence references in the new fact rows. Leave shared identifiers and regulatory facts at their original canonical grain.

The following are proposed table names and logical keys. Migration work must match existing PK types, schema grants, lifecycle conventions and foreign-key naming in Pilot. Use an internal `destination` schema for cross-destination facts and the approved consumer projection. Keep import staging and operational records in the existing pipeline architecture.

| Proposed table | Grain and key | Essential fields and integrity |
|---|---|---|
| `destination.policy_rule` | One stable rule identity, unique on authority, jurisdiction, route and source-native rule key | Country, optional subdivision/locality, topic, route/scheme and legal authority. One route can have multiple authorities at different scopes. |
| `destination.policy_version` | One immutable rule version and applicability variant | Rule ID, canonical variant hash, typed value, effective date range, lifecycle and review status, legal instrument/locator, source/evidence, observed/reviewed/review-due dates, supersedes link. Preserve source text only where permitted. |
| `destination.locality` | One recognised locality; unique source-native gazetteer scheme + code | Country, subdivision, canonical name, locality type, optional centroid and parent geography, source and status. Use scoped aliases and reject ambiguous name-only joins. |
| `destination.campus_locality` | One dated locality association for an existing campus and mapping type | Campus, locality, mapping basis, validity and evidence. Populate through validated `pipeline.city_regions` and official geography mappings. |
| `destination.city_observation` | One measure per locality, dataset edition, observation grain and applicability scope | Discriminated climate/cost type. Climate carries station ID, measurement period or normal baseline and month/annual indicator. Costs carry basket/category, low/high, currency, billing interval, population and method. Keep provider/campus-specific estimates scoped to their source. |
| `destination.dataset_edition` | One admitted edition/revision of a registered statistical or climate/cost dataset | Registry key, publisher release ID, content hash, release/revision dates, coverage, classification versions, source, evidence and rights. Reuse the existing candidate workflow before admission. Revisions preserve history. |
| `destination.stat_dimension_member` | One native occupation, industry or statistical geography member per publisher classification and edition | Scheme, edition, native code, label, hierarchy, geography scope and source. Add evidence-backed links to country/subdivision/locality where an exact correspondence exists. |
| `destination.stat_crosswalk` | One versioned mapping from a native member to a comparable member | Source and target members, relationship type, optional published weight, applicability, confidence and evidence. Retain one-to-many mappings. |
| `destination.labour_observation` | One dataset edition, metric, statistical geography, occupation/industry, period, population and statistic | Numeric or categorical value, native unit/currency, pay period, base year and price basis where relevant, actual/estimate/forecast classification, forecast origin and horizon, suppression status and evidence. Use edition-scoped natural keys with explicit absent dimensions. |

If existing controlled source-native identifiers already meet a proposed dimension's key and lineage requirements, use that existing representation during migration design. New official register IDs, accreditation references and programme keys for GB/IE/US go into the existing catalogue structures or mappings. Store course study load and attendance mode independently where applicable. If the existing course/campus model lacks one of those semantics, propose the smallest additive canonical extension and verify whether its exposure needs G3 approval.

```mermaid
flowchart TD
    A["Official feeds and pages"] --> B["Existing source and evidence"]
    B --> C["Validate and review"]
    C --> D["Catalogue and campus identities"]
    C --> E["Policy versions and observations"]
    D --> F["Approved destination projection"]
    E --> F
    F --> G["Study Square data feed"]
    E --> H["Existing Admin Data Delivery"]
```

### Study rules

| Policy type | Required structure |
|---|---|
| Application and offer documents | Route, applicant class, application channel, conditional document requirement, issuer, procedural deadline and applicable date basis. Link procedural reminders to existing important dates. Distinguish programme offer, sponsorship/immigration document and proof of funds. |
| Fees and funds | Charge or requirement type, amount/range, currency, period or once-off basis, unit per person or household, family size, region and application route. Keep visa charges, other fees and minimum funds as separate metrics. |
| Processing | Route, jurisdiction/application location, snapshot date, statistic type, percentile or service standard where declared, window, units, source and expiry. A time estimate expires on its own freshness schedule. |
| Dependants and work | Separate principal/dependant scope, relationship, enrolment, course level, duration, attendance, work type, hours and period, term/break, authorisation requirements and exceptions. Use neutral route labels with evidence. |
| Minimum wage | Authority, geographic coverage, sector/age/worker category where relevant, effective date, currency and pay unit. Scope federal, provincial, state, territorial or municipal rules independently where source coverage supports them. |
| Post-study and residence | Route, transitional cutovers, relevant application/decision/commencement date, qualification, field or local programme code, institution/campus, nationality/residency and other source conditions. Model employer, authorisation and application requirements as conditional attributes. |

Store the condition expression as versioned, schema-validated JSON on the rule version, with typed operators and allowlisted keys. Support AND/OR groupings with bounded nesting, explicit inclusive/exclusive comparisons, ordered threshold cases and typed references to catalogue, geography and classification identities. Include the applicable date field explicitly. Use decimal amounts and interval units rather than parsing display text. Common search keys stay relational. A missing condition input produces `unknown` for that variant. The consumer feed returns sourced conditions and availability, without collecting applicant details or offering personalised eligibility decisions.

Use half-open effective ranges `[start, end)` for date-based rules. Store publication, observed, verification, review due and legal-effective dates separately. Treat a proposal as evidence-only and preserve future confirmed rules with a scheduled activation date. Define `expired`, `superseded` and `withdrawn` independently from an elapsed review date. Serialize activation by rule key and variant. Enforce non-overlap for concurrently publishable versions of the **same exact** authority/jurisdiction/route/variant. Compare cross-variant intersections and jurisdiction-specific precedence against golden scenarios. Where authority or exceptions are ambiguous, hold the conflicting scope and preserve unrelated valid facts. A late correction creates a superseding version plus audit history. Test both sides of each transition using local statutory date semantics. [PostgreSQL range types](https://www.postgresql.org/docs/current/rangetypes.html)

### Cities and costs

Start with the campus localities named in the approved source cohort and work outwards. Match each campus to an official locality or published statistical geography. Review ambiguous city names, campuses spanning regions and station proxies. Carry station ID, period and basis with any climate normal. Pin the station-selection methodology to the dataset edition, and make the station-to-city proxy explicit.

Publish recurring local cost ranges in their original currency and interval with basket categories and source period. Separate student budgets from price indices and an institution's cost-of-attendance estimate. Sum components only when geographic coverage, period, units, basket and population align. UK, NZ and Ireland workbook rows cite visa maintenance/funds pages for living costs. Admit those figures only as Study rules. Acquire distinct first-party student budget or official cost observations for Cities and costs. In the USA split IPEDS cost-of-attendance components before using any permitted student living-cost estimate. A missing Canadian city budget becomes an explicit source gap. Exclude tuition, visa fees and one-off relocation expenses from the recurring city basket.

### Careers and labour market

Load each official dataset at its published occupation/industry/geography grain. Metric vocabulary includes shortage classification, outlook, employment, earnings, vacancies and projections. Store base year, period, projection horizon, units and population exactly as applicable. Preserve source suppression, survey exclusions and published confidence/sampling measures where available. Use source-native codes in imports and output. Cross-destination comparisons require compatible statistical populations, time basis and documented crosswalks. Do not imply individual job prospects or visa eligibility from a series.

Route UK Temporary Shortage List, NZ Green List, Irish employment permit occupation lists and Canadian immigration category lists to Study rules, with native classification links where applicable. Admit JSA occupation shortages and equivalent evidenced statistical assessments to Careers. US O*NET Bright Outlook is an outlook indicator. Missing shortage data remains a coverage gap. Occupation pay observations remain distinct from legal wage floors.

## New catalogue adapters and country sources

| Adapter | Identity and source precedence | Admission proof |
|---|---|---|
| **GB** | Stage Home Office sponsor register independently from the provider identity. Map provider IDs such as UKPRN where the source attests the match. Confirm degree authority under the applicable UK nation. Source UG listings from Discover Uni where usable and PG, attendance and international fees from official provider pages. | Reconcile sponsor, provider, campus, course and international scope. Review name-only joins, partner campuses, expired sponsor records, non-university sponsors, and institutions outside England. [Home Office register](https://www.gov.uk/government/publications/register-of-licensed-sponsors-students) · [Discover Uni](https://discoveruni.gov.uk/information-providers/) |
| **IE** | Link stable provider and qualification/award IDs through QQI/IRQ and provider pages. Stage TrustEd provider authorisation and ILEP programme evidence separately. Associate programme, campus, awarding body, NFQ level and exact dated authorisation. | Test the applicable ILEP/TrustEd transition by effective date and scope. Review franchise arrangements, mergers and unmatched programme IDs. Retain a valid pathway only where the official source supports that programme and cohort. [Irish Register of Qualifications](https://www.qqi.ie/what-we-do/the-qualifications-system/irish-register-of-qualifications) · [TrustEd Ireland](https://www.trustedireland.ie/) · [ISD ILEP](https://www.irishimmigration.ie/coming-to-study-in-ireland/what-are-my-study-options/interim-list-of-eligible-programmes-ilep/) |
| **US** | Join DHS SEVP F-1 campus evidence, appropriate recognised accreditation from DAPIP and institution/credential context from IPEDS. Preserve SEVP campus IDs or stable source keys, IPEDS UNITID and accreditor identifiers where available. Use institution course/catalogue pages for actual current programmes, campuses, tuition and attendance. | Prove campus-level F-1 scope, relevant institutional accreditation and bachelor-or-higher offering separately. Review unmatched campuses and branch relationships. IPEDS CIP completions describe historical output. Require official programme evidence for a current listing and published classification evidence for any field-specific policy connection. [DHS School Search](https://studyinthestates.dhs.gov/school-search) · [DAPIP](https://ope.ed.gov/dapip/) · [NCES IPEDS](https://nces.ed.gov/IPEDS/use-the-data) |

Use the following authorities as the first source candidates. Source owners must confirm exact data grain, applicable authority, access terms and redistribution permission during integration. A listed source is a lead; published claims require dated supporting evidence.

| Country | Study rules | Climate and costs | Careers |
|---|---|---|---|
| AU | Home Affairs, legislation and Fair Work authorities. Verify regional pathways and cohort-specific concessions independently. | BOM normals and scoped official or institutional student budget estimates. | ABS OSCA and JSA occupations, shortages, employment and projections. [Home Affairs](https://immi.homeaffairs.gov.au/visas/getting-a-visa/visa-listing/student-500) · [Fair Work](https://www.fairwork.gov.au/pay-and-wages/minimum-wages) · [BOM](https://www.bom.gov.au/climate/averages/) · [JSA](https://www.jobsandskills.gov.au/data) |
| CA | IRCC DLI and study permit/PGWP sources, with provincial/territorial employment authority for wage facts. | ECCC station normals and dated local student budgets. | NOC, Statistics Canada, Job Bank and COPS. [IRCC DLI](https://www.canada.ca/en/immigration-refugees-citizenship/services/study-canada/study-permit/prepare/designated-learning-institutions-list.html) · [ECCC](https://climate.weather.gc.ca/climate_normals/) · [Job Bank](https://www.jobbank.gc.ca/trend-analysis) |
| GB | Home Office Immigration Rules, application and graduate route pages, plus applicable wage authority. | Met Office station normals and verified provider/local student budgets. | ONS SOC, ASHE and regional employment, plus official projections. [Student visa](https://www.gov.uk/student-visa) · [Met Office](https://www.metoffice.gov.uk/research/climate/maps-and-data/climate-averages) · [ONS labour market](https://www.ons.gov.uk/employmentandlabourmarket) |
| NZ | Immigration NZ, NZQA source links where relevant and Employment NZ wage material. | Cliflo/official climate releases and scoped tertiary budgets. | Stats NZ native classifications, MBIE vacancy and projection data, Tahatū earnings with stated methodology. [Immigration NZ](https://www.immigration.govt.nz/study/after-you-finish-your-study/staying-to-work-after-finishing-your-study/) · [Cliflo](https://cliflo.niwa.co.nz/) · [MBIE](https://www.mbie.govt.nz/business-and-employment/employment-and-skills/labour-market-reports-data-and-analysis/) |
| IE | Irish Immigration Service, employment permit authority and statutory minimum wage sources. | Met Éireann normals and institutional or official student budgets. | SOLAS National Skills Bulletin and CSO occupation, industry, pay and employment data. [Irish Immigration Service](https://www.irishimmigration.ie/coming-to-study-in-ireland/) · [Met Éireann dataset](https://data.gov.ie/dataset/met-eireann-1991-2020-climate-averages) · [CSO data](https://data.cso.ie/) |
| US | State Department, DHS, USCIS and effective legal text. Verify federal and applicable state/local wage scopes. | NOAA normals, IPEDS components and scoped institutional budgets. | BLS SOC/OEWS/projections and O*NET outlook; use state and metro grains as published. [State Department](https://travel.state.gov/content/travel/en/us-visas/study/student-visa.html) · [NOAA normals](https://www.ncei.noaa.gov/products/land-based-station/us-climate-normals) · [BLS OEWS](https://www.bls.gov/oes/) |

## Ingest, review and publish

1. **Register the source.** Record publisher, canonical URL, dataset key and scope, cadence, rights for access/storage/redistribution, extraction method and freshness thresholds using existing source/configuration controls. Use official bulk files and APIs first, then direct HTML/PDF. Meter any approved Firecrawl/Parse fallback and AI extraction in the existing toolset budget. AI may suggest a candidate; publication-sensitive legal interpretation and ambiguous identity require the appropriate human review.
2. **Capture and stage.** Store permitted compressed bytes in the existing private evidence bucket with relative object paths. Retain hash, headers, parser version, source locator, timestamps and edition/import IDs. Reuse unchanged captures. If terms bar capture or redistribution, honour the rights mode and keep only permitted metadata or links. Replays use stable source ID, edition/revision, native row key and input hash. Retry after bounded backoff and retain the last accepted generation.
3. **Validate and admit.** Validate required scopes, units, effective dates, expected source membership, duplicate keys, source coverage and release-to-release count changes. Quarantine parse drift, unresolved joins, overlapping rules and large coverage changes. Review high-impact immigration, wage, funding, citizenship and expiry changes in the authorised existing review flow. Commit one accepted import edition or small resumable batch atomically. A partial fetch never retires missing catalogue rows. Only a complete authorised registry reconciliation can propose a lifecycle change.
4. **Refresh the consumer projection.** Generate indexed, revisioned outputs scoped to country/module with the last authorised generation remaining readable during rebuild. Publish a new generation only after completeness and permission checks. Withdraw a known-invalid fact immediately at the serving layer and purge the matching Worker cache. Keep recoverable prior generations subject to freshness, correctness and expiry checks.
5. **Verify and observe.** Reconcile staged, accepted and published counts to real HTTP read-back and cache across the authorised consumer. Surface denominators, missing/held reasons, changed and withdrawn values, last good source edition, review deadline, refresh health, cost and freshness in existing Data Delivery. Use targeted first-run verification, genuine outage/timeout recovery and two unattended cycles. Prioritise actionable issues using existing fingerprints and queues. [F-OPS acceptance](../../platform/STUDYSEARCH-FEATURE-ACCEPTANCE.md)

Initial cadence targets are daily source-change checks for high-impact policy and registries, weekly or term-aware provider verification, and release-based observation updates. Configure cadence, publication rights, freshness, coverage guardrails and batch/byte limits through existing controls. Keep processing snapshots shorter-lived than static climate normals. Recheck source tiers and performance after RM1/RM2. Use btree indexes for canonical join keys and country/edition reads, partial indexes for current publishable facts where measured, and range indexing for date overlap checks. Validate high-volume query plans and avoid synchronous country-wide scans. Run large transformations in bounded workers or database batches.

### Consumer contract and access

Reuse the existing Cloudflare and Supabase deployment paths. For new facts, propose a separate versioned destination read interface under existing G3 controls, with country/module selectors, cursor paging, generation/revision, source attribution, jurisdiction and measure metadata. A compact destination summary can point to separate policy, city and careers collections. Status values distinguish `available`, `not_available`, `under_review`, `stale` and `not_applicable`. Return a dated last-known observation only if the module's freshness contract permits it and label it. Suppress expired or withdrawn policy from current results. Publish material numbers in their native unit and currency. Preserve existing Website v2 and Zoho API contracts, with ordinary catalogue data published only through the established approved paths.

Private schema access defaults to internal roles. Publish only the approved read projection through the existing server/Worker boundary with least privilege, bounded response sizes and permissions tests. No broad anon/authenticated table grants, raw evidence links, private snapshot payloads or applicant inputs. Separate read and mutation privileges, use existing audit logging, and verify direct Data API denial for internal tables. [Supabase custom schemas](https://supabase.com/docs/guides/api/using-custom-schemas)

## Implementation sequence and acceptance

| Order | Implementation slice | Release evidence |
|---|---|---|
| 1 | RM0 schema/source/review fixtures, then RM1 Australia. First implementation is an official-source AU policy version, an AU campus climate normal and one JSA statistical edition through the existing evidence path. Add the remaining AU feature coverage within RM1. | Replay without duplicates; effective-date cutover, conflicting-source hold and withdrawal; city/station match and native units; shortage/visa-list separation; Admin and authorised consumer read-back. |
| 2 | RM2 Canada on existing catalogue. Implement provincial scope, programme/CIP matching and local budget coverage. | DLI and course match reconciliation; partial programme eligibility and missing CIP cases; provincial wage versus federal rule; date-bound cutover; blank city cost source reported. |
| 3 | RM3 GB adapters and modules; RM4 NZ modules on existing catalogue. | GB sponsor, provider and campus matches across four nations with UG/PG separation; London/non-London fund scope and wage bands. NZ qualification-specific and future/current pathway checks, local cost estimates and provider succession. |
| 4 | RM5 Ireland adapters and modules; RM6 USA adapters and modules. | Ireland programme/provider authorisation transition, NFQ and local costs. USA three-source join, distinct campus/parent identities, F-1 programme evidence, separate fee types, proposal-vs-effective handling, and native regional labour codes. |

For each country, record source-edition and target cohort counts, coverage by feature and geography, identity exceptions, quantitative publication gains, source authority review, golden scenario results, two unattended refreshes, a replay/partial-failure test and authenticated consumer read-back after publish/withdraw. For new catalogues report candidate, matched, rejected, active and published counts by entity grain. Validate that hidden or retired records and unsupported policy values stay out of public results. Verify controller-owned migrations, QA, production readiness and approved release under the existing model. Reuse F-DISC for adapter outcomes and F-OPS.02, .03A and .07 for first-run, observability and release proof. Record linked work and evidence in the existing Execution Register. This is a design record and proposed sequence. [Operating model](../../platform/AGENT-OPERATING-MODEL.md) · [Execution Register](../../platform/STUDYSEARCH-EXECUTION-REGISTER.md)

### Engineering and capacity allowance

| RM | Study rules | Cities and costs | Careers | Catalogue | Shared or release integration | Total eng h | Review/QA h |
|---|---:|---:|---:|---:|---:|---:|---:|
| RM0 | 128 | 70 | 110 | 48 | 64 | 420 | 24 |
| RM1 AU | 38 | 18 | 32 | 0 | 10 | 98 | 24 |
| RM2 CA | 55 | 20 | 40 | 0 | 10 | 125 | 28 |
| RM3 GB | 42 | 18 | 32 | 120 | 10 | 222 | 32 |
| RM4 NZ | 40 | 14 | 22 | 0 | 10 | 86 | 20 |
| RM5 IE | 32 | 14 | 22 | 66 | 10 | 144 | 24 |
| RM6 US | 58 | 28 | 54 | 170 | 10 | 320 | 36 |
| **Total** | **393** | **182** | **312** | **404** | **124** | **1,415** | **188** |

The 887 module hours reuse the roadmap estimates for RM0 and these six countries. The GB/IE/US catalogue estimates carry forward the roadmap lane allowances. Shared catalogue work, integration and review hours are scoped planning assumptions for this package. The estimate is a subset and refinement of the broader roadmap, with overlap reconciled before funding. At A$150/engineering hour and A$95/review hour, plus 25% contingency, allow **A$287,638 excluding GST** for labour. At 56 engineering hours per week, the effort is about **25 engineering weeks** before external lead times. Vendor usage, licensing, any separately procured specialist advice and website development require separate allowance.

Reuse the previous capacity model for the first six roadmap destinations as an initial envelope. The live baseline was **5.42 GB logical Postgres** and **30.69 GB objects**. Its six-destination model adds 90,500 course rows, 311,000 other observations and 129,600 retained captures. At 50 kB indexed per course, 2 kB per observation, 7 kB metadata and 220 kB object data per capture, that gives about **11.47 GB logical Postgres** and **59.20 GB objects**. The 30% headroom envelope is about **15 GB provisioned disk and 77 GB object storage**, subject to physical disk, WAL/temp use, backup/restore and organisation-wide quota checks. The model includes broader catalogue volumes from the roadmap. Measure actual object sizes, index growth, storage by bucket, throughput and database pressure after the first two releases. Use existing Medium compute as the starting point and scale on measured demand. [Roadmap capacity baseline](../../platform/nz-enrichment-brief/2026-11-11-studysearch-destination-roadmap.md) · [Supabase compute and disk](https://supabase.com/docs/guides/platform/compute-and-disk)

## S1-RM-Design — database design and v3 delivery handoffs (13 November 2026)

**Status:** design and handoff record for RM0 (chat S1-RM-Design). Slice RM1A-1 was delivered on 13 November 2026 (see §7); everything else in this section is proposed. Proposed objects are marked *proposed*; every other object named here was confirmed in live read-only metadata on 13 November 2026 at about 15:20 AEDT. Prompt: [S1-RM-DESIGN-PROMPT.md](S1-RM-DESIGN-PROMPT.md). Related items: RM1A, RM4A, RM1B, RM1C, RM0B; O29, O28, O38, O23, O27, R30, R32, R33; REQ-52, REQ-57, REQ-58, REQ-67, REQ-68, REQ-75, REQ-76, REQ-81.

### 1. Verified starting point

| Surface | Deployed | Authenticated read-back | Consumer cutover | Planned here |
|---|---|---|---|---|
| Website v3 | Edge function `website-api-v3` **v2 ACTIVE**; actions `reference, search, course, providers, provider, rankings, scholarships, scholarship, sync`. Course items pass through `public.website_v3_course_item_r28` (both `website_v3_course` overloads, `website_v3_course_search`, `website_v3_sync`). | Recorded in the field definition's dated notes for R23/R24/R28/R29/R31/O20/O22/O26. Not repeated in this chat (design only). | **None.** `pipeline.api_requests` shows 1,919 Website calls in the last 7 days, all `website_developer_v2`, **0 v3-labelled**. Decision 277 keeps v3 open to additions. | `recognition[]`, `field_of_study_codes[]` on `course`; new `destination` action |
| Zoho v3 | Edge function `zoho-api-v3` **v1 ACTIVE** (Pilot #1107). `course` and `courses` reuse `website_v3_course_item_r28`; `scholarships/scholarship/rankings` are the Website v3 answers; `sync` = `zoho_v2_sync`, `export` = `zoho_v2_export_page` (**v2 shape, v2 CSV**); other actions v2 unchanged. | Not performed in this chat. | **None.** 8 Zoho calls in 7 days, all `zoho_creator_v2`. | `recognition[]`, `field_of_study_codes[]` on `course` only, after Zoho comms |
| v2 | `website-api-v2` v3 and `zoho-api-v2` v5 ACTIVE, frozen under G3 | — | Live consumers | **No change** |
| `destination`, `api_v3` schemas | **Absent** | — | — | `destination` proposed below |

Live facts that shape the design:

| Fact (13 Nov 2026) | Consequence |
|---|---|
| `catalogue.course_registrations` (uuid PK; unique `course_id, scheme, registration_code`; FKs to course and country; no status CHECK, no `created_at/updated_at`). Active rows: AU `cricos` **25,543**, NZ `nzqa` **6,495**, CA `mtcu` 766 plus two first-party programme-code schemes (220). Every row has `source_id` and `evidence_id`; `valid_from` is never populated. | Reuse as-is for O29. No table change for the first slice. |
| **2,297 AU `cricos` rows are `status='active'` with `valid_to = 2026-10-01`** (all one date, one source; 2,099 of them are on API-searchable courses). | Contradictory lifecycle. The projection holds them (`registration_dates_inconsistent`) and F-DISC reconciles them; it never asserts recognition from a past `valid_to`. |
| AU evidence is the stored `cricos-courses.csv` from data.gov.au (source `dataset`, "CRICOS Providers, Courses and Locations", captures 26 Sep–3 Nov). NZ evidence is one stored **provider-list** snapshot (`nz_nzqa v1`, `typeCode=UNI`, 30 Oct); NZ codes mix 4-digit numbers (3,894), provider-style codes such as `AC1062` (2,559) and other forms (42). | AU is course-grain register evidence. NZ is **not yet course-grain evidence**; RM4A needs a course-level NZQF/NZQA listing before any NZ assertion. |
| `ref.fields_of_study`: 102 rows; courses point only at depth-1 `asced-dddd` codes (ASCED narrow field). AU values come from the CRICOS "Field of Education 1 Narrow Field" column (`_shared/cf247-register-zip.ts`); **no AU course has an `enrich_fields` field-of-study item**. NZ 6,301 and CA 4,921 values were filled by `enrich_fields` (`ai_title`). `primary_field_id` has no per-row source or evidence. | CA/NZ codes are inferred and must never be published as ASCED, CIP or NZSCED. AU is source-native in practice, but row-level provenance is not stored; see the O28 gap below. |
| API-searchable courses (`search.course_documents`): AU **23,732** (21,633 with a current-dated active CRICOS row), NZ **6,495**, CA **3,814** (0 CRICOS/NZQA). Only 5 AU and 5 NZ courses are `publication_status='published'` (formal publication intentionally inactive, 7 Nov). | Visible denominator = what the v2 course detail already returns. The new fields only decorate items v2 returned, so hidden, archived and unpublished-provider rules are inherited unchanged. |
| `catalogue.provider_registrations`: `ircc_dli` 1,130 active (provider grain), `cricos` 1,493 active / 63 ended, `nzqa` 417. | Provider DLI never becomes course recognition or PGWP. |
| `pipeline.city_regions`: 51 rows, one country, `source='ai'`. AU campuses: 3,990 active, 3,987 with postcode and evidence, **0 with latitude/longitude**. | `city_regions` cannot prove a locality. RM1B maps campus postcodes through an official ABS correspondence. |
| `pipeline.statistics_dataset_registry` holds QILT, PRISMS and rankings; `statistics_edition_candidates` exists. Extensions: no `btree_gist`. | Reuse the registry and candidate workflow for ABS editions. Enforce policy non-overlap by trigger, not an exclusion constraint. |
| Open PRs: Pilot #1118–#1120 (F-CDESC, F-SCH, F-INT); Admin #401. None touch recognition, classification or destination objects. | No conflict for the first slice. |

### 2. Field matrix

Null meaning: a scalar is `null` when nothing is admitted for the returned scope. An array is `[]` when no assertion is admitted. **Neither `null` nor `[]` asserts absence** (not recognised, not listed, no route). Operator views carry the held or unknown reason.

| RM / request ID | Meaning and entity grain | Verified source and canonical column, or proposed field | Type / enum and null meaning | Evidence / rights | Website v3 action | Zoho v3 action | Owner |
|---|---|---|---|---|---|---|---|
| RM1A / O29 (AU) | Course is registered on CRICOS. Grain: course × CRICOS course code | `catalogue.course_registrations` (`scheme='cricos'`, `registration_code`, `status`, `valid_to`, `source_id → pipeline.sources.url`, `evidence_id`) | `recognition[]` item `{scheme:"CRICOS", code, status:"registered", authority, source_url, checked_at}`; `[]` = none admitted | Stored data.gov.au CSV; public dataset link only (no evidence path). Confirm the dataset licence at source registration | `course` (both forms) — **slice RM1A-1** | `course` after Zoho comms; `courses` second | RM-Recognition; F-DISC owns lifecycle |
| RM4A / O29 (NZ) | Qualification listed on the NZQF. Grain: course × NZQA qualification number | Same table, `scheme='nzqa'` — **held**: evidence is provider-grain and codes mix schemes | `{scheme:"NZQF", code, status:"listed", authority:"NZQA", …}`; `[]` until course-grain evidence | Needs a course-level NZQA qualification listing captured through L1 | `course` (RM4A-2) | `course` | RM-Recognition with L1 NZ adapter owner |
| O29 (CA) | Programme authorisation (MTCU/APS etc.) — **not DLI, not PGWP** | `course_registrations` `mtcu` 766 / first-party codes 220; provider `ircc_dli` stays provider grain | Not emitted in RM1A/RM4A; later `{scheme:"ON_MTCU"…}` only with authority review | Ontario open data / first-party pages | Later (RM2) | Later | RM-Recognition (RM2) |
| RM1A / O28 (AU) | ASCED field of education. Grain: course × scheme edition × rank (CRICOS Field 1 and Field 2) | **Proposed** `catalogue.course_classification_assignments`, backfilled from stored CRICOS evidence. `courses.primary_field_id` keeps its `study_area` role | `field_of_study_codes[]` item `{scheme:"ASCED", edition:"2001", level:"narrow", code:"0803", rank:1}`; code is a 4-digit string with leading zero; `[]` = none admitted | CRICOS CSV row (course code + input hash) | `course` — **slice RM1A-2** | `course` | RM-Recognition |
| O28 (CA/NZ, US) | CIP / NZSCED native assignment | Same proposed table with `basis='register_native'` or `'provider_native'` only; AI-inferred `primary_field_id` excluded | `[]` until native; crosswalk rows never emitted | Native register or programme page | Later | Later | RM-Recognition (RM2/RM4/RM6) |
| RM1B / O38, REQ-67 | Resident population of the official urban area serving a campus city. Grain: locality × dataset edition × reference date × measure | **Proposed** `destination.locality` (ABS ASGS Significant Urban Area, boundary vintage), `destination.campus_locality`, `destination.city_observation` (`measure='erp_persons'`), `destination.dataset_edition` | `{locality_id, name, geography:"SUA", boundary_vintage:"ASGS 2021", value:int, unit:"persons", reference_date, edition}`; locality without observation → `value:null, status:"not_available"` | ABS Regional population (ERP) + ABS postcode→SUA correspondence. ABS publishes under CC BY 4.0 generally; confirm per table at registration (REQ-68 covers JSA/QILT/Home Affairs separately) | New `destination` action, `module=cities` | Not offered until a confirmed Zoho use | RM-Cities |
| RM1C / O23 | Application route. Grain: rule version × applicability (country, subdivision, provider, course, study level, applicant class) | **Proposed** `destination.policy_rule`, `destination.policy_version`, `destination.policy_applicability` (`topic='application_route'`) | Destination item `{route_code, route_label, url, applicant_class, limited_places: true/false/null, effective_from, effective_to}`; course `application_route` stays `null` unless the course is explicitly bound | Official portal/provider page, stored evidence, last checked | `destination` `module=study_rules` first; course `application_route` only for proven course bindings | Not offered initially | RM-Study-Rules |
| O27 | Post-study work right | Same policy tables, `topic='post_study_work'`, condition JSON on version | Course `post_study_work` stays `null`; destination returns sourced conditional rules only | Home Affairs / INZ / IRCC legal text | Later | Later | RM-Study-Rules |
| Extensions (climate, living costs, careers, wages, visa funds) | Climate normal; student budget; labour series; legal wage floor; visa funds | `city_observation` (`observation_type` climate/cost), `labour_observation` (as §Existing foundations), policy tables for wages and funds | Native unit/currency/interval; separate measures, never summed across types | BOM, institutional budgets, JSA, Fair Work, Home Affairs | `destination` modules `cities`, `careers`, `study_rules` | Later | RM-Cities / RM-Careers / RM-Study-Rules |
| RM1F / R30, REQ-57 | Business-school accreditation | Assertion table after **D-3** | provider `accreditations[]` | Accreditor list rights | `provider` | `provider` | RM-Accreditations |
| RM1E / R32, REQ-75 | Provider primary campus | Assertion after **D-4** | `campuses[].is_primary` boolean/null, `primary_basis` | Registered address evidence | `provider` | `provider` | RM-Campuses |
| RM1G / O25, O17, REQ-52 | Study load; teaching language | S2-CF (course/offering facts) | `study_load` `full_time·part_time·both·null`; `teaching_language` ISO 639-1/null | Course page | `course`, `search` | `course` | S2-CF |
| O18/O19/O21 | Admission tests, entry conditions | AER | as field definition §3 | — | `course` | `course` | AER |
| Deadlines / R28 | Application deadlines, start-date status | S2-Intakes | as deployed | — | as deployed | as deployed | S2-Intakes |
| Awards | Scholarship fields | S2-Scholarship | as deployed | — | as deployed | as deployed | S2-Scholarship |
| RM0B / R33, REQ-76 | Field dictionary | Developer pack; this matrix supplies the new rows | — | — | v3 guide | Zoho pack | RM-v3-Dictionary |

### 3. Relationships

```mermaid
erDiagram
    COURSES ||--o{ COURSE_REGISTRATIONS : "has (existing)"
    COURSES ||--o{ COURSE_CLASSIFICATION_ASSIGNMENTS : "proposed"
    COURSES }o--|| FIELDS_OF_STUDY : "primary_field_id (existing, study_area only)"
    SOURCES ||--o{ COURSE_REGISTRATIONS : source_id
    EVIDENCE_ARTIFACTS ||--o{ COURSE_REGISTRATIONS : evidence_id
    EVIDENCE_ARTIFACTS ||--o{ COURSE_CLASSIFICATION_ASSIGNMENTS : evidence_id
    STATISTICS_DATASET_REGISTRY ||--o{ DATASET_EDITION : "dataset_key (proposed)"
    DATASET_EDITION ||--o{ LOCALITY : "boundary edition"
    DATASET_EDITION ||--o{ CITY_OBSERVATION : edition
    LOCALITY ||--o{ CITY_OBSERVATION : locality
    CAMPUSES ||--o{ CAMPUS_LOCALITY : campus
    LOCALITY ||--o{ CAMPUS_LOCALITY : locality
    POLICY_RULE ||--o{ POLICY_VERSION : versions
    POLICY_VERSION ||--o{ POLICY_APPLICABILITY : scope
    POLICY_APPLICABILITY }o--o| PROVIDERS : "optional"
    POLICY_APPLICABILITY }o--o| COURSES : "optional"
    PUBLICATION_GENERATION ||--o{ CITY_OBSERVATION : "published in"
```

### 4. Proposed DDL and migration sequence

Migration timestamps are allocated by the Integration Controller. Names below are working labels. Each slice is one migration with its own forward-recovery file and guard header (G1–G4, Replaces, Retires, Reversal). All new functions are `security definer`, `set search_path = ''`, with execute revoked from `public, anon, authenticated` and granted to `service_role`, matching `20261113290000_cf247_zoho_api_v3.sql`. All new tables enable RLS with no policies (internal only). Before replacing any existing v3 function, record `md5(pg_get_functiondef(oid))` and stop if it differs from the value below.

| Function replaced | Live md5 (13 Nov) |
|---|---|
| `website_v3_course` (2 overloads) | `0d3ea4ec…`, `b8d1b699…` (match by `pg_get_function_identity_arguments`) |
| `zoho_v3_course(text,text)` | `f3e97603…` |
| `zoho_v3_courses(text[])` | `e7b05f53…` |

**M1 · RM1A-1 · O29 AU recognition projection (no table change)**

```sql
-- security.course_recognition_v1: set-based, one row per course id passed in; only CRICOS in this slice
create or replace function security.course_recognition_v1(p_course_ids uuid[])
returns table (course_id uuid, recognition jsonb, held_reason text)
language sql stable security definer set search_path = '' as $$
  select c.id,
         coalesce(jsonb_agg(jsonb_build_object(
             'scheme', 'CRICOS', 'code', r.registration_code, 'status', 'registered',
             'authority', 'Australian Government — CRICOS', 'source_url', s.url,
             'checked_at', to_char(e.captured_at at time zone 'UTC', 'YYYY-MM-DD'))
           order by r.registration_code) filter (where r.id is not null and (r.valid_to is null or r.valid_to > current_date)), '[]'::jsonb),
         case when bool_or(r.id is not null and r.valid_to <= current_date) then 'registration_dates_inconsistent' end
  from unnest(p_course_ids) u(id)
  join catalogue.courses c on c.id = u.id
  left join catalogue.course_registrations r
         on r.course_id = c.id and r.scheme = 'cricos' and r.status = 'active'
  left join pipeline.sources s on s.id = r.source_id and s.status = 'active'
  left join pipeline.evidence_artifacts e on e.id = r.evidence_id
  where s.id is not null or r.id is null
  group by c.id
$$;
-- public.website_v3_course_item_detail_v1(item jsonb): resolves the course id from search.course_documents (as _r28 does),
-- adds recognition (and in M2 field_of_study_codes). Called only by website_v3_course (both forms) and zoho_v3_course.
```

Rules: a registration with `status <> 'active'` produces no item (withdrawal removes the assertion at the next read; no cache beyond the existing Worker). A row with `valid_to` in the past is held, not shown. A course with no source URL produces no item. No new index is needed: the composite unique index leads with `course_id`. Rollback: restore the three wrappers from the recorded definitions; drop the two new functions. v2 untouched.

**M2 · RM1A-2 · O28 AU ASCED — verified schema gap**

> **Withdrawn 16 November 2026 (v1.3).** `catalogue.course_field_observations` already holds these codes with source and evidence. RM1A-2 was delivered as a read-only projection with no new table. The text below is kept for history only.

The gap: `primary_field_id` has no per-row source, evidence or scheme edition. It is also written by an AI classifier for other countries and only holds the first CRICOS field. A projection could only infer provenance from country. The smallest additive fix is an assignment table filled from stored register evidence.

```sql
create table catalogue.course_classification_assignments (            -- proposed
  id                uuid primary key default gen_random_uuid(),
  course_id         uuid not null references catalogue.courses(id) on delete cascade,
  scheme            text not null check (scheme in ('ASCED','CIP','NZSCED')),
  scheme_edition    text not null,                                      -- 'ASCED 2001'
  level             text not null check (level in ('broad','narrow','detailed')),
  code              text not null check (code ~ '^[0-9]{2,6}$'),          -- digits as published, leading zeros kept
  rank              smallint not null check (rank between 1 and 9),      -- CRICOS Field of Education 1 = 1, 2 = 2
  basis             text not null check (basis in ('register_native','provider_native','crosswalk','manual')),
  status            text not null default 'active' check (status in ('active','superseded','withdrawn','held')),
  source_id         uuid not null references pipeline.sources(id),
  evidence_id       uuid not null references pipeline.evidence_artifacts(id),
  source_row_key    text not null,                                       -- CRICOS course code
  input_hash        text not null,                                       -- sha256 of the source row fields read
  observed_at       timestamptz not null,
  withdrawn_at      timestamptz, withdrawn_reason text,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  check ((status = 'withdrawn') = (withdrawn_at is not null)),
  check (scheme <> 'ASCED' or level <> 'narrow' or code ~ '^[0-9]{4}$')
);
create unique index cca_current_uq on catalogue.course_classification_assignments (course_id, scheme, scheme_edition, rank) where status = 'active';
create unique index cca_replay_uq  on catalogue.course_classification_assignments (course_id, scheme, scheme_edition, rank, input_hash);
create index cca_code_idx          on catalogue.course_classification_assignments (scheme, code) where status = 'active';
create index cca_evidence_idx      on catalogue.course_classification_assignments (evidence_id);
alter table catalogue.course_classification_assignments enable row level security;
```

Backfill and refresh: an L1 apply step re-reads the **stored** CRICOS CSV (no new fetch), keyed on `(course_id, scheme, edition, rank, input_hash)` with `on conflict do nothing`. A changed hash supersedes the previous row in the same transaction. A course missing from a **complete** accepted edition is withdrawn. A partial read never withdraws. Batches are bounded (existing `batch.*` size; no change to `batch.admin_jobs`). Reconciliation before release: rank-1 code equals `primary_field_id` for every AU course, or the mismatch is listed in Data Delivery. Consumer projection emits only `basis in ('register_native','provider_native')`. Corrections: a manual row (`basis='manual'`, with evidence) supersedes and is protected by `pipeline.manual_locks`. Rollback: drop the projection change first, then the table (no other object depends on it).

**M3 · RM1B · destination core and AU city population**

```sql
create schema destination;                                                         -- proposed
revoke all on schema destination from public, anon, authenticated;
grant usage on schema destination to service_role;

create table destination.dataset_edition (
  id uuid primary key default gen_random_uuid(),
  dataset_key text not null references pipeline.statistics_dataset_registry(dataset_key),
  publisher_release_id text not null,                  -- e.g. ABS 'Regional population 2024-25'
  revision smallint not null default 0,
  reference_period daterange, released_on date not null, revised_on date,
  classification text,                                 -- 'ASGS Edition 3 (2021)'
  content_hash text not null, source_id uuid not null references pipeline.sources(id),
  evidence_id uuid not null references pipeline.evidence_artifacts(id),
  candidate_id bigint references pipeline.statistics_edition_candidates(id),
  rights_mode text not null check (rights_mode in ('publish','publish_attributed','internal_only','link_only')),
  attribution text,
  status text not null check (status in ('staged','accepted','published','superseded','withdrawn')),
  created_at timestamptz not null default now(),
  unique (dataset_key, publisher_release_id, revision));

create table destination.locality (
  id uuid primary key default gen_random_uuid(),
  country_id uuid not null references ref.countries(id),
  subdivision_id uuid references ref.subdivisions(id),
  scheme text not null,                                -- 'ABS_SUA'
  native_code text not null,                           -- kept as text
  boundary_edition_id uuid not null references destination.dataset_edition(id),
  name text not null, locality_type text not null,     -- 'significant_urban_area'
  status text not null default 'active' check (status in ('active','retired')),
  unique (scheme, native_code, boundary_edition_id));

create table destination.campus_locality (
  campus_id uuid not null references catalogue.campuses(id) on delete cascade,
  locality_id uuid not null references destination.locality(id),
  mapping_basis text not null check (mapping_basis in ('postcode_correspondence','official_address','manual')),
  allocation_ratio numeric(5,4) check (allocation_ratio between 0 and 1),
  status text not null check (status in ('accepted','held','withdrawn')),
  held_reason text, evidence_id uuid references pipeline.evidence_artifacts(id),
  valid_during daterange not null default daterange(current_date, null),
  decided_by uuid, decided_at timestamptz not null default now(),
  primary key (campus_id, locality_id, valid_during));
create unique index campus_locality_current_uq on destination.campus_locality (campus_id) where status = 'accepted' and upper_inf(valid_during);

create table destination.city_observation (
  id uuid primary key default gen_random_uuid(),
  locality_id uuid not null references destination.locality(id),
  edition_id uuid not null references destination.dataset_edition(id),
  observation_type text not null check (observation_type in ('population','climate','cost')),
  measure text not null,                               -- 'erp_persons'
  reference_date date not null, value numeric not null, unit text not null,
  scope jsonb not null default '{}'::jsonb,            -- climate: station/baseline; cost: basket/interval/currency
  native_row_key text not null, input_hash text not null,
  status text not null check (status in ('staged','accepted','withdrawn')),
  unique (edition_id, locality_id, measure, reference_date, scope));
create index city_obs_read_idx on destination.city_observation (locality_id, observation_type) where status = 'accepted';

create table destination.publication_generation (
  id bigint generated always as identity primary key,
  module text not null check (module in ('cities','study_rules','careers')),
  country_id uuid not null references ref.countries(id),
  status text not null check (status in ('building','published','superseded','withdrawn')),
  published_at timestamptz, item_count int, checks jsonb);
create unique index pubgen_current_uq on destination.publication_generation (module, country_id) where status = 'published';
```

Mapping rule: a campus maps to an SUA only when one SUA holds at least the configured share of its postcode (setting `destination.locality_min_share`, start 0.90). Lower shares, a missing postcode or multiple SUAs go to Layer 4 as `locality_ambiguous` with the correspondence row as evidence. Name-only joins and `pipeline.city_regions` (source `ai`) are never used as proof. Publishing writes a new `publication_generation`. The previous generation stays readable until the new one passes its checks. Withdrawing an edition sets it and its observations to `withdrawn` and publishes a generation without them. Rollback: drop the `destination` schema (no existing object references it).

**M4 · RM1C · policy rules for application routes**

```sql
create table destination.policy_rule (
  id uuid primary key default gen_random_uuid(),
  country_id uuid not null references ref.countries(id),
  topic text not null check (topic in ('application_route','post_study_work','visa_funds','work_rights','minimum_wage','dependants','processing')),
  authority text not null, jurisdiction text not null, rule_key text not null,
  unique (authority, jurisdiction, topic, rule_key));

create table destination.policy_version (
  id uuid primary key default gen_random_uuid(),
  rule_id uuid not null references destination.policy_rule(id),
  variant_hash text not null,                          -- hash of the canonical applicability set
  effective daterange not null check (not isempty(effective)),   -- half-open [start, end)
  value jsonb not null,                                -- schema-validated per topic: route_code, url, limited_places
  conditions jsonb,                                    -- typed condition JSON (O27); null for unconditional
  lifecycle text not null check (lifecycle in ('draft','scheduled','current','expired','superseded','withdrawn')),
  review_state text not null check (review_state in ('pending','approved','rejected')),
  source_id uuid not null references pipeline.sources(id),
  evidence_id uuid not null references pipeline.evidence_artifacts(id),
  legal_locator text, observed_at timestamptz not null, reviewed_at timestamptz, review_due date not null,
  supersedes_id uuid references destination.policy_version(id),
  created_at timestamptz not null default now());
create index policy_version_rule_idx on destination.policy_version (rule_id, variant_hash) where lifecycle in ('scheduled','current');

create table destination.policy_applicability (
  version_id uuid not null references destination.policy_version(id) on delete cascade,
  scope_type text not null check (scope_type in ('country','subdivision','provider','course','study_level','applicant_class')),
  country_id uuid references ref.countries(id), subdivision_id uuid references ref.subdivisions(id),
  provider_id uuid references catalogue.providers(id), course_id uuid references catalogue.courses(id),
  study_level_id uuid references ref.study_levels(id), applicant_class text,
  check (num_nonnulls(country_id, subdivision_id, provider_id, course_id, study_level_id, applicant_class) = 1));
create index policy_app_course_idx on destination.policy_applicability (course_id) where course_id is not null;
create index policy_app_provider_idx on destination.policy_applicability (provider_id) where provider_id is not null;
```

Non-overlap: a constraint trigger on `policy_version` takes `pg_advisory_xact_lock(hashtext(rule_id::text || variant_hash))` and rejects a second `scheduled/current` approved version whose `effective` overlaps (`&&`). This avoids adding `btree_gist`. Activation and expiry run in a bounded scheduled job registered in Task manager. `review_due` passing marks the item stale in Admin; it does not expire a legal rule. A correction inserts a superseding version and never edits the old one. AU first content: country-level international route `direct_to_institution` (AU international applicants apply to the provider or through its representatives), and subdivision-scoped tertiary admissions centre routes (UAC, VTAC, QTAC, SATAC, TISC) with `applicant_class='completing_australian_year12_or_ib_in_au'`. Each needs its own captured official page before admission. Course `application_route` is filled only from a `course` applicability row. Rollback: drop the three tables; M3 is unaffected.

**M5 · destination action (Website v3 only)**

New `public.website_v3_destination(p_country text, p_module text, p_cursor text, p_page_size int)` plus one action entry in `website-api-v3`. Owned by the Integration Controller. Zoho gains the action only for a confirmed use, under its own comms.

### 5. Contracts and fixtures

**Course detail — Website v3 `course` (RM1A-1/-2, additive):**

```json
{"action":"course","course_id":"course:cricos:03443d:104270b"}
→ {"item":{"course_id":"course:cricos:03443d:104270b","course_code":"104270B","study_area":{"code":"asced-0803","…":"…"}, "...":"v2 fields unchanged",
   "recognition":[{"scheme":"CRICOS","code":"104270B","status":"registered","authority":"Australian Government — CRICOS",
                   "source_url":"https://data.gov.au/data/dataset/cricos","checked_at":"2026-11-03"}],
   "field_of_study_codes":[{"scheme":"ASCED","edition":"2001","level":"narrow","code":"0803","rank":1}]},
   "api_version":"website-v3","request_id":"…"}
```

The course and CRICOS code are a real searchable AU course (13 Nov). Other values are illustrative.

| Fixture | Input state | Expected `recognition` | Expected `field_of_study_codes` |
|---|---|---|---|
| F1 positive AU | active CRICOS, `valid_to` null, source active | one CRICOS item | rank-1 ASCED narrow from assignment |
| F2 unknown | course without registration (e.g. CA) | `[]` | `[]` (AI-inferred `primary_field_id` not emitted) |
| F3 hidden | course not in `search.course_documents` or provider unpublished | `404 NOT_FOUND` as v2 | — |
| F4 expired / inconsistent | `status='active'`, `valid_to` ≤ today | `[]`, held reason in Admin | unchanged |
| F5 withdrawn | registration `status='inactive'` after an accepted edition | `[]` at next read | assignment `withdrawn` → `[]` |
| F6 NZ before RM4A-2 | active `nzqa`, provider-grain evidence | `[]` | `[]` |
| F7 parity | same course on Zoho v3 `course` | identical arrays | identical arrays |
| F8 v2 regression | same course on Website v2 and Zoho v2 | keys absent; body byte-equal to baseline | — |

Zoho v3 `course` uses the same helper. `courses` follows once batch timing is measured (≤ 50 ids). **Zoho `search`, `sync` and `export` stay v2-shaped**. This is documented as detail-only in the Zoho pack. Delta-sync child changes and withdrawals are out of scope. They need `updated_at` and change events on `course_registrations`, which the table does not have.

**Destination action — option comparison**

| Option | Fit | Risk | Verdict |
|---|---|---|---|
| A. New versioned `destination` action (`country_code`, `module`, `page_size` 1–200, `cursor`) | Fits paged observations and rule versions; explicit generation and revision | One new action to document | **Recommended** |
| B. Extend `reference` | Reuses an action | `reference` is unpaged closed lists; mixing editions breaks its caching and size | Rejected |
| C. Add locality/population to provider `campuses[]` | Convenient for one field | Duplicates per provider, no editions/paging; can't carry routes | Later, as a `locality_id` link only |

```json
{"action":"destination","country_code":"AU","module":"cities","page_size":100}
→ {"module":"cities","country_code":"AU","generation":17,"as_of":"2026-11-20T02:00:00Z","coverage":{"campus_cities":1165,"mapped":0,"held":0},
   "items":[{"locality_id":"…","name":"<SUA name>","geography":"ABS_SUA","native_code":"<SUA code>","boundary_vintage":"ASGS 2021",
             "population":{"value":null,"unit":"persons","reference_date":null,"edition":null,"status":"not_available"},
             "source":{"publisher":"ABS","url":"https://www.abs.gov.au/statistics/people/population/regional-population","attribution":"…"}}],
   "next_cursor":"g17:…","api_version":"website-v3"}
```

The cursor is pinned to `generation`. A cursor from a superseded generation returns `409 GENERATION_CHANGED` with the current generation. Statuses are `available`, `not_available`, `under_review`, `stale` and `not_applicable`. Withdrawn and non-redistributable rows are excluded. `study_rules` items carry `effective_from`/`effective_to` and conditions, and expired, withdrawn or draft versions are never returned. Values in the example are illustrative and are not admitted data.

### 6. Source registration, operations and acceptance

| Step | Existing control used |
|---|---|
| Register source | `pipeline.sources` (+ `statistics_dataset_registry` row `abs_erp_sua`, `abs_poa_sua_correspondence`) with rights mode and cadence; Platform Admin approval in Settings |
| Edition | `statistics-edition-discovery` → `statistics_edition_candidates` → accept to `destination.dataset_edition` |
| Refresh | CRICOS: existing L1 schedule; ABS: release-based check; routes: weekly page check with `review_due` |
| Operator view | Course Detail: registration and classification rows with source, evidence, status and held reason. Data Delivery: eligible / returned / held counts by reason for `recognition` and `field_of_study_codes`. Reference data: editions, localities, held mappings. Layer 4: `locality_ambiguous`, `registration_dates_inconsistent` |

| ID | Acceptance (measurable) | Links |
|---|---|---|
| AC-RM1A-01 | AU recognition returned on v3 `course` for all searchable courses with a current active CRICOS row (expected about 21,633). 2,099 searchable courses are held and shown in Data Delivery until F-DISC reconciles them | O29, F-DISC.01/.04 |
| AC-RM1A-02 | F1–F8 pass on Website v3 and Zoho v3 independently; `s57` consumer baseline shows no v2 change; `website_v2_*`/`zoho_v2_*` md5 unchanged | G3, Decision 277 |
| AC-RM1A-03 | Added `course` latency ≤ 10 ms p95 over 200 sampled calls; `EXPLAIN` shows index scans only; `search`/`sync` timings unchanged | Operating model v1.10 |
| AC-RM1A-04 | ASCED assignments: 100% of AU searchable courses have a rank-1 row from stored evidence, or each mismatch is listed; replay of the same edition inserts 0 rows | O28 |
| AC-RM4A-01 | NZ items appear only after a course-grain NZQF listing is captured; F6 passes until then | O29 |
| AC-RM1B-01 | One ABS ERP edition accepted; mapped/held counts for the AU campus cities in the approved cohort; no population shown for a different geography; withdraw and republish a generation proven | O38, REQ-67/68, F-OPS.02/.07 |
| AC-RM1C-01 | Overlap trigger rejects a conflicting version; a scheduled version activates at its date; an expired version disappears from current results; course `application_route` stays null without a course scope row | O23 |

### 7. First slice, dependencies and owners

| Order | Slice | Depends on | Owner |
|---|---|---|---|
| 1 | **RM1A-1** — M1 projection on Website v3 `course` (merge on green under Decision 277); Zoho v3 `course` held until Divya is notified. **Delivered 13 Nov 2026** (Pilot #1124, migration `20261113333000`): Website v3 only; live read-back 21,633 served / 2,099 held / NZ 6,495 held; Admin Recognition card and Data Delivery panel. Payload uses `evidence_date` and `checked_on` in place of `checked_at` | Recorded md5 of the three wrappers; developer register entry | RM-Recognition builds; Integration Controller composes wrappers and releases |
| 2 | F-DISC fix for the 2,297 `active`/past-`valid_to` CRICOS rows (clear on reappearance, or end the registration) | L1 CRICOS apply path | F-DISC / L1 owner |
| 3 | **RM1A-2** — M2 assignments + backfill + projection | Slice 1 released | RM-Recognition; L1 for the apply step |
| 4 | **RM4A-1** — capture course-grain NZQA/NZQF listing; classify `nzqa` codes by sub-scheme | L1 NZ adapter | RM-Recognition with L1 NZ owner |
| 5 | **RM1B** — M3 + ABS registration + postcode correspondence | Rights confirmation (REQ-68 route); Platform Admin source approval | RM-Cities |
| 6 | **RM1C** — M4 + AU route pages | M3 schema present | RM-Study-Rules |
| 7 | M5 destination action and developer pack rows | First published generation | Integration Controller; RM-v3-Dictionary for R33 |

Out of scope here: R30/R32 remain behind D-3/D-4. Study load and teaching language stay with S2-CF, admissions with AER, deadlines with S2-Intakes and awards with S2-Scholarship. UK, Ireland and USA catalogue identities follow their RM3/RM5/RM6 adapter milestones. Their recognition schemes reuse the same projection once the adapter proves course grain.

## RM delivery plan — database design, source data and Admin module by roadmap item (13 November 2026)

**Status:** plan (Platform Admin, 13 Nov 2026 16:35 AEDT, chat S1-RM-Design). Only RM1A-1 is built. Everything else below is planned work and uses the proposed objects in the S1-RM-Design section above.

**Consumer release position (Platform Admin, 13 Nov 2026 16:35):** Website v3 and Zoho v3 are both still under development. No v3 handover document is released to either developer yet. Roadmap fields are added to v3 as they are built and are recorded in the developer register and the v3 field definition. The handover documents (developer guide and Zoho pack, R33) are issued once, when v3 is ready to release. v2 stays frozen.

### How to read the plan

| Column | Meaning |
|---|---|
| Database | **Reuse** = existing tables only. **Extend** = one additive table or column. **New** = new tables in the proposed `destination` schema. |
| Source data | How the data arrives: **L1 register** (existing Layer 1 register adapter path), **Dataset ETL** (dataset registry → edition candidate → accepted edition, as QILT and PRISMS do today), **Page capture** (stored official page through the existing evidence path, reviewed by a person), **None** (already held). |
| Admin module | Where an operator sees and controls it. **Existing** screens are extended. **New** means a new module is needed. |

### Shared platform (RM0)

| RM | Item | Database | Source data | Admin module | Depends on |
|---|---|---|---|---|---|
| RM0B | v3 field dictionary and handover documents | None | None | None | Issued at v3 release, not before |
| RM0C *(new)* | Destination core: schema, dataset editions, localities, publication generations (design M3 core) | **New** `destination.dataset_edition`, `locality`, `campus_locality`, `city_observation`, `publication_generation` | Dataset ETL framework: one shared edition-load job registered in Task manager and Automations | Existing **Rankings & statistics** (dataset cards and edition picker) and **Layer 1 › Sources** | — |
| RM0D *(new)* | Study rules core: rules, versions, applicability, activation job (design M4 core) | **New** `destination.policy_rule`, `policy_version`, `policy_applicability` | Page capture with person review; daily activation/expiry job (catalogued) | **New** Destination data module (RM0F) | RM0C |
| RM0E *(new)* | `destination` action on Website v3; Zoho v3 when a use is confirmed (design M5) | Read functions only | None | Existing **Operations › API usage** | First published generation |
| RM0F *(new)* | **Destination data** Admin module | None (reads RM0C/RM0D) | None | **New**, one module with three tabs: **Study rules** (add, edit, review, approve, schedule, withdraw a rule version, with evidence), **Cities and costs** (localities, campus mappings, observations by edition), **Careers** (editions and coverage). Held items go to the existing Layer 4 Inbox. Coverage goes to existing Data Delivery. | RM0C, RM0D |

Why one new module: study rules are effective-dated records that a person must review and approve, and nothing in the current Admin edits that kind of record. City and careers data are read-mostly, so they sit as tabs in the same module instead of becoming separate screens.

### Australia (RM1)

| RM | Item | Database | Source data | Admin module | Depends on |
|---|---|---|---|---|---|
| RM1A-1 | CRICOS course recognition | Reuse | None (held) | Existing Course detail, Data Delivery | **Delivered 13 Nov** |
| RM1A-2 | ASCED field-of-study codes | **Extend** `catalogue.course_classification_assignments` | L1 register: apply step re-reads the stored CRICOS file (no new fetch) | Existing Course detail, Data Delivery | — |
| RM1A-3 *(new)* | Reconcile 2,297 active CRICOS registrations with a past end date | Reuse | L1 register (F-DISC fix in the CRICOS apply path) | Existing Layer 1 › Sources, Data Delivery | — |
| RM1B | City population | New (RM0C) | Dataset ETL: ABS regional population (ERP) and ABS postcode-to-urban-area correspondence | Destination data › Cities and costs; Layer 4 for ambiguous campus mappings | RM0C; source rights approval |
| RM1C | Application routes | New (RM0D) | Page capture: provider and admissions-centre pages | Destination data › Study rules | RM0D |
| RM1D | Careers dataset | **New** `destination.stat_dimension_member`, `stat_crosswalk`, `labour_observation` | Dataset ETL: one Jobs and Skills Australia edition | Destination data › Careers | RM0C; REQ-68 reuse terms |
| RM1E | Provider primary campus | **Extend** primary-campus assertion table | Rule job over held registered addresses, plus manual override | Existing Provider detail | Decision D-4 |
| RM1F | Business school accreditations | **Extend** accreditation assertion table | Page capture or accreditor list (rights first) | Existing Provider detail | Decision D-3 |
| RM1G | Study load and teaching language | Extend only if the course model lacks it (S2-CF decides) | Course-page reader (S2-CF) | Existing Course catalogue and detail | S2-CF |
| RM1H *(new)* | Study rules beyond routes: visa charges and funds, work rights, dependants, minimum wage, post-study work (O27) | New (RM0D) | Page capture: Home Affairs, Fair Work, legislation | Destination data › Study rules | RM0D, RM1C |
| RM1I *(new)* | Climate normals and student living costs | New (RM0C, `city_observation` climate and cost types) | Dataset ETL: BOM normals; page capture for institutional budgets | Destination data › Cities and costs | RM1B |

### Canada, UK, New Zealand, Ireland, USA (RM2–RM6)

| RM | Item | Database | Source data | Admin module | Depends on |
|---|---|---|---|---|---|
| RM2A | CA course-campus geography | Reuse | Existing pipeline repair | Existing Course catalogue | S2-CF |
| RM2B *(new)* | CA programme recognition and CIP codes; provider DLI kept separate from programme PGWP | Reuse registrations; Extend (RM1A-2 table) for CIP | L1 register: provincial programme registers; native CIP where published | Existing Course detail, Data Delivery | RM1A-2 |
| RM2C *(new)* | CA destination modules (study rules incl. PGWP, cities, careers) | New (RM0C/RM0D) | Page capture: IRCC, provinces. Dataset ETL: Statistics Canada, ECCC, Job Bank | Destination data (all tabs) | RM0C, RM0D, RM0F |
| RM3A *(new)* | GB catalogue adapter (sponsor register, provider identity, courses) | Reuse catalogue; identifiers in existing mapping tables | L1 register: Home Office sponsor register, Discover Uni; provider pages | Existing Layer 1 › Sources, Catalogue | RM3 opened |
| RM3B *(new)* | GB destination modules | New (RM0C/RM0D) | Page capture: Home Office. Dataset ETL: ONS, Met Office | Destination data | RM3A, RM0F |
| RM4A | NZ course recognition | Reuse | L1 register: capture a course-level NZQF listing (today's evidence is provider-level) | Existing Course detail, Data Delivery | L1 NZ adapter |
| RM4B | NZ course-campus geography | Reuse | Existing pipeline repair | Existing Course catalogue | S2-CF |
| RM4C *(new)* | NZ NZSCED codes and destination modules | Extend (RM1A-2 table); New (RM0C/RM0D) | L1 register for NZSCED. Page capture: Immigration NZ. Dataset ETL: Stats NZ, MBIE | Existing Course detail; Destination data | RM4A, RM0F |
| RM5A *(new)* | IE catalogue adapter (QQI/IRQ, TrustEd, ILEP) | Reuse catalogue | L1 register | Existing Layer 1 › Sources, Catalogue | RM5 opened |
| RM5B *(new)* | IE destination modules | New (RM0C/RM0D) | Page capture: Irish Immigration. Dataset ETL: CSO, SOLAS, Met Éireann | Destination data | RM5A, RM0F |
| RM6A *(new)* | US catalogue adapter (SEVP, DAPIP, IPEDS) | Reuse catalogue | L1 register | Existing Layer 1 › Sources, Catalogue | RM6 opened |
| RM6B *(new)* | US destination modules and CIP codes | Extend (RM1A-2 table); New (RM0C/RM0D) | Page capture: State, DHS, USCIS. Dataset ETL: BLS, NOAA, IPEDS | Destination data | RM6A, RM0F |

### Build order

| Wave | Items | Outcome |
|---|---|---|
| 1 | RM1A-2 (**delivered 16 Nov**, Pilot #1186), RM1A-3 | AU field codes on v3; 2,099 held courses released |
| 2 | RM0C, then RM1B and RM4A in parallel | Destination schema live with one ABS edition; NZ recognition evidence captured |
| 3 | RM0D, RM0F (Study rules tab first), RM1C | First reviewed AU application routes, managed from the Admin |
| 4 | RM0E, RM1D, RM1H, RM1I | `destination` action on v3 with cities, study rules and careers for Australia |
| 5 | RM2B, RM2C, RM4C | Canada and New Zealand on the shared modules |
| 6 | RM3A/B, RM5A/B, RM6A/B | UK, Ireland and USA catalogues and modules |
| At v3 release | RM0B | Field dictionary and both handover documents issued once |

Standing rules that apply to every item: each background job is registered in Automations or Jobs and visible in Task manager; each source is registered and approved in Layer 1 › Sources before its first load; held items state a plain reason in Layer 4; coverage and holds show in Data Delivery; RM1E and RM1F wait for D-4 and D-3; Study load stays with S2-CF, admissions with AER, deadlines with S2-Intakes and awards with S2-Scholarship.

## Roadmap alignment and Wave 1 delivery (16 November 2026)

**Status:** record of Platform Admin directions (16 Nov 2026 22:30, 22:32 and 22:42 AEDT, chat S1-RM-Design) and of what was verified live the same evening. "Verified" means read from the live database or the repositories on 16 November. Anything else is recorded as directed or scheduled, not as done.

### Policy and dependencies

| Item | Position | Verified 16 Nov |
|---|---|---|
| Zoho v3 merge rule | **Changed.** Website v3 and Zoho v3 are both still in development and no handover document has been issued. Additive Zoho v3 fields now merge on green CI under the same additive and G3 rules as Website v3. No handover document is issued until v3 release (RM0B). v2 stays frozen. | Platform Admin direction. No v3-labelled consumer calls were seen on 13 Nov; not re-counted on 16 Nov |
| D-4, primary campus | **Resolved.** `catalogue.campuses.is_primary` is live | 356 rows (Pilot #1184) |
| D-3, accreditations | **Resolved as a decision.** `catalogue.provider_accreditations` exists | Table exists with 0 rows. Loading and publisher rights remain RM1F work |
| Campus-null reason and study load | Live | `courses.empty_reason_code` 5,639 rows; `courses.study_load` 2,521 rows (Pilot #1184) |
| Scheduler consolidation (PR 1–3, `pipeline.field_execution_registry`) | In progress | The registry table is **not live yet**. PR 2 cutover is open (Pilot #1185). PR 3 creates the registry. Current state: `docs/CURRENT-STATE.md` |
| Cloudflare Worker Boost (`workers/cf-boost-extractor/`, this repository) | Available as the stateless Layer 1/4 extraction adapter for RM1A-3, RM4A and the Wave 6 country adapters (UK, IE, US) | Built, **not deployed** (`docs/platform/CF-WORKER-BOOST-AND-PROD-LAUNCH.md`) |
| Migration consolidation | **Scheduled:** squash the live migration history into one canonical v3 baseline in the quiet window **Thursday 19 Nov 2026, 01:30–03:30 AEDT**, after PR D (Wed 18 Nov 13:30 AEDT). Before it: a dump to the private `staging-boost` Storage bucket and a rehearsal on `coursefinder-boost-test` (`ucdaaqrpgcldnatavmib`). Waves 2–6 build on the single baseline. | 2,046 applied migrations before RM1A-2 (2,047 after). The `staging-boost` bucket paste file had not been run as at `docs/CURRENT-STATE.md` |
| Database checks from Claude sessions | Read-only. No interactive database write prompts. Migrations reach production only through the PR, CI rehearsal and deploy-on-merge path | Followed for RM1A-2 |

### Wave 1, RM1A-2: delivered

**Correction to v1.1 §4 M2.** The "verified schema gap" was wrong. `catalogue.course_field_observations` already records every CRICOS field-of-education code against its source and stored evidence: 26,918 first-field and 1,656 second-field rows, all Australian, all with evidence. It is written by the CRICOS register apply step. **The proposed `catalogue.course_classification_assignments` table is withdrawn.** RM1A-2 is a read-only projection.

| Point | Delivered (Pilot #1186, migration `20261116200000`, release candidate v2.16.15) |
|---|---|
| Field | `field_of_study_codes[]` on Website v3 `course` (both forms) and Zoho v3 `course`: `{scheme:"ASCED", level:"narrow", code, name, rank, source_url, evidence_date}` |
| Source rule | A code is returned only when a current observation holds the 4-digit code the register printed, the linked field is that same ASCED code, the source is active and public, evidence is stored and the course has a CRICOS registration. Rank 1 is the register's first field and equals `study_area`. Rank 2 is its second field |
| Not inferred | NZ and CA study areas set by the AI classifier have no observation row and return `[]`. No CIP or NZSCED scheme is emitted. `study_area` is unchanged |
| Zoho v3 | `course` detail also returns `recognition[]` (RM1A-1) under the new merge rule. Zoho `search`, `courses`, `sync` and `export` are unchanged |
| Live read-back | 23,732 of 23,732 searchable AU courses return a rank-1 code; 1,561 also return a second; 6 have a superseded first-field observation left out. Website and Zoho answers are identical. An NZ course returns `[]` |
| Invariants | Applied migration md5 equals the file (`a6c9df3c…`). G3 guard after deploy: 75 functions, 48 tables, no drift. `website_v2_course`, `zoho_v2_course`, `zoho_v3_courses` and the R28 item function unchanged by md5 |
| Admin | Course detail Recognition card shows the codes; Data Delivery panel counts them |
| Not done | A keyed HTTP call to either v3 endpoint and a signed-in look at the Admin views were not made from this session. Edition ("ASCED 2001") is not returned because the register file does not print it |

### Build order after this change

| Wave | Items | State |
|---|---|---|
| 1 | RM1A-2 | **Delivered 16 Nov** |
| 1 | RM1A-3 (2,297 active CRICOS registrations with a past end date) | Open. Worker Boost is available as the extraction adapter once deployed |
| — | Migration consolidation, Thu 19 Nov 01:30–03:30 AEDT | Scheduled. Waves 2–6 start from the new baseline |
| 2 | RM0C, then RM1B and RM4A | Not started |
| 3 | RM0D, RM0F (Study rules tab), RM1C | Not started |
| 4 | RM0E, RM1D, RM1H, RM1I | Not started |
| 5 | RM2B, RM2C, RM4C | Not started |
| 6 | RM3A/B, RM5A/B, RM6A/B | Not started |
| Alongside | RM1E (primary campus data live), RM1F (table live, no rows), RM1G (study load live) | Decisions resolved; API exposure and loading remain with their owners |

## Platform state, Wave 1B delivery and Wave 2 readiness (17 November 2026)

**Status:** record for chat S1-RM-Design (Platform Admin, 17 Nov 2026 06:43 AEDT). Every figure below was read from the live database or the repositories on 17 November between 06:45 and 07:15 AEDT, read only.

### Platform state after Pilot #1186

| Item | State | Read live |
|---|---|---|
| Consolidation PR 2, `admission-rule-runner` (Pilot #1185) | **Live** | 20 rules, all `live` and enabled. 21 components retire after 30 Nov (the 20 legacy jobs and one other) |
| Consolidation PR 3, `coverage-lane-dispatch` and `pipeline.field_execution_registry` (Pilot #1188) | **Live, in its 24-hour shadow** | 20 registry rows: 13 worker lanes in `shadow`, 7 API v3 field lanes registered and `disabled` |
| Consolidation PR 1, `rollup-scheduler` | **In its fixed 24-hour shadow**; cutover review tonight 23:20 AEDT | 26 targets, all `shadow` |
| Admin UI v2.16.16 (Pilot #1189, package 0.1.438) | **Live** before this change | Now superseded by v2.16.17 (below) |
| Zoho v3 merge rule | **Settled.** Additive Zoho v3 fields merge on green CI like Website v3. No handover document until v3 release. v2 frozen | G3 guard: 75 functions, 48 tables, no drift |

### Wave 1B, RM1A-3: delivered (Pilot #1190, migration `20261117010000`, v2.16.17)

**What the 2,297 were.** Not expired registrations. The stored 11 November CRICOS edition (plan `d35d2541`) lists 25,199 current course codes: 23,246 unchanged, 1,596 changed, 357 new. It also records 701 departed codes. The end-date job counted a code as listed only once its register row had been seen again. A changed row is not seen again until its slice is applied, so the 1,596 changed codes were end-dated 1 October as if they had left. The 2,297 split exactly.

| Group | Registrations | On searchable courses | Evidence | Outcome |
|---|---|---|---|---|
| 1. Verifiable from stored register evidence | 1,596 | 1,505 | Listed in the stored 11 Nov edition as changed rows | **Reconciled.** End date cleared by the job's own "listed again" step |
| 2. Not on the stored edition | 701 | 594 | Recorded by the plan as departed; departures approval `pending` | **Held.** Not guessed. Released automatically if a later edition lists them; removal waits for the existing register departures approval (Platform Admin, Layer 1 › Sources) |

| Point | Delivered |
|---|---|
| Fix | `security.layer1_register_end_dates_v1` treats a code the latest planned edition carries as a new or changed item as listed. No date is invented and no status is set by hand. Run once in the migration, as the daily job runs it |
| Result (run 23) | 1,635 course registrations restored (1,596 active, 39 inactive); 43 provider registrations restored from `ended`; 0 ended |
| `recognition[]` after deploy | AU served **23,138** of 23,732 searchable (was 21,633); **594 held**. A previously held course (095688K) now returns its CRICOS item on Website v3 and Zoho v3 |
| Held reason | Renamed `not_on_latest_register_edition` (was `registration_dates_inconsistent`); Admin card and Data Delivery wording updated |
| Invariants | Applied migration md5 equals the file (`115842dc…`). G3 guard after deploy: 75 functions, 48 tables, no drift. `website_v2_course` and `zoho_v2_course` unchanged by md5 |
| No separate re-check lane | The daily CRICOS register job and `layer1-register-end-dates` already re-check every edition, so group 2 needs no new `coverage-lane-dispatch` lane |
| Still open | 1,953 rows of the 11 Nov edition (1,596 changed, 357 new) are still waiting to be applied by Layer 1, six days after the plan. The 701 departures await approval |
| Not done | A keyed HTTP call to either v3 endpoint and a signed-in look at the Admin views |

### Wave 2 readiness (builds on the squashed baseline after Thu 19 Nov 01:30–03:30 AEDT)

**RM0C and RM1B (AU city population).** Design M3 stands. Sources to register:

| Dataset | Specification | Reuse terms | Use |
|---|---|---|---|
| ABS *Regional population*, 2024-25 | Released 31 March 2026. Estimated resident population at 30 June 2025 by Significant Urban Area (ASGS Edition 3, 2021 boundaries) | ABS website material is CC BY 4.0; attribute the ABS | `destination.city_observation`, measure `erp_persons`, reference date 2025-06-30 |
| ABS *ASGS Edition 3 (2021) Correspondence Files* (data.gov.au, ABS Geospatial Solutions) | One zip of correspondence files, including Significant Urban Area and non-ABS structures (Postal Areas) | CC BY 4.0 | Campus postcode → Postal Area → SUA share for `destination.campus_locality` |
| Fallback: ABS *ASGS Edition 3 (2021) Allocation Files* | Mesh Block to SUA and to Postal Area | CC BY 4.0 | Derive the postcode-to-SUA share if the zip has no direct Postal Area to SUA file |

To confirm at first capture, not assumed: that the correspondence zip holds a direct Postal Area 2021 to SUA 2021 file, and the exact SUA table in the 2024-25 data downloads. ASGS Edition 3 covers July 2021 to June 2026 and Postal Areas change with Edition 4, so the boundary vintage is stored on every locality.

**RM4A (NZ course recognition).** Capture plan through the existing Layer 1 NZ adapter:

1. Capture the NZQA qualifications search (NZQCF) per provider: qualification number, title, type, level, status. Store each result page as evidence.
2. Match to `catalogue.course_registrations` (`scheme='nzqa'`) by qualification number. The 3,894 four-digit codes are the candidates; the 2,559 provider-style codes (for example `AC1062`) and 42 others are classified, not assumed.
3. Emit `recognition[]` `{scheme:"NZQF", status:"listed"}` only for a matched, current qualification with course-level evidence. Universities' qualifications are approved by Universities New Zealand and still appear on the NZQCF.
4. Reuse terms: NZQA website material is CC BY 4.0 with written credit. NZQCF qualification details may be cited and used as reference; other or commercial use needs an application to NZQA. Recorded as a management flag; it does not gate admission (standing rule).

### Decisions for the Platform Admin

All three were approved on 17 November 2026 at 07:29 AEDT; see [ABS source approvals and Wave 2 schema hold](#abs-source-approvals-and-wave-2-schema-hold-17-november-2026).

1. Approve registering the two ABS sources (Regional population 2024-25 and the ASGS Edition 3 correspondence files) under CC BY 4.0 with ABS attribution shown beside every population figure.
2. Confirm Significant Urban Area as the city geography (not Greater Capital City or LGA), with ERP at 30 June 2025 as the first edition.
3. Confirm the campus mapping rule: a campus maps to one SUA only when at least 90% of its postcode falls in it; anything else goes to Layer 4.

## ABS source approvals and Wave 2 schema hold (17 November 2026)

Platform Admin, 17 November 2026 07:29 AEDT (S1-RM-Design). This section records decisions only. Nothing was built, registered or deployed by this change.

### Approved for RM1B

| # | Decision | Approved terms | Effect on the design |
|---|---|---|---|
| A-1 | Register two ABS sources | ABS *Regional population 2024-25* (reference date 30 June 2025) and ABS *ASGS Edition 3 (2021) Correspondences*, both under CC BY 4.0, with ABS attribution displayed beside every population figure | Both become approved sources for `destination.city_observation` and `destination.campus_locality` (design M3). Attribution is a required part of every delivered population figure, not an optional note |
| A-2 | City geography | Significant Urban Area (SUA) is the canonical city geography. The first dataset edition is 30 June 2025, on the ASGS Edition 3 boundary vintage | Greater Capital City and LGA are not used as the city key. Each locality and observation stores its dataset edition and boundary vintage |
| A-3 | Campus mapping rule | A campus maps to an SUA only when at least 90% of its postcode is contained in that SUA. Ambiguous or multi-SUA postcodes go to Layer 4 for review | No population figure is delivered for a campus until it has a mapped SUA or a Layer 4 decision |
| A-4 | Fallback mapping source (standing approval, 07:35 AEDT) | If the correspondence zip has no direct Postal Area to SUA file, the share is derived from the ASGS Edition 3 Mesh Block allocation files, under the same CC BY 4.0 terms and ABS attribution. No separate approval round | The allocation files are an approved source for `destination.campus_locality`; the 90% rule (A-3) applies to the derived share unchanged |

Notes:

- The 90% value is an operational threshold. Under G2 it is built as a setting in `pipeline.platform_toolset_settings` (label, range, unit, `used_by`), not written into code.
- Still confirmed at first capture, not assumed: that the correspondence files include a direct Postal Area 2021 to SUA 2021 file, and the exact SUA table in the 2024-25 data downloads. If there is no direct file, A-4 applies. Any source beyond A-1 and A-4 needs a new approval.
- Source registration rows are data written by a migration, so they ship with the RM0C and RM1B change, not before it.

### Wave 2 schema hold

> Superseded on 17 November 2026 at 07:39 AEDT: the Platform Admin directed the remaining roadmap schema to ship before the squash. See [Roadmap schema pack before the squash](#roadmap-schema-pack-before-the-squash-17-november-2026). The text below is kept as the record of the earlier instruction.

Wave 2 schema DDL for RM0C, RM1B and RM4A is held until the migration squash on Thursday 19 November 2026, 01:30–03:30 AEDT, has completed and the Platform Admin has confirmed it is complete (restated 07:35 AEDT). No Wave 2 migration is opened as a pull request before then. Design, source capture planning and register updates may continue during the hold.

| Item | State | Released when |
|---|---|---|
| RM0C destination core schema and dataset editions | Design ready (M3); DDL held | Platform Admin confirms the squash is complete |
| RM1B Australian city population | Sources and rules approved (A-1 to A-4); DDL held | After RM0C |
| RM4A New Zealand course recognition | Capture plan ready; DDL held | Platform Admin confirms the squash is complete |

## Roadmap schema pack before the squash (17 November 2026)

Platform Admin, 17 November 2026 07:39 AEDT (S1-RM-Design): ship every remaining roadmap database object before the migration squash on Thursday 19 November 01:30 AEDT. This supersedes the Wave 2 schema hold of 07:29 and 07:35 the same morning.

### Correction to this design

Sections M3 and M4 above (13 November) proposed `destination.dataset_edition`, `locality`, `campus_locality`, `city_observation`, `publication_generation`, `policy_rule`, `policy_version` and `policy_applicability`. Pilot #1155 (15 November) had already created a `destination` schema with `editions`, `study_rules`, `city_profiles` and `career_outcomes`, and Pilot `20261115230000` added an importer and a publication guard on them. Versions 1.3 to 1.5 of this document did not reconcile the two. The M3 and M4 table names are withdrawn. The live model is the one below.

Decision (Platform Admin, 17 November 2026, on the question "replace, duplicate or extend"): **extend in place**. The #1155 tables, importer and guard stay; nothing is duplicated and nothing is dropped.

### What shipped (Pilot #1193 and #1194, migration `20261117040000`, v2.16.18)

Pilot #1193 merged on green CI but its migration (`20261117030000`) was refused by the deploy step before anything ran: the NOT NULL relaxation on `destination.study_rules` was written as a top-level `alter table ... drop not null`, which the deploy step treats as a drop. Pilot #1194 reissued the same migration as `20261117040000` with that statement inside the block that holds the other constraint changes, and added the deploy step's own refusal test to the spec so it is caught before merge. The relaxation removes no column, row or object and the table is empty; it is the change the Platform Admin chose ("extend in place, relaxing the visa-only NOT NULLs").

| Area | Object | State |
|---|---|---|
| Localities (RM0C, RM1B, RM1I, RM4C) | `destination.localities`, `destination.locality_postcodes`, `destination.locality_metrics` | New, empty |
| Study rules (RM0D, RM1C, RM1H, RM2C) | `destination.study_rules` extended: state, rule category, applicant scope, title, summary, threshold, currency, effective dates, row approval, quote, evidence date. Visa-only columns are now optional | Extended, empty |
| Rule applicability (RM0D) | `destination.rule_applicability` (country, state, locality, provider or course; proven or excluded; evidence) | New, empty |
| Careers (RM1D) | `destination.career_outcomes` extended: locality, occupation scheme (ANZSCO, NOC, SOC), reference period, dataset edition, attribution, status | Extended, empty |
| Scheme register (RM2B, RM3, RM4A, RM5, RM6) | `ref.registration_schemes`, 18 rows | New, seeded |
| API v3 (RM0E) | Action `destination` on `website-api-v3` and `zoho-api-v3`, through `public.website_v3_destination` and `public.zoho_v3_destination` | Live, returns empty lists |
| Admin (RM0F, database part) | `admin_destination_overview`, `admin_destination_review` (Curator and above), `admin_destination_set_status` (Platform Admin, reason required) | Live; no screen yet |
| Settings (G2) | `destination.page_size_max` (100), `destination.review_list_max` (200), `destination.postcode_primary_min_share` (0.9, approval A-3) | Live |
| Admin access history | `security.user_access_events` accepts `password_reset_sent` | Live |

### How the brief was mapped onto the live tables

| Brief field | Live column | Why |
|---|---|---|
| `career_outcomes.median_annual_earnings`, `currency_code`, `demand_rating` | Existing `median_salary` (with `salary_period`), `salary_currency`, `job_outlook_rating`. The API returns them under the brief's names | The columns already existed; a second copy would drift |
| `study_rules.approval_status`, `approved_by`, `approved_at` | New columns on the row. The edition's own status and terms (REQ-68) still apply | A rule is returned only when the row is approved **and** its edition is published |
| `rule_applicability.entity_id` | `entity_id` plus `entity_code` | A state has no UUID |
| `localities` | Adds `geography_code` | A load needs the source's own code to be repeatable |
| Scheme names `NZQA`, `AU_CRICOS`, `ASCED` and so on | Lower-case keys the catalogue already stores (`cricos`, `nzqa`, `mtcu`, `ircc_dli`), with new keys `pgwp`, `uk_qaa`, `uk_ofs`, `ie_qqi`, `us_opeid`, `us_ipeds`, `asced`, `nzsced`, `cip`, `hecos` | Renaming stored values would change what the frozen v2 API reads (G3). The scheme columns are free text with no check constraint, so no table change was needed |

### Rules the read path enforces

- Localities and locality figures: status `approved` or `published`.
- Study rules: row `approved`, edition `published`, today inside the effective dates.
- Career outcomes: status `approved` or `published`, edition `published`.
- Rows of a published edition are fixed (guard of `20261115230000`): approve rows first, then publish the edition. A later change is a new edition.

### Known limits, stated plainly

| Limit | Effect | Next step |
|---|---|---|
| No loader function for localities, postcode shares or locality figures | Loading is a service-role upsert on the tables' unique keys; `security.destination_postcode_flags_v1` applies the 90% rule | Build one catalogued load job per dataset (G1) with the first ABS capture |
| `career_outcomes` is unique on edition, country and occupation | A locality-level figure for the same occupation cannot sit beside the national one in the same edition | Decide the grain before the first sub-national load; the change is a new unique key through a paste file |
| `destination.city_profiles` (#1155) and `locality_metrics` both can hold population | Two homes for one fact | Use `locality_metrics`; mark `city_profiles` retiring once nothing reads it |
| The `destination` action is not in `ref.api_field_dictionary` | Its 72 fields per API are listed under `pending_fields` in `docs/api/v3/field-dictionary.json` | Load with the next reviewed dictionary issue (RM0B, at v3 release) |
| No Admin screen | Review and approval are RPCs only | RM0F screen, Study rules tab first |
| `password_reset_sent` is accepted but not yet written | The reset action still does not log to the access history | One-line change in `admin-user-management` in the next release |
| UK, Ireland and USA | Scheme keys are registered; no adapter exists | RM3A, RM5A, RM6A adapters |

### Live verification (read only, 17 November 2026 08:44 AEDT)

| Check | Result |
|---|---|
| Pilot #1194 | Merged on green (13 checks); Deploy on merge green; main `63deb84e` |
| Migration `20261117040000` | Applied; history md5 `9f6b5a1a…` equals the file. `20261117030000` is not in the history. 2,053 migrations applied |
| New tables | `destination.localities`, `locality_postcodes`, `locality_metrics`, `rule_applicability` present, row level security on, 0 rows. `ref.registration_schemes` 18 rows |
| `public.website_v3_destination('{}')` | `localities: []`, `study_rules: []`, `career_outcomes: []`, totals 0, page size 100 |
| `public.zoho_v3_destination` (AU, localities, page size 5) | Same empty lists; filters echoed |
| Bad filter (`country_code: "AUS"`) | `INVALID_INPUT` |
| Grants | The two v3 wrappers: service role only. Admin functions: signed-in users (rank checked inside), not anon |
| Settings | `destination.page_size_max` 100, `destination.review_list_max` 200, `destination.postcode_primary_min_share` 0.9 |
| Access history | Action check includes `password_reset_sent` |
| G3 guard | 75 functions, 48 tables, no drift. `website_v2_course(text)` `50d22c3c…` and `zoho_v2_course` `6ee09600…` unchanged |
| Edge functions | `website-api-v3` version 3 and `zoho-api-v3` version 2, both deployed by this run |

Not done from this session: a keyed HTTP call to the `destination` action on either endpoint, and a signed-in call of the three Admin functions.

### Evidence

- Isolated PostgreSQL 16 fixture `tests/fixtures/destination-schema-pack/run.sh`: the pack applies twice; 33 checks pass (empty read, approval ranks, postcode rule from the setting, published-edition rules, scheme register, access history).
- Spec `cf-247-rm0-destination-schema-pack-contract`. Three existing specs were widened for the new action and are named in the pull request.

## Decisions G-1 to G-5 approved (17 November 2026)

Platform Admin, 17 November 2026 11:52 AEDT (S1-RM-Design). Detail is in [`DESTINATION-DATA-UI-AND-INGESTION-SPEC.md`](DESTINATION-DATA-UI-AND-INGESTION-SPEC.md) v1.1, section 4. Decisions only; nothing was built.

| # | Approved |
|---|---|
| G-1 | `destination.career_outcomes` holds one row per occupation and area (`national`, `state` or `locality`); the unique key is replaced inside the migration's constraint block. This closes the "career figures by city" limit listed under v1.6 |
| G-2 | Destination data page in the Catalogue menu after Rankings & statistics (`#destination-data`, Curator and above) |
| G-3 | Postcodes below 90% containment go to the Layer 4 Inbox as a new kind, "Campus locality" |
| G-4 | Tabs 1 and 2 of the page are built with the ABS loader (step 1), right after the squash |
| G-5 | `campuses[].locality` on the v3 `provider` action, in the shape of spec section 2.4 |

New schema and ingestion pull requests on Pilot are held until the Platform Admin confirms the squash of Thursday 19 November 2026 is complete; step 0 and step 1 then start at once. From 11:52 AEDT the agent merges green pull requests itself in both repositories.

## Design references

- [Destination roadmap and source workbook reconciliation](../../platform/nz-enrichment-brief/2026-11-11-studysearch-destination-roadmap.md)
- [Accepted database architecture v2.10.50](../../coursefinder-database-architecture-v2.10.50.md) · [Pipeline lineage](../../platform/PIPELINE-LINEAGE.md)
- [Feature acceptance](../../platform/STUDYSEARCH-FEATURE-ACCEPTANCE.md) · [Website developer requirements](../../integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md)
