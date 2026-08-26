# CF-CHG-20260826-043 — M2.4.1 Layer 1 Regulatory Operations Maturity & Automation

**Status:** APPLIED — ACTIVE UAT/IMPLEMENTATION  
**Category:** 20-layer1-regulatory-ingestion  
**Initiated:** 26 August 2026 20:52 AEST (+10:00)  
**Origin chat/workstream:** M2.4.1 — Layer 1 Regulatory Operations Maturity & Automation  
**Owner:** M2.4.1 workstream  
**Change class:** schema / ingestion / UI / security / operations / documentation

## Trigger

Planned M2.4.1 gate after M2.4.0 CLOSED/PASS. The accepted Layer 1 workers are technically functional, but the normal operator workspace is not yet a production-shaped control plane for AU CRICOS and NZ NZQA.

## Problem / requested outcome

Provide a governed Layer 1 operating model for authoritative regulatory sources: source configuration/validation, expected-count and variance safety, governed queue/progress/reconciliation, Evidence/log drill-through, retry/resume/idempotency, schedules/rechecks, stale/stuck visibility and safe transient housekeeping.

## Affected surfaces / related workstreams

- `pipeline.sources`, `pipeline.jobs`, `pipeline.evidence_artifacts` and additive Layer 1 operations objects.
- AU CRICOS and NZ NZQA Layer 1 adapters/workers.
- `public.admin_read` / private-security read/write helpers and browser-executable contracts.
- `src/layer1-operations-entry.jsx`, `src/lib/supabase.js`, shared navigation/UAT adapters.
- Evidence, Jobs/Runs, Data Quality immediate regression boundaries.
- M2.4 runsheets, PIM Admin Guide, Operations Runbook, troubleshooting, release notes.
- Related security/platform and UAT/release surfaces.

## Semantic impact

**No canonical identity or field-meaning change is authorised by this record.** AU CRICOS and NZ NZQA remain Layer 1 source/identity authorities according to their accepted contracts. Layer 2/3/4 and Search/Publication remain non-authoritative downstream consumers.

The change adds operational control metadata, validation/queue/scheduling state and operator presentation. Source-null/zero/suppressed/not-applicable/not-yet-ingested semantics must remain unchanged.

## Before

- `pipeline.sources` contains source URL/status/metadata and worker health fields.
- Layer 1 workers create jobs and Evidence and retain source hashes/reconciliation.
- Normal Layer 1 UI shows source registry health only.
- No explicit authority-domain qualification, normalized expected-count variance policy, L1 schedule/pause profile, operator queue/idempotency contract or retained transient-housekeeping policy.

## After

- AU/NZ sources have governed, versioned operations profiles with authority/domain and expected-format contracts.
- Source validation separates reachability from authority trust and records verification state/time.
- Expected record count and prior accepted count support warning/block variance decisions before unattended APPLY.
- Queue creation prevents unsafe duplicate/concurrent runs and supplies idempotency/resume state.
- Normal Layer 1 UI exposes health, current/next job, progress, reconciliation, Evidence/provenance, schedule/recheck and required actions using progressive disclosure.
- Housekeeping deletes only explicitly transient execution state and cannot delete governed Evidence/source versions/audit lineage.

## Source authority / evidence

- Accepted Pilot baseline `msinghbs-ai/Coursefinder-Pilot@ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`.
- AU source: CRICOS on data.gov.au with accepted discovery/resource contract.
- NZ source: NZQA Education Organisations with accepted NZ Layer 1 identity contract.
- M2.4.1 RUNSHEET gap matrix and retained Stage A/B/C evidence.

## Implementation references

- Supabase migration(s): pending during active implementation.
- Git repository/commit(s): Admin runsheet baseline `28eaef971846711588519fc6323085a67c51e619`; Pilot refs pending.
- RPC/API objects: pending.
- UI version: pending browser-facing release bump.

## UAT

A1–A7 model is mandatory: targeted validation → bounded integration → exactly one nominated full deployed desktop/mobile acceptance matrix. Security/advisor checks and role/rank/anonymous negatives are primary gates. Real representative AU/NZ runs are required where safe, with rollback-only/isolated paths for consequential actions.

## Rollback / reversion

Additive operations-profile/queue state is reversible independently of canonical tables. Browser changes can be reverted to the M2.4.0 Layer 1 shell. Any worker change must retain adapter-specific rollback and must not delete existing Evidence or accepted source versions.

## Documentation impact

- PIM Admin Guide: required.
- Architecture: additive operations objects only unless later semantic review requires a version bump.
- Running build: update only after exact acceptance SHA passes.
- Master plan: update only at M2.4.1 closure.
- UAT/design docs: required.
- Zoho contract: no change.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 26 Aug 2026 20:52 AEST | PROPOSED | M2.4.1 initiated from accepted M2.4.0 checkpoint | workstream prompt |
| 26 Aug 2026 21:xx AEST | APPLIED — ACTIVE UAT/IMPLEMENTATION | Reconciled actual Pilot/Supabase AU/NZ state and recorded gap matrix | `project-runsheets/milestone-2/m2.4/m2.4.1/RUNSHEET.md` |

## Closure

**Final status:** ACTIVE  
**Closed at:** N/A  
**Outcome:** Implementation/UAT in progress; M2.4.2 remains blocked from feature implementation until this record is CLOSED/PASS.
