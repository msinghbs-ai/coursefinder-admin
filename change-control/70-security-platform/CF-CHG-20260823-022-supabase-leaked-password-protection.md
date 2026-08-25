# CF-CHG-20260823-022 — Supabase leaked password protection

**Status:** **CLOSED / PASS**  
**Category:** `70-security-platform`  
**Initiated:** 23 August 2026 10:43 AEST (UTC+10)  
**Closed:** 25 August 2026 21:26 AEST (UTC+10)  
**Owner:** CourseFinder security/platform governance  
**Affected surfaces:** Supabase Auth, Platform security posture, Access Admin/UAT identities, Production readiness/cutover

## Requested outcome

Enable Supabase Auth leaked-password protection so passwords known to have appeared in public breaches are rejected through the managed Supabase Auth control.

This is a managed Auth setting. It is not a PostgreSQL/RLS migration and was not simulated with database SQL.

## History

At initiation the organisation was on the Free plan and the control was unavailable. The Pilot therefore carried a documented temporary exception while the control remained mandatory for Production.

On 25 August 2026 the organisation was upgraded to Pro. The former Free-plan premise became invalid and this Change Control was reopened until the managed setting could be enabled and independently verified.

## Final verified state

Live reconciliation on 25 August 2026 confirms:

- organisation `techM` / `rszbvkqopqfvjldvfnbh`: **Pro**;
- Pilot `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp`: ACTIVE_HEALTHY;
- region: `ap-south-1` (Mumbai);
- leaked-password protection was enabled through the Supabase Dashboard by the authorised project owner;
- subsequent live Security Advisor run no longer reports `auth_leaked_password_protection` / `Leaked Password Protection Disabled`;
- the previous WARN is therefore cleared.

## Regression evidence

After the managed setting was enabled:

- current Security Advisor contains INFO-level `rls_enabled_no_policy` notices only and no leaked-password WARN;
- privileged Layer 2 policy mutation remains denied to `anon` and `authenticated` and allowed only to `service_role`;
- bounded website Search preview RPCs remain denied to `anon` and `authenticated` and allowed only to `service_role`;
- canonical/runtime invariants remain unchanged: Courses 43,461; Providers 3,085; Search documents 33,105; AU 26,648; NZ 6,457; Search generation 22; broad publication 0;
- final deployed desktop/mobile Auth/application regression already passed on Pilot SHA `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`, run `32840377935`.

No password material was retained in UAT evidence.

## Production rule

The Pilot control is now PASS. Production remains a separate clean environment and must independently enable and verify the same managed Auth control as part of the Production establishment/security gate; Pilot PASS is not a substitute for Production Auth evidence.

## Security semantics

This control affects password acceptance only. It does not change CourseFinder role hierarchy, PIM/Pipeline ACLs, Layer authority, canonical Provider/Course data, Search Projection, Search Visibility or Publication.

## Decision history

| Date | State | Decision |
|---|---|---|
| 23 Aug 2026 | DEFERRED FOR PILOT | Free plan made the managed control unavailable; mandatory Production gate retained. |
| 25 Aug 2026 | REOPENED / BLOCKED | Organisation upgraded to Pro; setting remained disabled. |
| 25 Aug 2026 21:26 AEST | CLOSED / PASS | Authorised Dashboard enablement completed; live Security Advisor confirms the leaked-password WARN is absent; security/invariant regression remains PASS. |

## Closure

**Final status:** CLOSED / PASS.  
**Outcome:** Supabase Pro leaked-password protection is enabled and independently verified for the Pilot. Production must repeat the control under its own Auth authority.