# CourseFinder Running Build v2.60

**Status:** **M1-EVIDENCE-UX CLOSED / PASS — EVIDENCE WORKSPACE PROMOTED**  
**Date:** 21 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.59.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.11.md`  
**Evidence UAT:** `docs/uat/coursefinder-m1-evidence-ux-technical-acceptance-2026-08-21.md`

## Accepted release position

The current accepted Admin runtime is:

`PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0`

Merged Pilot source/head:

`msinghbs-ai/Coursefinder-Pilot@d036fa64c190db98ed44c33fe265d0b47860f97e`

Visible marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · governed`

Implementation was promoted through `Coursefinder-Pilot#14` after GitHub `Pilot Frontend Build #99 / 32439107994` passed and authenticated browser UAT completed on the Cloudflare candidate runtime.

## Evidence operational capability

Accepted Evidence lineage is explicit:

`Source → Acquisition Job → Evidence Artifact/Snapshot → Observation/Claim → Canonical Entity/Field → Review/Decision → Search/Publication consequence`

Accepted capability includes:

- rank-3+ Evidence workspace;
- country/source/layer/entity/evidence/MIME/status/freshness/extraction/job/conflict/date/hash filters;
- Country-aware Source options;
- server-paged Evidence list and bounded detail;
- source authority, acquisition job, artifact hash/version/validity and safe Storage metadata;
- canonical entity and Search/publication consequence context;
- canonical → Evidence and Evidence → canonical navigation;
- exact evidence-bearing Course value → Evidence navigation where `evidence_id` is persisted;
- explicit source-null/missing-extraction/stale/conflict/rejected/current/superseded state;
- signed Preview/Download through `admin-evidence-access`;
- high-volume observation guard above 500 observations;
- no authority collapse between Layers 1–4, Search and Publication.

## Country-aware Source filter correction

Browser UAT identified that Country-filtered Evidence results were correct but Source options remained global.

Accepted correction:

`20260821021205 — m1_evidence_ux_country_source_filter_v1`

The governed Evidence Source filter metadata now includes `country_code`. Selecting Country constrains Source choices; changing Country clears an incompatible Source; clearing Country restores the full source list.

Browser re-test passed for Australia and Canada.

## Real-volume acceptance

Current Evidence corpus at gate:

- Evidence Artifacts: 1,567;
- represented Sources: 43;
- represented acquisition Jobs: 1,113;
- artifacts with extraction: 387;
- missing-extraction artifacts: 1,180;
- private Evidence Storage objects: 1,540;
- largest observed regulatory artifact: 103,315 observations/entity links.

Measured governed reads:

- Evidence page, 50 rows, warm: ~55.7 ms;
- representative high-volume detail: ~181 ms;
- first 100 entity links for 103,315-observation artifact: ~459 ms;
- entity-link temp spill: 0 blocks.

The prior ~17.6-second bulk observation expansion is not invoked automatically above 500 observations.

## Browser/security acceptance

Authenticated browser UAT passed for:

- Evidence list/filter interaction;
- canonical → Evidence navigation;
- exact value → Evidence navigation;
- Evidence → canonical return;
- high-volume drawer responsiveness;
- signed Preview/Download;
- browser network/private-boundary inspection;
- Country-aware Source filtering;
- narrow/responsive layout.

Security remains:

`Supabase Auth → public.admin_read(text,jsonb) → server-side role/rank check → governed internal read`

- Curator rank 3 can read Evidence;
- below-rank authenticated access is denied with `42501`;
- Pipeline Control / Jobs / Sources remain rank 4+;
- private Evidence Storage remains server-mediated;
- service-role credentials remain server-side;
- signed object access expires after 60 seconds;
- no direct browser internal-schema CRUD was introduced.

## Preserved programme baselines

- PIM v2.11 semantics remain retained inside v2.12;
- Pipeline Ops v1.0 remains accepted and unchanged in authority;
- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- accepted Layer 1 AU adapter: `layer1-au-depth-v1.6.0`;
- CRICOS registered fee semantics remain separate from Provider-current fees;
- QILT, PRISMS and Scholarship authority remains unchanged;
- Search remains governed and derived;
- no canonical Provider/Course identity, Search admission rule or publication authority was broadened by Evidence UX.

## Current gate

**M1-PIM-FINALISATION: CLOSED / PASS.**  
**M1-PIPELINE-OPS: CLOSED / PASS.**  
**M1-EVIDENCE-UX: CLOSED / PASS.**

Future Evidence mutations, review actions, supersession workflows or authority-semantic changes require a new or applicable Change Control rather than extending `CF-CHG-20260821-017` implicitly.
