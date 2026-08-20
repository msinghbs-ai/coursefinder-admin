# CourseFinder Running Build v2.56

**Status:** CURRENT GOVERNED SOURCE BUILD — ATTRIBUTE FRONTEND PRESENTATION PENDING  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.55.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.52.md`  
**Attribute governance UAT:** `docs/uat/coursefinder-m1-pim-gov-attribute-governance-uat-2026-08-20.md`

## Build delta

v2.56 preserves PIM Admin **v2.9.0** and all previously accepted semantic/canonical state. It adds backend/security governance for `CF-CHG-20260820-014`: Attribute Options and Completeness Profile Rules are now part of the governed rank-5 PIM read contract.

No frontend version bump is claimed.

## Attribute governance defect

The current PIM Governance page counted Options but did not render them. It also listed Completeness Profiles without exposing the Profile Rules that give a completeness policy its actual scoring/readiness meaning.

The public PIM projection helpers also remained browser-callable compatibility surfaces around the intended PIM Admin role gate.

## Migration 071

Pilot migration:

`m1_pim_gov_attribute_governance_v1`

Repository mirror:

`supabase/production-migrations/071_m1_pim_gov_attribute_governance.sql`

Created private rank-5 helper:

`security.admin_pim_governance_read(jsonb)`

Governed payload:

- Attribute Families;
- Attribute Groups;
- Attributes;
- Attribute Options;
- Completeness Profiles;
- Completeness Profile Rules.

`public.admin_read('attributes')` routes to that helper.

Direct normal-browser execution is revoked from the five legacy public PIM projection functions. Service-role compatibility is retained.

No PIM configuration data was rewritten.

## Semantic rules

### Attribute Options

Options are governed vocabulary, not frontend convenience values.

PIM Admin must be able to audit:

- stable Option identity/code;
- display label;
- parent Attribute;
- status/lifecycle;
- ordering/governance metadata.

### Completeness Profiles and Rules

A Profile name does not define a score on its own. Rules must remain visible and attributable to the Profile.

Completeness remains readiness/presence under a governed policy; it is not source truth, approval or publication.

The existing six-signal Course Admin readiness remains a separately documented display-only rule unless a governed PIM Profile explicitly supersedes it.

## Current acceptance state

DB/RPC/security: PASS.

Frontend semantic presentation: PENDING.

Required source/UI acceptance:

- render Attribute Options and link/group them to parent Attributes;
- render Completeness Profile Rules and link/group them to parent Profiles;
- preserve code/label/status/order distinctions;
- show explicit empty relationship states;
- do not imply Profile applicability merely because a Profile record exists.

## Governance outputs

- `CF-CHG-20260820-014`;
- Attribute governance UAT;
- PIM Admin Guide v1.7;
- migration 071.

Zoho Consumer Contract remains v1.3 because PIM configuration tables are internal. Option-backed consumer values, if admitted later, must use the curated canonical field/Option semantics rather than internal PIM tables.

## Preserved programme baselines

- PIM Admin source version: v2.9.0;
- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- AU Course Facts: RMIT + UQ qualified / 10 bounded Courses;
- Search Course Documents: 33,105;
- Search enrichment admission remains explicitly gated;
- architecture remains v2.10.37.

## Next work

1. implement/source-test relationship-aware Options and Completeness Profile Rule presentation;
2. complete deployed browser UAT for open semantic/security records when appropriate role/runtime access exists;
3. continue PIM configuration/change-history audit without redesigning the canonical model for UI convenience.
