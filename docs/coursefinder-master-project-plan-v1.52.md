# CourseFinder Master Project Plan v1.52

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.51.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.56.md`

## Current programme position

Accepted AU Layer 1, Layer 2, Search-isolation and PIM semantic baselines remain unchanged.

Current additional `M1-PIM-GOV` gates:

| Change | State |
|---|---|
| `CF-CHG-013` Operations role boundary | DB/RPC/security PASS; deployed role-browser UAT pending |
| `CF-CHG-014` PIM Attribute Options / Completeness Rules | DB/RPC/security PASS; frontend semantic presentation pending |

Earlier open PIM semantic records retain their existing technical/frontend-source PASS and deployed-browser acceptance gates.

## Attribute governance decision

PIM governance is not complete if the Admin can see an Attribute but not the governed vocabulary or scoring rules that define its permitted values/readiness behaviour.

### Option-backed Attributes

Attribute Options must remain visible/auditable with:

- stable identity/code;
- label;
- parent Attribute;
- status;
- ordering/governance context.

UI convenience cannot create Option vocabulary that does not exist in PIM governance.

### Completeness Profiles

Profile meaning depends on its Rules.

A Profile record without visible Rules must not be used by an Admin to infer which fields are required, how they are weighted or whether a particular entity is ready.

Completeness/readiness remains distinct from truth, approval and publication.

## Governed backend contract

Migration 071 introduces:

`security.admin_pim_governance_read(jsonb)`

Minimum role: PIM Admin / rank 5.

The normal browser route is:

`public.admin_read('attributes')` → private rank-checked helper.

The payload includes Families, Groups, Attributes, Options, Completeness Profiles and Completeness Profile Rules.

Direct normal-browser execution of the five legacy public PIM projection helpers is removed.

## Frontend state

PIM Admin remains **v2.9.0**.

`CF-CHG-014` is not frontend-complete until the PIM Governance page presents:

- Options grouped/cross-linked under parent Attributes;
- Profile Rules grouped/cross-linked under parent Completeness Profiles;
- explicit empty states;
- durable code/label/status semantics;
- clear distinction between PIM Profile completeness and the existing six-signal Course Admin readiness rule.

## Governance outputs

- PIM Admin Guide v1.7;
- `CF-CHG-20260820-014`;
- Attribute governance UAT;
- migration 071;
- Running Build v2.56.

Zoho Consumer Contract remains v1.3 because PIM configuration itself is internal. A consumer Option value, if admitted, must be mapped through the curated canonical field contract rather than exporting internal PIM configuration tables.

## Preserved programme baselines

- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- AU Course Facts: RMIT + UQ / 10 bounded Courses;
- QUT source-specific blocker unchanged;
- QILT/PRISMS/Scholarship accepted state unchanged;
- Search Course Documents: 33,105;
- Search enrichment admission remains separately governed;
- vector Search remains not admitted;
- architecture remains v2.10.37.

## Next M1-PIM-GOV work

1. source-implement PIM Attribute Option and Completeness Profile Rule presentation;
2. keep PIM configuration change history and source/semantic meaning auditable;
3. complete deployed role/browser acceptance for open PIM governance records when appropriate identities/runtime access exist;
4. do not expose internal PIM configuration to Zoho/Website without a separate consumer need/contract.
