# CourseFinder Master Project Plan v1.50

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.49.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.54.md`

## Current programme position

The accepted AU Layer 1, Layer 2, Search-isolation and existing Admin/PIM-hardening baselines remain unchanged.

Current `M1-PIM-GOV` semantic gates:

| Change | State |
|---|---|
| `CF-CHG-001` Fee semantics | Technical/frontend source PASS through v2.9; deployed browser UAT pending |
| `CF-CHG-005` QILT/PRISMS | Technical/frontend source PASS through v2.9; deployed browser UAT pending |
| `CF-CHG-006` Evidence provenance | Technical/frontend source PASS through v2.9; deployed browser UAT pending |
| `CF-CHG-007` Catalogue paging/exact identity | Technical/frontend source PASS through v2.9; deployed browser UAT pending |
| `CF-CHG-008` Provider/Course/Campus geography | Technical/frontend source PASS through v2.9; deployed browser UAT pending |
| `CF-CHG-009` Intake/English | Technical/frontend source PASS through v2.9; deployed browser UAT pending |
| `CF-CHG-010` Taxonomy lineage | Technical/frontend source PASS through v2.9; deployed browser UAT pending |
| `CF-CHG-011` Scholarship compound semantics | Technical/frontend source PASS through v2.9; deployed browser UAT pending |
| `CF-CHG-012` Course lifecycle/publication/readiness/Search state | DB/RPC/security + frontend source PASS in v2.9; deployed browser UAT pending |

## State-model decision

CourseFinder will not use one generic Course `Status` to represent multiple authorities.

The governed state classes are:

1. canonical lifecycle;
2. canonical publication;
3. Admin canonical-presence readiness;
4. per-channel publication state;
5. Search projection presence/publication;
6. Search enrichment admission.

These states may legitimately differ at the same time.

## Live operational defect resolved

The state audit found that the governed Course page could not execute because the Search-state wrapper referenced nonexistent `search.course_documents.status`.

Migration 066 corrects the live read path to `publication_status` and exposes explicitly Search-prefixed projection state.

No canonical/Search data rewrite was required.

## Course-detail state contract

Migrations 067–068 expose the state model through the governed Course-detail read.

The summary includes:

- canonical lifecycle/publication;
- six-signal Admin readiness;
- canonical Scholarship relationship presence outside the readiness score;
- consumer-channel state/absence;
- Search projected/publication/admission state;
- Search projection version/generation/freshness metadata.

The `canonical_presence.scholarship` correction prevents the frontend from inferring canonical Scholarship presence from a field that was not part of Course detail.

## Reference mixed states

### CRICOS 121174E

- active;
- canonical unpublished;
- Admin readiness 50%;
- no channel publication record;
- Search projected;
- Search unpublished;
- canonical fee present;
- Search fee not admitted.

### CRICOS 102784C

- active;
- canonical unpublished;
- Admin readiness 83.33%;
- canonical registration/structure/fee/intake/English present except description;
- no channel publication record;
- Search projected/unpublished;
- Search Fee/Intake/English not admitted;
- Search projection `course-v2`, generation 12.

These are valid states, not data contradictions.

## PIM Admin v2.9.0

### Course grid

- **Admin readiness** replaces ambiguous `Complete`;
- Lifecycle remains independent;
- **Canonical publication** is a separate field;
- **Search** is a separate projected/publication field.

### Course detail

The `State & publication` panel displays and explains all state classes and canonical-vs-Search enrichment admission.

This preserves the v2.8 Scholarship semantics and all earlier v2.7 Course-detail semantics.

## Governance contracts

Current:

- PIM Admin Guide v1.5;
- Zoho Consumer Contract v1.3;
- State-model v2.9 UAT;
- Change Control register through `CF-CHG-012`.

Zoho v1.3 explicitly prevents a generic multi-authority `Status` field. Admin readiness and Search projection state default to internal diagnostics unless an explicit integration-monitoring use case admits them.

## Consumer boundary

Search projection and Search publication are not Website/Zoho publication authority.

Admin readiness does not grant publication.

Empty `publishing.entity_states` means no channel state recorded.

Canonical enrichment must be consumed through its curated canonical contract, not inferred from Search admission flags.

## Preserved programme baselines

- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- AU Course Facts: RMIT + UQ / 10 bounded Courses;
- QUT: deferred/source-specific HTTP 403;
- QILT/PRISMS/Scholarship accepted state unchanged;
- Search Course Documents: 33,105;
- Fee/Intake/English/Scholarship Search enrichment admitted: 0;
- vector Search remains rejected/not admitted.

## Remaining acceptance boundary

The current environment cannot independently observe the Cloudflare runtime. Source publication is not deployment proof. Open PIM semantic Change Controls close only after their deployed authenticated browser acceptance criteria pass.

## Next M1-PIM-GOV work

1. final branch/main reconciliation and non-force publication of PIM Admin v2.9.0;
2. deployed browser UAT when runtime observation becomes available;
3. continue audit of Review Queue, source/operations and PIM Attribute semantics/security surfaces;
4. continue curated Zoho contract without automatically admitting internal operational fields;
5. create new Change Control only where a material semantic/security defect is proven.

Database Architecture remains v2.10.37 because no canonical relational model changed.
