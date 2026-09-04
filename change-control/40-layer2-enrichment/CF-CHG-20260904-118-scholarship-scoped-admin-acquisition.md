# CF-CHG-20260904-118 — Scholarship Scoped Admin Acquisition

**Status:** IMPLEMENTED / TARGETED PASS  
**Milestone:** M2.4.5

## Change
The existing Layer 2 Admin scope control now applies to Scholarship acquisition as well as Course enrichment. Supported Scholarship scopes are country, state and individual university/provider.

A scoped start creates private Scholarship acquisition requests and ordinary `pipeline.jobs` rows so execution is visible in Recent Jobs. It does not authorise canonical mutation or publication.

## Controls
- Pipeline Operator rank or higher is required.
- State membership resolves from canonical Provider subdivision and campuses.
- First-party university catalogue authority is retained.
- Search/Website/Zoho publication is unchanged.
- Private request state remains RLS protected.