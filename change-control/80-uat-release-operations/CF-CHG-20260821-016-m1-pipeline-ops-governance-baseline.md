# CF-CHG-20260821-016 — M1 Pipeline Operations governance baseline and operational acceptance

**Status:** **CLOSED / PASS — POST-CLOSURE SAFE-SOURCES HARDENING COMPLETE**  
**Category:** `80-uat-release-operations`  
**Initiated:** 21 August 2026 09:04 AEST  
**Original closure:** 21 August 2026 10:01 AEST  
**Post-closure re-review completed:** 21 August 2026 12:55 AEST  
**Origin:** `M1-PIPELINE-OPS`  
**Owner:** CourseFinder Pipeline Operations  
**Affected surfaces:** `30-admin-pim-ux`, `70-security-platform`, Evidence provenance, Pipeline runtime/API contracts

## Trigger and accepted operational scope

M1-PIPELINE-OPS establishes a coherent Admin operational view across:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

The accepted console preserves authority boundaries, server paging/filtering, dry-run/APPLY semantics, partial-versus-complete scope, technical/governed failure distinctions, Evidence/entity-impact navigation and no generic retry/replay/reset mutation.

Provider/Course identity is not owned by this workspace. Layer 2 does not redefine Layer 1 identity. Layer 3 remains suggestion-only. Layer 4 remains auditable human resolution. Search and Publication remain independent downstream states.

## Original implementation acceptance

Original Pipeline Ops implementation:

- Pilot PR: `msinghbs-ai/Coursefinder-Pilot#15`;
- accepted commit: `848e302b19186cb0a751f74f23f06a244c5b0b2d`;
- visible release marker at that gate: `PIM Admin v2.11 · Pipeline Ops v1.0 · governed`;
- Evidence impact optimisation: `20260820235820 — m1_pipeline_ops_evidence_entity_links_fast_v2`;
- original UAT: `docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-2026-08-21.md`.

Original real-volume gate covered 1,325 Jobs, 54 Sources, 1,567 Evidence Artifacts, 135,456 Evidence Entity Links and 33,105 Search Course Documents. The largest CRICOS entity-impact read was reduced from ~3.42 s to ~27 ms for its first page.

## Post-closure re-review — residual safe-Sources defect

A later re-review against the current PIM v2.12 + Evidence v1.0 baseline found that the browser-facing Pipeline contract still returned the entire `pipeline.sources.metadata` object in two rank-4 operations:

- `pipeline_sources_page`;
- `pipeline_job_detail.source.metadata`.

The React UI rendered only selected safe fields, but UI omission is not an authority/security boundary. This contradicted the inherited `CF-CHG-20260820-013` requirement that rank-4 payloads must not expose hidden source implementation configuration.

No current password, bearer token, API key, service-role key or equivalent credential was found in the source metadata corpus. The defect was nevertheless treated as a gate issue because raw metadata included internal acquisition/runtime/mapping/hash/discovery configuration that the browser did not require.

The gate was therefore re-reviewed as **temporarily BLOCKED for the residual server-projection defect**, without reopening PIM v2.12 or Evidence v1.0 semantics.

## Corrective implementation

Live Supabase migration:

`20260821025059 — m1_pipeline_ops_safe_source_projection_v1`

Pilot implementation mirror and promotion:

- PR: `msinghbs-ai/Coursefinder-Pilot#17`;
- PR head: `55a1f81a9f22caf85a881fa5b9c88b9a70f61dbc`;
- merged Pilot head: `fda4270f3c440b8253b87da1a8c35a4b2769413e`;
- Frontend Build #101: PASS.

The correction:

1. keeps full `pipeline.sources.metadata` unchanged inside the private/server runtime;
2. introduces an explicit safe metadata allowlist at the governed `public.admin_read` boundary;
3. sanitises both Sources list results and Job Detail source metadata;
4. retains only operational fields currently required by the console: worker/configured-worker version, scope, coverage role, apply gate/enabled, identity scheme, course identity scheme, transport, acquisition method and country-completeness flag when present;
5. preserves the current Evidence v1.0 dispatcher routes;
6. introduces no mutation, canonical write or browser internal-schema permission.

## Post-correction UAT

Authoritative superseding Pipeline Ops UAT:

`docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-v1.1-2026-08-21.md`

Key results:

- all 54 current Sources returned through the governed Pipeline path;
- browser-visible Source metadata contained zero unexpected keys outside the allowlist;
- internal discovery/runtime/hash/mapping/config keys were absent from the rank-4 payload;
- Job Detail source metadata was sanitised while safe worker-version context remained;
- generic Retry / Replay / Reset remained disabled;
- below-rank Pipeline access remained `42501 pipeline_operator role required`;
- authenticated direct `pipeline` schema USAGE remained denied;
- public SECURITY DEFINER executable by authenticated = 0;
- public SECURITY DEFINER executable by anon = 0;
- Evidence dispatcher regression passed with 1,567 current Evidence Artifacts;
- Pipeline overview/filter routes remained available;
- warmed 50-row Sources read after sanitisation measured ~33.6 ms DB-side;
- Supabase Security Advisor introduced no new migration-specific security warning; existing RLS-no-policy INFO entries and leaked-password-protection WARN remain separate established platform posture/backlog.

## Destructive-operation decision retained

There is still no generic `Reset Everything`, `Retry Everything` or `Replay Everything` surface.

Any future operational mutation requires a separately governed server action with exact source/adapter/batch/entity scope, server-side role enforcement, idempotency/replay semantics, Evidence/hash preservation where applicable, audit/change history, explicit confirmation, busy/double-click protection and rollback behaviour.

Existing bounded Layer 1 country APPLY/continue/idempotency controls remain separate because their scope and confirmation semantics are explicit.

## Rollback / reversion

- Revert Pilot PR #17 / merge commit `fda4270f3c440b8253b87da1a8c35a4b2769413e` to remove the repository mirror.
- Restore the immediately prior `public.admin_read(text,jsonb)` dispatcher and drop the two sanitiser helpers if the projection causes a proven regression.
- The correction does not delete or rewrite `pipeline.sources.metadata`; it changes only the rank-4 browser projection.
- No canonical Provider/Course data, Evidence Artifact, Search admission state or Publication state was changed.

## Final decision

**CLOSED / PASS.**

The re-review identified a legitimate server-projection gap that my earlier handover should not have left as a permanent BLOCKED state. That gap is now corrected, tested against the current PIM v2.12 + Evidence v1.0 baseline and promoted without overwriting newer parallel work.