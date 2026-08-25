# CourseFinder Operations Runbook v1.3

**Issued:** 25 August 2026  
**Supersedes:** v1.2 for current operations  
**Status:** CURRENT  
**Change Controls:** CF-CHG-20260825-032, -033, -034, -035

All accepted Layer 1–4 procedures from v1.2 remain in force. This version adds the M2.2 operational controls below.

## M2.2 security preflight

Before release/promotion:

1. verify expected source/deployment SHA;
2. run Security Advisor and reconcile WARN/ERROR changes;
3. verify anon/authenticated EXECUTE boundaries for privileged RPCs;
4. confirm Vault/private schemas remain unavailable to browser roles;
5. confirm Evidence bucket remains private;
6. verify current auth method for each Production-retained Edge Function;
7. confirm no service-role/secret value appears in client assets/logs;
8. confirm broad Publication has not changed unintentionally.

## Layer 2 configuration changes

Execution-policy changes now use authenticated `layer2-config-control`. Direct authenticated execution of `public.layer2_ops_policy_update` is intentionally revoked. If the Admin save path fails, inspect Edge JWT/context/rank/service-boundary behaviour first; do not restore direct browser RPC access as a routine workaround.

## Search preview operations

Current service-only preview surfaces:

- `api.website_course_lookup_preview_v1` — exact Course code/stable-ID lookup;
- `api.website_course_search_preview_v1` — deterministic FTS/filter preview.

These are not a public website API. Never place a service-role/secret key in browser code.

Current Search invariant at issuance:

- projection `course-v3`;
- 33,105 documents;
- generation 22;
- broad Publication disabled;
- vector corpus zero until a governed model/profile is approved.

## Search relevance/performance incident procedure

1. separate exact identity lookup from FTS relevance;
2. inspect DB query plan/index usage before changing UI loading behaviour;
3. verify deterministic filters remain hard constraints;
4. verify projection generation/hash and row counts;
5. compare direct DB latency with RPC/API/network latency;
6. verify payload size and response aggregation cost;
7. do not enable vector/hybrid as a workaround without accepted benchmark evidence.

## Search gate-table RLS

`search.projection_country_gates`, `search.enrichment_gates` and `search.enrichment_source_gates` currently have RLS disabled, while anon/authenticated roles have no `search` schema usage or direct table privileges. Any future Search schema exposure change is a security change: define internal/service RLS policies before enabling RLS so accepted projection rebuilding is not accidentally blocked.

## Supabase Pro operations

The organisation is verified Pro. Record entitlement and actual configured state separately for each control. Leaked-password protection is currently an open M2.2 blocker until enabled and verified.

## Recovery operations

Production recovery acceptance occurs only after the clean Production project exists. Capture actual backup/PITR state, RPO/RTO, isolated restore target, restore timestamps, canonical counts/hashes/invariants, Storage/Evidence recovery and post-restore secret/deployment steps. Design documentation alone is not a restore PASS.
