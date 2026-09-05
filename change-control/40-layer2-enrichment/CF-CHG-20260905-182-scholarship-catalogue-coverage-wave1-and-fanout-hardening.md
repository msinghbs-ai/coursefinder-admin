# CF-CHG-20260905-182 — AU International Scholarship Catalogue Coverage Wave 1 & Fan-out Hardening

**Status:** IMPLEMENTED / DATA FILL ACTIVE  
**Milestone:** M2.4.5

## Objective

Scale the international Scholarship acquisition substrate beyond the original 11 executable AU university routes while preserving first-party authority, Evidence reuse, international-only qualification and fail-closed publication.

## CF-182 — first-party catalogue coverage expansion

Qualified and onboarded official international Scholarship catalogue roots for:

- The University of Sydney
- University of Technology Sydney (UTS)
- Flinders University
- Macquarie University
- Swinburne University of Technology
- University of Wollongong
- Griffith University
- Queensland University of Technology

Each source receives a versioned Layer 2 profile, execution policy and governed acquisition routes using the existing Direct HTTP / Parse.bot / Firecrawl / ZenRows provider registry. No new credential control plane is introduced.

Country preview changed from **11 to 19 executable Providers**.

## CF-183 — catalogue Evidence → shared-fetch bridge

Review found that successful Direct HTTP and Firecrawl catalogue acquisition could return retained Evidence without a `shared_fetch_id`. The Scholarship scope worker therefore stopped after Evidence capture instead of enumerating the catalogue.

A service-only bridge now registers successful catalogue Evidence into the shared-fetch cache using its retained content hash, MIME type, acquisition provider and profile, then runs the normal Provider-page Scholarship fan-out. This applies regardless of whether the acquisition came from Direct HTTP, Firecrawl, Parse.bot or a reused fetch.

The worker remains publication-blocked and does not use the bridge for individual detail jobs.

## CF-184 — precision gate before detail firing

The larger catalogue wave exposed external sponsors and general finance/support links inside international Scholarship pages. The detail classifier now requires:

1. same first-party university host/domain;
2. individual Scholarship/award/grant/bursary/fellowship semantics;
3. international qualification from the governed international catalogue or explicit international cue;
4. target is not the catalogue root itself;
5. target is not finance/loan/sponsor/navigation/support content.

External domains become `external_or_out_of_scope`, catalogue roots become `catalogue_or_filter`, support pages become `support_or_navigation`, and ambiguous first-party pages become `needs_review`. These classes remain outside automatic canonical reconciliation.

## Initial data outcome

The first catalogue fill surfaced **112 new candidate observations** across the eight new universities. Initial candidate counts after fan-out included:

- UTS: 22 new
- UOW: 24 new
- Griffith: 20 new
- Swinburne: 13 new
- Flinders: 11 new
- QUT: 9 new
- Sydney: 7 new
- Macquarie: 6 new

Detail acquisition was then bounded by University. No broad publication is authorised and the CF-171 verified-detail reconciliation gate remains the only canonical-unpublished creation path for these new records.

## Safety / retained contracts

- Scholarships remain international-only for automatic acquisition.
- Search/Website/Zoho publication remains unchanged.
- Existing Evidence is reused where possible.
- CF-102 Provider Logo display/cache architecture is untouched.
- Scraper credentials, vendor quota and route priority remain Administration → Scraper Config authority.

## Source reconciliation

Pilot migrations:

- `20260905002000_cf_182_expand_au_international_scholarship_catalogue_routes_wave1.sql`
- `20260905002100_cf_183_scholarship_catalogue_evidence_shared_fetch_bridge.sql`
- `20260905002200_cf_184_first_party_international_detail_semantic_gate.sql`

Runtime worker:

- `supabase/functions/scholarship-scope-job-execute/index.ts` — CF-183 Evidence/shared-fetch bridge, deployed after source reconciliation.
