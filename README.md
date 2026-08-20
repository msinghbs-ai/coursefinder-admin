# CourseFinder PIM Admin v2.10.0

Responsive React/Vite operational PIM for the CourseFinder Supabase catalogue, deployed as Cloudflare static assets/Worker routing.

## Governed information architecture

- Overview
- Catalogue — Providers, Courses, Campuses
- PIM Configuration — Attributes, Options and Completeness configuration
- Enrichment & Insights — QILT and PRISMS
- Data Quality — Course readiness and Review Queue
- Evidence
- Pipelines & Jobs — Pipeline Control, Jobs and Sources
- Scholarships
- Search & Publication

Only useful governed workspaces are shown. Integrations or Platform Settings are not added as empty menu placeholders.

## Browser data boundary

The Admin browser uses Supabase Auth and the governed `public.admin_read` RPC. It does not perform direct internal-schema table CRUD.

Role visibility is aligned with server-side rank checks:

- assigned CourseFinder role: Catalogue, Insights, Scholarships, Search/Publication;
- Curator+ (rank 3): Review Queue and Evidence;
- Pipeline Operator+ (rank 4): Pipeline Control, Jobs and Sources;
- PIM Admin+ (rank 5): PIM Configuration.

Legacy `public.ui_*` `SECURITY DEFINER` compatibility RPCs are internal/service-only rather than normal authenticated-browser surfaces.

## Operational behaviour

- 50-row server-side catalogue/operations paging;
- server-side search/filter/sort on operational list paths;
- exact Course/Provider/CRICOS identity search;
- URL-backed filters, paging, sort and detail state for browser Back/Forward;
- stale-request cancellation via `AbortController`;
- loading skeletons plus explicit empty/error/retry/permission states;
- responsive desktop/laptop navigation;
- sticky table headers/context;
- resizable table columns persisted in browser storage;
- structured Provider/Course/Campus/Scholarship detail rather than raw database-row dumps.

Course semantics continue to distinguish CRICOS registered total-course tuition from Provider-current fee observations.

## Local setup

1. Copy `.env.example` to `.env.local`.
2. Set `VITE_SUPABASE_URL` and a **publishable/browser** `VITE_SUPABASE_PUBLISHABLE_KEY`; never use a service-role secret in the frontend.
3. Run `npm install` then `npm run dev`.
4. Production build: `npm run build`.

## Cloudflare deployment

`wrangler.jsonc` defines the Admin Worker/static asset deployment and serves `dist` with SPA fallback. Git-integrated deployment must build the Vite bundle first and provide:

- `VITE_SUPABASE_URL`;
- `VITE_SUPABASE_PUBLISHABLE_KEY`.

Use the integration/preview branch for browser UAT before closing the `30-admin-pim-ux` Change Controls. PIM finalisation is not complete merely because source and DB UAT pass.

## Governance references

- `docs/coursefinder-pim-admin-guide-v1.8.md`
- `docs/uat/coursefinder-m1-pim-finalisation-uat-2026-08-20.md`
- `change-control/30-admin-pim-ux/CF-CHG-20260820-015-pim-operational-ui-browser-acceptance.md`
