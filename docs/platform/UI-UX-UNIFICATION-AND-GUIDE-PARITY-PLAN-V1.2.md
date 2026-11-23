# CourseFinder UI/UX Unification & Live Guide Parity Plan (v1.2, Final Fix)

**Status:** approved standing execution plan. **Date:** 23 Nov 2026. **Repositories:** `msinghbs-ai/Coursefinder-Pilot` and `msinghbs-ai/coursefinder-admin`.
**Owners:** S1-API-Frontend-Delivery (UI port, Layer 4 fix, guide parity, legacy CSS retirement) and S1-Build (settings registry, saved courses, partner contacts, daily mirror).
**Source:** Drive document of the same name, mirrored here on the Platform Admin's instruction of 23 Nov 2026 19:59 AEDT. This file is the source of truth.

## 1. Why the UI, mockups and guides drifted

1. **Split production experience.** Pilot #1498 (s990) moved Counsellor (rank 2) onto `src/ui-v1/` (`tokens.css` and `ui-kit.css`; Courses, Universities & Providers, Scholarships, Guide). Admin and Operator (rank 3+) routes stay on the legacy build with 58 legacy CSS files (656 KB).
2. **Layer 4 Review diff layout.** On `#layer-4-review` the Proposed value column collapsed to one word per line next to a full-width Live value now. Fixed in s998 (Pilot #1505).
3. **Settings disconnect.** Pipeline settings (for example `firecrawl.daily_budget_total`, `scholarships.counsellor_page_rows`, `integrations.status_fresh_hours`) do not match the plain-English section headers or sub-tabs, so operators cannot find or change them.
4. **Hardcoded stale role guides.** The legacy Role Guide still carries "reviewed for v2.16.61" and navigation that contradicts the live Counsellor build and the Admin sidebar.

## 2. Four slices

### Slice 1: Layer 4 Review and audit triage (S1-API-Frontend-Delivery)
- Diff grid: Proposed value and Live value now side by side at equal width (`minmax(0, 1fr) minmax(0, 1fr)`, `overflow-wrap: anywhere`) at 1440x900 and 375x812. **Done (s998).**
- Port Layer 4 onto `src/ui-v1/` (with the 2026-11-21 Layer 4 UI spec):
  - all 19 built-in queues share one 3-button bar: Yes (Approve), No (Reject), Resubmit to Review with AI; queue-specific extras under More options;
  - five primary filters on one row (Module / Field, University, Destination country, Source country, Decision bucket); the rest behind Advanced filters (N);
  - rule codes, version tags, 8-character refs and millisecond timings behind a Technical detail toggle, closed by default;
  - port Human Edits & Periodic Audit and Evidence.

### Slice 2: Settings, Integrations and API usage (S1-API-Frontend-Delivery and S1-Build)
- S1-Build: confirm or seed `firecrawl.daily_budget_total` (5.00, Standing Authority Charter section 10) and expose every active pipeline setting with a title, plain-English description, value, unit and audit-reason prompt.
- S1-API-Frontend-Delivery: port Settings, Integrations, API usage and Backup & restore onto `src/ui-v1/`. Render the budget caps (Firecrawl daily cap US$5.00 a day, monthly course-page credit cap) with instant search over plain-English labels and setting keys.

### Slice 3: Pipeline and operations monitoring (S1-API-Frontend-Delivery)
- Port Dashboard, Coverage & completeness, Layer 1 Register, Layer 2/3 Build & enrich, Platform health and Scheduled jobs. Show live queue progress, coverage and the active cron count (at most 140) with no hardcoded version banner.

### Slice 4: Admin catalogue, empty-state pills, route-driven guides (S1-API-Frontend-Delivery and S1-Build)
- Port Courses, Providers, Provider contacts (partner contacts REQ-116 by S1-Build), Scholarships, Entry requirements, Rankings & statistics, Destination data and Reference data.
- Four field-level empty-state pills (source-limitation reasons) across Course detail, Provider detail, AER, ELR and Scholarships.
- Role Guides generated from the live role-route manifest (`docs/UI-MAP.md`): Counsellor Guide (rank 2, the four live screens) and Operator & Platform Admin Guide (rank 3+, every live Admin route, the Layer 4 3-button workflow, Settings and API usage controls, Filter & Badge Reference). All hardcoded `v2.16.61` text and static guide prose removed.
- CI parity guard: the build fails if any guide link, screen name or filter label names a route or control absent from `docs/UI-MAP.md`.
- Legacy CSS retirement: delete the 58 legacy CSS files once no route imports them (checked by import graph, not assumed).

## 3. Acceptance

| Slice | Scope | Owner | Gate |
|---|---|---|---|
| 1 | Layer 4 diff fix, Layer 4, Human Edits & Periodic Audit, Evidence | S1-API-Frontend-Delivery | Diff columns 50/50 at 1440x900 and 375x812; 19 queues share the 3-button bar; all `data-l4-*` specs pass |
| 2 | Settings, Integrations, API usage, Backup & restore; `firecrawl.daily_budget_total` = 5.00 | S1-Build and S1-API-Frontend-Delivery | Every live setting editable with an audit reason; saved-courses RLS live |
| 3 | Dashboard, Coverage, Layer 1 Register, Layer 2/3, Platform health, Scheduled jobs | S1-API-Frontend-Delivery | No hardcoded version string; live cron, lock and coverage figures verified |
| 4 | Admin catalogue, four pills, route-driven guides, 58 CSS files deleted | both | Zero legacy CSS imports; guide-to-route parity check green; `v2.16.61` gone |

## 4. Guardrails

Consumer API G3 (75 functions, 48 relations) frozen (`s57`), reads use additive v3 RPCs only; 7,585 manual locks immutable; at most 140 active cron jobs; paid spend at most US$5.00 a day. Every PR keeps Playwright at 1440x900 and 375x812, `docs/UI-MAP.md` and `TEST-REGISTER.md` green.

## 5. Delivery rule for this plan

Each port is a Pilot PR preceded by its Admin PR (register, UI map, plan row). A legacy CSS file is deleted only in the PR after which the import graph shows no importer. Status is kept in `CONTINUOUS-DELIVERY-MASTER-PLAN.md` (Lane 1 status log).
