# CourseFinder M1-PIM-GOV Attribute Governance UAT

**Date:** 20 August 2026  
**Change Control:** `CF-CHG-20260820-014`  
**Workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Status:** **DB/RPC/SECURITY PASS — FRONTEND PRESENTATION PENDING**

## Purpose

Prove that PIM Attribute governance data is available only through the PIM Admin role boundary and that the governed read includes the Option vocabulary and Completeness Profile Rules needed to audit Attribute/completeness semantics.

## Pre-change presentation gap

The existing Attributes workspace displayed counts for:

- Families;
- Groups;
- Attributes;
- Options;
- Completeness Profiles.

But visible sections rendered only Profiles, Families, Groups and Attributes. Options were not presented, and Completeness Profile Rules were not part of the governed frontend/read result consumed by the page.

## Applied migration

Pilot migration:

`m1_pim_gov_attribute_governance_v1`

Repository mirror:

`supabase/production-migrations/071_m1_pim_gov_attribute_governance.sql`

Created private helper:

`security.admin_pim_governance_read(jsonb)`

Minimum CourseFinder role: **PIM Admin / rank 5**.

## Governed payload UAT

Authenticated assigned Platform Admin read:

`public.admin_read('attributes', {'limit':2000})`

returns collections for:

- `families`;
- `groups`;
- `attributes`;
- `options`;
- `completeness_profiles`;
- `completeness_profile_rules`.

The collections retain the stored PIM rows rather than inventing derived Option/Profile semantics.

**Verdict:** PASS.

## ACL UAT

Direct authenticated browser execution is revoked from:

- `public.ui_attribute_families_list()`;
- `public.ui_attribute_groups_list()`;
- `public.ui_attributes_list()`;
- `public.ui_attribute_options_list(integer)`;
- `public.ui_completeness_profiles_list()`.

The private PIM helper remains callable by authenticated identities only as the governed invoker target and enforces PIM Admin rank internally.

`public.admin_read(text,jsonb)` remains the browser API boundary.

**Verdict:** PASS.

## Data mutation UAT

The migration changes only read functions/grants.

No rows in:

- `pim.attribute_families`;
- `pim.attribute_groups`;
- `pim.attributes`;
- `pim.attribute_options`;
- `pim.completeness_profiles`;
- `pim.completeness_profile_rules`

were rewritten to satisfy the Admin presentation requirement.

**Verdict:** PASS.

## Semantic assertions

- Option code/value identity is different from display label.
- Options remain governed vocabulary even where the current Admin page does not yet render them.
- Completeness Profile name alone is not enough to understand a score; its Rules are required.
- Completeness is presence/readiness under a governed policy, not source truth or publication approval.
- The current six-signal Course readiness remains a separately documented display-only rule unless a governed PIM profile explicitly replaces it.

## Frontend acceptance still required

A later PIM Admin source release must prove:

1. Options are visible and attributable to their parent Attribute;
2. Completeness Profile Rules are visible and attributable to their parent Profile;
3. code/label/status/order semantics are not flattened;
4. empty Options/Rules have explicit empty states;
5. the UI does not imply a Profile is active/applicable merely because it exists;
6. PIM completeness and Course display readiness are labelled as different concepts.

## Final verdict

**DB/RPC read contract:** PASS  
**PIM Admin role boundary:** PASS  
**Legacy direct browser helpers:** CLOSED  
**Canonical/PIM configuration mutation:** NONE  
**Frontend semantic presentation:** PENDING
