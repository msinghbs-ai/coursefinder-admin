# CourseFinder Access Admin Contract v1.0

**Status:** CANDIDATE — technical implementation PASS; deployed browser acceptance pending  
**Change Control:** `CF-CHG-20260822-020`  
**Effective candidate date:** 22 August 2026

## Purpose

Define the governed browser/server contract for CourseFinder identity and role administration without exposing Supabase privileged credentials or converting private security tables into browser CRUD surfaces.

## Authorization model

CourseFinder identity remains Supabase Auth. Application authorization remains `security.user_roles` joined to `security.roles`.

Effective access is the highest rank among active, unexpired assigned roles:

1. Viewer;
2. Counsellor;
3. Curator;
4. Pipeline Operator;
5. PIM Admin;
6. Platform Admin.

Multiple assignments remain supported because they are part of the existing model. For ordinary operators and UAT identities, one explicit role is preferred unless additive access is intentionally required.

## Privileged administration boundary

Only effective Platform Admin rank 6 may administer users/roles.

Supported browser path:

`normal Supabase session JWT → admin-user-management Edge Function → normal caller-context/rank validation → server-side service-role client → Auth Admin + service-only RBAC RPCs`.

The service-role key never enters browser JavaScript, browser storage, browser response payloads or audit events.

Direct browser access to `auth.users`, `security.roles`, `security.user_roles` and `security.user_access_events` is not part of the contract.

## Supported v1 operations

- list/search Auth users and governed assignments;
- invite a staff user;
- create a confirmed password identity for a controlled UAT/test account;
- assign/replace governed roles;
- optional common expiry for non-Platform-Admin role assignments;
- disable/re-enable an Auth account;
- read recent access-administration audit events.

Destructive user deletion is intentionally excluded from v1.

## Lockout invariants

The server must not permit:

- the current Platform Admin to disable their own account;
- the current Platform Admin to remove their own `platform_admin` assignment;
- removal/disablement of the last active Platform Admin;
- `platform_admin` with an expiry in v1;
- an empty role set;
- inactive/unknown role codes.

These are server invariants. UI disable states are operator guidance only.

## User creation workflow

### Staff

Default to **Send invitation**. The user completes the normal Supabase Auth invitation/credential flow, while CourseFinder role assignment is established server-side at creation time.

### Controlled UAT/test identity

Use **Create with password** only when an automated/non-interactive test identity is required. Minimum v1 password length is 12 characters. A strong unique password must be used, and it must not be copied into Change Controls, source code, test fixtures, browser logs or chat.

The accepted first use case is the Curator identity required by `CF-CHG-20260822-019` to exercise Data Quality → Course → private Evidence through the deployed automated UAT harness.

## Audit contract

`security.user_access_events` records actor, target, action, before/after state, safe metadata and timestamp.

Actions:

- `user_created`;
- `user_invited`;
- `roles_replaced`;
- `user_disabled`;
- `user_enabled`.

Password/token keys are removed from audit metadata by the service helper. Audit storage remains RLS-enabled and unavailable to ordinary authenticated browser roles.

## UI contract

Candidate workspace: **Users & Roles**.

Visible only for Platform Admin rank 6 in normal navigation. A direct route by a lower role must still fail/deny through the server boundary.

The workspace must visibly distinguish:

- Auth state: invited / enabled / disabled;
- assigned roles;
- expired role assignments;
- effective highest role;
- current operator;
- role expiry;
- recent audited changes.

## Versioning

This capability is **Access Admin v1.0** on the current PIM Admin v2.12 shell. It does not by itself redefine PIM field semantics.

The contract becomes accepted only after deployed authenticated browser UAT closes `CF-CHG-20260822-020`. Until then, Master Project Plan v1.59, Running Build v2.62, PIM Admin Guide v1.13 and Admin/PIM Design Decisions v1.12 remain the accepted baseline.

Because this work introduces `security.user_access_events` and privileged service helpers, the database architecture document should be advanced at closure.