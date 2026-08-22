# CourseFinder Access Admin v1.0 — Deployed Browser Evidence

**Evidence window:** 22–23 August 2026  
**Change Control:** `CF-CHG-20260822-020`  
**Runtime:** `coursefinder-pilot.techm.workers.dev`  
**Result:** **PASS — CREATE / ROLE / EXPIRY / DISABLE-REENABLE / AUDIT PATH PROVEN**

## 1. Evidence supplied

Authenticated Platform Admin mobile-browser evidence was supplied against the deployed Worker after Access Admin v1.0 promotion.

The deployed browser proved:

- `Users & Roles` opens as Platform Administration / rank 6;
- the runtime marker includes `Access Admin v1.0`;
- the current operator authority is Platform Admin;
- `Create user` completed successfully;
- the user directory and governed role inventory load correctly;
- the controlled UAT account was created with Curator access;
- role replacement was exercised on the controlled account;
- optional non-Platform-Admin role expiry was set and then removed;
- the controlled account was disabled and then re-enabled from the deployed browser;
- the final browser state shows all three Auth users enabled and zero disabled;
- the controlled account is restored to Curator with no expiry;
- Recent access changes visibly include `Roles Replaced`, `User Disabled`, `User Enabled` and `User Created` events.

The final browser success banner states **Account re-enabled**.

No password, token or session material is retained in this evidence record.

## 2. Independent live server reconciliation

Live Supabase audit state was queried immediately after the final browser mutation cycle.

The final disable / re-enable sequence is recorded as:

- `user_disabled` at `2026-08-22T21:20:01.573021Z` (23 August 2026 07:20:01 AEST);
- `user_enabled` at `2026-08-22T21:20:10.495335Z` (23 August 2026 07:20:10 AEST).

The audit payload proves the actual server-side account state transition rather than only a UI message:

- before disable: `disabled=false`, `banned_until=null`;
- after disable: `disabled=true`, with a server-set ban timestamp;
- before re-enable: `disabled=true`;
- after re-enable: `disabled=false`, `banned_until=null`.

The same controlled identity had the preceding role/expiry sequence recorded at approximately 06:51–06:52 AEST:

1. Curator → Viewer;
2. Viewer → Viewer with expiry;
3. Viewer with expiry → Viewer without expiry;
4. Viewer → Curator.

The final role assignment is therefore restored to **Curator / no expiry**.

## 3. Security/lockout evidence

The current Platform Admin was not destructively modified merely to generate evidence.

Previously completed technical UAT remains authoritative for the safety controls:

- self-disable is rejected server-side;
- self-removal of `platform_admin` is rejected server-side;
- the service contract prevents disabling/removing the last active Platform Admin;
- private audit/RBAC helpers are not executable by normal browser roles;
- the browser never receives the Supabase service-role credential.

The deployed UI also identifies the current Platform Admin separately and does not require destructive self-lockout testing to close this control.

## 4. Accepted deployed acceptance items

`CF-CHG-20260822-020` now has deployed evidence for the complete operational mutation path:

1. Platform Admin can open Users & Roles;
2. all six governed roles are represented;
3. a controlled user can be created;
4. role assignments can be replaced;
5. effective access follows the active highest role;
6. optional expiry can be applied and removed for a non-Platform-Admin role;
7. a controlled identity can be disabled and re-enabled;
8. the final account/role state is restored correctly;
9. audit history records the mutations without passwords/tokens;
10. server-side lockout controls remain enforced.

## 5. Gate position

**PASS.** Access Admin v1.0 is operational on the deployed Worker and the privileged user/role lifecycle required by `CF-CHG-20260822-020` is accepted.

The separate CourseFinder deployed Playwright gate remains governed by `CF-CHG-20260822-019` / `CF-CHG-20260823-021`; it is not conflated with this privileged-access acceptance result.
