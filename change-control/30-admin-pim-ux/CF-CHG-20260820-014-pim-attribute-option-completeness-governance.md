# CF-CHG-20260820-014 — PIM Attribute Options and Completeness Profile governance

**Status:** APPLIED / DB-RPC-SECURITY PASS — FRONTEND PRESENTATION PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** PIM semantic visibility / completeness-rule auditability / browser ACL hardening

## Trigger

The PIM Governance workspace counted Attribute Options and Completeness Profiles, but its visible sections rendered only:

- Completeness Profiles;
- Attribute Families;
- Attribute Groups;
- Attributes.

Attribute Options were counted but not presented. Completeness Profile Rules were not part of the visible/admin read contract at all.

This creates two governance risks:

1. a select/multiselect Attribute can appear governed while the actual permitted vocabulary/order/status is invisible to the PIM Admin;
2. a Completeness Profile can appear as a named configuration without exposing the rules/weights/required attributes that define its score.

The audit also found that the public `ui_attribute_*` projection helpers were treated as browser-callable compatibility surfaces even though `admin_read('attributes')` is intended to require PIM Admin rank 5.

## Semantic decisions

### Attribute Family

Groups attributes into a governed business/entity family. Family is organisational/semantic structure; it is not an Attribute value.

### Attribute Group

Organises related Attributes within the governed PIM model. Group labels/order may affect Admin usability but must not redefine source authority.

### Attribute

Defines a governed field including code, label/name, data type, scope/classification and validation/governance behaviour.

The Attribute code is the durable semantic identifier. Display labels may change without creating a new Attribute.

### Attribute Option

An Option is part of the governed vocabulary for an option-backed Attribute.

Rules:

- Options must be visible to PIM Admins, not merely counted;
- Option code/value identity must remain distinct from display label;
- sort/display order is presentation metadata, not semantic precedence unless separately governed;
- inactive/deprecated Options must not silently disappear from audit history;
- UI convenience must not manufacture an Option not present in the governed vocabulary;
- consumer/Zoho exposure must use stable option code/value semantics rather than depending on current UI label text.

### Completeness Profile

Defines a named completeness/readiness policy context. A Profile is not itself a truth or approval state.

### Completeness Profile Rule

A Rule defines the actual Attribute requirements/weights/order/conditions that make a Profile meaningful.

Rules:

- a Profile must not be interpreted without its Rules;
- rule changes are semantic/configuration changes and require traceability;
- a completeness score remains presence/readiness under the governed profile, not source truth or publication approval;
- absence of a current Profile/Rule must not be replaced by an invented scoring policy;
- the current six-signal Course Admin readiness remains a separately documented display-only rule until/unless a governed PIM Completeness Profile explicitly supersedes it.

## Applied governed read contract

Pilot migration:

`m1_pim_gov_attribute_governance_v1`

Repository mirror:

`supabase/production-migrations/071_m1_pim_gov_attribute_governance.sql`

Private helper:

`security.admin_pim_governance_read(jsonb)`

Role contract:

- authentication required;
- PIM Admin rank 5 or higher required;
- safe restricted search path;
- browser calls through `public.admin_read('attributes',...)`.

The governed payload now contains:

- `families[]`;
- `groups[]`;
- `attributes[]`;
- `options[]`;
- `completeness_profiles[]`;
- `completeness_profile_rules[]`.

No PIM configuration row was rewritten.

## Browser ACL hardening

Direct normal-browser execution is revoked from:

- `public.ui_attribute_families_list()`;
- `public.ui_attribute_groups_list()`;
- `public.ui_attributes_list()`;
- `public.ui_attribute_options_list(integer)`;
- `public.ui_completeness_profiles_list()`.

They remain service-role compatible for internal composition/replay where still needed.

The browser PIM contract is `public.admin_read('attributes')` → private rank-checked PIM helper.

## Frontend gap remaining

Current PIM Admin source still needs a presentation release that:

1. shows Attribute Options explicitly, preferably grouped under their parent Attribute;
2. shows Completeness Profile Rules under their parent Profile;
3. preserves option/rule codes and status rather than showing labels only;
4. uses explicit empty states where no Options or Rules exist;
5. does not imply a Profile is active/applicable merely because it exists;
6. preserves the distinction between PIM profile completeness and the current display-only Course readiness rule.

Until that source/UI gate passes, this Change Control remains frontend-pending.

## UAT evidence

`docs/uat/coursefinder-m1-pim-gov-attribute-governance-uat-2026-08-20.md`

DB/RPC/security assertions include:

- assigned Platform Admin can read the governed PIM payload through `admin_read`;
- governed payload includes Options and Completeness Profile Rules collections;
- direct authenticated execution of the five legacy public PIM helpers is removed;
- `public.admin_read` remains the browser boundary.

## Consumer impact

No Option or Completeness Profile field is automatically admitted to Zoho/Website/Search.

If an option-backed Attribute is admitted later, consumer payloads must preserve stable option code/value and explicit null semantics. Completeness rules/scores are internal diagnostics by default unless a specific consumer use case is governed.

## Rollback

Rollback only the Admin PIM read/ACL changes if required. Do not delete or rewrite PIM Families, Groups, Attributes, Options, Profiles or Rules to roll back a browser/governance change.

## Closure

**Final status:** OPEN — DB/RPC/SECURITY PASS / FRONTEND PRESENTATION PENDING  
**Closed at:** N/A  
**Outcome:** PIM governance data is now available through one rank-5 read contract and legacy direct browser helper access is closed. Final source/browser acceptance requires explicit Option and Completeness Profile Rule presentation.
