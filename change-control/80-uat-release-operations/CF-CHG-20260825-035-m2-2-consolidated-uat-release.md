# CF-CHG-20260825-035 — M2.2 Consolidated Automated UAT & Release Gate

**Status:** APPROVED / IN PROGRESS  
**Category:** 80-uat-release-operations  
**Initiated:** 25 August 2026 20:08 AEST (+10:00)  
**Origin:** M2.2 — SECURITY-PRODUCTION-SEARCH-SHOWCASE  
**Owner:** CourseFinder UAT/release operations

## Scope

Consolidated automated evidence for M2.2 implemented scope, including:

- M2.1 Layer 2 regression safety;
- Auth/RBAC/RPC/RLS/Storage/Vault/Edge security;
- Supabase Pro control-state reconciliation;
- deterministic Search exact lookup, FTS and structured filters;
- pgvector candidate decision and benchmark evidence;
- server-side website developer read-contract boundary;
- query-plan/latency evidence;
- desktop and mobile deployed-browser regression;
- deployment SHA/artifact evidence.

## Required acceptance states

Each capability is recorded only as **PASS**, **BLOCKED with evidence**, or **DEFERRED by an accepted later gate**. Source/configuration existence alone is not PASS.

## Current evidence

- Supabase organisation plan verified `pro`.
- Direct authenticated execution of `public.layer2_ops_policy_update(uuid,uuid,jsonb)` removed; service role remains allowed.
- `layer2-config-control` live v3 is JWT-enforced and performs role/rank validation before service-bound policy mutation.
- Security Advisor no longer reports the Layer 2 SECURITY DEFINER warning; leaked-password protection remains the sole external WARN.
- Search preview/lookup functions are service-role-only; anon/authenticated EXECUTE checks are false.
- `search.course_documents` remains 33,105 rows, AU 26,648 / NZ 6,457; broad publication remains zero.
- pgvector 0.8.2 is installed, but embeddings/jobs/cache are all zero and no governed model profile exists; vector relevance PASS is therefore not inferred.
- direct FTS plan for `data science` over AU uses the GIN index and executed in ~18 ms in measured database UAT; current richer preview JSON wrapper still needs optimisation before performance PASS.
- latest Pilot deployed-browser workflow for current source SHA is running/pending and is not yet counted as PASS.

## Security finding disposition requiring explicit treatment

Three Search gate tables currently have RLS disabled:

- `search.projection_country_gates`;
- `search.enrichment_gates`;
- `search.enrichment_source_gates`.

Effective privilege inspection found no anon/authenticated schema usage or direct table privileges on `search`, so they are not currently exposed through the normal browser role boundary. Enabling RLS blindly would block internal service/database access without an accepted policy design, so no automatic RLS remediation is authorised under this UAT record. M2.2 must retain this as an explicit defence-in-depth WARN and define the Production policy before exposure changes.

## Remaining UAT before closure

- latest deployed desktop/mobile browser run must finish and be reconciled to the final Pilot SHA;
- final Search preview query-plan/latency optimisation or explicit non-acceptance;
- leaked-password state must either be enabled and verified or leave M2.2 BLOCKED;
- backup/PITR configuration/restore evidence must be allocated to the accepted Production establishment gate where a clean Production project is required;
- final adviser/invariant/regression run and evidence document update.

## Closure

**Final status:** IN PROGRESS  
**Outcome:** automated gate active; no handover delegation to the user.