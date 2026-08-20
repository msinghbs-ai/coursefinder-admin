# CF-CHG-20260820-015 — PIM operational UI and browser acceptance finalisation

**Status:** **CLOSED / PASS — PIM ADMIN V2.11 DEPLOYED BROWSER + VISUAL ACCEPTANCE COMPLETE**  
**Category:** `30-admin-pim-ux`  
**Initiated:** 20 August 2026 15:04 AEST  
**Origin:** `M1-PIM-FINALISATION — Admin/PIM Operational UI & Browser Acceptance Gate`  
**Owner:** CourseFinder Admin/PIM governance  
**UI candidate:** PIM Admin v2.11.0  
**Last updated:** 20 August 2026 22:42 AEST

## Governing boundary

This work continues from accepted PIM v2.9.0 semantics. It does **not** redefine Provider/Course identity, CRICOS fee semantics, intake/English semantics, taxonomy authority, Scholarship semantics, lifecycle/publication/readiness/Search separation or Evidence provenance meaning.

`public.admin_read(text,jsonb)` remains the normal browser read boundary. Internal schemas are not promoted as browser CRUD surfaces.

## Reconciliation performed before change

The gate was reconciled against:

- `PROJECT_INSTRUCTIONS.md` on `main`;
- current master plan / running build / architecture / Admin guide;
- Admin/PIM design decisions v1.10 and IA v1.1;
- all open `30-admin-pim-ux` records 001 and 005–014;
- current `coursefinder-admin/main` and the v2.10 integration branch;
- the separate `Coursefinder-Pilot` repository;
- live `coursefinder_Pilot` Supabase migrations, functions, grants and API telemetry.

Several filenames referenced by `PROJECT_INSTRUCTIONS.md` are stale or absent on `main`; no missing governance content was invented. The latest matching current documents were used where present.

## Defects confirmed

- Evidence v2.5 could request up to 2,000 rows and filter locally.
- Operations/PIM compatibility paths could request four-digit row sets.
- v2.9 navigation/filter/detail state was largely in-memory.
- stale-request cancellation / consistent skeleton-error-retry behaviour was incomplete.
- Provider detail read `rows` from helpers returning `items`, causing false empty related-data displays.
- the old default 50-row Course page measured about 5.27 s DB-side.
- normal derived Course filters could fall back to full rich-row evaluation; `Has fee = Yes` measured about 4.29 s DB-side during finalisation recheck.
- Search/Publication had a cold wide-table aggregation path.
- legacy `public.ui_*` `SECURITY DEFINER` browser execution remained incompatible with the promoted `admin_read` boundary until retired.
- real Chrome API telemetry proved the deployed bundle was still calling legacy `ui_*` RPCs immediately before the governed redeploy trigger.
- after RPC recovery, the deployed v1.7-era shell still lacked the visual hierarchy, recent operational activity, populated governed Provider/Course filters and resilient sidebar navigation required for mature Admin acceptance.

## Applied finalisation contract

### PIM Admin v2.10 operational shell

The candidate information architecture is:

- Overview;
- Catalogue — Providers, Courses, Campuses;
- PIM Configuration — Attributes;
- Enrichment & Insights — QILT, PRISMS;
- Data Quality — Completeness, Review Queue;
- Evidence;
- Pipelines & Jobs — Pipeline Control, Jobs, Sources;
- Scholarships;
- Search & Publication.

Dead Integrations / Platform Settings placeholders were not added merely to satisfy a taxonomy.

The shell provides URL/history-backed state, browser Back/Forward support, scroll restoration, request cancellation, debounced search, loading skeletons, explicit empty/error/retry/permission states, responsive navigation, sticky table/context regions, persisted resizable columns and structured Provider/Campus detail. Accepted Course and Scholarship semantic panels remain in use.

### Course scale

The Course read path now filters/counts/sorts canonical rows before bounded page enrichment. Normal derived filters are also evaluated before page enrichment without changing their governed meanings.

Measured Pilot DB-side samples:

| Path | Measured |
|---|---:|
| old default Course page, 50 | ~5,272 ms |
| current default Course page, warm sample | ~259 ms |
| current default Course page, cold sample during recheck | ~2,536 ms |
| `Has fee = Yes` before final derived-filter repair | ~4,287 ms |
| `Has fee = Yes` after migration 075 | **~277 ms** |
| minimum Admin readiness 50% after migration 075 | **~442 ms** |
| exact CRICOS `121174E` earlier bounded sample | ~167 ms |
| Provider page, 50 | ~212 ms |
| Campus page, 50 | ~109 ms |
| Evidence page, 50 | ~134 ms |
| Pipeline Jobs page, 50 | ~517 ms |
| Pipeline Sources page, 50 | ~32 ms |
| QILT page, 50 | ~157 ms |
| PRISMS page, 50 | ~297 ms |
| PIM Configuration | ~28 ms |

The cold default Course sample is explicitly recorded rather than hidden. v2.10 renders loading progress instead of a blank screen; real network/browser latency remains part of deployed UAT.

Migration applied to Pilot:

`m1_pim_finalisation_course_derived_filters_fast_v1`

Repository mirror:

`supabase/production-migrations/075_m1_pim_finalisation_course_derived_filters_fast.sql`

Fee/readiness *ordering* remains intentionally unpromoted in the normal v2.10 grid; their accepted calculations are not redefined.

## Exact identity / semantic regression

Post-repair authenticated regression under the assigned Platform Admin identity:

- exact Course query `121174E` → 1 Course;
- exact Provider query `00025B` → 1 Provider;
- `121174E` CRICOS registered fee rows → 3;
- Provider-current fee rows for `121174E` → 0;
- semantic-review/other fee rows → 0;
- Non-Tuition Fee AUD 0 row remains present.

No CRICOS registered amount was substituted into the Provider-current fee section.

## Security regression

Live Pilot after-state:

- `public.admin_read` is `SECURITY INVOKER` and executable by `authenticated`;
- zero public `SECURITY DEFINER` functions are executable by `authenticated`;
- zero public `SECURITY DEFINER` functions are executable by `anon`;
- no browser internal-schema CRUD was introduced.

A synthetic authenticated identity with no CourseFinder assignment received SQLSTATE `42501` for:

- Evidence — `curator role required`;
- Pipeline Jobs — `pipeline_operator role required`;
- PIM Configuration — `pim_admin role required`.

Do not restore broad direct authenticated execution of legacy `public.ui_*` helpers to make an old browser bundle work.

## Production build gate

A real GitHub Actions production-build gate was added to the v2.10 integration branch.

Initial workflow configuration failed before application build because the repository has no lockfile and `setup-node` npm caching required one. The workflow was corrected to the repository's actual dependency model.

Final CI result:

- Node 22.23.2;
- `npm install --ignore-scripts` — PASS, 0 reported vulnerabilities;
- `npm run build` — PASS;
- Vite 8.1.5;
- 65 modules transformed;
- production bundle emitted successfully.

The latest branch build after migration 075 also passed.

## Deployed frontend evidence

Immediately before recovery, Supabase API logs from the real Windows Chrome client showed direct calls such as:

- `/rest/v1/rpc/ui_context`;
- `/rest/v1/rpc/ui_dashboard`;
- `/rest/v1/rpc/ui_courses_decision_page`;
- `/rest/v1/rpc/ui_course_filter_options`;
- legacy QILT/PRISMS helpers.

The newest observed legacy request in the original log batch was **20 August 2026 07:00:57 UTC**, returning HTTP 403 for `ui_context`.

This proved that the deployed browser bundle was stale **before** the first recovery trigger.

### Governed redeploy triggers

An initial no-content fast-forward commit was applied to `coursefinder-admin/main` using the unchanged v2.9 tree:

`494a6ddcc18671abd492370410a94212c9c21deb`

Commit time: **20 August 2026 07:04:28 UTC**.

A second governed redeploy trigger was issued after explicit operator approval, again preserving the exact same v2.9 application tree and changing no ACL or application code:

`eae32edab4ef9395b0584370ac62b6a0f5988ca3`

Commit time: **20 August 2026 08:07:02 UTC / 18:07 AEST**.

Post-trigger technical regression under the assigned Platform Admin identity remained PASS:

- `admin_read('context')` → `platform_admin`, role rank 6;
- exact Provider `00025B` → 1 Provider;
- Provider detail → 382 related Courses;
- exact Course `121174E` → 1 Course;
- Course detail → 3 CRICOS registered fee rows, 0 Provider-current rows, 0 semantic-review/other rows;
- `admin_read` remains executable by `authenticated` and denied to `anon`;
- zero public `SECURITY DEFINER` functions are executable by `authenticated` or `anon`.

The only remaining directly executable legacy `ui_*` functions for `authenticated` are the two `ui_providers_page` overloads, both `SECURITY INVOKER`; no legacy `ui_*` `SECURITY DEFINER` surface was reopened.

## Confirmed deployment-source mismatch — 20 August 2026 18:22 AEST

A fresh authenticated browser retest after the second `coursefinder-admin/main` trigger still displayed **UI v1.7.2** and the visible error `permission denied for function ui_context`.

Fresh Supabase telemetry from the retest showed direct browser requests after the 18:07 AEST trigger, including:

- `ui_context` — 403;
- `ui_dashboard` — 403;
- `ui_provider_filter_options` — 403;
- `ui_courses_decision_page` / `ui_course_filter_options` — 403;
- QILT page/filter helpers — 403;
- PRISMS page/filter helpers — 403;
- `ui_attributes_list` — 403.

The deployed Worker was then reconciled against the actual implementation repository. The live `coursefinder-pilot` Worker is governed by `msinghbs-ai/Coursefinder-Pilot/wrangler.jsonc`, while `coursefinder-admin/wrangler.jsonc` declares a different Worker name (`coursefinder-admin`). The deployed Pilot repository `main` was still at `464f9c3c3a6634daca9783f8b00048950eca4719`, whose browser adapter directly invoked legacy `ui_*` RPCs.

**Root cause:** deployment-source mismatch, not Supabase canonical data failure and not a need to restore retired ACLs.

## Governed `Coursefinder-Pilot` recovery — APPLIED

Explicit operator approval was received to align the actual Pilot deployment repository with the governed browser read boundary.

Recovery branch:

`fix/governed-admin-read-recovery-20260820`

Pilot PR:

`msinghbs-ai/Coursefinder-Pilot#12`

Recovery scope was deliberately limited to two browser-facing files:

- `src/lib/supabase.js` — all browser database reads now enter through `public.admin_read(text,jsonb)`; direct legacy `ui_*` browser RPC calls were removed from the adapter;
- `index.html` — visible `Governed RPC recovery r1` runtime marker added for deployed-build correlation.

No Supabase ACL, migration, canonical data, Provider/Course identity, source authority, Search admission or Edge Function operational write contract changed.

Legacy Provider/Course filter-option selectors that did not yet have a governed `admin_read` filter-options contract were intentionally presented with non-authoritative empty option sets rather than re-opening retired RPC permissions. Governed search/paging/exact identity reads continued through catalogue page operations.

### Recovery build / DB contract UAT

`Coursefinder-Pilot` GitHub Actions `Pilot Frontend Build` run #84 completed successfully at recovery head:

`a27c74543456f73be9159ea8b1772188da3330fc`

A bounded authenticated Platform Admin transaction also exercised the recovery operations without mutation:

- `context` → `platform_admin` — PASS;
- `dashboard` → Providers 3,085 — PASS;
- exact `providers_page` query `00025B` → total 1 — PASS;
- exact `courses_page` query `121174E` → total 1 — PASS;
- `qilt_outcomes` + `qilt_filters` — PASS;
- `prisms_student_flow` — PASS;
- `evidence_page` — PASS;
- `reviews_page` — valid governed result — PASS;
- `attributes` — governed payload returned — PASS;
- `jobs` — PASS;
- `sources` → 54 rows — PASS.

After build PASS and a final recheck that `Coursefinder-Pilot/main` had not moved, `main` was fast-forwarded without force to:

`a27c74543456f73be9159ea8b1772188da3330fc`

at approximately **20 August 2026 18:33 AEST**. GitHub records PR #12 as merged at the same head.

Subsequent real browser telemetry proved the recovery boundary itself: the deployed browser switched to `/rest/v1/rpc/admin_read` and returned HTTP 200 responses. The permission/deployment-source incident is therefore no longer the active blocker.

Detailed recovery UAT:

`docs/uat/coursefinder-pilot-governed-rpc-recovery-uat-2026-08-20.md`

## PIM Admin v2.11 UX maturity remediation — APPLIED

The post-recovery visual review identified a separate maturity gap: the recovered shell loaded real data but lacked semantic Dashboard hierarchy, recent operational activity, populated Provider/Course filter selectors and robust lower-navigation accessibility.

Explicit operator approval was received to proceed with the Admin UX maturity pass, governed filters and Dashboard operations under this existing Change Control.

### Governed filter / Dashboard contract

Production migration:

`20260820121633 — m1_pim_ux_maturity_filters_dashboard_v1`

Repository mirror:

`supabase/production-migrations/076_m1_pim_ux_maturity_filters_dashboard.sql`

Additive `admin_read` routes:

- `provider_filters`;
- `course_filters`;
- enhanced `dashboard` response with bounded operational counters/freshness and recent activity.

Bounded authenticated UAT:

- Provider countries → 3;
- AU Provider State/Region options → 8;
- Course countries → 3;
- AU Course State/Region options → 8;
- AU Course Provider options → 1,546;
- Course Study Levels → 20;
- Course Fields → 79;
- Delivery modes → 1;
- exact Provider `00025B` → 1;
- exact Course `121174E` → 1;
- enhanced Dashboard recent activity → 10 bounded records.

Measured DB-side:

- AU Course filter options → **~234.6 ms**;
- enhanced Dashboard → **~51.2 ms**.

Security after-state remains:

- `admin_read` SECURITY INVOKER;
- authenticated EXECUTE yes / anon no;
- public SECURITY DEFINER executable by authenticated = 0;
- public SECURITY DEFINER executable by anon = 0;
- legacy `ui_*` SECURITY DEFINER executable by authenticated = 0.

### PIM Admin v2.11 browser implementation

Pilot branch:

`m1-pim-ux-maturity-v2-11-20260820`

Pilot PR:

`msinghbs-ai/Coursefinder-Pilot#13`

Published head:

`b3867cc89bbfd3f76def01993a70868318016ef0`

Applied UX:

- semantic icons and restrained colour hierarchy;
- operational-health state, pulse counters, recent activity and attention/next-action Dashboard sections;
- governed populated Provider filters;
- governed populated Course Country/State/Provider/Study Level/Field/Delivery and decision filters;
- searchable filter comboboxes and active-filter chips;
- fixed brand/account regions with an independently scrollable middle navigation, preventing Jobs/Sources/Attributes/Settings from disappearing below the viewport;
- responsive off-canvas navigation for narrower screens;
- sticky decision-grid headers and identity column;
- stronger detail drawer and explicit Course fee-semantic separation;
- existing privileged Platform Settings operational component and Edge Function write path retained.

Visible runtime marker:

`PIM Admin v2.11 · governed`

`Pilot Frontend Build` run #86 — **PASS**:

- Node 22.23.2;
- npm 10.9.8;
- 0 vulnerabilities;
- Vite 6.4.3;
- 1,625 modules transformed;
- production build completed in ~2.34 s.

PR source review found no direct `ui_*` browser RPC calls in the v2.11 change set.

After build PASS and confirmation Pilot `main` had not moved, `Coursefinder-Pilot/main` was fast-forwarded without force to `b3867cc89bbfd3f76def01993a70868318016ef0` at approximately **20 August 2026 22:24 AEST**. GitHub records PR #13 as merged at the same head.

Detailed maturity UAT:

`docs/uat/coursefinder-pim-admin-v2.11-ux-maturity-uat-2026-08-20.md`

## Final deployed browser acceptance — PASS

The operator loaded the Cloudflare-served v2.11 release and confirmed the visible runtime marker `PIM Admin v2.11 · governed`.

Fresh authenticated browser telemetry from approximately **20 August 2026 22:37–22:41 AEST** showed only governed requests to:

`/rest/v1/rpc/admin_read`

All observed requests in the fresh acceptance window returned **HTTP 200**. No new direct legacy `ui_*` RPC calls and no fresh 4xx/5xx responses were observed.

The operator then explicitly declared:

**`v2.11 visual UAT pass`**

This closes the visual/interaction criteria covering the mature Dashboard hierarchy, populated governed Provider/Course filters, exact identity search, lower-navigation reachability, responsive navigation and detail/table interaction. No security or authority exception was required to obtain acceptance.

Final deployed release head:

`msinghbs-ai/Coursefinder-Pilot@b3867cc89bbfd3f76def01993a70868318016ef0`

Final browser acceptance UAT:

`docs/uat/coursefinder-pim-admin-v2.11-final-browser-acceptance-2026-08-20.md`

## Closure

**Final status:** **CLOSED / PASS — DB/RPC/SECURITY/BUILD/DEPLOYED BROWSER/VISUAL UAT COMPLETE.**

`CF-CHG-20260820-001` and `005`–`014` may now be closed because their shared deployed authenticated browser gate has passed. Their accepted semantic boundaries are not reopened or redefined by this closure.

No Supabase ACL rollback was performed. `public.admin_read(text,jsonb)` remains the browser read boundary, legacy `ui_*` SECURITY DEFINER browser execution remains retired, and no internal-schema browser CRUD was introduced.