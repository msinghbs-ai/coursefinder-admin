# CF-CHG-20260902-063 — QS / THE World University Ranking Layer 1 Context

**Status:** SCHEMA / READ FOUNDATION IMPLEMENTED — DATA INGESTION PENDING  
**Initiated:** 2026-09-02 05:29 Australia/Melbourne  
**Primary category:** 10 — Architecture / Data Model  
**Related:** Layer 1 authoritative ingestion; Admin/PIM; Search/API consumers; M2.5

## Request

Add QS World University Rankings 2026/2027 and Times Higher Education World University Rankings 2026, with 5–10 years of historical editions where official publisher access and reuse terms permit.

## Decision

Ranking publisher data is modelled as Layer 1 **authoritative external institutional context**, while CRICOS/NZQA/etc remain Layer 1 regulatory identity authorities.

Do not add scalar `qs_rank` or `the_rank` columns to Provider. Use editioned, source-versioned observations with separate canonical Provider mapping.

## Source authority

Publisher sources:
- QS: https://www.topuniversities.com/world-university-rankings and year-specific `/world-university-rankings/{YEAR}`.
- THE: https://www.timeshighereducation.com/world-university-rankings/latest/world-ranking and year-specific `/world-university-rankings/{YEAR}/world-ranking`.

Official publisher downloadable artifacts are preferred when accessible under acceptable terms.

## Schema direction

Introduce a ranking domain with:
- ranking systems;
- ranking editions/source versions;
- publisher institutions/crosswalk;
- ranking observations;
- typed ranking indicators;
- canonical Provider mappings;
- immutable Evidence linkage.

Exact, tied and banded ranks are distinct semantics.

## Historical rule

Backfill 5–10 years opportunistically from official publisher editions. Preserve methodology version/breaks and do not imply longitudinal comparability across methodology changes.

## UI direction

Provider detail and Compare expose QS and THE separately. Course detail may only show inherited **Provider ranking** context.

## Security / publication

Private ingestion/source tables remain server-side. Search/Website/Zoho exposure requires an explicit downstream acceptance decision. Ranking cannot silently alter regulatory status or Search relevance.

## Implementation refs

Pending. No schema migration, data acquisition, Production enablement or consumer publication is claimed by this design record.

## Rollback

Documentation/design addition can be reverted without runtime impact. Any later schema/data apply must define its own migration rollback/reconciliation procedure.

## Acceptance status

DESIGN ACCEPTED. Implementation and source/licensing qualification remain open under M2.5 follow-ups.


## Implementation checkpoint

Pilot now contains the private `ranking` schema with:
- systems;
- editions;
- publisher institutions;
- Provider mappings;
- observations;
- indicator observations;
- manual imports.

Secure helper/read functions are wired through the existing Admin gateway and ranking context is attached to Provider detail, Course Provider-context detail and Compare.

The manual publisher-file registration path is operational via `ranking-publisher-import` v1 and the existing private Evidence bucket.

Not yet complete:
- QS 2026/2027 parser/load;
- THE 2026 parser/load;
- historical edition parser/load;
- Provider crosswalk reconciliation;
- accepted ranking observations.

Therefore this Change Control remains open for data ingestion and acceptance.
