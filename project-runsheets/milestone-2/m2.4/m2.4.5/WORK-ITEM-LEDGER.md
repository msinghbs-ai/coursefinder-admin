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

| 2026-09-03 12:59 | GOVERNANCE/PRIORITY | User directed M2.4.5 to execute H11 onward first | H11-H13 | CF-CHG-20260903-091 / CF-087 | gate order updated; H2 residual blocker and H3-H10 parked/continuous as applicable | repository continuity validation | ACTIVE — begin H11 immediately |

| 2026-09-03 12:59 | ADDENDA/INGESTION | Use established Parse.bot APIs for QS and ARWU multi-year 2015–2026 rather than generating new scrapers | H13 | CF-CHG-20260903-092 / CF-091 / CF-089 / CF-090 | QS `get_world_rankings`; ARWU `get_arwu_rankings` snapshot v10; shared staging/validate/apply contract | live qualification waits for valid Vault credential | ACTIVE / AUTH BLOCKED ONLY |

| 2026-09-03 13:48 | UAT/BLOCKER | Revalidate current Vault Parse.bot key against established QS and ARWU APIs | H13 | CF-CHG-20260903-092 | read-only QS + ARWU API calls using Vault internally | both HTTP 401 `Invalid API key`; endpoint reachability proven | BLOCKED — replace/rotate Parse.bot API key |

| 2026-09-03 14:29 | UAT/PASS | Validate corrected Vault Parse.bot key against established QS/ARWU ranking APIs | H13 | CF-CHG-20260903-092 | QS year=2026 items_per_page=1; ARWU year=2026 snapshot v10 | both HTTP 200; QS edition_year=2026 total=1504; ARWU year=2026 total=892 | PASS — begin controlled 2015–2026 Evidence/staging backfill |

| 2026-09-03 14:42 | FEATURE/INGESTION | Add Admin URL/file ranking import parser for QS/ARWU and prepare both 2026 editions | H12/H13 | CF-CHG-20260903-093 / CF-092 | ARWU system + URL importer + parser v1.5.0 + exact import control + v2.15.49 UI; backend deployed | targeted deployed UAT `33715985168` PASS; QS/ARWU APIs HTTP 200 | IMPLEMENTED / 2026 registration awaits authenticated Admin action |

| 2026-09-03 14:55 | BUG/UX | Recent ranking items stale; successful Parse remained enabled; duplicate edition needed warning | H12/H13 | CF-CHG-20260903-094 | latest-activity ordering + post-success lock + inline duplicate revision guard | Pilot DB applied; deployed UAT `33716795837` active | IMPLEMENTED / VERIFYING |

| 2026-09-03 15:57 | BUG/RELEASE | Browser showed v2.15.48 while newer ranking UI was active; QS 2027 error rendered [object Object] | H12/H13 | CF-CHG-20260903-095 | v2.15.51 version sync + QS 2026 default + 2027 warning/block + nested error formatter + dedicated deployed UAT | run `33721019815` PASS | CLOSED / TARGETED PASS |

| 2026-09-03 16:13 | BUG/INGESTION | QS 2026 Parse.bot Evidence registered but Parse & validate falsely required Evidence | H12/H13 | CF-CHG-20260903-096 | exact-import RPC now returns private storage_path + ARWU source mapping | live QS import validated: 1,503 observations, 15,030 indicators, 97.22% AU mapping | CLOSED / APPLY MANUAL |

| 2026-09-03 16:16 | UAT/PASS | Finalise QS 2026 Parse.bot Evidence hand-off gate after test assertion correction | H12/H13 | CF-CHG-20260903-096 | parser already validated live import; cleared-banner assertion corrected | deployed targeted UAT `33722438639` PASS | CLOSED / TARGETED PASS |
