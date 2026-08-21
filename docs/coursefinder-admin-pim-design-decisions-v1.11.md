# CourseFinder Admin/PIM Design Decisions v1.11

**Status:** **CURRENT — PIPELINE OPS v1.0 ACCEPTED**  
**Effective:** 21 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.10.md`  
**Change Control:** `CF-CHG-20260821-016`

All accepted v1.10 Admin/PIM decisions remain in force. This revision adds the accepted Pipeline Operations decisions below.

## DD-PIPELINE-01 — One visible operational journey, separate authority semantics

The Admin models:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

The stages share operational navigation but do not share authority.

- Layer 1 may own regulatory/identity facts where the approved authority supplies them.
- Layer 2 enriches governed canonical entities without redefining Layer 1 identity.
- Layer 3 is suggestion-only and has no silent overwrite authority over Layer 1/2.
- Layer 4 is auditable human resolution.
- Search is a governed derived projection.
- Publication is an independent downstream channel state.

## DD-PIPELINE-02 — Job success is multi-dimensional

Admin status must preserve, where available:

- dry-run versus APPLY;
- partial batch versus source/scope completion;
- records discovered/selected/processed/accepted/rejected;
- creates/updates/unchanged/conflicts;
- unresolved ambiguity;
- technical runtime/defect, source validation, governed rejection and governed blocker as different classes;
- Evidence, duration and resume cursor.

A completed ingestion/enrichment job is not evidence of Search admission or Publication.

## DD-PIPELINE-03 — Operations reads remain server-governed

Pipeline Control / Jobs / Sources require Pipeline Operator+ rank 4 and use:

`public.admin_read(text,jsonb)`

The browser does not receive direct `pipeline` schema CRUD permission. Hidden source credentials and private implementation secrets are not rank-4 payload fields.

## DD-PIPELINE-04 — Jobs and Sources are operational decision views, not raw tables

Jobs and Sources must be server-paged/bounded and filterable. Jobs provide expandable errors/run semantics and Evidence navigation. Sources provide health/freshness and safe configuration context.

The accepted UI must work at real operational volume rather than relying on small local-filter fixtures.

## DD-PIPELINE-05 — Evidence impact uses the maintained lineage index

Evidence → entity impact should use `pipeline.evidence_entity_links` as the maintained governed lineage index and page link identities before resolving canonical/Search/publication state.

This avoids rebuilding lineage by unioning large canonical tables for every drill-down and aligns the read path with the accepted Evidence UX lineage model.

Final accepted migration:

`20260820235820 — m1_pipeline_ops_evidence_entity_links_fast_v2`

## DD-PIPELINE-06 — No generic destructive operation

There is no generic Retry Everything, Replay Everything or Reset Everything surface.

Future operational mutations must be adapter/source-specific and require:

- explicit server action and role check;
- exact scope;
- idempotency/replay semantics;
- preserved Evidence/hash where applicable;
- audit/change history;
- explicit confirmation for destructive operations;
- busy/double-click protection;
- bounded error/rollback behaviour.

Existing bounded Layer 1 country APPLY/continue/idempotency controls remain separate because their scope and confirmation semantics are explicit.

## DD-PIPELINE-07 — Current blockers remain visible

Stale/blocked jobs, unclassified sources, absent Layer 3 Suggestions or absent Layer 4 Review work are displayed as current operational state. The UI must not manufacture successful activity, silently reclassify authority or treat a blocker as permission to replay.

## Acceptance references

- Pilot: `msinghbs-ai/Coursefinder-Pilot@848e302b19186cb0a751f74f23f06a244c5b0b2d`
- UAT: `docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-2026-08-21.md`
- Admin Guide: `docs/coursefinder-pim-admin-guide-v1.10.md`
- Running Build: `docs/coursefinder-running-build-v2.59.md`
