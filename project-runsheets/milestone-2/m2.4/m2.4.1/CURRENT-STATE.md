# M2.4.1 — Current State

**Status:** CLOSED / PASS  
**Closed:** 27 August 2026 04:18 AEST (+10:00)  
**Change Control:** `CF-CHG-20260826-043` — CLOSED/PASS  
**Accepted starting Pilot:** `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`  
**Accepted final Pilot:** `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`  
**Visible browser release:** PIM Admin `v2.15.7`

## Accepted capability

Layer 1 Regulatory is now a production-shaped AU/NZ operating workspace with governed source configuration/validation, expected-count and variance safety, queue/progress/reconciliation, Evidence/Jobs drill-through, retry/resume/idempotency, scheduled non-destructive rechecks, stuck/stale handling and safe transient housekeeping.

Routine entry remains `Data Operations → Layer 1 — Regulatory`. Experimental/destructive controls remain outside the normal operator path.

## Accepted authority and counts

### AU CRICOS

- live validation: 26,648 active, 90 expired, 26,738 total Course rows;
- required CRICOS CKAN package/resources and Course Code identity passed;
- active count derives from source `Expired` semantics and is not hard-coded.

### NZ NZQA

- live validation: 411 unique providers across UNI/POLLY/WANA/PTE/GTE;
- previous accepted baseline: 409;
- variance approximately 0.489%; PASS under 5% warning / 20% block thresholds.

## Accepted operational controls

- rank >=4 read and source-validation authority;
- rank >=6 source configuration, dry-run/APPLY, pause/resume and recovery authority;
- explicit warning acknowledgement before APPLY;
- blocking variance prevents APPLY;
- one active run per source;
- idempotency/replay protection;
- retry/resume linkage and cursor;
- cumulative reconciliation counters;
- heartbeat/stuck visibility and bounded `recover_stuck`;
- hash-sensitive `no_change` path;
- scheduled authoritative-source validation through one-time nonce without unattended canonical APPLY;
- paused-source scheduler exclusion and stale-dispatch recovery;
- 30-day transient queue retention and daily safe housekeeping preserving Evidence/source versions/canonical history.

## Repository/runtime truth

Pilot contains the deployed M2.4.1 migration/Edge chain, including the final `public.admin_read` bridge reconciliation migration `20260826124452`, which preserves accepted Data Quality and Layer 2 dispatches while adding Layer 1 operations.

Mirrored Edge runtimes:

- `layer1-operations-control-v1.0.1`;
- `layer1-operations-scheduled-v1.0.0`.

## Security / performance

Final Security Advisor: INFO-only observations; no new material M2.4.1 Critical/High/Warning finding.

Final Performance Advisor: no unindexed Layer 1 foreign key. Low-traffic Layer 1 indexes may remain as unused INFO where required for governed FK/drill-through paths.

Accepted browser/data boundary:

- anonymous users cannot execute Layer 1 read/command/table/service-helper paths;
- authenticated users use governed public Admin bridges with independent rank checks;
- service role retains worker/scheduler-only helper access.

## Final UAT evidence

Final staged chain after correcting one obsolete permanent-test release pin:

- Stage A targeted: `721658a732c763892179250fee1c0268bd27051d`, run `32971449084` — PASS;
- Stage B integration: `98172a4f616291212253c23f16fe1ab633b9c34b`, run `32971584012` — desktop/mobile PASS;
- Stage C acceptance: `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`, run `32972106291` — desktop/mobile PASS;
- final frontend build `32972106272` — PASS;
- build job `98188036405` — PASS;
- browser smoke `98188175754` — PASS;
- deployed acceptance job `98188037242` — desktop/mobile PASS.

No threshold or authority/security contract was weakened to obtain PASS.

## Documentation

Current accepted operational guidance:

- `docs/coursefinder-m2-4-data-operations-admin-guide-v1.2.md`;
- `docs/coursefinder-operations-runbook-v1.3.md`;
- `docs/coursefinder-pim-admin-guide-v1.21.md`.

## Next gate

M2.4.2 — Layer 2 Full Enrichment, Operations Maturity & Performance — is now authorised to begin under the standing M2 change-control/security/staged-UAT rules.

NZ first-party Layer 2 Course enrichment remains separately DEFERRED pending future source qualification/onboarding. Production cutover, broad Publication and Zoho cutover remain later governed gates.