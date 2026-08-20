# CF-CHG-20260820-003 — QUT Course Facts Acquisition Deferred

**Status:** DEFERRED  
**Category:** 40-layer2-enrichment  
**Initiated:** 20 August 2026  
**Origin chat/workstream:** M1-L2-AU-COURSE-FACTS — AU First-Party Course Enrichment  
**Owner:** CourseFinder Layer 2 enrichment workstream  
**Change class:** ingestion / operations / governance

## Trigger

Qualification of a third authoritative Provider-owned AU Course Facts source class after RMIT and UQ acceptance.

## Problem / requested outcome

QUT official Course pages are semantically suitable and expose exact CRICOS Course identity plus Provider-current fee/intake/English facts, but production acquisition must succeed from the accepted Supabase runtime before any fact can be applied.

## Affected surfaces / related workstreams

- `coursefacts-au-qut`
- `integration.systems`
- `pipeline.sources`
- `pipeline.course_fact_source_qualifications`
- Pilot nonce allowlist
- Layer 2 source acquisition governance

## Semantic impact

**No canonical semantic change.**

No QUT Course Facts were admitted. The change records a source-specific operational acquisition blocker and disables APPLY for this source.

## Before

QUT was not represented as a governed Course Facts source candidate.

## After

QUT source identity is registered but qualification is `deferred`:

- Provider CRICOS: `00213J`
- source key: `au_qut_official_course_pages`
- worker: `coursefacts-au-qut-v0.1.1`
- APPLY admitted: false
- Search admitted: false
- accepted QUT canonical Course Facts: 0

## Source authority / evidence

Bounded canonical Course identities:

- `083019B` — Bachelor of Business - International
- `017323G` — Bachelor of Information Technology (Honours)

The public QUT Course pages were verified as authoritative source candidates. Production runtime fetch attempts returned HTTP 403.

## Implementation references

- source migration: `20260820004729_m1_l2_au_coursefacts_qut_source_v1`
- deferral migration: `20260820004902_m1_l2_au_coursefacts_qut_defer_v1`
- worker: `coursefacts-au-qut-v0.1.1`
- Edge Function version: 2
- deployment SHA-256: `87a6734145c26c1727c777ab1c57d7bb8dd488756036b4aa27f1f1eb015d82fb`
- Pilot UAT: `docs/m1-l2-au-course-facts-qut-deferred-uat-2026-08-20.md`
- UI version: N/A

## UAT

- exact canonical CRICOS preflight: PASS
- runtime dry-run `1909`: FAIL CLOSED / HTTP 403
- browser-equivalent retry `1910`: FAIL CLOSED / HTTP 403
- APPLY performed: no
- canonical QUT Layer 2 facts created: 0
- bypass/challenge circumvention attempted: no
- Search admission: no

## Rollback / reversion

No canonical data rollback is required. The source registration can remain as deferred operational evidence. If removed, delete only the QUT source qualification/source-system records after confirming no downstream references.

## Documentation impact

- Architecture: unchanged; existing source qualification contract already covers deferred acquisition
- Running build: update current snapshot
- Master plan: record QUT as source-specific deferred candidate, not programme blocker
- Pilot UAT: added
- Search/Zoho/PIM: no contract change

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 20 Aug 2026 | BOUNDED | QUT source pre-staged for independent source-class UAT | source migration |
| 20 Aug 2026 | DEFERRED | Two production runtime fetch attempts returned HTTP 403; APPLY disabled | requests 1909 / 1910 |

## Closure

**Final status:** DEFERRED  
**Closed at:** N/A  
**Outcome:** QUT is semantically suitable but production-fetch blocked. It does not block continued AU Course Facts expansion through other authoritative sources.
