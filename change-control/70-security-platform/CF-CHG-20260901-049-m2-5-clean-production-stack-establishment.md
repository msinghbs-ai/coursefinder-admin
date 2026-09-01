# CF-CHG-20260901-049 — M2.5 Clean Production Stack Establishment, Restore & Security Acceptance

**Status:** ACTIVE / READINESS — PRODUCTION PROJECT NOT YET PROVISIONED  
**Category:** 70-security-platform  
**Initiated:** 1 September 2026 AEST (+10:00)  
**Origin chat/workstream:** CourseFinder — post-M2.4 closure / M2.5 Production readiness  
**Owner:** M2.5 Production establishment workstream  
**Change class:** security / platform / production / deployment / restore / UAT / operations

## Trigger

M2.4 and M2.4.4 are CLOSED/PASS under `CF-CHG-20260830-048` at accepted Pilot `95f2991e97e76e644bd74f73512b8bf2725fd4b7`.

The authoritative programme sequence identifies M2.5 as the next main gate: clean Production stack deployment, restore and security acceptance. Production must be a separate trust boundary and must not be created by renaming/promoting the Pilot.

## Problem / requested outcome

Establish a separately provisioned Production environment with:
- separate paid-plan Supabase Production project;
- isolated credentials/Auth/Storage/Vault/vendor secrets;
- accepted schema/migrations and authoritative seed/re-ingestion;
- hardened RLS/grants/views/RPC/SECURITY DEFINER boundaries;
- protected Production CI/CD;
- Cloudflare Production deployment/origin/WAF controls;
- backup/restore/DR proof;
- monitoring/alerts/runbooks;
- SHA-bound automated desktop/mobile Production acceptance.

## Current readiness truth

Supabase inventory on 1 September 2026:
- `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp` / ap-south-1 / ACTIVE_HEALTHY;
- `coursefinder-demo` / `gfryvshbeptxwbzjomhe` / ap-southeast-2 / ACTIVE_HEALTHY;
- unrelated `ARR` / inactive;
- **no Production CourseFinder Supabase project exists**.

Available Supabase organisation discovered:
- `techM` / organisation ID `rszbvkqopqfvjldvfnbh`.

Per Supabase tooling policy, paid Production project creation requires explicit user confirmation of:
1. organisation;
2. quoted project cost;
3. Production region.

No cost lookup or billable resource creation has been performed yet because organisation selection must be explicitly confirmed first.

## Affected surfaces / related workstreams

- Supabase Production project, Auth, Storage, DB, Vault/secrets, Edge Functions, Cron.
- `msinghbs-ai/Coursefinder-Pilot` as source deployment candidate only; Pilot remains Pilot.
- GitHub protected Production environment/CI-CD.
- Cloudflare Production deployment/origin/WAF.
- backup/restore/DR.
- Production monitoring/alerts.
- Production automated UAT and release evidence.
- `CF-CHG-20260823-022` leaked-password protection Production gate.
- M3 Zoho remains separate ACTIVE/PARTIAL Pilot integration; no Zoho Production cutover is authorised here.
- M4 Search/publication/final handover remains later.

## Semantic impact

No canonical semantic change is authorised by M2.5 establishment itself.

M2.5 copies/deploys accepted application/data contracts into a clean Production trust boundary. It must not silently change Layer 1–4 authority, field meaning, source precedence, Search/publication semantics, or Zoho/Website consumer semantics.

## Before

- Pilot accepted and operational.
- No governed Production Supabase project identity.
- Production credentials/secrets/Auth/Storage not provisioned.
- No Production restore exercise or Production final acceptance.
- Production cutover/broad Publication remain unauthorised.

## After

M2.5 may close only when a separately identified Production environment is provisioned, restored/deployed, security hardened, restore-tested and accepted through Production-specific automated UAT.

M2.5 closure alone still does not automatically authorise broad Publication, Website cutover, Zoho cutover or M4 final handover unless those later gates explicitly pass.

## Security acceptance minimums

- Production leaked-password protection PASS under `CF-CHG-20260823-022`.
- Production-only secrets; no Pilot secret reuse unless explicitly approved.
- service-role/secret keys server-side only.
- exposed schemas, grants, RLS, views, RPCs and SECURITY DEFINER threat-modelled.
- negative anon/insufficient-rank tests.
- private Evidence Storage enforced.
- Production Auth/RBAC/session controls revalidated.
- Security Advisor: no unexplained WARN/ERROR/Critical/High.
- restore/rollback tested.
- Production acceptance SHA-bound.

## Blackout / scheduling

Standing programme baseline:
- 16–30 September 2026 inclusive: no planned implementation/deployment/UAT/project delivery unless separately authorised.
- Historical plan positions M2.5 delivery after blackout, with 12 planned engineering hours.
- Readiness/governance may be prepared before blackout; billable/resource creation is not inferred.

## Implementation references

- Production project: NOT YET PROVISIONED.
- Supabase organisation candidates: only `techM` currently visible.
- Production region: NOT YET APPROVED.
- Production project cost: NOT YET QUOTED/CONFIRMED.
- UI version: N/A at readiness entry.

## UAT

Entry/readiness checks:
- accepted M2.4.4 Pilot: PASS;
- replacement final acceptance `33468512515`: desktop 75 / mobile 76 PASS;
- Security Advisor at M2.4.4 closure: 146 INFO / 0 WARN / 0 ERROR;
- Performance Advisor at M2.4.4 closure: 172 INFO / 0 WARN / 0 ERROR;
- Production Supabase project inventory: NONE FOUND.

## Rollback / reversion

Readiness/governance changes can be reverted without runtime impact.
After a Production project is provisioned, rollback must preserve Pilot and delete/disable only the separately created Production resources through an explicit safe rollback decision.

## Documentation impact

- Master Project Plan: advance to M2.5 readiness baseline.
- Running Build: record accepted M2.4.4 Pilot as Production source candidate, not Production truth.
- M2.5 runsheet/current-state/follow-ups/next-chat created.
- Production runbook/handover to be revised after actual provisioning.
- Architecture changes only if Production deployment reveals/accepts structural differences.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 1 Sep 2026 AEST | ACTIVE / READINESS | M2.5 opened after M2.4 closure; Production inventory proves no Production Supabase project exists | current workstream |

## Closure

**Final status:** ACTIVE / READINESS  
**Closed at:** N/A  
**Outcome:** Production readiness gate opened. Paid project creation blocked pending explicit organisation, quoted-cost and region confirmation.
