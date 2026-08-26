# M2.4.1 — Layer 1 Regulatory Operations Maturity & Automation

**Status:** CLOSED / PASS  
**Parent:** M2.4  
**Started:** 26 August 2026 20:52 AEST (+10:00)  
**Closed:** 27 August 2026 04:18 AEST (+10:00)  
**Accepted starting Pilot:** `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`  
**Accepted final Pilot:** `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`  
**Change Control:** `CF-CHG-20260826-043` — CLOSED/PASS  
**Governance:** `PROJECT_INSTRUCTIONS.md`, M2 Standing Instructions, A1–A7

## Objective — achieved

Layer 1 is now a mature regulatory-operations workspace for AU CRICOS and NZ NZQA with governed source validation, count/variance safety, queue/progress/reconciliation, Evidence/provenance, retry/resume/idempotency, scheduled rechecks, stale/stuck recovery and safe transient housekeeping.

The accepted normal journey is:

`Regulatory source → validate source → assess expected count/variance → queue/run → live progress/reconciliation → Evidence/Jobs → scheduled recheck → housekeeping`.

## Accepted operator workspace

`Data Operations → Layer 1 — Regulatory` exposes:

1. Source Health;
2. Current / Next Job;
3. Progress;
4. Reconciliation;
5. Evidence / Provenance;
6. Schedule / Recheck;
7. Blockers / Required Actions.

Experimental parser/reset/probe/destructive controls do not form part of the normal operator journey.

## Accepted control-plane behaviour

- versioned AU/NZ source-operation profiles;
- approved authority domains and expected source format contracts;
- expected-count kind, prior accepted count, current observed count and warn/block thresholds;
- rank >=4 read/validate authority; rank >=6 configuration, dry-run/APPLY, pause/resume and recovery authority;
- explicit warning acknowledgement before APPLY;
- blocking variance prevents execution;
- one active run per source at database level;
- idempotency and replay protection;
- heartbeat/stuck visibility, queue position and runtime;
- retry/resume linkage and resume cursor;
- cumulative Created/Updated/Unchanged/Rejected/Conflicted/Failed reconciliation;
- source hash comparison and `no_change` execution path;
- scheduled non-destructive authoritative-source validation via one-time nonce;
- paused-source exclusion and stale scheduled-dispatch failure handling;
- bounded Platform Admin `recover_stuck` for >30-minute stale running work;
- 30-day transient queue retention;
- daily housekeeping that cannot delete governed Evidence, source-operation versions or canonical history.

## AU CRICOS live proof

- authority: Australian Government CRICOS dataset on `data.gov.au`;
- live validation: 26,648 active, 90 expired, 26,738 total Course rows;
- required CKAN package/resources and CRICOS Course Code identity passed;
- parser derives active count from source `Expired` semantics rather than a hard-coded 26,648 assertion.

## NZ NZQA live proof

- authority: NZQA Education Organisations on `nzqa.govt.nz`;
- live validation: 411 unique providers across UNI/POLLY/WANA/PTE/GTE;
- previous accepted baseline: 409;
- observed variance approximately 0.489%; PASS under 5% warning / 20% block thresholds.

## Recovery / scheduler / housekeeping proof

- concurrent second active source run blocked;
- idempotency replay blocked;
- retry retained `retry_of` linkage and resume cursor progressed;
- reconciliation accumulated across continuation batches;
- simulated major AU variance blocked APPLY;
- paused NZ source created no scheduled request;
- real NZ scheduled source verification completed through the nonce path without canonical APPLY;
- >30-minute scheduled dispatch was failed visibly;
- >30-minute regular running job was recoverable only through rank-6 bounded recovery;
- housekeeping removed an eligible expired queue record while Evidence and retained source-operation versions remained unchanged.

## Security / ACL gate

Accepted boundary:

- `anon`: no Layer 1 read/command/table/service-helper access;
- `authenticated`: public governed Admin bridges only, with independent server-side rank checks;
- `service_role`: worker/scheduler helper/table access as required.

Final Security Advisor: INFO-only observations; no new material M2.4.1 Critical/High/Warning finding.

Final Performance Advisor: no unindexed Layer 1 foreign key. Retained low-traffic Layer 1 indexes may appear as unused INFO.

## Repository/runtime reconciliation

Pilot repository truth mirrors all deployed M2.4.1 database/Edge changes, including:

- Layer 1 control-plane/queue/ACL/read/progress/scheduler/recovery/housekeeping migration chain;
- final recovery/housekeeping metadata migration;
- accepted `public.admin_read` bridge reconciliation migration `20260826124452` preserving Data Quality and Layer 2 dispatches while adding Layer 1;
- `layer1-operations-control` runtime `v1.0.1`;
- `layer1-operations-scheduled` runtime `v1.0.0`.

## Final staged UAT

An earlier Stage C candidate failed only because two permanent Course Detail tests hard-coded the old visible release `v2.15.6`. The stale assertion was corrected without changing application/runtime semantics and the mandatory sequence was restarted.

Final accepted chain:

- **Stage A targeted:** `721658a732c763892179250fee1c0268bd27051d`, run `32971449084` — PASS;
- **Stage B bounded integration:** `98172a4f616291212253c23f16fe1ab633b9c34b`, run `32971584012` — desktop/mobile PASS;
- **Stage C acceptance:** `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`, run `32972106291` — desktop/mobile PASS;
- final frontend build `32972106272` — PASS;
- build job `98188036405` — PASS;
- browser smoke `98188175754` — PASS;
- deployed acceptance job `98188037242` — desktop/mobile PASS.

No performance threshold, role/security boundary, authority contract or data assertion was weakened to obtain PASS.

## Documentation gate

Accepted/current:

- `docs/coursefinder-m2-4-data-operations-admin-guide-v1.2.md`;
- `docs/coursefinder-operations-runbook-v1.3.md`;
- `docs/coursefinder-pim-admin-guide-v1.21.md`;
- PIM Admin `v2.15.7` release notes;
- this runsheet and M2.4 current-state/follow-up/next-chat records.

## Exit gate

**PASS.** AU and NZ can be operated end-to-end from the mature Layer 1 UI with validated authoritative sources, governed count/variance safety, queue/progress/reconciliation, retained Evidence/logs, retry/resume/idempotency, scheduled rechecks, stale/stuck recovery and safe housekeeping.

M2.4.2 is now the next authorised feature gate. NZ first-party Layer 2 Course enrichment remains separately deferred pending future source qualification/onboarding.