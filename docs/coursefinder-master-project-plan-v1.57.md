# CourseFinder Master Project Plan v1.57

**Status:** **AUTHORITATIVE PROGRAMME GOVERNANCE — M1-EVIDENCE-UX CLOSED / PASS**  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.56.md`  
**Last consolidated:** 21 August 2026 12:36 AEST  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Running build:** `docs/coursefinder-running-build-v2.60.md`  
**Admin/PIM decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.11.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.11.md`  
**Evidence UAT:** `docs/uat/coursefinder-m1-evidence-ux-technical-acceptance-2026-08-21.md`

## Current programme position

M1-PIM-FINALISATION remains **CLOSED / PASS**.

M1-PIPELINE-OPS remains **CLOSED / PASS** under `CF-CHG-20260821-016`.

M1-EVIDENCE-UX is now **CLOSED / PASS** under `CF-CHG-20260821-017`.

The accepted Admin operational model is:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

Evidence now spans that journey as a governed cross-layer lineage rather than a file list.

## Accepted implementation authority

Current accepted Pilot source/head:

`msinghbs-ai/Coursefinder-Pilot@d036fa64c190db98ed44c33fe265d0b47860f97e`

Visible release marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · governed`

Pilot PR:

`Coursefinder-Pilot#14`

GitHub `Pilot Frontend Build #99 / 32439107994` passed before promotion. Authenticated browser UAT passed on the Cloudflare candidate runtime before merge.

## Evidence operational acceptance

Accepted Evidence lineage:

`Source → Acquisition Job → Evidence Artifact/Snapshot → Observation/Claim → Canonical Entity/Field → Review/Decision → Search/Publication consequence`

Accepted behaviours:

- dedicated rank-3+ Evidence workspace;
- filters for country, source, layer, entity type, entity/provider/job scope, evidence type, MIME, verification date, freshness, hash, status, extraction state and unresolved conflicts;
- Country-aware Source choices with incompatible Source reset on Country change;
- bounded server-side list/detail reads;
- source authority, acquisition job, artifact hash/version/validity and safe Storage metadata;
- extracted observation and affected canonical-entity lineage;
- Provider/Course/Campus/Scholarship → Evidence navigation;
- exact evidence-bearing Course values → supporting artifact where `evidence_id` exists;
- Evidence → canonical return navigation;
- explicit source-null, missing-extraction, stale, conflict, rejected, current and superseded states;
- safe signed Preview/Download through the private Evidence access service;
- high-volume observation guard above 500 observations;
- Search/publication consequence displayed as downstream context without collapsing authority layers.

## Browser-discovered defect and correction

Authenticated UAT identified that selecting Country correctly filtered Evidence results but the Source dropdown still exposed global sources.

Correction accepted under the same Change Control:

`20260821021205 — m1_evidence_ux_country_source_filter_v1`

All 43 Evidence sources now carry `country_code` in governed filter metadata. Browser re-test confirmed Australia shows Australian sources only and Canada shows Canadian sources only.

## Performance and scale gate

Evidence acceptance was performed against real Pilot scale:

- 1,567 Evidence Artifacts;
- 43 represented Sources;
- 1,113 represented acquisition Jobs;
- 387 artifacts with extraction;
- 1,180 missing-extraction artifacts;
- 1,540 private Evidence Storage objects;
- largest observed Evidence artifact with 103,315 observations/entity links.

Measured current-path performance:

- Evidence page, 50 rows, warm: ~55.7 ms;
- high-volume Evidence detail: ~181 ms;
- first 100 entity links for the 103,315-observation artifact: ~459 ms;
- entity-link temp spill: 0 blocks.

The previously observed ~17.6-second bulk observation expansion is suppressed automatically above 500 observations.

## Security position

The accepted Admin boundary remains:

`Supabase Auth → public.admin_read(text,jsonb) → server-side role/rank check → governed internal read`

- Evidence / Review Queue require Curator+ rank 3;
- Pipeline Control / Jobs / Sources require Pipeline Operator+ rank 4;
- anon cannot execute governed Admin reads;
- internal Evidence tables/Storage remain server-mediated/private;
- `admin-evidence-access` rechecks role before issuing 60-second signed access;
- service-role credentials remain server-side;
- authenticated browser network UAT found no raw private Storage/service-role credential exposure;
- no new browser internal-schema CRUD was introduced.

A rank-3 Curator read passed and below-rank authenticated access was denied with SQLSTATE `42501`. The server remains the authority boundary.

## Pipeline Ops coexistence

Pipeline Ops v1.0 remains accepted and unchanged in authority. Evidence v1.0 preserves:

- Pipeline Ops launcher/runtime;
- Layer 1–4 operations semantics;
- rank-4 Pipeline Operator boundary;
- final Evidence entity-impact optimisation;
- no generic retry/replay/reset mutation.

## Governing records

- `CF-CHG-20260820-006` — Evidence provenance/private boundary — CLOSED / PASS;
- `CF-CHG-20260820-013` — Pipeline Operator role/safe Sources boundary — CLOSED / PASS;
- `CF-CHG-20260820-015` — PIM operational/browser baseline — CLOSED / PASS;
- `CF-CHG-20260821-016` — M1 Pipeline Operations — CLOSED / PASS;
- `CF-CHG-20260821-017` — M1 Evidence UX — **CLOSED / PASS**.

## Preserved architecture position

Database Architecture v2.10.38 remains current. Evidence UX consumed/extended accepted governed read metadata and Admin navigation; it did not change canonical Provider/Course identity architecture and therefore does not justify an architecture-version bump.

## Current baseline for subsequent work

Subsequent CourseFinder workstreams should use:

- Master Project Plan v1.57;
- Running Build v2.60;
- Database Architecture v2.10.38;
- Admin/PIM Design Decisions v1.11;
- PIM Admin Guide v1.11;
- accepted Pilot head `d036fa64c190db98ed44c33fe265d0b47860f97e`.

Future Evidence mutations, review-decision workflows, supersession rules or authority-semantic changes require a new or applicable Change Control rather than extending `017` implicitly.
