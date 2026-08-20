# CourseFinder Master Project Plan v1.54

**Status:** **AUTHORITATIVE PROGRAMME GOVERNANCE — M1-PIM-FINALISATION CLOSED / PASS**  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.53.md`  
**Last consolidated:** 20 August 2026 22:42 AEST  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Running build:** `docs/coursefinder-running-build-v2.58.md`

## Current programme position

The accepted AU Layer 1 canonical substrate, Layer 2 boundaries, Search isolation and established PIM field semantics remain unchanged.

**M1-PIM-FINALISATION is complete.** The operational Admin/PIM now has technical, build, deployed runtime and explicit operator visual acceptance.

## M1-PIM-FINALISATION result

| Area | Final state |
|---|---|
| governance / Change Controls reconciled | PASS |
| governed Admin information architecture | PASS |
| normal Catalogue server paging | PASS |
| exact Course/Provider identity search | PASS |
| Evidence bounded server page | PASS |
| Pipeline Jobs/Sources bounded server pages | PASS |
| PIM Configuration governed read | PASS |
| Provider related-data contract | PASS |
| responsive/sticky operational UI | PASS |
| governed Provider/Course filter options | PASS |
| mature Dashboard operational hierarchy | PASS |
| browser internal-schema CRUD boundary | PASS |
| legacy authenticated SECURITY DEFINER compatibility execution | PASS — retired |
| role/rank denial UAT | PASS |
| real Node 22 production build | PASS |
| derived Course `Has fee` filter | PASS — ~4.29 s → ~277 ms |
| minimum Admin readiness 50% | PASS — ~442 ms |
| actual Cloudflare deployment source alignment | PASS |
| governed real-browser `/rpc/admin_read` runtime | PASS |
| deployed visual/interaction UAT | **PASS — operator accepted 22:42 AEST** |

## Accepted deployed Admin release

The actual Pilot Worker source is:

`msinghbs-ai/Coursefinder-Pilot`

Accepted release head:

`b3867cc89bbfd3f76def01993a70868318016ef0`

Visible release marker:

`PIM Admin v2.11 · governed`

The deployment-source mismatch that previously left v1.7.2 live is resolved. The separate `coursefinder-admin` repository remains the architecture, migration-mirror and Change Control integration repository rather than being treated as the Pilot Worker source.

## Browser and security position

The promoted browser read boundary remains:

`public.admin_read(text,jsonb)`

Final after-state:

- SECURITY INVOKER;
- authenticated EXECUTE yes;
- anon EXECUTE no;
- public SECURITY DEFINER executable by authenticated = 0;
- public SECURITY DEFINER executable by anon = 0;
- legacy `ui_*` SECURITY DEFINER executable by authenticated = 0;
- no internal-schema browser CRUD.

Fresh real-browser telemetry from approximately **22:37–22:41 AEST** used only `/rest/v1/rpc/admin_read` with HTTP 200 in the observed acceptance window. No new direct legacy `ui_*` calls or fresh 4xx/5xx responses were observed.

No ACL rollback was required.

## PIM Admin v2.11 operational UX

Accepted deployed capabilities include:

1. Dashboard semantic icons and restrained colour hierarchy;
2. Operational Pulse, Recent Activity and Attention / Next Actions;
3. governed Provider Country/State filters;
4. governed Course Country/State/Provider/Study Level/Field/Delivery and decision filters;
5. searchable filter comboboxes and active-filter chips;
6. fixed Brand/Account regions and independently scrollable navigation;
7. responsive/off-canvas navigation;
8. sticky decision-grid headers/identity and improved detail interaction;
9. role-aware Evidence, Review Queue, Jobs, Sources, Attributes and Settings reachability.

Pilot Frontend Build run #86 passed on Node 22.23.2 with 0 reported vulnerabilities.

## Data/filter UAT position

Production migration:

`20260820121633 — m1_pim_ux_maturity_filters_dashboard_v1`

Accepted bounded results:

- AU Provider State/Region options = 8;
- AU Course State/Region options = 8;
- AU Course Provider options = 1,546;
- Study Levels = 20;
- Fields = 79;
- exact Provider `00025B` = 1;
- exact Course `121174E` = 1;
- enhanced Dashboard recent activity = 10;
- AU Course filter operation ~234.6 ms DB-side;
- enhanced Dashboard ~51.2 ms DB-side.

## Scale position

The programme continues to distinguish:

- accepted AU CRICOS substrate: 1,546 Providers / 26,648 active Courses;
- broader Pilot at PIM finalisation: 3,085 active Providers / 35,487 active Courses / 43,461 total Course rows.

Operational Admin acceptance was performed against the broader current catalogue rather than assuming the AU-only substrate.

## Semantic position

Accepted reference regressions remain:

- `121174E` exact Course result = 1;
- `00025B` exact Provider result = 1;
- `121174E` CRICOS registered fees = 3 rows;
- Provider-current fees for `121174E` = 0;
- Non-Tuition Fee AUD 0 remains present.

CRICOS registered total-course fees remain distinct from Provider-current fee observations. Provider/Course identity, provenance, Search admission and publication authority were not changed to achieve UI acceptance.

## Change Control position

The authoritative Change Control register closes the shared Admin/PIM browser gate for:

`CF-CHG-20260820-001` and `CF-CHG-20260820-005` through `CF-CHG-20260820-015`.

`CF-CHG-20260820-015` is the final shared browser acceptance record. Earlier predecessor browser-pending notes are superseded by this final PASS only for that common gate; their established semantic decisions remain authoritative.

Final browser UAT:

`docs/uat/coursefinder-pim-admin-v2.11-final-browser-acceptance-2026-08-20.md`

## Preserved programme baselines

- accepted Layer 1 AU adapter: `layer1-au-depth-v1.6.0`;
- QILT/PRISMS/Scholarship accepted semantics unchanged;
- Search Course Documents: 33,105;
- Search remains a governed derived projection;
- vector Search remains outside this PIM closure;
- no consumer visibility is broadened by this Admin/PIM gate.

## Immediate sequence

With M1-PIM-FINALISATION closed:

1. retain the accepted PIM semantic and security boundaries;
2. do not reopen legacy browser RPC execution;
3. continue the remaining non-UI Milestone 1 gates, including Search/vector and outstanding enrichment/source-qualification work, under their own Change Controls;
4. treat future Admin changes as new governed deltas rather than reopening this accepted gate unless a regression is proven.