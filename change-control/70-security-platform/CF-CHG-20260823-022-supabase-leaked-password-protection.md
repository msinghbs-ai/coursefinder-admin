# CF-CHG-20260823-022 — Supabase leaked password protection

**Status:** **DEFERRED FOR PILOT — MANDATORY PRODUCTION GO-LIVE GATE**  
**Category:** `70-security-platform`  
**Initiated:** 23 August 2026 10:43 AEST (UTC+10)  
**Decision updated:** 23 August 2026 11:40 AEST (UTC+10)  
**Origin:** CourseFinder chat — proceed with leaked password protection; subsequently park for Pilot and require for Production  
**Owner:** CourseFinder security/platform governance  
**Affected surfaces:** Supabase Auth, Platform security posture, Access Admin/UAT identities, Production readiness/cutover  
**Change class:** managed Auth security hardening / Production release gate

## 1. Requested outcome

Enable Supabase Auth leaked-password protection so passwords known to have appeared in public breaches are rejected using Supabase's HaveIBeenPwned.org Pwned Passwords integration.

This is an Auth platform setting. It is not a PostgreSQL schema/RLS change and must not be simulated with a database migration.

The programme decision of 23 August 2026 is to **park this control for the current Pilot** and make it a **mandatory Production go-live requirement**.

## 2. Current Pilot state

Project:

`coursefinder_Pilot` / `fxcwkweaxjtknorudmwp`

Connected organisation:

`techM` / `rszbvkqopqfvjldvfnbh`

Live Supabase Pilot state at initiation:

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

The connected Pilot organisation is currently on the Free plan. The setting therefore cannot be enabled on the present Pilot subscription without a paid-plan change.

No paid-plan upgrade is authorised for Pilot by this control.

## 4. Programme decision — Pilot versus Production

### Pilot

The warning is accepted as a **documented, temporary Pilot exception** because:

- the Pilot remains a non-production validation environment;
- the control is subscription-gated on Pro+;
- the current accepted Pilot Auth/RBAC/UAT controls remain operational;
- upgrading Pilot solely to remove this warning is not required for Pilot acceptance.

This exception does **not** mean the warning is resolved. It remains visible and traceable under this Change Control.

Pilot acceptance/runtime remains unchanged and must not be represented as having leaked-password protection enabled.

### Production

Leaked-password protection is a **mandatory Production readiness and cutover gate**.

A CourseFinder Production environment must not receive final production security sign-off or go-live approval until all closure criteria in Section 8 are satisfied.

Production must use a Supabase plan that makes the control available (currently Pro or above), or a future Supabase entitlement that demonstrably provides the same managed setting.

Any proposal to waive this Production requirement requires a new explicit security-risk decision/change control; Pilot deferral is not a Production waiver.

## 5. Required Production implementation path

When the Production Supabase environment/subscription is provisioned:

1. confirm the Production project and organisation are on an eligible plan;
2. enable **Prevent use of leaked passwords** in Supabase Auth password settings;
3. retain existing CourseFinder password handling — passwords remain Supabase Auth credentials and are never stored in CourseFinder governance/audit;
4. run the Supabase security advisor against the Production project;
5. require `auth_leaked_password_protection` to be absent before Production security sign-off;
6. run a bounded Auth regression using controlled Production/UAT identities without recording password values;
7. prove a known leaked-password attempt is rejected through the managed Auth path;
8. prove a compliant governed user can authenticate normally;
9. confirm CourseFinder role/RBAC, Access Admin and privileged server boundaries remain unchanged;
10. attach Production evidence to this control and close it only after the Production gate passes.

## 6. Security semantics

When enabled, this control strengthens password acceptance only. It does not change:

- CourseFinder role hierarchy or RBAC;
- `security.user_roles` / `security.roles` semantics;
- Access Admin rank-6 boundary;
- Evidence/Pipeline/Data Quality ACLs;
- canonical Provider/Course data;
- Search/publication behaviour.

Existing users are not silently assigned replacement passwords. Exact post-enable behaviour will be validated during Production UAT rather than assumed.

## 7. Pilot evidence / current exception

**Pre-change advisor check:** PASS as evidence of the gap.

Observed live Pilot warning:

`auth_leaked_password_protection — Leaked Password Protection Disabled — WARN`

Observed Pilot organisation plan:

`free`

Current Supabase documentation requires Pro Plan or above.

No Pilot Auth setting, database schema, application source or subscription was changed.

**Pilot disposition:** DEFERRED / ACCEPTED TEMPORARY EXCEPTION.

This exception is bounded to the Pilot environment and must not be copied into Production acceptance.

## 8. Production closure gate

This Change Control may move to **CLOSED / PASS** only when all are true for the Production environment:

- Production project/environment identity is recorded;
- subscription eligibility is confirmed;
- leaked-password protection is enabled;
- Production security advisor no longer reports `auth_leaked_password_protection`;
- a controlled leaked-password rejection is proven without storing password material;
- a compliant governed UAT identity can still authenticate;
- Access Admin / RBAC regression passes;
- no unrelated Auth regression is introduced;
- evidence is retained in `docs/uat/`;
- Production readiness/cutover record references this PASS.

Until then, the Production go-live security gate is **NOT SATISFIED**.

## 9. Rollback

If Production enablement later causes a demonstrated Auth compatibility issue during bounded pre-go-live UAT, disable the setting temporarily, record the evidence and move this control back to BLOCKED. Production must not proceed while the mandatory gate is unsatisfied. No database rollback is required.

## 10. Current status

**DEFERRED FOR PILOT — MANDATORY PRODUCTION GO-LIVE GATE.**

Pilot remains accepted on its existing runtime with this documented exception. No Pilot runtime/UI/schema version changes are made.

Production leaked-password protection remains outstanding and must be implemented and UAT-proven before Production cutover. This decision changes programme/release governance only; it does not justify a Running Build, Database Architecture, Admin/PIM Decisions, PIM Admin Guide or visible UI version bump.