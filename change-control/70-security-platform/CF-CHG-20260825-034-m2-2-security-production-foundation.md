# CF-CHG-20260825-034 — M2.2 Security & Production Foundation

**Status:** APPROVED / IN PROGRESS  
**Category:** 70-security-platform  
**Initiated:** 25 August 2026 20:08 AEST (+10:00)  
**Origin chat/workstream:** M2.2 — SECURITY-PRODUCTION-SEARCH-SHOWCASE  
**Owner:** CourseFinder security/platform workstream  
**Change class:** security / production foundation / Auth / RPC / Edge / CI-CD / recovery

## Trigger

M2.2 is the accepted Security & Production Foundation milestone. Supabase has now been upgraded to Pro and the Friday showcase acceleration requires the current Pilot security posture and Production trust design to be reconciled rather than relying on M1 assumptions.

## Required outcome

- prove the current Supabase entitlement/state;
- re-evaluate controls previously deferred only because Pilot was on Free;
- inventory current browser-executable RPCs, SECURITY DEFINER functions, RLS/grants, Storage, Vault and Edge Functions;
- remove or explicitly disposition privileged browser mutation surfaces;
- retain the accepted Pilot/Production trust boundary;
- define CI/CD, backup/recovery, monitoring and rollback evidence required for later clean Production establishment;
- execute automated security/regression UAT for implemented changes.

## Live initiation state

- organisation `techM` (`rszbvkqopqfvjldvfnbh`) plan: **Pro**;
- Pilot `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`) region: Mumbai `ap-south-1`, ACTIVE_HEALTHY;
- current external Security Advisor WARNs: leaked-password protection disabled; `public.layer2_ops_policy_update(uuid,uuid,jsonb)` is SECURITY DEFINER and executable by `authenticated`;
- `public.layer2_ops_policy_update` performs actor equality and rank >=5 checks, but is still an avoidable direct privileged browser mutation because a JWT-enforced Layer 2 control Edge boundary already exists;
- Search/private operational schemas are not granted USAGE to anon/authenticated; direct table privileges for anon/authenticated across Search/Catalogue/Pipeline/Publishing are absent;
- Evidence bucket is private with a 50 MiB limit and explicit MIME allowlist;
- Vault schema has no anon/authenticated USAGE;
- current Admin repository CI is build-only; Pilot repository has SHA-bound deployed desktop/mobile UAT but no accepted Production protected-environment deployment workflow;
- many historical/ingestion Edge Functions retain `verify_jwt=false`; each Production-relevant retained endpoint needs custom-auth or server-only disposition before Production promotion.

## Approved immediate hardening

For the Pilot Layer 2 policy mutation:

1. move the browser path through `layer2-config-control` Edge Function with `verify_jwt=true`;
2. require current authenticated context and rank >=5 in the Edge boundary;
3. call `layer2_ops_policy_update` using the service boundary only after validating the authenticated actor;
4. revoke direct `authenticated` EXECUTE on `public.layer2_ops_policy_update`;
5. update the Admin Layer 2 Operations UI to call the Edge function;
6. run negative lower-rank/direct-RPC tests and positive authorised-path regression.

This does not alter Layer 2 source/canonical semantics.

## Supabase Pro / leaked-password control

`CF-CHG-20260823-022` is reopened for entitlement reconciliation: Pro is confirmed, but the security advisor still reports the setting disabled. The setting must not be represented as enabled until the managed Auth configuration is actually changed and verified. If the available managed connector cannot mutate this dashboard-level Auth setting, record the implementation blocker rather than fabricating PASS.

## Production trust boundary

Production remains a clean separate environment, not a renamed/copied Pilot. M2.2 may design and harden the foundation; creation/cutover remains under the accepted Production establishment gate. Production target region remains Sydney `ap-southeast-2` unless a later explicit regional decision changes it.

## UAT minimum

- current RPC/SECURITY DEFINER inventory and effective grants;
- direct Layer 2 policy RPC denied to authenticated after hardening;
- JWT-enforced Edge positive/negative paths;
- Auth/RBAC rank negative paths;
- private Search/Vault schema effective-access checks;
- Evidence Storage non-public/access checks;
- service-role non-disclosure review;
- Security Advisor re-run;
- deployed desktop/mobile regression after Pilot source deployment;
- M2.1 Layer 2 operations regression.

## Rollback

Re-grant the prior direct authenticated function only if the new Edge path produces an evidenced pre-Production regression and the Change Control is moved to BLOCKED. Production must not inherit the direct privileged browser mutation merely for convenience.

## Documentation impact

Update Running Build after deployed hardening, Production guide, Operations Runbook, current UAT evidence, Master Plan/TSOW via `CF-CHG-20260825-032`, and Change Control register.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 25 Aug 2026 20:08 AEST | APPROVED / IN PROGRESS | M2.2 security/Production foundation opened; Pro entitlement confirmed, controls not assumed enabled. | M2.2 workstream |

## Closure

**Final status:** IN PROGRESS  
**Closed at:** N/A  
**Outcome:** Security hardening/UAT underway.