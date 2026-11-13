# StudySearch roadmap queue — API v3 quick wins and module briefs

**13 November 2026 AEDT · Proposed design and workstream handoff · RM0–RM6**

## Start here

Start **O29 course recognition**, **R33 field dictionary** and the **O38 Australian city population source check** in parallel. O29 can return real AU and NZ records from the existing catalogue. R33 documents the API developers can use today. Australian city population is the smallest useful slice of the destination observations model and has no dependency on opening a new country. Run O28 AU field codes alongside O29 in the same chat. Start a separate study-rules chat on application routes while the city source is qualified. Keep course load with S2-CF, entry with AER, dates with S2-Intakes and awards with S2-Scholarship.

Treat the roadmap queue in this brief as the unresolved R/O/REQ items in the canonical developer register that intersect the six-destination design. No matching Roadmapped issue status was found in the live integration-issue register during this review. Use the existing developer register and feature acceptance plan to own status, implementation links and actual delivery evidence. Module labels below are chat assignments.

### Evidence and release context

- The links supplied resolve to **Operating Model v1.20** and **Developer Requirements v2.23**. The v1.19 scholarship rules and v2.22 requests remain in those documents. v1.20 adds single-owner controls for the shared job runner. [Operating model](../../platform/AGENT-OPERATING-MODEL.md) · [Developer register](../../integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md)
- Website v3 and Zoho v3 are deployed per the newer field definition and Pilot #1107, and both v3 RPC families exist in live metadata. Actual developer cutover was not established. The older Zoho status in the S2-Scholarship and S2-Intakes sections is historical. Zoho v3 scholarship detail/list reuse Website v3 answers; Z1 search summary is already deployed. Zoho provider/reference and sync/export inherited v2 shapes in #1107. Confirm current deployed code and authenticated read-back for each relevant action before marking a request delivered. [v3 field definition](../../integrations/api-v3/API-V3-FIELD-DEFINITION.md) · [Pilot #1107](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1107)
- Draft #1085 was closed. Sections 1–6 of the field definition include its superseded dispatcher, `api_v3` schema, release switch and placeholder-key claims. Check the dated deployment notes and the actual per-action wrappers. New data fields listed in that draft are design candidates until verified.
- On 13 November, the catalogue had **25,380 active AU courses with active CRICOS** and **6,495 active NZ courses with active NZQA course registrations**, all with source and evidence references in this query. These are canonical course counts, not API visibility or licence checks. Registration rows and the course-catalogue counts use different denominators. Of 3,814 active CA courses, 202 had a matching active MTCU course registration in this check. The Canadian provider register holds DLI records at provider grain. Scope their publication separately from programme PGWP eligibility.
- The same live check found ASCED-shaped primary field codes on **25,380 AU**, **3,790 CA** and **6,301 NZ** active courses. Only release AU ASCED entries in the first O28 slice and confirm the asserted scheme and classification grain per row. The CA and NZ codes are not evidence of native CIP or NZSCED assignments. No `destination` tables were present in the targeted metadata check. The destination design therefore remains proposed.

## Prioritised backlog and ownership

Indicative engineering hours cover the stated first release scope, targeted tests and the module handoff. Shared v3 integration is counted separately and only once. Source clearance, specialist review and external data fees can extend delivery. This package overlaps RM0–RM6 and is not additional roadmap funding by default.

| Priority | Start or route to | First outcome | Request / milestone | Eng h | Prerequisite |
|---|---|---|---|---:|---|
| 1 | **RM-Recognition** | Source-backed AU CRICOS and NZ NZQA course recognition. AU ASCED field codes as a second small change. | O29, O28 · RM1/RM4 | 16–28 | Existing data; confirm source licence, validity and actual API visibility |
| 1 | **RM-v3-Dictionary** | Developer field dictionary and executable examples against current Website and Zoho shapes, including v3 sync/export exceptions | R33 / REQ-76 · RM0 | 8–14 | Verify deployed contract and examples. No migration. |
| 1 | **RM-Cities** | One official Australian city population edition for selected campus cities | O38 / REQ-67–68 · RM1 | 16–28 | Verify dataset rights, population basis and locality mapping before publication |
| 2 | **RM-Study-Rules** | First official AU application-route facts or central portal references; UK/CA routes where course/provider applicability is proven | O23 · RM0–RM3 | 18–30 | Same owner as future O27; verify authority and publishing rights |
| 2 | **RM-Campuses** | Repair NZ/CA course-campus geography where evidence exists; design the AU primary-campus flag separately | REQ-58/81, R32 / REQ-75 · RM1/RM2/RM4 | 12–24 for geography; 10–18 for R32 | Confirm S2-CF handoff; D-4 remains open for primary-campus policy |
| 2 | **S2-CF** | Source-backed study load on a bounded set of verified courses; O17 teaching language if explicit data exists | O25 / REQ-52, O17 · RM1–RM4 | 16–28 | Existing owner; no second course enrichment chat |
| 3 | **RM-Careers** | Import one licensed AU JSA edition, first as a scoped observation set | O38 / REQ-68 and roadmap · RM1 | 18–32 | Confirm permitted use and the exact edition, metric and geography grain |
| 3 | **RM-Accreditations** | Scoped AACSB, EQUIS and AMBA claims with verified school/programme identity | R30 / REQ-57 · RM1–RM6 | 18–32 | D-3 and publisher rights. Design can run in parallel. |
| Shared | **Integration Controller** | Review each module's contract, compose shared v3 wrappers and verify per-consumer fixtures and release | RM0 / F-OPS | 12–22 | One owner of wrappers, migration allocation and shared runner |

Recommended first package: recognition, dictionary, city population and shared integration, **52–92 engineering hours**. Ship recognition and the dictionary independently of any open city dataset decision. Estimates for the first package exclude subsequent recognition schemes, bulk course enrichment and new-country catalogue releases.

## Module briefs

### RM-Recognition — course recognition and classification

**Own:** Read-only recognition/classification projection, its tests and the O28/O29 design. Registration ingestion and lifecycle stay with F-DISC/L1. Provider campus identity stays with its existing owner.

| Slice | Canonical model and fields | v3 contract and proof |
|---|---|---|
| O29, AU then NZ | Reuse `catalogue.course_registrations` (`course_id`, `scheme`, `registration_code`, `country_id`, `status`, `valid_from`, `valid_to`, `source_id`, `evidence_id`). Join authoritative public source via `pipeline.sources` or a verified register record. Filter by active course, applicable country, effective registration and the existing consumer visibility function. | Course detail `recognition[]` with `{scheme,status,source_url}` per field definition. Start with confirmed active listings, preserve existing IDs, use a stable scheme vocabulary and include only public links. Known registration withdrawal removes the assertion. Unknown source/scope returns no assertion, never a negative recognition claim. |
| O28, AU ASCED | Reuse `catalogue.courses.primary_field_id → ref.fields_of_study`. Verify provenance and whether the code is a broad/narrow/detailed classification. Keep its digit string including leading zeros. | Course detail `field_of_study_codes[]` with `{scheme,code}`. Output `ASCED` only where the catalogue code and provenance support it. Preserve existing `study_area` semantics. Test source-native codes versus inferred classifications. |
| O28, later native schemes | Check `ref.external_study_areas` and `ref.external_study_area_mappings` for scheme definitions. If no course-level native assignment exists, propose `catalogue.course_classification_assignments`: course, optional campus/offering scope, scheme, edition, code, effective dates, source/evidence and status. Unique on entity grain + scheme/edition/code/version. | CIP/NZSCED are source-backed native assignments. A crosswalk can aid discovery, with evidence and method. A crosswalk never makes a legal eligibility decision. Keep NZQF qualification level distinct from NZSCED field. |
| O29, CA and new countries | Reuse provider registrations for DLI and course registrations for actual programme evidence. Separate authority and grain for sponsor, licence, accreditation and programme eligibility. | Provider-level DLI does not imply course PGWP. Recognise new programme schemes only when the new country adapter proves the applicable grain. No country-wide inference. |

**Mechanism:** Set-based projection over the IDs returned by a bounded API page or detail call, using valid source mappings. Start with detail and no new filters. Test withdrawn, unknown, wrong-country, inactive, hidden and multi-scheme cases, plus Website and Zoho parity independently. Show the registration scheme, verified source and missing/held reason in existing Course Detail and Data Delivery. Extend list/sync only against a defined consumer need and verified delta behaviour.

### RM-v3-Dictionary — consumer handoff

**Own:** R33 developer pack and contract fixture catalogue. No database change. Trace the deployed action→key→type→null/empty meaning, units, allowed values, filters, pagination and supported sync/export fields. Reconcile the latest deployed notes and older addenda for R23, R24, R28, R29, R31, O20/O22/O26 and Z1/Z4. Capture separate Website and Zoho examples, including R29 page 2, unknown nationality, intake status and stable scholarship IDs. Record authenticated verification or the exact unresolved consumer status. Keep internal ops details out of the external pack. The Integration Controller owns shared API code, actual developer notifications and cutover.

### RM-Cities — localities and observations

**Own:** Proposed `destination.locality`, `destination.campus_locality`, `destination.city_observation` and shared `destination.dataset_edition` model. RM-Careers consumes the edition contract. Match campus to an explicit official statistical geography and store the native geographic code, geography type, edition and evidence. Keep a boundary vintage and population period. Capture population count, publisher, measure unit, geography, value, reference period, published/revised date, method and source. Reuse `pipeline.city_regions`, `catalogue.campuses` and `ref.subdivisions` where they can prove the mapping. Use ABS population tables for the exact intended geography and verified source reuse terms.

**Mechanism:** Register the source/edition, stage the official file, validate schema and units, confirm exact campus-city mappings and publish a single permitted Australian edition. Unique observation grain: dataset edition + locality + metric + source-period + population scope. Replays use native row IDs and content hash. Future climate observations add station/baseline/period. Future student costs add basket, low/high, currency, billing interval, population and method. Visa maintenance/funds remain a Study rules fact. Do not publish a city population figure for a different metropolitan/geographic unit. Expose country/city and per-measure provenance through the destination v3 action proposed below. Show source, edition and hold reason in existing Reference data/Data Delivery. [ABS regional population](https://www.abs.gov.au/statistics/people/population/regional-population)

### RM-Study-Rules — application routes first, policy later

**Own:** Proposed `destination.policy_rule` and `destination.policy_version` from the existing design. Use a policy topic for application route, with route code, public portal URL, scope (country, provider, course, study level and audience as applicable), validity window, evidence, last checked and confirmed limited-places flag where held. Introduce a typed target relation only if repeated explicit provider/course bindings require it. One stable rule and versioned scope variant per authority/jurisdiction/route; concurrent current versions of the same exact variant are invalid. Source official portals and programme pages.

**Mechanism:** Release country-level official route references where verified. Course detail `application_route {route,url,limited_places}` is optional and only populated when the course is demonstrably covered. A route can be one of several applicant pathways; use a country reference for alternatives until a course contract can express them accurately. `limited_places` is tri-state. S2-Intakes owns application deadline dates; AER owns applicant entry conditions/tests. Keep visa charges, funds, dependants and work separate within the existing effective-dated policy model. O27 remains later: prove authority, effective date basis, scheme and course conditions including native field, level, delivery/campus and applicant facts where required. A simple months field is safe only for a proven unconditional fact at the stated scope. Conditional route information belongs at destination level until the course contract can express the caveats. No student eligibility verdicts.

### RM-Campuses — geography and primary campus

**Own:** Campus-side identity and geography reconciliation after S2-CF confirms ownership split. Use the existing `catalogue.course_campuses` join and `catalogue.campuses.subdivision_id`. Where course records genuinely span campuses, retain all supported subdivisions. Resolve partial NZ/CA campus data in the existing pipeline and compare actual Website and Zoho course outputs before proposing a new shape. Headquarters alone cannot fill the course subdivision. Keep R23's already deployed campus names/counts.

**After D-4:** Propose a provider primary-campus assertion with provider/campus FK, source/evidence, basis, validity, selection actor and override/lock. Enforce same-provider campus and at most one current designation. A unique headquarters match is a proposal under the approved rule; validate explicit official main-campus evidence and leave ties unresolved. Course-campus `is_primary` is a different grain. Return provider `campuses[].is_primary` and `primary_basis` only at the approved contract boundary. Use `null` when a primary decision is unknown. Verify the remaining REQ-81 street address and international scope separately.

### S2-CF and AER — existing course owners

**S2-CF:** Implement O25 against the current course-source, identity and admission path. Store source-grounded study load at course/offering and audience grain. Use an additive typed field only where the existing offering model can carry scope and provenance. If multiple variants need representation, propose a small course offering facts relation keyed by course, campus/variant, audience, valid dates and field type, with source/evidence. Expose `study_load` as `full_time`, `part_time`, `both` or `null`. Emit `both` only when both loads are proven in the returned scope. Record delivery mode independently. For O17 reuse `ref.languages`; explicit multilingual cases need a scoped contract decision before flattening to the singular planned field. Use existing Course Catalogue/Detail and Data Delivery.

**AER:** Own O18/O19/O21 and related language test/waiver requirements. Verify reuse of course entry and qualifications before adding typed tests, score scales or condition scopes. O20/O22 already shipped on Website v3. Keep current S2-Intakes and S2-Scholarship admission, recovery and v3 field work in those sessions. F-SCH.05/.06/.07 already define long-page recovery, controlled same-ID restoration and real cross-consumer acceptance. Read admitted award facts where needed. [Feature acceptance](../../platform/STUDYSEARCH-FEATURE-ACCEPTANCE.md) · [Quick Start](../../platform/nz-enrichment-brief/INDEX.md)

### RM-Careers and RM-Accreditations — independent designs

**Careers:** Reuse the dataset registry and edition candidate workflow. Consume RM-Cities' shared edition key. Own native occupation/industry/geography dimensions, optional evidenced crosswalks and `destination.labour_observation`. One licensed AU edition first. Persist native code, metric, geography, period, population, unit, source and actual/estimate/forecast flag. Use bounded bulk file imports and a staged count/coverage comparison. Immigration occupation lists stay with RM-Study-Rules. Keep the consumer claim and coverage scope explicit and record publication rights against REQ-68. [JSA data](https://www.jobsandskills.gov.au/data)

**Accreditations:** Own the R30/D-3 design only until the decision and rights are verified. Propose an assertion with canonical provider plus school/programme scope, accreditor, original accreditation type, validity, public source and evidence. Prove the affiliation and exact accredited entity before showing `accreditations[]` on provider detail. Triple Crown requires three independently proven grants that apply to the same school at the same time. Never convert missing school or programme matches to a negative claim. Use Provider Detail and existing evidence workflow.

## Shared integration and acceptance

| Boundary | Implementation rule |
|---|---|
| Course/provider fields | Use current v3 action wrappers, stable IDs and existing visibility checks. Detail first for recognition, codes and optional route; R32 and R30 on provider detail when authorised. Validate the live return shape and obtain fixture parity in each affected consumer. |
| New destination data | Proposed additive `destination` action in the existing v3 endpoint. Use `country_code`, `module`, bounded `page_size` and optional cursor. Return revision, `as_of`, items, source links and `next_cursor`. Validate enums and scopes, pin the cursor to revision and use a single set-based internal read. First module `cities`, then `study_rules` and `careers` only when scoped. Website first if it is the only consumer requesting a destination payload. Add Zoho only for a confirmed use and under its own consumer rules. |
| Null and empty | For a scalar use `null` where the requested scope has no admitted value. An array with no admitted assertions can be empty, with coverage/unknown available in operator views. Empty never asserts legal absence. The developer pack states the actual adopted convention and supported statuses. Exclude draft, expired, withdrawn and non-redistributable records. |
| Sync and export | Define per field whether detail, list/search, sync or export are required. A detail-only increment must be documented as such. For any new field expected in delta sync, verify stable cursor replay, change events on updates from child tables, and withdrawals. In Zoho, treat existing v2-shaped sync/export as a separate integration slice, never as automatic parity. |
| Database and security | Keep proposed destination tables in the internal schema. Use existing server/RPC grants and source/evidence links. Verify same-grain keys, validity, source ownership and private evidence access. Keep API reads bounded and independent of parsing, crawling, settlement and vendor requests. [Supabase custom schemas](https://supabase.com/docs/guides/api/using-custom-schemas) |
| Parallel ownership | Module chats own their facts, fixtures and bounded projection helper. The Integration Controller owns both v3 edge action lists, shared wrappers, shared UI merges, migration numbers and runner-wide settings. Share fixture contracts early. Review related open PRs before edits. No module changes global `batch.admin_jobs` or cross-lane settings as a local fix. |
| Release authority | Recheck actual consumer cutover before integration. Use Decision 277's Website-only pre-go-live additive exception where it applies. Follow the standing consumer comms, baseline and G3 rules for Zoho or frozen surfaces. Keep v2 contract evidence green. D-3/D-4, data rights, vendor spending and consumer cutover follow their existing decision routes. |
| Completion | Report source-backed canonical gain, eligible/held denominator, signed-in Admin visibility, verified Website and Zoho actions as applicable and developer documentation. For ongoing refreshes prove two unattended cycles plus replay, a correction and withdrawal. Pure read projections prove canonical/API parity and exclusion of inactive, hidden or withdrawn rows. Record implementation in the existing F-subtask, developer register and Execution Register. |

## Copy into each new Claude chat

```text
Own only [MODULE NAME] in StudySearch. Read the current operating model,
Admin Quick Start and your module brief in docs/Roadmap/2026-01/V3-QUICK-WINS-MODULES.md.
Reconcile the listed R/O/REQ IDs with current main, the existing F-subtask,
open PRs and targeted read-only live evidence. Start with the first bounded
deliverable. Produce the database reuse/gap, exact keys and field types,
source/evidence and lifecycle rules, v3 action contract, Admin acceptance,
targeted tests and rollback. Record existing-object ownership and send the
fixture/projection interface to the Integration Controller before touching
shared code. Implement authorised module work on its own branch. Keep shared
API wrappers, migration ordering and runner settings with the integrator.
Report actual canonical and consumer results by action, or the exact remaining
dependency. Use existing request and execution records.
```

**Start now:** `RM-Recognition`, `RM-v3-Dictionary`, `RM-Cities`. Run `RM-Study-Rules` next or in parallel if another engineer is available. Pass the O25 and NZ/CA campus handoff to the existing S2-CF chat. Prepare D-3/D-4 design work while the decisions remain open. Begin UK, Ireland and USA catalogue adapters under their original RM milestones, without making them prerequisites for AU/NZ quick wins.

### References

- [Production destination data design](DESTINATION-DATA-DESIGN.md)
- [Consumer request register](../../integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md) · [Request CSV](../../integrations/CONSUMER-REQUESTS.csv)
- [API v3 field definition](../../integrations/api-v3/API-V3-FIELD-DEFINITION.md) · [Website v3 implementation](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/supabase/functions/website-api-v3/index.ts) · [Zoho v3 implementation](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/supabase/functions/zoho-api-v3/index.ts)
- [Course API gap review](../../integrations/2026-11-12-destination-sources-course-api-gap-review.md) · [AER API gap review](../../integrations/2026-11-12-destination-sources-aer-api-gap-review.md)
- [Operating model](../../platform/AGENT-OPERATING-MODEL.md) · [Feature acceptance](../../platform/STUDYSEARCH-FEATURE-ACCEPTANCE.md) · [Admin Quick Start](../../platform/nz-enrichment-brief/INDEX.md)
