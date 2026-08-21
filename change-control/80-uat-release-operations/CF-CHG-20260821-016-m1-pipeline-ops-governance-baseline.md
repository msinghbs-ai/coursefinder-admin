# CF-CHG-20260821-016 — M1 Pipeline Operations governance baseline and operational acceptance

**Status:** **CLOSED / PASS — IMPLEMENTED, LIVE DB UAT COMPLETE, PILOT MAIN PROMOTED**  
**Category:** `80-uat-release-operations`  
**Initiated:** 21 August 2026 09:04 AEST  
**Closed:** 21 August 2026 10:01 AEST  
**Origin:** `M1-PIPELINE-OPS`  
**Owner:** CourseFinder Pipeline Operations  
**Affected surfaces:** `30-admin-pim-ux`, `70-security-platform`, Evidence provenance, Pipeline runtime/API contracts

## Trigger

M1-PIPELINE-OPS required a coherent Admin operational view across regulatory ingestion, deterministic/structured enrichment, AI suggestions, human resolution, Search admission and Publication without collapsing their different authority semantics.

The workstream also inherited an earlier governance ambiguity between historical PIM records. That ambiguity was resolved before implementation; `CF-CHG-20260820-013` and `CF-CHG-20260820-015` remain CLOSED / PASS for their accepted PIM scopes.

## Reconciled baseline

Implementation began only after re-reading/rechecking:

1. `PROJECT_INSTRUCTIONS.md`;
2. `change-control/README.md` and `change-control/REGISTER.md`;
3. Master Project Plan v1.55;
4. Running Build v2.58;
5. Database Architecture v2.10.38;
6. Admin/PIM Design Decisions v1.10;
7. PIM Admin Guide v1.9;
8. accepted PIM Admin v2.11 browser UAT;
9. overlapping Change Controls `006`, `013`, `015`;
10. current `Coursefinder-Pilot` `main` and deployed Supabase state.

The accepted implementation starting head was:

`msinghbs-ai/Coursefinder-Pilot@b3867cc89bbfd3f76def01993a70868318016ef0`

Live reconciliation established that Supabase was already ahead of the governance handoff and contained `20260820051800 — m1_pipeline_ops_read_contract_v1` with the Pipeline Ops `public.admin_read` routes. The new browser implementation therefore consumes that governed contract instead of replacing the shared dispatcher.

## Semantic before / after

### Before

- accepted v2.11 `Jobs` and `Sources` screens still used generic bounded operational lists;
- the live database had richer Layer/Mode/completion/failure/evidence semantics than the browser exposed;
- there was no coherent visible Layer 1 → Layer 4 → Search → Publication operational journey;
- job/error/evidence/entity-impact context required separate technical inspection;
- the Settings surface still contained a generic whole-Pilot Reset Database card;
- Evidence entity-impact reconstruction was too slow on the largest real CRICOS artifact.

### After

The promoted Admin surface now exposes:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

For governed layers/runs it surfaces source/configuration context, last success/current run, discovered/selected/processed/accepted/rejected, creates/updates/unchanged/conflicts, Evidence, duration, cursor/completion, blockers/health, next allowed action and Change Control/UAT references where persisted.

Jobs now support server paging/filtering, expandable failure detail, explicit dry-run/APPLY, completion/failure classifications, evidence navigation and entity-impact drill-down. Sources now expose governed health/freshness/configuration signals without opening a browser mutation path.

Search Admission and Publication remain independent downstream states. Layer 3 remains suggestion-only. Layer 4 remains auditable human resolution.

Generic retry/replay/reset is not enabled. Backend `safe_actions` returns all generic mutations disabled, and the generic whole-Pilot reset card is removed from the promoted Admin surface. Existing bounded Layer 1 country APPLY controls remain separately scoped and typed-confirmed.

## Implementation evidence

Pilot PR:

`msinghbs-ai/Coursefinder-Pilot#15`

Accepted Pilot main commit:

`848e302b19186cb0a751f74f23f06a244c5b0b2d — M1-PIPELINE-OPS: governed Layer 1-4 operations console`

Visible release marker:

`PIM Admin v2.11 · Pipeline Ops v1.0 · governed`

Live Supabase optimisation migrations:

- `20260820235756 — m1_pipeline_ops_evidence_entity_links_fast_v1` — intermediate UAT optimisation;
- `20260820235820 — m1_pipeline_ops_evidence_entity_links_fast_v2` — final accepted read path.

Repository mirror of the final migration:

`Coursefinder-Pilot/supabase/migrations/20260820235820_m1_pipeline_ops_evidence_entity_links_fast_v2.sql`

## UAT evidence

Authoritative UAT record:

`docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-2026-08-21.md`

UAT reference:

`M1-PIPELINE-OPS-2026-08-21`

Final real-volume corpus:

- 1,325 Pipeline Jobs;
- 54 Pipeline Sources;
- 1,567 Evidence Artifacts;
- 135,456 Evidence Entity Links;
- 33,105 Search Course Documents.

Performance gate:

- Pipeline overview ~384 ms;
- Jobs page at offset 1,250 ~293 ms;
- Sources page ~347 ms;
- 26,648-link CRICOS evidence impact first page improved from ~3.42 s to ~27 ms;
- evidence impact at offset 26,000 ~872 ms.

Frontend CI:

- PR Frontend Build #89 — PASS;
- PR Frontend Build #90 — PASS.

Security regression:

- authenticated `public.admin_read` EXECUTE = allowed;
- anon `public.admin_read` EXECUTE = denied;
- below-rank-4 Pipeline read = `42501 pipeline_operator role required`;
- authenticated direct `pipeline` schema USAGE = denied;
- public SECURITY DEFINER executable by authenticated = 0;
- public SECURITY DEFINER executable by anon = 0;
- new Pipeline browser module is read-only and introduces no mutation API.

## Current operational state surfaced by the console

The gate is PASS even though the live pipeline correctly shows operational work still requiring resolution:

- Layer 1 has one stale-running job; next allowed action is investigation before replay;
- Layer 2 has blocked job state requiring explicit blocker resolution;
- Layer 3 has no current Suggestions and is reported as not operational rather than fabricated;
- Layer 4 currently has no Review Queue/Actions;
- Search contains 33,105 documents with AU/NZ country gates approved while four enrichment gates remain blocked;
- Publication remains an independent downstream state.

These are data/runtime states, not hidden UI failures and not permission for generic replay/reset.

## Authority and safety decisions retained

- Provider/Course identity is not owned by the Pipeline workspace;
- Layer 2 does not redefine Layer 1 identity;
- Layer 3 cannot silently overwrite Layer 1/2 facts;
- Layer 4 decisions must remain auditable;
- source/evidence/versioning is retained;
- private Evidence boundaries remain in force;
- no broad authenticated legacy `ui_*` SECURITY DEFINER compatibility path was restored;
- future retry/replay/cancel/schedule/source mutation requires a separate explicit server action with scope, idempotency, audit and confirmation semantics.

## Rollback / reversion

1. Revert Pilot commit `848e302b19186cb0a751f74f23f06a244c5b0b2d` to return to the accepted PIM v2.11 browser baseline.
2. If the Evidence entity-impact optimisation regresses, restore the prior `security.admin_evidence_entities(uuid,jsonb)` definition; no lineage/canonical data was deleted by this optimisation.
3. No canonical Provider/Course identity or factual observation was changed by this gate.
4. No generic destructive operational action was enabled.

## Final decision

**CLOSED / PASS.**

M1-PIPELINE-OPS now provides the requested genuine operations console while preserving the inherited PIM/Evidence/security boundaries and distinct authority semantics across Layers 1–4, Search and Publication.
