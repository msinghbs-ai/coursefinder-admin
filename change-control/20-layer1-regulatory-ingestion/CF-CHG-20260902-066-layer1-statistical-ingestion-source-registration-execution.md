# CF-CHG-20260902-066 — Layer 1 Statistical Ingestion Source Registration & Execution

**Status:** IMPLEMENTED / TARGETED VALIDATION IN PROGRESS  
**Initiated:** 2 September 2026, 10:02 AEST  
**Origin:** User correction after CF-065 Layer 1 v2 review  
**Owner:** CourseFinder programme  
**Primary category:** 20-layer1-regulatory-ingestion  
**Related categories:** 30-admin-pim-ux, 40-layer2-enrichment  
**UI version:** v2.15.25

## Problem

CF-065 made Layer 1 capable of displaying regulatory and statistical ingestion cards, but the governed `layer1_source_operations` registry still contained only AU CRICOS and NZ NZQA. Therefore the Statistics filter had no QILT/PRISMS sources to show or run.

The underlying QILT and PRISMS ETLs and accepted observations already existed; the missing component was governed Layer 1 operational registration and execution routing.

## Requested outcome

Australia Layer 1 must show the existing governed statistical ingestion sources as normal runnable dataset cards, rather than presenting an empty Statistics filter.

## Implemented sources

AU Statistics now registers:
- QILT GOS 2025 National Report Tables;
- QILT SES 2024 National Report Tables;
- QILT GOS-L 2025 National Report Tables;
- QILT ESS 2025 National Report Tables;
- Department of Education PRISMS SA4 December 2025.

AU CRICOS remains a Regulatory source. NZQA remains a Regulatory source.

QS/THE are not falsely exposed as automated runnable sources: their current accepted path remains ranking-source onboarding/manual publisher import until the automated ingestion adapters are accepted.

## Semantic boundary

This is an **operational-control placement change**, not a reclassification of statistical authority.

QILT and PRISMS retain:
- existing structured statistical observation grain;
- `identity_authority=false`;
- no Provider/Course identity creation/redefinition;
- no Search/Publication authority;
- existing Evidence-backed ETL semantics.

Their historical metadata may retain Layer 2A lineage. Layer 1 v2 is the operational ingestion surface from which authoritative/regulatory and governed statistical datasets can be run.

## Runtime implementation

Migration:
`20260902001800_cf_066_layer1_statistical_ingestion_sources.sql`

It:
- marks existing QILT/PRISMS source records as `dataset_class=statistics`;
- registers their existing source IDs into `pipeline.layer1_source_operations`;
- establishes authority domains/formats and observation-count expectations;
- seeds initial operations versions;
- preserves the existing source/Evidence rows rather than duplicating them.

Observed registered baseline after migration:
- QILT ESS: 228 observations;
- QILT GOS: 593;
- QILT GOS-L: 235;
- QILT SES: 977;
- PRISMS: 2,270;
- plus AU CRICOS and NZ NZQA.

## Execution routing

`layer1-operations-control` v1.1.0 now detects source system from governed source metadata:
- QILT → existing `qilt-au-etl`;
- PRISMS → existing `prisms-au-etl`;
- AU CRICOS / NZ NZQA preserve their existing Layer 1 paths.

QILT and PRISMS workers now accept either:
- their existing one-time Pilot nonce; or
- a service-role-only internal Layer 1 execution header sent exclusively by the Layer 1 control function.

The service key is never exposed to the browser.

Deployed Pilot Edge versions:
- `qilt-au-etl` v8 / source v0.2.5;
- `prisms-au-etl` v2 / source v0.1.1;
- `layer1-operations-control` v3 / source v1.1.0.

## Operator UX

With Country = Australia:
- Dataset = All shows CRICOS + five statistical sources;
- Dataset = Statistics shows the five QILT/PRISMS cards;
- each statistical source has status, observation count, Evidence, last/next run, Details and **Run now**;
- Run now uses the existing governed queue/progress model.

No source URL/parser detail returns to the routine Layer 1 screen.

## Validation

Permanent Layer 1 deployed UAT has been extended to prove:
- Statistics filter returns exactly the five registered AU statistical sources;
- each source is presented as Statistics and is runnable;
- real QILT GOS dry-run validation succeeds;
- real PRISMS dry-run validation succeeds;
- existing NZQA, CRICOS and anonymous-boundary tests remain intact.

Candidate validation is running against Coursefinder-Pilot main after v2.15.25 release alignment.

## Rollback

- revert CF-066 source/function changes;
- remove only the five CF-066 `layer1_source_operations` registrations if rollback is required;
- retain all pre-existing QILT/PRISMS source, Evidence and statistical observation history;
- do not delete QILT/PRISMS source data.

## Production boundary

Pilot only. No Production enablement, broad Publication, Search admission or Zoho Production cutover is authorised.
