# CourseFinder Master Project Plan v1.58

**Status:** **AUTHORITATIVE PROGRAMME GOVERNANCE — PIPELINE SAFE-SOURCES HARDENING COMPLETE**  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.57.md`  
**Last consolidated:** 21 August 2026 12:55 AEST  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Running build:** `docs/coursefinder-running-build-v2.61.md`  
**Admin/PIM decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.11.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.12.md`  
**Pipeline Ops UAT:** `docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-v1.1-2026-08-21.md`  
**Evidence UAT:** `docs/uat/coursefinder-m1-evidence-ux-technical-acceptance-2026-08-21.md`

## Current programme position

M1-PIM-FINALISATION remains **CLOSED / PASS**.

M1-PIPELINE-OPS remains **CLOSED / PASS** under `CF-CHG-20260821-016` after a post-closure safe-Sources server-projection correction.

M1-EVIDENCE-UX remains **CLOSED / PASS** under `CF-CHG-20260821-017` and was preserved during the Pipeline correction.

The accepted Admin operational model remains:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

## Current accepted implementation authority

Pilot source/head:

`msinghbs-ai/Coursefinder-Pilot@fda4270f3c440b8253b87da1a8c35a4b2769413e`

Visible marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · governed`

Latest Pilot promotion:

`Coursefinder-Pilot#17 — M1-PIPELINE-OPS: harden rank-4 Sources payload`

Frontend Build #101 passed before merge.

## Pipeline post-closure correction

Re-review of the accepted Pipeline Ops contract found that raw `pipeline.sources.metadata` was still returned through rank-4 Pipeline Sources and Job Detail reads. The UI displayed only selected fields, but browser field omission did not satisfy the safe-Sources server contract inherited from `CF-CHG-20260820-013`.

The correction was applied without reverting the later Evidence v1.0 workstream:

`20260821025059 — m1_pipeline_ops_safe_source_projection_v1`

The browser now receives only a strict operational metadata allowlist while the full Source metadata object remains private/server-side.

Post-correction checks against all 54 current Sources found zero unexpected metadata keys. Evidence dispatcher regression, role/ACL checks and performance UAT also passed.

## Pipeline Operations accepted capability

Pipeline Ops v1.0 remains accepted for:

- one visible Layer 1 → Layer 4 → Search → Publication journey;
- layer-specific authority semantics;
- source/configuration, last success/current job, record/change/evidence/duration/cursor/blocker/next-action context;
- server-paged/filterable Jobs and Sources;
- explicit DRY_RUN versus APPLY;
- partial-batch versus source/scope completion;
- technical/source-validation/governed failure classes kept distinct;
- ambiguity separated from parser/runtime failure;
- expandable error detail and run semantics;
- Job → Evidence → canonical/Search/publication drill-down;
- no generic retry/replay/reset mutation.

## Evidence v1.0 accepted capability retained

Evidence remains a first-class cross-layer provenance workspace with:

- rank-3 boundary;
- Country-aware Source filtering;
- bounded list/detail/entity reads;
- canonical ↔ Evidence navigation;
- high-volume observation protection;
- private Storage and server-mediated signed Preview/Download;
- no Layer/Search/Publication authority collapse.

No Evidence route or Evidence authority decision was replaced by the Pipeline safe-Sources correction.

## Security position

Supported browser boundary:

`Supabase Auth → public.admin_read(text,jsonb) → server-side role/rank check → governed internal read`

Current acceptance includes:

- Pipeline Control / Jobs / Sources require Pipeline Operator+ rank 4;
- Evidence / Review Queue require Curator+ rank 3;
- anon cannot execute `admin_read`;
- authenticated browser has no direct `pipeline` schema USAGE;
- public SECURITY DEFINER executable by authenticated/anon remains 0;
- Source raw implementation metadata is not a rank-4 payload;
- generic destructive Pipeline actions remain unauthorised.

## Current technical baselines

- Pipeline Jobs: 1,325;
- Pipeline Sources: 54;
- Evidence Artifacts: 1,567;
- Evidence Entity Links: 135,456 at original Pipeline gate;
- Search Course Documents: 33,105;
- final Pipeline Evidence entity-impact optimisation: `20260820235820 — m1_pipeline_ops_evidence_entity_links_fast_v2`;
- safe Pipeline Source projection: `20260821025059 — m1_pipeline_ops_safe_source_projection_v1`;
- Evidence Country-aware Source metadata: `20260821021205 — m1_evidence_ux_country_source_filter_v1`.

## Preserved architecture position

Database Architecture v2.10.38 remains current. The safe-Sources correction narrows a browser read projection and does not alter canonical identity, source authority, evidence grain or core data architecture; no architecture version bump is justified.

Admin/PIM Design Decisions v1.11 also remains current because DD-PIPELINE-03 already states the governing rule that hidden source credentials/private implementation secrets are not rank-4 payload fields. The correction brings implementation into compliance with that existing decision rather than introducing a new design decision.

## Current governing records

- `CF-CHG-20260820-013` — safe Sources/rank boundary — CLOSED / PASS;
- `CF-CHG-20260821-016` — Pipeline Operations — **CLOSED / PASS, post-closure hardening complete**;
- `CF-CHG-20260821-017` — Evidence UX — **CLOSED / PASS**.

## Current baseline for subsequent work

Use:

- Master Project Plan v1.58;
- Running Build v2.61;
- Database Architecture v2.10.38;
- Admin/PIM Design Decisions v1.11;
- PIM Admin Guide v1.12;
- Pipeline Ops UAT v1.1;
- existing Evidence UAT;
- Pilot head `fda4270f3c440b8253b87da1a8c35a4b2769413e`.

Future Pipeline mutations or changes to Source metadata visibility require a new/applicable Change Control; do not extend `016` implicitly beyond this documented post-closure correction.