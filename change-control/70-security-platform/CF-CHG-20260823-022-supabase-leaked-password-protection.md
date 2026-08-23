# CF-CHG-20260823-022 — Supabase leaked password protection

**Status:** **BLOCKED — SUPABASE PRO PLAN REQUIRED**  
**Category:** `70-security-platform`  
**Initiated:** 23 August 2026 10:43 AEST (UTC+10)  
**Origin:** CourseFinder chat — proceed with leaked password protection  
**Owner:** CourseFinder security/platform governance  
**Affected surfaces:** Supabase Auth, Platform security posture, Access Admin/UAT identities  
**Change class:** managed Auth security hardening

## 1. Requested outcome

Enable Supabase Auth leaked-password protection so passwords known to have appeared in public breaches are rejected using Supabase's HaveIBeenPwned.org Pwned Passwords integration.

This is an Auth platform setting. It is not a PostgreSQL schema/RLS change and must not be simulated with a database migration.

## 2. Current live state

Project:

`coursefinder_Pilot` / `fxcwkweaxjtknorudmwp`

Connected organisation:

`techM` / `rszbvkqopqfvjldvfnbh`

Live Supabase project state at initiation:

- project status: `ACTIVE_HEALTHY`;
- organisation plan: **Free**;
- Supabase security advisor: **WARN — Leaked Password Protection Disabled**;
- advisor detail: compromised-password checking is disabled.

The existing project-wide `RLS enabled / no policy` INFO findings remain the deliberate private/internal-table pattern and are not part of this control.

## 3. Product constraint

Current Supabase documentation states:

- leaked-password protection is configured in Auth password/security settings;
- Supabase uses the HaveIBeenPwned.org Pwned Passwords API to reject known leaked passwords;
- **Leaked password protection is available on the Pro Plan and above.**

The connected organisation is currently on the Free plan. Therefore the requested control cannot be enabled on the current subscription.

No paid-plan upgrade is authorised implicitly by this security-hardening request. Subscription changes must be explicitly approved because they create ongoing cost.

## 4. Decision

Do not:

- create a fake PostgreSQL setting to silence the advisor;
- weaken or bypass Supabase Auth;
- store passwords or test them against breach lists inside CourseFinder;
- upgrade the Supabase subscription without explicit cost approval.

Required implementation path after subscription approval:

1. upgrade the `techM` Supabase organisation/project to a plan that includes leaked-password protection;
2. enable **Prevent use of leaked passwords** in Supabase Auth password settings;
3. retain existing CourseFinder password handling — passwords remain Supabase Auth credentials and are not stored in CourseFinder governance/audit;
4. re-run the Supabase security advisor;
5. require the `auth_leaked_password_protection` warning to be absent before closure;
6. run a bounded Auth regression using a controlled test identity/password-change path without recording the password value in governance evidence.

## 5. Security semantics

When enabled, this control strengthens password acceptance only. It does not change:

- CourseFinder role hierarchy or RBAC;
- `security.user_roles` / `security.roles` semantics;
- Access Admin rank-6 boundary;
- Evidence/Pipeline/Data Quality ACLs;
- existing user role assignments;
- canonical Provider/Course data;
- Search/publication behaviour.

Existing users are not silently assigned replacement passwords. Supabase documentation notes that strengthened password requirements can cause weak-password feedback for affected password sign-ins/changes; exact post-enable behaviour will be validated during UAT rather than assumed.

## 6. Initial UAT / evidence

**Pre-change advisor check:** PASS as evidence of the gap.

Observed live warning:

`auth_leaked_password_protection — Leaked Password Protection Disabled — WARN`

**Plan eligibility check:** BLOCKED.

Observed organisation plan:

`free`

Current Supabase documentation requires Pro Plan or above.

No Auth setting was changed because the current plan is ineligible.

## 7. Rollback

If enabled later and an unexpected Auth compatibility issue is demonstrated during bounded UAT, disable leaked-password protection in Supabase Auth settings while preserving the evidence and reopening this control. No database rollback is required.

## 8. Closure gate

This Change Control may close only when all are true:

- subscription eligibility is confirmed;
- leaked-password protection is enabled in the live project;
- security advisor no longer reports `auth_leaked_password_protection`;
- existing normal governed UAT identity can still authenticate where its password complies;
- controlled weak/leaked-password rejection is proven without storing password material;
- no unrelated Auth/RBAC regression is introduced.

## 9. Current status

**BLOCKED — SUPABASE PRO PLAN REQUIRED.**

Current accepted application/runtime baseline remains unchanged. This control does not justify a Master Plan, Running Build, Database Architecture, Admin/PIM Decisions, PIM Admin Guide or visible UI version bump while the managed Auth setting remains unapplied.
