# CourseFinder M1-PIM-GOV v2.9 State Model — Final Regression Addendum

**Date:** 20 August 2026  
**Change Control:** `CF-CHG-20260820-012`  
**Parent UAT:** `docs/uat/coursefinder-m1-pim-gov-state-model-v2.9.0-uat-2026-08-20.md`  
**Status:** **PASS — DEPLOYED BROWSER UAT STILL PENDING**

## Purpose

Record the final source-contract correction found after the main v2.9 UAT: the state panel needed a positive canonical Scholarship relationship value for canonical-vs-Search comparison, but Course detail did not expose `has_scholarship` as a top-level field.

## Defect avoided before publication

The staged frontend initially referenced:

`data.has_scholarship`

That field is not part of the governed Course-detail top-level payload. Treating the resulting `undefined` as false would have created a false negative in the Admin state comparison.

The six-signal Admin readiness definition must also remain unchanged; Scholarship relationship presence is not one of registration/structure/fee/intake/English/description.

## Correction

Pilot migration:

`m1_pim_gov_course_state_scholarship_presence_v1`

Repository mirror:

`supabase/production-migrations/068_m1_pim_gov_course_state_scholarship_presence.sql`

`security.admin_course_state_summary(uuid)` now includes:

```text
canonical_presence.scholarship
```

The field is explicitly outside `admin_readiness.signals`.

`src/CourseStatePanel.jsx` now compares:

- `canonical_presence.scholarship`;
- Search `has_scholarship`.

No canonical Scholarship/Course relationship and no Search document was modified.

## Negative reference — 102784C

Authenticated governed Course-detail result:

- canonical Scholarship relationship: false;
- Search Scholarship admitted: false.

**Result:** PASS.

## Positive reference — RMIT Course 006591A

Course UUID: `147a6114-ad07-46ab-af77-b46998856e69`  
Course Code: `006591A`

The current accepted Scholarship scopes include RMIT Provider-level include scopes.

Authenticated governed Course-detail result after migration 068:

- canonical Scholarship relationship: **true**;
- Search Scholarship admitted: **false**.

**Result:** PASS.

This proves the state panel can distinguish a real canonical Scholarship relationship from Search admission and does not rely on a missing frontend field.

## Security regression

Supabase Security Advisors were rerun after migrations 066–068.

- no new public-schema warning was introduced for `security.admin_course_state_summary`;
- the helper remains in the non-exposed `security` schema;
- `anon` execution remains denied;
- authenticated access remains governed by the helper's authentication/role checks and the `public.admin_read` browser boundary.

Pre-existing legacy `public.ui_*` SECURITY DEFINER findings, private-schema RLS/no-policy informational findings and leaked-password-protection configuration debt remain separate work.

## Final v2.9 migration chain

1. `066_m1_pim_gov_course_state_semantics.sql` — repair Course page Search-state wrapper and explicit Search fields;
2. `067_m1_pim_gov_course_state_detail.sql` — governed detail state summary;
3. `068_m1_pim_gov_course_state_scholarship_presence.sql` — explicit canonical Scholarship relationship presence for admission comparison.

## Verdict

**State model:** PASS  
**Scholarship canonical-vs-Search comparison:** PASS  
**Six-signal readiness definition preserved:** PASS  
**Security regression:** PASS  
**Canonical/Search data mutation:** NONE  
**Deployed browser UAT:** PENDING
