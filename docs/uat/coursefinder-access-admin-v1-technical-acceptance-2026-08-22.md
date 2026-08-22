# CourseFinder Access Admin v1.0 — Technical Acceptance

**Date:** 22 August 2026  
**Change Control:** `CF-CHG-20260822-020`  
**Result:** **TECHNICAL PASS / DEPLOYED BROWSER PENDING**  
**Scope:** Platform Admin user creation, role administration, account disable/enable and audit boundary

## 1. Authority

CourseFinder retains the existing RBAC contract:

`Supabase Auth → security.user_roles → security.roles → highest active role rank`.

Six active governed roles are preserved: Viewer 1, Counsellor 2, Curator 3, Pipeline Operator 4, PIM Admin 5 and Platform Admin 6.

The new identity-administration surface requires effective Platform Admin rank 6.

## 2. Server implementation

Live migration:

`20260822111848 — m1_access_roles_admin_v1`

Added private/service-only audit storage:

`security.user_access_events`

Added service-only RPCs:

- `svc_admin_access_snapshot`;
- `svc_admin_access_replace_roles`;
- `svc_admin_access_guard_disable`;
- `svc_admin_access_log_event`.

Live Edge Function:

`admin-user-management` v1, JWT verification enabled.

Function ID: `8deb038b-33e8-4ff9-89fa-90984ec6606e`  
Content SHA: `e00223246414b75af2ba9bbda9b86b248bf50b52ed4cf8ed2259233fdcc6146f`

The function validates the caller through normal Auth + `admin_read('context')`, requires rank 6, and only then uses server-side service-role authority. No service-role key is returned to or embedded in browser code.

## 3. ACL result — PASS

| Check | Expected | Result |
|---|---:|---:|
| anon snapshot EXECUTE | denied | PASS |
| authenticated snapshot EXECUTE | denied | PASS |
| service_role snapshot EXECUTE | allowed | PASS |
| authenticated role replacement EXECUTE | denied | PASS |
| service_role role replacement EXECUTE | allowed | PASS |
| authenticated disable guard EXECUTE | denied | PASS |
| service_role disable guard EXECUTE | allowed | PASS |
| access-audit RLS | enabled | PASS |
| authenticated audit SELECT | denied | PASS |
| service-role audit SELECT/INSERT | allowed | PASS |

Service-context snapshot returned six active governed role definitions.

## 4. Lockout result — PASS

The current Platform Admin was not destructively modified. Safe negative tests proved:

- self-disable is rejected server-side with SQLSTATE `42501`;
- self-removal of the Platform Admin role is rejected server-side with SQLSTATE `42501`.

The service contract additionally counts other active Platform Administrators before permitting removal/disablement of a Platform Admin, preventing last-admin lockout.

## 5. Browser source/build result — PASS

Pilot PR #21:

`CF-CHG-020: Platform Admin Users & Roles`

Source head:

`22d6af25709d053b15d41e845d774acfaaeb0174`

GitHub Actions:

- workflow `Pilot Frontend Build`;
- run #111 / ID `32570183349`;
- production build PASS;
- UAT suite discovery PASS: 8 tests / 2 files across desktop and mobile projects;
- local Chromium smoke PASS;
- evidence upload PASS;
- artifact `9475125044`;
- artifact SHA256 `ba51550430b3b423ca1005ea2e660a0d0b7a4e6d756a8283058a5fe25df43ddc`.

PR #21 promoted to Pilot main:

`c4ca6f9bbf1a9b430d9b860a2962df22b8da49c0`

## 6. Implemented browser workflow

Candidate runtime capability is **Access Admin v1.0** on the retained PIM Admin v2.12 shell.

Platform Admin-only `Users & Roles` provides:

- user list/search;
- Auth confirmation/invitation/disabled state;
- last sign-in;
- all six CourseFinder role assignments;
- highest active/effective role;
- invite-first user provisioning;
- explicit password provisioning for controlled UAT/test accounts;
- role replacement and optional expiry;
- account disable/re-enable;
- access-management audit history.

Password mode requires a minimum 12-character password and is intended for controlled UAT identities. Passwords are sent only to the protected Edge Function and are excluded from audit/event data.

## 7. Advisor regression

Security advisor retains the established private/internal `RLS enabled / no policy` INFO pattern. `security.user_access_events` intentionally follows this service-only pattern. The pre-existing **Leaked Password Protection Disabled** warning remains open and is not caused by this work.

Performance advisor shows project-wide INFO findings. New audit indexes appear unused immediately after creation; no performance gate failure is inferred from a zero-volume audit table.

## 8. Remaining acceptance

Overall control remains **BLOCKED** until the deployed Worker proves the privileged workflow through a real Platform Admin browser session.

Required deployed path:

`Platform Admin → Users & Roles → create controlled UAT identity → assign Curator → verify list/effective role/audit → edit role/expiry → disable/re-enable`.

A lower-role denial should also be proved when a suitable test identity exists. Do not create excessive privileged accounts solely for UAT.

The first newly created Curator UAT account can then be placed into GitHub Actions secrets and used to close `CF-CHG-20260822-019` through the automated deployed Playwright suite.

No password is to be recorded in this document or any Change Control.