# CourseFinder M1 Guides / Operations Handover — Technical Acceptance

**Date:** 23 August 2026  
**Workstream:** M1-GUIDES-OPS-HANDOVER  
**Change:** CF-CHG-20260823-025  
**Result:** PASS

## 1. Scope

Validate that the final User Guide, PIM Admin Guide and Operations Runbook describe the actually accepted/deployed Pilot rather than planned or obsolete behaviour.

## 2. Authorities reconciled

Reviewed and reconciled:

- `PROJECT_INSTRUCTIONS.md`;
- `change-control/README.md`;
- `change-control/REGISTER.md` and overlapping controls 001–024;
- `docs/coursefinder-master-project-plan-v1.63.md`;
- `docs/coursefinder-running-build-v2.65.md`;
- `docs/coursefinder-database-architecture-v2.10.40.md`;
- `docs/coursefinder-admin-pim-design-decisions-v1.13.md`;
- `docs/coursefinder-pim-admin-guide-v1.14.md`;
- current Data Quality / Publication / Search-enrichment acceptance records;
- accepted Pilot source `msinghbs-ai/Coursefinder-Pilot@16ce78e25e78c2324e056a7b8cb6024d4a0428a8`;
- live Pilot Supabase project `fxcwkweaxjtknorudmwp`.

## 3. Deployed navigation UAT

Accepted Pilot `src/mature-main.jsx` reports PIM Admin `2.12.0` and the deployed role-filtered navigation:

- Dashboard;
- Providers, Courses, Campuses, Scholarships;
- Outcomes (QILT), Student Flow (PRISMS);
- Completeness, Evidence, Review Queue;
- Jobs, Sources, Attributes, Settings.

Minimum ranks in deployed source:

- rank 1: base read workspaces;
- rank 3: Evidence / Review Queue;
- rank 4: Jobs / Sources;
- rank 5: Attributes;
- rank 6: Settings.

Result: **PASS**. User Guide v2.0 and PIM Admin Guide v1.15 match deployed navigation and remove obsolete top-level Course Collections/Categories and accepted-vector-search instructions from older guides.

## 4. Live role UAT

Live `security.roles` returned:

| code | rank |
|---|---:|
| viewer | 1 |
| counsellor | 2 |
| curator | 3 |
| pipeline_operator | 4 |
| pim_admin | 5 |
| platform_admin | 6 |

Result: **PASS**. Role guidance is consistent with live database state. “Reviewer” is documented as the business/handover description of the Curator review function, not as a new database role.

## 5. Live catalogue/Search UAT

Live Pilot state returned:

- canonical Providers: 3,085 all-country;
- canonical Courses: 43,461 all-country;
- Search documents: 33,105 AU+NZ;
- published Search documents: 0;
- Search projection code: `courses`;
- Search projection version: `course-v3`;
- Search row count: 33,105;
- current generation: 22;
- combined content hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`;
- refresh function: `search.refresh_course_documents_v3`;
- enrichment gate: `domain_and_source_explicit`.

Result: **PASS**. Guides document the stable projection semantics/hashes and current unpublished state. They intentionally do not treat historical generation 13 as a fixed operating invariant because bounded publication UAT advanced generation while restoring identical content.

## 6. Complex-field documentation UAT

PIM Admin Guide v1.15 includes, for materially complex fields/domains:

- business meaning;
- source authority;
- grain/cardinality context;
- null/zero/not-applicable/not-yet-enriched semantics;
- evidence relationship;
- freshness/verification meaning;
- Search implication;
- Zoho mapping guidance where applicable.

Covered explicitly: Provider identity/geography, Campus, Course/CRICOS identity, CRICOS tuition/non-tuition, Provider-current tuition, official URL, Intake, English, Scholarship, QILT, PRISMS, verification, completeness/readiness, Search admission and publication.

Result: **PASS** against `PROJECT_INSTRUCTIONS.md` documentation obligation.

## 7. Operations-runbook UAT

Runbook includes bounded procedures for:

- source refresh;
- failed jobs;
- resume/replay/idempotency;
- Evidence inspection;
- source structural/semantic changes;
- rollback/reversion;
- security incident escalation;
- Search admission;
- publication rollback;
- access/role troubleshooting;
- handover evidence capture.

Result: **PASS**.

## 8. Security UAT

Supabase security advisers were re-run. Current findings are consistent with the established private-schema/RLS posture and include the already-governed warning:

- `auth_leaked_password_protection` — WARN, still disabled in Pilot.

No schema/runtime change was introduced by this documentation workstream. The guide/runbook explicitly preserve `CF-CHG-20260823-022` as a Pilot-only exception and mandatory Production go-live gate.

Result: **PASS WITH DOCUMENTED PILOT EXCEPTION**. This exception does not block the documentation handover gate because it is neither introduced nor reclassified here.

## 9. Change-control / overlap UAT

No canonical, Search, publication, Zoho or security semantics were changed. Existing closed controls remain authoritative. `CF-CHG-20260823-025` is documentation/operations-owned under `80-uat-release-operations` and cross-references affected surfaces rather than duplicating earlier semantic controls.

Result: **PASS**.

## 10. Final decision

**M1-GUIDES-OPS-HANDOVER: PASS.**

Accepted handover documents:

- `docs/coursefinder-user-guide-v2.0.md`;
- `docs/coursefinder-pim-admin-guide-v1.15.md`;
- `docs/coursefinder-operations-runbook-v1.0.md`.

No runtime, schema or publication change is required for this gate.