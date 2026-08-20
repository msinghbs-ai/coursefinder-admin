# CourseFinder Database Architecture v2.10.37

**Status:** AUTHORITATIVE  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.36.md`

## 1. Version scope

v2.10.37 preserves the accepted AU Layer 1 substrate and extends the accepted Layer 2 Course Facts source set from one Provider source class to two.

Accepted AU Layer 1 remains exactly:

- Providers: 1,546
- active CRICOS Courses: 26,648
- production adapter: `layer1-au-depth-v1.6.0`
- governed Study Level: 26,648 / 26,648
- residual Campus source absence: 34
- unexplained Layer 1 mapping defects: 0

## 2. Layer 2 Course Facts boundary

`M1-L2-AU-COURSE-FACTS` enriches accepted CRICOS Courses only with Provider-owned facts that are current or more granular than the Layer 1 regulatory representation:

- official Course URL;
- current/year-specific international tuition fee;
- intake/application timing;
- English entry requirements.

Layer 2 never redefines Provider or Course identity.

Course resolution must use the published CRICOS Course code or another separately governed stable mapping. Title-only resolution is prohibited.

## 3. Qualified Provider sources

### RMIT University

- source key: `au_rmit_official_course_pages`
- Provider CRICOS: `00122A`
- worker: `coursefacts-au-rmit-v0.2.0`
- qualification: `qualified`
- identity authority: false
- APPLY admitted: true
- Search admitted: false

### The University of Queensland

- source key: `au_uq_official_program_pages`
- Provider CRICOS: `00025B`
- worker: `coursefacts-au-uq-v0.1.0`
- qualification: `qualified`
- identity authority: false
- APPLY admitted: true
- Search admitted: false

UQ is the second independently proven Provider-owned page class. It validates that the relational and evidence contracts are not RMIT-site-specific.

## 4. Canonical relational targets

Provider-owned facts remain in:

- `catalogue.course_links`
- `catalogue.course_fees`
- `catalogue.course_intakes`
- `catalogue.course_english_requirements`
- `pipeline.course_fact_source_records`
- `pipeline.evidence_artifacts`
- `pipeline.course_fact_source_qualifications`

Official Provider URLs remain Layer 2 links and do not overwrite canonical `catalogue.courses.course_url`.

## 5. Fee semantics

Provider-current fees use `fee_type='provider_current_tuition'` and retain:

- fee year;
- audience;
- amount/currency;
- exact published basis;
- source fee key;
- evidence/source snapshot.

Accepted examples now prove multiple published bases:

- RMIT annual;
- RMIT total indicative;
- UQ indicative annual.

These remain semantically separate from CRICOS registered total-course fees. No annualisation or basis conversion is permitted unless explicitly supported by the Provider source.

## 6. Intake semantics

Intakes retain published year, label, start date and application deadline.

Campus scope is populated only where the Provider source proves a Campus-specific fact. No Campus scope may be inferred merely because a page presents a program location.

UQ UAT additionally proves international-only intake selection where domestic and international availability differ on the same source page.

## 7. English requirement semantics

English requirements resolve only to governed `ref.english_tests` values and retain overall/component thresholds and source evidence.

A Provider may publish additional tests that are not yet governed. Those alternatives must remain unpersisted until a governed test mapping exists; they must not be coerced into a different test identity.

The UQ gate therefore persisted IELTS, TOEFL iBT and PTE Academic only, while leaving UQ BE/CES alternatives outside the canonical English-test table.

## 8. Evidence and replay

Each source fetch is SHA-256 captured in private evidence storage.

Replay behaviour is source-sensitive but canonical-idempotent:

- dynamic Provider HTML may legitimately create new evidence versions when source bytes change;
- unchanged source bytes may reuse an existing source record;
- unchanged parsed facts must never duplicate canonical links, fees, intakes or English requirements.

RMIT proves dynamic-byte evidence versioning; UQ proves unchanged-byte source-record reuse.

## 9. Accepted aggregate state

Across the two qualified Provider sources:

- qualified source classes: 2
- exact bounded CRICOS Courses: 4
- official Course links: 4
- provider-current fee observations: 4
- intake observations: 6
- English requirement observations: 14
- canonical Course URL mutations: 0
- CRICOS registered-fee collisions: 0
- ambiguity rejection: PASS for both source classes
- canonical replay idempotency: PASS for both source classes

## 10. Security boundary

Course Facts workers use the one-time Pilot nonce execution model.

`pipeline.svc_pilot_submit_nonce(text,jsonb)` remains:

- `anon`: no EXECUTE
- `authenticated`: no EXECUTE
- `service_role`: EXECUTE

Provider source qualification is required before APPLY. Search admission remains an independent decision.

## 11. Search boundary

Layer 2 source acceptance does not automatically admit enrichment into Search/API/Website.

Verified Search state remains:

- Course Documents: 33,105
- `has_fee=true`: 0
- `has_intake=true`: 0
- `has_english=true`: 0

Search enrichment admission remains a separate governed gate.

## 12. Decision

**v2.10.37 accepted.**

RMIT and UQ are now qualified AU Provider-owned Course Facts source classes. Controlled source and Course coverage expansion may proceed under the same exact-identity, evidence, fee-semantics, intake-scope, English-test governance, replay and Search-isolation contracts without changing the accepted CRICOS substrate.
