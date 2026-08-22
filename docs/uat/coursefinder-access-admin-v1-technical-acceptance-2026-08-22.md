# CourseFinder Access Admin v1.0 — Technical Acceptance

**Evidence window:** 22–23 August 2026  
**Change Control:** `CF-CHG-20260822-020`  
**Result:** **PASS — TECHNICAL + DEPLOYED PRIVILEGED WORKFLOW ACCEPTED**  
**Scope:** Platform Admin user creation, role administration, role expiry, account disable/enable and audit boundary

## 1. Authority

CourseFinder retains the existing RBAC contract:

`Supabase Auth → security.user_roles → security.roles → highest active role rank`.

Six active governed roles are preserved: Viewer 1, Counsellor 2, Curator 3, Pipeline Operator 4, PIM Admin 5 and Platform Admin 6.

Identity administration requires effective Platform Admin rank 6.

## 2. Server implementation

Live migration:

`20260822111848 — m1_access_roles_admin_v1`

Private/service-only audit storage:

`security.user_access_events`

Service-only RPCs:

- `svc_admin_access_snapshot`;
- `svc_admin_access_replace_roles`;
- `svc_admin_access_guard_disable`;
- `svc_admin_access_log_event`.

Live Edge Function:

`admin-user-management` v1, JWT verification enabled.

Function ID: `8deb038b-33e8-4ff9-89fa-90984ec6606e`  
Content SHA: `e00223246414b75af2ba9bbda9b86b248bf50b52ed4cf8ed2259233fdcc6146f`

The function validates normal Supabase Auth plus `admin_read('context')`, requires rank 6, and only then uses server-side service-role authority. No service-role key is returned to browser code.

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

Service-context snapshot returned six active governed roles.

## 4. Lockout result — PASS

Safe negative tests proved:

- self-disable is rejected server-side with SQLSTATE `42501`;
- self-removal of the Platform Admin role is rejected server-side with SQLSTATE `42501`;
- another active Platform Admin must exist before an active Platform Admin can be removed/disabled;
- `platform_admin` assignments cannot carry an expiry in v1.

The sole live Platform Admin was not destructively modified merely to generate test evidence.

## 5. Browser source/build result — PASS

Pilot PR #21 — `CF-CHG-020: Platform Admin Users & Roles`.

Source head:

`22d6af25709d053b15d41e845d774acfaaeb0174`

GitHub Actions:

- workflow `Pilot Frontend Build`;
- run #111 / ID `32570183349`;
- production build PASS;
- UAT suite discovery PASS;
- local Chromium login-shell smoke PASS;
- evidence upload PASS.

PR #21 promoted Access Admin v1.0 to Pilot main at:

`c4ca6f9bbf1a9b430d9b860a2962df22b8da49c0`

Subsequent Pilot promotions retain the same Access Admin v1.0 runtime marker.

## 6. Deployed privileged workflow — PASS

Authenticated Platform Admin browser evidence plus independent server audit reconciliation proves the required controlled-user lifecycle:

`create Curator → replace Curator with Viewer → add Viewer expiry → remove expiry → restore Curator → disable → re-enable`.

Final disable/re-enable audit events:

- `user_disabled` — 23 August 2026 07:20:01 AEST;
- `user_enabled` — 23 August 2026 07:20:10 AEST.

The final server state is restored to:

- account enabled;
- `banned_until = null`;
- governed role = Curator;
- role expiry = null.

The browser shows the success state **Account re-enabled** and Recent access changes contains both `User Disabled` and `User Enabled` alongside the preceding role mutations.

Detailed evidence:

`docs/uat/coursefinder-access-admin-v1-deployed-browser-evidence-2026-08-22.md`

## 7. Audit/privacy result — PASS

Audit payloads contain action, actor/target identifiers, before/after governed state and safe metadata. Passwords/tokens are excluded by contract. No password or token is retained in governance evidence.

## 8. Advisor regression

Security advisor retains the established private/internal `RLS enabled / no policy` INFO pattern. `security.user_access_events` intentionally follows this service-only pattern. The pre-existing **Leaked Password Protection Disabled** warning remains open and was not caused by this work.

Performance advisor retains unrelated project-wide INFO findings. No acceptance failure is attributed to the new low-volume audit indexes.

## 9. Final gate

**PASS.** The technical boundary, build, deployed Platform Admin user lifecycle, expiry semantics, disable/re-enable path, audit trail and lockout controls are accepted.

This control does not alter Provider/Course identity, Layer authority semantics, Search admission, Evidence privacy or publication semantics.
