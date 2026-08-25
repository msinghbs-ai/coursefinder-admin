# CF-CHG-20260825-032 — M2.2 Search / Showcase Acceleration

**Status:** **APPLIED — GOVERNED ACCELERATION; M2.2 OVERALL BLOCKED ON MANAGED AUTH**  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 20:08 AEST (+10:00)  
**Updated:** 25 August 2026 21:15 AEST (+10:00)  
**Origin chat/workstream:** M2.2 — SECURITY-PRODUCTION-SEARCH-SHOWCASE  
**Owner:** CourseFinder programme governance

## Programme decision

The Friday 28 August 2026 Search/showcase acceleration is now a governed M2.2 scope change. It does not grant broad Publication, Production consumer exposure, Zoho cutover or final Production handover authority.

The authority model remains:

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 remains terminal. Search Projection, Search Visibility and Publication remain downstream product states.

## Applied scope

M2.2 retained Security & Production Foundation as its primary milestone and added a bounded Friday acceleration for:

- deterministic exact/FTS/filter Search demonstration;
- pgvector/vector/hybrid measured decision;
- website-developer Search/read contract;
- representative end-to-end Admin/Layer 2/Evidence/Search showcase;
- SHA-bound automated security/performance/browser UAT;
- Supabase Pro entitlement and formerly Free-plan-blocked control reconciliation.

## Final technical outcome

- M1 remains FROZEN / PASS.
- M2.1 remains CLOSED / PASS and was not reopened.
- Supabase organisation plan: Pro.
- final Pilot SHA: `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`.
- build run `32840377937`: PASS.
- deployed desktop/mobile UAT run `32840377935`: PASS.
- deterministic Search/read acceleration: PASS under `CF-CHG-20260825-033`.
- vector/hybrid: explicitly DEFERRED / NOT ACCEPTED because no governed embedding profile/corpus exists.
- consolidated automated UAT: CLOSED / PASS under `CF-CHG-20260825-035`.
- Security/Production foundation: BLOCKED WITH EVIDENCE under `CF-CHG-20260825-034` solely because hosted leaked-password protection remains disabled and cannot be changed through the currently connected Supabase management operation.
- broad Publication remains zero / not authorised.
- Production cutover remains not authorised.

## Programme documents issued

- Master Project Plan: `docs/coursefinder-master-project-plan-v1.68.md`;
- M2→Production Delivery Plan / TSOW: `docs/coursefinder-m2-production-delivery-plan-tsow-v1.1.md`;
- M2.2 architecture: `docs/coursefinder-m2-2-security-production-search-showcase-architecture-v1.0.md`;
- Production guide: `docs/coursefinder-production-environment-build-operations-guide-v1.1.md`;
- Running Build: `docs/coursefinder-running-build-v2.69.md`;
- website developer contract: `docs/coursefinder-website-developer-search-read-contract-v1.0.md`;
- UAT evidence: `docs/uat/coursefinder-m2-2-security-search-showcase-2026-08-25.md`;
- Friday milestone record: `docs/coursefinder-milestone-meeting-2026-08-28-m2-2-showcase.md`.

## Time/cost governance

No engagement hours are inferred from technical execution. Previously confirmed engineering hours remain authoritative until explicitly confirmed by the user. Supabase Pro is recorded separately as a project expense; no subscription amount is fabricated.

## Next programme gate

Resolve the managed Supabase leaked-password protection blocker and run the specified Auth/RBAC regression. If successful, re-evaluate M2.2 for final PASS while preserving later Production/Publication gates.

## Closure

**Programme acceleration status: APPLIED.**

**M2.2 overall status: BLOCKED WITH EVIDENCE** on the single mandatory managed Auth control. This is not a rollback of the accepted deterministic Search/read showcase or consolidated UAT.