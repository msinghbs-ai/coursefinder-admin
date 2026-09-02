# CF-CHG-20260902-077 — Statistical Provider Equivalence Fan-out

**Status:** IMPLEMENTED / TARGETED DATA CONTRACT PASS  
**Initiated:** 2 September 2026  
**Origin:** User decision: statistical/ranking data may fan out across duplicate Provider records when CRICOS identity or university name is the same  
**Primary category:** 20-layer1-regulatory-ingestion  
**Related categories:** 40-layer2-enrichment, 30-admin-pim-ux

## Decision

For **non-identity data** such as rankings, QILT/provider statistics and future Provider-scoped statistical datasets, duplicate canonical Provider records are no longer treated as a blocking ambiguity when the records are demonstrably equivalent by either:

1. the same current Provider identifier (including CRICOS-style identifiers); or
2. the same exact normalised Provider/university name within the same country.

The statistical observation may be associated with every equivalent Provider record.

This is a **fan-out exception**, not an identity merge.

## Guardrails

The exception does **not**:
- merge Provider records;
- rewrite Provider identity;
- treat fuzzy/similar names as equal;
- bridge providers across countries;
- infer equivalence from ranking order, website similarity or semantic similarity;
- change CRICOS/Layer 1 identity authority.

Ambiguity that is not exact-name/same-identifier remains reviewable/unmapped.

## Runtime implementation

New reusable service contract:
- `public.svc_statistical_equivalent_provider_ids(provider_id)`

It returns same-country canonical Provider IDs sharing an exact normalised Provider name and/or current identifier.

Ranking:
- `ranking.observation_provider_links` stores one source ranking observation linked to all equivalent canonical Provider records;
- the existing ranking observation is retained once rather than inventing duplicate publisher observations;
- Provider-specific ranking reads recognise the bridge links;
- reconciliation preview classifies exact duplicate names as `equivalent_exact_name_fanout` rather than `exact_ambiguous`;
- APPLY reports `equivalent_provider_fanout_links`.

QILT:
- exact duplicate canonical names are accepted as `exact_equivalent_provider_fanout`;
- normalised aliases only fan out when all candidates resolve to the same exact canonical Provider name;
- statistical observations are written for each equivalent Provider ID;
- mapping metadata records the equivalent Provider IDs/stable keys and `statistical_equivalence_fanout=true`.

PRISMS currently has no Provider dimension in the accepted SA4 dataset, so there is nothing to fan out there. The reusable equivalence function is available to future Provider-scoped statistical adapters.

## Proof

Pilot data proof for **Victoria University**:
- two existing AU canonical Provider records;
- exact same canonical/display name;
- different CRICOS-derived stable keys;
- `svc_statistical_equivalent_provider_ids` returns both Provider IDs;
- ranking reconciliation preview now reports:
  - mapped rate: 100%;
  - equivalent fan-out: 1;
  - exact ambiguous: 0;
  - unmatched: 0.

This means the THE 2015 Victoria University row can be associated with both existing Provider records without choosing one arbitrarily or merging them.

## Production boundary

Pilot only. This policy applies to contextual/statistical data association, not canonical Provider identity governance.
