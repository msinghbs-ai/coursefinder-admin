# CourseFinder Layer 2 Scholarship Enrichment — Australia First-Source Gate UAT v1.0

**Date:** 18 August 2026  
**Process:** `M1-L2-SCHOLARSHIPS`  
**Result:** **PASS / ACCEPTED — first authoritative AU Scholarship source gate**  
**Architecture entering gate:** `coursefinder-database-architecture-v2.10.25.md` with Scholarship relational model inherited from v2.10.23  
**Pilot source-control baseline:** `msinghbs-ai/Coursefinder-Pilot` commit `2f159d5d5f1715e771e0564cd13b8fc9e1d95ad5`

## 1. Gate objective

Prove that the accepted relational Scholarship model can ingest real authoritative Australian Scholarship sources without collapsing identity, time, scope, eligibility or award semantics.

Required proof:
- stable source-native Scholarship identifiers;
- Offering Cycles separate from Scholarship identity;
- multiple Application Windows per cycle where published;
- Scope separate from student Eligibility;
- nested/compound Eligibility groups;
- Award Tiers separate from Coverage;
- accepted canonical Provider mapping only through stable CRICOS identity;
- immutable private evidence and source-record version history;
- dry-run, APPLY, replay and idempotency;
- no automatic student-facing publication/Search projection.

## 2. Qualified AU sources

### Study Australia

**Authority:** Australian Trade and Investment Commission — Study Australia.  
**Status:** QUALIFIED.  
**Source key:** `au_study_australia_scholarships`.  
**Identifier scheme:** `study_australia_scholarship_id`.

Accepted source identity is the 32-hex source-local identifier carried in the canonical Study Australia Scholarship detail URL.

Provider mapping contract:

`Study Australia Provider source key -> Study Australia Provider page -> published CRICOS -> exact accepted catalogue Provider registration`

Provider-name matching is prohibited for Scholarship-to-Provider identity.

### Australia Awards Scholarships

**Authority:** Department of Foreign Affairs and Trade.  
**Status:** QUALIFIED.  
**Source key:** `au_dfat_australia_awards`.  
**Identifier scheme:** `dfat_award_scheme`.

Accepted enduring Scholarship identifier: `AAS`.

`2027` is represented as an Offering Cycle, not as a second Scholarship identity.

### Research Training Program

**Authority:** Australian Government Department of Education.  
**Status:** BOUNDED.  
**Source key:** `au_education_rtp`.  
**Persistent program identifier:** DOI `10.82133/C42F-K220`.

RTP program identity/coverage is qualified. Provider-specific application timing is not fabricated from the central program page because participating providers administer applications. Provider rounds require first-party provider evidence before ingestion.

## 3. Runtime delivered

Pilot Edge worker: `scholarships-au-etl` v0.1.1.

Applied live migrations:
- `20260818070135_scholarship_au_authoritative_source_contract_v1`;
- `20260818070544_scholarship_au_pilot_nonce_runner`;
- `20260818071312_scholarship_source_qualification_country_index`.

New governed pipeline structures:
- `pipeline.scholarship_source_qualifications`;
- `pipeline.scholarship_source_records`.

New service contracts:
- `public.svc_scholarship_prepare_source`;
- `public.svc_scholarship_register_evidence`;
- `public.svc_scholarship_resolve_au_provider`;
- `public.svc_scholarship_apply_records`;
- `public.svc_scholarship_source_record`.

Stable child IDs are deterministic from accepted source identity + cycle + child key, so replay does not replace relational identities.

## 4. Study Australia live-source UAT

Three source-native RMIT records were selected to exercise different award/window forms:

| Source ID | Scholarship | Exact Provider map | Cycle | Award/Coverage |
|---|---|---|---|---|
| `3d26fbb4f240456a8ffc71f9bd51ecf4` | RMIT Irana Turynska Scholarship | CRICOS `00122A` | `current` | AUD 10,000 annually Award Tier |
| `d2ec6bbb95a42533d1bc38a55330b012` | RMIT David Phillips Memorial Scholarship | CRICOS `00122A` | `recurring` | AUD 5,000 annually Award Tier |
| `475b48e53aeac5761f333d81f6e302ae` | RMIT English Language Bursary for Latin American Students | CRICOS `00122A` | `2026` | 35% program-fee Award Tier + tuition Coverage; closing date 1 December 2026 |

The published 1 December 2026 deadline is date-only. The model stores the exact source date without inventing a source time zone; the corresponding timestamp field remains null and source date/granularity remain in window metadata.

### Parser defect caught during autonomous UAT

Worker v0.1.0 preserved the bursary source text but failed to derive 35% Coverage because a regular expression incorrectly used a trailing word boundary after `%`.

The gate was not handed over in that state. Worker v0.1.1 corrected percentage parsing and the dry-run/APPLY/replay sequence was repeated.

Corrected Study Australia run:
- candidates: 3;
- exact CRICOS maps: 3;
- fallback/name maps: 0;
- Offering Cycles: 3;
- Application Windows: 3;
- Provider Scopes: 3;
- Eligibility criteria: 3;
- Award Tiers: 3;
- Coverage rows: 1.

## 5. Australia Awards live-source UAT

Canonical Scholarship source identifier: `AAS`.

Accepted Offering Cycle: `2027` — study commencing in 2027.

Application Windows:
- `AAS-2027-MAIN`: opens 1 February 2026 09:00 AEDT; closes 30 April 2026 14:00 AEST;
- `AAS-2027-PLW`: opens 30 March 2026 09:00 AEDT; closes 30 June 2026 14:00 AEST.

Compound eligibility is represented using two linked groups:
- `2027:eligibility_all` — conjunction `all`;
- `2027:country_any` — conjunction `any`, child of the root group.

The cycle contains 9 eligibility criteria covering the published participating-country pathway and general DFAT eligibility conditions.

Coverage is represented as 9 separate facts:
- 100% tuition fees;
- return air travel;
- establishment allowance;
- living expenses;
- Introductory Academic Program;
- Overseas Student Health Cover;
- conditional pre-course English;
- conditional supplementary academic support;
- conditional fieldwork travel.

## 6. Dry-run result

Both live source paths returned HTTP 200 in dry-run mode and completed validation before canonical APPLY.

The initial dry-run gate was run while the Scholarship domain was empty and created no canonical Scholarship rows.

**Dry-run: PASS.**

## 7. Corrected APPLY/replay/idempotency result

Final canonical Scholarship population after corrected APPLY:

| Relation | Count |
|---|---:|
| Scholarships | **4** |
| Source Identifiers | **4** |
| Offering Cycles | **4** |
| Application Windows | **5** |
| Criterion Groups | **5** |
| Eligibility Criteria | **12** |
| Scopes | **3** |
| Award Tiers | **3** |
| Coverage | **10** |

Replay completed successfully for both Study Australia and Australia Awards.

After replay, all canonical counts above remained unchanged and all deterministic-ID fingerprints remained identical:

| Relation | Fingerprint |
|---|---|
| Scholarships | `96203df1062d17a0f1e5c8d44a151715` |
| Offering Cycles | `3c14cc1d151fa9743c1b742a19fd6be1` |
| Application Windows | `7680638e21c4a957b3457c4d052c9657` |
| Criterion Groups | `08f0a78efba95347807d5ec23a9330e2` |
| Eligibility Criteria | `7622006a9000613cde68c148dcc1d352` |
| Scopes | `ebc4950c24dea0750a16a8fdd9c28112` |
| Award Tiers | `2a5463b3d914499f282d36704ab249a2` |
| Coverage | `db52862b231baea866419365c5cb2f0f` |

**Canonical replay/idempotency: PASS.**

Source-record/evidence history is intentionally not forced to the canonical row count. If an upstream HTML/PDF response changes bytes, a new content-hashed evidence/source-record version may be retained while the Scholarship and child identities remain stable.

## 8. Security/evidence result

- existing `evidence` Storage bucket remains private (`public=false`);
- Scholarship evidence is stored under `layer2a/AU/scholarships/...`;
- source HTML/PDF and evidence manifests are SHA-256 content-addressed;
- source-record history retains source ID, source URL, provider source ID/CRICOS, payload, content hash, evidence link and observed/applied timestamps;
- all new `public.svc_scholarship_*` write/read-helper RPCs are not executable by `anon` or `authenticated` and are executable by `service_role`;
- Edge UAT path uses the existing single-use Pilot nonce pattern;
- all 4 Scholarship rows remain `publication_status='unpublished'`.

Supabase Performance Advisor was rerun after the new qualification-table foreign-key index was added. The new missing-FK-index notice was cleared. Existing project-wide INFO notices and unrelated inherited warnings remain outside this gate.

## 9. Gate boundary

This gate proves the first authoritative Scholarship source implementation. It does **not** claim:
- full ingestion of the entire Study Australia scholarship catalogue;
- provider-specific RTP application windows;
- New Zealand Scholarship ingestion;
- completion of the Admin Scholarship relational workspace;
- student-facing Search/API publication of Scholarships.

Those remain later controlled gates.

## 10. Decision

**M1-L2-SCHOLARSHIPS — Australia first-authoritative-source gate: PASS / ACCEPTED.**

The v2.10.23 relational Scholarship model is now proven against real AU source data while preserving source identifiers, Offering Cycles, Application Windows, Scopes, compound Eligibility, Award Tiers, Coverage and evidence/version history.
