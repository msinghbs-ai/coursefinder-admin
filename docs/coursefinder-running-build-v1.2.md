# Coursefinder — Running Build v1.2

**Status:** Active Pilot build  
**Authoritative runtime:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Supabase project ref:** `fxcwkweaxjtknorudmwp`  
**Pilot code:** `msinghbs-ai/Coursefinder-Pilot`  
**Architecture/design/project records:** `msinghbs-ai/coursefinder-admin`

## Repository boundary

`Coursefinder-Pilot` is code/runtime only. Architecture, DB design, migrations/design records, project plans, UAT evidence, handover, build state and roadmap remain in `coursefinder-admin`.

## Runtime milestone — 11 Aug 2026

Cloudflare production build and deployment succeeded after correcting the unsupported Lucide icon import.

- Worker: `coursefinder-pilot`
- Runtime URL: `https://coursefinder-pilot.techm.workers.dev`
- Framework: Vite / React
- Build output: `dist`
- Production build: successful
- Cloudflare Worker deploy: successful
- Supabase Auth login: manually confirmed by Pilot user

This closes the basic GitHub → Cloudflare → Supabase Auth runtime bootstrap gate.

## Database state

Production-model Mumbai database migrations are now applied through **024**.

### Migration 024 — UI catalogue detail bridge

Added authenticated, read-only RPC contracts:

- `ui_campuses_list`
- `ui_course_collections_list`
- `ui_categories_list`
- `ui_course_detail`

The Course detail contract returns canonical course metadata plus current related data for:

- fees;
- intakes;
- English requirements;
- Academic Options;
- Course Collections;
- global Categories.

Browser code continues to use curated RPCs rather than direct internal-schema access.

## Current UI state

### Release 1 — merged

Pilot PR #1 / squash commit `10474eba29ea51835ea1cb42260f10d8a7fa76ae`:

- Supabase Auth login;
- PIM-style navigation;
- Dashboard;
- Providers;
- Courses;
- Scholarships;
- Attributes;
- Completeness;
- Review Queue;
- Pipeline;
- Jobs.

### Release 1 hotfix — deployed

Unsupported `lucide-react` `Attribute` icon replaced with supported `Tags` icon. Cloudflare production build subsequently completed successfully.

### Release 2 — merged / deployment pending validation

Pilot PR #2 / squash commit `e8e9082b4303372f89c1468ada80e83d576abfc8`:

- Campuses list;
- Course Collections list;
- Categories list;
- Course workspace master/detail layout;
- course metadata detail;
- fees/intakes/English detail;
- Academic Options detail;
- Course Collection and Category chips;
- dedicated responsive catalogue workspace styling.

Cloudflare automatic build/deploy is expected from the merge and must be runtime-validated before marking Release 2 UAT-ready.

## Seed/data state

Current UI/UAT seed remains deliberately small:

- 7 Australian providers;
- 35 courses;
- 35 Search Projection documents;
- Search Projection generation 2.

Campuses, Collections, Categories, Academic Options, fees/intakes/English may legitimately display empty for some/all current seed records until Layer 2 or the wider canonical migration populates those domains.

## Supabase Studio visual expectations

The physical model is multi-schema. `public` is intentionally not the location of the canonical domain tables.

Use schema selector to inspect:

- `catalogue` — providers, campuses, collections, courses and child data;
- `pim` — families, groups, attributes, categories and values;
- `scholarship` — scholarship domain;
- `pipeline` — sources/jobs/evidence/claims;
- `workflow` — reviews/import/export/migration records;
- `search` — profiles/projection/embeddings/cache;
- `ref` — reference data;
- `security` — roles and service permissions.

An empty-looking `public` Schema Visualizer/Table Editor does not mean the database is empty.

## Security gate — BLOCKING before formal UAT sign-off

The Supabase table inventory identified **61 internal tables with RLS disabled**. RLS/privilege hardening remains a mandatory pre-UAT security gate.

Required before formal UAT sign-off:

1. enable RLS on the identified internal domain tables;
2. confirm anon/authenticated have no unintended direct-table access;
3. preserve server/service-role processing paths;
4. validate the authenticated UI RPC bridge after hardening;
5. run Supabase Security Advisor;
6. require no Critical/Error findings.

Do not enable broad write access in the UI before this gate and role-checked write APIs are complete.

## Build/deployment improvements recorded

Cloudflare successfully auto-configured Wrangler during deployment, but the build log notes that generated Wrangler setup changes should be committed. The log also notes dependency caching is unavailable because no supported lockfile exists in the repository.

Roadmap candidates:

- commit explicit `wrangler.jsonc` / deployment scripts instead of relying on build-time autoconfiguration;
- commit a deterministic package lockfile (`bun.lock` or supported equivalent);
- add a CI build check before merge;
- retain Cloudflare deployment/runtime smoke validation after each UI release.

## Next execution

1. validate Release 2 Cloudflare build and authenticated runtime;
2. RLS/privilege hardening before formal UAT sign-off;
3. Provider detail workspace;
4. PIM Family / Group / Option configuration screens;
5. role-checked write API design;
6. wider canonical Pilot data migration;
7. Layer 1/2 pipeline promotion.

## Revision

### v1.2

- Cloudflare build/deployment and Supabase Auth login confirmed.
- Migration 024 recorded.
- Pilot UI PR #2 recorded.
- Build reproducibility improvements added.
