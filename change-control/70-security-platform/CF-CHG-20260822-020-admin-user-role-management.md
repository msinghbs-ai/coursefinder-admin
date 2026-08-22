# CF-CHG-20260822-020 — Admin user and role management

**Status:** **CLOSED / PASS**  
**Category:** `70-security-platform`  
**Initiated:** 22 August 2026 21:12 AEST (UTC+10)  
**Closed:** 23 August 2026 07:20 AEST (UTC+10)  
**Origin:** CourseFinder chat — review workflow and create users from Admin panel for all roles  
**Owner:** CourseFinder security/platform governance  
**Affected surfaces:** `30-admin-pim-ux`, `80-uat-release-operations`, Supabase Auth/RBAC, Pilot Admin UI  
**Change class:** privileged identity administration / RBAC / Admin workflow

## 1. Request

Add a governed Platform Admin capability to create and manage CourseFinder users from the Admin panel for every accepted role:

- Viewer — rank 1;
- Counsellor — rank 2;
- Curator — rank 3;
- Pipeline Operator — rank 4;
- PIM Admin — rank 5;
- Platform Admin — rank 6.

The capability also removes the normal operational dependency on Supabase Dashboard/SQL for creating controlled UAT identities.

## 2. Accepted authority

Authorization remains:

`Supabase Auth identity → security.user_roles → security.roles → security.current_role_rank()`.

`security.current_role_rank()` resolves the highest active, unexpired assigned role. Multiple role assignments remain additive; the highest active rank governs effective access.

Role boundaries remain:

- assigned role: Catalogue / Data Quality;
- Curator+ rank 3: Evidence / Review;
- Pipeline Operator+ rank 4: Jobs / Sources / Pipeline;
- PIM Admin+ rank 5: PIM Configuration;
- Platform Admin rank 6: privileged identity/platform administration.

## 3. Accepted security design

User management is restricted to Platform Admin rank 6.

The browser never receives a Supabase service-role key. Privileged Auth operations execute in JWT-protected Edge Function `admin-user-management`, which:

1. requires the signed-in Supabase bearer JWT;
2. resolves current CourseFinder context through `public.admin_read('context', ...)`;
3. requires effective CourseFinder role rank 6;
4. only then instantiates the server-side service-role client;
5. performs Supabase Auth Admin operations plus service-only RBAC RPCs;
6. records access-management audit events without passwords/tokens.

No direct browser CRUD on `auth.users`, `security.roles`, `security.user_roles` or `security.user_access_events` is authorised.

### Live implementation

Migration:

`20260822111848 — m1_access_roles_admin_v1`

Table:

`security.user_access_events`

Service-only functions:

- `public.svc_admin_access_snapshot()`;
- `public.svc_admin_access_replace_roles(uuid,uuid,text[],timestamptz)`;
- `public.svc_admin_access_guard_disable(uuid,uuid)`;
- `public.svc_admin_access_log_event(uuid,uuid,text,jsonb,jsonb,jsonb)`.

Live Edge Function:

- slug: `admin-user-management`;
- version: 1;
- JWT verification: enabled;
- function ID: `8deb038b-33e8-4ff9-89fa-90984ec6606e`;
- deployed content SHA: `e00223246414b75af2ba9bbda9b86b248bf50b52ed4cf8ed2259233fdcc6146f`.

The exact migration and Edge Function source are mirrored in the Pilot repository.

## 4. Accepted Admin workflow

Workspace: **Users & Roles** (`#users-roles`).

Accepted capabilities:

- list/search current Supabase Auth users and CourseFinder assignments;
- show confirmed/invited, last-sign-in and enabled/disabled state;
- show all six governed roles and effective highest role;
- invite-first normal-staff provisioning;
- confirmed password account creation for controlled UAT/test identities;
- assign/replace governed roles;
- optional common role-assignment expiry for non-Platform-Admin roles;
- disable/re-enable accounts;
- recent access-management audit history.

Out of scope for v1:

- destructive Auth-user deletion from Admin;
- password retrieval/reset administration;
- service-role/browser credential exposure.

Visible deployed marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · Access Admin v1.0 · governed`

PIM Admin remains independently versioned at v2.12; Access Admin is v1.0.

## 5. Lockout controls — PASS

The server rejects:

- self-disable by the current Platform Admin;
- self-removal of `platform_admin`;
- removal/disablement of the last active Platform Admin;
- unknown/inactive role codes;
- creation/role replacement with no governed role;
- expiry on `platform_admin` in v1.

Safe negative tests proved self-disable and self-role-removal rejection with SQLSTATE `42501`. The sole live Platform Admin was not destructively altered merely to produce browser evidence.

## 6. Technical boundary — PASS

Verified live:

- anon/authenticated service-helper EXECUTE denied;
- service_role helper execution allowed only where intended;
- access-audit RLS enabled;
- authenticated audit-table SELECT denied;
- service-role audit SELECT/INSERT allowed;
- six governed roles returned by the service-context snapshot.

Security advisor retains the established private/internal `RLS enabled / no policies` INFO pattern. The pre-existing **Leaked Password Protection Disabled** warning remains open and was not introduced here.

## 7. Build/source promotion — PASS

Pilot PR `#21 — CF-CHG-020: Platform Admin Users & Roles` passed:

- production Vite build;
- Playwright suite discovery;
- local Chromium login-shell smoke;
- evidence upload.

Initial Access Admin promotion:

`c4ca6f9bbf1a9b430d9b860a2962df22b8da49c0`

Later Pilot main promotions retain the same Access Admin v1.0 capability.

## 8. Deployed privileged workflow — PASS

Deployed Platform Admin browser evidence plus immediate Supabase audit reconciliation proves the complete controlled-account mutation sequence:

`create Curator → Curator to Viewer → add Viewer expiry → remove expiry → restore Curator → disable → re-enable`.

Final disable/re-enable evidence:

- `user_disabled` — 23 August 2026 07:20:01 AEST;
- `user_enabled` — 23 August 2026 07:20:10 AEST.

Server before/after state proves a real Auth disable/re-enable transition, not only a UI banner. Final state is restored to:

- enabled;
- `banned_until = null`;
- Curator;
- no role expiry.

The deployed browser shows **Account re-enabled** and Recent access changes contains `User Disabled` and `User Enabled` alongside the preceding role mutations.

Detailed evidence:

- `docs/uat/coursefinder-access-admin-v1-technical-acceptance-2026-08-22.md`;
- `docs/uat/coursefinder-access-admin-v1-deployed-browser-evidence-2026-08-22.md`.

## 9. Residual/non-destructive checks

The current Platform Admin self-lockout path is accepted from server-side negative UAT rather than destructively exercised against the sole live Platform Admin. This is deliberate and does not weaken the security boundary.

Regression of unrelated Catalogue/Data Quality/Evidence/Pipeline surfaces is governed separately by the PIM/UAT controls. It is not retained as an Access Admin blocker once the privileged mutation path and shared runtime remain healthy.

## 10. Architecture/version consequence

This control introduces a durable security schema artifact (`security.user_access_events`) and privileged service boundary. Database Architecture and Admin governance should reflect Access Admin v1.0 in the next accepted baseline update.

It does not change Provider/Course identity, Layer authority semantics, Evidence privacy, Search admission or publication semantics.

## 11. Rollback

- remove the Users & Roles browser route/navigation;
- disable/remove `admin-user-management`;
- revoke/remove service-only helper RPCs and access-audit table only after preserving required audit evidence;
- existing Supabase Auth users and pre-existing role assignments remain authoritative.

## 12. Closure

**Final gate: CLOSED / PASS.**

Access Admin v1.0 is accepted for governed user creation, role replacement, optional role expiry, account disable/re-enable, audit history and lockout protection.
