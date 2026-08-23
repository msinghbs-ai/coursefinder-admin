# CourseFinder Master Project Plan v1.63

**Status:** **AUTHORITATIVE PROGRAMME GOVERNANCE — PUBLICATION POSITIVE PATH ACCEPTED**  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.62.md`  
**Last consolidated:** 23 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.40.md`  
**Publication contract:** `docs/coursefinder-publication-governance-contract-v1.0.md`  
**Running build:** `docs/coursefinder-running-build-v2.65.md`  
**Pilot-to-Production Plan:** `docs/coursefinder-pilot-to-production-project-plan-v1.10.md`  
**Admin/PIM decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.13.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.14.md`

## Current programme position

- M1-PIM-FINALISATION — **CLOSED / PASS**.
- M1-PIPELINE-OPS (`CF-CHG-20260821-016`) — **CLOSED / PASS**.
- M1-EVIDENCE-UX (`CF-CHG-20260821-017`) — **CLOSED / PASS**.
- M1-DATA-QUALITY-READINESS (`CF-CHG-20260821-018`) — **CLOSED / PASS**.
- M1-UAT-HARNESS (`CF-CHG-20260822-019`) — **CLOSED / PASS**.
- Access Admin v1.0 (`CF-CHG-20260822-020`) — **CLOSED / PASS**.
- Data Quality concurrent/snapshot hardening (`CF-CHG-20260823-021`) — **CLOSED / PASS**.
- Supabase leaked-password protection (`CF-CHG-20260823-022`) — **DEFERRED FOR PILOT / MANDATORY PRODUCTION GO-LIVE GATE**.
- M1-SEARCH-ENRICHMENT (`CF-CHG-20260823-023`) — **CLOSED / PASS**.
- M1-PUBLICATION-UAT (`CF-CHG-20260823-024`) — **CLOSED / PASS**.
- M1-SEARCH-VECTOR — **REJECTED / NOT ADMITTED**.

Accepted operational journey:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Governed Publication → Consumer Channels`

## Current accepted implementation authority

Pilot:

`msinghbs-ai/Coursefinder-Pilot@16ce78e25e78c2324e056a7b8cb6024d4a0428a8`

Pilot PR #28 is the closure authority for the controlled publication profile and consumer-path corrections. Its Frontend Build run `32614972686` passed. The visible Admin runtime remains PIM Admin v2.12; no UI release is claimed by this gate.

## Search projection position

The accepted AU+NZ Search projection remains `course-v3` with **33,105 Course documents**. Search admission is domain-gated and source-gated; canonical relational presence alone does not imply Search readiness, and Search readiness does not imply publication.

Accepted first-party Course Facts admission remains qualified RMIT and UQ only:

- Provider-current tuition: 10 Courses;
- comparable annual/indicative-annual Provider tuition: 9 Courses;
- official Course URL: 10 Courses;
- Intake: 10 Courses / 18 observations;
- English requirements: 10 Courses / 32 observations.

Deferred QUT remains outside Search admission.

## Governed publication position

Pilot publication profile `pilot-course-positive-v1` is accepted as a bounded positive-path control, not a catalogue-wide publication rule.

The profile requires explicit per-Course approval plus active AU/NZ canonical identity, stable Course/Provider identity, Course title/code, accepted Search projection and at least one governed Course Evidence relationship.

Publication states are distinct:

- `published`: Website + Zoho;
- `internal`: Zoho only;
- `unpublished`: neither;
- `blocked`: neither.

Search projected/readiness remains independent and can coexist with any of these states.

The controlled AU/NZ UAT used only:

- AU CRICOS `102784C`;
- NZQA `109509`.

A separate Search-ready/enriched AU Course lacking explicit approval was correctly rejected. No full-catalogue publication was performed.

## Consumer contracts

Website Search v2 remains service-role-only and consumer-visible only for `published` Search documents.

Zoho Candidate API remains `zoho-course-candidates-v1`, authenticated/rank-gated, with no DTO expansion. Its stale Search projection metadata was corrected from `course-v2` to accepted `course-v3`.

Consumer payload UAT found no Evidence, review, artifact, storage-path or source-id leakage.

## Determinism / invalidation / rollback

Publication transitions changed only the bounded UAT Courses. Unchanged republish was idempotent.

A controlled existing UQ intake observation was temporarily withdrawn and restored to prove enrichment invalidation. Exactly one enrichment row changed; restoration returned its enrichment/semantic hashes and the global enrichment stage hash exactly to their accepted values.

Final post-UAT Search content state is exactly restored:

- base content hash `cd2c8422da31f2fa298053a40563c947780ebdaf09d7b41ff983bc6ef9649d9b`;
- enrichment stage hash `fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`;
- combined projection hash `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`.

Final Pilot visibility state after rollback:

- canonical non-unpublished Courses: `0`;
- Search non-unpublished Course documents: `0`;
- `publishing.entity_states`: `0`.

The publication profile, approvals and audit events remain as private controlled Pilot capability/evidence.

## Fee semantics

CRICOS registered tuition remains separate from Provider-current tuition. Regulatory fee states remain exactly 26,326 present / 191 source-null / 6,457 not-applicable / 131 zero.

Provider-current tuition retains year/basis/scope; only annual-compatible basis values enter comparable annual fields. `total_indicative` remains structured display data and is not silently annualised.

## Scholarships / QILT / PRISMS

Canonical Scholarships remain 4; none are Search-admitted while unpublished. QILT and PRISMS remain excluded from Course-grain Search; no provider/study-area/flow/cohort signal is fabricated at Course grain.

## Search-mode decision

FTS remains accepted. M1-SEARCH-VECTOR remains rejected/not admitted; no semantic corpus is accepted.

## Security / Production exception

Publication controls are service-role-only and publication profile/approval/event tables are private. The only new performance-adviser issue found during this gate — a missing covering index on publication event profile FK — was fixed before closure.

`CF-CHG-20260823-022` remains unchanged: leaked-password protection is a bounded Pilot exception and mandatory Production go-live security gate.

## Accepted technical baselines

- AU Providers / Courses: 1,546 / 26,648;
- NZ Providers / Courses: 409 / 6,457;
- AU+NZ Providers / Courses: 1,955 / 33,105;
- all-country Courses: 43,461;
- Campuses: 3,922;
- Scholarships: 4 canonical / 0 currently Search-admitted;
- Search Course Documents: 33,105 (`course-v3`);
- accepted AU Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- broad publication: not authorised.

## Governing references

- `CF-CHG-20260823-023` — Search enrichment CLOSED / PASS;
- `CF-CHG-20260823-024` — Publication UAT CLOSED / PASS;
- `docs/uat/coursefinder-m1-publication-uat-technical-acceptance-2026-08-23.md`;
- `docs/coursefinder-publication-governance-contract-v1.0.md`;
- Database Architecture v2.10.40;
- Running Build v2.65;
- Pilot-to-Production Project Plan v1.10.

## Baseline for subsequent work

Use Master Project Plan v1.63, Pilot-to-Production Plan v1.10, Running Build v2.65, Database Architecture v2.10.40, Publication Governance Contract v1.0, Admin/PIM Design Decisions v1.13, PIM Admin Guide v1.14, and Pilot `16ce78e25e78c2324e056a7b8cb6024d4a0428a8`.

Search enrichment and the bounded publication positive path are accepted. Broad catalogue publication remains a separate governed decision. Vector/hybrid remains not admitted.
