# CF-CHG-20260825-034 — M2.2 Security & Production Foundation

**Status:** **BLOCKED WITH EVIDENCE — MANAGED AUTH CONTROL ONLY**  
**Category:** 70-security-platform  
**Initiated:** 25 August 2026 20:08 AEST (+10:00)  
**Updated:** 25 August 2026 21:15 AEST (+10:00)  
**Origin chat/workstream:** M2.2 — SECURITY-PRODUCTION-SEARCH-SHOWCASE  
**Owner:** CourseFinder security/platform workstream

## Final implemented security state

Supabase organisation `techM` (`rszbvkqopqfvjldvfnbh`) is verified on **Pro**. Pilot `fxcwkweaxjtknorudmwp` remains ACTIVE_HEALTHY in Mumbai `ap-south-1`.

Implemented and UAT-proven hardening:

- browser-direct authenticated execution of `public.layer2_ops_policy_update(uuid,uuid,jsonb)` revoked;
- policy mutation routed through JWT-enforced `layer2-config-control` v3 with current actor/rank validation and policy-field allowlist;
- the former Security Advisor warning for that authenticated SECURITY DEFINER surface is gone;
- browser roles are denied the M2.2 website Search preview RPCs;
- Search/Vault private boundaries remain non-browser CRUD surfaces;
- no service-role secret is added to browser code;
- Publication remains zero and cannot be escalated by the bounded Search preview;
- final deployed desktop/mobile UAT passes on Pilot SHA `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`, run `32840377935`.

## Blocking control — leaked-password protection

`CF-CHG-20260823-022` is no longer eligible for its former Free-plan Pilot exception because Pro entitlement is now confirmed.

Live Security Advisor still reports:

`auth_leaked_password_protection — Leaked Password Protection Disabled — WARN`

The connected Supabase management capability available to this workstream exposes project/database/functions/advisor operations but **does not expose a hosted Auth-configuration write operation** capable of switching the managed leaked-password setting. The control therefore cannot be truthfully marked enabled or UAT-proven from the connected management plane.

**Disposition: BLOCKED WITH EVIDENCE.** This is a real platform-management capability blocker, not delegated routine technical UAT and not a reason to simulate the setting in SQL.

The next authorised management path must enable the hosted Supabase Auth setting, after which automation must immediately re-run:

1. Security Advisor — `auth_leaked_password_protection` absent;
2. controlled leaked-password rejection through managed Auth without retaining password material;
3. compliant-user login/session regression;
4. Access Admin/RBAC regression;
5. deployed desktop/mobile Auth regression if the setting changes runtime login behaviour.

## Other security disposition

Three internal Search gate tables retain RLS disabled:

- `search.projection_country_gates`;
- `search.enrichment_gates`;
- `search.enrichment_source_gates`.

Current effective browser roles lack Search schema/direct-table access. This is retained as an explicit Production defence-in-depth WARN. RLS must not be blindly enabled without accepted internal/service policies that preserve projection operations.

Historical/ingestion Edge Functions with `verify_jwt=false` remain subject to Production relevance inventory and either custom-auth/server-only disposition or retirement before clean Production promotion. M2.2 does not grant Production release authority.

## Production trust boundary

Production remains a new clean environment, not a renamed Pilot. Target region remains Sydney `ap-southeast-2` unless a later regional Change Control changes it. Production establishment/cutover must separately prove:

- environment/project identity and scoped secrets;
- protected deployment workflow;
- backup/PITR configuration;
- isolated restore execution and accepted RPO/RTO;
- Production logging/monitoring;
- Auth controls including leaked-password protection;
- final security advisor and browser/API regression.

## Evidence

- final Pilot source SHA: `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`;
- build run: `32840377937` PASS;
- deployed UAT: `32840377935` desktop/mobile PASS;
- detailed evidence: `docs/uat/coursefinder-m2-2-security-search-showcase-2026-08-25.md`;
- leaked-password parent control: `CF-CHG-20260823-022`.

## Closure

**Final status: BLOCKED WITH EVIDENCE.**

All M2.2 security changes that are technically controllable through the connected project runtime are implemented and UAT-proven. Overall M2.2 security acceptance is blocked solely because the mandatory managed leaked-password protection setting remains disabled and cannot be changed through the currently available Supabase management operation.