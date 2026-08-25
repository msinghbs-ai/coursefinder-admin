# CF-CHG-20260823-022 — Supabase leaked password protection

**Status:** **REOPENED / BLOCKED — PRO ENTITLEMENT CONFIRMED, CONTROL STILL DISABLED**  
**Category:** `70-security-platform`  
**Initiated:** 23 August 2026 10:43 AEST (UTC+10)  
**Decision updated:** 25 August 2026  
**Owner:** CourseFinder security/platform governance  
**Affected surfaces:** Supabase Auth, Platform security posture, Access Admin/UAT identities, Production readiness/cutover

## Requested outcome

Enable Supabase Auth leaked-password protection so passwords known to have appeared in public breaches are rejected through the managed HaveIBeenPwned integration.

This is a managed Auth setting. It is not a PostgreSQL/RLS migration and must not be simulated with database SQL.

## Original Pilot decision — 23 August 2026

At initiation the connected organisation was verified on the Free plan and Supabase documented leaked-password protection as Pro+. The Pilot therefore carried a documented temporary Free-plan exception while the control remained mandatory for Production go-live. The warning was never represented as resolved.

## M2.2 entitlement change — 25 August 2026

The previous Free-plan premise is no longer true.

Live reconciliation now verifies:

- organisation `techM` / `rszbvkqopqfvjldvfnbh` plan: **`pro`**;
- Pilot `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp`: ACTIVE_HEALTHY;
- region: `ap-south-1` (Mumbai);
- current Security Advisor: **WARN — Leaked Password Protection Disabled**.

Supabase documentation confirms leaked-password protection is available on Pro and above. Therefore the former Free-only Pilot exception is reopened under M2.2 and is no longer a valid reason to leave the control unresolved.

## Current implementation state

**Entitlement:** PASS.  
**Setting state:** BLOCKED / NOT ENABLED.  
**Advisor state:** WARN remains.  
**M2.2 security acceptance:** blocked while this required control remains disabled.

The currently connected Supabase project-management capability can verify project/organisation/advisor/database state and deploy database/Edge changes, but no authorised managed Auth-config mutation action is exposed in the current connection. Repository search found no existing governed `SUPABASE_ACCESS_TOKEN`/Auth-config automation path to perform the Management API change safely.

Accordingly, M2.2 does not fabricate enablement. The blocker is retained as evidence rather than delegating technical UAT or claiming a false PASS.

## Required enablement/UAT path

When an authorised managed Auth configuration path is available:

1. enable **Prevent use of leaked passwords** for the intended environment;
2. re-read managed Auth configuration where possible;
3. run Security Advisor and require `auth_leaked_password_protection` to disappear;
4. run a bounded known-leaked-password rejection test without recording password material;
5. verify a compliant governed identity can authenticate;
6. verify Access Admin/RBAC/session behaviour is unchanged;
7. retain UAT evidence and close only after those checks pass.

## Production rule unchanged

Production remains blocked from final security sign-off/go-live until leaked-password protection is enabled and UAT-proven in the Production Auth authority. Pilot Pro entitlement is not a Production substitute.

## Security semantics

This control affects password acceptance. It does not change CourseFinder role hierarchy, PIM/Pipeline ACLs, Layer authority, canonical Provider/Course data, Search Projection, Search Visibility or Publication.

## Rollback

If enablement causes an evidenced pre-go-live Auth compatibility defect, disable the setting temporarily, record the failure and move the control back to BLOCKED. Production cannot proceed while the mandatory gate remains unsatisfied.

## Decision history

| Date | State | Decision |
|---|---|---|
| 23 Aug 2026 | DEFERRED FOR PILOT | Free plan made the managed control unavailable; mandatory Production gate retained. |
| 25 Aug 2026 | REOPENED / BLOCKED | Organisation upgraded to Pro; entitlement now passes but live advisor proves the setting is still disabled. Free-plan exception retired. |

## Closure

**Final status:** BLOCKED pending managed Auth enablement and automated UAT evidence.
