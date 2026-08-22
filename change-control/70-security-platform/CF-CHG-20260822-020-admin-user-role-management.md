# CF-CHG-20260822-020 — Admin user and role management

**Status:** IMPLEMENTING / UAT  
**Category:** `70-security-platform`  
**Initiated:** 22 August 2026 21:12 AEST (UTC+10)  
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

The capability is also intended to remove the current manual Supabase Dashboard/SQL dependency for creating the dedicated UAT identity required by `CF-CHG-20260822-019`.

## 2. Existing authority reconciled

Current authorization is:

`Supabase Auth identity → security.user_roles → security.roles → security.current_role_rank()`.

`security.current_role_rank()` resolves the highest active, unexpired assigned role. Multiple role assignments are therefore additive, with the highest active rank governing effective access.

Current browser boundaries remain:

- assigned role: Catalogue / Data Quality;
- Curator+ rank 3: Evidence / Review;
- Pipeline Operator+ rank 4: Jobs / Sources / Pipeline;
- PIM Admin+ rank 5: PIM Configuration;
- Platform Admin rank 6: full platform administration.

## 3. Security design

User management is restricted to **Platform Admin rank 6**.

The browser must never receive a Supabase service-role key. Privileged Auth operations execute in a JWT-protected Edge Function which:

1. validates the caller through normal Supabase Auth;
2. resolves current CourseFinder context using the governed browser/session identity;
3. requires effective role rank 6;
4. uses the server-side service-role credential only inside the Edge Function;
5. performs Supabase Auth admin operations and service-only RBAC RPCs;
6. records access-management audit events without recording passwords/tokens.

No direct browser CRUD on `auth.users`, `security.roles`, `security.user_roles` or access-audit storage is authorised.

## 4. Planned Admin workflow

New Platform Administration workspace: **Users & Roles**.

Capabilities:

- list/search current Auth users and CourseFinder role assignments;
- show confirmed/last-sign-in/disabled state;
- show all six governed roles and effective highest role;
- create by invitation (default normal-staff workflow);
- create a confirmed password account for controlled UAT/test identities where explicitly selected;
- assign one or more governed roles, with single-role assignment the normal UAT pattern;
- replace role assignments;
- optional assignment expiry;
- disable / re-enable an account;
- recent access-management audit history.

Not in v1 scope: destructive Auth-user deletion or service-role/browser credential exposure.

## 5. Lockout controls

The server must reject:

- self-disable by the current Platform Admin;
- self-removal of `platform_admin`;
- removal/disablement of the last active Platform Admin;
- unknown/inactive role codes;
- user creation without at least one governed CourseFinder role.

## 6. UAT

Minimum acceptance:

- ACL: non-rank-6 access denied server-side;
- service-only database helper EXECUTE denied to `PUBLIC`, `anon`, `authenticated`;
- all six roles render and can be selected;
- create/invite flow creates Auth identity and matching governed role row(s);
- role replacement updates effective rank correctly;
- expiry is retained;
- disable/re-enable operates through Supabase Auth admin API;
- self/last-Platform-Admin lockout controls PASS;
- no password/token appears in audit payloads or browser response logs;
- production Vite build and browser smoke remain PASS;
- deployed browser UAT required before closure.

## 7. Versioning / architecture

This is a material Admin/security workflow and may advance the visible PIM Admin candidate from v2.12 to v2.13 after implementation. Accepted v2.12 remains the current browser baseline until deployed UAT passes.

A new security access-audit table and service-only RPC contract are expected. Canonical Provider/Course/Scholarship identity, Search admission, Evidence grain and source authority are unchanged.

## 8. Current implementation baselines

- Pilot main: `80c293ff3d757a14cdb4495508684df1e6036e64`;
- Admin main: `8ff2714c47c0a73f9b8d0a17ae95415fc417e6d6`;
- Master Project Plan v1.59;
- Running Build v2.62;
- Database Architecture v2.10.38;
- Admin/PIM Design Decisions v1.12;
- PIM Admin Guide v1.13;
- `CF-CHG-20260822-019` remains open pending its first authenticated deployed automated run.

## 9. Rollback

- remove the Users & Roles browser route/navigation;
- disable/remove the new Edge Function;
- revoke/remove service-only helper RPCs and access-audit table only after preserving required audit evidence;
- existing Supabase Auth users and pre-existing role assignments remain authoritative and are not deleted by rollback.
