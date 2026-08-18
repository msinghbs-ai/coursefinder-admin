# CourseFinder Database Architecture v2.10.26

**Status:** AUTHORITATIVE ARCHITECTURE BASELINE  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.25.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 18 August 2026  
**Milestone:** Milestone 1 — canonical data platform  
**Scholarship UAT:** `docs/uat/coursefinder-layer2-scholarships-au-first-source-gate-uat-v1.0.md`

v2.10.26 retains all accepted Layer 1, QILT and PRISMS rules from v2.10.25 and records the accepted **M1-L2-SCHOLARSHIPS Australia first-authoritative-source contract** after autonomous source qualification, dry-run, APPLY, replay, idempotency, integrity, security and performance UAT.

## 1. Scholarship authority and identity boundary

Scholarships are independent canonical entities in the accepted relational Scholarship domain. They do not redefine Provider or Course identity.

The accepted chain remains:

`Scholarship -> Source Identifiers -> Offering Cycle -> Application Windows / Scopes / Eligibility / Award Tiers / Coverage`

Identity rules:
- Scholarship title alone is never identity;
- stable source-native identifiers are preferred and are stored in `scholarship.identifiers`;
- an annual intake/year is an Offering Cycle when the underlying scholarship/program identity is enduring;
- deadlines/rounds are Application Windows, not separate Scholarship rows;
- Provider Scope is not student Eligibility;
- Award Tier is not Coverage;
- historical/closed cycles remain valid history and are not rewritten into current identity.

AU CRICOS remains the accepted Layer 1 Provider/Course identity authority. Scholarship sources may attach to an accepted Provider only through an authoritative stable Provider key such as exact CRICOS. Name-derived Provider identity remains prohibited.

## 2. First accepted Australian source contracts

### Study Australia

Publisher/authority: Australian Trade and Investment Commission — Study Australia.

Source key:

`au_study_australia_scholarships`

Identifier scheme:

`study_australia_scholarship_id`

Accepted Scholarship identity is the 32-hex source-local identifier in the canonical Scholarship detail URL.

Accepted Provider mapping path:

`Study Australia Provider source key -> official Study Australia Provider page -> published CRICOS -> exact catalogue.provider_registrations(registration_scheme='cricos')`

No Provider-name fallback is permitted.

### Australia Awards Scholarships

Publisher/authority: Department of Foreign Affairs and Trade.

Source key:

`au_dfat_australia_awards`

Identifier scheme:

`dfat_award_scheme`

Accepted enduring Scholarship source identifier:

`AAS`

The published `AAS 2027` scheme/intake is represented as Offering Cycle `2027`, not as a new Scholarship identity.

### Research Training Program

Publisher/authority: Australian Government Department of Education.

Source key:

`au_education_rtp`

Qualification state: **BOUNDED**.

Persistent program identifier:

`10.82133/C42F-K220`

The central RTP program is qualified for stable program identity and central benefits/coverage. Provider-specific application windows are explicitly withheld until first-party Provider evidence is acquired because eligible higher education providers administer applications.

## 3. Source qualification and source-record history

New internal pipeline structures:

### `pipeline.scholarship_source_qualifications`

Stores the governed source contract independently from canonical Scholarship data:
- country;
- source key;
- authority/publisher;
- source URL/class;
- identifier scheme;
- stable identifier strategy;
- Provider mapping strategy;
- cycle strategy;
- evidence strategy;
- qualification status (`qualified`, `bounded`, `deferred`, `rejected`);
- notes/metadata.

This table is internal, RLS-enabled and service-role-only.

### `pipeline.scholarship_source_records`

Stores versioned source observations before/alongside canonical application:
- source ID;
- source record ID + URL;
- source Provider ID/CRICOS/name when present;
- content hash;
- evidence ID;
- parsed payload;
- observed/applied timestamps;
- status/error state.

Unique source-record version identity is:

`source_id + source_record_id + content_hash`

This allows source evidence to version independently from canonical identity. A changed upstream HTML/PDF snapshot may create a new source-record/evidence version without creating a duplicate Scholarship.

## 4. Canonical Scholarship identity and deterministic child identity

Canonical Scholarship stable key for the accepted AU worker is:

`scholarship:AU:<scholarship_source_key>:<source_record_id>`

Source identity resolution first checks:

`source_id + identifier_scheme + identifier_value`

New Scholarship and child IDs are deterministic from stable source identity so replay preserves IDs.

Child deterministic keys include the Offering Cycle and a source-local child key for:
- Application Window;
- Scope;
- criterion group;
- criterion;
- Award Tier;
- Coverage.

Cycle-aware source group codes are used so the same logical eligibility section can recur in later cycles without overwriting historical eligibility.

## 5. Offering Cycle and Application Window contract

A Scholarship can have zero-to-many Offering Cycles. A cycle can have zero-to-many Application Windows.

Accepted Australia Awards example:
- Scholarship identifier: `AAS`;
- Offering Cycle: `2027`;
- Window `AAS-2027-MAIN`: 1 February 2026 09:00 AEDT -> 30 April 2026 14:00 AEST;
- Window `AAS-2027-PLW`: 30 March 2026 09:00 AEDT -> 30 June 2026 14:00 AEST.

A source that only publishes a calendar date is not assigned an invented time zone. The source date is retained exactly and window metadata records source granularity; a timestamp remains null when the source does not publish a time.

## 6. Scope contract

Scope describes what the Scholarship can apply to. It is separate from applicant eligibility.

The accepted v1 worker can resolve:
- global scope;
- Provider scope;
- study-level scope;
- country scope.

Provider scope must resolve through exact accepted canonical identity. An unresolved non-global scope is rejected by the service apply contract rather than silently weakened.

The initial Study Australia proof contains three Provider Scopes, all resolving to RMIT University CRICOS `00122A`.

## 7. Compound Eligibility contract

Eligibility remains represented by linked criterion groups and criteria, not flattened text only.

Group conjunctions support nested `all` / `any` semantics.

Accepted Australia Awards 2027 example:
- root group `2027:eligibility_all` — `all`;
- child group `2027:country_any` — `any`.

The accepted cycle contains 9 criteria representing published country-pathway and general eligibility requirements, including age, Australian citizenship/permanent-residency restriction, military-status restriction, prior-award interval, institution admission, Student Visa requirements and overlapping-funding restriction.

Where a provider source publishes eligibility only as prose, the original narrative is preserved as evidence-backed non-machine-evaluable criteria instead of inventing unsupported structure.

## 8. Award Tier and Coverage contract

Award Tiers describe selectable/published award amounts or percentages.

Coverage describes what costs/benefits are covered.

The first accepted Study Australia proof includes:
- AUD 10,000 annually Award Tier;
- AUD 5,000 annually Award Tier;
- 35% tuition/program-fee reduction Award Tier plus corresponding tuition Coverage.

Australia Awards 2027 retains 9 Coverage facts:
- 100% tuition fees;
- return air travel;
- establishment allowance;
- living expenses;
- Introductory Academic Program;
- Overseas Student Health Cover;
- conditional pre-course English;
- conditional supplementary academic support;
- conditional fieldwork travel.

Coverage facts remain independently evidence-backed and cycle-scoped.

## 9. Evidence/version contract

Accepted source evidence includes official HTML and PDF responses plus a content-hashed JSON manifest.

Storage path family:

`layer2a/AU/scholarships/...`

The existing `evidence` bucket remains private.

Each evidence component retains:
- source URL;
- SHA-256 content hash;
- Storage path;
- MIME type;
- captured timestamp;
- source-record/worker metadata.

The manifest links the component evidence set used for a canonical APPLY.

Evidence immutability/versioning is intentionally distinct from canonical replay idempotency: source bytes can change while canonical stable identity remains unchanged.

## 10. Runtime and write boundary

Pilot worker:

`scholarships-au-etl` v0.1.1

Pilot source-control baseline:

`msinghbs-ai/Coursefinder-Pilot` commit `2f159d5d5f1715e771e0564cd13b8fc9e1d95ad5`

Applied migrations:
- `20260818070135_scholarship_au_authoritative_source_contract_v1`;
- `20260818070544_scholarship_au_pilot_nonce_runner`;
- `20260818071312_scholarship_source_qualification_country_index`.

Service RPCs:
- `public.svc_scholarship_prepare_source`;
- `public.svc_scholarship_register_evidence`;
- `public.svc_scholarship_resolve_au_provider`;
- `public.svc_scholarship_apply_records`;
- `public.svc_scholarship_source_record`.

All new public Scholarship service RPCs are revoked from `anon` and `authenticated` and granted to `service_role` only.

Pilot Edge UAT uses the existing single-use nonce pattern. No persistent bearer secret is placed in the Edge request.

## 11. Accepted first-source population

After corrected APPLY:

| Relation | Count |
|---|---:|
| Scholarships | 4 |
| Source Identifiers | 4 |
| Offering Cycles | 4 |
| Application Windows | 5 |
| Criterion Groups | 5 |
| Eligibility Criteria | 12 |
| Scopes | 3 |
| Award Tiers | 3 |
| Coverage | 10 |

All 4 Scholarships remain `publication_status='unpublished'`.

This is a first-source/UAT population and not a claim of complete national Scholarship catalogue coverage.

## 12. Replay/idempotency invariants

Corrected worker APPLY was replayed for both Study Australia and Australia Awards.

Canonical counts remained unchanged and deterministic-ID fingerprints were identical:
- Scholarships: `96203df1062d17a0f1e5c8d44a151715`;
- Offering Cycles: `3c14cc1d151fa9743c1b742a19fd6be1`;
- Application Windows: `7680638e21c4a957b3457c4d052c9657`;
- Criterion Groups: `08f0a78efba95347807d5ec23a9330e2`;
- Eligibility Criteria: `7622006a9000613cde68c148dcc1d352`;
- Scopes: `ebc4950c24dea0750a16a8fdd9c28112`;
- Award Tiers: `2a5463b3d914499f282d36704ab249a2`;
- Coverage: `db52862b231baea866419365c5cb2f0f`.

Canonical replay/idempotency is therefore accepted independently from evidence/source-record version count.

## 13. Autonomous UAT defect correction

The initial Study Australia percentage extractor used an invalid trailing word-boundary assumption after `%`. The source narrative was retained correctly, but the 35% bursary was not derived into Award Tier/Coverage.

The gate was held, worker v0.1.1 corrected percentage parsing, and dry-run/APPLY/replay was repeated. The corrected result contains one 35% Award Tier and one tuition Coverage row for the bursary.

This is an accepted example of the gate rule: preserved source evidence is authoritative; derived structure must be corrected and replayed before handover.

## 14. Security/performance invariants

Security UAT confirms:
- `anon`/`authenticated` cannot execute new `public.svc_scholarship_*` service RPCs;
- `service_role` can execute them;
- evidence Storage remains private;
- Scholarship rows remain unpublished.

The new source-qualification country foreign key received a covering index after advisor review.

The post-fix Supabase Performance Advisor no longer reports that new missing-index condition. Existing inherited/project-wide INFO notices and unrelated warnings remain programme hardening work rather than Scholarship gate blockers.

## 15. Publication/Search boundary

The first-source gate does not automatically publish Scholarships or add Scholarship facts to Search ranking/filtering.

Before consumer exposure, M1-SEARCH/Admin must define:
- publication/lifecycle semantics for current versus closed Offering Cycles;
- which Application Window is relevant for a student;
- how compound Eligibility is evaluated/displayed;
- Award Tier/Coverage presentation;
- missing/ambiguous data behaviour;
- evidence visibility rules;
- Search/filter/ranking semantics.

Until that gate, `publication_status='unpublished'` is the accepted state.

## 16. Governance decision

**M1-L2-SCHOLARSHIPS — Australia first-authoritative-source gate is PASS / ACCEPTED.**

The accepted v2.10.23 relational Scholarship model is now proven against real Study Australia and DFAT sources without weakening Provider/Course identity. RTP is qualified with a deliberate provider-window boundary. Full national Scholarship catalogue ingestion, NZ Scholarships, Admin workspace completion and student-facing publication remain separate gates.
