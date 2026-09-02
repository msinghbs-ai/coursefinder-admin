# CourseFinder Database Architecture v2.10.49

**Status:** CURRENT ADDITIVE M2.5 ARCHITECTURE  
**Date:** 3 September 2026  
**Supersedes:** v2.10.48; unchanged accepted architecture remains authoritative.  
**Change Controls:** CF-CHG-20260902-063, CF-CHG-20260902-080, CF-CHG-20260902-081, CF-CHG-20260903-083

## Preserved v2.10.48
The shared Layer 2 acquisition plane, Provider asset domain, adapter routing, refresh policies and consumer boundary from v2.10.48 remain authoritative.

## Scholarship acquisition grain
Scholarship acquisition now has two explicit source grains:

### `scholarship_catalogue`
A list/search/index source that may describe many Scholarships. It is an enumeration source only.

### `scholarship_detail`
A first-party detail source for one Scholarship candidate/identity.

The individual Scholarship extractor must reject `scholarship_catalogue` input. Catalogue Evidence is processed by the catalogue enumerator.

## Catalogue completeness
`pipeline.scholarship_catalogue_runs` retains:
- source;
- Evidence;
- source profile version;
- Provider;
- content hash;
- discovered/unique/duplicate counts;
- status;
- observation metadata.

This provides a measurable answer to “have all 200+ Provider Scholarships been discovered?” without creating Scholarship×Course Cartesian relationships.

## Detail identity
Where a first-party Provider exposes no stronger stable source-native ID, the canonical source identifier is:
- scheme: `first_party_detail_url`;
- value: normalised official Scholarship detail URL.

Content hash is retained for Evidence/version replay and must not replace identity.

## Canonical root before scope
A detail record may create an unpublished canonical Scholarship root after:
- Provider is resolved through stable regulatory identity;
- source identity is stable;
- first-party Evidence exists.

Cycle/window/scope data must not be fabricated merely to complete the root.

## Layer 4 scope resolution
`pipeline.layer4_field_registry` now includes Scholarship `scope_resolution` as a publication-sensitive JSON review field.

An unresolved Scholarship may therefore be:
- canonically identified;
- Provider-linked;
- Evidence-backed;
- unpublished;
- pending Layer 4 scope decision.

Only accepted scope decisions may later populate the relational Scholarship scope model and downstream applicability projections.

## Provider asset promotion
Provider logo candidates and governed assets remain separate.

Promotion creates a managed copy in private `provider-assets` Storage with:
- Provider path;
- SHA-256 hash;
- source URL;
- Evidence reference;
- MIME metadata;
- approved/primary state.

The legacy Provider `logo_url` field is not the source of truth for promoted assets.

## Consumer boundary
Neither a primary Provider asset nor an unpublished Scholarship becomes Website/Zoho/Search-visible solely because it exists in canonical storage.
