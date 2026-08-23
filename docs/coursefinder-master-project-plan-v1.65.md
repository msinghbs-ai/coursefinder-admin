# CourseFinder Master Project Plan v1.65

**Status:** **AUTHORITATIVE PROGRAMME GOVERNANCE — MILESTONE 1 COMPLETE / FROZEN**  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.64.md`  
**Last consolidated:** 23 August 2026  
**Change Control:** `CF-CHG-20260823-028`  
**Frozen M1 baseline:** `docs/coursefinder-m1-frozen-architecture-baseline-v1.0.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.40.md`  
**Running build:** `docs/coursefinder-running-build-v2.67.md`  
**Pilot-to-Production Plan:** `docs/coursefinder-pilot-to-production-project-plan-v1.10.md`  
**Admin/PIM decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.13.md`  
**User Guide:** `docs/coursefinder-user-guide-v2.0.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.15.md`  
**Operations Runbook:** `docs/coursefinder-operations-runbook-v1.0.md`

## Current programme position

**CourseFinder Milestone 1 is COMPLETE / ACCEPTED for the governed Pilot baseline.**

This decision is made only by `M1-ACCEPTANCE` under `CF-CHG-20260823-028` after independent reconciliation of governance, Change Controls, current Admin and Pilot repositories, deployed Mumbai Supabase state and final count/integrity/security/performance/Search smoke UAT.

M1 completion does not imply Production readiness or broad catalogue publication authority.

## Final M1 gate disposition

- M1-PIM-FINALISATION — **CLOSED / PASS**;
- M1-PIPELINE-OPS — **CLOSED / PASS**;
- M1-EVIDENCE-UX — **CLOSED / PASS**;
- M1-DATA-QUALITY-READINESS — **CLOSED / PASS**;
- M1-UAT-HARNESS — **CLOSED / PASS**;
- Access Admin v1.0 — **CLOSED / PASS**;
- M1-SEARCH-ENRICHMENT — **CLOSED / PASS**;
- M1-PUBLICATION-UAT — **CLOSED / PASS**;
- M1-GUIDES-OPS-HANDOVER — **CLOSED / PASS**;
- M1-PERFORMANCE-RESPONSIVENESS — **CLOSED / PASS**;
- M1-SECURITY-RELEASE — **CLOSED / PASS** for Pilot;
- M1-ACCEPTANCE — **CLOSED / PASS**;
- M1-SEARCH-VECTOR — **REJECTED / NOT ADMITTED**;
- Supabase leaked-password protection — **DEFERRED FOR PILOT / MANDATORY PRODUCTION GO-LIVE GATE** under `CF-CHG-20260823-022`.

## Frozen M1 data/runtime baseline

Deployed Supabase: `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp`, Mumbai (`ap-south-1`).

Accepted live baseline at final acceptance:

- all-country Providers: 3,085;
- all-country Courses: 43,461;
- AU: 1,546 Providers / 26,648 Courses;
- NZ: 409 Providers / 6,457 Courses;
- AU+NZ Search: 33,105 `course-v3` Course documents;
- Search generation: 22;
- combined Search hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`;
- published Search documents: 0;
- `publishing.entity_states`: 0;
- embeddings / embedding jobs / query cache: 0 / 0 / 0.

Final dry-run replay returned 0 new / 0 changed / 0 removed / 33,105 unchanged for base and 0 changed / 33,105 unchanged for enrichment.

## Frozen capability baseline

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · Access Admin v1.0 · Publication Governance v1.0 · governed`

Current operational guidance remains:

- User Guide v2.0;
- PIM Admin Guide v1.15;
- Operations Runbook v1.0.

## Repository responsibility baseline

Admin repository remains authoritative for governance/change-control/architecture/UAT/release documentation.

Pilot repository remains authoritative for deployed runtime, migration mirrors, Edge Function source and automated browser UAT implementation.

Accepted Pilot `main` at M1 freeze: `133b81734e435f9dea5ffb3ddd943e71d2930696`.

Final deployed browser performance acceptance remains bound to `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`; subsequent Pilot commits are security-only layers that do not redefine accepted PIM/Admin UI semantics.

## Security / release position

M1 Security is accepted for the Pilot baseline. Final live security smoke confirms:

- only `public.admin_read(text,jsonb)` is browser-executable by authenticated application users in `public`;
- it is SECURITY INVOKER and anon is denied;
- Evidence Storage remains private and constrained;
- no unexplained Critical/Error Supabase security finding remains.

The leaked-password-protection WARN is an explicit Pilot-only residual and remains a mandatory Production cutover gate. It is not waived by M1 completion.

## Explicit post-M1 scope

The following are intentionally outside M1 rather than silently open:

1. Production leaked-password protection enablement and Auth/RBAC UAT;
2. any future vector/hybrid Search admission;
3. QUT first-party Course Facts acquisition;
4. broad catalogue publication / Production Website or Zoho channel cutover;
5. physical deletion of retired diagnostic/UAT Edge tombstones;
6. Production identity-model review for retained custom-auth ingestion workers;
7. additional country expansion and wider enrichment coverage beyond the accepted AU/NZ baseline;
8. INFO-only performance-advisor optimisation unless later evidence shows material regression.

## Programme rule after freeze

Any post-M1 change touching the frozen baseline must open/update a Change Control and state explicitly whether it:

- extends the M1 baseline;
- supersedes part of it; or
- invalidates an accepted M1 invariant.

No future chat may silently reinterpret M1 acceptance as permission to publish broadly, enable rejected vector behaviour, waive Production security gates, or overwrite later parallel work.

## Final M1 decision

**MILESTONE 1 COMPLETE / ACCEPTED / FROZEN FOR PILOT.**

Technical evidence: `docs/uat/coursefinder-m1-final-acceptance-technical-acceptance-2026-08-23.md`.