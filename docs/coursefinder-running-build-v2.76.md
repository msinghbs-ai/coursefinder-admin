# CourseFinder Running Build v2.76

**Status:** M1 FROZEN / M2.1 CLOSED-PASS / M2.2 CLOSED-PASS / M2.3 CLOSED-PASS / M2.4.0 CLOSED-PASS / M2.4.1 CLOSED-PASS / **M2.4.2 CLOSED-PASS**  
**Date:** 29 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.75.md`  
**Master Project Plan:** `docs/coursefinder-master-project-plan-v1.76.md`  
**Change Controls:** `CF-CHG-20260826-042`, `CF-CHG-20260827-044`

## Accepted Pilot runtime

**Final M2.4.2 source / corrective Stage C acceptance SHA:**

`msinghbs-ai/Coursefinder-Pilot@093010fada8391c93626b59e59c678064f4961c3`

Visible browser release:

- PIM Admin `v2.15.9`;
- Layer 1 Ops `v1.0`;
- accepted M2.3 Layer 2/3/4 capabilities remain inherited.

Final acceptance evidence:

- Frontend Build `32972106272` — PASS;
- build job `98188036405` — PASS;
- browser smoke `98188175754` — PASS;
- deployed Stage C UAT `32972106291` — PASS;
- deployed acceptance job `98188037242` — desktop/mobile PASS.

## M2.4.2 accepted closure

M2.4.2 closes Layer 2 Full Enrichment, Operations Maturity & Performance for the accepted Pilot scope while preserving the blocked/deferred items explicitly listed below.

### Accepted operator/runtime changes

- normal Layer 2 operator path remains one governed Sync action with explicit Direct HTTP → Firecrawl → governed fallback → Evidence routing;
- State/University/Course filters are paged and tablet-safe with 10-item bounded option pages;
- Advanced configuration exposes qualified, paused and disabled Course/Scholarship profiles for operational visibility without making paused profiles executable;
- Course detail uses the wider responsive decision workspace with contextual QILT outcomes, PRISMS student-flow context and Scholarship funding context while preserving actual source granularity;
- Firecrawl screenshot Evidence is retained as secondary visual Evidence with private signed thumbnail/full-view access; source/raw Evidence remains authoritative;
- per-user catalogue state and Course-card layout preferences persist correctly;
- transient Evidence-detail 5xx responses use bounded retry only, with recovered 5xx retained separately and unrecovered 5xx remaining hard UAT failures.

### A14 telemetry baseline

Layer 2 and Layer 3 performance/usage telemetry is now a standing contract.

Final M2.4.2 snapshot:
- Direct HTTP: 2,246 attempts, 1,442 succeeded, avg ~732 ms, p95 ~1,819 ms;
- Firecrawl: 740 attempts, 671 succeeded, avg ~8,607 ms, p95 ~20,635 ms;
- Scrape.do: 52 attempts, 2 succeeded, avg ~4,439 ms, p95 ~9,579 ms;
- ZenRows: 39 attempts, 2 succeeded, avg ~7,979 ms, p95 ~23,842 ms;
- Layer 3 Nemotron benchmark history: 26 external calls, 10,462 input tokens, 7,078 output tokens;
- OpenRouter/free trial: 5 calls, 452 input / 422 output tokens;
- GPT-OSS free trial: 7 calls with provider usage unavailable/zero-retained;
- accepted production Layer 3 interpretations: 0.

Historical provider-attempt vendor-unit/cost gaps are not backfilled by inference. New active Layer 2 attempt paths and Layer 3 model-call paths retain their applicable provider/model/call/token/latency/cost fields.

### Refresh/promotion disposition

- UQ weekly Course refresh: ENABLED;
- RMIT weekly Course refresh: DISABLED;
- Federation weekly Course refresh: DISABLED; source profile PAUSED/source-limited;
- RMIT frozen canonical-promotion cohort: 212/212 identity matched, 0 unsafe, 0 applied, fingerprint `627bb7daa62fe3bbfc3047ce2b57a88e`;
- RMIT promotion remains separately BLOCKED because no already-authorised exact frozen-set executor exists; no privileged bypass was introduced;
- Layer 3 source-pattern profile remains separately BLOCKED under its unchanged quality threshold.

### Final validation evidence

- targeted A12: `33175425752` — PASS;
- targeted A13: `33174990072` — PASS;
- Stage B integration: `33214733610` — desktop/mobile PASS;
- historical first Stage C: `33215640328` — FAIL 45/46 desktop because of a stale pre-A12 reorder assertion; retained as immutable evidence;
- explicit governance reopening authorised one corrective Stage C;
- corrected UAT source: `60e9e25a86a48522dbae7a29d6c2955c9d295761`;
- corrective Stage C candidate: `093010fada8391c93626b59e59c678064f4961c3`;
- corrective Stage C run: `33219089690` — **45/45 desktop PASS and 45/45 mobile PASS**.

No security, authority, paging, Evidence, cost or performance assertion was weakened to obtain PASS.

### Final security/performance state

- Security Advisor: 131 INFO / 0 WARN / 0 ERROR;
- Performance Advisor: 167 INFO / 0 WARN / 0 ERROR.

Relevant active Edge versions:
- `layer2-acquire-v2` v9;
- `layer2-scope-discover-scheduled` v19;
- `layer2-scale-qualify-scheduled` v3;
- `layer3-interpret` v3;
- `layer3-provider-control` v2;
- `layer3-source-pattern-benchmark` v7;
- `admin-evidence-access` v2;
- `layer2-screenshot-backfill-scheduled` v1.

Parallel `zoho-course-api` remains v9 and was not modified by closure.

## M2.4.1 accepted changes

### Layer 1 Regulatory operations

`Data Operations → Layer 1 — Regulatory` is now the normal AU/NZ regulatory operations workspace with:

- Source Health;
- Current / Next Job;
- Progress;
- Reconciliation;
- Evidence / Provenance;
- Schedule / Recheck;
- Blockers / Required Actions.

Experimental/destructive controls remain outside the normal operator journey.

### Source governance and safety

Accepted AU/NZ operations profiles retain approved authority domains, expected source format/count semantics, verification/ingestion cadence, prior accepted count, observed count, warning/block thresholds and retained configuration versions.

Saving source configuration forces revalidation. Reachability alone cannot override authority-domain checks.

Rank >=4 may read/validate. Rank >=6 retains consequential configuration, dry-run/APPLY, pause/resume and recovery authority. Warning APPLY requires explicit acknowledgement; blocking variance cannot execute.

### Queue, progress and recovery

Accepted Layer 1 execution now includes:

- database-enforced one-active-run-per-source protection;
- idempotency/replay protection;
- heartbeat/stuck visibility;
- queue position and runtime;
- retry/resume linkage and resume cursor;
- cumulative Created/Updated/Unchanged/Rejected/Conflicted/Failed reconciliation;
- hash-sensitive `no_change` path;
- bounded Platform Admin recovery of a genuinely stale running job.

### Scheduling and housekeeping

Authoritative-source rechecks use a dedicated non-destructive schedule and short-lived one-time nonce execution. Changed source state does not silently APPLY canonical data.

Paused sources are excluded. Stale scheduled dispatches fail visibly instead of remaining indefinitely active.

Transient terminal Layer 1 queue state has 30-day retention. Daily housekeeping cannot delete governed Evidence, source-operation versions or canonical history.

## Live source proof

### AU CRICOS

- 26,648 active Course rows;
- 90 expired;
- 26,738 total;
- CKAN package/resource/identity checks passed;
- parser derives active count from source `Expired` semantics rather than a hard-coded baseline assertion.

### NZ NZQA

- 411 unique current providers across UNI/POLLY/WANA/PTE/GTE;
- previous accepted comparison baseline 409;
- approximately 0.489% variance, PASS under 5% warning / 20% block thresholds.

## Database / Edge reconciliation

Pilot repository truth mirrors the deployed M2.4.1 control-plane, scheduler, recovery and housekeeping migration chain and both Edge sources.

The final accepted `public.admin_read` bridge reconciliation migration `20260826124452` preserves Data Quality and Layer 2 dispatches while adding Layer 1 operations.

Mirrored Edge runtimes:

- `layer1-operations-control-v1.0.1`;
- `layer1-operations-scheduled-v1.0.0`.

## Security / performance state

Final Security Advisor contains no new material M2.4.1 Critical/High/Warning finding. Layer 1 tables remain RLS-protected with no direct browser policy/grant path; browser authority is through governed bridge/helper contracts with server-side rank checks.

Final Performance Advisor contains no unindexed Layer 1 foreign key. Low-traffic Layer 1 indexes may remain as unused INFO where required for governed FK/drill-through paths.

## Staged validation evidence

Final accepted chain after correcting one obsolete permanent-test patch-version assertion:

- Stage A targeted: `721658a732c763892179250fee1c0268bd27051d`, run `32971449084` — PASS;
- Stage B bounded integration: `98172a4f616291212253c23f16fe1ab633b9c34b`, run `32971584012` — desktop/mobile PASS;
- Stage C acceptance: `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`, run `32972106291` — desktop/mobile PASS.

No performance threshold, security/rank boundary, authority contract or data assertion was weakened to obtain PASS.

## Documentation state

Current accepted guides:

- `docs/coursefinder-m2-4-data-operations-admin-guide-v1.2.md`;
- `docs/coursefinder-operations-runbook-v1.3.md`;
- `docs/coursefinder-pim-admin-guide-v1.21.md`.

## Gate state

- M1 — CLOSED / PASS / FROZEN;
- M2.1 — CLOSED / PASS;
- M2.2 — CLOSED / PASS;
- M2.3 — CLOSED / PASS — NZ L2 EXPANSION DEFERRED;
- M2.4.0 — CLOSED / PASS;
- M2.4.1 — CLOSED / PASS;
- M2.4.2 — **CLOSED / PASS**;
- M2.4.3 — **NEXT / READY**;
- M2.4.4 — PLANNED;
- broad Publication — NOT AUTHORISED;
- Production cutover — NOT AUTHORISED.

## Next programme gate

Proceed to M2.4.3 Layer 3 AI Operations Maturity, inheriting the accepted Layer 1/Layer 2 authority, Evidence, telemetry and staged-UAT contracts. The existing source-pattern model-quality blocker remains an input to M2.4.3 and must not be bypassed.

NZ first-party Layer 2 Course enrichment remains deferred unless separately source-qualified and authorised.

## Commercial/time boundary

Technical execution does not create billable-time entries. The maintained engagement-time record remains authoritative.