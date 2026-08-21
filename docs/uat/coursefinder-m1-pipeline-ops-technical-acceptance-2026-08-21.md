# CourseFinder M1-PIPELINE-OPS Technical Acceptance — 21 August 2026

**Gate:** **PASS**  
**Workstream:** `M1-PIPELINE-OPS`  
**Change Control:** `CF-CHG-20260821-016`  
**UAT reference:** `M1-PIPELINE-OPS-2026-08-21`  
**Closed:** 21 August 2026 10:01 AEST  
**Pilot implementation:** `msinghbs-ai/Coursefinder-Pilot@848e302b19186cb0a751f74f23f06a244c5b0b2d`  
**Pilot PR:** `Coursefinder-Pilot#15`  
**Visible release marker:** `PIM Admin v2.11 · Pipeline Ops v1.0 · governed`

## 1. Acceptance scope

This gate adds the Admin operations console for the governed operational journey:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

The implementation does not change Provider/Course canonical identity and does not give the browser a direct internal-schema write path.

## 2. Reconciled starting state

Before implementation the workstream reconciled:

- `PROJECT_INSTRUCTIONS.md`;
- Change Control README/register and overlapping controls `006`, `013`, `015`, `016`;
- Master Project Plan v1.55;
- Running Build v2.58;
- Database Architecture v2.10.38;
- Admin/PIM Design Decisions v1.10;
- PIM Admin Guide v1.9;
- accepted PIM Admin v2.11 browser acceptance;
- current `Coursefinder-Pilot` `main` at `b3867cc89bbfd3f76def01993a70868318016ef0`;
- live Supabase project `coursefinder_Pilot`.

The live database was newer than the governance handoff: migration `20260820051800 — m1_pipeline_ops_read_contract_v1` already provided governed Pipeline Ops read operations through `public.admin_read`. Later PIM dispatcher reconciliation migrations preserved those branches. The implementation therefore consumed the existing contract rather than replacing the dispatcher or duplicating the schema.

## 3. Implemented Admin behaviour

### Pipeline Control

The console now visibly separates all six stages. Layer cards expose, where persisted by the runtime:

- source/configuration count and source navigation;
- last successful run;
- current job;
- job/evidence counts;
- discovered, selected, processed, accepted and rejected counts;
- unresolved ambiguity count;
- creates, updates, unchanged and conflicts;
- duration;
- resume/next cursor and `has_more` state;
- layer health/blocker;
- next allowed action;
- current Change Control/UAT reference and per-run references when persisted.

Search Admission and Publication are separate panels and are not treated as synonyms for ingestion/enrichment completion.

### Jobs

- server-paged at 50 rows;
- query/layer/status/mode/country/job-type/completion/failure filters;
- explicit `DRY_RUN` versus `APPLY`;
- explicit partial-batch versus source/scope-complete state;
- separate failure classes for technical failure/runtime/defect, source validation, governed rejection and governed blocker;
- unresolved ambiguity shown independently from parser/technical failure;
- expandable job detail and full error text;
- Source/authority context;
- job → Evidence drill-down;
- Evidence → affected canonical entity/Search/publication-state drill-down;
- safe-action policy returned by the server.

### Sources

- server-paged/filtered source inventory;
- layer, country, type, status and health filtering;
- last success, freshness, trust, running/problem jobs and Evidence counts;
- selected non-secret source configuration fields only;
- expandable last-error detail and authority/source link.

### Destructive operations

The console exposes no generic retry, replay or reset mutation. Backend job detail returns all three generic actions disabled with explicit reasons. The legacy whole-Pilot `Reset Database` card is removed from the promoted Admin surface. Existing bounded Layer 1 country controls remain separately scoped with deterministic offset/batch and typed APPLY confirmation.

## 4. Authority semantics

PASS criteria confirmed:

- Layer 1 remains regulatory/identity authority where applicable;
- Layer 2 remains deterministic/structured non-identity enrichment;
- Layer 3 is explicitly suggestion-only and cannot silently overwrite Layer 1/2 facts;
- Layer 4 policy requires auditable human resolution through review actions;
- successful ingestion/enrichment does not imply Search admission;
- Search projection does not imply Publication;
- partial batch completion does not imply complete-country/source completion;
- deterministic/governed rejection remains a separate failure class from technical failure;
- ambiguity count remains separate from parser/runtime failure.

Current live Layer 3 Suggestions and Layer 4 Review Queue/Actions are all zero. This is displayed as current operational state, not manufactured activity.

## 5. Real-volume UAT

The load gate used the deployed production-size Pilot data, not empty fixtures.

Final observed corpus:

| Surface | Real volume |
|---|---:|
| Pipeline Jobs | 1,325 |
| Pipeline Sources | 54 |
| Evidence Artifacts | 1,567 |
| Evidence Entity Links | 135,456 |
| Search Course Documents | 33,105 |
| Layer 3 Suggestions | 0 |
| Layer 4 Review Queue | 0 |
| Layer 4 Review Actions | 0 |

Measured database-side execution using the authenticated governed read path:

| Operation | Real scope | Result |
|---|---|---:|
| Pipeline overview | full live operational corpus | ~384 ms |
| Jobs page | 50 rows at offset 1,250 | ~293 ms |
| Sources page | 50 rows from 54 live sources | ~347 ms |
| Evidence entity impact before optimisation | 50 rows from a 26,648-entity CRICOS artifact | ~3.42 s |
| Evidence entity impact after v1 optimisation | same artifact/page | ~697 ms |
| Evidence entity impact after final v2 optimisation | same artifact/page | **~27 ms** |
| Evidence entity impact deep offset | offset 26,000, limit 50 | ~872 ms |

The slow Evidence entity-impact path was not accepted as-is. It was changed to page the maintained `pipeline.evidence_entity_links` lineage index before resolving canonical/Search/publication state.

Live migrations:

- `20260820235756 — m1_pipeline_ops_evidence_entity_links_fast_v1` — intermediate UAT optimisation;
- `20260820235820 — m1_pipeline_ops_evidence_entity_links_fast_v2` — final accepted implementation.

The implementation repository records the final v2 migration at:

`supabase/migrations/20260820235820_m1_pipeline_ops_evidence_entity_links_fast_v2.sql`

The final indexed read also improves lineage completeness for an older CRICOS regulatory snapshot: `pipeline.evidence_entity_links` resolves 29,321 affected entities where the previous reconstruction path returned zero because it did not cover those current lineage relations.

## 6. Real semantic variation exercised

The live Jobs contract currently classifies:

- partial batch: 255;
- explicit source/scope complete: 11;
- stale running: 1;
- technical failure: 24;
- technical runtime: 89;
- technical defect: 6;
- source validation: 2;
- governed blocker: 5;
- governed rejection: 0 current rows.

The absence of current governed-rejection rows does not collapse the category into technical failure; the contract keeps the class independently filterable.

Operational state at acceptance includes:

- Layer 1 blocker: stale running job requiring investigation before replay;
- Layer 2 blocker: explicit blocked job(s) requiring resolution before rerun;
- Layer 3: not operational because there are no Suggestions yet;
- Search: 33,105 documents with AU/NZ country gates approved while four enrichment gates remain blocked;
- Publication: independent downstream state and not inferred from Search or ingestion.

These are genuine pipeline/data states surfaced by the console and do not make the console gate fail.

## 7. Security/ACL UAT

Final live checks:

| Check | Result |
|---|---|
| authenticated EXECUTE on `public.admin_read(text,jsonb)` | PASS — allowed |
| anon EXECUTE on `public.admin_read(text,jsonb)` | PASS — denied |
| rank below Pipeline Operator calling `pipeline_overview` | PASS — `42501 pipeline_operator role required` |
| authenticated direct `pipeline` schema USAGE | PASS — denied |
| public SECURITY DEFINER executable by authenticated | PASS — 0 |
| public SECURITY DEFINER executable by anon | PASS — 0 |
| browser Pipeline Ops implementation | PASS — read-only `adminRead` operations; no new mutation API |

The accepted rank-4 Pipeline boundary and private Evidence semantics remain intact.

## 8. Build/responsiveness gate

`Coursefinder-Pilot#15` passed the existing Node 22 / Vite production build workflow twice after the Pipeline UI and final migration mirror were added:

- Frontend Build run #89 — PASS;
- Frontend Build run #90 — PASS.

Responsive treatment is part of the promoted module:

- desktop operations layout;
- <=1100 px single-column operational cards and two-column source/filter reduction;
- <=720 px mobile/off-canvas-compatible control layout, single-column details/evidence/actions and horizontally scrollable pipeline journey/table context.

The operations module is isolated in its own authenticated React root so the accepted PIM v2.11 shell is not replaced. Existing `#jobs` and `#sources` navigation opens the governed console for rank-4+ users.

## 9. Change safety and rollback

Implementation was developed from the exact accepted v2.11 Pilot head and merged only after PR CI and live RPC UAT.

Rollback/reversion paths:

1. frontend: revert Pilot commit `848e302b19186cb0a751f74f23f06a244c5b0b2d` to restore the accepted v2.11 shell behaviour;
2. evidence read optimisation: restore the prior `security.admin_evidence_entities(uuid,jsonb)` definition if a regression is proven; the underlying lineage table/data was not destructively changed;
3. no canonical Provider/Course identities or canonical factual observations were mutated by this gate;
4. no generic operational mutation was enabled.

## 10. Final decision

**M1-PIPELINE-OPS: PASS.**

The Admin now has a genuine Layer 1–4 operations console with separate Search/Publication state, real server paging/filtering, evidence/entity impact navigation and operational authority semantics. Current stale/blocked pipeline jobs remain visible operational work to resolve through their owning adapters/runbooks; they are not hidden and they are not treated as permission for generic replay/reset.
