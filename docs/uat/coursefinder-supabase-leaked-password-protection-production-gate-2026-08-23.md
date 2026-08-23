# CourseFinder Supabase Leaked Password Protection — Production Gate Decision

**Date:** 23 August 2026 11:40 AEST  
**Change Control:** `CF-CHG-20260823-022`  
**Decision:** **PILOT DEFERRED / PRODUCTION MANDATORY**

## Decision scope

This record changes the treatment of the existing leaked-password-protection finding; it does not claim that the managed Auth setting has been enabled.

## Pilot disposition

Current Pilot:

- project: `coursefinder_Pilot`;
- project ref: `fxcwkweaxjtknorudmwp`;
- organisation plan at decision: Free;
- security advisor finding: `auth_leaked_password_protection — Leaked Password Protection Disabled`.

The warning is retained as a documented temporary non-production exception.

No Pilot subscription, Auth configuration, database schema, application source, RBAC or runtime version is changed by this decision.

Pilot accepted runtime remains:

`msinghbs-ai/Coursefinder-Pilot@e877e3e28cd281ff3751a70bc500eeb0d8f31963`

## Production acceptance requirement

Before final Production security sign-off or cutover, require evidence that:

1. the Production Supabase environment is explicitly identified;
2. the Production plan/entitlement supports leaked-password protection;
3. **Prevent use of leaked passwords** is enabled;
4. the Production security advisor no longer reports `auth_leaked_password_protection`;
5. a controlled known-leaked-password attempt is rejected without the password value being logged or committed;
6. a compliant governed UAT account authenticates successfully;
7. CourseFinder Access Admin/RBAC behaviour remains correct;
8. no unrelated Auth regression is introduced.

## Gate classification

Pilot:

**DEFERRED / ACCEPTED TEMPORARY EXCEPTION**

Production:

**NOT YET SATISFIED — MANDATORY BEFORE GO-LIVE**

A Pilot exception cannot be used as Production acceptance evidence.

## Evidence to collect at Production implementation

Retain only non-secret evidence:

- Production project reference/name and plan eligibility;
- screenshot or configuration evidence showing the setting enabled where appropriate;
- security-advisor result showing the warning absent;
- Auth test result showing leaked-password rejection without password material;
- compliant-login result;
- Access Admin/RBAC regression result;
- timestamp and operator/change reference;
- production rollback/reversion decision if any incompatibility is discovered.

## Current outcome

**PASS — governance decision recorded.**

This is not an implementation PASS for the Production control. `CF-CHG-20260823-022` remains open/deferred until the Production environment passes the mandatory closure gate.