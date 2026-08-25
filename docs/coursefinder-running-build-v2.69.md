# CourseFinder Running Build v2.69

**Status:** M1 FROZEN / M2.1 CLOSED-PASS / M2.2 IMPLEMENTED SCOPE PASS — OVERALL BLOCKED ON MANAGED AUTH  
**Date:** 25 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.68.md`  
**Change Controls:** `CF-CHG-20260825-032`, `-033`, `-034`, `-035`; `CF-CHG-20260823-022`

## Current deployed Pilot candidate

Final M2.2 Pilot source SHA:

`38ad08bb75ee7cf26a0a701a3ae008d1563b915b`

Automated evidence:

- Pilot Frontend Build run `32840377937` — PASS;
- deployed UAT run `32840377935` — PASS;
- Chromium desktop job `97778367860` — PASS;
- Chromium mobile job `97778367490` — PASS;
- desktop artifact `9560350909`, digest `sha256:b72ab53cfb77435d2508af645f5ed478b07655f1cc80460ace15c7552f80f677`;
- mobile artifact `9560520848`, digest `sha256:3504e06bd8c22f31203a87f17ef81914a293e0571aa2f99db29afb3fa0a7683c`.

## Inherited accepted baseline

M1 remains frozen. M2.1 remains CLOSED / PASS on accepted Layer 2 Platform semantics and has not been reopened.

The authority model remains:

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 is terminal. Search Projection, Search Visibility and Publication remain downstream states.

## M2.2 runtime changes

### Security

- direct authenticated EXECUTE on privileged `public.layer2_ops_policy_update(uuid,uuid,jsonb)` revoked;
- Layer 2 policy mutation routed through JWT-enforced `layer2-config-control` v3 with actor/rank validation and a bounded policy allowlist;
- former Security Advisor warning for that authenticated SECURITY DEFINER path removed;
- website Search/read preview RPCs are service-side only;
- raw Search/Vault operational boundaries remain unavailable for normal browser CRUD;
- broad Publication remains disabled.

### Search/read acceleration

Bounded service-side website-developer demonstration contract now supports:

- exact Course/regulatory code lookup;
- exact stable Course identifier lookup;
- deterministic PostgreSQL FTS;
- structured hard filters;
- bounded pagination/sorting;
- consumer-safe DTO with projection/version metadata and no Publication grant.

Final functions include:

- `api.website_course_lookup_preview_v1(text)`;
- `api.website_course_search_preview_v1(...)`.

Performance defects identified by automated UAT were corrected without relaxing the 3-second deployed RPC budget:

- Admin exact Course lookup regression: corrected with indexed exact-identity narrowing;
- website exact lookup: ~8.78 s cold → ~17 ms measured database execution;
- website AU FTS preview: ~4.74 s → ~281 ms measured database execution.

Final deployed desktop evidence includes Courses page 1,841 ms, exact Course interaction request 963 ms and Course detail 986 ms.

### pgvector decision

pgvector 0.8.2 remains installed, but:

- Course embeddings: 0;
- embedding jobs/cache: 0;
- governed embedding model profiles: 0.

Vector/hybrid is therefore **DEFERRED / NOT ACCEPTED**. No synthetic vectors were created. Exact/FTS/filter is the accepted bounded Friday Search demonstration.

## Data invariants

Final post-change runtime checks:

- catalogue Courses: 43,461;
- Providers: 3,085;
- Search documents: 33,105;
- AU Search documents: 26,648;
- NZ Search documents: 6,457;
- Search Projection: `course-v3`, generation 22;
- embeddings: 0;
- published entities: 0.

No canonical identity or broad Publication regression is accepted.

## Supabase Pro / Auth position

Organisation `techM` is verified on Supabase Pro. Pilot remains healthy in Mumbai `ap-south-1`.

The former Free-plan assumption is obsolete. However, live Security Advisor still reports leaked-password protection disabled. The currently connected Supabase management capability does not expose the hosted Auth-config write operation needed to enable that managed setting.

Therefore:

- Pro entitlement: PASS;
- implemented DB/RPC/Edge security hardening: PASS;
- leaked-password protection: **BLOCKED WITH EVIDENCE** under `CF-CHG-20260823-022` / `CF-CHG-20260825-034`;
- overall M2.2 acceptance: BLOCKED until that managed control is enabled and Auth/RBAC regression is re-run.

## Production boundary

Production remains a clean separate later environment and is not this Pilot project renamed or promoted in place. Production target region remains Sydney `ap-southeast-2` unless explicitly changed.

M2.2 does not claim:

- Production cutover;
- broad website Publication;
- Zoho cutover;
- executed Production restore/DR PASS.

Backup/PITR/isolated restore evidence remains mandatory at the clean Production establishment/cutover gate.

## Current programme documents

- Master Project Plan: `docs/coursefinder-master-project-plan-v1.68.md`;
- M2→Production Delivery Plan / TSOW: `docs/coursefinder-m2-production-delivery-plan-tsow-v1.1.md`;
- M2.2 architecture: `docs/coursefinder-m2-2-security-production-search-showcase-architecture-v1.0.md`;
- Production Build & Operations Guide: `docs/coursefinder-production-environment-build-operations-guide-v1.1.md`;
- Website Developer Search/read contract: `docs/coursefinder-website-developer-search-read-contract-v1.0.md`;
- User Guide: `docs/coursefinder-user-guide-v2.3.md`;
- Operations Runbook: `docs/coursefinder-operations-runbook-v1.3.md`;
- PIM/Admin Guide: current accepted M2.1 `docs/coursefinder-pim-admin-guide-v1.17.md` plus M2 Production addenda where applicable;
- Data Flow & Feature Atlas: `docs/coursefinder-data-flow-feature-atlas-v1.1.md`;
- M2.2 UAT: `docs/uat/coursefinder-m2-2-security-search-showcase-2026-08-25.md`;
- Friday milestone record: `docs/coursefinder-milestone-meeting-2026-08-28-m2-2-showcase.md`.

## Commercial/time boundary

Confirmed engagement hours are not inferred from technical execution. Previously confirmed project hours remain authoritative until the user confirms additional billable time. Supabase Pro is a project expense separate from engineering hours; the billing amount is not fabricated in this build record.

## Current gate state

- M1 — CLOSED / PASS / FROZEN;
- M2.1 — CLOSED / PASS;
- M2.2 deterministic Search/read implementation — PASS;
- M2.2 consolidated automated UAT — PASS;
- M2.2 Security & Production Foundation — **BLOCKED on managed leaked-password protection**;
- pgvector/vector/hybrid — DEFERRED / NOT ACCEPTED;
- broad Publication — NOT AUTHORISED;
- Production cutover — NOT AUTHORISED.

## Exact next gate

Enable the hosted Supabase leaked-password protection control through an authorised management path and immediately re-run Security Advisor, leaked-password rejection, compliant login/session, Access Admin/RBAC and deployed browser Auth regression. If those pass with this runtime unchanged, M2.2 can be re-evaluated for final PASS without reopening M2.1 or granting later Production/Publication authority.