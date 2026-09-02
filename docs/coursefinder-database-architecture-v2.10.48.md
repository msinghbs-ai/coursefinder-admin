# CourseFinder Database Architecture v2.10.48

**Status:** CURRENT ADDITIVE M2.5 ARCHITECTURE  
**Date:** 2 September 2026  
**Supersedes:** v2.10.47; unchanged accepted architecture remains authoritative.  
**Change Controls:** CF-CHG-20260902-063, CF-CHG-20260902-080, CF-CHG-20260902-081

## Layer 2 shared acquisition plane
A physical `pipeline.sources` row may now support more than one `layer2_source_profile`. Source identity/evidence remains singular; extraction semantics remain profile-versioned.

`pipeline.layer2_shared_fetches` records bounded same-URL acquisition reuse. `pipeline.layer2_fanout_tasks` records independent downstream extraction work. Reuse means “reuse captured bytes/Evidence”, never “copy another module's interpretation”.

Layer 2 route scope is explicitly limited to:
- Course facts;
- Scholarships;
- Provider assets.

QILT, PRISMS, rankings/statistical editions and other Layer 1 domains remain excluded.

## Provider asset domain
`catalogue.provider_assets` stores evidence-backed Provider display assets. `pipeline.provider_asset_candidates` is the discovery/review staging relation.

A logo:
- belongs to canonical `provider_id`;
- may have light/dark/brand variants;
- retains original source URL, content hash and Evidence;
- may be approved/rejected/superseded;
- cannot establish or change canonical Provider identity.

## Acquisition adapters
The existing acquisition-provider registry remains authoritative. CF-081 adds a disabled `parsebot` structured-proxy slot. It has no endpoint or credential until qualification.

Preferred cost-aware route is reusable Evidence → Direct HTTP → qualified structured proxy → Firecrawl/rendered fallback → governed terminal fallback.

## Refresh policy
`pipeline.layer2_domain_refresh_policies` separates full refresh frequency from low-cost change checks and deadline-sensitive acceleration. This prevents blanket daily vendor recrawls.

## Scholarship relationship
The accepted Scholarship relational identity, cycles, windows, eligibility, scope, award tiers and coverage remain unchanged. CF-081 changes acquisition efficiency and seed coverage only; it does not flatten Scholarship-to-Course relationships or authorise consumer publication.

## Consumer boundary
Provider logos and Scholarship summaries may later be admitted into Website/Zoho/Search projections only by their relevant consumer contract. This architecture revision does not publish them.
