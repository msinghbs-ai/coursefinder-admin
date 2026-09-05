# CF-CHG-20260905-214 — THE URL → Evidence XLSX Acquisition

**Status:** IMPLEMENTED / TARGETED UAT ACTIVE  
**Milestone:** M2.4.5 — H13 ranking acquisition/parser completion  
**Related:** CF-213 QS URL Evidence workflow; CF-091/CF-092 ranking acquisition controls

## Objective

Extend the governed ranking acquisition pattern to Times Higher Education (THE) World University Rankings from the 2010–11 edition (selected as edition year 2011) through the current/latest edition.

The operator path is:

`THE publisher URL → publisher metadata/completeness check → structured acquisition → raw private Evidence → generated THE XLSX Evidence → THE XLSX parser → reconciliation/dry-run → explicit Apply → ranking read projections/export`

No Search, Website or Zoho publication admission is implied by this change.

## Approved publisher URL family

- `https://www.timeshighereducation.com/world-university-rankings/latest/world-ranking`
- `https://www.timeshighereducation.com/world-university-rankings/{year}/world-ranking`
- Minimum supported selected edition year: `2011`.
- Only HTTPS `www.timeshighereducation.com` World University Rankings URLs are accepted.
- A year embedded in the URL must match the selected edition; `latest` is accepted for the current edition path.

## Acquisition contract

The THE page remains the canonical submitted/publisher source URL. The current public ranking table is interactive; CourseFinder uses a governed structured acquisition adapter where the publisher page does not expose the complete table server-side.

Current structured adapter:

- Provider: Parse.bot configured through the existing Scraper Config/Vault path.
- Scraper ID: `a250cfd9-0c7d-421b-87a3-80a0d7d392be`.
- Endpoint: `get_rankings`.
- Ranking type: `world_university_rankings`.
- Edition/year is explicit.

The adapter is an acquisition mechanism, not ranking authority. THE remains the publisher/authority and its page URL is retained as source provenance.

## Evidence contract

The workflow is Evidence-first and fail-closed.

1. Capture THE publisher page metadata and advertised interactive result total where available.
2. Acquire the structured edition dataset.
3. Reject zero-row or incomplete datasets using edition-aware minimums and the publisher-advertised total when available.
4. Store the complete raw acquisition response in the private `evidence` bucket and register `ranking_publisher_raw` Evidence.
5. Generate and store a deterministic XLSX Evidence artifact.
6. Register the XLSX through `svc_ranking_manual_import_register`.
7. Run the dedicated THE XLSX parser in dry-run/validation mode.
8. Keep canonical Apply explicit unless the caller explicitly requests Apply.

Generated workbook filename:

`{year} Times Higher Education World University Rankings CourseFinder Evidence.xlsx`

Generated workbook sheets:

- `Rankings`
- `Raw Source`
- `Evidence Metadata`

The `Raw Source` sheet preserves every field returned by the structured acquisition response. The ranking sheet exposes the ranking fields, pillar scores/ranks and available student-statistics fields in a stable operator-friendly format.

## Edition-aware methodology semantics

Historical and current THE pillar labels are not flattened into false equivalence.

Earlier editions retain:

- Teaching
- Research
- Citations
- Industry Income
- International Outlook

Current methodology-era editions retain:

- Teaching
- Research Environment
- Research Quality
- Industry
- International Outlook

Per-pillar score and available rank semantics use the generalized `ranking.indicator_observations` score/rank fields introduced by CF-213.

The public ranking table/acquisition adapter does not currently expose every underlying individual THE methodology sub-indicator as a score. CourseFinder must not manufacture unavailable sub-indicator values. If a licensed THE dataset/API later exposes those fields, they may be admitted as additional Evidence-backed indicator observations under a separately verified parser revision.

## Completeness controls

Edition-aware minimum row thresholds protect against country subsets or partial table responses. When THE publisher HTML exposes a total result count, the acquired structured dataset must meet or exceed that publisher count before XLSX Evidence registration proceeds.

Examples used in acceptance planning:

- 2010–11 / selected edition 2011: 200 ranked rows.
- Current 2026 page: 2,191 ranked institutions; the interactive table reports a larger total including participating/reporting rows. The Evidence workflow retains the full acquired source table and preserves unranked/reporting status rather than discarding those records.

## Runtime implementation

Pilot Edge Functions:

- `ranking-the-url-import` v1 — authenticated operator URL acquisition/XLSX generation.
- `ranking-the-official-etl` v1 — service-authorized THE XLSX parser/dry-run/Apply.
- `ranking-publisher-control` v10 — THE validate/Apply routed through the dedicated parser.
- `ranking-publisher-url-import` v5 — THE publisher URLs delegated into the governed THE URL worker.
- Existing `ranking-evidence-export` provides short-lived private XLSX export for THE imports.

Pilot source commits include:

- `d04b443f1f558ab8407ac16aabec873ce0743840` — THE Evidence workbook parser.
- `efe0ae0e85f9ade0d1d62bf088856f3e3969c05e` — THE URL acquisition and XLSX generation.
- `e70bc9549e3446a9a4fc56d1381f75dfda65c1fe` — ranking control parser routing.
- `01c0640480721eb6ae738a6a868fc98ff5e272da` — THE publisher URL delegation and Administration UI exposure.
- `64a662dac0518e3dd49a53ce66a38d1a985d5301` — permanent CF-214 contract UAT.

## Administration UX

`Administration → Sources & Imports` now supports THE `Publisher URL → Evidence XLSX` mode.

- THE year selector covers 2026 through 2011 at the current release baseline.
- The URL field is labelled `THE publisher URL`.
- Generated/imported THE XLSX Evidence is available through the existing per-import `Export XLSX` action.
- Apply remains a distinct operator action following validation.

## Security and production boundary

- User-facing URL worker requires a valid authenticated Admin/Pipeline Operator context (rank >= 4).
- Parser is service-authorized and is not a public browser mutation surface.
- Evidence remains private; export uses short-lived signed access.
- Parse.bot credentials remain in the configured secret/Vault path and are not returned to the client.
- No Production Supabase project/resource was created or modified by CF-214.

## Acceptance outstanding

CF-214 remains TARGETED UAT ACTIVE until:

1. Pilot CI/deployed UAT passes for the final source head.
2. An operator-authenticated run validates the current/latest THE URL and verifies acquired count against the publisher page total.
3. An operator-authenticated run validates the 2011 URL and verifies the 200-row historical edition contract.
4. Generated XLSX files are exported and hash/provenance checked against registered Evidence.
5. Parse.bot credential/runtime qualification is confirmed; any 401 or schema drift must fail closed and remain a blocker rather than permitting partial Evidence.
