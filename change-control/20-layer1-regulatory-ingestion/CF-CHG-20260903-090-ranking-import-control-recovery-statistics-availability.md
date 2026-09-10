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

## Corrective follow-up — 9 September 2026

User UAT on the recovered v2.15.74 baseline identified two QS-specific issues in Administration → Sources & Imports:

1. valid source revisions for the same QS edition were rendered as separate workflow rows, causing editions such as 2024 to appear more than once;
2. QS 2026 and 2027 remained in `needs_review` after historical parse attempts.

### Runtime diagnosis

The duplicate-year symptom was a read/presentation issue, not duplicate canonical ranking observations. `ranking.manual_imports` correctly retained multiple Evidence revisions for some editions, while `security.admin_ranking_imports_read` exposed every revision directly to the edition workflow.

The 2026/2027 failures were traced to legacy inline Evidence retention rather than ranking-semantic parsing:
- the retained 2026 inline payload is truncated and fails gzip checksum validation;
- the retained 2027 import has no recoverable inline XLSX payload.

Those source bytes are not reconstructed or manufactured.

A second acquisition defect was also identified: `ranking-qs-url-import` had direct-static completeness contracts only through edition 2025. Even when the governed QS static-indicator endpoint was available, editions 2026 and 2027 could not satisfy `completeStatic` and were forced to the Parse.bot fallback path.

### Corrective implementation

- `security.admin_ranking_imports_read` now returns one visible revision per `(ranking system, edition year)` for the Administration workflow while retaining all underlying `ranking.manual_imports` rows for audit/provenance.
- QS official static-indicator qualification now includes 2026 and 2027 using the governed current indicator set.
- `ranking-qs-url-import` runtime worker advanced to internal version `v1.1.0`; JWT verification remains enabled.
- No historical Evidence, import revisions, ranking observations, Search projection or consumer publication state was deleted or overwritten.

## Recovery reconciliation — 10 September 2026

Repository/runtime review identified that Pilot PR #59 merged before its Codex review completed. The later review found three material defects in the one-row-per-edition read contract: source selection used mutable processing `updated_at`; detected country scope was taken only from the selected revision; and `logical_revision_count` omitted lifecycle-rejected/superseded revisions.

The Pilot runtime has been corrected with `cf_ranking_import_history_codex_followup` plus `cf_ranking_import_history_file_scope_followup`. The function now:
- selects the visible source revision by immutable `uploaded_at` capture order with ID tie-breaker;
- aggregates detected scope across every retained source revision for the same system and edition;
- includes both `ranking_import_acquire` URL acquisition jobs and governed `layer1_ranking_etl` manual-file acquisition jobs when aggregating source scope;
- counts every retained source revision, including lifecycle-rejected rows;
- preserves the existing authentication, Pipeline Operator rank >= 4 and execute-grant boundaries.

Pilot PR #64 was reviewed by Codex. Its initial review found a P1 omission of manual-file acquisition jobs from scope aggregation; that defect was corrected in commit `297309654cc9ef3a9039c40ff27b010088e2d85e`, the Pilot Frontend Build run `34435716416` passed, and the corrected SQL was already active in Pilot runtime. PR #64 then merged to main as `faca58121fc67829d0993b694d85fc90e6fd1d23`. RLS task #60 remains separate and unchanged.

### QS 2026 recovery

The authorised `2026 QS World University Rankings 1.3 (For qs.com).xlsx` was independently hash-verified against the governed Evidence record and exact publisher workbook before recovery. SHA-256: `be3499826108e7c43faca9c426f2e911083574b4ff58aaebc7a401b663157c5d`.

The exact workbook was restored to private Evidence Storage and applied through `ranking-qs-official-etl`:
- 1,504 ranking observations parsed/applied;
- 15,040 indicator observations parsed/applied;
- 195 provider mappings resolved;
- 1,309 institutions remain unmapped;
- low-confidence mappings: 0;
- import status: `needs_review` / `awaiting_mapping` only because provider mapping review is still required.

This is an applied data recovery, not a parsing failure. No publisher value was manufactured.

### QS 2027 recovery

The authorised `2027 QS World University Rankings 1.3 (For qs.com).xlsx` supplied for recovery is valid and exactly matches the governed Evidence hash `f4d09f8099d676f270afa4f83aa23a073e99f31c0cc4d61da4884a20d554d706` at 311,633 bytes. It contains 1,504 ranking rows and the expected 15,040 indicator cells.

QS's currently discoverable public 2027 workbook is a different v1.1 revision, so it is not substituted for the governed v1.3 Evidence. The exact v1.3 binary still requires completion of the private Evidence transfer before ETL APPLY. No 2027 canonical ranking observations are claimed until that exact-byte gate passes.

A purpose-built JWT-protected `ranking-qs-upload-recovery` helper verifies the fixed import ID, exact byte count and SHA-256 before Storage restore and invokes the existing official ETL. Temporary recovery helpers must be retired after recovery closure.

A large inline-Evidence fallback transfer was tested but abandoned after chunk-integrity verification detected corruption risk. The incomplete fallback payload was cleared; no corrupt partial XLSX payload is retained. Recovery remains blocked specifically on transporting the exact local v1.3 binary into the private Evidence bucket through an available authenticated binary-upload path.

### Remaining gate

1. Complete exact-byte private Evidence transfer for QS 2027 and run official ETL APPLY.
2. Verify 1,504 ranking observations and 15,040 indicator observations, with any remaining `needs_review` state attributable only to provider mapping.
3. Retire temporary recovery Edge functions.
4. Reconcile M2.4.5 RUNSHEET / CURRENT-STATE / FOLLOW-UPS / NEXT-CHAT with the final recovery result.
5. Keep the separate stale QS 2027 operator-warning UI correction coordinated with the current application release candidate rather than colliding with parallel release/version work.