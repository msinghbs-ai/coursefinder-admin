# CF-CHG-20260825-032 — M2.2 Search / Showcase Acceleration

**Status:** **CLOSED / PASS — GOVERNED M2.2 ACCELERATION**  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 20:08 AEST (+10:00)  
**Closed:** 25 August 2026 21:26 AEST (+10:00)  
**Origin chat/workstream:** M2.2 — SECURITY-PRODUCTION-SEARCH-SHOWCASE  
**Owner:** CourseFinder programme governance

## Programme decision

The Friday 28 August 2026 Search/showcase acceleration is accepted as a governed M2.2 scope change. It does not grant broad Publication, Production consumer exposure, Zoho cutover or final Production handover authority.

The authority model remains:

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 remains terminal. Search Projection, Search Visibility and Publication remain downstream product states.

## Closed scope

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
- leaked-password protection: enabled and live Security Advisor verified under `CF-CHG-20260823-022` CLOSED/PASS.
- final Pilot SHA: `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`.
- build run `32840377937`: PASS.
- deployed desktop/mobile UAT run `32840377935`: PASS.
- deterministic Search/read acceleration: CLOSED/PASS under `CF-CHG-20260825-033`.
- vector/hybrid: explicitly DEFERRED / NOT ACCEPTED because no governed embedding profile/corpus exists.
- consolidated automated UAT: CLOSED/PASS under `CF-CHG-20260825-035`.
- Security & Production Foundation: CLOSED/PASS for the Pilot foundation under `CF-CHG-20260825-034`.
- broad Publication remains zero / not authorised.
- Production cutover remains not authorised.

## Final security/invariant regression

After managed Auth enablement:

- Security Advisor no longer reports leaked-password protection disabled;
- direct Layer 2 privileged RPC remains denied to anon/authenticated and allowed only to service_role;
- bounded website Search RPCs remain denied to anon/authenticated and allowed only to service_role;
- Courses 43,461; Providers 3,085; Search documents 33,105; AU 26,648; NZ 6,457;
- embeddings/jobs/query cache remain 0/0/0;
- Search generation remains 22;
- broad publication remains 0.

## Programme documents

- Master Project Plan: `docs/coursefinder-master-project-plan-v1.68.md`;
- M2→Production Delivery Plan / TSOW: `docs/coursefinder-m2-production-delivery-plan-tsow-v1.1.md`;
- M2.2 architecture: `docs/coursefinder-m2-2-security-production-search-showcase-architecture-v1.0.md`;
- Production guide: `docs/coursefinder-production-environment-build-operations-guide-v1.1.md`;
- Running Build: `docs/coursefinder-running-build-v2.70.md`;
- website developer contract: `docs/coursefinder-website-developer-search-read-contract-v1.0.md`;
- UAT evidence: `docs/uat/coursefinder-m2-2-security-search-showcase-2026-08-25.md`;
- Friday milestone record: `docs/coursefinder-milestone-meeting-2026-08-28-m2-2-showcase.md`.

## Time/cost governance

No engagement hours are inferred from technical execution. Previously confirmed engineering hours remain authoritative until explicitly confirmed by the user. Supabase Pro is recorded separately as a project expense; no subscription amount is fabricated.

## Next programme gate

Proceed to the next accepted M2/Production establishment gate. It must preserve M2.2 scope boundaries and independently establish clean Production environment/secrets, protected deployment, backup/PITR/restore evidence, Production Auth/security controls, monitoring and release acceptance before Production cutover.

## Closure

**Programme acceleration: CLOSED / PASS.**  
**M2.2 overall: CLOSED / PASS for the implemented Pilot Security/Production/Search showcase scope.**

No broad Publication, Production consumer exposure, Zoho cutover or final Production handover authority is implied.