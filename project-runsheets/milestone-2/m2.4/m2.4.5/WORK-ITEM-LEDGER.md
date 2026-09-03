# M2.4.5 WORK ITEM LEDGER

All material Bugs, Addenda, Features, Governance, Operations and Security items must be recorded here before closure.

| Timestamp AEST | Type | Requested outcome | Workstream | Change ID | Implementation | UAT | Outcome / Next |
|---|---|---|---|---|---|---|---|
| 2026-09-03 10:28 | GOVERNANCE | Insert pre-production Admin/PIM hardening gate before M2.5 | H1-H10 | CF-CHG-20260903-087 | governance/runsheet commits | repository validation | ACTIVE |
| 2026-09-03 10:28 | FEATURE/HARDENING | Simplify/standardise Admin menu/submenu/UI | H1 | CF-CHG-20260903-088 | Pilot v2.15.45; core `527980d1e4fb5870c4870845a9b7956b6b3838f1`; access embed `a5eff83fa4accf190728f796480c5e4a986010ca` | build `33700864619` PASS; deployed UAT `33700864824` PASS | CLOSED / TARGETED PASS |
| 2026-09-03 10:28 | FEATURE/HARDENING | Scraper Config enable/disable and complete controls | H2 | CF-085 | ownership clarification `a033d3ef941eadb7fd992da15eb82c77956f9bec`; live provider registry reconciled | H1/H2 targeted browser running; provider semantic UAT next | ACTIVE |
| 2026-09-03 10:28 | FEATURE/HARDENING | Refactor scraper routing/Layer config UX | H2 | CF-085; child only if semantics change | readers/writers/runtime mapped; wording `60c8ad28afa28b166641d168d0c7bf08e0a74c56` | semantic routing test not yet run | ACTIVE / NO SEMANTIC CHANGE |
| 2026-09-03 10:28 | BUG/FEATURE | Mature Scholarship columns/order/filters | H3 | child CC on implementation | pending | pending | OPEN |
| 2026-09-03 10:28 | OPERATIONS | Revisit Scheduler Jobs | H4 | child CC on implementation | pending | pending | OPEN |
| 2026-09-03 10:28 | FEATURE | Manual record creation across applicable PIM | H5 | child CC on implementation | pending | pending | OPEN |
| 2026-09-03 10:28 | FEATURE/SECURITY | Auto-publication with explicit manual/mass controls | H6 | child CC required | pending | pending | DESIGN REQUIRED / DISABLED |
| 2026-09-03 10:28 | OPERATIONS | Keep Production migration data/telemetry current | H7 | CF-084/CF-087 | continuous | continuous | ACTIVE |
| 2026-09-03 10:28 | GOVERNANCE | Dated Addenda/Bug/Fix intake | H8 | CF-087 + owning CCs | continuous | continuous | ACTIVE |
| 2026-09-03 10:28 | UAT | Faster targeted testing | H9 | CF-087 + owning UAT CC | pending | pending | OPEN |
| 2026-09-03 10:28 | GOVERNANCE/MEETING | Milestone meeting evidence + interaction timeline | H10 | CF-087 | continuous | n/a | ACTIVE |


| 2026-09-03 10:35 | BUG/HARDENING | Remove separate full-screen Users & Roles Admin shell while preserving legacy deep link and rank-6 boundary | H1 | CF-CHG-20260903-088 / CF-078 | canonical embedded workspace; standalone root retired | build `33700864619` PASS; deployed UAT `33700864824` PASS | CLOSED / TARGETED PASS |
| 2026-09-03 10:43 | OPERATIONS/TELEMETRY | Reconcile live Scraper Config and Production migration inventory before H2 | H2/H7 | CF-085 / CF-084 / CF-087 | runtime read only; no mutation | Supabase runtime queries | PASS — Production targets remain pending |

| 2026-09-03 11:36 | BUG/FEATURE | Recheck user-enabled Parse.bot against official API and test connection | H2 | CF-CHG-20260903-089 | Parse.bot base/auth contract aligned; connection probe; generic runtime guard; v2.15.46 | targeted build/browser + live credential probe active | IMPLEMENTED / VERIFYING |
| 2026-09-03 11:36 | BUG/UX | Scraper Config header/Refresh/bold typography inconsistent with canonical Admin theme | H2 | CF-CHG-20260903-089 | canonical embedded header; labelled Refresh; inherited bold styling removed | targeted browser active | IMPLEMENTED / VERIFYING |
| 2026-09-03 11:37 | PERFORMANCE | Scraper Config eagerly loaded full Layer 2 profile inventory | H2/H9 | CF-CHG-20260903-089 | initial provider-only read; bounded 10-result profile search on progressive routing open | targeted browser active | IMPLEMENTED / VERIFYING |
| 2026-09-03 11:37 | UX/GOVERNANCE | Clarify Layer 2 execution policy and Layer 2 source purpose | H2 | CF-CHG-20260903-089 | workload defaults collapsed/standardised; routing read-only there; Layer 2 sources relabelled Extraction Profiles | targeted build/browser active | IMPLEMENTED / VERIFYING |

| 2026-09-03 11:39 | UAT/BUG | CF-089 deployed run selected stale CF-088 exact-release regression and failed on v2.15.45 pin while Worker was v2.15.46 | H2/H9 | CF-CHG-20260903-089 / CF-088 | durable CF-088 release assertion `304597a70b6d6c43a327cb4168fc362aa097d21b`; workflow routing `726b3f962eda9aa03380a7f9a7e76dbed39a6fe7` | run `33704442944` FAIL — test-maintenance only; replacement active | CORRECTED / REVERIFYING |
| 2026-09-03 11:41 | BUG/UX | Layer 2 workload inputs inherited browser-default layout because existing m-kv-list CSS styled div rows only, not label/input rows | H2 | CF-CHG-20260903-089 | `80b9548eb23edefcdbbd9cc8fa943f42c73d1165` canonical label/input/select/checkbox styling | build `33704684206` PASS; browser `33704684224` active | IMPLEMENTED / VERIFYING |

| 2026-09-03 11:48 | UAT/BLOCKER | Real Parse.bot Vault-credential probe reached official API but returned HTTP 401 authentication_failed | H2 | CF-CHG-20260903-089 | diagnostic probe telemetry persisted; no secret exposed | live `GET /dispatch/tasks` probe | BLOCKED — rotate/re-enter valid Parse.bot API key before generated API qualification |

| 2026-09-03 11:50 | UAT | Final CF-089 Scraper Config/Parse.bot diagnostic browser validation | H2/H9 | CF-CHG-20260903-089 | accepted Pilot `b6f75ffccf93981522a5c077100deeac87f7022a` | deployed `33705175873` PASS; frontend build job `33705175916` PASS | UI/PERFORMANCE TARGETED PASS; Parse.bot credential remains BLOCKED 401 |

| 2026-09-03 12:47 | ADDENDA/FEATURE | Complete primary university/Provider logo coverage and use Hotcourses sitemap/navigation for source discovery/reconciliation | H11 | CF-CHG-20260903-091 / CF-083 A32 | governance backlog added; no runtime mutation | repository + external-source review | OPEN — first-party assets remain canonical authority |
| 2026-09-03 12:47 | FEATURE/DATA | Add ARWU 2025 + multi-year ARWU to Statistics & Rankings | H12 | CF-CHG-20260903-091 / CF-090 | governance/design backlog added | pending bounded real-data UAT | OPEN |
| 2026-09-03 12:47 | FEATURE/DATA | Add University Diversity Index / HDI to Statistics & Rankings | H12 | CF-CHG-20260903-091 | contextual dataset backlog added; source/reuse gate retained | pending | OPEN |
| 2026-09-03 12:47 | FEATURE/INGESTION | Support ranking ingestion by uploaded parser and governed API/Parse.bot endpoint with multi-year edition input | H13 | CF-CHG-20260903-091 / CF-089 / CF-090 | unified acquisition contract planned; API key remains Vault-only | pending adapter/auth/schema-drift UAT | OPEN |
| 2026-09-03 12:47 | GOVERNANCE/RECONCILIATION | Recheck user note that CF-083/A32/v2.10.49/v1.30 cross-references were incomplete | H8/H10 | CF-CHG-20260903-091 | repo truth shows reconciliation already completed and current docs advanced to v2.10.50/v1.31 | repo search/current-doc router | PASS — historical note superseded |
