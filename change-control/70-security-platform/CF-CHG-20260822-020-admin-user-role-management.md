# CF-CHG-20260822-020 — Admin user and role management

**Status:** **BLOCKED — DEPLOYED CREATE / ROLE ASSIGNMENT / AUDIT PASS; ROLE-EDIT / EXPIRY / DISABLE-REENABLE BROWSER UAT PENDING**  
**Category:** `70-security-platform`  
**Initiated:** 22 August 2026 21:12 AEST (UTC+10)  
**Last updated:** 22 August 2026 22:07 AEST (UTC+10)  
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

The capability also removes the normal operational dependency on Supabase Dashboard/SQL for creating the dedicated UAT identity required by `CF-CHG-20260822-019`.

## 2. Existing authority reconciled

Authorization remains:

`Supabase Auth identity → security.user_roles → security.roles → security.current_role_rank()`.

`security.current_role_rank()` resolves the highest active, unexpired assigned role. Multiple role assignments are additive, with the highest active rank governing effective access. The Admin workspace preserves this existing model rather than inventing a new role hierarchy.

Current role boundaries remain:

- assigned role: Catalogue / Data Quality;
- Curator+ rank 3: Evidence / Review;
- Pipeline Operator+ rank 4: Jobs / Sources / Pipeline;
- PIM Admin+ rank 5: PIM Configuration;
- Platform Admin rank 6: privileged identity/platform administration.

## 3. Implemented security design

User management is restricted to **Platform Admin rank 6**.

The browser never receives a Supabase service-role key. Privileged Auth operations execute in JWT-protected Edge Function `admin-user-management`, which:

1. requires the normal signed-in Supabase bearer JWT;
2. resolves current CourseFinder context through `public.admin_read('context', ...)` using the caller identity;
3. requires effective CourseFinder role rank 6;
4. only then instantiates the server-side service-role client;
5. performs Supabase Auth Admin operations plus service-only RBAC RPCs;
6. records access-management audit events without passwords/tokens.

No direct browser CRUD on `auth.users`, `security.roles`, `security.user_roles` or the access-audit table is authorised.

### Live implementation

Migration:

`20260822111848 — m1_access_roles_admin_v1`

New table:

`security.user_access_events`

New service-only functions:

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

## 4. Admin workflow implemented

New Platform Administration workspace: **Users & Roles** (`#users-roles`).

Capabilities implemented:

- list/search current Supabase Auth users and CourseFinder assignments;
- show confirmed/invited, last-sign-in, enabled/disabled state;
- show all six governed roles and effective highest role;
- create by invitation — default normal-staff workflow;
- create a confirmed password account for controlled UAT/test identities;
- assign one or more governed roles, with single-role assignment recommended for UAT identities;
- replace role assignments;
- optional common role-assignment expiry;
- disable / re-enable accounts;
- recent access-management audit history.

Not in v1 scope:

- destructive Auth-user deletion from the Admin UI;
- password retrieval/reset administration;
- service-role/browser credential exposure.

Visible deployed marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · Access Admin v1.0 · governed`

PIM Admin remains versioned independently at v2.12; Access Admin is v1.0.

## 5. Lockout controls

The server rejects:

- self-disable by the current Platform Admin;
- self-removal of `platform_admin`;
- removal/disablement of the last active Platform Admin;
- unknown/inactive role codes;
- creation/role replacement with no governed role;
- expiry on `platform_admin` in v1.

Browser-side controls mirror these rules for operator feedback but are not relied on as the security boundary.

## 6. Technical UAT evidence

### 6.1 ACL / private boundary — PASS

Verified live after migration:

- anon `svc_admin_access_snapshot` EXECUTE: false;
- authenticated `svc_admin_access_snapshot` EXECUTE: false;
- service_role snapshot EXECUTE: true;
- authenticated role-replacement helper EXECUTE: false;
- service_role role-replacement EXECUTE: true;
- authenticated disable-guard EXECUTE: false;
- service_role disable-guard EXECUTE: true;
- `security.user_access_events` RLS: enabled;
- authenticated audit SELECT: false;
- service-role audit SELECT/INSERT: true.

A service-context snapshot returned exactly six governed roles and the live role-assignment set.

### 6.2 Lockout regression — PASS

Live service-context tests proved:

- self-disable rejected with SQLSTATE `42501` / `platform admin cannot disable own account`;
- self-removal of `platform_admin` rejected with SQLSTATE `42501` / `platform admin cannot remove own platform_admin role`.

The last-active-Platform-Admin condition is also enforced by the same service functions. It is not destructively exercised against the sole live Platform Admin merely to produce UAT evidence.

### 6.3 Build/browser smoke — PASS

Pilot PR `#21 — CF-CHG-020: Platform Admin Users & Roles`.

PR head:

`22d6af25709d053b15d41e845d774acfaaeb0174`

Workflow:

- `Pilot Frontend Build` run #111;
- run ID `32570183349`;
- production Vite build: PASS;
- Playwright suite discovery: PASS — 8 tests / 2 files / desktop + mobile projects;
- local Chromium login-shell smoke: PASS;
- evidence upload: PASS;
- artifact ID: `9475125044`;
- artifact digest: `sha256:ba51550430b3b423ca1005ea2e660a0d0b7a4e6d756a8283058a5fe25df43ddc`.

Pilot main had not advanced from `80c293ff3d757a14cdb4495508684df1e6036e64` before merge, so no parallel Pilot code was overwritten.

PR #21 merged to Pilot main:

`c4ca6f9bbf1a9b430d9b860a2962df22b8da49c0`

### 6.4 Advisor regression

Security advisor retains the established internal/private-table INFO pattern `RLS enabled / no policies`; the new access-audit table follows that deliberate private/service-only pattern. Existing project warning **Leaked Password Protection Disabled** remains open and was not introduced by this change.

Performance advisor shows existing unindexed-FK/unused-index INFO. The two new audit indexes were reported unused immediately after creation, which is expected before operational audit volume exists and is not an acceptance defect.

## 7. Deployed browser acceptance

### 7.1 Create / assignment / audit subgate — PASS

Fresh authenticated mobile-browser evidence was supplied against `coursefinder-pilot.techm.workers.dev` at approximately 22:05 AEST on 22 August 2026.

The deployed browser proved:

- `Users & Roles` opens as Platform Administration / rank 6;
- sidebar and runtime marker expose `Access Admin v1.0`;
- `Create user` completed successfully;
- the user directory showed 3 Auth users, all enabled;
- the workspace showed 1 active Platform Admin and 6 governed roles;
- the newly created account showed assigned role `Curator` and effective role `Curator`;
- Recent access changes rendered `Roles Replaced` and `User Created` events;
- the browser success message explicitly states that the password is not stored or retrievable from CourseFinder.

Immediate live Supabase reconciliation matched the screenshot exactly:

- Auth users: `3`;
- enabled users: `3`;
- disabled users: `0`;
- active Platform Admins: `1`;
- active role assignments: Viewer `0`, Counsellor `0`, Curator `2`, Pipeline Operator `0`, PIM Admin `0`, Platform Admin `1`;
- `roles_replaced`: `2026-08-22T12:05:28.497227Z`;
- `user_created`: `2026-08-22T12:05:29.050027Z`.

No password or token material was recorded in governance evidence.

Detailed evidence:

`docs/uat/coursefinder-access-admin-v1-deployed-browser-evidence-2026-08-22.md`

### 7.2 Remaining deployed browser checks

The supplied browser evidence does **not** prove the following actions, so they remain open rather than being fabricated as PASS:

1. replace roles on an existing non-critical test identity and confirm effective rank changes;
2. set/remove optional role expiry on a non-Platform-Admin identity;
3. disable then re-enable a non-critical test identity;
4. confirm the deployed UI/server path refuses self-disable / self-removal of the current Platform Admin;
5. return to mature Admin and confirm Catalogue / Data Quality / Evidence / Pipeline routes remain functional.

These are now the only remaining `CF-CHG-020` acceptance items.

## 8. Versioning / architecture

The accepted programme baseline remains unchanged until the remaining browser mutation regression closes:

- Master Project Plan v1.59;
- Running Build v2.62;
- PIM Admin Guide v1.13;
- Admin/PIM Design Decisions v1.12;
- Database Architecture v2.10.38;
- PIM Admin v2.12.

Unlike Data Quality, this work introduces a real security schema artifact (`security.user_access_events`) and privileged service contract. Database Architecture should advance during final closure, not before the browser mutation gate is complete.

## 9. Rollback

- remove the Users & Roles browser route/navigation;
- disable/remove `admin-user-management`;
- revoke/remove service-only helper RPCs and access-audit table only after preserving required audit evidence;
- existing Supabase Auth users and pre-existing role assignments remain authoritative and are not deleted by rollback.

## 10. Current gate

**BLOCKED — DEPLOYED CREATE / ROLE ASSIGNMENT / AUDIT PASS; ROLE-EDIT / EXPIRY / DISABLE-REENABLE BROWSER UAT PENDING.**

The deployed user-creation path is operational. The remaining blocker is limited to deployed regression of the other privileged mutation controls and does not represent a backend, security-contract, build, canonical-data, Search or Evidence defect.
