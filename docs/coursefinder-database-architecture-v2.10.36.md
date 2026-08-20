# CourseFinder Database Architecture v2.10.36

**Status:** AUTHORITATIVE  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.35.md`

## 1. Version scope

v2.10.36 preserves the accepted AU Layer 1 substrate and records the first accepted Provider-owned Layer 2 Course Facts source.

Accepted AU Layer 1 remains exactly:

- Providers: 1,546
- active CRICOS Courses: 26,648
- production adapter: `layer1-au-depth-v1.6.0`
- governed Study Level: 26,648 / 26,648
- residual Campus source absence: 34
- unexplained Layer 1 mapping defects: 0

## 2. Layer 2 Course Facts boundary

`M1-L2-AU-COURSE-FACTS` may enrich accepted CRICOS Courses with Provider-owned facts that CRICOS does not authoritatively supply at the required currency/grain:

- official Course URL;
- current/year-specific international tuition fee;
- intake/application timing;
- English entry requirements.

Layer 2 does not redefine Provider or Course identity.

Course resolution must use published CRICOS Course code or another separately governed stable mapping. Title-only resolution is prohibited.

## 3. First accepted source

RMIT University official Course pages are accepted as the first bounded source under source key `au_rmit_official_course_pages`.

Identity contract:

- Provider CRICOS: `00122A`
- Course CRICOS: exact Course registration code
- source qualification: `qualified`
- APPLY: admitted for the qualified bounded source
- Search admission: false
- identity authority: false

## 4. Canonical relational targets

Provider-owned facts are retained in relational observation structures:

- `catalogue.course_links`
- `catalogue.course_fees`
- `catalogue.course_intakes`
- `catalogue.course_english_requirements`
- `pipeline.course_fact_source_records`
- `pipeline.evidence_artifacts`

Official Provider URLs remain Layer 2 links and do not overwrite canonical `catalogue.courses.course_url`.

## 5. Fee semantics

Provider-current fees use `fee_type='provider_current_tuition'` and retain:

- fee year;
- audience;
- amount/currency;
- exact published basis;
- source fee key;
- evidence/source snapshot.

They remain semantically separate from CRICOS registered total-course fees.

No annualisation or basis conversion is permitted unless explicitly supported by the Provider source.

## 6. Intake and English semantics

Intakes retain published year/label/start/application timing and Campus scope when the Provider source proves a Campus-specific fact. Absence of a proven Campus scope must remain null rather than inferred.

English requirements resolve only to governed `ref.english_tests` values and retain overall/component thresholds and source evidence.

## 7. Evidence and replay

Each source fetch is SHA-256 captured in private evidence storage. Dynamic Provider HTML may create different content hashes between observations. This is valid evidence versioning when parsed facts are unchanged.

Canonical idempotency is measured independently: repeated unchanged parsed facts must not duplicate links, fees, intakes or English requirements.

## 8. First-source accepted result

RMIT bounded UAT accepted:

- 2 exact CRICOS Courses
- 2 official links
- 2 provider-current 2027 fee observations
- 3 intake observations
- 8 English requirement observations
- 0 canonical Course URL mutations
- 0 CRICOS fee collisions
- ambiguity rejection: PASS
- canonical replay idempotency: PASS

## 9. Search boundary

Layer 2 acceptance does not automatically admit enrichment into Search/API/Website.

Verified Search state remains:

- Course Documents: 33,105
- `has_fee=true`: 0
- `has_intake=true`: 0
- `has_english=true`: 0

Search enrichment admission remains a separate governed gate.

## 10. Decision

**v2.10.36 accepted.**

The RMIT source is the first accepted AU Provider-owned Course Facts source. Controlled expansion may proceed under the same exact-identity, evidence, fee-semantics, idempotency and ambiguity rules without changing the accepted CRICOS substrate.
