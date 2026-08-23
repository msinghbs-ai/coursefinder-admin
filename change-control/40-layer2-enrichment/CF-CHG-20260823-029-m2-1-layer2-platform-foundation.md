# CF-CHG-20260823-029 — M2.1 Layer 2 Enrichment Platform Foundation

**Status:** PROPOSED  
**Category:** 40-layer2-enrichment  
**Initiated:** 23 August 2026 20:21 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — L2-PLATFORM  
**Owner:** M2.1 Layer 2 Platform workstream  
**Change class:** schema / enrichment / UI / security / governance / documentation / operations

## Trigger

Milestone 2.1 authorised implementation gate following the accepted and frozen Milestone 1 Pilot baseline.

## Problem / requested outcome

Layer 2 currently contains source-specific qualification/acquisition implementations and a Layer 1-oriented Sources surface, but it does not yet provide one reusable, versioned, governed configuration contract for deterministic enrichment acquisition across materially different source and transport types. The requested outcome is a reusable Layer 2 configuration/control plane that separates configuration from execution, preserves source authority, prevents acquisition from directly mutating canonical data, and exposes safe operational governance in Admin without browser-visible secrets.

## Affected surfaces / related workstreams

- `pipeline.sources`, `pipeline.jobs`, `pipeline.evidence_artifacts` and Layer 2 source qualification/acquisition objects;
- new Layer 2 configuration/version/validation objects and traceability links;
- `public.admin_read(text,jsonb)` governed browser read contract;
- Admin Platform Settings / Sources / Enrichment Configuration UX;
- Pilot migration mirrors and automated UAT;
- M1 Evidence, Pipeline Ops, security and publication invariants;
- Platform User Guide, PIM Admin Guide, Data Flow & Feature Atlas and Operations Runbook.

## Semantic impact

No canonical identity or field-meaning change is authorised by this record. Layer 1 authority and canonical identity remain unchanged. This change adds a governed Layer 2 operational/configuration contract and traceability metadata. Source discovery or acquisition must not directly mutate canonical data; the accepted sequence remains Source Configuration → Acquisition → Evidence → Observation/Extraction → Canonical Mapping → Review where required → Search Admission → Publication.

## Before

Layer 2 acquisition exists through source-specific records/qualification logic and shared pipeline/evidence tables, while the accepted Admin Sources surface is primarily an operational source view. Configuration details are not represented as a single reusable versioned contract spanning website, API, document/feed, sitemap and search/discovery acquisition types.

## After

A reusable Layer 2 source profile contract is versioned independently from execution. Jobs and Evidence can identify the exact configuration version used. Unsafe/incomplete profiles fail validation before execution. Browser surfaces expose only non-secret governed configuration, status/history/diff/health/traceability and authorised pause/disable controls. Multiple materially different acquisition profiles use the same schema.

## Source authority / evidence

- `PROJECT_INSTRUCTIONS.md` and current Change Control register;
- M1 frozen architecture and accepted AU+NZ canonical substrate;
- deployed `coursefinder_Pilot` Supabase project `fxcwkweaxjtknorudmwp`;
- current `msinghbs-ai/Coursefinder-Pilot` and `msinghbs-ai/coursefinder-admin` main branches;
- M2.1 gate requirements from originating chat.

## Implementation references

- Supabase migration(s): pending
- Git repository/commit(s): pending
- Issue/PR: N/A
- RPC/API objects: `public.admin_read(text,jsonb)` extension planned; write/control path to be separately role-guarded
- UI version: pending

## UAT

Pending implementation. Required gate coverage: reusable contract, versioning, multiple acquisition methods, configuration→Job→Evidence traceability, pre-execution validation, secret-leakage checks, authenticated/role ACL checks, deployed desktop/mobile browser UAT, regression checks for M1 authority/publication invariants.

## Rollback / reversion

Additive schema objects will be independently removable after confirming no dependent M2 jobs/evidence exist. Admin UI changes can be reverted to the frozen M1 Sources surface. Any control-path function introduced by this change must have grants revoked before object removal. Canonical M1 tables/data are not to be rewritten by rollback.

## Documentation impact

- PIM Admin Guide: required
- Architecture: required if new persistent platform objects are accepted
- Running build: required when capability is accepted/deployed
- Master plan: required when M2.1 gate state changes
- UAT/design docs: required
- User Guide: required
- Data Flow & Feature Atlas: required/create if absent
- Operations Runbook: required
- Zoho contract: no direct contract change expected

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 23 Aug 2026 20:21 AEST | PROPOSED | M2.1 Layer 2 platform workstream initiated against frozen M1 baseline | M2.1 — L2-PLATFORM |

## Closure

**Final status:** N/A  
**Closed at:** N/A  
**Outcome:** Implementation and autonomous UAT in progress.