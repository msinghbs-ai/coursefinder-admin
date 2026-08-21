# CourseFinder Running Build v2.59

**Status:** **M1-PIPELINE-OPS CLOSED / PASS — OPERATIONS CONSOLE PROMOTED**  
**Date:** 21 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.58.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.10.md`  
**Pipeline Ops UAT:** `docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-2026-08-21.md`

## Accepted release position

PIM Admin v2.11 remains the accepted PIM shell. Pipeline Ops v1.0 is now accepted on top of that shell from:

`msinghbs-ai/Coursefinder-Pilot@848e302b19186cb0a751f74f23f06a244c5b0b2d`

Visible marker:

`PIM Admin v2.11 · Pipeline Ops v1.0 · governed`

The implementation was merged through `Coursefinder-Pilot#15` after Frontend Build #89 and #90 passed.

## Pipeline Operations capability

The Admin operational journey is now explicit:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

Accepted capability includes:

- rank-4+ Pipeline Control, Jobs and Sources;
- server-paged Jobs/Sources with operational filters;
- dry-run/APPLY distinction;
- partial-batch/source-complete distinction;
- technical/source-validation/governed failure classification;
- unresolved ambiguity distinct from parser/runtime failure;
- record/change/evidence/duration/cursor visibility;
- layer health/blocker/next-action visibility;
- expandable job errors and run semantics;
- Job → Evidence → affected entity/Search/publication drill-down;
- explicit Layer 3 suggestion-only and Layer 4 audit policies;
- Search Admission and Publication reported independently from ingestion/enrichment completion;
- no generic retry/replay/reset mutation.

## Deployed read/runtime contract

The console consumes the already-deployed governed Pipeline read contract introduced by:

`20260820051800 — m1_pipeline_ops_read_contract_v1`

through the shared:

`public.admin_read(text,jsonb)`

The shared dispatcher was not replaced and accepted Evidence/PIM routes remain preserved.

Final Evidence entity-impact optimisation:

`20260820235820 — m1_pipeline_ops_evidence_entity_links_fast_v2`

This pages `pipeline.evidence_entity_links` before resolving canonical/Search/publication state.

## Real-volume acceptance

Final live corpus at gate:

- Pipeline Jobs: 1,325;
- Pipeline Sources: 54;
- Evidence Artifacts: 1,567;
- Evidence Entity Links: 135,456;
- Search Course Documents: 33,105.

Measured DB-side governed reads:

- Pipeline overview ~384 ms;
- Jobs page at offset 1,250 ~293 ms;
- Sources page ~347 ms;
- 26,648-link CRICOS Evidence entity impact first page ~27 ms after optimisation, from ~3.42 s before;
- same Evidence impact at offset 26,000 ~872 ms.

## Security regression

- authenticated `admin_read` EXECUTE: allowed;
- anon `admin_read` EXECUTE: denied;
- below-rank-4 Pipeline access: denied with `42501`;
- authenticated `pipeline` schema USAGE: denied;
- public SECURITY DEFINER executable by authenticated: 0;
- public SECURITY DEFINER executable by anon: 0;
- no new browser mutation API introduced.

## Current live operational state

The console currently reports genuine blockers rather than hiding them:

- Layer 1: stale running job requires investigation before replay;
- Layer 2: blocked job state requires blocker resolution before rerun;
- Layer 3: no current Suggestions, therefore not operational;
- Layer 4: no current Review Queue/Actions;
- Search: 33,105 documents; AU/NZ country gates approved; four enrichment gates blocked;
- Publication: independent downstream state.

These conditions do not reopen the accepted Pipeline Ops UX/read/security gate.

## Preserved programme baselines

- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- accepted Layer 1 AU adapter: `layer1-au-depth-v1.6.0`;
- CRICOS fee semantics remain distinct from Provider-current fees;
- QILT, PRISMS and Scholarship semantic authority remains unchanged;
- Search remains governed and derived;
- no consumer publication scope was broadened by Pipeline Ops;
- no canonical Provider/Course identity or fact was mutated by this gate.

## Current gate

**M1-PIM-FINALISATION: CLOSED / PASS.**  
**M1-PIPELINE-OPS: CLOSED / PASS.**

Future operational mutations such as retry/replay/cancel/schedule/source enable-disable remain separate change-controlled work requiring adapter-specific server contracts and idempotency/audit semantics.
