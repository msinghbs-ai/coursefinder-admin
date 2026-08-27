# CF-CHG-20260827-045 — Zoho Creator Pilot Integration & UI/UX

**Status:** ACTIVE / PARTIAL — PILOT READ CONTRACT DEPLOYED; ZOHO MCP CONNECTION BLOCKED  
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

Direct use of a Supabase service-role key by Zoho is **prohibited**. A later bounded Pilot transport gate must place these functions behind a server-side integration endpoint with Zoho-side credential storage/rotation and rate limiting.

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
- Pilot source mirror:
  - `supabase/migrations/20260827234500_zoho_integration_v1_pilot_read_contract.sql` — commit `733dccc843bbfe636165cf9e02e7b95bf1c27dec`.
  - `supabase/migrations/20260827234600_zoho_integration_v1_search_campus_reconcile.sql` — commit `ddbad8012ed1052989aa1f374b145eac9f7386b3`.
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

Bounded HTTP/Zoho integration, malformed-request transport handling, rate limiting, responsive Creator UI and final acceptance remain open because the Zoho connection/transport is not yet available.

## Security findings

- New read functions use explicit `search_path`, SECURITY DEFINER and service-role-only EXECUTE.
- No service-role/database/Vault/Evidence credential is returned.
- Zoho must not call these RPCs using a service-role key.
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

## Closure

**Final status:** ACTIVE / PARTIAL  
**Closed at:** N/A  
**Outcome:** Pilot-safe read substrate is deployed and governed. Actual Zoho Creator connection/UI construction and server-side transport acceptance remain open; Production and public Website integration are not authorised.