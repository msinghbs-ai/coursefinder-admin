# CF-CHG-20260907-231 — Ranking Edition Completeness & Runtime Reconciliation

**Status:** ACTIVE / RUNTIME GAPS CONFIRMED  
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

- 2027 — `needs_review`; official QS XLSX Evidence retained; parser identified 1,504 candidate observations.
- 2026 — `needs_review`; official QS XLSX Evidence retained; repeated `layer1_ranking_etl` jobs failed with opaque `{}` error text. This is a diagnostics blocker and must be corrected before another repeated retry cycle.

THE:

- 2024, 2023, 2022, 2021, 2020, 2019, 2018, 2017 and 2016 are already `validated` and retain candidate counts/reconciliation previews.
- Existing THE validation previews report 100% mapped rate within the governed AU reconciliation scope for those retained files, with equivalent Provider fan-out retained where applicable.
- These editions are not yet applied and therefore are not available as accepted ranking editions to Statistics/Compare.

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

1. Stop blind QS 2026 retries while error payload remains opaque.
2. Harden ranking worker/control error reporting so structured Supabase/worker errors become actionable text.
3. Re-run QS 2026 through the dedicated `ranking-qs-official-etl` dry-run/validate path.
4. If validation passes, apply QS 2026 and verify accepted edition, observation count, AU/NZ Provider mapping and canonical indicators.
5. Resolve QS 2027 separately after 2026 passes; do not weaken workbook gates simply to force acceptance.
6. Apply already-validated THE editions in descending order 2024 → 2016 through the governed `ranking-publisher-control` path, preserving existing Evidence and reconciliation.
7. Verify Statistics edition selectors expose all accepted editions only.
8. Verify Provider Compare can select the accepted QS/THE years and resolves rank history for Providers mapped in both systems.
9. Retain all mapping exceptions and equivalent Provider fan-out lineage.
10. Do not touch Production.

## Acceptance

CF-231 may close only when:

- QS 2026 is either accepted or has a specific, non-opaque governed rejection reason;
- repeated `{}` ranking failure text is eliminated for new jobs;
- validated THE 2024–2016 editions are either applied or each has a recorded specific blocker;
- accepted edition selectors in Statistics/Compare match runtime accepted editions;
- QS/THE history remains Evidence-linked and no indicator values are manufactured;
- CF-230 Parse.bot retirement remains intact;
- targeted desktop acceptance passes after the runtime edition set changes.

## Current decision

**NO-GO for claiming H12/H13 ranking completeness yet.**

The ranking architecture and CF-230 acquisition strategy are accepted, but runtime edition coverage is incomplete because QS 2026/2027 are not accepted and most retained THE historical editions are validated-only.
