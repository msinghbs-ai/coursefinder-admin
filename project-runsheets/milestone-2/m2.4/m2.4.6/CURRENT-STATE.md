# M2.4.6 CURRENT STATE

**Status:** ACTIVE — PRODUCTION OPERATIONS MODEL  
**Reconciled:** 2026-09-15 AEST  
**Accepted Pilot baseline:** `e62c01cadaf43efa8c3d8ea57625c23874d1b010`  
**Visible accepted release:** v2.15.79 / package 0.1.6  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 paused until M2.4.9 GO

## Baseline carried from M2.4.5

The accepted runtime provides Scheduled Tasks/orchestration foundations, managed Layer 2 run items/provider attempts/Evidence, CF-245 operational telemetry, hourly coverage snapshots, bounded deterministic admission paths and the rank-gated Enrichment Operations report.

Latest accepted AU coverage snapshot: 33,105 Search courses; 26,457 regulatory tuition; 487 intakes; 520 English requirements; 421 official course URLs; 161 provider-current tuition; 0 website-admitted scholarships. NZ remains unexpanded for these governed fields pending qualification.

M2.4.5 acceptance is green: dedicated CF-245 deployed UAT `34926246733`, generic targeted UAT `34926246675`, build/smoke `34926246673`, and Cloudflare deployment all PASS.

## Active question

The active gate is no longer “is scheduling alive?” or “can we increase throughput?”. It is whether the current implementation forms a complete, practical production-like operating model:

- dispatcher and wave ownership;
- exact eligibility/qualification rules;
- Evidence reuse before new paid acquisition;
- deterministic Layer 2 handling;
- bounded Layer 3 and Layer 4 escalation;
- retry/parking/stale recovery and replay safety;
- quota/cost/concurrency stop controls;
- operator ownership and auditability;
- outcome and coverage metrics tied to individual runs/waves.

## Exact next action

Perform a repository/runtime reconciliation of those operating-model elements against the existing scheduler, dispatcher, run-item, provider-attempt, Evidence and CF-245 telemetry implementation. Record what already exists versus genuine gaps. Do not implement speculative redesign; open a new Change Control only for demonstrated gaps.
