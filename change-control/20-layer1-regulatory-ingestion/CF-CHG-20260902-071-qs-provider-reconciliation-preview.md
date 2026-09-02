# CF-CHG-20260902-071 — QS 2026 Provider Reconciliation Preview

**Status:** IMPLEMENTED / TARGETED UAT ACTIVE  
**Initiated:** 2 September 2026 Australia/Melbourne  
**Primary category:** 20 — Layer 1 Regulatory / Authoritative Ingestion  
**Related:** CF-063, CF-064, CF-067, CF-068, A29

## Purpose

Measure QS 2026 Australian Provider reconciliation quality from the retained 1,501-row publisher JSON snapshot without writing ranking observations or Provider mappings.

## Change

- Added service-only `public.svc_ranking_reconciliation_preview(jsonb,text)`.
- The function is `SECURITY DEFINER`, executable only by `service_role`; PUBLIC/anon/authenticated are revoked.
- It performs read-only exact Provider name + country matching against canonical `catalogue.providers`.
- It reports Australian source rows, unique exact matches, ambiguous exact matches, unmatched rows, exact-match rate, and bounded unmatched/ambiguous samples.
- `ranking-layer1-etl` v1.2.0 calls the preview during QS dry-run.
- `layer1-operations-control` v1.2.3 exposes the preview inside governed validation output.
- No `ranking.publisher_institutions`, `ranking.provider_mappings`, `ranking.editions` or `ranking.observations` rows are created by this preview.

## Safety boundary

Direct QS JSON APPLY remains disabled. This change does not grant publication/Search/Website/Zoho authority and does not alter Provider identity.

## Acceptance

- QS 2026 remains exactly 1,501 candidate observations.
- AU reconciliation preview returns >30 Australian rows.
- Unique exact matches >20.
- Ambiguous exact matches = 0.
- `ranking.observations` remains 0.
- security advisor remains 0 WARN / 0 ERROR.
- deployed targeted UAT must pass.