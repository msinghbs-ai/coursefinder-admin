# CourseFinder Running Build v2.70

**Status:** M1 FROZEN / M2.1 CLOSED-PASS / **M2.2 CLOSED-PASS**  
**Date:** 25 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.69.md`  
**Change Controls:** `CF-CHG-20260825-032`, `-033`, `-034`, `-035`; `CF-CHG-20260823-022`

## Current accepted Pilot runtime

Final M2.2 Pilot source SHA:

`38ad08bb75ee7cf26a0a701a3ae008d1563b915b`

Automated evidence:

- Pilot Frontend Build run `32840377937` — PASS;
- deployed UAT run `32840377935` — PASS;
- Chromium desktop job `97778367860` — PASS;
- Chromium mobile job `97778367490` — PASS;
- desktop artifact `9560350909`, digest `sha256:b72ab53cfb77435d2508af645f5ed478b07655f1cc80460ace15c7552f80f677`;
- mobile artifact `9560520848`, digest `sha256:3504e06bd8c22f31203a87f17ef81914a293e0571aa2f99db29afb3fa0a7683c`.

## Inherited authority baseline

M1 remains frozen. M2.1 remains CLOSED/PASS and has not been reopened.

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 remains terminal. Search Projection, Search Visibility and Publication remain downstream product states.

## M2.2 accepted capability

### Supabase Pro / security

- organisation `techM` verified on Pro;
- leaked-password protection enabled through managed Supabase Auth and independently verified by a clean Security Advisor result with the prior WARN absent;
- direct authenticated EXECUTE on privileged `public.layer2_ops_policy_update(uuid,uuid,jsonb)` revoked;
- Layer 2 policy mutation routed through JWT-enforced `layer2-config-control` v3 with actor/rank validation and a bounded policy allowlist;
- website Search/read preview RPCs are service-role-only;
- raw Search/Vault operational boundaries remain unavailable for normal browser CRUD;
- no service-role secret is introduced into browser code;
- broad Publication remains disabled.

Current advisor output retains INFO-level RLS/no-policy notices on private/internal tables. These are not treated as browser exposure and remain subject to Production defence-in-depth design.

### Search/read acceleration

Accepted bounded server-side demonstration contract supports:

- exact Course/regulatory code lookup;
- exact stable Course identifier lookup;
- deterministic PostgreSQL FTS;
- structured hard filters;
- bounded pagination/sorting;
- consumer-safe DTO with projection/version metadata and no Publication grant.

Functions:

- `api.website_course_lookup_preview_v1(text)`;
- `api.website_course_search_preview_v1(...)`.

Performance defects found during UAT were corrected without relaxing the existing 3-second deployed RPC budget:

- website exact lookup ~8.78 s cold → ~17 ms measured database execution;
- website AU FTS preview ~4.74 s → ~281 ms measured database execution;
- final deployed desktop Courses page 1,841 ms;
- exact Course interaction request 963 ms;
- Course detail 986 ms.

### pgvector decision

pgvector 0.8.2 is installed, but Course embeddings, embedding jobs, query cache and governed embedding model profiles remain zero.

**Vector/hybrid remains DEFERRED / NOT ACCEPTED.** No synthetic vectors were generated. Exact/FTS/filter is the accepted Friday Search demonstration.

## Final data/runtime invariants

- catalogue Courses: 43,461;
- Providers: 3,085;
- Search documents: 33,105;
- AU Search documents: 26,648;
- NZ Search documents: 6,457;
- Search Projection: `course-v3`, generation 22;
- Search Projection hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`;
- embeddings/jobs/query cache: 0 / 0 / 0;
- published entities: 0.

No canonical identity, M2.1 Layer 2 authority or broad Publication regression is accepted.

## Production boundary

M2.2 PASS is a Pilot Security/Production/Search foundation acceptance. It is **not** Production cutover.

Production remains a clean separate environment. Target region remains Sydney `ap-southeast-2` unless explicitly changed.

The next Production establishment gate must independently prove:

- clean Production project/environment identity;
- scoped Production secrets and protected deployment environment;
- migration/deployment evidence and rollback path;
- backup/PITR configuration;
- isolated restore execution with accepted RPO/RTO;
- Production logging/monitoring;
- Production Auth controls including leaked-password protection;
- final Production Security Advisor/API/browser negative and positive regression.

Broad website Publication, Zoho cutover and final Production handover remain separately governed.

## Current programme documents

- Master Project Plan: `docs/coursefinder-master-project-plan-v1.68.md`;
- M2→Production Delivery Plan / TSOW: `docs/coursefinder-m2-production-delivery-plan-tsow-v1.1.md`;
- M2.2 architecture: `docs/coursefinder-m2-2-security-production-search-showcase-architecture-v1.0.md`;
- Production Build & Operations Guide: `docs/coursefinder-production-environment-build-operations-guide-v1.1.md`;
- Website Developer Search/read contract: `docs/coursefinder-website-developer-search-read-contract-v1.0.md`;
- User Guide: `docs/coursefinder-user-guide-v2.3.md`;
- Operations Runbook: `docs/coursefinder-operations-runbook-v1.3.md`;
- PIM/Admin Guide: `docs/coursefinder-pim-admin-guide-v1.17.md` plus applicable M2 addenda;
- Data Flow & Feature Atlas: `docs/coursefinder-data-flow-feature-atlas-v1.1.md`;
- M2.2 UAT: `docs/uat/coursefinder-m2-2-security-search-showcase-2026-08-25.md`;
- Friday milestone record: `docs/coursefinder-milestone-meeting-2026-08-28-m2-2-showcase.md`.

## Commercial/time boundary

No engagement hours are inferred from technical execution. Previously confirmed engineering hours remain authoritative until explicitly confirmed. Supabase Pro is recorded separately as a project expense; subscription cost is not fabricated here.

## Gate state

- M1 — CLOSED / PASS / FROZEN;
- M2.1 — CLOSED / PASS;
- M2.2 — **CLOSED / PASS**;
- deterministic Search/read showcase — PASS;
- consolidated automated UAT — PASS;
- Supabase Pro leaked-password control — PASS for Pilot;
- pgvector/vector/hybrid — DEFERRED / NOT ACCEPTED;
- broad Publication — NOT AUTHORISED;
- Production cutover — NOT AUTHORISED.

## Exact next gate

Proceed to clean Production establishment and release-readiness execution under the current Master Plan/TSOW. Do not promote the Pilot in place or infer Production authority from this M2.2 closure.