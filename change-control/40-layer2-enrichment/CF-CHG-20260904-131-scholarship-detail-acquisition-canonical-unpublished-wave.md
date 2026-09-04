# CF-CHG-20260904-131 — Scholarship Detail Acquisition → Canonical Unpublished Wave

**Status:** IMPLEMENTED / TARGETED PASS  
**Milestone:** M2.4.5  
**Authority boundary:** first-party Provider Scholarship pages only; no automatic Publication/Search/Website/Zoho admission.

## Objective

Advance the AU Scholarship fill from catalogue enumeration into governed first-party detail acquisition, Evidence capture, source-record extraction, deterministic dedupe/reconciliation, and canonical **unpublished** roots.

## Runtime work

1. **CF-127** bootstrapped execution policy for existing Scholarship detail profiles.
2. **CF-128** ran five Charles Sturt first-party detail profiles and reconciled them against existing canonical Scholarships by Provider + exact detail URL.
3. **CF-129** onboarded missing first-party detail sources/profiles from verified acquisition-trace rows.
4. **CF-130** inherited the already-governed Provider acquisition routes from each Provider's qualified Scholarship catalogue profile into its first-party detail profiles. The first attempted wave correctly blocked with `no_eligible_provider_route`; routes were not bypassed.
5. **CF-131** reran the detail wave, reconciled exact Provider/title matches first, created new canonical roots only for identity-clear first-party details, retained all new roots as `unpublished`, linked Evidence/source records/traces, and materialised structured percentage/fixed-amount semantics.

## Targeted results

Successful first-party detail Evidence now covers:

- Australian National University — 2 verified detail records;
- Charles Sturt University — 5 verified detail records;
- Federation University Australia — Federation Pathways Scholarship plus prior Federation evidence;
- Monash University — International Merit and International Leadership;
- University of Melbourne — AG Whitlam, International Excellence (Undergraduate), International Pathway, and International Undergraduate;
- RMIT — prior evidence-backed validation rows remain retained.

For the selected validation Providers there are no remaining `first_party_verified` trace rows without Evidence.

## Financial semantics

Where the retained first-party detail text is explicit:

- `%` awards are stored as `award_value_type=percentage` plus `award_percentage`;
- `award_fee_basis=tuition_fee` is populated only when the Evidence explicitly says tuition;
- `$` awards are stored as `fixed_amount` with `AUD` where the source uses the Australian dollar symbol/context;
- ambiguous `fee` wording retains the percentage but does **not** invent a tuition basis.

Examples now structured include Charles Sturt 15/25/30/50%, Federation Pathways 10%, Monash Leadership 100%, and Melbourne 20% awards. Course-side saving/net-fee calculation remains fail-closed until the Scholarship fee basis, Course fee basis and year align.

## Dedupe / canonicalisation

- Existing Provider + normalised-title matches are reused first.
- Existing canonical records are promoted to the official first-party detail URL/Evidence rather than duplicated.
- New identity-clear records are created as canonical **unpublished** roots only.
- First-party detail URLs are retained as Scholarship identifiers.
- Discovery candidates matching acquired detail URLs move to `acquired`.
- No broad Provider-ownership assumption creates Course eligibility.

## Safety and publication boundary

- Layer 2 acquisition/extraction does not directly publish.
- Ambiguous Course/provider scope remains Layer 4 work.
- Raw/private pipeline schemas remain unavailable to browser consumers.
- Search, Website and Zoho projections remain unchanged.
- No canonical Course values are mutated by this change.

## Source reconciliation

Pilot source migrations:

- `20260904051000_cf_127_130_scholarship_detail_execution_bootstrap.sql`
- `20260904051100_cf_128_csu_detail_reconciliation.sql`
- `20260904051530_cf_131_verified_detail_to_canonical_unpublished.sql`

This change preserves the M2.4.5 boundary and does not advance M2.5/Production provisioning.
