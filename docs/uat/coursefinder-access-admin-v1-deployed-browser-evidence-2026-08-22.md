# CourseFinder Access Admin v1.0 — Deployed Browser Evidence

**Date:** 22 August 2026  
**Change Control:** `CF-CHG-20260822-020`  
**Runtime:** `coursefinder-pilot.techm.workers.dev`  
**Pilot source:** `c4ca6f9bbf1a9b430d9b860a2962df22b8da49c0`  
**Result:** **PARTIAL PASS — DEPLOYED USER CREATION / ROLE ASSIGNMENT / AUDIT PATH PROVEN; ROLE-EDIT / DISABLE-REENABLE BROWSER REGRESSION REMAINS**

## Evidence supplied

A fresh authenticated Platform Admin mobile-browser screenshot was supplied after the Worker had picked up Access Admin v1.0.

Visible deployed evidence:

- `Users & Roles` Platform Administration workspace loaded successfully;
- sidebar identifies `Access Admin v1.0`;
- runtime marker includes `Access Admin v1.0` alongside the accepted PIM/Pipeline/Evidence/Data Quality releases;
- current authority shown as Platform Admin;
- `Create user` action completed successfully;
- success banner states that the password is not stored or retrievable from CourseFinder;
- directory shows three Auth users, all enabled;
- one active Platform Admin is shown;
- governed role count is six;
- the newly created account is shown with assigned role `Curator` and effective role `Curator`;
- recent access changes show `User Created` and `Roles Replaced` entries for the new account.

No password or token material is captured in the screenshot or this evidence record.

## Live server reconciliation

Immediately after the screenshot, live Supabase state was independently queried.

Result:

- Auth users: `3`;
- enabled users: `3`;
- disabled users: `0`;
- active Platform Admins: `1`;
- active role assignments:
  - Viewer `0`;
  - Counsellor `0`;
  - Curator `2`;
  - Pipeline Operator `0`;
  - PIM Admin `0`;
  - Platform Admin `1`;
- recent access events:
  - `roles_replaced` at `2026-08-22T12:05:28.497227Z`;
  - `user_created` at `2026-08-22T12:05:29.050027Z`.

Those timestamps correspond to approximately 22:05 AEST and match the browser evidence.

## Proven deployed acceptance items

The following `CF-CHG-020` browser requirements are now accepted:

1. deployed runtime contains Access Admin v1.0;
2. Platform Admin can see and open Users & Roles;
3. six governed roles are present in the deployed contract;
4. a controlled account can be created from the deployed Admin panel;
5. the new Auth user appears with the selected Curator role and effective rank;
6. access audit records both role replacement and user creation without password/token material.

## Remaining deployed acceptance

The screenshot does not prove the following mutation paths and they are therefore not fabricated as PASS:

1. replace roles on an existing non-critical test identity and confirm effective rank changes;
2. optional role expiry on a non-Platform-Admin identity;
3. disable then re-enable a non-critical test identity from the deployed browser;
4. browser-path confirmation that self-disable / self-removal of Platform Admin remains blocked;
5. quick regression that returning to the mature Admin keeps Catalogue / Data Quality / Evidence / Pipeline routes functional.

Server-side technical UAT for self-lockout controls and service-only helper ACLs already passed before deployment; the remaining requirement is deployed browser-path regression only.

## Gate position

**Access Admin v1.0 user creation is deployed and operational.**

`CF-CHG-20260822-020` remains open only for the remaining role-edit/expiry/disable-reenable browser checks. The accepted product baseline is not bumped solely from this partial evidence.
