# CourseFinder Master Project Plan v1.53

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE CANDIDATE — **M1-PIM-FINALISATION TECHNICAL PASS / DEPLOYED BROWSER BLOCKED**  
**Supersedes on this integration branch:** `docs/coursefinder-master-project-plan-v1.50.md` plus the reconciled PIM-GOV Operations/Attribute deltas  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Running build:** `docs/coursefinder-running-build-v2.57.md`

## Current programme position

The accepted AU Layer 1 canonical substrate, Layer 2 boundaries, Search isolation and established PIM field semantics remain unchanged.

The immediate UI priority is **M1-PIM-FINALISATION**, not another generic PIM-hardening pass.

## M1-PIM-FINALISATION objective

Finish the operational Admin/PIM and its deployed authenticated browser acceptance without redesigning accepted canonical semantics.

## Reconciled technical state

| Area | State |
|---|---|
| governance / open Change Controls reconciled before change | PASS |
| governed IA / menu candidate | PASS in v2.10.0 source |
| normal Catalogue server paging | PASS |
| exact Course/Provider identity search | PASS |
| Evidence bounded server page | PASS |
| Pipeline Jobs/Sources bounded server pages | PASS |
| PIM Configuration current-schema read | PASS |
| Provider related-data defect | PASS — repaired |
| Provider/Campus structured detail source | PASS |
| URL/filter/page/detail history source | PASS |
| stale-request cancellation source | PASS |
| skeleton/empty/error/retry/permission source | PASS |
| responsive/resizable/sticky UI source | PASS |
| browser internal-schema CRUD boundary | PASS |
| legacy authenticated `SECURITY DEFINER` compatibility execution | PASS — retired |
| role/rank denial UAT | PASS |
| real Node 22 / Vite production build | **PASS** |
| derived Course `Has fee` filter | **PASS — ~4.29 s → ~277 ms** |
| minimum Admin readiness 50% filter | **PASS — ~442 ms** |
| deployed Cloudflare bundle after recovery trigger | **NOT PROVEN** |
| deployed authenticated browser UAT | **BLOCKED / GATE OPEN** |

## Scale position

Two baselines must remain distinct:

- accepted AU CRICOS substrate: 1,546 Providers / 26,648 active Courses;
- current broader Pilot: 3,085 active Providers / 35,487 active Courses / 43,461 total Course rows.

Operational PIM acceptance is now assessed against the larger current catalogue rather than assuming the older AU-only scale.

## Information architecture

PIM Admin v2.10 candidate navigation:

1. Overview;
2. Catalogue — Providers, Courses, Campuses;
3. PIM Configuration — Attributes;
4. Enrichment & Insights — QILT, PRISMS;
5. Data Quality — Completeness, Review Queue;
6. Evidence;
7. Pipelines & Jobs — Pipeline Control, Jobs, Sources;
8. Scholarships;
9. Search & Publication.

Integrations and Platform Settings stay absent until a useful governed workspace exists. Dead placeholders do not satisfy the acceptance gate.

## Course performance decision

The operational Course list evaluates canonical filtering/counting/sorting before bounded page enrichment.

During finalisation, `Has fee = Yes` was found still using the old catalogue-wide rich-row fallback at ~4.29 s. Migration `m1_pim_finalisation_course_derived_filters_fast_v1` retains the same canonical predicates while evaluating normal derived filters before page enrichment.

Measured after-state:

- `Has fee = Yes` ~277 ms;
- minimum Admin readiness 50% ~442 ms;
- immediate warm default page ~259 ms;
- a cold default recheck ~2.54 s remains explicitly recorded for real initial-load/browser observation.

Fee/readiness catalogue-wide ordering remains deliberately unpromoted until independently optimised. This is an execution decision only; fee and readiness meaning is unchanged.

## Semantic regression

Post-repair authenticated checks preserve the accepted reference:

- `121174E` exact Course result = 1;
- `00025B` exact Provider result = 1;
- `121174E` CRICOS registered fees = 3 rows;
- Provider-current fees for `121174E` = 0;
- Non-Tuition Fee AUD 0 remains present.

CRICOS registered total-course fees remain distinct from Provider-current fees.

## Security position

`public.admin_read` is the promoted browser read boundary and is `SECURITY INVOKER`.

Current Pilot inspection shows zero public `SECURITY DEFINER` functions executable by authenticated or anon. Synthetic unassigned authenticated users are denied Evidence, Pipeline and PIM Configuration at the Curator/Pipeline Operator/PIM Admin thresholds.

Do not re-open direct authenticated legacy `public.ui_*` execution to make a stale client function.

## Production build position

The finalisation branch now has a real Node 22 GitHub Actions production-build gate.

The corrected workflow passes dependency installation and Vite production build; the latest build after migration 075 also passes.

## Deployed runtime blocker

Real Chrome API telemetry immediately before recovery showed a stale deployed client still calling direct legacy `ui_*` RPCs. The newest available legacy event is `ui_context` at **20 August 2026 07:00:57 UTC**, returning 403.

A no-content fast-forward commit using the unchanged accepted v2.9 tree was issued to `coursefinder-admin/main` solely to trigger the existing external Cloudflare Git-integrated rebuild:

`494a6ddcc18671abd492370410a94212c9c21deb` — **07:04:28 UTC**.

No browser API telemetry newer than that trigger is available in the current evidence set. The Worker URL cannot be opened by the available external browser tool and no Cloudflare control-plane connector is connected.

Therefore the correct current state is:

**post-trigger deployment/browser state NOT PROVEN — not a deployment failure and not a PASS.**

## PIM Change Control position

The register explicitly reclassifies `CF-CHG-001` and `005`–`015` from generic browser-pending language to the shared current blocker:

**technical/source gates passed to the extent recorded; final closure blocked by deployed authenticated browser/runtime acceptance.**

No applicable PIM record is closed from SQL, source, build or synthetic-role evidence.

## Remaining acceptance boundary

The gate requires real deployed authenticated evidence that:

- browser reads use `/rpc/admin_read` rather than direct legacy `ui_*` calls;
- no unexplained blank/slow screens exist;
- Course operation is practical at current 35k+/43k+ scale;
- exact IDs work through browser controls;
- filters/page/sort/scroll survive cross-navigation and Back/Forward;
- stale requests cannot overwrite newer results;
- responsive laptop/desktop layout is usable;
- sticky context and resizable columns work in the actual browser;
- every visible menu entry is useful or an explicit governed empty state;
- role-visible navigation matches server-side permissions.

## Preserved programme baselines

- accepted Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- QILT/PRISMS/Scholarship accepted semantics unchanged;
- Search Course Documents: 33,105;
- Search remains a governed derived projection;
- vector Search remains outside this PIM gate;
- no consumer visibility is broadened by v2.10.

## Immediate sequence

1. retain PR #5 as the v2.10 integration candidate while the deployed runtime gate is unresolved;
2. collect post-trigger deployed browser/API evidence;
3. if the deployed bundle is still stale, repair the actual Cloudflare Git/deployment source rather than weakening database ACLs;
4. run the full authenticated browser matrix;
5. record failures against the existing applicable Change Controls and retest;
6. close `001`, `005`–`015` only where their deployed criteria pass;
7. then return to the remaining non-UI Milestone 1 gates without reopening accepted PIM semantics.
