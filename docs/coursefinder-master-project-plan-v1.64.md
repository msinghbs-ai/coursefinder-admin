# CourseFinder Master Project Plan v1.64

**Status:** **AUTHORITATIVE PROGRAMME GOVERNANCE — M1 OPERATIONAL HANDOVER ACCEPTED**  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.63.md`  
**Last consolidated:** 23 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.40.md`  
**Running build:** `docs/coursefinder-running-build-v2.66.md`  
**Pilot-to-Production Plan:** `docs/coursefinder-pilot-to-production-project-plan-v1.10.md`  
**Admin/PIM decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.13.md`  
**User Guide:** `docs/coursefinder-user-guide-v2.0.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.15.md`  
**Operations Runbook:** `docs/coursefinder-operations-runbook-v1.0.md`

## Current programme position

All accepted technical and semantic positions from Master Project Plan v1.63 remain in force.

Current M1 gates:

- M1-PIM-FINALISATION — **CLOSED / PASS**;
- M1-PIPELINE-OPS — **CLOSED / PASS**;
- M1-EVIDENCE-UX — **CLOSED / PASS**;
- M1-DATA-QUALITY-READINESS — **CLOSED / PASS**;
- M1-UAT-HARNESS — **CLOSED / PASS**;
- Access Admin v1.0 — **CLOSED / PASS**;
- M1-SEARCH-ENRICHMENT — **CLOSED / PASS**;
- M1-PUBLICATION-UAT — **CLOSED / PASS**;
- M1-GUIDES-OPS-HANDOVER (`CF-CHG-20260823-025`) — **CLOSED / PASS**;
- M1-SEARCH-VECTOR — **REJECTED / NOT ADMITTED**;
- Supabase leaked-password protection (`CF-CHG-20260823-022`) — **DEFERRED FOR PILOT / MANDATORY PRODUCTION GO-LIVE GATE**.

## M1 handover documentation baseline

Operational handover now has three current documents:

1. `docs/coursefinder-user-guide-v2.0.md` — role-specific deployed navigation and normal use;
2. `docs/coursefinder-pim-admin-guide-v1.15.md` — Admin field semantics, provenance, readiness and consumer implications;
3. `docs/coursefinder-operations-runbook-v1.0.md` — source/job/replay/evidence/rollback/security/publication operating procedures.

Technical acceptance is recorded in `docs/uat/coursefinder-m1-guides-ops-handover-technical-acceptance-2026-08-23.md`.

## Accepted operating journey

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Governed Publication → Consumer Channels`

This order is both the implementation authority model and the operations/training model. No guide may collapse these boundaries.

## Current implementation authority

Pilot runtime source remains:

`msinghbs-ai/Coursefinder-Pilot@16ce78e25e78c2324e056a7b8cb6024d4a0428a8`

No runtime/UI release was introduced by the handover gate. Visible Admin remains PIM Admin v2.12 plus independently versioned Pipeline Ops, Evidence, Data Quality, Access Admin and Publication Governance capabilities.

## Search / publication baseline

Accepted Search remains `course-v3`, 33,105 AU+NZ Course documents. Live handover verification found all 33,105 Search documents unpublished and the combined accepted hash unchanged at:

`b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`.

Current generation is 22. Generation is not a semantic acceptance invariant; bounded deterministic refresh/UAT may advance it while content returns to the accepted hashes.

Broad catalogue publication remains unauthorised. The private `pilot-course-positive-v1` publication capability is only a bounded Pilot control.

## Security / Production gate

The Pilot leaked-password-protection warning remains unresolved by design under `CF-CHG-20260823-022`. It is not transferable to Production. Production cutover/security sign-off requires an eligible Supabase plan, leaked-password protection enabled and Auth/RBAC UAT passing.

## Programme baseline for subsequent work

Subsequent CourseFinder work should begin from:

- Master Project Plan v1.64;
- Running Build v2.66;
- Database Architecture v2.10.40;
- Pilot-to-Production Plan v1.10;
- Admin/PIM Design Decisions v1.13;
- User Guide v2.0;
- PIM Admin Guide v1.15;
- Operations Runbook v1.0;
- Change Control Register current through `CF-CHG-20260823-025`;
- Pilot runtime `16ce78e25e78c2324e056a7b8cb6024d4a0428a8`.

M1 documentation/operations handover is accepted. Production security gating, broader publication decisions and any future Search/vector changes remain separately governed.