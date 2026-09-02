# CF-CHG-20260902-078 — Users & Roles / PIM Operator Restoration

**Status:** IMPLEMENTED / TARGETED VERIFICATION ACTIVE  
**Initiated:** 2 September 2026, 20:42 AEST (Australia/Melbourne)  
**Origin:** CourseFinder chat — “User and roles menu items disappeared, bring it back I need to create a PIM operator role”  
**Owner:** CourseFinder Platform / Admin  
**Primary category:** 70-security-platform  
**Affected surfaces:** 30-admin-pim-ux, Supabase RBAC, Access Admin, release UX  
**Change class:** corrective navigation + role presentation; no authority expansion

## Problem

The governed Users & Roles workspace and server-side Platform Admin access contract remained present, but a later Administration refactor removed its canonical entry from the Administration sub-navigation. This made the existing access-management capability effectively undiscoverable.

The accepted rank-5 PIM role existed internally as `pim_admin` / “PIM Admin”. The requested operator-facing role is “PIM Operator”.

## Requested outcome

1. Restore **Administration → Users & Roles** for Platform Admin only.
2. Permit a Platform Admin to create/invite a user and assign the rank-5 PIM operating role.
3. Present that role as **PIM Operator** without changing its internal code, rank, or existing authorization boundary.
4. Do not restore the retired Operations-menu DOM injection.

## Before

- Access workspace: present at `#users-roles`, rank 6 only.
- Canonical Administration sub-navigation: Users & Roles entry missing.
- Rank-5 role: `pim_admin`, display name “PIM Admin”.
- Access workspace Back to Admin action returned to Dashboard.

## After

- Platform Admin rank 6 sees **Users & Roles** in Administration and can enter the existing governed Access Admin workspace.
- Rank-5 `pim_admin` is displayed as **PIM Operator**.
- `pim_admin` code and rank 5 remain unchanged, so all existing server-side `v_rank >= 5` PIM configuration contracts remain stable.
- PIM Operator receives no rank-6 Users & Roles, platform/security, or identity-administration authority.
- Access Admin returns to `#administration`.
- Legacy post-render sidebar injection remains disabled.

## Security / authority impact

No authorization widening is introduced.

- User creation, invitation, role replacement, disable/enable and access audit remain behind the existing rank-6 Platform Admin Edge Function/service contract.
- PIM Operator is a presentation change over the existing `pim_admin` role, not a new duplicate rank.
- The unique role-rank model is retained.
- No service-role credential is exposed to the browser.
- Layer 1/2/3/4 authority, Search, Publication and consumer contracts are unchanged.

## Implementation

### Pilot UI

Target UI version: **2.15.39**

- `src/mature-main.jsx`
  - restores Users & Roles as a Platform Admin-only Administration section;
  - adds an Administration overview entry;
  - routes the entry to the retained `#users-roles` workspace;
  - does not add a root/Operations navigation item.
- `src/access-roles-entry.jsx`
  - Back to Admin now returns to central Administration.
- `index.html`, `src/pim-version-entry.js`
  - version and release note updated to v2.15.39.

### Pilot database

Applied migration:

`20260902104605_cf_078_restore_users_roles_pim_operator_label`

The migration changes only the rank-5 display name/description:

- code: `pim_admin` — unchanged;
- rank: `5` — unchanged;
- display name: `PIM Operator`;
- Platform Admin remains rank 6.

## Verification / UAT

Targeted acceptance:

- [x] live `security.roles` confirms `pim_admin` = PIM Operator, rank 5;
- [x] Platform Admin remains rank 6;
- [x] canonical source restores Administration → Users & Roles only when `rank >= 6`;
- [x] legacy Access Admin DOM nav injection remains disabled;
- [x] Access Admin remains rank-6 gated;
- [ ] source build/CI;
- [ ] deployed authenticated browser confirmation;
- [ ] create/invite a test user with PIM Operator and confirm rank-5 PIM access / rank-6 denial.

## Rollback

1. Revert the v2.15.39 Pilot UI commits.
2. Restore `security.roles.name='PIM Admin'` and the prior description for `code='pim_admin'`.
3. Do not delete or rewrite existing user-role assignments; they continue to reference the stable `pim_admin` code.

## Related governance

- `CF-CHG-20260822-020` — Admin user and role management.
- M2 A20/A21 canonical Administration/navigation contract.
- `docs/coursefinder-admin-pim-design-decisions-v1.28.md`.
- `docs/coursefinder-pim-admin-guide-v1.22.md`.
