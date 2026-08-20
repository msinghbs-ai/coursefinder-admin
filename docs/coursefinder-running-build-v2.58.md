# CourseFinder Running Build v2.58

**Status:** **M1-PIM-FINALISATION CLOSED / PASS — PIM ADMIN V2.11 DEPLOYED AND BROWSER ACCEPTED**  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.57.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.9.md`  
**Final browser UAT:** `docs/uat/coursefinder-pim-admin-v2.11-final-browser-acceptance-2026-08-20.md`

## Accepted release position

M1-PIM-FINALISATION is complete. The accepted deployed Admin release is **PIM Admin v2.11.0** from the actual Cloudflare source repository:

`msinghbs-ai/Coursefinder-Pilot@b3867cc89bbfd3f76def01993a70868318016ef0`

The separate `coursefinder-admin` repository remains the governed architecture/change-control integration repository. Its finalisation history mirrors production database migrations and governance without redefining the actual Pilot Worker source.

## Browser/runtime acceptance

The earlier permission incident is closed. Root cause was a deployment-source mismatch: the live `coursefinder-pilot` Worker was still serving an older Pilot frontend that directly called retired `ui_*` RPCs.

The accepted after-state is:

- browser reads use `public.admin_read(text,jsonb)`;
- `admin_read` remains SECURITY INVOKER;
- authenticated EXECUTE = yes; anon = no;
- public SECURITY DEFINER functions executable by authenticated = 0;
- public SECURITY DEFINER functions executable by anon = 0;
- legacy `ui_*` SECURITY DEFINER functions executable by authenticated = 0;
- no internal-schema browser CRUD was introduced.

Fresh real-browser telemetry from approximately **22:37–22:41 AEST** used only `/rest/v1/rpc/admin_read` and returned HTTP 200 in the observed acceptance window. No new legacy `ui_*` calls and no fresh 4xx/5xx responses were observed.

The operator explicitly accepted the deployed visual/interaction release at **22:42 AEST** with:

**`v2.11 visual UAT pass`**

## PIM Admin v2.11 maturity release

The accepted deployed UX includes:

- semantic Dashboard icons and restrained status colour;
- Operational Pulse, Recent Activity and Attention / Next Actions;
- populated governed Provider filters;
- populated governed Course Country/State/Provider/Study Level/Field/Delivery and decision filters;
- searchable filter comboboxes and active-filter chips;
- fixed Brand/Account regions with independently scrollable navigation;
- lower menu reachability for Jobs, Sources, Attributes and Settings;
- responsive/off-canvas navigation;
- sticky decision-grid headers and identity column;
- stronger detail drawers and explicit Course fee-semantic separation.

Pilot PR `Coursefinder-Pilot#13` passed Frontend Build run #86:

- Node 22.23.2;
- npm 10.9.8;
- 0 reported vulnerabilities;
- Vite 6.4.3;
- 1,625 modules transformed;
- production build ~2.34 s.

## Governed filter and Dashboard contract

Production migration:

`20260820121633 — m1_pim_ux_maturity_filters_dashboard_v1`

Repository mirror:

`supabase/production-migrations/076_m1_pim_ux_maturity_filters_dashboard.sql`

Accepted bounded UAT:

- Provider countries: 3;
- AU Provider State/Region options: 8;
- Course countries: 3;
- AU Course State/Region options: 8;
- AU Course Provider options: 1,546;
- Study Levels: 20;
- Fields: 79;
- exact Provider `00025B`: 1;
- exact Course `121174E`: 1;
- Dashboard recent activity: 10 bounded records;
- AU Course filter operation: ~234.6 ms DB-side;
- enhanced Dashboard: ~51.2 ms DB-side.

## Course-scale and semantic regression

Previously accepted finalisation performance remains in force:

- default Course page warm sample ~259 ms;
- `Has fee = Yes` ~277 ms after migration 075, from ~4.29 s before optimisation;
- minimum Admin readiness 50% ~442 ms;
- exact `121174E` remains one Course;
- exact `00025B` remains one Provider;
- `121174E` retains 3 CRICOS registered fee rows and 0 Provider-current rows;
- Non-Tuition Fee AUD 0 remains preserved.

CRICOS registered total-course fees remain distinct from Provider-current fee observations.

## Change Control closure

The authoritative PIM finalisation register classifies:

- `CF-CHG-20260820-001`;
- `CF-CHG-20260820-005` through `CF-CHG-20260820-015`

as **CLOSED / PASS** for their accepted PIM scopes because the shared deployed authenticated browser gate passed.

`CF-CHG-20260820-013` is specifically reconciled as CLOSED / PASS for the original role-boundary/safe-Sources scope. Residual Pipeline-specific rank-4 browser/action acceptance is carried by `CF-CHG-20260821-016` rather than reopening the accepted PIM release.

## Preserved programme baselines

- AU CRICOS accepted baseline: 1,546 Providers / 26,648 active Courses;
- broader Pilot at finalisation: 3,085 active Providers / 35,487 active Courses / 43,461 total Course rows;
- accepted Layer 1 AU adapter: `layer1-au-depth-v1.6.0`;
- Search Course Documents: 33,105;
- QILT, PRISMS and Scholarship accepted semantics unchanged;
- Search remains a governed derived projection;
- vector Search remains outside this PIM gate;
- no consumer publication scope was broadened by PIM finalisation.

## M1-PIPELINE-OPS governance handoff

On 21 August 2026 the Pipeline Operations governance ambiguity was reconciled without changing this deployed build.

Current Pipeline Ops entry point:

`docs/coursefinder-m1-pipeline-ops-governance-baseline-v1.0.md`

Current Pipeline Ops Change Control:

`CF-CHG-20260821-016`

This is a governance handoff only. No Pipeline runtime, ACL, source configuration, canonical data or deployed frontend change is claimed by the v2.58 documentation update.

## Current gate

**M1-PIM-FINALISATION: CLOSED / PASS.**  
**M1-PIPELINE-OPS governance baseline: RESOLVED; implementation not started.**
