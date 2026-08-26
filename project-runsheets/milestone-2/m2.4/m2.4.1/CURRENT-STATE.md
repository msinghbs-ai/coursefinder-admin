# M2.4.1 — Current State

**Status:** ACTIVE — bounded Stage B integration in progress  
**Change Control:** `CF-CHG-20260826-043`  
**Accepted starting Pilot:** `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`  
**Frozen working Pilot:** `fcb77befb797e98f9369b33a79ab29a4950717ff`  
**Stage B marker Pilot:** `69c21bab97cee34505787403af4f6065ddcd79f7`  
**Final targeted UAT:** `32968177074` — PASS

## Implemented runtime

- Production-shaped AU/NZ Layer 1 operations workspace: Source Health, Current/Next Job, Progress, Reconciliation, Evidence/Provenance, Schedule/Recheck and Blockers/Required Actions.
- Governed source authority/configuration with retained configuration versions, approved authority domains, expected source format/count semantics, cadence and variance guardrails.
- Rank split: Pipeline Operator rank >=4 may read and validate a governed source; Platform Admin rank >=6 retains source configuration, dry-run/APPLY queueing, pause/resume, retry/resume and stale-run recovery.
- AU CRICOS live validation dynamically checks CKAN package/resource shape and counts active Course rows from source `Expired` semantics rather than hard-coding the accepted baseline.
- NZ NZQA live validation checks all five accepted tertiary organisation listing types and deduplicates stable provider IDs.
- One-active-run-per-source queue guard, idempotency keys, heartbeat/stuck detection, resume cursor, cumulative reconciliation and no-change hash path.
- Scheduled authoritative-source verification using the existing M2.3 refresh substrate and short-lived one-time nonce; scheduled verification is non-destructive and never silently APPLYs canonical data.
- Scheduled dispatch timeout recovery after 30 minutes.
- Platform Admin `recover_stuck` operation bounded to a genuinely running job whose heartbeat is older than 30 minutes.
- Daily transient Layer 1 housekeeping at 03:17 UTC; only expired terminal queue state is eligible for deletion.

## Repository/runtime reconciliation

Pilot `96559a13c847330c78a0eb64101d94faa1936d76` mirrored the then-live nine M2.4.1 migrations and both deployed Edge sources into repository truth.

Pilot `fcb77befb797e98f9369b33a79ab29a4950717ff` added and mirrored final migration `20260826121631_m2_4_1_layer1_recovery_housekeeping_metadata.sql`, explicit APPLY warning confirmation, source-config version, queue position/runtime and stuck recovery UI.

Deployed Edge sources mirrored in Pilot:

- `supabase/functions/layer1-operations-control/index.ts` — runtime `layer1-operations-control-v1.0.1`;
- `supabase/functions/layer1-operations-scheduled/index.ts` — runtime `layer1-operations-scheduled-v1.0.0`.

## Operational evidence

### Real AU CRICOS validation

- accepted comparison baseline: 26,648 active CRICOS Course rows;
- live validation: 26,648 active, 90 expired, 26,738 total rows;
- authority/package/resource shape passed;
- parser no longer relies on a hard-coded 26,648 assertion.

### Real NZ NZQA validation

- previous accepted baseline remains 409 providers;
- live source currently returns 411 unique providers across UNI/POLLY/WANA/PTE/GTE;
- variance approximately 0.489%; decision PASS under initial 5% warning / 20% block thresholds.

### Scheduled recheck

A real NZ scheduled verification request completed through the one-time nonce path in approximately six seconds, advanced next verification, recorded `completed_changed`, and did not APPLY canonical data.

### Queue / retry / resume / idempotency — rollback-safe proof

- concurrent second active source run blocked by the unique one-active-source guard;
- failed run retried with explicit `retry_of` linkage;
- resume cursor progressed from 100 to 411;
- reconciliation counters accumulated rather than reset;
- duplicate idempotency replay was blocked;
- transaction rollback left no test queue residue.

### Variance / pause / stuck guards — rollback-safe proof

- simulated AU count 1,000 versus 26,648 produced -96.2474% variance, `block`, and APPLY rejection;
- paused NZ source produced zero scheduled requests;
- scheduled request older than 30 minutes was automatically failed with a visible schedule error;
- regular running NZ job with heartbeat 31 minutes old was successfully recovered through rank-6 `recover_stuck`, then rolled back.

### Housekeeping — rollback-safe proof

One expired terminal queue record was removed while Evidence remained 1,696 → 1,696 and retained source-operation versions remained 2 → 2.

## Security / performance evidence

Final browser/data ACL reconciliation:

- `anon`: no Layer 1 read/command/service-function/table access;
- `authenticated`: public Admin read/command bridges only; no direct Layer 1 table or service-only helper access;
- `service_role`: service helpers/table access as required;
- rank is independently enforced inside security functions/Edge authority checks.

Final Security Advisor after M2.4.1 database shape reports INFO-only `rls_enabled_no_policy` observations; no M2.4.1 Critical/High/Warning finding is present. Layer 1 tables deliberately use RLS with no browser policies/direct grants.

Final Performance Advisor reports no unindexed Layer 1 foreign keys. Fresh/low-traffic Layer 1 indexes may appear as unused INFO, including `layer1_run_queue_actual_job_idx`; it is retained because it covers the actual-job FK/drill-through path.

## UAT progression

### Stage A — PASS

Final frozen working candidate `fcb77befb797e98f9369b33a79ab29a4950717ff`:

- deployed UAT `32968177074`: PASS;
- targeted suite = Layer 1 only;
- desktop only during development by A7 design;
- includes real AU CRICOS and NZ NZQA authority/count validation and rank-4 UI authority assertions.

### Stage B — ACTIVE

Integration marker `69c21bab97cee34505787403af4f6065ddcd79f7` points to frozen working SHA `fcb77bef…`.

Deployed integration run `32968310102` is executing the bounded desktop/mobile regression set covering Layer 1, Admin navigation, Data Quality, performance, screen-state persistence and release notes.

No Pilot application/runtime change is authorised while this candidate is under evaluation. A substantive fix invalidates the candidate and requires Stage A → Stage B again.

## Documentation

Admin repo commit `09b20d1fe74b2b9a3ce3a36af98305a051fb3d14` published:

- Data Operations Admin Guide v1.2;
- Operations Runbook v1.3;
- PIM Admin Guide v1.21.

These match the deployed M2.4.1 authority, validation, variance, scheduling, recovery, retry/resume and housekeeping behaviour.

## Current acceptance position

Stage C is not yet authorised. Stage B must PASS first. If Stage B passes without code/runtime change, nominate one frozen acceptance marker and execute exactly one complete deployed desktop/mobile Stage C matrix.

M2.4.2 remains blocked until M2.4.1 is formally CLOSED/PASS.