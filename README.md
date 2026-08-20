# CourseFinder PIM Admin — v2.11 Accepted Governance State

Governed Admin/PIM architecture, migration mirrors, Change Control and release documentation for the CourseFinder Supabase catalogue.

The **actual Cloudflare Pilot implementation** is deployed from `msinghbs-ai/Coursefinder-Pilot`. The accepted PIM Admin v2.11 release is:

`Coursefinder-Pilot@b3867cc89bbfd3f76def01993a70868318016ef0`

This `coursefinder-admin` repository remains the authoritative project-governance and Admin architecture integration source; do not confuse its separate Worker target with the live `coursefinder-pilot` Worker.

## Governed information architecture

- Overview / operational Dashboard
- Catalogue — Providers, Courses, Campuses
- PIM Configuration — Attributes, Options and Completeness configuration
- Enrichment & Insights — QILT and PRISMS
- Data Quality — Course readiness and Review Queue
- Evidence
- Pipelines & Jobs — Pipeline Control, Jobs and Sources
- Scholarships
- Search & Publication
- Platform Settings where role-authorised and operationally useful

Only useful governed workspaces should be shown. Empty menu taxonomy is not an acceptance criterion.

## Browser data boundary

The accepted Admin browser uses Supabase Auth and the governed `public.admin_read(text,jsonb)` RPC. It does not perform direct internal-schema table CRUD.

Final security after-state for the v2.11 acceptance gate:

- `admin_read` is SECURITY INVOKER;
- authenticated EXECUTE = yes;
- anon EXECUTE = no;
- public SECURITY DEFINER executable by authenticated = 0;
- public SECURITY DEFINER executable by anon = 0;
- legacy `public.ui_*` SECURITY DEFINER browser execution remains retired.

Role visibility stays aligned with server-side rank checks:

- assigned CourseFinder role: Catalogue, Insights, Scholarships and permitted general reads;
- Curator+ (rank 3): Review Queue and Evidence;
- Pipeline Operator+ (rank 4): Pipeline operations, Jobs and Sources;
- PIM Admin+ (rank 5): PIM Configuration;
- Platform Admin (rank 6): privileged Platform Settings and approved operational actions.

## Accepted v2.11 operational behaviour

- semantic Dashboard icons and restrained status colour;
- Operational Pulse, Recent Activity and Attention / Next Actions;
- governed populated Provider and Course filters;
- searchable/typeable filter controls and active-filter chips;
- bounded server-side catalogue/operations paging;
- exact Course/Provider/CRICOS identity search;
- responsive navigation with independently scrollable menu and fixed identity/account regions;
- sticky decision-grid headers and identity column;
- structured Provider/Course/Campus/Scholarship detail rather than raw database-row dumps.

Course semantics continue to distinguish CRICOS registered total-course tuition from Provider-current fee observations.

## M1-PIM-FINALISATION status

**CLOSED / PASS — 20 August 2026 22:42 AEST.**

Fresh deployed browser telemetry used `/rest/v1/rpc/admin_read` with HTTP 200 in the observed acceptance window, with no new legacy `ui_*` calls or fresh 4xx/5xx responses. The operator explicitly accepted the deployed release with `v2.11 visual UAT pass`.

No ACL rollback or canonical semantic relaxation was used to obtain acceptance.

## Local setup

1. Copy `.env.example` to `.env.local`.
2. Set `VITE_SUPABASE_URL` and a **publishable/browser** `VITE_SUPABASE_PUBLISHABLE_KEY`; never use a service-role secret in the frontend.
3. Run `npm install` then `npm run dev`.
4. Production build: `npm run build`.

## Deployment note

`wrangler.jsonc` in this repository declares the separate `coursefinder-admin` target. It is **not** the live Pilot Worker source. Any future Pilot UI deployment must reconcile against `msinghbs-ai/Coursefinder-Pilot` before applying a production change.

## Governance references

- `PROJECT_INSTRUCTIONS.md`
- `docs/coursefinder-master-project-plan-v1.54.md`
- `docs/coursefinder-running-build-v2.58.md`
- `docs/coursefinder-pim-admin-guide-v1.8.md`
- `docs/uat/coursefinder-pim-admin-v2.11-final-browser-acceptance-2026-08-20.md`
- `change-control/30-admin-pim-ux/CF-CHG-20260820-015-pim-operational-ui-browser-acceptance.md`