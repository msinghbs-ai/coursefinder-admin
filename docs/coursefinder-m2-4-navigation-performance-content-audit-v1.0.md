# CourseFinder M2.4 Navigation, Performance & Content Audit v1.0

**Issued:** 26 August 2026  
**Workstream:** M2.4 / Go 7 — Admin information architecture and operational UX  
**Change Control:** `CF-CHG-20260826-040`  
**Browser release:** PIM Admin `v2.15.6`  
**Runtime source under audit:** `msinghbs-ai/Coursefinder-Pilot` Go 7 line  
**Purpose:** retain a repeatable inventory of primary navigation, page/workspace content, deployed performance, relevance and improvement opportunities.

## 1. Executive assessment

Go 7 materially improves the operator mental model. The primary navigation now follows the CourseFinder authority chain rather than exposing implementation history or experimental launchers. Layer 1 is presented as a first-class regulatory operation, Layer 2/3/4 are grouped coherently, Scholarship Selection is separated as a decision tool, privileged provider/access configuration remains under Governance, and Guides are visible in-product.

The strongest current performance result is that the governed core RPCs remain inside the existing 3,000 ms budget without relaxing thresholds. The main optimisation targets are `courses_page` latency and the `course_filters` payload. The main maintainability target is to replace hidden-launcher/DOM-bridge navigation with first-class routed React workspaces over time.

## 2. Streamlined primary navigation

Accepted logical order:

1. **Overview**
2. **Catalogue**
3. **Data Operations**
4. **Insights**
5. **Quality & Review**
6. **Decision Tools**
7. **Governance & Platform**
8. **Help & Guides**

Role-aware Data Operations presents:

- Layer 1 — Regulatory;
- Layer 2 — Enrichment;
- Layer 3 — AI Interpretation;
- Layer 4 — Human Resolution;
- Evidence & Provenance;
- Jobs & Runs;
- Onboarding.

Decision Tools contains Scholarship Selection. Governance & Platform retains source/taxonomy/access/provider configuration according to rank. Help & Guides exposes Guides & Runbooks directly from the main navigation.

Representative screenshots are retained under `docs/evidence/m2-4-navigation-audit/` and the permanent deployed UAT now also generates a page-by-page navigation/content audit artifact.

## 3. Deployed performance baseline

The measurements below were captured from the deployed PIM Admin v2.15.6 Go 7 runtime. They remain valid measurements even though that specific run later failed inherited navigation selectors; the individual performance requests listed below completed successfully with HTTP 200 and the new Go 7 navigation tests themselves passed. Final Go 7 acceptance must use the subsequent selector-aligned run.

### Core workspace RPCs

| Operation | Desktop | Mobile | Payload | Budget / observation |
|---|---:|---:|---:|---|
| `providers_page` | 1,470 ms | 1,270 ms | 34,198 B | healthy; below 3,000 ms |
| `dashboard` | 354–998 ms | 397–710 ms | 2,553 B | healthy |
| `courses_page` | **2,024 ms** | **2,164 ms** | 80,557 B | highest core latency; 67–72% of 3 s budget |
| `course_filters` | payload capture | payload capture | **257,659 B** | 74% of 350 KB filter-payload budget |
| `campuses_page` | 449 ms | 403 ms | 35,417 B | healthy |
| `scholarships_page` | 335 ms | 283 ms | 3,428 B | healthy |
| `evidence_page` | 463 ms | 452 ms | 50,344 B | healthy |
| `data_quality_overview` | 389 ms | 286 ms | 17,174 B | healthy |

### Course interaction path

| Interaction | Desktop | Mobile | Payload |
|---|---:|---:|---:|
| initial Courses page | 957 ms | 880 ms | 80,557 B |
| exact CRICOS lookup | 645 ms | 618 ms | 1,788 B |
| Course detail | 758 ms | 724 ms | 15,258 B |
| subsequent Courses paging/filtering | 819–941 ms | 850–936 ms | ~80.6 KB |

### Responsive containment

At 1,440×900, 1,366×768 and 1,280×800, the document width remained equal to the viewport width. Wide decision grids intentionally scroll inside their table wrappers rather than forcing page-level horizontal overflow. The Courses table required approximately 1,610 px of internal table width while the wrapper reduced to 958–1,118 px across common laptop widths; this is acceptable containment but reinforces the need for sensible column presets on smaller displays.

## 4. Page/workspace relevance and improvement matrix

| Group / page | Current content and role | Relevance | Suggested improvement | Priority |
|---|---|---|---|---|
| Overview — Dashboard | Catalogue counts, operational pulse, failures, recent activity, attention/next actions | **Very high** | Add Layer 1 freshness, Layer 2 coverage/cost, Layer 3 queue/quality and Layer 4 backlog cards so the dashboard answers the full Layers 1–4 operating question without opening overlays. | P1 |
| Catalogue — Providers | Governed Provider catalogue, geography, lifecycle/publication, Course/Evidence cross-links | **Very high** | Add compact L1 authority/source-health and L2 enrichment-coverage indicators plus direct Evidence/source drill-through. | P2 |
| Catalogue — Courses | Core Course catalogue, filters, completeness, fee/intake/English/scholarship signals, detail drawer | **Critical** | Reduce filter payload; introduce saved/role presets and compact Layer status chips. Continue keeping required gaps visible rather than filling them synthetically. | **P1** |
| Catalogue — Campuses | Campus geography and Provider relationships | **High** | Add orphan/relationship-quality alerts and Provider/country coverage summary. | P2 |
| Catalogue — Scholarships | Canonical scholarship catalogue and publication/source state | **High** | Add direct source/Evidence completeness status and contextual launch into Scholarship Selection. | P2 |
| Data Operations — Layer 1 Regulatory | Bounded regulatory ingestion, source health, source registry, deterministic offsets/reconciliation | **Critical for Platform Admin** | Convert from reused hidden Settings host into a native first-class route/component. Keep qualification tools and Pilot reset in a separate Advanced/UAT area, never in routine L1 operations. | **P1 maintainability** |
| Data Operations — Layer 2 Enrichment | Enrichment plan, provider health, Evidence, source configuration, trials/jobs drill-down | **Critical** | Consolidate provider/config/trial sub-overlays as tabs/drawers under the Layer 2 route; expose coverage uplift and paid-provider budget at top level. | P1 |
| Data Operations — Layer 3 AI Interpretation | Benchmarked model profiles, eligible Evidence interpretation, recent interpretations, validator/cost controls | **High** | Replace manual Evidence/entity ID entry with an actionable unresolved queue. Show benchmark age, model/provider availability, quality rate, latency and cost trend. | **P1** |
| Data Operations — Layer 4 Human Resolution | Terminal queue, before/proposed values, Evidence/L2/L3 lineage, six governed actions | **Critical for review** | Add facets for country/provider/field/age/impact, downstream-consequence preview and queue statistics. Preserve mandatory reason and Search-signal boundary. | P1 |
| Data Operations — Evidence & Provenance | Cross-layer source artifacts, hashes/versions and canonical consequences | **Critical** | Add a compact lineage timeline L1 → L2 → L3 → L4 → Search signal and stronger jump links back to originating job/entity. | P1 |
| Data Operations — Jobs & Runs | Pipeline execution history/status | **High for operators** | Filter/group by layer, country, provider and source profile; add duration, throughput, retry and SLO indicators. | P2 |
| Data Operations — Onboarding | Nine-stage Country/Provider/Course lifecycle, outcomes and audit lineage | **High, lower frequency** | Add case dashboard, stage blocker checklist, owner/due state and one-click links to source/profile/provider/course/Evidence. | P2 |
| Insights — Outcomes (QILT) | Provider/study-area outcome observations and benchmarks | **High contextual relevance** | Emphasise observation grain/collection year and add simple benchmark/trend presentation. Never present as Course-grain fact. | P2 |
| Insights — Student Flow (PRISMS) | State/study-area/sector/cohort flow observations, periods and suppression | **High contextual relevance** | Add trend chart/filter while keeping suppression and grain clearly visible. | P2 |
| Quality & Review — Completeness | Factual/readiness domains, present/source-null/unresolved exceptions and drill-through | **Critical** | Add action-prioritised queues by layer/provider/freshness and direct routing to L2/L3/L4 where authority permits. | P1 |
| Decision Tools — Scholarship Selection | Course-scoped structural fit, SOURCE FACT / DERIVED SCORE / MISSING-UNRESOLVED | **High decision-support relevance** | Make Course drawer the preferred contextual launch with Course ID prefilled; retain global tool for reviewer lookup. Keep `eligibility_inference_permitted=false`. | P1 |
| Governance — Sources | Governed source inventory/configuration | **High admin relevance** | Distinguish governance/configuration from Layer 1 operational source health to avoid duplicated mental models. Add ownership, freshness policy and onboarding linkage. | P2 |
| Governance — Attributes | PIM taxonomy/options/completeness configuration | **High admin relevance** | Show usage/impact counts and which completeness/search surfaces each attribute affects before edits. | P2 |
| Governance — Layer 3 Provider | Vault-backed credential/model/provider configuration | **Critical admin-only** | Add benchmark history, last credential verification/rotation and provider availability state; never echo secret values. | P2 |
| Governance — Users & Roles | Auth identities, roles, expiry, disable/enable and audit | **High admin-only** | Continue current model; add last-effective-role change and optional access-review reminder/report later. | P3 |
| Help — Guides & Runbooks | In-product authority model, role quick guides and workflow launchers | **Very high usability improvement** | Generate/validate displayed guide version against repo-current guide metadata and provide page-specific “What can I do here?” links. | P2 |
| Release Notes | Version history opened from top-right version pill | **High operational traceability** | Continue mandatory maintenance rule on every visible release and link material changes to Change Control IDs. | P3 |

## 5. Cross-cutting recommendations

### P1 — performance

1. **Reduce `course_filters` payload** from ~258 KB by splitting dependent option sets, lazy-loading less frequently used filters and/or caching country/subdivision/provider option lists. Do not remove accepted filter semantics to meet the budget.
2. **Protect `courses_page` headroom.** It is currently inside the 3 s threshold but is the slowest core read at ~2.0–2.16 s in the representative run. Optimise only with query-plan/workload evidence; do not mass-add indexes solely because an advisor lists INFO findings.
3. Keep the existing Data Quality off-peak snapshot strategy and explicit post-ingestion refresh contract to prevent heavy refresh contention from returning to interactive traffic.

### P1 — information architecture / maintainability

1. Replace hidden launcher-backed overlays and DOM bridge navigation with first-class routed React workspaces progressively. The current Go 7 menu is the accepted user-facing IA; this recommendation changes implementation quality, not the visible grouping.
2. Give Layer 1 a native route and component rather than presenting a cleaned version of the legacy Settings component.
3. Make Course → Evidence, Course → Scholarship Selection and exception → appropriate Layer action contextual links the preferred operator path.

### P2 — operations intelligence

1. Standardise a scorecard header for Layers 1–4: health, queue, oldest item, throughput, failure rate, cost where applicable, and next action.
2. Standardise status language: healthy, degraded, stale, blocked, not configured, not yet run.
3. Keep advanced provider/parser/trial diagnostics behind progressive disclosure rather than adding more primary menu entries.

## 6. UAT and evidence status

Go 7 navigation acceptance itself passed in deployed browser UAT on both the new logical menu and visible Guides. The first complete deployed run on SHA `eabb7d99f93acf6260c06b33c852ed4b0bb6fd8a` subsequently failed because inherited Layer 2 and M2.3 tests still searched for deliberately removed labels/launchers (`Layer 2 Operations`, `M2.3 Intelligence`). Those were test-navigation contract failures, not proof that the underlying workspaces were unavailable.

Permanent test support has now been aligned to navigate through `Layer 2 — Enrichment`, `Layer 3 — AI Interpretation`, `Layer 4 — Human Resolution` and `Onboarding` while retaining the functional/security assertions. A permanent M2.4 navigation/content audit test has also been added to enumerate every menu item visible to the test role, record page/dialog heading and representative content, navigation elapsed time and screenshot evidence.

The final acceptance result and current screenshot inventory must be updated from the selector-aligned run before CF-CHG-040 is closed.

## 7. Evidence naming / location

Repository evidence folder:

`docs/evidence/m2-4-navigation-audit/`

The audit retains representative desktop/mobile screenshots plus a README mapping screenshots to the corresponding page/workspace. Full Playwright artifacts remain attached to the GitHub Actions deployed-UAT run for trace/video/runtime detail.

## 8. Next optimisation gate

After the final Go 7 desktop/mobile matrix is PASS:

1. close CF-CHG-20260826-040 and freeze PIM Admin v2.15.6 navigation;
2. use this audit as the M2.4 prioritisation baseline;
3. address P1 `course_filters`/`courses_page` headroom and native route/component refactoring without weakening security, data authority or UAT thresholds;
4. retain before/after performance and screenshot evidence for each accepted optimisation.
