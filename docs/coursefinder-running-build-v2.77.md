# CourseFinder Running Build v2.77

**Status:** CURRENT — M2.4.3 ACTIVE / A15 CONTACT INTELLIGENCE IN IMPLEMENTATION
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

Final M2.4.2 acceptance evidence:

- Stage B integration `33214733610` — chromium-desktop PASS / chromium-mobile PASS;
- historical first Stage C `33215640328` — 45/46 desktop PASS with one stale pre-A12 reorder assertion; mobile skipped; retained as immutable failed-gate evidence;
- explicit governance reopening authorised one corrective Stage C;
- corrected UAT source `60e9e25a86a48522dbae7a29d6c2955c9d295761`;
- corrective Stage C candidate / accepted Pilot `093010fada8391c93626b59e59c678064f4961c3`;
- corrective Stage C `33219089690` — **45/45 chromium-desktop PASS and 45/45 chromium-mobile PASS**;
- final Security Advisor: 131 INFO / 0 WARN / 0 ERROR;
- final Performance Advisor: 167 INFO / 0 WARN / 0 ERROR.

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

- `docs/coursefinder-m2-4-data-operations-admin-guide-v1.4.md`;
- `docs/coursefinder-operations-runbook-v1.6.md`;
- `docs/coursefinder-pim-admin-guide-v1.21.md`.

## Accepted architecture baseline

- `docs/coursefinder-database-architecture-v2.10.43.md`;
- `docs/coursefinder-admin-pim-design-decisions-v1.19.md`.

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

## M2.4.3 A15 — Institute International Contact Intelligence

Status: **ACTIVE — TARGETED UAT PASS / COHORT ROLLOUT IN PROGRESS**

Governance:
- CF-CHG-20260829-046;
- Execution Addendum A15;
- Database Architecture v2.10.44;
- Admin/PIM Design Decisions v1.20.

Implemented:
- private contact profile/observation/watch/telemetry schema;
- Provider-detail governed contact projection;
- Provider blade International contacts decision section;
- PIM Admin v2.15.10 release notes;
- first-party university contact discovery worker;
- optional Apollo professional-title search adapter;
- service-role bridges and one-time scheduled execution controls;
- source precedence and contact-change semantics.

Initial target cohort:
- AU 52;
- NZ 8;
- total 60 governed Provider profiles.

Live quality proof:
- UQ: 8 accepted current first-party International Regional Manager assignments;
- source: governed university regional-manager page on `study.uq.edu.au`;
- evidence-backed institutional emails and territory mappings retained;
- targeted deployed browser UAT PASS: run `33221965310`.

Rollout hardening:
- malformed duplicate-scheme NZ discovery URLs normalised only in the Layer 2 transport profile;
- canonical Layer 1 website values remain untouched pending governed source correction;
- Direct HTTP → Firecrawl fallback added for 403/429/5xx/network-limited first-party pages;
- contact acquisition attempts retain provider, calls, units, latency, estimated cost and outcome.

Open before A15 closure:
- reconcile full 60-profile first-party sweep;
- prove fallback behavior and source-limited outcomes;
- verify Apollo configuration and bounded no-reveal behavior if credential exists;
- Security/Performance Advisors;
- bounded integration regression and final acceptance;
- closure documentation with exact accepted runtime refs.


## A15 frozen first-party rollout baseline

A15 international contact intelligence is implemented and first-party cohort rollout is complete.

Runtime:
- Pilot freeze: `f9e4e530462b49cf5a83ad8e0d5137631255028a`;
- first-party worker: `provider-contact-discover-scheduled-v1.3.2` / Edge v15;
- Provider detail International contacts UI: PIM Admin v2.15.10;
- targeted deployed UAT: PASS `33229889360`.

Coverage:
- 52/52 AU profiles successful;
- 8/8 NZ profiles successful;
- 0 current errors;
- 31 current contacts across 11 Providers;
- 17 territory-assigned contacts;
- 45 rejected historical/noisy observations retained.

Acquisition telemetry:
- Direct HTTP 319 attempts, 154 succeeded, 165 failed/fell through, avg 599.41 ms, p95 1,944.5 ms;
- Firecrawl 107 attempts, 107 succeeded, 107 page units, avg 3,996.84 ms, p95 7,132.2 ms.

Recovery cases:
- Wellington HTTP 410: live `wgtn.ac.nz` International Office entry point plus governed Firecrawl fallback;
- CQU HTTP 403: governed Firecrawl recovery;
- Bond Evidence uniqueness error: serialized retry PASS.

Advisors remain 0 WARN / 0 ERROR.
