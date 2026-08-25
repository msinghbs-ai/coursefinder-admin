# CourseFinder Running Build v2.68

**Status:** M1 FROZEN / M2.1 CLOSED-PASS / M2.2 SECURITY-PROD-FOUNDATION NEXT  
**Date:** 25 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.67.md`  
**Change Control:** `CF-CHG-20260825-031`

## Accepted runtime position

M2.1 Layer 2 Platform is accepted complete on the current Pilot runtime after final deployed authenticated desktop/mobile UAT.

Accepted Pilot SHA:

`cba0e9ecd2f4878bfd51ad5278e60046b1fae581`

Final deployed UAT:

- run `32795496640` — success;
- desktop job `97645884152` — success;
- mobile job `97645884483` — success;
- desktop artifact `9544813710`;
- mobile artifact `9544904988`.

## Current capability marker

`M1 frozen PIM/Search/Publication baseline + Layer 2 Platform v1.4 accepted`

M2.1 adds:

- Source Profiles and execution policy;
- acquisition-provider abstraction/routing;
- Vault-backed Scrape.do/Firecrawl/ZenRows credentials;
- Provider Attempts;
- Native + Normalised Evidence lineage;
- deterministic Course extraction and candidate apply;
- completeness trial/measurement;
- Scholarship listing/detail extraction path;
- Layer 2 Operations Admin workspace;
- measured Layer 3 fall-out.

## Data invariants retained

- all-country Courses: 43,461;
- AU+NZ Search: 33,105 `course-v3` Course documents;
- broad publication remains disabled;
- Layer 2 does not redefine Layer 1 identity;
- Search/Publication are not implicitly changed by Layer 2 apply;
- Layer 4 is terminal; there is no Layer 5.

## Evidence capacity snapshot

Measured Supabase Pilot Storage on 25 Aug 2026:

- `evidence` objects: 1,583;
- bytes: 1,793,315,334 (~1.67 GiB).

Most current storage is regulatory Evidence. Current Layer 2 v2 samples indicate roughly 0.8 MiB for the Native+Normalised pair associated with a successful Course-page acquisition. Broad one-pass enrichment planning envelope: 45–60 GiB including discovery/retries/Scholarships/headroom.

## Security position

M1 Pilot security acceptance remains frozen, but M2 has introduced new Production work.

Current Supabase Security Advisor review on 25 Aug 2026 includes:

- leaked-password protection disabled — mandatory Production gate under `CF-CHG-20260823-022`;
- `public.layer2_ops_policy_update(...)` is `SECURITY DEFINER` and executable by `authenticated` — function currently verifies `auth.uid()` actor equality and minimum role rank 5, but requires explicit M2.2 Production threat-model/grant/RPC disposition.

No claim of Production security readiness is made by M2.1 closure.

## Admin IA direction

The accepted M2.1 UI remains Layer 2 Operations v1.4, but the current M2 target IA now matures:

- Layer 1 — Regulatory;
- Layer 2 — Enrichment;
- Layer 3 — AI Interpretation;
- cross-layer Evidence;
- Layer 4 terminal Review Queue.

Target document: `docs/coursefinder-admin-navigation-information-architecture-v1.3.md`.

## Commercial / acquisition direction

Initial scale-out recommendation:

- Direct HTTP first;
- Firecrawl Standard as initial paid richer-Evidence route;
- Scrape.do/ZenRows retained as fallback until measured Production-domain needs justify paid secondary capacity.

## Current gate state

- M1 — CLOSED / PASS / FROZEN;
- M2.1 — **CLOSED / PASS**;
- M2.2 — **NEXT**;
- broad Publication — NOT AUTHORISED;
- Production cutover — NOT YET AUTHORISED.

## Current guides

- consolidated M2 review: `docs/coursefinder-milestone-2-consolidated-review-v1.0.md`;
- Production build/operations: `docs/coursefinder-production-environment-build-operations-guide-v1.0.md`;
- milestone standard: `docs/coursefinder-milestone-governance-standard-v1.0.md`;
- PIM/Admin M2 addendum: `docs/coursefinder-pim-admin-guide-m2-layer-operations-addendum-v1.0.md`;
- Operations M2 addendum: `docs/coursefinder-operations-runbook-m2-production-addendum-v1.0.md`.

## Next gate

M2.2 — SECURITY-PROD-FOUNDATION must establish clean Production isolation, Auth/RBAC, privileged RPC review, backup/restore, CI/CD separation, monitoring and automated release UAT before Production can be accepted.
