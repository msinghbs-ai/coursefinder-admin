# CourseFinder Database Architecture v2.10.46

**Status:** CURRENT ADDITIVE M2.5 ARCHITECTURE  
**Date:** 2 September 2026  
**Supersedes:** v2.10.45; all unchanged accepted architecture remains authoritative.  
**Change Control:** `CF-CHG-20260902-063`

## University ranking domain

Add a new private `ranking` domain for publisher-authoritative institutional ranking context.

Core logical entities:
- `ranking.systems`;
- `ranking.editions`;
- `ranking.publisher_institutions`;
- `ranking.provider_mappings`;
- `ranking.observations`;
- `ranking.indicator_observations`.

The model is additive and does not replace Provider identity, regulatory registrations, QILT, PRISMS or Scholarship domains.

## Source / identity rule

A QS/THE row first retains publisher institution identity. Canonical `catalogue.providers` mapping is separate, governed and nullable.

Ranking ingestion must not create or merge canonical Providers merely because a publisher row exists.

## Temporal/source rule

Rankings are editioned observations. Source corrections/revisions and methodology versions are retained.

Exact, tied and banded ranks must remain distinguishable. Reporter/unranked/missing states are not numeric rank zero.

## Evidence

Ranking source pages/files use the existing governed Evidence/artifact model. Source fingerprint, retrieved time and licensing/access assessment are retained with the edition/source version.

## Consumer boundary

Private ranking tables are not exposed directly to anonymous consumers. Secured projections may later expose accepted Provider-level latest/history context after a separate Search/API admission gate.

## Production boundary

This architecture revision is DESIGN authority only for the ranking domain. It does not claim a deployed migration, populated ranking data, Production source enablement or Search/Zoho/Website admission.
