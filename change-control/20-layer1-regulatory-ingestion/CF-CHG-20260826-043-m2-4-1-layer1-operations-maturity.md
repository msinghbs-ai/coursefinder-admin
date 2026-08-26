# CF-CHG-20260826-043 — M2.4.1 Layer 1 Regulatory Operations Maturity & Automation

**Status:** CLOSED / PASS  
**Category:** 20-layer1-regulatory-ingestion  
**Initiated:** 26 August 2026 20:52 AEST (+10:00)  
**Closed:** 27 August 2026 04:18 AEST (+10:00)  
**Owner:** M2.4.1 workstream  
**Change class:** schema / ingestion / UI / security / operations / documentation

## Outcome

M2.4.1 is CLOSED/PASS. The accepted Layer 1 operating model for AU CRICOS and NZ NZQA is now production-shaped for Pilot operations while preserving Layer 1 regulatory authority, canonical identity, Evidence/provenance and existing security boundaries.

The normal operator journey is:

`Regulatory source → validate source → assess expected count/variance → queue/run → live progress/reconciliation → Evidence/Jobs drill-through → scheduled recheck → safe transient housekeeping`.

## Accepted runtime

Final accepted Pilot source / acceptance SHA:

`msinghbs-ai/Coursefinder-Pilot@ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`

Visible browser release: PIM Admin `v2.15.7`.

Final build and acceptance evidence:

- Pilot Frontend Build `32972106272` — PASS;
- build job `98188036405` — PASS;
- browser smoke `98188175754` — PASS;
- deployed Stage C UAT `32972106291` — PASS;
- deployed desktop/mobile job `98188037242` — PASS for both desktop and mobile stages.

## Implemented control plane

- governed/versioned Layer 1 source-operations profiles;
- approved authority domains, expected source format/count semantics, cadence and variance guardrails;
- dynamic AU CRICOS source validation and active-course counting from source `Expired` semantics;
- dynamic NZ NZQA authority/listing validation across UNI/POLLY/WANA/PTE/GTE;
- rank >=4 read/validation authority and rank >=6 consequential configuration/execution/recovery authority;
- one-active-run-per-source protection, idempotency, retry/resume linkage and resume cursor;
- heartbeat/stuck detection, queue position, runtime and cumulative reconciliation counters;
- explicit warning acknowledgement before APPLY and hard block on blocking variance;
- hash-sensitive `no_change` path to avoid unnecessary ingestion;
- scheduled non-destructive authoritative-source verification using short-lived one-time nonce execution;
- paused-source exclusion and stale scheduled-dispatch recovery;
- bounded Platform Admin recovery of genuinely stuck runs;
- 30-day transient queue retention and daily housekeeping that cannot delete governed Evidence/source versions/canonical history;
- normal Layer 1 UI sections: Source Health, Current / Next Job, Progress, Reconciliation, Evidence / Provenance, Schedule / Recheck and Blockers / Required Actions.

## Live authority/count proof

### Australia — CRICOS

- accepted comparison baseline: 26,648 active Courses;
- live validation: 26,648 active, 90 expired, 26,738 total;
- CKAN package/resource shape and CRICOS Course Code identity checks passed;
- parser no longer relies on a hard-coded 26,648 assertion.

### New Zealand — NZQA

- previous accepted comparison baseline: 409 providers;
- live validation observed 411 unique provider IDs;
- variance approximately 0.489%; decision PASS under the configured 5% warning / 20% block guardrails.

## Operational proof

- concurrent second active source run rejected by the database one-active-source guard;
- idempotency replay rejected;
- retry/resume retained `retry_of` linkage and progressed the resume cursor;
- reconciliation counters accumulated correctly across continuation batches;
- simulated large AU count variance blocked APPLY;
- paused NZ source produced no scheduled dispatch;
- real NZ scheduled verification completed through the nonce path without canonical APPLY;
- stale scheduled dispatch and stale regular run recovery were proven;
- transient housekeeping removed eligible expired queue state while Evidence and retained source-operation versions remained unchanged.

## Security / performance

Final browser/data boundary:

- `anon`: no Layer 1 read/command/service-function/table access;
- `authenticated`: governed public Admin bridges only, with server-side rank checks; no direct Layer 1 table/service-helper access;
- `service_role`: service helpers/table access as required by workers/scheduler.

Final Supabase Security Advisor contains INFO-only observations and no new material M2.4.1 Critical/High/Warning finding.

Final Performance Advisor contains no unindexed Layer 1 foreign key. Low-traffic Layer 1 indexes may report unused INFO and remain intentionally retained where they cover governed FK/drill-through paths.

## Staged UAT

The final accepted chain after correcting one stale permanent-test version pin was:

- **Stage A targeted:** Pilot `721658a732c763892179250fee1c0268bd27051d`, run `32971449084` — PASS;
- **Stage B bounded integration:** marker `98172a4f616291212253c23f16fe1ab633b9c34b`, run `32971584012` — desktop/mobile PASS;
- **Stage C full acceptance:** `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`, run `32972106291` — desktop/mobile PASS.

An earlier Stage C candidate `6de71a2576307ae28b46666538f4d9a4a6bf8ff7` / run `32970866977` was correctly rejected because two permanent Course Detail tests still hard-coded the previous visible release `v2.15.6`. Application/runtime behaviour was green; the stale test assertion was corrected without changing product/runtime semantics, and the full staged chain was restarted as required.

## Repository/runtime reconciliation

Pilot repository truth mirrors the deployed M2.4.1 migration chain through the final Layer 1 recovery/housekeeping metadata migration and subsequent accepted admin-read bridge reconciliation migration `20260826124452`.

Deployed Edge sources are mirrored in Pilot:

- `layer1-operations-control` — runtime `layer1-operations-control-v1.0.1`;
- `layer1-operations-scheduled` — runtime `layer1-operations-scheduled-v1.0.0`.

The final `public.admin_read` contract preserves the accepted Data Quality and Layer 2 dispatches while adding Layer 1 operations; the bridge reconciliation was directly and browser-regression tested before final acceptance.

## Documentation

Accepted documentation includes:

- `docs/coursefinder-m2-4-data-operations-admin-guide-v1.2.md`;
- `docs/coursefinder-operations-runbook-v1.3.md`;
- `docs/coursefinder-pim-admin-guide-v1.21.md`;
- M2.4.1 runsheet/current-state/follow-up records;
- PIM Admin v2.15.7 release notes.

## Semantic / production boundary

No canonical identity or field-meaning authority was transferred. AU CRICOS and NZ NZQA remain Layer 1 authorities; Layer 2/3/4 and Search/Publication remain downstream according to the accepted architecture.

Production establishment/cutover, broad Publication and Zoho cutover are not authorised by this closure.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 26 Aug 2026 20:52 AEST | PROPOSED | M2.4.1 initiated from accepted M2.4.0 checkpoint | workstream prompt |
| 26 Aug 2026 | APPLIED — ACTIVE UAT/IMPLEMENTATION | AU/NZ control plane, scheduler, recovery, housekeeping, UI and documentation implemented | M2.4.1 runsheet |
| 27 Aug 2026 04:18 AEST | CLOSED / PASS | Final frozen Stage C desktop/mobile acceptance PASS; advisors and runtime reconciliation complete | Pilot `ed41ea4d…`, run `32972106291` |

## Closure

**Final status:** CLOSED / PASS  
**Closed at:** 27 August 2026 04:18 AEST (+10:00)  
**Outcome:** M2.4.1 accepted. M2.4.2 may now begin under the standing M2 staged-UAT, security and change-control governance.