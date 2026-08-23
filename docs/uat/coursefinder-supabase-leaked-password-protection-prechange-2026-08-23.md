# CourseFinder Supabase Leaked Password Protection — Pre-change Evidence

**Date:** 23 August 2026  
**Change Control:** `CF-CHG-20260823-022`  
**Result:** **BLOCKED — SUPABASE PRO PLAN REQUIRED**

## Live project

- Project: `coursefinder_Pilot`
- Project ref: `fxcwkweaxjtknorudmwp`
- Organisation: `techM`
- Organisation plan: **Free**
- Project status: `ACTIVE_HEALTHY`

## Security advisor evidence

Live Supabase security advisor reports:

`auth_leaked_password_protection — Leaked Password Protection Disabled — WARN`

Advisor detail states that Supabase Auth can prevent compromised passwords by checking against HaveIBeenPwned.org and recommends enabling the feature.

## Product eligibility evidence

Current Supabase Auth password-security documentation states that leaked-password protection is available on the **Pro Plan and above**.

The connected organisation is on the Free plan. The requested control therefore cannot be enabled on the current subscription.

## Acceptance rule after subscription approval

1. Enable leaked-password protection in Supabase Auth password settings.
2. Re-run the security advisor and require `auth_leaked_password_protection` to be absent.
3. Prove a controlled known-leaked/weak password is rejected without storing or recording the password value.
4. Prove a compliant governed UAT identity can still authenticate.
5. Confirm CourseFinder RBAC/Access Admin behaviour is unchanged.

No Auth setting, database schema or application source was changed during this pre-change gate.
