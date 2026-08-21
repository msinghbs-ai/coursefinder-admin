# CourseFinder Running Build v2.61

**Status:** **M1-PIPELINE-OPS CLOSED / PASS — SAFE SOURCES PROJECTION HARDENED; EVIDENCE v1.0 RETAINED**  
**Date:** 21 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.60.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.12.md`  
**Pipeline Ops UAT:** `docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-v1.1-2026-08-21.md`  
**Evidence UAT:** `docs/uat/coursefinder-m1-evidence-ux-technical-acceptance-2026-08-21.md`

## Accepted release position

The current accepted Admin runtime remains:

`PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0`

Current Pilot source/head:

`msinghbs-ai/Coursefinder-Pilot@fda4270f3c440b8253b87da1a8c35a4b2769413e`

Visible marker remains:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · governed`

The latest change is a server-contract hardening only. It does not change the browser release label or Evidence UX.

## Pipeline safe-Sources hardening

A post-closure re-review of `CF-CHG-20260821-016` confirmed that the rank-4 Pipeline read contract returned raw `pipeline.sources.metadata` even though the UI rendered only selected operational fields.

This was corrected at the governed server boundary by:

`20260821025059 — m1_pipeline_ops_safe_source_projection_v1`

Pilot promotion:

- PR `Coursefinder-Pilot#17`;
- Frontend Build #101 — PASS;
- merged head `fda4270f3c440b8253b87da1a8c35a4b2769413e`.

The browser now receives only an explicit operational Source metadata allowlist. Full metadata remains private to the server/runtime.

The allowlist contains, where present:

- configured/active worker version;
- scope;
- coverage role;
- APPLY gate/enabled state;
- identity/course-identity scheme;
- transport/acquisition method;
- country-completeness flag.

Discovery internals, raw hashes, mapping/runtime details and other implementation metadata are not rank-4 payload fields.

## Post-correction UAT

Current-volume regression passed:

- 54/54 Pipeline Sources returned;
- unexpected browser metadata keys: 0;
- representative Job Detail source metadata sanitised;
- generic retry/replay/reset remain disabled;
- Evidence route remains functional with 1,567 artifacts;
- Pipeline overview still reports 1,325 Jobs;
- below-rank Pipeline read still fails with SQLSTATE `42501`;
- authenticated direct `pipeline` schema USAGE remains denied;
- public SECURITY DEFINER browser execution remains 0 for authenticated and anon;
- 50-row Sources read after sanitisation ~33.6 ms DB-side.

Superseding acceptance record:

`docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-v1.1-2026-08-21.md`

## Evidence v1.0 coexistence

The hardening was based on and merged into the current Evidence v1.0 Pilot head. The replacement `public.admin_read` definition was reconciled from live state before deployment and preserved all current Evidence routes.

Evidence v1.0 remains accepted with:

- rank-3 workspace boundary;
- private Storage mediation;
- Country-aware Source filtering;
- bounded Evidence/detail/entity lineage;
- signed 60-second Preview/Download;
- no authority collapse across Layers 1–4, Search or Publication.

## Security posture

The supported browser boundary remains:

`Supabase Auth → public.admin_read(text,jsonb) → server-side role/rank check → governed internal read`

- Pipeline Control / Jobs / Sources: Pipeline Operator+ rank 4;
- Evidence / Review Queue: Curator+ rank 3;
- anon `admin_read`: denied;
- direct authenticated internal-schema CRUD: not a browser contract;
- generic Pipeline destructive actions: not authorised.

Supabase Security Advisor showed no new warning attributable to this migration. Existing RLS-enabled/no-policy INFO notices on private/default-deny schemas and the Auth leaked-password-protection WARN remain separate existing platform posture/backlog.

## Preserved programme baselines

- PIM v2.11 semantics remain retained inside v2.12;
- Pipeline Ops v1.0 remains accepted;
- Evidence v1.0 remains accepted;
- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- accepted Layer 1 AU adapter: `layer1-au-depth-v1.6.0`;
- Search remains governed and derived;
- no canonical Provider/Course identity, factual observation, Search admission or Publication authority was changed.

## Current gate

**M1-PIM-FINALISATION: CLOSED / PASS.**  
**M1-PIPELINE-OPS: CLOSED / PASS — post-closure safe-Sources hardening complete.**  
**M1-EVIDENCE-UX: CLOSED / PASS.**