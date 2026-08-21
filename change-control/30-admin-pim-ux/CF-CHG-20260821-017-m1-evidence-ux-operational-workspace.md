# CF-CHG-20260821-017 — M1-EVIDENCE-UX Operational Evidence Workspace

**Category:** `30-admin-pim-ux`  
**Initiated:** 21 August 2026, 09:40 AEST  
**Status:** **BLOCKED — all source/build/deployment/DB/role/security/performance gates PASS; authenticated interactive browser acceptance remains unavailable**  
**Workstream:** `M1-EVIDENCE-UX`  
**Primary repository:** `msinghbs-ai/Coursefinder-Pilot`  
**Governance repository:** `msinghbs-ai/coursefinder-admin`

## 1. Purpose

Promote Evidence from a narrow provenance/file-list surface into a first-class Admin operational workspace spanning Layer 1 regulatory evidence, Layer 2 deterministic/structured enrichment, Layer 3 AI suggestions, Layer 4 human resolution and current Search/publication consequence state, without changing authority semantics or weakening the private evidence boundary.

Required lineage:

`Source → Acquisition Job → Evidence Artifact/Snapshot → Extracted Observation/Claim → Canonical Entity/Field → Review/Decision → Search/Publication consequence`

## 2. Reconciled current baseline

This workstream was re-reconciled after `M1-PIPELINE-OPS` advanced in parallel.

Current accepted baseline retained:

- `CF-CHG-20260820-006` — accepted initial Evidence provenance/ACL baseline, CLOSED / PASS;
- `CF-CHG-20260820-015` — accepted PIM Admin v2.11 browser/security baseline, CLOSED / PASS;
- `CF-CHG-20260821-016` — Pipeline Ops v1.0, CLOSED / PASS;
- Master Project Plan v1.56;
- Running Build v2.59;
- Database Architecture v2.10.38;
- PIM Admin Guide v1.10;
- accepted Pilot head before this candidate: `848e302b19186cb0a751f74f23f06a244c5b0b2d`.

The Evidence branch was explicitly synchronised with the accepted Pipeline Ops mainline before further UAT. Pipeline Ops entry points, migrations and runtime markers are preserved. No newer parallel work is overwritten.

## 3. Existing deployed Evidence server contract preserved

Live Supabase already contains the governed Evidence operational contract required by this UI, including role-checked operations for:

- `evidence_page`;
- `evidence_filters`;
- `evidence_detail`;
- `evidence_observations`;
- `evidence_entities`.

The live `public.admin_read(text,jsonb)` dispatcher is SECURITY INVOKER and routes those operations through private security-schema functions. The existing `admin-evidence-access` Edge Function remains the only authorised short-lived object-access path used by the candidate UI.

The workstream does not replace or reapply the existing Evidence server functions merely to make source history look linear.

## 4. Candidate UI

Pilot branch: `m1-evidence-ux-operational-workspace`  
Pilot PR: `msinghbs-ai/Coursefinder-Pilot#14`  
Reconciled candidate head: `ab682a561a3121c1ca51c0fd3d9b427c539eb049`  
Target release marker: `PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · governed`

Candidate capabilities:

- filters for country, source, layer, entity type, canonical entity/provider scope, acquisition job, job status, evidence type, MIME, verification dates, freshness, hash, status, extraction state and unresolved conflicts;
- dedicated Evidence decision grid with source/layer/job, capture time, extraction state/count, freshness, conflict/status, hash and private-object availability;
- detail lineage showing source authority, acquisition metadata, content hash, snapshot/version, safe storage descriptor, Change Controls, claims/reviews/actions and current downstream Search/publication context;
- Provider/Course/Campus/Scholarship → Evidence scoped navigation;
- exact evidence-bearing Course values → supporting artifact navigation where an evidence identifier is persisted;
- Evidence → canonical entity navigation;
- explicit states for source-null, missing extraction, stale, conflicting, rejected, current and superseded values;
- safe preview/download through existing signed private access only;
- high-volume guard: artifacts with more than 500 observations do not invoke the unbounded observation expansion automatically.

No Provider/Course identity, source authority, ingestion behaviour, Search admission, publication rule or private Storage policy is changed.

## 5. Current live corpus observed

- Evidence artifacts: **1,567**;
- represented sources: **43**;
- represented acquisition jobs: **1,113**;
- artifacts with extracted observations: **387**;
- missing-extraction artifacts: **1,180**;
- artifacts containing source-null observations: **1**;
- private Evidence Storage objects: **1,540**;
- current materialised Evidence/entity links include a 103,315-observation regulatory artifact and other national snapshots;
- claims/reviews/open conflicts and explicit supersession links remain valid empty states where no persisted records exist.

## 6. Reconciled performance UAT

Measured against the current live Supabase state after the Pipeline Ops Evidence entity-impact optimisation:

| Gate | Result |
|---|---:|
| Evidence page, 50 rows, warm governed path | **~55.7 ms — PASS** |
| Representative high-volume Evidence detail | **~181.0 ms — PASS** |
| First 100 entity links for 103,315-observation snapshot | **~459.1 ms — PASS** |
| Temp spill on optimised entity-link page | **0 temp blocks — PASS** |
| Legacy unbounded 103,315-observation expansion | **not invoked by candidate browser above 500 observations** |

A first cold `admin_read('evidence_page')` execution during reconciliation took ~3.64 s while warming buffers; the immediate governed repeat was ~55.7 ms. This is retained as cold-start evidence rather than hidden. The operational UI provides loading state and does not bulk materialise the 103,315 observations into the drawer.

## 7. Role/security UAT

PASS evidence:

- transactional Curator role test resolved `security.current_role_rank()` to **3** and successfully returned Evidence through `public.admin_read`;
- an authenticated identity with no CourseFinder role was rejected with SQLSTATE **42501 / curator role required**;
- Evidence navigation minimum role remains rank 3+;
- `public.admin_read` remains SECURITY INVOKER;
- internal Evidence tables and Storage remain server-mediated/private;
- raw private Storage paths are not used as browser object access;
- service-role credentials remain server-side in `admin-evidence-access`;
- signed access expiry remains 60 seconds;
- the existing platform-wide leaked-password-protection advisor item is pre-existing and is not weakened or altered by this workstream.

## 8. Build and preview deployment UAT

- GitHub Actions `Pilot Frontend Build` run **#97 / 32432274493** — **PASS** on reconciled head `ab682a56`;
- Cloudflare Workers Git integration reported **Deployment successful** for the same commit;
- commit preview and branch preview URLs were generated by Cloudflare for PR #14;
- Pipeline Ops entry point is retained in the reconciled candidate shell alongside the Evidence v2.12 runtime.

## 9. Remaining blocker — authenticated interactive browser acceptance

The project acceptance standard requires the deployed/preview browser to prove the actual signed-in interaction path, including:

1. rank <3 cannot use Evidence;
2. rank 3+ can filter/page/open detail;
3. canonical → Evidence scoped deep links resolve correctly;
4. exact evidence-bearing fee/intake/English values open the correct artifact when an evidence ID exists;
5. Evidence → canonical return navigation resolves correctly;
6. high-volume snapshot opens without the legacy 17.6-second observation expansion;
7. preview/download produces only authorised expiring signed access;
8. browser network/runtime does not expose raw private Storage paths/service-role credentials;
9. responsive/narrow layout remains usable;
10. no unexplained browser 4xx/5xx or stale-request UX regressions occur.

This environment can verify source, CI, deployed preview existence and live authenticated server contracts, but it does not provide an interactive authenticated browser/session capable of executing and observing that final signed-in UI/network gate. The gate is therefore not represented as PASS.

## 10. Rollback / release rule

PR #14 remains a candidate and must not be promoted as accepted production solely on build/SQL evidence. The accepted production Admin remains PIM v2.11 + Pipeline Ops v1.0 until the authenticated browser gate is completed.

No database rollback is required if the candidate is abandoned because this workstream did not replace the existing live Evidence server contract.

## 11. Verdict

**BLOCKED WITH EVIDENCE.**

All currently executable technical gates pass. The only remaining blocker is authenticated interactive browser acceptance on the Cloudflare candidate runtime. Once that evidence is obtained, this record may move directly to CLOSED / PASS without reopening the completed database/security/performance work.
