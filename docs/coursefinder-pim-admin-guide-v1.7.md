# CourseFinder PIM Admin Guide v1.7

**Status:** LIVING GOVERNANCE GUIDE — ATTRIBUTE/OPTION/COMPLETENESS UPDATE  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.6.md`  
**Change Control:** `CF-CHG-20260820-001`, `008`, `009`, `010`, `011`, `012`, `013`, `014`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`

All unchanged v1.0-v1.6 rules remain in force. v1.7 defines the PIM Attribute governance contract, especially governed Option vocabulary and Completeness Profile Rules.

## Attribute Families

A Family groups PIM Attributes for a governed business/entity context.

Rules:

- Family identity uses durable code/ID, not current display label;
- Family is organisational/semantic structure, not a field value;
- moving an Attribute between Families is a governed configuration change;
- a Family does not itself grant publication or completeness.

## Attribute Groups

A Group organises related Attributes for PIM administration.

Rules:

- group code is the durable configuration identity;
- name/label/order can be presentation-oriented but remain traceable;
- Group membership must not silently change source authority or field meaning;
- Admin layout convenience is not permission to merge Attributes with different semantics.

## Attributes

An Attribute defines a governed field contract.

Admin audit should make recoverable where applicable:

- stable Attribute code;
- label/name;
- data type;
- entity/family/group scope;
- validation/required behaviour;
- classification/publication treatment;
- status/lifecycle;
- Option-backed vocabulary relationship;
- configuration provenance/change history where implemented.

The Attribute code is the durable semantic identity. A display-label change should not require a new Attribute unless its meaning changed.

## Attribute Options

Options are governed vocabulary, not a frontend convenience list.

For select/multiselect/enumerated Attributes, Admin must be able to inspect the accepted Option set.

Preserve:

- Option code/value identity;
- display label;
- parent Attribute relationship;
- status/lifecycle;
- sort/display order;
- other stored governance metadata.

Rules:

- do not invent Options in the UI merely to make a form usable;
- zero Options on an Option-backed Attribute is an explicit configuration state that needs review, not permission for free text;
- deprecated/inactive Options should remain auditable and must not be silently rewritten to another Option;
- display order is not business precedence unless the Attribute contract explicitly says so;
- consumer integrations should use stable Option identity rather than label-only matching.

## Completeness Profiles

A Completeness Profile defines a named readiness/presence policy context.

A Profile by itself is not enough to understand a score.

Admin must expose the Profile together with its Rules.

Possible Profile dimensions include:

- governed entity/scope;
- required attributes;
- weights;
- thresholds;
- ordering;
- conditional applicability;
- status/effective lifecycle.

Do not infer any dimension not actually configured.

## Completeness Profile Rules

Rules give operational meaning to the Profile.

Each Rule should remain attributable to its parent Profile and preserve the stored rule identity/configuration.

Rules may determine:

- which Attribute is tested;
- whether it is required;
- weighting/contribution;
- ordering;
- conditional behaviour;
- other stored validation/readiness semantics.

A rule change is a material semantic/configuration change where it changes how readiness is calculated and must be traceable through Change Control where applicable.

## Completeness is not truth

This project has multiple completeness/readiness contexts. Keep them named.

### PIM Profile completeness

Readiness/presence under a configured `pim.completeness_profiles` policy and its Rules.

### Course Admin canonical-presence readiness

Current six-signal display rule:

- registration;
- structure;
- fee;
- intake;
- English;
- description.

This remains explicitly display-only and is not automatically a PIM Profile simply because Profile infrastructure exists.

### Consumer/Search readiness

Separately governed publication/projection admission state.

Never map these to one generic `Complete` Boolean without an explicit contract.

## PIM Admin role boundary

PIM governance reads require PIM Admin / rank 5 or higher.

Normal browser path:

`public.admin_read('attributes')` → `security.admin_pim_governance_read(...)`

Legacy public PIM projection helpers are compatibility/internal surfaces, not normal authenticated browser APIs.

## Required PIM workspace presentation

A mature PIM governance view should show:

1. Families;
2. Groups;
3. Attributes;
4. Attribute Options;
5. Completeness Profiles;
6. Completeness Profile Rules.

Preferred relationship-aware presentation:

- Options grouped/cross-linked under their parent Attribute;
- Rules grouped/cross-linked under their parent Completeness Profile;
- dense grids remain searchable/resizable where volume requires;
- raw UUIDs are secondary audit metadata, not primary business labels;
- explicit empty state where a relationship collection is empty.

## Zoho/consumer rule

PIM configuration objects are internal by default.

When a canonical field backed by an Option is admitted to Zoho/Website, expose the governed field value/Option identity—not the internal PIM configuration tables.

Completeness Profiles and Rules should normally remain internal diagnostics unless a separately governed operational-integration use case requires them.
