# CF-CHG-20260903-100 — Multi-country Same-edition Statistical & Ranking Ingestion Strategy

**Status:** IMPLEMENTED / TARGETED VERIFICATION ACTIVE  
**Initiated:** 2026-09-03 18:58 AEST  
**Origin chat/workstream:** 01-CourseFinder PIM Principles / M2.4.5 H12-H13 continuation  
**Owner:** CourseFinder programme governance  
**Primary category:** 10-architecture-data-model  
**Related:** CF-063, CF-067, CF-077, CF-098, CF-099  
**Runtime mutation:** Pilot secured read + Admin UI v2.15.56

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



## Implementation advance — 2026-09-03 19:05 AEST

Implemented in Pilot:
- secured ranking import read now exposes per-import `detected_scope` and `logical_revision_count`;
- Administration release v2.15.56 distinguishes all-new country scope from overlapping/mixed scope;
- all-new country scope uses **Add country data & parse** without the old generic replacement warning;
- overlapping/mixed scope remains a governed source revision and requires explicit continuation;
- import history shows country scope and logical revision count;
- Apply remains manual; no Search/Publication authority changed;
- physical source-version rows remain provenance records while the logical operator edition is system + year.

Pilot source commits:
- `b3980cec000042549efba54bbd65d2de0d0550f9`;
- `f304b46530827152904fe99b9c6fa59d1af35bf8`;
- `f2d787df69605590bb7871b5882b1e344907aa25`;
- `7b41e246f869654ded7028e8b118db9b73b95078`;
- `5140ac5b2c557aeff8a89be7eb43d5a37cbfda78`;
- UAT routing `46ccc13fc5f7aa4189da0d067c641cc76592aced`.

Runtime:
- CF-100 secured read migration applied successfully to Pilot;
- function definition confirms detected-scope/revision fields;
- ACL remains authenticated + service_role only, anon/public revoked;
- Security/Performance advisor posture introduced no new WARN/ERROR finding attributable to CF-100.

Validation:
- frontend build compile job `100589327628`: PASS;
- full frontend build workflow `33736846482`: browser-smoke active at record time;
- targeted deployed UAT workflow `33736846609`: active at record time.
