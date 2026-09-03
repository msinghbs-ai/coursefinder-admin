# CF-CHG-20260903-100 — Multi-country Same-edition Statistical & Ranking Ingestion Strategy

**Status:** APPLIED — DESIGN / GOVERNANCE PASS  
**Initiated:** 2026-09-03 18:58 AEST  
**Origin chat/workstream:** 01-CourseFinder PIM Principles / M2.4.5 H12-H13 continuation  
**Owner:** CourseFinder programme governance  
**Primary category:** 10-architecture-data-model  
**Related:** CF-063, CF-067, CF-077, CF-098, CF-099  
**Runtime mutation:** NONE

## Trigger

User asked how CourseFinder will ingest additional countries for the same statistical/ranking year later without duplicating or overwriting data.

## Decision

For global datasets such as QS, THE and ARWU:

`system + edition/year` is the logical dataset edition.

Country is an observation/reconciliation scope, not part of the edition identity.

This allows AU/NZ to be loaded first and CA/GB/US/IE to be added later under the same edition while retaining independent Evidence and mapping outcomes.

For country-native government/statistical datasets, each authoritative national family remains separate under a shared semantic/UI grouping unless an explicit cross-country metric crosswalk is accepted.

## Operational contract

Later-country ingestion into an existing year must:

- reuse the existing edition;
- register new country/global Evidence as an additional revision/bundle;
- detect/validate country scope;
- reconcile only against canonical Providers in that country where name-based mapping is involved;
- produce net-new/changed/duplicate/unmatched/ambiguous counts;
- keep manual Apply;
- preserve all prior-country accepted observations and Evidence;
- never infer a missing row as rank 0/unranked/deleted.

## UX contract

Edition coverage must show per-country scope and distinguish:
- Partial;
- complete for selected country/countries;
- publisher/global complete.

The UI should offer **Add country data** rather than encouraging a duplicate year/edition.

## UAT strategy

Permanent/targeted tests should include:
- create an edition from AU+NZ bundle;
- later add CA to the same edition;
- assert edition count remains one;
- assert AU/NZ rows unchanged;
- assert CA rows add only CA scope;
- duplicate CA replay = idempotent;
- corrected CA revision changes only accepted CA rows after manual Apply;
- same-name institution in another country cannot cross-map;
- cross-country QS/THE/ARWU comparison aligns on the same edition.

## Documentation

- supersede University Ranking Data Design v1.0 with v1.1;
- update current-doc router;
- update M2.4.5 ledger/state.

## Rollback

Revert documentation/governance commits. No database/runtime rollback is required.

