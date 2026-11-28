# DR-19: runtime reader, remedy and country-adapter trace (evening closure evidence)

S2-RM-Design, 28 Nov 2026 16:05 AEDT. Instructions: `PC-20261128-EVENING-COUNTRY-NEUTRAL-CLOSURE` (S2-RM-Design scope: trace reader/writer and country-adapter assumptions), `PC-20261128-ONE-COMMAND-RUNTIME-CLOSURE` (reader profiles, adapters, qualified remedies), `PC-20261128-PRODUCTION-COMPLETION` (DR-19 capability matrix; learning-registry audit). All figures are live and rolled back; repository is `origin/main` at the read time. No code, migration, database object, cron or spend was added.

## 1. Country-adapter assumptions in the readers (code trace, then live impact)

| Default in code | Where | Live impact | Verdict |
|---|---|---|---|
| Missing provider country becomes `"AU"` | `coverage-sweep/index.ts` (course-code and source-site paths) | 0 published providers lack a country | Latent; never fires for a published provider. Not changed |
| Missing scholarship currency becomes `"AUD"` | `coverage-sweep/index.ts` (three scholarship read paths), `scholarship.ts` | NZ and CA scholarships hold 0 AUD amounts (NZ: 252 NZD, 82 none; CA: 317 CAD, 1 USD, 126 none) | Latent; callers pass the provider currency. Not changed |
| `fee()` currency defaults to AUD | `coverage-sweep/extract.ts` | NZ and CA fees hold 0 AUD (NZ 1,656 NZD; CA 751 CAD) | Latent; not changed |
| CRICOS code as the AU registration identifier | `extract.ts`, `link-rollover.ts` | Applied only when the country is AU; NZ and CA use their own path (TLD and site checks) | Country-scoped already; no CRICOS requirement outside AU |

**Result:** no proven AU coupling to remove (instruction: "remove only proven AU coupling"). The three latent defaults are recorded for S1-Build's next genuine code release in coverage-sweep. Consolidating them then means passing the provider's country and currency explicitly; that needs no schema change and no country-specific table.

## 2. Runtime mechanisms already live (no PR to change behaviour)

| Mechanism | Live rows | Changed at runtime by | Used for |
|---|---|---|---|
| `pipeline.ops_remedy_knowledge` (recovery knowledge) | 37 patterns; 9 auto-eligible; applied 7,298, verified 4,467, failed 2,831; 8 with a no-yield streak of 3 or more | Existing remedy runner and closure learning (s1292, s1294) | Reuse of verified remedies; the no-yield streak is the ineffective-retry signal |
| `pipeline.work_recovery_policies` | 22 (including `ai_account_refusal`, s1282) | Policy rows | Retry, defer or escalate per failure class; whether an attempt is counted |
| `pipeline.recovery_error_classes` | 18 (including the three `service_limit` rows, s1277) | Rows | Classifying error wording into classes and owners |
| `pipeline.ai_service_routes` | 19 routes, 16 enabled | Settings › Models & services (existing admin controls) | Pinned model per service, enabling and caps |
| `pipeline.field_execution_registry` | 29 lanes, 19 enabled | Lane enable and mode | Which producer runs for which field |
| `pipeline.integration_issues` | closed 149, triaged 493, deployed 7, in production verification 2 | Existing issue flow | Root cause, remedy and verification per issue; linked per course by the record trace (s1295) |

## 3. DR-19 capability and decision matrix (record trace `recovery_cause`, s1295 and s1335)

| Recovery cause | Data correction or engineering gap | Existing remedy and owner |
|---|---|---|
| account_refusal | Operational | Hand-back once to the existing worker (s1277); policy `ai_account_refusal`. Engineering gap: the worker still counts a refusal as an attempt (S1-Build) |
| technical_failure | Operational | Existing retry and backoff policies |
| insufficient_evidence | Data (evidence holds) | Reader guard holds stand. A person decides in Layer 4, or the source is read again when its content changes |
| no_source / missing_official_source | Data | Source discovery (S1-Build, S2-CF lanes) |
| identity_unproven | Data | Course-identity recovery (S2-AER) |
| unsupported_website_structure | Engineering (reader capability) | Declarative reader profile or adapter (this lane), activated through S1-Build. Today 0 cases under the corrected rule (s1335) |
| no_reader_configuration / reader_not_qualified / qualified_reader_awaiting_activation | Engineering or decision | Route and lane register. Activating a route is a protected decision |
| repeated_ineffective_extraction | Engineering | Suppressed by the no-yield streak in recovery knowledge; review of the reader by its owner |
| no_eligible_work_from_planner | Engineering (planner) | PIM planner step (S1-RM-Design) |
| admission_or_publication_hold | Protected | Layer 4, manual locks, publication switch; never bypassed |

## 4. Outcome proof and remaining holds

- **Two productive cycles (s1277 recovery, worker cycles of 26 to 27 Nov):** 47 descriptions filled. All are verified in the catalogue and served by Website v3 with the catalogue text exactly. 472 stopped on evidence holds, 8 went to Layer 4, and 0 were refused again by the account.
- **Holds:**
  - The stronger-model second-opinion step is off with no pinned model (Platform Admin decision).
  - The worker counts account refusals as attempts (S1-Build code change).
  - The three latent AU defaults above (S1-Build, at the next coverage-sweep release).
  - No unsupported-structure case is eligible to prove the reader-profile chain end to end.
- **Footprint this evening:** 0 migrations, 0 database objects, 0 cron jobs, 0 code changes, US$0.
