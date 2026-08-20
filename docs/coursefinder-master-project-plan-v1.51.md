# CourseFinder Master Project Plan v1.51

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.50.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.55.md`

## Current programme position

Accepted AU Layer 1, Layer 2, Search isolation and PIM semantic baselines through v2.9 remain unchanged.

Current `M1-PIM-GOV` position adds:

| Change | State |
|---|---|
| `CF-CHG-013` Admin operations role boundary | DB/RPC/security PASS; deployed role-browser UAT pending |

Earlier open PIM semantic records retain their current technical/frontend-source PASS and deployed-browser acceptance gates.

## Operations security decision

Authentication is not authorisation.

Review Queue, Pipeline Jobs and Sources must be read through a role-aware governed boundary rather than directly executing public `SECURITY DEFINER` projections.

### Review Queue

- minimum role: Curator / rank 3;
- purpose: semantic/data-quality review.

### Pipeline Jobs

- minimum role: Pipeline Operator / rank 4;
- purpose: ingestion/job operations.

### Regulatory Sources — operational view

- minimum role: Pipeline Operator / rank 4;
- purpose: source health, validation, ingestion/freshness and automation awareness;
- browser payload is curated to exclude implementation/configuration metadata.

### Full source/integration configuration

- Platform Admin/private tooling only;
- not part of the normal Sources browser payload.

## Defect proof and remediation

Before `CF-CHG-013`, a synthetic authenticated identity with no CourseFinder role successfully read 1,000 Pipeline Job rows directly from `ui_jobs_list(1000)`.

The same identity was rejected by `public.admin_read('jobs')`, proving the public helper grant bypassed the intended role model.

Migrations 069–070 close the direct helper path and introduce a safe role-aware Operations dispatcher.

## Frontend decision

PIM Admin remains **v2.9.0**.

No UI version bump is required because existing navigation already reflects the intended workspace minimum roles:

- Review Queue at rank 3;
- Jobs at rank 4;
- Sources at rank 4.

The backend/payload contract is now aligned with that existing UX.

## Role-browser acceptance limitation

There are currently no active users assigned exactly Pipeline Operator rank 4.

A persistent production user will not be created merely to manufacture UAT coverage. Backend role checks and Platform Admin regression pass; deployed rank-4 browser UAT remains pending until an appropriate assigned identity exists.

## Governance outputs

- `CF-CHG-20260820-013`;
- Operations role-boundary UAT;
- PIM Admin Guide v1.6;
- migrations 069–070;
- central Change Control register update;
- Running Build v2.55.

Zoho Consumer Contract remains v1.3 because internal Review/Job/Source operations are not normal consumer contract fields.

## Preserved programme baselines

- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- AU Course Facts: RMIT + UQ / 10 bounded Courses;
- QUT: deferred/source-specific HTTP 403;
- QILT/PRISMS/Scholarship accepted state unchanged;
- Search Course Documents: 33,105;
- Search Fee/Intake/English/Scholarship enrichment admission: 0;
- vector Search remains rejected/not admitted;
- architecture remains v2.10.37.

## Next M1-PIM-GOV work

1. final branch/main reconciliation and history-preserving publication of CF-CHG-013;
2. deployed Pipeline Operator role-browser UAT when an assigned rank-4 account exists;
3. continue audit of PIM Attributes, Options and completeness-profile semantics/security;
4. preserve Admin operational fields as internal unless a separate consumer contract authorises exposure;
5. create new Change Control only for material semantic/security defects.
