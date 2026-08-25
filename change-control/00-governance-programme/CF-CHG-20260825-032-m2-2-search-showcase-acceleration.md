# CF-CHG-20260825-032 — M2.2 Search / Showcase Acceleration

**Status:** APPROVED / IN PROGRESS  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 20:08 AEST (+10:00)  
**Origin chat/workstream:** M2.2 — SECURITY-PRODUCTION-SEARCH-SHOWCASE  
**Owner:** CourseFinder programme governance  
**Change class:** programme / Search acceleration / security / release governance

## Trigger

A new programme objective requires a substantial, defensible CourseFinder enhancement for the Friday 28 August 2026 milestone meeting, including a practical website-developer discussion covering Search, filtering, display contracts and a pgvector-backed option. The accepted v1.67 programme baseline scheduled most consumer/Search work later under M3/M4, so this acceleration must be governed rather than silently treated as pre-approved scope.

The Supabase organisation has also been upgraded from Free to Pro, invalidating earlier Free-plan assumptions for Pilot hardening and requiring re-evaluation of controls that were deferred only because of entitlement.

## Problem / requested outcome

Deliver one coherent M2.2 gate that preserves the accepted Layer 1–4 authority model while combining:

- Production/security foundation maturity;
- Supabase Pro reconciliation and hardening;
- bounded, safe and measurable Search/pgvector evaluation;
- a developer-facing Search/read contract for Friday discussion;
- representative end-to-end Admin/PIM showcase readiness;
- complete automated technical UAT and evidence;
- current milestone/task/change-control records.

The Friday showcase does not grant broad Publication, Production consumer exposure, Zoho cutover or final Production handover authority.

## Affected surfaces / related workstreams

- `00-governance-programme` — M2.2 scope/status and Friday milestone objective;
- `50-search-api-consumers` — bounded Search/read contract and vector/hybrid benchmark under `CF-CHG-20260825-033`;
- `70-security-platform` — Supabase Pro/Auth/RPC/RLS/Storage/secret controls, including `CF-CHG-20260823-022`;
- `80-uat-release-operations` — consolidated automated security/Search/browser regression evidence;
- Admin/PIM showcase surfaces only where current accepted UX needs genuine correctness/usability fixes;
- Master Project Plan, M2→Production TSOW, Running Build, Production guide, guides/runbook, milestone meeting record and UAT evidence.

## Semantic impact

No canonical identity, Layer authority, source authority or field-meaning change is authorised by this programme control.

The accepted model remains:

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 remains terminal. Search Projection, Search Visibility and Publication remain downstream product states. The term `Search Admission` must not be reintroduced into current product/governance terminology.

## Before

- M2.2 was Security & Production Foundation only, planned at 10 hours.
- M3 later owned the browser-safe consumer API/Zoho contract.
- M4 later owned Search/publication/Production handover.
- M1 Search accepted deterministic `course-v3`; vector/hybrid was rejected/not admitted with zero embeddings.
- leaked-password protection was deferred for Pilot because the organisation was on Supabase Free.

## After

- M2.2 retains Security & Production Foundation as its primary gate.
- A bounded Search/showcase acceleration is permitted inside M2.2 for evaluation, read-contract preparation and demonstrable Pilot Search behaviour.
- Later M3/M4 authority boundaries remain intact: the acceleration may prove/read-demo a contract but cannot imply broad Publication, Production website exposure, Zoho cutover or final release authority.
- pgvector may be accepted only if the benchmark proves material relevance value over deterministic FTS/filters at representative AU+NZ scale; otherwise FTS remains accepted and vector/hybrid remains candidate/deferred.
- Supabase Pro entitlement is now a live fact and formerly Free-plan-blocked controls must be re-evaluated; entitlement is not equivalent to control enablement.

## Live reconciliation at initiation

Supabase organisation `techM` / `rszbvkqopqfvjldvfnbh`:

- plan: `pro`;
- Pilot project `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp`: `ACTIVE_HEALTHY`;
- region: `ap-south-1` (Mumbai);
- PostgreSQL: 17.6.1;
- `vector` extension installed: 0.8.2;
- `search.course_documents`: 33,105;
- `search.course_embeddings`: 0;
- `search.embedding_jobs`: 0;
- publication: 0 published entities;
- current Security Advisor external WARNs: leaked-password protection disabled; `public.layer2_ops_policy_update(...)` authenticated `SECURITY DEFINER` execution.

A live Search-schema inspection also identified three gate tables with RLS disabled (`search.projection_country_gates`, `search.enrichment_gates`, `search.enrichment_source_gates`). Their effective grants/API exposure must be independently reconciled before any remediation decision; no automatic RLS change is authorised by this record alone.

## Implementation references

- Programme source baseline before this control: `34dd22215bb937c8f0ef131c36a6011893ade714`;
- accepted M2.1 Pilot SHA: `cba0e9ecd2f4878bfd51ad5278e60046b1fae581`;
- Search implementation / migration refs: maintained in `CF-CHG-20260825-033`;
- Supabase project: `fxcwkweaxjtknorudmwp`;
- UI version: unchanged at initiation.

## UAT

Required before this control can close:

- Supabase Pro/Auth control reconciliation;
- browser-executable RPC/`SECURITY DEFINER`/grant/RLS/Storage/Vault inventory and negative authorisation;
- Search exact-code/title/FTS/filter/vector/hybrid benchmark where implemented;
- publication/visibility negative tests;
- deterministic replay/idempotency;
- API/read-contract positive/negative tests;
- representative performance/query-plan measurement;
- desktop and mobile deployed-browser regression;
- M2.1 Layer 2 regression safety.

## Rollback / reversion

The programme acceleration can be reverted by removing the M2.2 Search/showcase additions and restoring v1.67 sequencing. Any Search implementation is derived-only and must have its own rollback under `CF-CHG-20260825-033`; canonical Layer 1–4 data/Evidence must not be altered merely to make the showcase appear complete.

## Documentation impact

- Master Project Plan: new version required because sequencing/scope materially changes;
- M2→Production TSOW: new version required while preserving confirmed hours and later milestone authority;
- Running Build: update only when runtime capability changes;
- Search/read developer contract: new bounded document;
- Production guide / Operations runbook / User/PIM guides: update for actual implemented security/Search/showcase behaviour;
- milestone meeting record: create/update for Friday 28 August 2026;
- engagement hours: do not fabricate; technical status is independent of confirmed billable time.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 25 Aug 2026 20:08 AEST | APPROVED / IN PROGRESS | User authorised M2.2 security/Production/Search/showcase acceleration with automated UAT and preserved later authority boundaries. | M2.2 — SECURITY-PRODUCTION-SEARCH-SHOWCASE |

## Closure

**Final status:** IN PROGRESS  
**Closed at:** N/A  
**Outcome:** M2.2 acceleration is governed; no broad Publication/Production/Zoho authority is implied.