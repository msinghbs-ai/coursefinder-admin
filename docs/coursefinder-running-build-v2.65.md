# CourseFinder Running Build v2.65

**Status:** **M1-PUBLICATION-UAT CLOSED / PASS**  
**Date:** 23 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.64.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.40.md`  
**Publication contract:** `docs/coursefinder-publication-governance-contract-v1.0.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.14.md`  
**Admin/PIM decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.13.md`

## Accepted release position

Current accepted Admin runtime remains:

`PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0 + Data Quality v1.0 + Access Admin v1.0`

No visible PIM/Admin release is claimed by this publication-control change.

Accepted Pilot source authority:

`msinghbs-ai/Coursefinder-Pilot@16ce78e25e78c2324e056a7b8cb6024d4a0428a8`

Pilot PR #28 is the source closure authority for the controlled publication profile, service-only publication control, Zoho projection-metadata correction and publication-event FK index. Frontend Build run `32614972686` passed.

## M1-PUBLICATION-UAT — accepted

The governed path is now proven as:

`canonical → explicit publication readiness/profile → Search refresh → publication/channel state → Website / Zoho visibility`.

Accepted Pilot profile: `pilot-course-positive-v1`.

Controlled UAT slice only:

- AU CRICOS `102784C` / `course:cricos:00025b:102784c`;
- NZQA `109509` / `course:nzqa:8509:109509`.

The profile requires explicit approval, active AU/NZ canonical identity, stable Course/Provider identity, Course code/title, accepted Search projection and at least one governed Course Evidence relationship. Search presence or enrichment alone is insufficient.

The full catalogue was never published.

## Publication state semantics

- `published`: Website + Zoho visible;
- `internal`: Website hidden, Zoho visible;
- `unpublished`: neither consumer visible;
- `blocked`: neither consumer visible.

Search projection/readiness remains independent. A Course may remain Search projected while publication is internal, blocked or unpublished.

## Positive-path / rollback acceptance

Technical UAT passed:

- publication-profile positive eligibility;
- non-approved Search-ready Course rejection;
- publish;
- republish unchanged/idempotent;
- internal visibility;
- blocked visibility;
- unpublish/withdrawal;
- deterministic Search refresh;
- controlled enrichment invalidation and exact restoration;
- Website API positive/negative visibility;
- Zoho candidate API positive/internal visibility;
- role/ACL boundaries;
- consumer DTO leakage checks;
- response-latency checks;
- exact rollback.

Final Pilot state after UAT rollback:

- canonical non-unpublished Courses: `0`;
- Search non-unpublished documents: `0`;
- `publishing.entity_states`: `0`;
- controlled publication audit events retained;
- publication profile/allowlist retained for future bounded Pilot use.

## Search baseline preservation

The accepted AU+NZ Search projection remains **33,105 Course documents** under `course-v3`.

Post-UAT content is exactly restored to the accepted Search baseline:

- base content hash `cd2c8422da31f2fa298053a40563c947780ebdaf09d7b41ff983bc6ef9649d9b`;
- enrichment stage hash `fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`;
- combined projection hash `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`.

Generation advanced during bounded publication/invalidation UAT, but content returned exactly to the accepted hashes. Search enrichment semantics from `CF-CHG-20260823-023` are unchanged.

## Search enrichment position retained

Accepted Course-Fact Search coverage remains:

- CRICOS regulatory tuition: 26,326 present / 131 zero / 191 source-null / 6,457 not-applicable;
- Provider-current tuition: 10 Courses;
- comparable annual/indicative-annual Provider tuition: 9 Courses;
- official Course URL: 10 Courses;
- Intake: 10 Courses / 18 observations;
- English requirements: 10 Courses / 32 observations;
- admitted Scholarships: 0;
- QILT/PRISMS Course Search signals: excluded/not admitted.

Only qualified/UAT-passed RMIT and UQ first-party sources remain admitted. Deferred QUT remains outside Search.

## Consumer contracts

Website continues to use versioned `api.website_course_search_v2(...)` and returns published records only.

Zoho continues to use `api.zoho_course_candidates_v1(...)`, with no DTO expansion. During UAT its stale `meta.projection_version='course-v2'` declaration was corrected to the accepted `course-v3` substrate.

No Evidence, review-workflow, internal storage path or source identifier is exposed by either positive consumer payload.

## Security / performance

Publication readiness, mutation and explicit publication Search refresh are service-role-only. Publication profile/approval/event tables remain private from anon/authenticated users.

The performance adviser identified a missing covering index for `publishing.publication_events.profile_code`; migration `20260823031628_m1_publication_uat_event_profile_fk_index` resolved it.

The existing Supabase leaked-password protection warning remains separately governed by `CF-CHG-20260823-022`; it is a Pilot exception and mandatory Production gate.

## Search-mode position

FTS remains the accepted Search path. M1-SEARCH-VECTOR remains rejected/not admitted. Vector state remains 0 accepted embeddings / no admitted semantic corpus.

## Preserved programme baselines

- AU: 1,546 Providers / 26,648 Courses;
- NZ: 409 Providers / 6,457 Courses;
- AU+NZ: 1,955 Providers / 33,105 Courses;
- all-country Courses: 43,461;
- Campuses: 3,922;
- Scholarships: 4 canonical;
- accepted AU Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- canonical identity unchanged;
- broad catalogue publication remains unauthorised.

## Governance

`CF-CHG-20260823-024` — **CLOSED / PASS**. Technical acceptance: `docs/uat/coursefinder-m1-publication-uat-technical-acceptance-2026-08-23.md`.

Durable state/permission semantics: `docs/coursefinder-publication-governance-contract-v1.0.md`.

## Current gates

**M1-PIM-FINALISATION: CLOSED / PASS.**  
**M1-PIPELINE-OPS: CLOSED / PASS.**  
**M1-EVIDENCE-UX: CLOSED / PASS.**  
**M1-DATA-QUALITY-READINESS: CLOSED / PASS.**  
**M1-UAT-HARNESS: CLOSED / PASS.**  
**ACCESS ADMIN v1.0: CLOSED / PASS.**  
**M1-SEARCH-ENRICHMENT: CLOSED / PASS.**  
**M1-PUBLICATION-UAT: CLOSED / PASS.**  
**M1-SEARCH-VECTOR: REJECTED / NOT ADMITTED.**
