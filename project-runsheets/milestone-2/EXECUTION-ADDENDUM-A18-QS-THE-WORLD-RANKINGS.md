# M2 Execution Addendum A18 — QS / THE World University Rankings

**Status:** DESIGN ACCEPTED — IMPLEMENTATION / SOURCE-QUALIFICATION PENDING  
**Date:** 2 September 2026  
**Change Control:** `CF-CHG-20260902-063`  
**Applies to:** M2.5+ Layer 1 authoritative institutional context, Provider details/comparison, Search/API admission and historical trend retention.

## Purpose

Add annual university-ranking observations from the ranking publishers themselves:

- QS World University Rankings: current target editions **2026 and 2027**;
- Times Higher Education (THE) World University Rankings: current target edition **2026**;
- historical backfill target: normally **5–10 editions** where an official publisher page/file remains accessible and the access/licensing terms permit CourseFinder ingestion.

This is Provider/institution context. It is not Course quality, student outcome, regulatory status, accreditation or an eligibility signal.

## Authority classification

QS is authoritative for QS rankings. Times Higher Education is authoritative for THE rankings.

Therefore publisher-issued ranking observations are treated as **Layer 1 authoritative external reference data**. They must not be scraped from Wikipedia, university marketing pages, news summaries or secondary aggregators when the publisher source is available.

This does not redefine the Layer 1 regulatory identity authority for CRICOS/NZQA/etc. Ranking records attach to canonical Providers only after governed institution matching.

## Official source catalogue

### QS

- 2027 current table: https://www.topuniversities.com/world-university-rankings
- 2027 alternate/current landing path observed by QS: https://www.topuniversities.com/qs-top-uni-wur
- 2026 edition: https://www.topuniversities.com/world-university-rankings/2026
- historical edition pattern: https://www.topuniversities.com/world-university-rankings/{YEAR}
- examples confirmed: 2024 and 2023 use the year-specific pattern.
- where QS exposes an authorised Excel download for an edition, prefer the publisher file because it gives a reproducible source artifact.

### Times Higher Education

- 2026 current table: https://www.timeshighereducation.com/world-university-rankings/latest/world-ranking
- 2025: https://www.timeshighereducation.com/world-university-rankings/2025/world-ranking
- 2024: https://www.timeshighereducation.com/world-university-rankings/2024/world-ranking
- historical pattern to qualify: https://www.timeshighereducation.com/world-university-rankings/{YEAR}/world-ranking
- 2026 methodology: https://www.timeshighereducation.com/world-university-rankings/methodology

## Access / licensing rule

Public visibility does not automatically mean unrestricted bulk reuse.

For every edition/profile retain:
- source URL;
- publisher;
- access method;
- retrieval timestamp;
- terms/licensing assessment;
- file/page fingerprint;
- edition/release date;
- correction/revision marker where exposed.

Do not bypass login, registration, bot protection, paywalls or download controls. If an official download requires an account or licence, CourseFinder may use a manually supplied/licensed publisher artifact as Layer 1 Evidence rather than circumventing the control.

## Canonical grain

One ranking observation is:

`ranking_system + ranking_type + edition_year + publisher_institution_identity`.

Canonical Provider mapping is separate and nullable until resolved.

Do not flatten the observation to `provider.world_rank`; QS and THE are independent series and historic values must coexist.

## Required fields

Ranking edition:
- system code: `qs_wur` / `the_wur`;
- edition year;
- publication/release date where known;
- methodology/version URL;
- source table/file URL;
- correction/version label;
- retrieved_at;
- source fingerprint;
- licensing/access status.

Ranking observation:
- edition FK;
- publisher institution name;
- publisher institution/source ID or stable profile URL where available;
- source country/location text;
- exact rank where supplied;
- rank-band lower/upper where the publisher supplies a band;
- displayed rank text preserved verbatim as source representation;
- overall score where published;
- component/pillar scores as typed observations, not arbitrary columns;
- canonical Provider FK when matched;
- mapping method/confidence/status;
- Evidence/source row reference;
- source row payload for replay/audit.

## Rank semantics

Preserve:
- exact rank;
- tied rank;
- banded rank such as 201–250;
- reporter/unranked/not-eligible states;
- missing score.

Never manufacture an exact numeric rank from a band and never treat reporter status as a numeric rank.

## Historical backfill

Target window:
- QS: 2027 backwards, preferably through 2018 where source access is defensible;
- THE: 2026 backwards, preferably through 2017 where source access is defensible.

The adapter must discover/qualify each edition rather than assuming identical markup or methodology.

Historical trend comparisons must expose methodology breaks. A movement across a methodology change is descriptive only and must not be presented as a like-for-like performance delta without the methodology context.

## Matching to CourseFinder Providers

Priority:
1. stable publisher institution identifier/profile URL mapped through an explicit crosswalk;
2. exact canonical/legal name + country;
3. accepted alias + country;
4. deterministic normalisation with unique candidate;
5. otherwise unresolved candidate for Layer 4 review.

Never merge two canonical Providers because the publisher presents a university system/brand differently.

Store mapping history so a later correction does not destroy the publisher source row.

## Layer 1 ingestion mechanism

Normal flow:

`source registration → licence/access qualification → edition discovery → publisher page/file acquisition → immutable Evidence → parse/normalise source rows → idempotent edition apply → Provider mapping → reconciliation → contextual read projection`.

Controls:
- publisher profile is environment-gated;
- edition fingerprint prevents duplicate apply;
- corrections create a new source version/retrieval, not silent overwrite;
- raw/unmatched institutions are retained for reconciliation;
- ingestion does not create arbitrary CourseFinder Providers;
- Provider rank context does not modify Provider regulatory status;
- annual schedule checks for a new edition and corrections.

## Admin / UI requirements

Provider blade:
- compact QS and THE cards showing latest edition, rank/band and prior-year movement;
- 5-year sparkline/trend where at least two comparable observations exist;
- methodology/source link;
- explicit “not ranked”, “not mapped” or “unavailable” states.

Compare workspace:
- QS row group and THE row group;
- edition selector, default latest common edition;
- rank + overall score when published;
- optional historical trend;
- never compare QS rank directly against THE rank as though they were the same metric.

Course blade:
- may inherit Provider-level ranking context labelled **Provider ranking**;
- must never imply that the Course itself holds the institutional world ranking.

## Consumer boundary

Search/Website/Zoho admission is separate. If approved, expose:
- latest Provider QS rank/band + edition;
- latest Provider THE rank/band + edition;
- optional historical series endpoint.

Do not use ranking as an undisclosed relevance boost. Any ranking-based sort/filter must be explicit to the user.

## Acceptance

Required before implementation PASS:
- current QS 2026 + 2027 and THE 2026 edition qualification;
- at least two historical editions per publisher in Pilot;
- replay/idempotency;
- tied/banded/unranked semantics;
- canonical Provider matching positive and ambiguous cases;
- source correction/versioning;
- Evidence lineage;
- anonymous/role security checks;
- Provider blade and Compare browser UAT;
- performance/payload budgets;
- no Search/Publication admission without a separate acceptance decision.
