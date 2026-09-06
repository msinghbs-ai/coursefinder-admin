# CF-CHG-20260907-231 — Ranking Edition Completeness & Runtime Reconciliation

**Status:** ACTIVE / QS EVIDENCE RE-REGISTRATION REQUIRED  
**Initiated:** 2026-09-07 AEST  
**Category:** 20-layer1-regulatory-ingestion  
**Milestone:** M2.4.5 — H12/H13  
**Depends on:** CF-CHG-20260907-230 CLOSED / TARGETED PASS

## Objective

Complete the QS/THE ranking editions already retained in Pilot Evidence and make Statistics/Compare consume only accepted, traceable Layer 1 ranking editions.

CF-230 is not reopened. Parse.bot remains excluded from ranking acquisition.

## Runtime truth — 7 September 2026

### Accepted ranking editions

QS World University Rankings:

- 2025 — accepted; 1,503 observations; 65 primary Provider mappings; 13,527 indicator rows; 9 canonical indicator codes.
- 2024 — accepted; 1,498 observations; 66 primary Provider mappings; 13,482 indicator rows; 9 canonical indicator codes.
- 2023 — accepted; 1,422 observations; 66 primary Provider mappings; 11,376 indicator rows; 8 indicator codes.
- 2022 — accepted; 1,300 observations; 64 primary Provider mappings; 7,800 indicator rows; 6 indicator codes.
- 2021 — accepted; 1,184 observations; 59 primary Provider mappings; 7,104 indicator rows; 6 indicator codes.

Times Higher Education:

- 2026 — accepted; 3,118 observations; 71 primary Provider mappings; 18,708 indicator rows; 6 retained indicator codes.
- 2025 — accepted; 2,855 observations; 71 primary Provider mappings; 17,130 indicator rows; 6 retained indicator codes.
- 2015 — accepted; 1,526 observations; 68 primary Provider mappings; 9,156 indicator rows; 6 retained indicator codes.

### Registered imports not yet accepted

QS:

- 2027 — `needs_review`; import metadata identifies the official QS XLSX and 1,504 candidate observations, but the historical `inline://` pointer has no retained inline payload in the current Evidence artifact.
- 2026 — `needs_review`; the original import used an `inline://` Evidence bridge. The retained `cf212_stage_1` value is only 9,459 decoded bytes while the Evidence record declares a 337,667-byte workbook. It begins with a gzip header but is truncated/corrupt and fails checksum validation. The authorised publisher XLSX must therefore be re-registered; the worker must not attempt to manufacture or reconstruct missing bytes.

THE:

- 2024, 2023, 2022, 2021, 2020, 2019, 2018, 2017 and 2016 are already `validated` and retain candidate counts/reconciliation previews.
- Existing THE validation previews report 100% mapped rate within the governed AU reconciliation scope for those retained files, with equivalent Provider fan-out retained where applicable.
- These editions are not yet applied and therefore are not available as accepted ranking editions to Statistics/Compare.

## QS 2026 corrective diagnosis — 7 September 2026

The opaque `{}` failure has been resolved diagnostically.

Root cause:

1. QS 2026/2027 manual-import records used `inline://ranking/...` paths.
2. `ranking-qs-official-etl` v1.2.0 assumed every ranking Evidence path was a Storage object and attempted `storage.download()`.
3. CF-231 migration `20260906205708_cf231_qs_inline_evidence_context` extended the existing service-role-only `svc_ranking_import_control_context` to expose retained inline payload data without granting direct client access to `pipeline`.
4. `ranking-qs-official-etl` v1.3.0 now supports retained gzip/base64 inline Evidence and emits structured actionable errors instead of `{}`.
5. A bounded one-time revalidation of QS 2026 produced the specific governed failure: `QS inline Evidence decode failed: corrupt gzip stream does not have a matching checksum`.
6. Byte-level inspection proves the retained payload is incomplete: declared workbook size 337,667 bytes; retained base64 12,612 characters / 9,459 decoded bytes; gzip header present (`1f8b08`) but no valid complete gzip stream.
7. QS 2027 has no retained `cf212_stage_1` payload at all in its Evidence artifact.

Implementation/runtime lineage:

- Pilot `e10f63fc00fe8c568a7d4edbce2a6a2af3398bb6` — matching service-only inline Evidence context migration.
- Pilot `2fe8233b4c163188561ea6144a4c5d02c714e88a` — QS official worker v1.3.0 with inline Evidence support and actionable error serialization.
- Pilot runtime migration `20260906205708_cf231_qs_inline_evidence_context` applied.
- Pilot `ranking-qs-official-etl` deployed as Edge Function version 4, worker `ranking-qs-official-etl-v1.3.0`.
- One-time CF-231 executor created solely to invoke the fixed import once, then immediately retired to a JWT-protected HTTP 410 endpoint after the result was captured.
- The resulting Layer 1 Ranking ETL Job is `ee27bd66-311c-4011-aed4-d244b98b86a4`, status `failed`, with the specific gzip corruption error above instead of `{}`.

Security:

- `svc_ranking_import_control_context` remains executable by `service_role` only; execute remains revoked from public/anon/authenticated.
- No Production environment was touched.
- Security Advisor was rerun after the migration. Broader pre-existing advisor WARN/INFO backlog remains; no new advisor finding specific to the modified ranking import-context RPC was surfaced.

Decision: do not retry either QS 2026 or QS 2027 against the historical inline pointer. Re-register the authorised original XLSX Evidence so a complete immutable Evidence object is retained, then execute the dedicated Layer 1 QS worker.

## Canonical indicator findings

QS 2025 currently exposes:

- academic_reputation
- employer_reputation
- faculty_student_ratio
- citations_per_faculty
- international_faculty_ratio
- international_student_ratio
- international_research_network
- employment_outcomes
- sustainability

The dedicated QS official worker also recognises `international_student_diversity`. Its absence in the 2025 accepted edition must be treated as edition/source availability until proven otherwise; it must not be manufactured.

THE 2025/2026 accepted data currently retains six codes:

- overall
- teaching
- research
- citations
- industry_income
- international_outlook

The current dedicated THE Evidence worker recognises newer methodology aliases including `research_environment`, `research_quality` and `industry`. Historical accepted editions must not be rewritten merely to force a modern indicator schema. New official workbook ingestion should retain methodology-specific fields when actually present.

## Work plan

1. COMPLETE — eliminate opaque QS ranking failure reporting.
2. COMPLETE — diagnose QS 2026 retained Evidence integrity rather than blindly retry it.
3. Re-register complete authorised QS 2026 XLSX Evidence and run `ranking-qs-official-etl` validate/apply.
4. Re-register complete authorised QS 2027 XLSX Evidence and run the same dedicated worker without weakening workbook gates.
5. Apply already-validated THE editions in descending order 2024 → 2016 through the governed ranking control path, preserving existing Evidence and reconciliation.
6. Verify Statistics edition selectors expose all accepted editions only.
7. Verify Provider Compare can select the accepted QS/THE years and resolves rank history for Providers mapped in both systems.
8. Retain all mapping exceptions and equivalent Provider fan-out lineage.
9. Do not touch Production.

## Acceptance

CF-231 may close only when:

- QS 2026 is either accepted or has a specific, non-opaque governed rejection reason — **specific rejection reason now proven; re-registration remains required for completeness**;
- repeated `{}` ranking failure text is eliminated for new jobs — **PASS for the new CF-231 job**;
- validated THE 2024–2016 editions are either applied or each has a recorded specific blocker;
- accepted edition selectors in Statistics/Compare match runtime accepted editions;
- QS/THE history remains Evidence-linked and no indicator values are manufactured;
- CF-230 Parse.bot retirement remains intact;
- targeted desktop acceptance passes after the runtime edition set changes.

## Current decision

**NO-GO for claiming H12/H13 ranking completeness yet.**

The ranking architecture, Evidence-first strategy and error diagnostics are now sound. QS 2026/2027 need clean Evidence re-registration because their historical inline byte retention is incomplete, while THE 2016–2024 remain validated-only and are the next runtime completeness work once the QS Evidence files are restored.
