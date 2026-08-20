# CourseFinder PIM Admin Guide v1.4

**Status:** LIVING GOVERNANCE GUIDE — SCHOLARSHIP COMPOUND-SEMANTICS UPDATE  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.3.md`  
**Change Control:** `CF-CHG-20260820-001`, `008`, `009`, `010`, `011`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`

All unchanged v1.0-v1.3 rules remain in force. v1.4 adds explicit Scholarship cycle, scope, eligibility-logic, award and coverage guidance.

## Scholarship identity

A Scholarship is a governed relational entity. Use its stable identifier/source identifier before display name. A renamed Scholarship must not become a new Scholarship solely because its display label changed.

Provider ownership is optional: a government Scholarship such as Australia Awards need not have one canonical Provider owner.

## Offering Cycle

An Offering Cycle is the temporal parent for cycle-specific Scholarship observations.

Admin must preserve:

- `cycle_code`;
- academic year when supplied;
- intake/cycle label;
- validity window;
- cycle status;
- source/evidence;
- source metadata where it changes interpretation.

Do not use the top-level Scholarship `academic_year` or application convenience dates to overwrite richer cycle/window observations.

## Application Windows

Application Windows repeat under an Offering Cycle.

Important rules:

- multiple rounds remain multiple rows;
- exact open/close timestamps remain nullable;
- source-only closing text remains source text if no exact date is supplied;
- do not manufacture a date from phrases such as `Mid September each year - check website for exact dates`;
- application method and application URL belong to the window where supplied;
- window status is independent from Scholarship lifecycle/publication state.

## Scholarship scopes

Scopes state where a Scholarship is explicitly included/excluded.

Possible governed targets include Provider, Course, Course Collection, Study Level, Field of Study, Country and Campus.

Rules:

- preserve `scope_type`;
- preserve `include_exclude`;
- resolve IDs to canonical display identities in Admin while retaining stable IDs for audit;
- no Scope rows does **not** mean `all Providers`, `all Courses` or universal applicability;
- eligibility criteria may carry audience/country meaning independently of structured Scope rows;
- cycle-scoped Scope rows stay attached to that cycle.

## Compound eligibility

Eligibility is a logical tree, not a flat checklist.

`criterion_groups` define:

- parent/child relationship;
- group code/label;
- conjunction (`all`, `any`, or another governed future operator);
- mandatory state;
- display/order context;
- source/evidence.

`criteria` are direct children of a group and preserve:

- criterion type;
- operator;
- human/source text;
- typed values;
- mandatory state;
- machine-evaluable state;
- status;
- confidence;
- source/evidence.

### Conjunction rules

- `all` → all governed requirements/child groups in that group must be satisfied according to the rule structure;
- `any` → one governed alternative in that group may satisfy the group, subject to parent-group logic.

Never flatten nested groups into one list because doing so can change the eligibility rule itself.

`machine_evaluable=false` means the criterion requires human/source interpretation. It does not mean the criterion failed or should be ignored.

### Australia Awards reference

For the current 2027 cycle:

- `General eligibility` = mandatory `all` group with 7 direct criteria;
- `Participating-country pathway` = mandatory child `any` group with 2 direct criteria.

Admin should make this hierarchy visually obvious. The nine criteria must not be presented as nine independent equivalent conditions.

## Award Tiers versus Coverage

These are different semantic classes.

### Award Tier

Represents a value/award option such as:

- AUD amount;
- percentage;
- basis (`annual`, `tuition_fee_reduction`, etc.);
- maximum amount;
- source notes.

Example: RMIT David Phillips Memorial Scholarship — AUD 5,000 / annual.

### Coverage

Represents benefit components such as:

- tuition fees;
- living expenses;
- health cover;
- return air travel;
- establishment allowance;
- pre-course English;
- supplementary academic support.

A Coverage row may have a percentage/amount/duration or may be defined primarily by source notes. Do not force every Coverage benefit into a numeric amount.

Australia Awards currently has nine separate governed Coverage components. They must not be collapsed into one generic `Full scholarship` value.

## Unscoped cycle observations

If a cycle-capable child observation has `cycle_id=NULL`, Admin must keep it visible as Scholarship-level/unscoped rather than attaching it to the most recent or active cycle.

Use exception-first presentation such as **Needs Attention / Scholarship-level or unscoped observations** where interpretation matters.

## Scholarship provenance

The Scholarship header source/evidence does not automatically prove every child observation.

Admin should expose source/evidence at the child level for:

- cycle;
- window;
- scope;
- eligibility group;
- criterion;
- award tier;
- coverage.

## Lifecycle/publication caution

Scholarship lifecycle, cycle/window status and publication are independent concepts.

Examples:

- Scholarship `active` + publication `unpublished` is valid;
- an Offering Cycle can be `closed` while the Scholarship entity remains `active`;
- a recurring Scholarship may have a window whose exact dates are not yet supplied;
- Admin visibility does not mean consumer publication.

## Zoho / consumer consequence

Consumer payloads must preserve the same parent/child/cardinality semantics. If Zoho cannot represent recursive/nested eligibility without semantic loss, Scholarship eligibility admission must remain blocked or use a separately governed relational child-module design.
