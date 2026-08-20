# CourseFinder PIM Admin v2.11 UX Maturity UAT — 20 August 2026

**Change Control:** `CF-CHG-20260820-015`  
**Origin:** `M1-PIM-FINALISATION — Admin/PIM Operational UI & Browser Acceptance Gate`  
**Runtime target:** `coursefinder-pilot.techm.workers.dev`  
**Deployment repository:** `msinghbs-ai/Coursefinder-Pilot`  
**Status:** **APPLIED — DB/SECURITY/BUILD PASS; DEPLOYED VISUAL/BROWSER ACCEPTANCE PENDING**

## 1. Trigger for maturity remediation

The governed RPC recovery succeeded: post-recovery browser telemetry showed the deployed Pilot using `/rest/v1/rpc/admin_read` with HTTP 200 responses instead of retired direct `ui_*` calls.

The subsequent authenticated visual review identified a separate UX acceptance failure:

- Dashboard cards had data but lacked semantic icons, useful colour hierarchy and operational engagement;
- no recent activity or attention/next-action layer was visible;
- Provider and Course governed filter option sets were intentionally empty after the emergency RPC recovery;
- sidebar scrolling could leave Jobs / Settings inaccessible;
- the deployed interface still felt like a recovery shell rather than a mature decision/operations workspace.

This work therefore advances the existing `CF-CHG-20260820-015` record rather than opening a competing change.

## 2. Governed read extension

Production migration applied:

`20260820121633 — m1_pim_ux_maturity_filters_dashboard_v1`

Repository mirror:

`supabase/production-migrations/076_m1_pim_ux_maturity_filters_dashboard.sql`

The migration adds only private role-checked read helpers and additive `public.admin_read` routes:

- `provider_filters`;
- `course_filters`;
- enhanced `dashboard` response with bounded operational summary and recent activity.

It does **not** alter Provider/Course identity, source authority, Search admission, canonical values or legacy `ui_*` browser ACLs.

### Filter-option UAT

Authenticated Platform Admin bounded checks returned:

| Contract | Result |
|---|---:|
| Provider countries | 3 |
| AU Provider State/Region options | 8 |
| Course countries | 3 |
| AU Course State/Region options | 8 |
| AU Course Provider options | 1,546 |
| Course Study Level options | 20 |
| Course Field options | 79 |
| Delivery modes | 1 |
| exact Provider `00025B` | 1 |
| exact Course `121174E` | 1 |

Measured DB-side samples:

- `admin_read('course_filters', {'country_code':'AU'})` — **~234.6 ms**;
- enhanced `admin_read('dashboard')` — **~51.2 ms**.

Dashboard response returned 10 bounded recent-activity records plus operational counters/freshness fields.

## 3. Security regression

Post-migration live after-state:

- `public.admin_read(text,jsonb)` remains **SECURITY INVOKER**;
- `authenticated` EXECUTE on `admin_read` — **yes**;
- `anon` EXECUTE on `admin_read` — **no**;
- public SECURITY DEFINER functions executable by `authenticated` — **0**;
- public SECURITY DEFINER functions executable by `anon` — **0**;
- legacy `public.ui_*` SECURITY DEFINER functions executable by `authenticated` — **0**.

No browser internal-schema CRUD was introduced.

## 4. PIM Admin v2.11 frontend maturity implementation

Pilot branch:

`m1-pim-ux-maturity-v2-11-20260820`

Pilot PR:

`msinghbs-ai/Coursefinder-Pilot#13`

Published head:

`b3867cc89bbfd3f76def01993a70868318016ef0`

Applied browser UX:

- semantic icons and restrained colour hierarchy across Dashboard/navigation/cards;
- operational-health state and attention-first messaging;
- recent Jobs / Reviews / Evidence activity feed;
- operational pulse for running/failed/completed jobs and evidence captured in the last 24 hours;
- freshness signals for latest job/evidence/Search projection;
- Dashboard cross-links into operational workspaces;
- governed Provider filters: Country, State/Region, lifecycle and publication;
- governed Course filters: Country, State/Region, Provider, Study Level, Field, Delivery, fee/intake/English/scholarship presence, readiness, freshness, lifecycle and publication;
- searchable filter comboboxes and active-filter chips;
- fixed brand/account regions and independently scrollable navigation so lower Operations items remain reachable;
- responsive off-canvas navigation for narrower screens;
- sticky decision-grid headers and identity column;
- improved detail drawer and explicit Course fee-semantic separation;
- existing privileged Platform Settings component and Edge Function operational write paths retained.

Visible runtime marker:

`PIM Admin v2.11 · governed`

## 5. Production build gate

GitHub Actions `Pilot Frontend Build` run #86 — **PASS**.

- Node 22.23.2;
- npm 10.9.8;
- `npm install --ignore-scripts` — PASS;
- 0 reported vulnerabilities;
- Vite 6.4.3 production build — PASS;
- 1,625 modules transformed;
- JS bundle ~454.67 kB / 127.49 kB gzip;
- CSS bundle ~45.21 kB / 9.14 kB gzip;
- build completed in ~2.34 s.

PR source review found no direct `ui_*` browser RPC call in the v2.11 change set.

After build PASS and confirmation that Pilot `main` had not moved, `Coursefinder-Pilot/main` was fast-forwarded without force to `b3867cc89bbfd3f76def01993a70868318016ef0` at approximately 20 August 2026 22:24 AEST. GitHub records PR #13 as merged at the same head.

## 6. Remaining deployed visual/browser acceptance

Do not classify the maturity gate PASS until the Cloudflare-served authenticated browser proves:

1. visible marker is `PIM Admin v2.11 · governed`;
2. Dashboard displays icons, restrained semantic colour, operational pulse, recent activity and attention cards;
3. Provider Country/State filters contain governed values and materially filter results;
4. Course Country/State/Provider/Study Level/Field/Delivery and decision filters contain governed values and materially filter results;
5. exact `00025B` and `121174E` remain searchable;
6. sidebar Brand and Account remain fixed while the middle navigation scrolls, with Jobs / Sources / Attributes / Settings reachable;
7. tablet/mobile navigation opens as an off-canvas menu and remains usable;
8. no unexplained 403/permission regressions occur;
9. browser network continues to use `/rpc/admin_read` rather than retired direct `ui_*` calls;
10. no material blank/slow/overlapping states are observed at current catalogue scale.

## Verdict

**APPLIED — DB/SECURITY/BUILD PASS. DEPLOYED VISUAL/BROWSER ACCEPTANCE PENDING.**
