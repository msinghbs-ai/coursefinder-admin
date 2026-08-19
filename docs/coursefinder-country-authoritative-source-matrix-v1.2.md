# CourseFinder Country Authoritative Source Matrix v1.2

**Status:** AUTHORITATIVE SOURCE-QUALIFICATION RECORD  
**Supersedes:** `docs/coursefinder-country-authoritative-source-matrix-v1.1.md`  
**Date:** 19 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.29.md`  
**Purpose:** Milestone 1 source strategy, Layer 1 country qualification and Layer 2 enrichment source qualification  
**Process boundary:** `SRC-QUAL` is research/gate only. No country ETL or adapter implementation is authorised unless the source-qualification decision is `GO`.

## Executive decision

CourseFinder remains **source-qualification-first**.

A country enters Layer 1 adapter design/coding only when the declared CourseFinder product population has an authoritative national source contract that satisfies the mandatory source gate retained from architecture v2.10.23 through the current v2.10.29 baseline.

This v1.2 review adds the Netherlands, Finland and Norway to the future-country qualification record and revalidates Ireland, United Kingdom, United States and Germany.

**New decision:** the **Netherlands is GO for Layer 1 adapter design/coding** against the declared scope of current OCW-recognised Dutch higher-education institutions and programmes. Finland, Ireland, Norway, United Kingdom and United States remain HOLD. Germany remains PAUSE. Canada remains PAUSE with its existing canonical/history work preserved.

`GO` in this document means the **source contract is sufficiently qualified to authorise adapter implementation work**. It does not mean a country has passed CourseFinder production ingestion, Search publication or implementation UAT. Any future NL adapter must still pass bounded dry-run/APPLY/replay/idempotency/integrity/security/performance UAT before production acceptance or Search admission.

## Source qualification gate

A country is `GO` for Layer 1 only when all mandatory criteria are proven sufficiently for the declared product scope:

1. **Authority** — authoritative/national source for the declared CourseFinder product population.
2. **Provider identity** — stable non-name Provider identifier.
3. **Course identity** — stable non-name Course/Qualification/Programme identifier.
4. **Population completeness** — complete target population rather than an incidental subset unless the product scope exactly matches that subset.
5. **Lifecycle/currentness** — current/retired status or reproducible current inventory is available.
6. **Machine acquisition** — deterministic bulk download or bounded repeatable endpoint.
7. **Evidence reproducibility** — complete inventory can be retained, hashed/versioned and reproduced.
8. **Use rights** — machine/product use and redistribution terms are acceptable.
9. **Replay/idempotency feasibility** — stable source identities and deterministic inventories permit exact replay/change detection without title/name identity.
10. **Location model** — Campus/location relationships are retained where the authority exposes them.

Failure of any mandatory item means `HOLD`, `HOLD / QUALIFY` or `PAUSE`. It does **not** trigger institution-by-institution scraper construction as a substitute for national authority.

Layer 2 sources use a separate gate. They may enrich accepted canonical Providers/Courses or create independent Scholarship entities, but cannot redefine Layer 1 identity.

## Current source matrix

| Country | Layer 1 decision | Layer 1 canonical source posture | Structured outcomes / Layer 2A | Scholarship enrichment | Programme position |
|---|---|---|---|---|---|
| Australia | **GO / ACCEPTED** | CRICOS — accepted Provider/Course/Location/Course-Location authority | QILT **PASS**; PRISMS **PASS** | Study Australia **PASS first source**; Australia Awards **PASS**; RTP **BOUNDED** | Primary Milestone 1 country |
| New Zealand | **GO / ACCEPTED** | NZQA Education Organisations + Qualifications | Education Counts queued | Study with New Zealand / provider sources queued | Second accepted country |
| **Netherlands** | **GO / SOURCE QUALIFIED** | DUO RIO + Overzicht Erkenningen HO — national OCW-recognised HE authority with stable Provider/Offering/Location identity, daily machine publication and CC BY reuse | Future qualification only | Future qualification only | **First new future country authorised for adapter design/coding** |
| Finland | **HOLD / QUALIFY** | EDUFI Studyinfo/Kouta/Konfo is highly comprehensive and machine-accessible; explicit catalogue-data product/redistribution rights not yet proven to CourseFinder gate | Strong future candidate | Future qualification only | Close to GO; close rights contract first |
| Ireland | **HOLD / QUALIFY** | QQI IRQ is national qualifications/programmes authority; linked-open-data QDR transfer exists, but supported complete direct machine contract/stable-key/currentness/use-rights path is not yet fully proven | To qualify separately | GOI-IES + provider candidates | High-priority qualification candidate |
| Norway | **HOLD** | HK-dir/Utdanning.no is a strong national catalogue; current production API is documented as internal/unversioned and may change without notice | Strong discovery/enrichment candidate | Future qualification only | Do not authorise Layer 1 adapter yet |
| United Kingdom | **HOLD** | UKVI Provider authority + Discover Uni eligible undergraduate-course dataset; no accepted complete all-level national Course authority | Discover Uni/NSS/Graduate Outcomes/LEO/TEF candidates | UK government programmes / Study UK | Enrichment candidate; no Layer 1 ETL |
| United States | **HOLD** | IPEDS/College Scorecard are strong structured statistical sources but do not provide accepted stable current marketed-programme Course identity | College Scorecard / IPEDS candidates | EducationUSA candidate | Layer 2A first; no Layer 1 ETL |
| Canada | **PAUSE** | IRCC DLI Provider authority accepted; Course authority remains federated/provincial/institutional | Statistics Canada / EduCanada where useful | EduCanada candidate | Preserve existing work; no fragmented M1 expansion |
| Germany | **PAUSE** | Hochschulkompass is comprehensive, but general use is personal-use only and commercial/product use requires HRK approval/cooperation | DAAD / other structured candidates | DAAD Scholarship Database candidate | Partnership/licensing gate before Layer 1 work |

---

## Netherlands — GO / SOURCE QUALIFIED

### Declared Layer 1 scope

Current **OCW-recognised Dutch higher-education institutions and programmes**, using DUO's Registratie Instellingen en Opleidingen (RIO) source family and the higher-education recognition/offer/location relations that RIO publishes.

This is a deliberately governed product scope. It does not silently claim all non-formal/private training products outside the accepted higher-education recognition scope.

### Authority and national population

Primary authority: **Dienst Uitvoering Onderwijs (DUO) — Registratie Instellingen en Opleidingen (RIO)**.

Official resources:
- RIO open-data source family: https://onderwijsdata.duo.nl/datasets/rio_nfo_po_vo_vavo_mbo_ho
- Overzicht Erkenningen HO: https://onderwijsdata.duo.nl/datasets/overzicht-erkenningen-ho
- HO Opleidingsoverzicht: https://onderwijsdata.duo.nl/datasets/ho_opleidingsoverzicht
- RIO knowledge base: https://rio-kennisbank.duo.nl/

`Overzicht Erkenningen HO` states that it contains **all current data for OCW-recognised higher-education institutions and programmes**. RIO is the source. The dataset is updated daily and published under **Creative Commons Attribution**.

The broader RIO open-data family exposes machine-readable datasets including:
- `onderwijsaanbieders`;
- `onderwijslocaties`;
- `onderwijslocatiegebruiken`;
- `aangeboden_ho_opleidingen`;
- `aangeboden_ho_opleiding_cohorten`;
- `ho_opleidingen`;
- `ho_opleidingserkenningen`;
- `ho_onderwijsaccreditaties`;
- `ho_onderwijslicenties`;
- Provider/board/location/licence/recognition relationship datasets.

The RIO source family can be downloaded manually or queried through API endpoints and is published daily.

### Stable identity contract

RIO assigns stable source-native identifiers that do not depend on display names:

- **Provider / onderwijsaanbieder code:** RIO code format `999A999`.
- **Offered programme / aangebodenopleiding code:** UUID-format source identifier.
- **Education location / onderwijslocatie code:** RIO code format `999X999`.

Higher-education offered programmes also retain begin/end semantics. RIO defines cohorts separately for concrete starts/application periods rather than requiring Course identity to be cloned for each intake.

This maps naturally to the CourseFinder canonical principle:

`RIO Provider source identity -> RIO offered/recognised programme identity -> RIO location relationship`

Names and titles remain display/reconciliation facts only.

### Ten-gate assessment

| Gate | Result | Qualification evidence |
|---|---|---|
| Authority | **PASS** | DUO/RIO national higher-education registry and OCW-recognition publication |
| Stable Provider identity | **PASS** | RIO `onderwijsaanbiedercode` (`999A999`) |
| Stable Course/Programme identity | **PASS** | RIO offered-programme UUID plus recognised HO programme/education-unit identifiers |
| Population completeness | **PASS for declared scope** | `Overzicht Erkenningen HO` explicitly contains all current OCW-recognised HE institutions/programmes |
| Lifecycle/currentness | **PASS** | Daily publication plus begin/end/current/future/recognition semantics |
| Machine acquisition | **PASS** | Open downloadable files + CKAN/datastore API surfaces |
| Evidence reproducibility | **PASS** | Published dataset resources, documentation/changelog/control files and deterministic inventories permit private evidence capture/hash pinning |
| Use rights | **PASS** | Creative Commons Attribution |
| Replay/idempotency feasibility | **PASS at source-contract gate** | Stable non-name IDs and deterministic current inventories permit exact-key replay/change detection; implementation must still prove runtime replay UAT |
| Location model | **PASS** | Stable RIO locations and provider/offering/location relationship datasets |

### Qualification decision

**GO — adapter design/coding is authorised.**

Implementation constraints:
- use only accepted RIO stable identifiers for canonical Provider/Course identity;
- keep recognition identity, offered-programme identity, cohorts and locations relational rather than flattening them into title-derived keys;
- acquire immutable evidence and pin source versions/hashes before APPLY;
- do not infer missing location/recognition facts;
- do not publish NL into Search merely because Layer 1 ingestion later succeeds;
- production and Search remain separate acceptance gates.

---

## Finland — HOLD / QUALIFY

### Candidate authority

**Finnish National Agency for Education (EDUFI) — Studyinfo / Opintopolku, backed by Kouta/Konfo.**

Official evidence:
- Studyinfo is maintained by EDUFI and is described as the official, up-to-date site containing information about study programmes leading to a degree in Finland: https://www.oph.fi/en/higher-education-institutions-supporting-immigrants
- External Kouta/Konfo API documentation: https://wiki.eduuni.fi/spaces/ophPPK/pages/190612447/Koulutustarjonta%2Bja%2BOpintopolku.fi%2Btietomallit%2Bja%2Brajapinnat
- Current technical service documentation: https://wiki.eduuni.fi/spaces/ophPPK/pages/522308222/Tekninen%2Bdokumentaatio%2Bja%2Brajapinnat%2Bkoulutustarjonta

The public Konfo external interface is intended for other systems to retrieve published education offerings for use on their own websites. This is materially stronger than a scrape-only portal.

### Outstanding gate

The qualification review has not yet established an explicit authoritative **catalogue-data** licence/product-redistribution contract equivalent to NL RIO's CC BY terms. Documentation references software/service licensing and intended external API use, but that is not enough to silently infer commercial catalogue-data redistribution rights.

### Decision

**HOLD / QUALIFY.**

Finland is the highest-priority HOLD candidate after NL. Close Gate 8 with an explicit EDUFI data-use/product-redistribution statement or written permission before adapter authorisation. Provider/programme stable-key and lifecycle semantics should be documented at the same time rather than inferred from UI labels.

---

## Ireland — HOLD / QUALIFY

### Candidate authority

**Quality and Qualifications Ireland (QQI) — Irish Register of Qualifications (IRQ).**

Official resources:
- IRQ: https://www.qqi.ie/what-we-do/the-qualifications-system/irish-register-of-qualifications
- 2026 QDR update: https://www.qqi.ie/news/irq-data-update-to-the-europass-qualifications-data-register-qdr-0

QQI defines the IRQ as the national database of NFQ qualifications and the programmes that lead to them, including quality-assured providers and awarding bodies.

In April 2026 QQI confirmed a further higher-education data transfer from IRQ to the European Qualifications Dataset Register (QDR), where information is published as linked open data. QQI reported 219 providers and more than 11,000 qualifications in IRQ.

### Outstanding gate

The review still has not proven the complete supported CourseFinder acquisition contract end-to-end:
- deterministic full inventory endpoint/bulk export appropriate for recurring acquisition;
- stable Provider and Programme/Qualification source keys through that interface;
- currentness/lifecycle semantics for CourseFinder's declared programme population;
- explicit product/reuse terms for the exact acquisition path.

Linked-open-data publication is strong evidence of machine readiness but does not by itself prove the whole CourseFinder Layer 1 contract.

### Decision

**HOLD / QUALIFY.**

Ireland remains a high-priority qualification candidate, but no adapter coding is authorised yet.

---

## Norway — HOLD

### Candidate authority

**HK-dir — Utdanning.no** is a strong national education catalogue and discovery service.

Observed production API:
- https://v3.api.utdanning.no/

The current API describes itself as an open API for **internal Utdanning.no services**, is not versioned and may change without notice.

That makes it unsuitable as the accepted recurring Layer 1 source contract despite the strength of the national catalogue itself.

### Decision

**HOLD.**

A supported/versioned full-inventory Provider+Programme API or bulk contract with stable identity and acceptable reuse terms must be proven before adapter authorisation. Utdanning.no may still be assessed separately for Layer 2/discovery use.

---

## United Kingdom — HOLD confirmed

### Provider authority

UKVI Register of licensed sponsors — students remains useful Provider authority:
- https://www.gov.uk/government/publications/register-of-licensed-sponsors-students

It does not provide the complete all-level national Course catalogue required by the current CourseFinder Layer 1 target.

### Course data boundary

Discover Uni:
- https://discoveruni.gov.uk/information-providers/

Discover Uni's current dataset contains information for providers' **eligible undergraduate courses** and combines provider-submitted data with NSS, Graduate Outcomes and LEO. It is therefore an excellent structured outcomes/course-information source but remains a subset of an all-level national Course population.

### Decision

**HOLD.**

Do not combine separate partial authorities and call the result a complete national Layer 1 authority. Discover Uni/NSS/Graduate Outcomes/LEO/TEF remain Layer 2 candidates.

---

## United States — HOLD confirmed

### Structured national sources

IPEDS/NCES and College Scorecard remain strong machine-readable sources.

IPEDS data resources:
- https://nces.ed.gov/ipeds/datacenter/DataFiles.aspx

IPEDS completions report awards/degrees by six-digit CIP field and award level; other files report counts of programmes offered. These are statistical/reporting grains, not accepted stable current marketed-programme Course identities comparable to CRICOS, NZQA or RIO.

### Decision

**HOLD.**

IPEDS/College Scorecard should be qualified as Layer 2A institution/programme-field/outcome observations rather than promoted to Layer 1 identity authority.

---

## Germany — PAUSE confirmed

### National source

**Hochschulkompass**, maintained by the German Rectors' Conference/HRK, is a strong and comprehensive national study portal.

Resources:
- Downloads/terms: https://www.hochschulkompass.de/hochschulen/downloads.html
- Cooperation model: https://www.hochschulkompass.de/en/about-us/collaborative-partners.html
- Nationwide data-export cooperation: https://www.hochschulkompass.de/ueber-uns/kooperationspartner/bundesweit.html

Hochschulkompass states that its downloadable overviews are free for **personal use only** and that other uses, especially commercial use, require approval. HRK does provide regular data exports to approved cooperation partners for national programme-search services.

### Decision

**PAUSE.**

Germany can be reopened if CourseFinder obtains an HRK cooperation/data-use contract that proves acceptable product rights and a deterministic complete programme feed. Scraping around the rights boundary is prohibited.

---

## Canada — PAUSE retained

IRCC DLI remains strong Provider authority and existing CourseFinder CA canonical/history work remains preserved.

No new finding in this SRC-QUAL review provides a materially simpler national current Course authority for the international Bachelor+ target. Continue to prohibit institution-by-institution expansion under Milestone 1 and keep CA outside accepted Search until a new source strategy passes qualification.

---

## Australia and New Zealand — accepted substrate retained

No future-country research changes the accepted AU/NZ Layer 1 substrate.

Australia:
- CRICOS remains Provider/Course identity authority;
- QILT remains accepted Layer 2A outcomes enrichment;
- PRISMS remains accepted Layer 2A student-flow enrichment;
- Study Australia and Australia Awards Scholarship contracts remain accepted;
- RTP remains bounded to central-program authority unless Provider-specific evidence is supplied.

New Zealand:
- NZQA remains accepted Layer 1 Provider/Qualification authority;
- Education Counts remains the next structured Layer 2A candidate;
- Scholarship sources require their own stable source-identity qualification.

All detailed Scholarship source contracts accepted in v1.1 remain unchanged by this v1.2 revision.

---

## Future-country priority order

The source-qualified backlog is now:

1. **Netherlands — GO / SOURCE QUALIFIED** — next country permitted to enter adapter design/coding when programme capacity authorises it.
2. **Finland — HOLD / QUALIFY** — close explicit catalogue-data reuse/product-rights contract and document stable-key/currentness semantics.
3. **Ireland — HOLD / QUALIFY** — prove complete supported machine contract and stable Provider/Programme identity through the acquisition path.
4. **Norway — HOLD** — require supported/versioned full-inventory API/bulk contract.
5. **United Kingdom — HOLD** — no complete all-level Course authority qualified.
6. **United States — HOLD** — national statistical sources are Layer 2A, not marketed-Course identity authority.
7. **Germany — PAUSE** — reopen only through an acceptable HRK cooperation/licensing contract.
8. **Canada — PAUSE** — preserve current work; no fragmented expansion.

## Governance decision

**SRC-QUAL future-country review: PASS as a research/gate workstream.**

The review does not implement ETL and does not change accepted Search publication.

The material programme change is:
- **NL moves from unassessed future backlog to GO / SOURCE QUALIFIED**;
- **FI and NO are added to the qualified backlog as HOLD candidates**;
- **IE remains HOLD / QUALIFY with stronger linked-open-data evidence**;
- **GB and US remain HOLD**;
- **DE remains PAUSE with the rights/partnership blocker made explicit**;
- **CA remains PAUSE**.

No future-country adapter should be coded except NL unless a later SRC-QUAL revision records a new `GO` decision under the same mandatory gate.
