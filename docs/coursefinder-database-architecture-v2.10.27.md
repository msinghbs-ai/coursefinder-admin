# CourseFinder Database Architecture v2.10.27

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.26.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 19 August 2026  
**Milestone:** Milestone 1 — canonical data platform

v2.10.27 retains every accepted Provider/Course identity, QILT, PRISMS and Scholarship contract from v2.10.26 and corrects the AU canonical geography and Course enrichment design after live schema/data revalidation.

## 1. Live AU completeness correction

AU Layer 1 CRICOS remains accepted for canonical Provider/Course/Campus identity, but Layer 1 acceptance must not be interpreted as complete enrichment coverage.

Live revalidation on 19 August 2026 confirms:

| Dimension | Live AU state |
|---|---:|
| Canonical Providers | 1,546 |
| Providers with canonical subdivision | 0 |
| Canonical Courses | 26,648 |
| Canonical Campuses | 3,922 |
| Campuses with canonical subdivision | 0 |
| Course-Campus relationships | 47,671 |
| Courses with structured fee rows | 0 |
| Courses with legacy `course_url` populated | 0 |
| Relational Course Links | 0 |
| AU canonical subdivisions in `ref.subdivisions` | 8 |

Therefore:
- Course-Campus relationships are **not missing**; they are already a populated Layer 1 relationship.
- State/Region mapping, structured Fees and Course URLs/Links are current completeness gaps.
- Admin/Search must expose these as missing structured data, not infer or fabricate values.

## 2. AU geography truth contract

### Canonical reference geography

`ref.subdivisions` contains the eight accepted Australian state/territory dimensions using ISO-style codes:

`AU-ACT`, `AU-NSW`, `AU-NT`, `AU-QLD`, `AU-SA`, `AU-TAS`, `AU-VIC`, `AU-WA`.

### Campus geography

CRICOS Location rows publish a State value and are the authoritative Layer 1 source for Campus state/territory geography.

The AU ingestion worker already carries the source State token into the location service contract. The previously accepted service resolver compared source abbreviations such as `NSW` only against canonical `AU-NSW`/full name, causing valid states to remain null.

Migration 053 introduces exact canonical subdivision normalisation through `ref.resolve_subdivision_exact(country_id, source_state)`.

Accepted matches are limited to:
1. exact canonical code, e.g. `AU-NSW`;
2. exact canonical name, e.g. `New South Wales`;
3. exact canonical code suffix, e.g. `NSW` -> `AU-NSW`.

This is deterministic source normalisation, not geographic inference.

**Prohibited:** silently deriving State/Region from city, postcode, address text, Provider name or another nearby Campus.

If the published State token is absent or does not resolve exactly, `subdivision_id` remains null and ingestion reports an unmapped subdivision condition.

### Provider geography

`catalogue.providers.subdivision_id` means the Provider's explicitly published primary/administrative/postal subdivision when an authoritative Provider source supplies it. It does **not** mean every state in which the Provider operates.

A multi-state Provider's operational geography is derived relationally:

`Provider -> Campuses -> Campus subdivision`

The current AU CRICOS Provider adapter only forwards postal city and therefore has not populated Provider subdivision/address/postcode. The Layer 1 AU adapter must be upgraded to pass direct published Provider postal geography where present. No Provider state may be inferred from Campus coverage.

## 3. Course-Campus relationship contract

`catalogue.course_campuses` remains the canonical many-to-many relationship between Course and Campus/Location.

AU currently contains 47,671 such relationships. These remain authoritative Layer 1 CRICOS facts.

This relationship must not be confused with web links/URLs.

Terminology in UI/governance:
- **Locations/Campuses** = `course_campuses` relational geography.
- **Links** = external evidence-backed URLs attached to the Course.

## 4. Course Links relational model

Migration 053 creates `catalogue.course_links` for evidence-backed external Course URLs.

A Course may have multiple links, including examples such as:
- primary/provider Course page;
- international Course page;
- handbook/course guide;
- fees page;
- application page.

Key dimensions:
- `course_id`;
- `link_type`;
- `url`;
- optional audience/locale/label;
- primary flag;
- status and validity period;
- source/evidence/confidence;
- last verification timestamp.

Only one active primary link is allowed per Course.

`catalogue.courses.course_url` remains a compatibility/current-primary convenience field. It is no longer the intended multi-link source of truth. Future projection logic may populate it from the accepted active primary `course_links` row.

Course URLs are **Layer 2 provider/source enrichment**, not CRICOS Layer 1 facts unless a regulatory source explicitly publishes and governs that URL.

## 5. Course Fee model

`catalogue.course_fees` remains the canonical relational Course Fee observation table rather than adding fee columns to `catalogue.courses`.

Existing dimensions already support:
- Course;
- fee year;
- audience;
- fee type;
- exact amount/currency;
- basis/load basis;
- CSP flag where applicable;
- validity period;
- evidence/source/confidence.

Migration 054 hardens this for production Layer 2 replay by adding:
- optional `campus_id` where the authoritative source explicitly publishes campus-specific fees;
- stable source-local `source_fee_key`;
- fee observation lifecycle/status;
- `last_verified_at` and `updated_at`;
- deterministic source identity uniqueness on Course + Source + source fee key.

Fees remain empty for AU until a qualified first-party/authoritative Layer 2 source is ingested.

No fee is inferred from course duration, similar courses, domestic schedules, search snippets or third-party aggregators.

## 6. Layer boundary

### Layer 1 — CRICOS

Owns/reconciles:
- Provider identity and CRICOS registration;
- Course identity and CRICOS registration;
- Campus/Location identity;
- Course-Campus relationships;
- direct CRICOS location geography including State where published;
- direct Provider postal geography only where explicitly present in the accepted source.

### Layer 2 — Provider/authoritative enrichment

Owns/reconciles evidence-backed:
- Course Links/URLs;
- international tuition/other Fees;
- Intakes;
- English requirements;
- descriptions and other provider-published Course facts;
- Scholarships under the separately accepted relational Scholarship contract;
- structured outcomes under accepted Layer 2A contracts.

Layer 2 must map to already accepted canonical Provider/Course identity and must never redefine Course identity from a URL/title alone.

## 7. Layer 2 Course enrichment identity/replay rules

For every fee/link source record:
1. resolve Provider through accepted stable identity;
2. resolve Course through accepted registration/source mapping;
3. preserve source URL/source-native key and evidence;
4. dry-run before APPLY;
5. upsert/reconcile using deterministic source-local keys;
6. never create or merge a canonical Course solely because a page title resembles an existing Course;
7. route ambiguous Course mapping to review;
8. retain historical fee/link observations rather than silently rewriting provenance.

## 8. Admin/PIM implications

Course decision workspace must distinguish:
- `Has Campus/Location` — relational `course_campuses` exists;
- `Has State/Region` — relevant canonical Campus subdivision exists;
- `Has Fee` — accepted structured fee observation exists;
- `Has Course Link` — accepted active `course_links` row exists.

State/Region filters must not suggest AU state coverage is populated while Campus subdivisions remain null.

Provider detail must display separately:
- primary/postal Provider geography;
- operational Campus coverage by State/Region.

Course detail should expose separate related sections/tabs:
- Locations;
- Links;
- Fees;
- Intakes;
- English;
- Scholarships;
- Evidence.

## 9. Search/consumer implications

Search may only expose State/Region when backed by canonical Campus subdivision mapping.

Course comparison/search should use Campus State/Region for location filtering. Provider postal subdivision is not a substitute for Course delivery geography.

Fee filters/sorting must define current fee selection semantics, including audience, fee year, basis and stale/missing behaviour before consumer publication.

Course links shown to consumers must come from accepted active source-backed links, with primary-link selection governed deterministically.

## 10. Applied migrations

- `053_au_geography_course_links_hardening.sql`
  - exact canonical subdivision resolver;
  - corrected Layer 1 location subdivision reconciliation;
  - Provider service contract prepared for direct source geography;
  - `catalogue.course_links` relational domain.
- `054_course_fee_source_identity_hardening.sql`
  - Layer 2 fee source identity/replay/lifecycle hardening.

## 11. Current gate state

The schema/service design correction is applied and verified, but **AU geography population is not yet declared complete**.

Current live records remain unchanged until evidence-backed ingestion/replay occurs:
- Provider subdivision: 0/1,546;
- Campus subdivision: 0/3,922;
- structured fees: 0/26,648 Courses;
- relational Course Links: 0/26,648 Courses.

The next AU completeness gate must:
1. update the AU worker to forward direct Provider postal geography fields;
2. replay bounded CRICOS Location records through the corrected exact subdivision resolver;
3. verify all recognised CRICOS State tokens and report unresolved tokens explicitly;
4. validate no Provider/Course/Campus identity-count regression;
5. qualify first-party Course URL/Fee acquisition sources;
6. dry-run/APPLY/replay Layer 2 Links/Fees with evidence and deterministic identity;
7. update completeness/search projections only after those gates pass.
