# CourseFinder PIM Admin Guide v1.3

**Status:** LIVING GOVERNANCE GUIDE — TAXONOMY SOURCE-LINEAGE UPDATE  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.2.md`  
**Change Control:** `CF-CHG-20260820-001`, `008`, `009`, `010`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`

All unchanged v1.0-v1.2 rules remain in force. v1.3 adds explicit taxonomy mapping-lineage guidance.

## Study Level

The canonical Course Study Level is a governed taxonomy value, not a replacement for the source vocabulary that produced it.

For regulatory audit, Admin must be able to show:

**source scheme + registration code + exact source value → mapping status → canonical Study Level → source/evidence**.

For Australian CRICOS Courses, when CRICOS supplies a populated Course Level, do not infer a different level from the Course title.

### Reference example — CRICOS 121174E

- source value: `Bachelor Degree`;
- mapping status: `mapped`;
- canonical code: `bachelor`;
- canonical label: `Bachelor`;
- source: CRICOS Providers, Courses and Locations;
- source snapshot, validity, observation time, verification and evidence retained.

`Bachelor` is the normalised taxonomy label. `Bachelor Degree` is still important audit vocabulary and must remain recoverable.

## Field of Study

The canonical Field of Study may be normalised to a governed taxonomy such as ASCED. Source code/name remain part of the mapping lineage.

Admin must be able to show:

**source Field code/name → canonical Field code/name → primary/status → source/evidence**.

Do not treat a Provider marketing study area or display category as identical to the canonical Field of Study without a governed mapping.

### Reference example — CRICOS 121174E

- source Field code: `0201`;
- source Field name: `Computer Science`;
- canonical code: `asced-0201`;
- canonical label: `Computer Science`;
- primary observation: true;
- source/evidence: CRICOS regulatory snapshot.

Even when source and canonical labels happen to be textually identical, the mapping relationship is still meaningful because the canonical taxonomy identity is governed separately from raw source vocabulary.

## Admin presentation

Course decision grids may continue to show concise canonical Study Level / Field labels.

Course detail should provide a compact **Taxonomy & source mapping** audit section containing:

- canonical Study Level;
- exact source Course Level vocabulary;
- mapping status;
- canonical Field of Study;
- source Field code/name;
- source/evidence/verification context.

Do not require administrators to infer mapping lineage from table names or raw database joins.

## Consumer semantics

Normal consumer payloads should expose canonical taxonomy code/label. Original source vocabulary/code can be included as audit metadata where useful, but must not replace the canonical taxonomy identity.

Consumer-facing labels must not imply a source term and canonical taxonomy term are interchangeable merely because their display text is similar.
