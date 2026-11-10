# Study Square — 28-Destination Data Aggregation and API Handover

**Record date:** 10 November 2026, Australia/Melbourne  
**Status:** Scoped and mapped; **planning baseline, not approved new consumer API or deployed destination data**  
**Accountable platform:** StudySearch / CourseFinder  
**Website delivery:** Website developer / Study Square team, **outside the StudySearch deliverable**  
**Stakeholder target:** 2027 intake readiness, 28–30 December 2026 website launch. First-week-of-December destination page handover, SSQ vetting in December. These are stakeholder targets, not guaranteed data availability.

## 1. Scope decision — data/API only, not website development

StudySearch must (1) catalogue the requested data fields, (2) reuse existing canonical provider/course/fee/English/AER/intake/scholarship data, (3) acquire and validate missing country-specific primary-source facts, (4) serve **versioned, documented, authenticated read-only consumer APIs**, and (5) support data defect correction and production API operations. Study Square website developers own page design, CMS, navigation, markup, content presentation, deployment and website release.

**Do not create a second course catalogue or confuse an existing schema with populated, source-validated, API-visible data.** Separate stable source records, current canonical values, publication gates, API projections, and external API HTTP. A public response must not expose unconfirmed or unsupported facts. Missing values must be distinguishable from not applicable, pending SSQ decision, unpublished, stale and genuinely unavailable.

## 2. Authoritative reference documents / provenance

1. Stakeholder source workbook: **Study-Square-destination-data-sources (1).xlsx**, SHA-256 **5829c49ee63480fb763736b20accbdc8ce304c41283b308ba38ae5f80e42a0bc**, as supplied 10 Nov. Country sheets are the **official-source directory**; **Country overview** is comparison-only and never the source for a published claim; **Still to confirm** entries must remain withheld until resolved; **Source check** needs named review/ownership reconciliation.
2. Derived working mapping workbook: **StudySquare_StudySearch_API_Field_Mapping_2026-11-10.xlsx**, SHA-256 **d6dd4cf7f2aceaff442b99ca8c56d49e9690ee92030c635302fc2e3f0e34a424**. Contains **Overview, API Actions, Field Mapping (886 source requirement rows), Country Summary, Confirmations (69), Delivery Gates, Domain Summary**. Source workbook and working XLSX were conversation artifacts, **not embedded in this Git documentation commit**; the controller must locate the exact named/hash-pinned artifacts and commit a reviewed CSV/XLSX source snapshot if persistent row-level reuse is required. Do not claim all 886 row-level mapping values are already in this repo.
3. Governance: [Agent Operating Model](../AGENT-OPERATING-MODEL.md), [Feature Acceptance](../STUDYSEARCH-FEATURE-ACCEPTANCE.md), [Execution Register](../STUDYSEARCH-EXECUTION-REGISTER.md), [Programme Status](../STUDYSEARCH-PROGRAMME-STATUS.md), [Pipeline Lineage](../PIPELINE-LINEAGE.md), and applicable G1–G4/consumer approvals. General reuse pattern: [shared source-to-published enrichment design, Admin PR #400](https://github.com/msinghbs-ai/coursefinder-admin/pull/400) (its merge status must be checked; not authority for new country policy auto-publication).
4. Production evidence snapshot (read only), 10 November ~20:01 AEDT: project **fxcwkweaxjtknorudmwp**; counts below are dated and not necessarily current at revisit.

## 3. Workbook inventory and status — no blanket completeness claim

| Workbook state | Count | Interpretation |
|---|---:|---|
| Destination sheets | 28 | AU, Canada, UK, NZ, Ireland, USA, Germany, Sweden, Finland, Denmark, Spain, Malta, Netherlands, France, Austria, Switzerland, Poland, Hungary, Italy, Greece, Latvia, Cyprus, Dubai (UAE), Thailand, Singapore, Malaysia, South Korea, Japan |
| Data requirements | 886 | Country-sheet source/field rows; not necessarily 886 distinct database columns |
| Loaded | 31 | Australia workbook label; verify actual source database and current output |
| In prototype Supabase | 37 | Canada workbook label; **not proof of StudySearch production** |
| To load | 518 | Not yet recorded as delivered |
| To add | 256 | New or expanded data/fact work |
| Not available | 44 | Require source/exception resolution |
| Outstanding confirmations | 69 | Includes 8 high-priority; no publication until evidence/SSQ approval |
| Linked source references | 974 | Links may repeat |
| Distinct source URLs | 677 | Each must be authority/rights/effective-date checked before use |
| No usable source URL | 40 | Needs clarification, source discovery or withheld value |

**Country-level reconciliation:** [28-destination country counts CSV](2026-11-10-country-requirements-baseline.csv) records 66 country-specific confirmation items plus **3 cross-cutting `All countries` confirmations** = 69 total; do not incorrectly add 69 to the country rows. The CSV is a durable summary, not the 886-row field mapping.\n\n**Source-rule invariants:** Only applicable authoritative government/statutory/public programme or institution pages. Search/AI summaries are *discovery pointers*, not facts. Verify year (especially 2027), student audience/residency, country/region, effective and expiry dates, source URL and stored evidence. Check rights for proprietary rankings/survey/career content; QILT is not automatically licensed for redistribution. No AI-filled visa/work-rights guesses, invented intakes, forced values for "Still to confirm", or unsupported flight estimates.

## 4. Existing StudySearch data and reuse boundary (dated snapshot)

| Entity/field | Observed StudySearch data | What can be promised |
|---|---:|---|
| Providers | 3,103; descriptions 1,299; provider websites 2,324 | Existing AU/NZ/CA catalogue; field-level/source/HTTP still partial |
| Active courses | 35,689; descriptions 764 | Course search exists, but descriptions are sparsely populated |
| Active intake rows | 31,838; 1,855 exact start dates; 106 application deadlines | Many are legitimately month-only; **do not** infer every row needs a date |
| Course fees | 92,063 active rows across 29,146 courses | Reuse only correct currency/year/basis/campus/audience + verified consumer projection |
| English requirements | 30,591 active rows across 21,167 courses | Field present; coverage and student audience vary |
| Course AER / provider matrix | 1,304 / 663 active rows | Review/identity gates still apply; no fabricated equivalences |
| Active scholarship records | 1,570, with 1,149 published | Serve only eligible published records; verify year/amount/audience |
| Rankings and provider outcomes | 0 / 0 active | Structures/API may exist; **data is not populated** |
| Official course links | 31,567 active links | Link integrity/current identity still needs verification |

The three existing StudySearch countries are **Australia, New Zealand and Canada**. The workbook's Australian *Loaded* and Canadian *prototype* data may reside in different stores; reconcile before claiming these are available in the live StudySearch API. The other 25 destinations are not established production course catalogues.

**Baseline only.** On revisit, compare to the latest timestamped production read, deployed versions, HTTP and SSQ approvals. The platform's new provider/course admissions may have progressed since this snapshot.

## 5. Field/domain-to-API reuse plan

| Field/domain | Workbook requirements | Delivery path |
|---|---:|---|
| Provider directory | 45 | Existing Website API v2 **providers/provider** for supported countries; onboard other countries only with verified registers |
| Courses/programmes | 72 | Existing Website API v2 **search/course**, AU/NZ/CA partial |
| Scholarships | 37 | Existing Website API v2 **scholarships/scholarship**, currently published subset |
| Rankings | 28 | Existing Website API v2 **rankings**; no populated production records; rights verification |
| University attributes | 9 | Reuse core provider fields; evaluate extras |
| Language/admissions tests | 28 | Course-specific existing fields + new country-level policy facts |
| University outcomes | 54 | Existing gated data structure, zero active; licensing + data admission required |
| Visa/application/financial policy | 153 | **Proposed** destination policy dataset + API |
| Work-in-study/cost rules | 71 | **Proposed** country/region policy facts + API |
| Post-study work/residence | 43 | **Proposed** destination policy facts + API |
| Course-to-policy eligibility | 34 | **Proposed** course+policy binding/eligibility facts; no generic country-wide assumption |
| Institution quality/accreditation | 96 | **Proposed**, source/rights review |
| Careers/labour statistics | 101 | **Proposed** country/occupation/year statistics |
| City, climate and living costs | 88 | **Proposed** region/city/year facts |
| Arrival guidance | 1 | **Proposed** official guidance fact |
| Flight/travel estimates | 26 | **Defer/omit** without applicable approved official sources |
| **Total** | **886** | Counts classify requirements, not completed data or 886 API properties |

## 6. Consumer interface — what exists vs what needs G3 approval

Pilot Website API v2 code (inspect current deployed release before contracting) implements authenticated **POST** actions:
- **reference**: available lookup/filter options
- **providers / provider**: provider list/detail
- **search / course**: course list/detail; exact course identifiers and optional prior-education country on detail
- **scholarships / scholarship**: published scholarships
- **rankings**: action exists, data currently empty
- **sync**: paginated full/delta change stream

Current implementation is in **Coursefinder-Pilot/supabase/functions/website-api-v2/index.ts**; signed consumer HTTP tests were **not** performed as part of this mapping. Preserve rate limits, API keys, paging, compatibility and publication rules. Do not expose raw Supabase tables to the website developer. Keep Zoho unchanged absent a separate specific contract decision.

**Candidate, NOT BUILT/APPROVED:** separately versioned **destination-data-v1**:
- **destinations** — list of all 28 names/codes and **per-section availability**, not a claim that policy facts exist;
- **destination** — typed country policy/guidance facts (visa, work, dependants, financial, living, careers, application, tests, year, audience);
- **destination_sources** — source URL, publisher, evidence hash, checked/captured/effective/expiry dates, rights and SSQ approval/publication state;
- **destination_changes** — versioned delta/withdrawal cursor so consumer caches update safely.

Agree and obtain protected **G3** approval on exact new URL/action/JSON contract, auth scope, rate limits, stable identifiers, optional vs required keys, null vs not-applicable vs pending/withheld, locales, versioning, paging, cache/ETag or delta behaviour, error semantics and backwards compatibility **before** building an external API. Where a public response cannot expose private reviewer information, expose a safe reason/status only.

**Common fact envelope (conceptual, not a shipped schema):** country (ISO or explicit destination marker such as Dubai/UAE), topic/field ID, typed value/unit/currency, audience/eligibility, effective year/date, official source URL/publisher, evidence ID/hash, captured/verified timestamps, SSQ reviewer status, lifecycle/publication status, applicable country/city/course, and next-recheck/staleness. Withhold unapproved values; expose useful availability metadata instead of fabricated content.

## 7. Developer handover acceptance

The **StudySearch deliverable** is a reliable consumer integration package:
1. Machine-readable schema/data dictionary for every actually supported action, exact endpoint/version, request/response examples and authenticated staging/production access method (never secrets in Git).
2. Field-level and country/section-level **available/partial/held/unavailable/not-served** matrix with last verified time and source, distinguishing workbook *Loaded* from real API data.
3. Pagination, filtering, throttling, error codes, cache/sync contract and backward-compatibility commitments.
4. 2027-oriented validation on fees, scholarships, intakes, language tests and eligibility — no fabricated dates or values.
5. Official-source and SSQ decision traceability, rights rules, withheld values and changes/withdrawals.
6. Positive and negative tests with **live authenticated HTTP**, canonical vs projection vs API parity, 404/empty/withheld/non-served tests, error/rate-limit/retry tests.
7. Named support/defect owner and operational reporting during December website integration.

The website team is solely responsible for pages, layouts, CMS, display decisions, SEO, forms and website deployment. The website must not independently fabricate values missing from the API.

## 8. Proposed milestones — planning gates, not release promises

| Target | StudySearch data/API deliverable | Acceptance and dependency |
|---|---|---|
| **14 Nov** | Final field-to-source/API mapping; 69 confirmation holds and source rights triaged | Data owner signs scope; baseline already drafted, pending verification |
| **20 Nov** | Contract agreement with website developer | Exact Website v2 shape verified; any proposed destination-data-v1 G3 change approved separately |
| **27 Nov** | Existing AU/NZ/CA consumer data acceptance | Verified representative 2027 canonical-to-external-HTTP parity and honest gaps |
| **4 Dec** | Initial **verified subset** of destination policy facts; country/section availability for 28 | No claim of 28-country completeness; source/SSQ and G3 gates |
| **7 Dec** | API developer handover | Documentation, credentials process, sample responses, field dictionary and exceptions |
| **7–21 Dec** | Source/data vetting and corrections | SSQ approval and withheld/published audit by field |
| **23 Dec** | Data API production readiness | External read-only HTTP acceptance, monitoring and rollback; no critical correctness defects |
| **28–30 Dec** | API-side launch support | Monitoring, consumer sync and data fixes — **not website launch ownership** |
| **After launch** | Progressive source-backed population for additional countries/fields | Real retained canonical + applicable consumer gains, autonomous cycles where authorised |

**Capacity warning:** The core platform is still resolving provider descriptions, course-description machine admission, intakes, AER and autonomous planner reliability. Do not promise 886 populated fields or complete 25 new country course catalogues by 7 December. Prefer a truthful well-defined API with partial availability and SSQ withholding to a fictitious completion percentage. This new Study Square integration must not silently displace already-ranked StudySearch P0 data-delivery work; the responsible controller must reconcile capacity/priorities with the Platform Admin.

## 9. Revisit / next-session checklist

On resumption:
1. Locate this document and the **hash-pinned** source and mapping workbooks. Verify country rows, section names, URLs, source ownership, rights and confirmation holds against the latest workbook version; record changes and their dates rather than silently treating old counts as current.
2. Verify current Pilot main, deployed Website v2 action contracts, auth/rate/paging, project production read-only data and serving scope. Do not infer deployment from repo alone.
3. Determine which of the **886 source requirements** are already satisfied by an actual live API value vs only a table, prototype label or planned endpoint. Record per-field source/evidence, audience, 2027 applicability and SSQ publication status.
4. Reconcile work against existing Admin Execution Register/API G3 approval and controller; do not open another tracker, issue family, data catalogue, scheduler or duplicate platform.
5. Ask developer for a concise **required-fields contract and initial consumer sample**; agree missing-value semantics. Only schedule new ingestion where fields actually needed for the first 28 destination handover lack source-supported values.
6. Use the existing G1–G4 release/QA procedure, update this record's disposition and record the PR, actual deployed API version, first authenticated end-to-end consumer responses and remaining held sources. Keep unconfirmed items withheld.
7. If the full row-level field mapping workbook is not in repo, preserve/recover the exact hashed artifact and submit an appropriate durable reviewed data fixture before that mapping becomes an implementation dependency.

**Current disposition:** **Documented for later delivery planning**. No new destination API, ingestion worker, production table, website action, budget increase or publication approval is claimed.
