# CourseFinder Running Build v2.75

**Status:** M1 FROZEN / M2.1 CLOSED-PASS / M2.2 CLOSED-PASS / M2.3 CLOSED-PASS / M2.4.0 CLOSED-PASS / **M2.4.1 CLOSED-PASS**  
**Date:** 27 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.74.md`  
**Master Project Plan:** `docs/coursefinder-master-project-plan-v1.75.md`  
**Change Controls:** `CF-CHG-20260826-040`, `CF-CHG-20260826-042`, `CF-CHG-20260826-043`

## Accepted Pilot runtime

**Final M2.4.1 source / acceptance SHA:**

`msinghbs-ai/Coursefinder-Pilot@ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`

Visible browser release:

- PIM Admin `v2.15.7`;
- Layer 1 Ops `v1.0`;
- accepted M2.3 Layer 2/3/4 capabilities remain inherited.

Final acceptance evidence:

- Frontend Build `32972106272` — PASS;
- build job `98188036405` — PASS;
- browser smoke `98188175754` — PASS;
- deployed Stage C UAT `32972106291` — PASS;
- deployed acceptance job `98188037242` — desktop/mobile PASS.

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
- M2.4.1 — **CLOSED / PASS**;
- M2.4.2 — **NEXT / READY**;
- M2.4.3–M2.4.4 — PLANNED;
- broad Publication — NOT AUTHORISED;
- Production cutover — NOT AUTHORISED.

## Next programme gate

Proceed to M2.4.2 Layer 2 Full Enrichment, Operations Maturity & Performance, inheriting the accepted Layer 1 authority/security/operations contracts and staged UAT discipline.

NZ first-party Layer 2 Course enrichment remains deferred unless separately source-qualified and authorised.

## Commercial/time boundary

Technical execution does not create billable-time entries. The maintained engagement-time record remains authoritative.