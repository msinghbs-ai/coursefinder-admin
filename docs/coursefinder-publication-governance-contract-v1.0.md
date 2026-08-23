# CourseFinder Publication Governance Contract v1.0

**Status:** ACCEPTED PILOT PUBLICATION CONTROL  
**Effective:** 23 August 2026  
**Change Control:** `CF-CHG-20260823-024`  
**Parent architecture:** `docs/coursefinder-database-architecture-v2.10.40.md`

## Purpose

Define the governed boundary between canonical identity/readiness, the accepted Search projection, publication state and consumer visibility. This contract does not authorise broad catalogue publication.

## State model

Search projection/readiness is operationally independent from publication. A Course may remain Search projected while publication is `published`, `internal`, `unpublished` or `blocked`.

| State | Canonical / Search publication | Website | Zoho | Consumer consequence |
|---|---|---|---|---|
| `published` | `published` | `published` | `published` | Website + Zoho |
| `internal` | `internal` | `unpublished` | `internal` | Zoho only |
| `unpublished` | `unpublished` | `unpublished` | `unpublished` | Neither |
| `blocked` | `blocked` | `blocked` | `blocked` | Neither |

`active`, completeness/readiness, Search projection presence and enrichment presence are not publication approval.

## Pilot publication profile

Profile: `pilot-course-positive-v1`.

A Course may enter `internal` or `published` under this profile only when:

1. the Course is explicitly approved for the profile;
2. canonical lifecycle is active;
3. country is AU or NZ;
4. stable Course identity, stable Provider identity, Course title and Course code are present;
5. the Course exists in the accepted Search projection;
6. at least one governed Course Evidence relationship exists.

Layer 2 enrichment is not manufactured to satisfy this profile. Truthful country/source gaps remain gaps.

The Pilot profile is intentionally bounded and does not provide blanket approval to publish all otherwise eligible AU/NZ records.

## Controlled service surfaces

- `publishing.course_publication_readiness_v1(uuid,text)`;
- `publishing.set_course_publication_v1(uuid,text,text,text)`;
- `publishing.refresh_course_publication_search_v1()`;
- `publishing.publication_profiles`;
- `publishing.publication_approvals`;
- `publishing.publication_events`.

Publication mutation/readiness and explicit publication Search refresh are service-role-only. Publication profile, approval and event tables are private and not browser/consumer-readable.

## Consumer contracts

### Website

`api.website_course_search_v2(...)` remains service-role-only and returns only Search documents whose publication state is `published`.

### Zoho

`api.zoho_course_candidates_v1(...)` remains authenticated and rank-gated. It admits `published` and `internal` Search records. Its contract version remains `zoho-course-candidates-v1`; metadata declares accepted projection `course-v3`.

Neither consumer DTO exposes Evidence artifacts, review workflow, internal storage paths or source identifiers.

## Refresh and invalidation

Publication state changes are followed by explicit `course-v3` Search refresh. Enrichment changes use the same deterministic native projection invalidation semantics and may not silently bypass the accepted enrichment admission gates.

## Admin semantics

The Admin Course detail must continue to distinguish:

- Search projected/readiness;
- canonical publication state;
- Website channel state;
- Zoho channel state;
- display-only completeness/readiness.

No readiness score or Search-ready signal may be rendered as publication approval.

## Rollback

A bounded publication rollback must:

1. transition the affected approved Courses to `unpublished`;
2. refresh Search;
3. verify Website and Zoho invisibility;
4. restore any controlled UAT fact mutation to its exact prior canonical state;
5. preserve publication audit evidence unless the publication-control feature itself is formally retired.

## Accepted Pilot UAT

The controlled AU/NZ positive path under `CF-CHG-20260823-024` proved publish, internal, blocked, unpublish, unchanged replay, enrichment invalidation/restoration, Website/Zoho visibility, ACL boundaries, leakage protection and response latency.

Final UAT rollback restored:

- canonical non-unpublished Courses: `0`;
- Search non-unpublished Course documents: `0`;
- `publishing.entity_states`: `0`;
- accepted base content hash: `cd2c8422da31f2fa298053a40563c947780ebdaf09d7b41ff983bc6ef9649d9b`;
- accepted enrichment stage hash: `fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`;
- accepted combined projection hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`.

Technical acceptance: `docs/uat/coursefinder-m1-publication-uat-technical-acceptance-2026-08-23.md`.
