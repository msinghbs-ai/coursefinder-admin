# Coursefinder — Running Build v1.3

**Status:** Active Pilot build record  
**Pilot runtime:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Pilot code:** `msinghbs-ai/Coursefinder-Pilot`  
**Design/planning/guides:** `msinghbs-ai/coursefinder-admin`

## Current Runtime State

- Cloudflare Worker deployment is operational at `coursefinder-pilot.techm.workers.dev`.
- Vite/React production build succeeds.
- Supabase Auth login confirmed with a Pilot-created user.
- Mumbai database is the authoritative Pilot database.
- Database build now includes migrations 001–025.
- Pilot UI PR #1 and PR #2 are merged.
- Current UI includes Dashboard, Providers, Campuses, Course Collections, Courses with detail panel, Scholarships, Categories, Attributes, Completeness, Review Queue, Pipeline and Jobs.
- Pilot remains read-first while the mandatory RLS/privilege hardening gate is completed.

## Layer 1 / Regulatory Settings

Migration 025 adds `public.ui_regulatory_sources_list()` as the read contract for Super Admin country regulator/source configuration.

The view is backed by existing:

- `ref.countries`;
- `pipeline.sources`;
- `integration.systems`.

No duplicate regulator table was created.

Current source registry contains no configured country regulatory sources yet. This is intentionally visible as a configuration gap.

### Target Settings experience

`Settings → Regulatory Sources`

For each country display:

- authoritative regulator/source;
- source type;
- endpoint/base URL;
- provider/course ingestion enablement;
- trust rank;
- source status;
- authentication requirement;
- last check;
- last successful fetch;
- latest failure;
- approved override where applicable.

Layer 1 Workers will resolve this registry automatically. Source discovery itself remains governed; Workers must not silently trust arbitrary internet-discovered regulator endpoints.

## Cloudflare Access

No direct Cloudflare/TechM control-plane connector is available in the current ChatGPT tool session. Cloudflare plugin search returned no available plugin. Current operations therefore use GitHub-triggered deployment, Worker URLs and supplied build/deploy logs.

## Documentation Artefacts

Created in `coursefinder-admin`:

- `docs/coursefinder-user-guide-v1.0.md`
- `docs/coursefinder-admin-guide-v1.0.md`

Guides are role-oriented and will be versioned as features and operating processes are promoted.

## Current Blocking Gate

Mandatory internal-table RLS / privilege hardening remains required before formal UAT security sign-off.

## Immediate Next Actions

1. Populate/approve regulatory sources for active Pilot countries.
2. Add Super Admin Settings UI for regulatory-source visibility.
3. Connect Layer 1 Worker source resolution to the registry.
4. Add source health/last-run telemetry.
5. Complete RLS/privilege hardening.
6. Continue PIM UI and role-specific workflows.
7. Continue User Guide/Admin Guide versioning with screenshots once UI stabilises.
