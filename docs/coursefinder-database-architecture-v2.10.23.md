# CourseFinder Database Architecture v2.10.23

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.22.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 18 August 2026  
**Milestone:** Milestone 1 — canonical data platform

This version retains the accepted Canada identity/history model and Scholarship relational contract from v2.10.22, while changing the programme execution policy: **country ETL implementation is source-qualified before code is built**. Australia and New Zealand remain the accepted Layer 1 production reference countries. Canada country expansion is paused rather than continuing institution-by-institution adapter generation.

## 1. Milestone 1 canonical principle

CourseFinder is not a collection of source-shaped country databases.

The canonical architecture separates:

`Source Authority -> Source Identity / Evidence / Observations -> Canonical Entity -> Derived Search/API Projection`

The source proves facts. The canonical model owns durable CourseFinder identity and history. Consumer/search models are derived products and never become the source of truth.

### Core rules

- Stable identifiers are authoritative; names and titles are never identity.
- A source row and a canonical entity are different concepts.
- Layer 1 may create Provider/Course identity only from an accepted identity authority.
- Layer 2 enriches accepted canonical entities and cannot redefine Layer 1 identity.
- Layer 3 AI structures evidence or proposes values; it cannot invent regulatory/source identity.
- Layer 4 resolves ambiguity, mappings and conflicts with audit history.
- Search, Website and Zoho consume curated projections, not raw source tables.
- Historical source identities/facts are preserved even when no longer active for publication.

## 2. Source qualification precedes ETL implementation

A country adapter must not be built simply because a public website exists.

A source is accepted for Layer 1 only when all mandatory gates pass:

1. **Authority** — authoritative for the declared CourseFinder product population.
2. **Provider identity** — stable non-name Provider key.
3. **Course identity** — stable non-name Course/Qualification/Programme key.
4. **Population completeness** — complete for the declared product scope, rather than an incidental subset.
5. **Lifecycle/currentness** — current/retired status or reproducible current inventory is available.
6. **Machine acquisition** — deterministic bulk download or bounded repeatable endpoint.
7. **Evidence reproducibility** — complete inventory can be hashed/versioned and retained privately.
8. **Use rights** — machine/product use and redistribution terms are acceptable.
9. **Replay/idempotency** — exact replay must not create duplicate canonical identities.
10. **Location model** — Campus/location relationships are retained where the authority exposes them.

If a mandatory criterion fails, the country remains `source_qualification`, `hold` or `paused`. The default response is **not** to compensate by writing dozens of institution-specific scrapers.

Source matrix: `docs/coursefinder-country-authoritative-source-matrix-v1.0.md`.

## 3. Layer responsibilities

### Layer 1 — canonical identity and regulatory/base truth

Layer 1 owns:
- Provider identity;
- Course/Qualification identity;
- regulator/source registrations;
- source lifecycle/currentness;
- authoritative locations/campuses where supplied;
- source evidence and current inventory hashes.

Layer 1 should remain narrow. Fees, graduate outcomes, student experience, scholarship eligibility and marketing descriptions do not become identity just because they arrive in the same feed.

### Layer 2 — deterministic structured enrichment

Layer 2 attaches evidence-backed facts to existing canonical identities, including:
- QILT outcomes/student experience/employer satisfaction;
- PRISMS international enrolment/commencement observations;
- Education Counts outcomes;
- fees and intakes from accepted structured sources;
- Scholarships and award programmes;
- other country outcome datasets such as Discover Uni/NSS/TEF or College Scorecard where mapping quality is sufficient.

Layer 2 may use a comprehensive statistical dataset even when that dataset is not authoritative enough to create Course identity.

### Layer 3 — AI enrichment

Layer 3 is used only when deterministic parsing cannot reliably express the source fact. Every material value retains evidence, extraction metadata and confidence.

### Layer 4 — human governance

Layer 4 resolves ambiguous identity mappings, conflicting claims, non-machine-evaluable eligibility and publication decisions. Human decisions are auditable and do not overwrite evidence history.

## 4. Canonical Provider model

A canonical Provider is long-lived and can have multiple source/regulatory identities over time.

Identity resolution order:
1. exact accepted stable Provider identifier;
2. governed identifier mapping/association;
3. explicit Layer 4 review;
4. never name-only merge.

Provider display name, website, address and brand are mutable facts.

Accepted examples:
- AU: `AU + cricos + CRICOS Provider Code`.
- NZ: `NZ + nzqa + Education Organisation number`.
- CA preserved identity: `CA + ircc_dli + DLI number`.

Provider lineage and associations remain separate from identity.

## 5. Canonical Course model

A canonical Course is a long-lived academic offering identity anchored to an accepted source-local key under a Provider.

General identity shape:

`Provider + accepted source scheme + stable source-local Course/Qualification identifier`

Course title has zero identity power.

Accepted examples:
- AU: Provider + CRICOS + `CRICOS Course Code`.
- NZ: Provider + NZQA + qualification `Number`.
- CA preserved source-scoped model: Provider + governed provincial/institutional scheme + stable programme identifier.

A changed title, fee, intake or temporary admissions closure updates observations/lifecycle; it does not create a new Course identity unless the authority establishes a new programme identity.

## 6. Source identities, inventories and evidence

CourseFinder must retain enough source state to explain every canonical decision.

Required concepts:
- `integration.systems` — external systems/authorities;
- `pipeline.sources` — configured acquisition source;
- source-native identifiers/registrations;
- private source inventory/staging where needed;
- `pipeline.evidence_artifacts` — immutable evidence lineage;
- captured timestamps and hashes;
- current/previous observation state.

Raw source inventory is not a browser-facing catalogue.

Canonical APPLY occurs only after source records pass identity and scope validation.

## 7. Observations are time-scoped, not identity

Outcome/statistical data should be modelled as observations against canonical entities or accepted dimensions.

Examples:
- graduate employment rate for Provider/study area/year;
- student satisfaction for Provider/study area/year;
- international enrolments for provider/sector/country/month;
- salary/earnings outcome for a field/cohort/year.

An observation must retain:
- source;
- measure/metric code;
- value/unit;
- population/dimension keys;
- period/cohort;
- evidence/version;
- canonical mapping confidence/status where applicable.

This keeps QILT, PRISMS, Education Counts, Discover Uni and similar sources out of Course identity while still making them highly valuable to search/recommendation.

## 8. Scholarship canonical model

The accepted v2.10.22 relational Scholarship architecture remains authoritative.

A Scholarship is a long-lived canonical entity:

`Scholarship -> Source Identifiers -> Offering Cycle -> Application Windows / Scopes / Eligibility / Award Tiers / Coverage`

Rules:
- scholarship title alone is never identity;
- source-native scholarship identifier is preferred;
- annual year/intake does not clone the Scholarship;
- recurring periods create/update Offering Cycles;
- multiple deadlines are Application Windows;
- Course/Provider applicability is modelled independently of student eligibility;
- eligibility retains nested `all` / `any` criteria;
- award amount/percentage and coverage are cycle-aware and evidence-backed;
- closed/superseded cycles remain historical.

Scholarship is Layer 2. It cannot alter Provider/Course identity.

## 9. Accepted Milestone 1 country substrate

### Australia — production reference

Accepted Layer 1 population:
- 1,546 Providers;
- 26,648 Courses;
- authoritative CRICOS Locations/Course Locations available for Campus relationships.

Layer 2 priority:
- QILT;
- PRISMS;
- Study Australia / Australia Awards / RTP Scholarship enrichment.

### New Zealand — accepted second country

Accepted Layer 1 population:
- 409 Providers;
- 6,457 Qualifications/Courses;
- 6,457 Search Documents at country acceptance.

Layer 2 priority:
- Education Counts;
- Study with New Zealand Scholarships.

### Accepted Search substrate

At the 18 August programme reset, the live Search Projection contains **33,105 documents**, exactly:

`AU 26,648 + NZ 6,457 = 33,105`

This is the Milestone 1 accepted consumer substrate.

## 10. Canada — preserved but execution paused

The Canada work remains valid canonical/history work but country expansion is paused.

Live physical state at the programme reset:
- 1,130 Providers;
- 10,253 physical Courses;
- 2,279 active scoped Course rows;
- 7,974 inactive/historical Course rows.

CA is deliberately absent from the accepted Search Projection while its national source strategy remains unresolved.

The architecture retains:
- IRCC DLI Provider identity;
- source-scoped Course identities;
- `pipeline.ca_course_scope_keys`;
- source inventory/staging;
- inactive historical rows/evidence;
- existing BC/Alberta/institutional UAT evidence.

Pause means:
- do not delete/re-key existing CA canonical identities;
- do not continue institution-by-institution ETL under Milestone 1;
- do not publish CA into Search;
- resume only after a materially simpler, source-qualified coverage strategy is accepted.

## 11. Search and publication architecture

Search is a derived acceptance boundary.

Canonical data may exist without being publishable.

A Course enters an accepted Search Projection only when:
- canonical identity is accepted;
- lifecycle/product scope is active;
- country/source gate permits publication;
- required relational mappings are valid;
- no unresolved publication-blocking review exists.

This explains the current state where CA canonical/history data exists but AU+NZ alone form the 33,105-document accepted Search Projection.

Search rebuilds must be idempotent and versioned. Embeddings are regenerated from accepted projection content rather than copied from source/demo caches.

## 12. Admin/PIM implications

Admin should expose the canonical distinction explicitly:

- **Identity** — accepted stable Provider/Course/Scholarship identifiers;
- **Source & Evidence** — authority, captured artifact, version/hash;
- **Lifecycle** — active/inactive/historical/publication state;
- **Structured facts** — fees, intakes, locations, outcomes;
- **Scholarships** — identity, cycles, windows, scopes, eligibility, awards;
- **Review** — conflicts/uncertain mappings;
- **Search status** — projected/not projected and reason.

Admin must not present a source row as if it were automatically canonical/published.

## 13. Security boundary

Unchanged security principles:
- internal schemas are deny-by-default;
- `service_role` is server-side only;
- privileged ingestion RPCs are not browser CRUD surfaces;
- Auth/RBAC gates Platform Admin actions;
- private evidence remains private Storage;
- Layer 2/3 secrets remain Edge/server side;
- evidence access uses governed/signed mechanisms;
- diagnostic/UAT functions are retired or locked after validation.

## 14. Milestone 1 narrative

The Milestone 1 success criterion is **not number of countries**.

Milestone 1 proves that CourseFinder can:
1. ingest comprehensive national regulatory data;
2. create stable canonical Provider/Course identities;
3. preserve provenance/history;
4. enrich the same identities from independent structured outcome and Scholarship sources;
5. govern uncertainty separately;
6. expose a clean accepted Search/API projection;
7. repeat ingestion without duplicates;
8. reset/rebuild and audit the result.

Australia is the reference implementation, New Zealand proves portability, and the Canada experience establishes the governance rule that source fragmentation must be rejected at qualification time rather than absorbed indefinitely as custom ETL complexity.

## 15. Programme execution rule from v2.10.23

- Maintain AU and NZ Layer 1 adapters.
- Prioritise AU/NZ Layer 2 structured enrichment and Scholarships.
- Keep CA frozen and unpublished while preserving all canonical/history data.
- Keep GB, US, DE and IE at source-qualification/HOLD until the Layer 1 gate is proven.
- Permit independent Layer 2 source evaluation for structured outcome/scholarship datasets even when a country has no accepted Layer 1 Course authority.

This architecture is the canonical baseline for the Milestone 1 meeting and subsequent process-specific chats.
