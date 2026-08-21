# CourseFinder M1-PIPELINE-OPS Technical Acceptance v1.1 — 21 August 2026

**Gate:** **PASS**  
**Workstream:** `M1-PIPELINE-OPS`  
**Change Control:** `CF-CHG-20260821-016`  
**Supersedes for current status:** `docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-2026-08-21.md`  
**Re-review completed:** 21 August 2026 12:55 AEST  
**Current Pilot head:** `msinghbs-ai/Coursefinder-Pilot@fda4270f3c440b8253b87da1a8c35a4b2769413e`  
**Current UI marker:** `PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · governed`

## 1. Purpose

This v1.1 acceptance retains the original Pipeline Ops functional/performance gate and adds a post-closure correction for the rank-4 Source metadata projection discovered during re-review.

The current runtime already includes the later accepted Evidence v1.0 workstream. The correction was therefore tested and promoted on top of PIM v2.12 + Pipeline Ops v1.0 + Evidence v1.0 rather than reverting to the earlier v2.11 implementation head.

## 2. Defect confirmed during re-review

The live `security.admin_pipeline_ops_read` contract returned raw `pipeline.sources.metadata` in:

- `pipeline_sources_page`;
- `pipeline_job_detail.source.metadata`.

The Pipeline UI displayed only selected fields, but a rank-4 caller could inspect the full JSON returned by `public.admin_read`.

The current metadata corpus did not contain obvious passwords, bearer tokens, API keys or service-role keys. It did contain implementation-only fields such as discovery/runtime/mapping/hash/resource information that were outside the documented safe rank-4 Sources contract.

Result before correction: **BLOCKED for the residual server-projection defect.**

## 3. Correction

Production migration:

`20260821025059 — m1_pipeline_ops_safe_source_projection_v1`

Repository promotion:

- Pilot PR #17;
- PR head `55a1f81a9f22caf85a881fa5b9c88b9a70f61dbc`;
- merged head `fda4270f3c440b8253b87da1a8c35a4b2769413e`;
- Pilot Frontend Build #101 — PASS.

The browser projection now retains only this explicit operational metadata allowlist where a value exists:

- `configured_worker_version`;
- `worker_version`;
- `scope`;
- `coverage_role`;
- `apply_gate`;
- `apply_enabled`;
- `identity_scheme`;
- `course_identity_scheme`;
- `transport`;
- `acquisition_method`;
- `coverage_complete_for_country`.

Full source metadata remains unchanged server-side.

## 4. Current-volume Sources UAT

The governed Sources page was executed against all **54** current Pipeline Sources.

Results:

- total Sources: 54;
- returned Sources at limit 200: 54;
- unexpected metadata keys outside the allowlist: 0;
- browser exposure of audited internal keys including `credential_filter`, `discovery_url`, prior/updated source URLs, runtime details, required resources, Evidence/course/ZIP hashes, provider-mapping and production-route metadata: false.

The UI retains useful worker/scope/gate/identity/transport configuration context without receiving the raw metadata object.

## 5. Job Detail UAT

Representative current Job:

`13aae16b-71f4-425c-9424-0b8340b3682d`

Results:

- `source.metadata.credential_filter` absent;
- `source.metadata.discovery_url` absent;
- safe `worker_version` retained;
- generic retry enabled = false;
- generic replay enabled = false;
- generic reset enabled = false.

The job's governed run semantics, Evidence links and counters remain available; only Source metadata is reduced to the safe operational projection.

## 6. Role / ACL / dispatcher regression

| Check | Result |
|---|---|
| authenticated EXECUTE on `public.admin_read(text,jsonb)` | PASS — allowed |
| anon EXECUTE on `public.admin_read(text,jsonb)` | PASS — denied |
| simulated authenticated UUID without Pipeline role | PASS — `42501 pipeline_operator role required` |
| authenticated direct `pipeline` schema USAGE | PASS — denied |
| public SECURITY DEFINER executable by authenticated | PASS — 0 |
| public SECURITY DEFINER executable by anon | PASS — 0 |
| sanitiser helper executable by anon | PASS — denied |
| Evidence `evidence_page` route after dispatcher replacement | PASS — 1,567 artifacts |
| Pipeline overview route after dispatcher replacement | PASS — 1,325 Jobs observed |
| Pipeline filters after dispatcher replacement | PASS — L1/L2/L3/L4/UNCLASSIFIED retained |

The shared dispatcher was reconciled from the live current definition before replacement so the later Evidence v1.0 routes were preserved.

## 7. Performance regression

Authenticated governed read, Sources page, limit 50:

- execution time: **~33.6 ms** DB-side;
- shared hit blocks: 3,795;
- temp spill: 0.

The sanitisation does not introduce a material load regression.

Original Pipeline Ops scale/performance acceptance remains valid, including the final Evidence entity-impact optimisation `20260820235820 — m1_pipeline_ops_evidence_entity_links_fast_v2`.

## 8. Security Advisor

Supabase Security Advisor was rerun after the DDL change.

No new migration-specific security warning was identified. Existing project-wide notices remain:

- RLS-enabled/no-policy INFO notices on private/default-deny schemas;
- Auth leaked-password-protection WARN, already documented as separate platform backlog and not introduced by this change.

Reference remediation for the latter: https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection

## 9. Authority / data regression

No change was made to:

- Provider/Course canonical identity;
- Layer 1 or Layer 2 facts;
- Layer 3 overwrite authority;
- Layer 4 review semantics;
- Evidence artifacts or private Storage;
- Search admission;
- Publication state;
- current Sources metadata stored server-side.

No generic retry/replay/reset mutation was introduced.

## 10. Final decision

**M1-PIPELINE-OPS: PASS.**

The prior BLOCKED handover is superseded. The residual rank-4 Source metadata projection issue is corrected at the server boundary, tested against the current PIM v2.12 + Evidence v1.0 runtime, and promoted without overwriting newer parallel work.