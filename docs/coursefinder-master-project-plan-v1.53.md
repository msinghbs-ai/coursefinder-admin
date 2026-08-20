# CourseFinder Master Project Plan v1.53

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE CANDIDATE — PIM BROWSER GATE OPEN  
**Supersedes on this integration branch:** `docs/coursefinder-master-project-plan-v1.50.md` plus the independently developed PIM-GOV Operations/Attribute deltas  
**Last consolidated:** 20 August 2026 15:51 AEST  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Running build:** `docs/coursefinder-running-build-v2.57.md`

## Current programme position

The accepted AU Layer 1 canonical substrate, Layer 2 semantic boundaries, Search isolation and established PIM field semantics remain unchanged.

The immediate UI priority is now **M1-PIM-FINALISATION**, not another generic PIM-hardening pass.

## M1-PIM-FINALISATION gate

### Objective

Finish PIM Admin deployed-browser acceptance and make the Admin practical as a responsive operational PIM at the accepted 26k+ Course scale without redesigning canonical field semantics.

### Technical state

| Area | State |
|---|---|
| governed IA / menu source | PASS in v2.10.0 |
| normal Catalogue server paging | PASS |
| exact Course/Provider identity search | PASS |
| normal Course DB performance | PASS — ~5.27 s → ~260 ms for default 50-row page |
| Evidence bounded server page | PASS |
| Pipeline Jobs/Sources bounded server pages | PASS |
| PIM Configuration current-schema read | PASS |
| Provider related-data defect | PASS — repaired |
| Provider/Campus structured detail source | PASS |
| URL/filter/page/detail browser-history source | PASS |
| stale-request cancellation source | PASS |
| skeleton/empty/error/retry/permission source | PASS |
| responsive/resizable/sticky UI source | PASS |
| internal browser CRUD boundary | PASS |
| legacy authenticated SECURITY DEFINER compatibility execution | PASS — retired |
| role/rank SQL denial UAT | PASS |
| deployed Cloudflare build/runtime | PENDING |
| deployed authenticated browser UAT | **PENDING / GATE BLOCKER** |

### Acceptance rule

Source/DB/RPC/security/performance success is necessary but not sufficient. The PIM finalisation gate closes only after the deployed authenticated browser proves:

- no unexplained blank/slow screens;
- practical 26k Course operation;
- filters/page/sort/scroll survive cross-navigation and Back/Forward;
- exact IDs work through browser controls;
- desktop/laptop responsive behaviour;
- no stale-response overwrite;
- all visible menu entries useful;
- permissions visually and server-side aligned.

## PIM Change Control position

| Change | State after v2.10 source integration |
|---|---|
| CF-CHG-001 Fee/Admin semantics | retained; deployed browser UAT pending |
| CF-CHG-005 QILT/PRISMS | retained; deployed browser UAT pending |
| CF-CHG-006 Evidence | v2.10 operational source integrated; deployed browser UAT pending |
| CF-CHG-007 Catalogue paging/exact identity | DB/performance + v2.10 source PASS; deployed browser UAT pending |
| CF-CHG-008 Geography | retained in structured detail; deployed browser UAT pending |
| CF-CHG-009 Intake/English | retained; deployed browser UAT pending |
| CF-CHG-010 Taxonomy | retained; deployed browser UAT pending |
| CF-CHG-011 Scholarship semantics | retained; deployed browser UAT pending |
| CF-CHG-012 Lifecycle/publication/readiness/Search | retained; deployed browser UAT pending |
| CF-CHG-013 Operations role boundary | DB/RPC/security + v2.10 role source PASS; deployed role-browser UAT pending |
| CF-CHG-014 Attribute/Completeness governance | corrected DB mapping + v2.10 presentation source PASS; deployed browser UAT pending |
| CF-CHG-015 Operational UI/browser finalisation | DB/RPC/security/performance + source PASS; deployed browser UAT pending |

No applicable PIM record is marked CLOSED from synthetic/source evidence.

## Information architecture decision

The v2.10 navigation is:

1. Overview;
2. Catalogue — Providers, Courses, Campuses;
3. PIM Configuration — Attributes;
4. Enrichment & Insights — QILT, PRISMS;
5. Data Quality — Completeness, Review Queue;
6. Evidence;
7. Pipelines & Jobs — Pipeline Control, Jobs, Sources;
8. Scholarships;
9. Search & Publication.

Integrations and Platform Settings remain absent until a governed useful workspace exists. A dead placeholder is worse than an incomplete taxonomy.

## Performance decision

The normal Course list uses a paged-enrichment execution model. Derived catalogue-wide fee/completeness sorts remain semantically correct but are withheld from normal clickable grid sorting until independently optimised.

This is an operational performance decision only; it does not change fee or readiness meaning.

## Security decision

`public.admin_read` is the browser read boundary. Role visibility in React mirrors but does not replace server rank checks.

Legacy `public.ui_*` SECURITY DEFINER browser EXECUTE is retired. Internal schemas remain non-browser CRUD surfaces.

Supabase leaked-password protection remains a separate platform warning and should be resolved under Platform/Auth security governance rather than falsely closed through the PIM UI gate.

## Preserved programme baselines

- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- accepted Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- CRICOS registered total-course fee remains distinct from Provider-current fee;
- QILT/PRISMS/Scholarship accepted semantics unchanged;
- Search Course Documents observed during finalisation: 33,105;
- Search remains a governed derived projection;
- vector Search remains outside this PIM gate;
- no consumer visibility is broadened by v2.10.

## Immediate sequence

1. complete integration-branch repository reconciliation;
2. create/review the v2.10 pull request without force-push history rewriting;
3. deploy through the existing Cloudflare Git/Worker path;
4. run the deployed authenticated browser matrix across normal assigned role, Curator, Pipeline Operator and PIM Admin where accounts are available;
5. record failures against the applicable Change Control and retest;
6. close 001/005–015 only where their deployed acceptance criteria actually pass;
7. then return to non-UI Milestone 1 gates without reopening accepted PIM semantics.
