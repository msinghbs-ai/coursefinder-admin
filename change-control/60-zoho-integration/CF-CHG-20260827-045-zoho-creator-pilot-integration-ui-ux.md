# CF-CHG-20260827-045 — Zoho Creator Pilot Integration & UI/UX

**Status:** ACTIVE / PARTIAL — ZOHO CREATOR E2E READ PATH PROVEN; DEVELOPER-CONSOLE QUOTA/CACHE HARDENING ACTIVE  
**Category:** 60-zoho-integration  
**Initiated:** 27 August 2026 12:34 AEST (+10:00)  
**Origin chat/workstream:** CourseFinder — Zoho Creator UI/UX + Pilot Integration  
**Owner:** Zoho Pilot integration workstream  
**Change class:** integration / API / UI design / security / UAT / documentation

## Trigger

User-authorised Pilot/UAT workstream to connect ChatGPT to Zoho Creator where available, define the staff-facing Creator UI/UX, and establish a governed Zoho-specific consumer boundary without starting Production cutover or public Website integration.

## Problem / requested outcome

Existing Zoho documentation defines semantic mappings, but the live Pilot did not yet have a complete versioned Provider/Course/Campus/Scholarship read/sync contract suitable for a separate server-side Zoho consumer. An older `api.zoho_course_candidates_v1` exists and is authenticated-user executable; it is not accepted as the new Zoho boundary.

The current ChatGPT session exposes no Zoho Creator MCP/plugin tools. Access must not be invented.

## Affected surfaces / related workstreams

- Pilot Supabase `api.zoho_*_v1` read/sync functions.
- `msinghbs-ai/Coursefinder-Pilot` migration source.
- Zoho Creator information architecture and future MCP/data integration.
- Existing semantic contract `docs/coursefinder-zoho-consumer-contract-v1.3.md`.
- Website contract remains separate and unchanged.
- Active M2.4.2 / CF-CHG-20260827-044 is an overlapping runtime workstream; no Layer 2 authority/routing change is made here.

## Semantic impact

No canonical identity, source-authority, Layer 1–4, Search visibility or Publication semantic change.

The change introduces a Zoho-specific curated **read contract**. Zoho remains a derived consumer and is not a canonical-write or identity authority.

QILT and PRISMS are explicitly contextual. They are not coerced into Course-level facts.

## Before

- Zoho semantic mapping contract v1.3 existed.
- Old `api.zoho_course_candidates_v1` was an incomplete authenticated-user surface.
- No accepted Provider/Campus/Scholarship + incremental-sync Zoho v1 Pilot read family.
- No Zoho Creator connector is exposed in the current ChatGPT tool surface.

## After

Pilot now has service-role-only functions for:
- Provider search/exact lookup;
- Course search/exact lookup;
- Campus search/exact lookup;
- Scholarship search/exact lookup;
- changed-since reconciliation manifest.

Contract identifier: `zoho-integration-v1`.

The functions return curated DTOs only and do not expose raw `catalogue`, `pipeline`, Evidence, review, Vault, secret or credential structures.

Direct use of a Supabase service-role key by Zoho is **prohibited**. The first bounded Pilot transport is now deployed as `zoho-course-api` for the Courses screen. It uses a dedicated bearer token whose SHA-256 hash is stored in `private`, service-role-only database helpers, safe errors, request IDs and per-action rate limiting. The raw token is not stored in the database or source repository.

## Source authority / evidence

- `PROJECT_INSTRUCTIONS.md`.
- M2 Standing Instructions and A1–A10 execution rules.
- `docs/coursefinder-database-architecture-v2.10.42.md`.
- `docs/coursefinder-admin-pim-design-decisions-v1.17.md`.
- `docs/coursefinder-zoho-consumer-contract-v1.3.md`.
- `docs/coursefinder-website-developer-search-read-contract-v1.0.md` for separation/reference only.
- Live Pilot `fxcwkweaxjtknorudmwp`.

## Implementation references

- Supabase deployed migration: `20260827023923 / zoho_integration_v1_pilot_read_contract`.
- Supabase deployed migration: `20260827024224 / zoho_integration_v1_search_campus_reconcile`.
- Supabase deployed migration: `20260827054951 / zoho_pilot_course_api_auth_and_filter_options_v1`.
- Supabase deployed migration: `20260827055312 / zoho_pilot_course_api_rate_limit_v1`.
- Supabase Edge Function: `zoho-course-api` v10 ACTIVE, `verify_jwt=false` by design because the handler performs dedicated integration-token authentication before any resource action.
- Public service-role-only Edge wrappers reconcile PostgREST exposed-schema constraints without exposing `api` to anon/authenticated.
- `reference_bundle` now returns countries, subdivisions, Provider reference rows and dashboard platform statistics in one authenticated call for Zoho cache refresh.
- Pilot source mirror:
  - `supabase/migrations/20260827234500_zoho_integration_v1_pilot_read_contract.sql` — commit `733dccc843bbfe636165cf9e02e7b95bf1c27dec`.
  - `supabase/migrations/20260827234600_zoho_integration_v1_search_campus_reconcile.sql` — commit `ddbad8012ed1052989aa1f374b145eac9f7386b3`.
  - `supabase/migrations/20260827054951_zoho_pilot_course_api_auth_and_filter_options_v1.sql` — commit `a3d8ac5a71530a2aaba0f6f9045fadfabb8dfae7`.
  - `supabase/migrations/20260827055312_zoho_pilot_course_api_rate_limit_v1.sql` — commit `a461df6af40ee0fd3edc260866da4d0190deab89`.
  - `supabase/functions/zoho-course-api/index.ts` — latest commit `ef9ea02318942ccc315cef6909a3f505f8e57397`.
- RPC/API objects:
  - `api.zoho_provider_search_v1`
  - `api.zoho_provider_lookup_v1`
  - `api.zoho_course_search_v1`
  - `api.zoho_course_lookup_v1`
  - `api.zoho_campus_search_v1`
  - `api.zoho_campus_lookup_v1`
  - `api.zoho_scholarship_search_v1`
  - `api.zoho_scholarship_lookup_v1`
  - `api.zoho_sync_manifest_v1`
- UI version: N/A — Zoho Creator UI structure not yet created.

## UAT

Targeted Pilot results:
- exact Course lookup `082960F` → Provider `provider:cricos:00025b`: PASS;
- replay of exact lookup produces identical `item`: PASS;
- AU `nursing` search: 330 matches; requested page 5 returns 5: PASS;
- requested Course page 500 is capped at 50: PASS;
- Campus AU page returns bounded 10-item page: PASS;
- all nine new functions: `anon=false`, `authenticated=false`, `service_role=true`: PASS;
- changed-since 30-day Course manifest: 33,105; future watermark: 0: PASS;
- current manifest totals: 33,105 Courses / 3,085 Providers / 4 Scholarships;
- Security Advisor after DDL: 129 INFO, 0 WARN/ERROR, no Zoho-specific finding;
- Performance Advisor after DDL: 165 INFO, 0 WARN/ERROR, no Zoho-specific finding.
- representative direct DB timing: Course text search ~937 ms; exact Course lookup ~11 ms; Provider search ~49 ms.
- no-result search returns 200-style empty item semantics at the DB contract; negative limit/offset are bounded to 1/0.
- Course detail QILT/PRISMS context remains explicit `not_admitted` with correct grain labels.
- integration credential hash check: valid hash=true / invalid hash=false; `anon=false`, `authenticated=false`, `service_role=true`: PASS.
- Course filter options: Search-backed countries currently AU/NZ; AU subdivisions 8: PASS.
- rate-limit helper: limit=2 test produced allowed=true,true,false; `anon=false`, `authenticated=false`, `service_role=true`: PASS.
- Edge Function `zoho-course-api` v10 is ACTIVE with 120 requests/minute per action and 429 + `Retry-After` semantics.
- Zoho Creator Developer Console end-to-end Course lookup/search/filter/provider actions: PASS after public wrapper correction; exact Course `082960F`, AU nursing=330, AU/NZ countries, AU subdivisions and RMIT provider options were observed from Creator.
- Developer Console quota finding: official Zoho usage documentation limits Developer Console to 50 External Calls/day; `invokeURL` consumes External Calls. Repeated bridge/UI calls can therefore exhaust Development quota and surface generic `COURSEFINDER_UNAVAILABLE` even while Supabase remains healthy.
- Corrective UI design v3.1: dashboard makes zero live API calls, reference filters prefer Zoho cache/static AU/NZ references, bridge calls are de-duplicated, polling is bounded to two reads and failures open a client-side circuit breaker.
- One-call reference bundle validation: 3 countries, 21 current subdivisions, 3,085 Providers, payload ~1.22 MB; provider counts AU=1,546 / NZ=409 / CA=1,130; Search Course counts AU=26,648 / NZ=6,457.

The Supabase HTTP transport and Developer Console bridge path are now proven end-to-end for bounded read actions. Remaining acceptance is focused on quota-safe cache scheduling, high-fidelity responsive UI, persistent Zoho workflow forms and final bounded UAT. Production cutover remains unauthorised.

## Security findings

- New read functions use explicit `search_path`, SECURITY DEFINER and service-role-only EXECUTE.
- No service-role/database/Vault/Evidence credential is returned.
- Zoho must not call these RPCs using a service-role key.
- `private.zoho_integration_credentials` stores only a SHA-256 token hash; raw integration token is external to Supabase/source.
- `private.zoho_integration_rate_windows` is not exposed to `anon` or `authenticated`.
- The existing legacy `api.zoho_course_candidates_v1` is not promoted by this change and requires separate disposition before final Zoho acceptance.

## Rollback / reversion

Pilot rollback is deterministic:
1. revoke EXECUTE on the nine `api.zoho_*_v1` functions;
2. drop the nine functions by exact signature;
3. retain canonical/Search/Layer 1–4 data unchanged.
No canonical mutation, Search mutation or Publication mutation is part of these migrations.

## Documentation impact

- Zoho transport/read contract: `docs/coursefinder-zoho-integration-read-contract-v1.0.md`.
- Zoho Creator UI/UX handoff: `docs/coursefinder-zoho-creator-ui-ux-pilot-v1.0.md`.
- Run sheet: `project-runsheets/milestone-3/zoho-pilot/`.
- Existing Zoho consumer semantic contract v1.3 remains authoritative for field meaning.
- Architecture/Running Build/Master Plan not bumped: no accepted programme gate or canonical architecture change.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 27 Aug 2026 12:34 AEST | PROPOSED | Zoho Pilot UI/integration workstream initiated | current workstream |
| 27 Aug 2026 | ACTIVE / PARTIAL | No Zoho Creator tool exposed; continued safe Pilot implementation | tool discovery |
| 27 Aug 2026 | ACTIVE / PARTIAL | `zoho-integration-v1` read family deployed, source-mirrored and targeted security/UAT passed | migrations + commits above |
| 27 Aug 2026 | ACTIVE / PARTIAL | Official Zoho MCP/ChatGPT setup constraint documented; structural Creator build remains outside MCP capability | Zoho Creator MCP + OpenAI MCP app documentation |
| 27 Aug 2026 15:53 AEST | ACTIVE / PARTIAL | Courses-screen Pilot HTTP gateway, hashed integration auth, filter-options RPC and per-action rate limiting deployed; source mirrored | migrations `20260827054951`, `20260827055312`; Edge Function `zoho-course-api` v2 |
| 28 Aug 2026 | ACTIVE / PARTIAL | Creator bridge end-to-end read path proven after PostgREST `PGRST106` diagnosis and service-role-only public wrapper correction | exact lookup/search/filter/provider Creator evidence; Edge v8-v9 |
| 31 Aug 2026 | ACTIVE / PARTIAL | Developer Console 50 External Calls/day quota identified as repeated `COURSEFINDER_UNAVAILABLE` cause; quota-safe Widget v3.1 design prepared; one-call `reference_bundle` deployed | Edge v10; Pilot migration mirror `20260831051000_zoho_public_edge_wrappers_and_reference_bundle_v1.sql` |

## Closure

**Final status:** ACTIVE / PARTIAL  
**Closed at:** N/A  
**Outcome:** Pilot-safe read substrate, HTTP transport and bounded Zoho Creator bridge reads are proven. Developer Console quota behaviour is now an explicit Pilot constraint; cache-first/high-fidelity UI hardening and persistent Zoho workflow acceptance remain open. Production and public Website integration are not authorised.