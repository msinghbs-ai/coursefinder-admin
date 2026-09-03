# CF-CHG-20260903-090 — Ranking Import Control Recovery & Statistics Availability

**Status:** IMPLEMENTED / TARGETED UAT ACTIVE  
**Initiated:** 3 September 2026 11:58 AEST  
**Primary category:** 20 — Layer 1 Regulatory / Authoritative Ingestion  
**Affected surfaces:** Administration → Sources & Imports; Statistics & Rankings; private ranking Evidence; Edge/API service boundary  
**Related:** CF-067, CF-074, CF-075, CF-076, CF-077, CF-087

## User-reported defect

After uploading native THE 2026 JSON in a `.txt` file, the Admin showed an object-style error and QS/THE remained grey/unavailable in Statistics & Rankings.

## Runtime diagnosis

The upload itself succeeded:
- import ID `8f104e87-3347-45cd-aac3-6b047d6a1b28`;
- file `THE_year2026.txt`;
- 3,966,028 bytes;
- MIME `text/plain`;
- SHA-256 `00fdcfa0a2d5067982c9b7631e5baa7dc64e683c0c0280a1a02730edb45112fa`;
- private Evidence ID `cd5425cf-e5ee-4f98-98f6-a545ae0c03dc`;
- import status remained `uploaded`.

Immediately after registration the browser called `ranking-publisher-control`; live Edge logs show HTTP **404** at 3 Sep 2026 11:43 AEST.

Root cause: `ranking-publisher-control` attempted direct PostgREST access to the private `ranking` schema using `svc.schema("ranking").from(...)`. The ranking schema is intentionally not exposed through the Data API. The correct boundary is service-only RPC, not exposing the private schema.

Statistics & Rankings was grey because its QS/THE cards were disabled when `accepted_editions=0`. Since Parse & validate failed, THE never advanced from uploaded to validated/applied and therefore had no accepted observations.

## Correction

### Service boundary
Added service-only RPCs:
- `public.svc_ranking_import_control_context(uuid)`;
- `public.svc_ranking_import_validation_update(uuid,text,jsonb,jsonb)`.

PUBLIC/anon/authenticated EXECUTE is revoked; service_role only.

`ranking-publisher-control` now:
- reads import/system context through the service RPC;
- writes validation state through the service RPC;
- never requires exposing the private ranking schema.

### Error rendering
`src/lib/supabase.js` now normalises object-shaped Edge errors into readable error text instead of surfacing `[object Object]`.

### Statistics availability semantics
QS and THE are no longer disabled/grey solely because no edition has been applied.
- With accepted observations: Compare + Manage imports.
- Without accepted observations: active card showing `Source configured · no accepted edition applied yet.` + Manage imports.
- Compare ranking toggles remain unavailable until accepted ranking observations exist.

Visible Admin version: **v2.15.47**.

## Recovery gate

Permanent deployed test:
`tests/uat/cf-090-ranking-import-recovery-deployed.spec.mjs`

The test uses the already-uploaded `THE_year2026.txt` Evidence, runs Parse & validate, applies the edition after successful validation, and proves the Statistics & Rankings THE card becomes data-backed.

## Safety

- no `ranking` schema exposure added;
- no anonymous/authenticated write access added;
- uploaded Evidence is reused in place;
- no Search/Website/Zoho ranking publication authority changes;
- QS direct publisher JSON APPLY remains governed separately; a QS card being actionable does not imply accepted QS observations.
