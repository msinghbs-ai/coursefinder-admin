# CF-CHG-20260904-112 — Scholarship Provider Stats Operations Read

**Status:** IMPLEMENTED / TARGETED PASS
**Milestone:** M2.4.5
**Area:** Layer 2 / Scholarships / Admin PIM

## Change
The existing guarded `public.scholarship_operations_read()` contract now returns `provider_stats` and `provider_stats_summary` sourced from the private `pipeline.scholarship_provider_stats` view.

## Security and governance
- Existing authenticated `pipeline_operator` rank guard is retained.
- No direct `anon` or `authenticated` grant is added to the private stats view.
- Landscape observations remain private completeness signals only.
- First-party university evidence remains the authority for Scholarship facts.
- No Search, Website or Zoho publication state is changed.

## Outcome
Admin/PIM can obtain a quick provider-by-provider Scholarship completion summary through the existing operations boundary without creating a second browser-facing data contract.
