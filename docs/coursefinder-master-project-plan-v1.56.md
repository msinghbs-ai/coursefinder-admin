# CourseFinder Master Project Plan v1.56

**Status:** **AUTHORITATIVE PROGRAMME GOVERNANCE — M1-PIPELINE-OPS CLOSED / PASS**  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.55.md`  
**Last consolidated:** 21 August 2026 10:01 AEST  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Running build:** `docs/coursefinder-running-build-v2.59.md`  
**Admin/PIM decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.11.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.10.md`  
**Pipeline Ops UAT:** `docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-2026-08-21.md`

## Current programme position

M1-PIM-FINALISATION remains **CLOSED / PASS** and PIM Admin v2.11 remains the accepted PIM shell.

M1-PIPELINE-OPS is now **CLOSED / PASS** under `CF-CHG-20260821-016`.

The accepted operational journey is:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

## Accepted implementation authority

Current accepted Pilot source/head:

`msinghbs-ai/Coursefinder-Pilot@848e302b19186cb0a751f74f23f06a244c5b0b2d`

Visible release marker:

`PIM Admin v2.11 · Pipeline Ops v1.0 · governed`

Pilot PR:

`Coursefinder-Pilot#15`

Frontend Build #89 and #90 passed before promotion.

## Pipeline Operations acceptance

The Admin now exposes a coherent operational console rather than unrelated Jobs/Sources tables.

Accepted behaviours:

- per-layer source/configuration, last success/current job, record/change/evidence/duration/cursor/blocker/next-action context;
- server-paged/filterable Jobs and Sources;
- explicit dry-run versus APPLY;
- explicit partial batch versus source/scope complete state;
- technical, source-validation and governed failure classifications kept distinct;
- unresolved ambiguity separated from parser/runtime failure;
- expandable errors and job run semantics;
- Job → Evidence → canonical entity/Search/publication-state drill-down;
- Layer 3 suggestion-only authority;
- Layer 4 auditable human-resolution authority;
- Search Admission separate from ingestion/enrichment completion;
- Publication separate from Search and canonical readiness;
- generic retry/replay/reset withheld pending separately governed mutation contracts.

## Performance and scale gate

Acceptance was performed against real Pilot scale:

- 1,325 Jobs;
- 54 Sources;
- 1,567 Evidence Artifacts;
- 135,456 Evidence Entity Links;
- 33,105 Search Course Documents.

The largest Evidence entity-impact path was optimised during UAT from ~3.42 s to ~27 ms for the first 50 affected entities of a 26,648-link CRICOS artifact.

Final optimisation migration:

`20260820235820 — m1_pipeline_ops_evidence_entity_links_fast_v2`

## Security position

The accepted Admin boundary remains unchanged:

`Supabase Auth → public.admin_read(text,jsonb) → server-side role/rank check → governed internal read`

- Pipeline Control / Jobs / Sources require Pipeline Operator+ rank 4;
- anon cannot execute `admin_read`;
- authenticated users do not receive direct `pipeline` schema USAGE;
- no public SECURITY DEFINER browser compatibility surface was reopened;
- the new Pipeline Ops browser module introduces no mutation API;
- private Evidence boundaries remain authoritative.

## Destructive-operation position

There is no generic Reset Everything surface in the promoted Admin operations console.

Future retry/replay/cancel/schedule/source mutation must be authorised through a new explicit action contract with:

- exact adapter/source/country/entity/batch scope;
- server-side role enforcement;
- replay/idempotency semantics;
- preserved Evidence/hash where required;
- audit/change-history evidence;
- explicit confirmation and double-click/busy protection;
- rollback/reversion behaviour.

Existing bounded Layer 1 country APPLY/continue/idempotency controls remain separate because they carry governed scope and typed confirmation.

## Current operational blockers are visible, not hidden

At acceptance:

- Layer 1 has a stale-running job requiring investigation before replay;
- Layer 2 has blocked job state requiring resolution before rerun;
- Layer 3 has no Suggestions and is therefore shown as not operational;
- Layer 4 has no Review Queue/Actions;
- Search has 33,105 documents, AU/NZ country gates approved and four enrichment gates blocked.

These are owning-workstream operational states. They do not authorise generic Pipeline mutation and do not invalidate the accepted Admin operations console.

## Governing records

- `CF-CHG-20260820-006` — Evidence provenance/private boundary — CLOSED / PASS;
- `CF-CHG-20260820-013` — Pipeline Operator role/safe Sources boundary — CLOSED / PASS;
- `CF-CHG-20260820-015` — accepted PIM v2.11 browser baseline — CLOSED / PASS;
- `CF-CHG-20260821-016` — M1 Pipeline Operations — **CLOSED / PASS**.

## Preserved architecture position

Database Architecture v2.10.38 remains current. This work consumed/optimised accepted read contracts and added Admin operational UX; it did not change canonical Provider/Course identity architecture and therefore does not justify an architecture-version bump.

## Next programme work

Subsequent workstreams should use Running Build v2.59, Admin/PIM Design Decisions v1.11 and Admin Guide v1.10 as the current operating baseline. Any future Pipeline operational mutation must open or update an applicable Change Control rather than extending `016` implicitly.
