# CourseFinder PIM Admin Guide v1.12

**UI:** PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0  
**Effective:** 21 August 2026  
**Status:** **CURRENT ADMIN OPERATING GUIDE — PIPELINE SAFE-SOURCES HARDENING ACCEPTED**  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.11.md`

## 1. Purpose

This guide retains all accepted v1.11 PIM, Pipeline Ops and Evidence semantics and records the final server-side Source projection rule for Pipeline Operator users.

The current operational journey remains:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

Evidence remains a first-class cross-layer provenance capability and not a public file browser.

## 2. Browser and role boundary

The supported browser read path remains:

`Supabase Auth → public.admin_read(text,jsonb) → server-side role/rank check → governed internal read`

| Area | Minimum role |
|---|---|
| Overview / Catalogue / Insights / Scholarships | assigned CourseFinder role |
| Review Queue / Evidence | Curator, rank 3 |
| Pipeline Control / Jobs / Sources | Pipeline Operator, rank 4 |
| PIM Configuration | PIM Admin, rank 5 |
| privileged mutations | explicit governed server action only |

Menu visibility and React field omission are not security boundaries. The server response itself must comply with the role contract.

## 3. Pipeline Sources safe-projection rule

`pipeline.sources.metadata` is an internal runtime/governance object. It is **not** a raw rank-4 browser payload.

The accepted rank-4 Sources/Job Detail projection may expose only operational configuration required for decision-making, currently:

- configured/active worker version;
- scope;
- coverage role;
- APPLY gate/enabled state;
- identity/course-identity scheme;
- transport/acquisition method;
- country-completeness flag.

The server must withhold unrelated implementation metadata such as internal discovery details, raw evidence/source hashes, runtime routing, mapping internals, resource inventories and other configuration not needed by the Pipeline Operator UI.

This is enforced by:

`20260821025059 — m1_pipeline_ops_safe_source_projection_v1`

The rule applies to both:

- Pipeline Sources list results;
- Job Detail `source.metadata`.

Full metadata remains available to authorised server/runtime processes; it is not deleted from `pipeline.sources`.

## 4. Pipeline operational semantics

Pipeline Ops v1.0 continues to distinguish:

- Layer 1 regulatory/identity authority where approved;
- Layer 2 deterministic/structured enrichment without Layer 1 identity redefinition;
- Layer 3 suggestion-only AI output;
- Layer 4 auditable human resolution;
- Search Admission as a governed derived projection;
- Publication as an independent downstream state.

Operators must distinguish:

- `DRY_RUN` from `APPLY`;
- partial batch from source/scope completion;
- accepted/rejected/ambiguity from parser/runtime failure;
- technical failure/runtime/defect from source validation and governed blocker/rejection;
- ingestion/enrichment success from Search and Publication state.

## 5. Jobs and evidence impact

Jobs remain server-paged/bounded and may expose persisted counters, duration, cursor/completion state, errors, Source context, Change Control/UAT references and Evidence links.

Job → Evidence → canonical entity/Search/publication drill-down remains governed by the Evidence/private-boundary model.

Evidence entity impact continues to use the maintained lineage index under:

`20260820235820 — m1_pipeline_ops_evidence_entity_links_fast_v2`

## 6. Destructive and replay controls

There is no generic `Retry Everything`, `Replay Everything` or `Reset Everything` operation.

A future mutation requires:

- explicit server action;
- exact adapter/source/country/entity/batch scope;
- server-side role enforcement;
- idempotency/replay semantics;
- Evidence/hash preservation where applicable;
- audit/change history;
- explicit confirmation where destructive;
- busy/double-click protection;
- bounded rollback/reversion behaviour.

Existing bounded Layer 1 country APPLY/continue/idempotency controls are separate because their scope and typed confirmation semantics are explicit.

## 7. Evidence operating model retained

Evidence lineage remains:

`Source → Acquisition Job → Evidence Artifact/Snapshot → Observation/Claim → Canonical Entity/Field → Review/Decision → Search/Publication consequence`

All v1.11 Evidence rules remain in force, including:

- Country-aware Source filtering;
- source-null/missing-extraction/stale/conflict/rejected/superseded/current distinctions;
- bounded high-volume behaviour;
- canonical ↔ Evidence navigation;
- private Storage and server-mediated signed Preview/Download;
- 60-second signed access;
- no service-role credential in the browser.

## 8. Current accepted release

Current Pilot head:

`msinghbs-ai/Coursefinder-Pilot@fda4270f3c440b8253b87da1a8c35a4b2769413e`

Visible marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · governed`

Pipeline hardening promotion:

- `Coursefinder-Pilot#17`;
- Frontend Build #101 — PASS.

Pipeline acceptance:

`docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-v1.1-2026-08-21.md`

Evidence acceptance remains:

`docs/uat/coursefinder-m1-evidence-ux-technical-acceptance-2026-08-21.md`

## 9. Current state

`CF-CHG-20260821-016` remains **CLOSED / PASS** after the post-closure safe-Sources correction.  
`CF-CHG-20260821-017` remains **CLOSED / PASS** and was not reopened or overwritten by this correction.

The platform-wide leaked-password-protection warning remains a separate security backlog item and is not justification for exposing source/runtime metadata.