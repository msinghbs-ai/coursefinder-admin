# CourseFinder Running Build v2.67

**Status:** **MILESTONE 1 COMPLETE / FROZEN — PILOT BASELINE**  
**Date:** 23 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.66.md`  
**Change Control:** `CF-CHG-20260823-028`  
**Frozen baseline:** `docs/coursefinder-m1-frozen-architecture-baseline-v1.0.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.40.md`

## Accepted release position

Milestone 1 is accepted complete for the governed Pilot baseline after final independent M1-ACCEPTANCE reconciliation.

Accepted capability marker remains:

`PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0 + Data Quality v1.0 + Access Admin v1.0 + Publication Governance v1.0`

No new product feature or UI capability is introduced by this release record.

## Final live baseline

- Providers: 3,085 all-country;
- Courses: 43,461 all-country;
- AU: 1,546 Providers / 26,648 Courses;
- NZ: 409 Providers / 6,457 Courses;
- Search: 33,105 `course-v3` documents;
- Search generation: 22;
- Search combined hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`;
- published Search documents: 0;
- publication entity states: 0;
- embeddings / jobs / query cache: 0 / 0 / 0;
- Evidence artifacts: 1,567;
- Pipeline jobs: 1,325.

Final Search dry-run is idempotent: 0 new / 0 changed / 0 removed / 33,105 unchanged for base and 0 changed / 33,105 unchanged for enrichment.

## Final integrity smoke

Zero findings for bounded checks of:

- Course → Provider orphans;
- Search → Course orphans;
- Search → Provider orphans;
- duplicate Provider stable keys;
- duplicate Course stable keys;
- duplicate Search Course IDs.

## Security position

M1 Security/Release remains CLOSED / PASS for Pilot.

Final live browser RPC boundary:

- `public.admin_read(text,jsonb)` only;
- SECURITY INVOKER;
- authenticated EXECUTE only;
- anon denied.

Evidence bucket remains private, 50 MiB maximum and MIME restricted.

Security Advisor has no unexplained Critical/Error findings. The leaked-password-protection WARN remains explicitly deferred for Pilot under `CF-CHG-20260823-022` and is mandatory before Production security sign-off.

## Performance position

M1 Performance/Responsiveness remains CLOSED / PASS.

Final accepted deployed run: `32622164346` against Pilot `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`.

Performance Advisor observations remain INFO-only and are future optimisation watch items, not measured M1 blockers.

## Source/runtime authority

Pilot main at freeze:

`msinghbs-ai/Coursefinder-Pilot@133b81734e435f9dea5ffb3ddd943e71d2930696`

The security-only commits after the browser performance SHA remain layered without changing accepted Admin UI semantics.

Admin repository remains the governance/Change Control/UAT/release-document authority; Pilot remains the deployed runtime/migration/Edge/UAT-implementation authority.

## Gate state

**M1-PIM-FINALISATION: CLOSED / PASS.**  
**M1-PIPELINE-OPS: CLOSED / PASS.**  
**M1-EVIDENCE-UX: CLOSED / PASS.**  
**M1-DATA-QUALITY-READINESS: CLOSED / PASS.**  
**M1-UAT-HARNESS: CLOSED / PASS.**  
**ACCESS ADMIN v1.0: CLOSED / PASS.**  
**M1-SEARCH-ENRICHMENT: CLOSED / PASS.**  
**M1-PUBLICATION-UAT: CLOSED / PASS.**  
**M1-GUIDES-OPS-HANDOVER: CLOSED / PASS.**  
**M1-PERFORMANCE-RESPONSIVENESS: CLOSED / PASS.**  
**M1-SECURITY-RELEASE: CLOSED / PASS FOR PILOT.**  
**M1-ACCEPTANCE: CLOSED / PASS.**  
**M1-SEARCH-VECTOR: REJECTED / NOT ADMITTED.**  
**LEAKED PASSWORD PROTECTION: DEFERRED FOR PILOT / MANDATORY PRODUCTION GATE.**

## Explicit post-M1 items

- Production leaked-password protection and Auth/RBAC UAT;
- vector/hybrid Search if reconsidered;
- QUT first-party Course Facts acquisition;
- broad catalogue publication / Production channel cutover;
- physical deletion of retired Edge tombstone slugs;
- Production identity review for retained custom-auth ingestion workers;
- further country expansion and wider enrichment coverage;
- non-blocking performance-advisor optimisation.

## Final acceptance evidence

`docs/uat/coursefinder-m1-final-acceptance-technical-acceptance-2026-08-23.md`

**Result: MILESTONE 1 COMPLETE / ACCEPTED / FROZEN FOR PILOT.**