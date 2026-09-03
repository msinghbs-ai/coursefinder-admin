# M2.4.5 MILESTONE MEETING READINESS

**Started:** 2026-09-03 10:28 AEST

## Purpose

Maintain a continuously usable milestone-meeting record of:
- what was achieved;
- what failed/blocked;
- what remains next;
- implementation commits;
- UAT/workflow evidence;
- runtime/data/telemetry changes;
- interaction timestamps;
- user-confirmed billable time separately from session timestamps.

## Interaction timeline

| Date/time AEST | Interaction / decision | Evidence |
|---|---|---|
| 2026-09-03 10:03 | CF-086 PIM principles/document routing established | CF-086 governance commits |
| 2026-09-03 10:13 | M2.5 P0 runtime reconciliation; Production project still absent | CF-049 + M2.5 runsheet/current-state commits |
| 2026-09-03 10:28 | User requested pre-production hardening placement; decision to insert M2.4.5 | CF-087 |

## Time accounting rule

Repository interaction timestamps are evidence of when decisions/actions occurred. They are **not automatically billable duration**. Billable hours must remain user-confirmed under standing programme rules.

## Meeting pack sections to maintain

1. Milestone timeline and accepted baselines.
2. Feature/demo matrix by Layer/module.
3. Admin/PIM maturity changes.
4. Data counts/coverage and Evidence.
5. Jobs/schedulers/telemetry/cost.
6. Security/UAT results.
7. Open blockers/deferred items.
8. Production readiness status.
9. Roadmap: M2.4.5 closure → M2.5 P0–P8.
10. Confirmed engagement hours separately from interaction timeline.


## H1/H2 readiness update — 2026-09-03 10:47 AEST

### Achieved
- H1 Administration IA/UI inventory completed and implementation accepted by targeted validation under CF-088.
- Pilot v2.15.45 uses one metadata-driven Administration section model, compact configuration cards and canonical Users & Roles embedding.
- Legacy `#users-roles`, `#attributes` and `#settings` links remain compatible without reinstating a second Admin shell.
- Role/rank runtime reconciled: viewer 1, counsellor 2, curator 3, pipeline_operator 4, PIM Operator 5, Platform Admin 6.
- H2 source/runtime inventory completed for provider registry, profile routes, global wave policy and per-profile execution policy.
- Live provider state recorded; Parse.bot remains disabled; Firecrawl entitlement/reserve recorded as 5,000 / 250.
- Production migration manifest remains source-ready / target-pending and no Production Supabase project exists.
- Targeted validation: Frontend Build `33700864619` PASS; Deployed UAT `33700864824` PASS.

### Failed / blocked
- No H1 failure remains.
- H2 semantic routing consolidation is not yet complete: the relationship between global `route_mode`, profile provider ordering/fallback and per-profile execution policy still requires bounded reconciliation before any semantic change.
- Production provisioning remains intentionally blocked by M2.4.5 and the existing P0 organisation/region/name/cost confirmations.

### Next
- Continue H2 only: reconcile qualification state, global wave route mode, per-profile routing and Layer 2 read-only effective-state presentation under CF-085; open a child Change Control only if runtime semantics change.
- Then proceed to H3 Scholarship maturity.

## Interaction timeline additions

| Date/time AEST | Interaction / decision | Evidence |
|---|---|---|
| 2026-09-03 10:35 | User opened M2.4.5 execution and instructed H1 then H2 with targeted validation only | current chat / CF-087 |
| 2026-09-03 10:39 | H1 inventory identified separate Users & Roles Admin shell and duplicated Administration metadata | CF-088 inventory |
| 2026-09-03 10:43 | H2 live Scraper Config + Production migration inventory reconciled | Pilot Supabase runtime read evidence |
| 2026-09-03 10:47 | H1 targeted build and deployed browser validation passed | runs 33700864619 / 33700864824 |

No billable duration is inferred from these interaction timestamps.

## H2 CF-089 update — 2026-09-03 11:41 AEST

### Achieved
- User-enabled Parse.bot was reconciled against the official Parse API contract rather than assumed to be a generic scraper proxy.
- Parse.bot registry now uses `https://api.parse.bot` + write-only `X-API-Key`; runtime remains enabled but generic execution is explicitly blocked until generated API qualification.
- Real server-side connection test added using `GET /dispatch/tasks`; stored Vault credential is never returned to the browser.
- Scraper Config initial load reduced from full extraction-profile inventory to the seven-provider registry; profile routing is loaded only on demand with at most 10 search results.
- Dark nested application header, icon-only Refresh, excessive provider-card bold styling and browser-default workload inputs corrected to canonical Admin patterns.
- Layer 2 Sources is now presented as **Extraction Profiles**, separating source-specific extraction/version rules from scraper/provider controls.
- Workload policy is collapsed as advanced defaults and no longer writes the legacy global routing mode.
- Runtime migrations and Edge guards applied without creating Production resources.
- Final source/build run `33704684206` passed.

### Failed / blocked
- First deployed UAT `33704442944` failed only because an older CF-088 regression pinned v2.15.45 while the Worker had correctly advanced to v2.15.46. The test and routing were corrected.
- Parse.bot full extraction is not yet execution-qualified. A connection/auth PASS is only the prerequisite; generated Parse API `scraper_id` + `endpoint_name`, bounded execution, Evidence and cost telemetry remain required.

### Next
- Record final deployed run `33704684224`.
- If Parse.bot connection passes, perform one bounded generated-API qualification on an agreed extraction profile before admitting Parse.bot to runtime routing.
- Then finish H2 and continue H3 Scholarship PIM maturity.

## Interaction timeline additions

| Date/time AEST | Interaction / decision | Evidence |
|---|---|---|
| 2026-09-03 11:36 | User enabled Parse.bot and challenged Scraper Config loading, theme consistency, execution policy and Layer 2 Sources purpose | CF-089 trigger / supplied screenshots |
| 2026-09-03 11:37 | Runtime/repo review identified 1,883 extraction profiles and 12,207 route rows being exposed behind eager profile loading | Pilot runtime reconciliation |
| 2026-09-03 11:38 | Parse.bot generic-proxy mismatch corrected; bounded profile loading and connection probe implemented | CF-089 Pilot/migration/Edge commits |
| 2026-09-03 11:39 | Initial deployed UAT failed on stale CF-088 v2.15.45 assertion, not application behaviour | run 33704442944 |
| 2026-09-03 11:41 | Workload input styling corrected after screenshot/source CSS comparison | Pilot `80b9548eb23edefcdbbd9cc8fa943f42c73d1165` |

No billable duration is inferred from these interaction timestamps.
