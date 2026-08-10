# Coursefinder Running Build v1.1

**Status:** Active pilot build record  
**Authoritative runtime:** `coursefinder_Pilot` Supabase in Mumbai (`ap-south-1`)  
**Authoritative code repo:** `msinghbs-ai/Coursefinder-Pilot`  
**Architecture / design / planning repo:** `msinghbs-ai/coursefinder-admin`

## Current build state

### Supabase Pilot

- Project: `coursefinder_Pilot`
- Project ref: `fxcwkweaxjtknorudmwp`
- Region: Mumbai (`ap-south-1`)
- Free plan
- Production-model migrations applied through `023_ui_bridge_security_hardening`
- UI/UAT seed: 7 Australian providers and 35 courses
- Search Projection: 35 course documents, generation 2
- PIM families/groups/attributes seeded
- Private evidence Storage bucket exists
- Browser access is intended through authenticated RPC/API contracts rather than direct internal-schema access

### Supabase Studio visual expectations

The project uses multiple internal schemas rather than placing the domain model in `public`.

If Supabase Studio Table Editor or Schema Visualizer defaults to `public`, the database can appear nearly empty. This is expected.

Select these schemas to inspect the physical model:

- `catalogue` — Providers, Courses, Campuses, Course Collections, Academic Options and Provider Associations
- `pim` — Families, Groups, Attributes, Options, Categories, Values and Completeness
- `scholarship` — Scholarships, award tiers, scopes, criteria and coverage
- `pipeline` — sources, acquisition policies, jobs, evidence and claims
- `workflow` — Layer 4 review, import/export, migration and reconciliation
- `search` — Search Profiles, intent aliases, Search Projection, embeddings and cache
- `integration` — system/extraction/model profiles
- `publishing` — channels and publication states
- `security` — roles and user-role assignments
- `ref` — controlled reference data

The `public` schema mainly contains curated RPC/API functions and transitional read interfaces. It is not the canonical storage schema.

## Mandatory security gate

Supabase currently reports 61 non-public domain tables with RLS disabled. This is a **blocking hardening item before formal UI/UAT security sign-off**.

Target posture:

- enable RLS on internal domain tables;
- preserve server-side service-role access;
- do not add broad anonymous/authenticated table policies;
- browser/UI access remains through explicit authenticated RPC/API contracts;
- re-run Supabase Security Advisor and require no critical/error findings before UAT sign-off.

Do not enable RLS blindly without checking the current API bridge and server workflows; the hardening migration must be tested against UI and pipeline access.

## Pilot UI build

### Repository boundary

`Coursefinder-Pilot` is code/runtime only. Do not add architecture, design, plans, UAT records, handover or roadmap Markdown there. Those remain in `coursefinder-admin`.

### First UI release

PR #1 `Pilot PIM UI shell` was merged into `Coursefinder-Pilot/main`.

- Merge commit: `10474eba29ea51835ea1cb42260f10d8a7fa76ae`
- Stack: Vite + React + Supabase JS
- Auth: Supabase email/password session
- Environment variables: `VITE_SUPABASE_URL` and `VITE_SUPABASE_PUBLISHABLE_KEY`
- UI mode: read-only baseline

Implemented live screens against the Mumbai authenticated RPC bridge:

- Dashboard
- Providers
- Courses
- Scholarships
- Attributes
- Completeness
- Review Queue
- Pipeline
- Jobs

Navigation placeholders exist for:

- Campuses
- Course Collections
- Categories
- Integrations
- Settings

These placeholders intentionally wait for dedicated v2.9.1 API/RPC contracts instead of granting the browser direct access to internal schemas.

### UI visual model

- left-hand PIM navigation;
- catalogue workspace tables;
- PIM-style status/completeness presentation;
- separate Catalogue, PIM Model, Data Quality, Enrichment and Administration sections;
- responsive desktop/mobile shell;
- read-only first release before role-checked write operations.

## Build validation state

The GitHub branch/repo changes were reviewed through the GitHub connector and merged cleanly. The assistant execution container could not resolve `github.com`, so an external `npm install && npm run build` could not be performed there.

The first Cloudflare Worker/Pages deployment is therefore the definitive compile/runtime validation gate.

Expected build settings:

- Build command: `npm run build`
- Output directory: `dist`
- Environment:
  - `VITE_SUPABASE_URL=https://fxcwkweaxjtknorudmwp.supabase.co`
  - `VITE_SUPABASE_PUBLISHABLE_KEY=<Mumbai publishable key>`

## Immediate next actions

1. Connect `Coursefinder-Pilot` to the new Cloudflare Worker/Pages deployment.
2. Configure the two Vite environment variables.
3. Run the first Cloudflare build and resolve any compile/runtime issue.
4. Create a Mumbai Supabase Auth UAT user and assign the appropriate role.
5. Smoke-test live Dashboard, Providers and Courses.
6. Complete mandatory RLS/privilege hardening and re-test the UI bridge.
7. Add dedicated API contracts and UI screens for Course Collections, Campuses and Categories.
8. Start course/provider detail workspace and family-driven edit UI.

## Current blockers / risks

- RLS hardening is not yet complete and remains the primary security gate.
- Cloudflare compile/runtime validation has not yet run.
- No Pilot Auth UAT user has been confirmed in this build record.
- Write/mutation APIs remain intentionally unpromoted.
- Wider catalogue, Layer 2 enrichment and full embeddings remain future population work and do not block UI shell development.

## Revision log

### v1.1

- Records the code-only `Coursefinder-Pilot` repository boundary.
- Records first Pilot UI merge and implemented screens.
- Adds Cloudflare build/runtime validation gate.
- Retains RLS hardening as mandatory pre-UAT security work.
- Retains Supabase multi-schema Studio/Visualizer expectations.
