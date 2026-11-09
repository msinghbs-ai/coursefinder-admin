# Autonomous AI Operations: baseline, architecture and workstreams (3 Nov 2026, 15:40 AEDT)

Mandate (verbatim copy): `2026-11-03-p0-autonomous-ai-operations-mandate-1537.md`. Integration Controller: this Claude session.

## 1. Phase 0: live baseline (checked 15:38 AEDT, read-only)

| Item | Live state |
|---|---|
| Last migrations | 20261103230000 (v2.15.426), 20261103210000 (v2.15.425), 20261103200000 |
| svc_enrich_ai_record time-outs since v2.15.426 (14:37) | 0 (IQ-00053 clean-hour check due 15:50) |
| Integration queue | 48 detected, 8 triaged, 5 deployed, 7 closed; 26 open P1 |
| New since the last report | IQ-00067: coverage-admit failed 3 of 6 runs in the hour |
| Worker error answers, last hour | 5 |
| Cron failures, last hour | 6 |
| Active scheduled jobs | 144 |
| Gap queue (14:23) | 35,690 courses scanned, 1,018 items; 4,038 page proofs, 297 proven |
| Source-proof feed (14:44) | relink 50, reading 108, Layer 4 362, locked 258, no route 1,222 (D1) |
| Onboarding d5dfc2ea (NEWGEN EDUCATION, CRICOS 03871F) | stopped, needs_source_discovery; website `https://info@newgen.edu.au` unchanged and not guessed |

The supplied baseline matches live.

The main finding is that 48 issues sit at "detected". The platform already detects well, but nothing diagnoses, remedies or verifies on its own. That is the gap this mandate closes.

## 2. Architecture decision: extend, do not duplicate

The platform already has the Detect and Track half of the lifecycle:
- `pipeline.integration_issues`: fingerprint, `root_cause_class`, `verification_*`, `regression_count`, `reopened_at`, `retry_count`, `condition_cleared_at`.
- The `integration-validate`, `zero-yield-detect`, `waste-guard`, `queue-watch` and `flag-recheck` jobs.
- `ops_scorecard_v1` and `integration_yield_checks_v1`.

The **AI Operations Controller** is therefore built as the missing stages on the same queue: Classify → Correlate → Diagnose → Select remedy → Execute → Validate → Learn → Close.
- There is no new queue and no new orchestration engine.
- Work runs through the existing scheduler (`cron`) and `pipeline.admin_jobs`. AI diagnosis runs through the existing worker and OpenRouter guards.

Shared contract, owned by workstream A (migration 20261104010000). Other workstreams code against these names and land after A:

| Object | Purpose |
|---|---|
| `pipeline.ops_root_causes` | Root-cause taxonomy (code, class: transient / data / rule / policy / dependency, description) |
| `pipeline.ops_remedies` | Remedy registry: code, authority (`auto` / `release` / `admin`), action function, verify function, max attempts, cool-down, the root causes it treats |
| `pipeline.ops_remedy_runs` | Every execution: issue, remedy, before and after measures, result, evidence |
| New columns on `pipeline.integration_issues` | `correlation_key`, `diagnosis` (jsonb with evidence and confidence), `remedy_code`, `remedy_attempts`, `next_action_at` |
| `pipeline.ops_outcome_codes` | The 8 job outcomes in mandate §7 |
| `pipeline.admin_jobs.outcome` | New column referencing `ops_outcome_codes`. The state check stays as it is, so the change is backwards compatible with nothing dropped. "Not needed" becomes a real outcome, not cancellation read as success |
| `security.ops_remedy_register_v1(...)` | How B, C, D, F and G add their remedies (insert or replace by code) |

**Authority boundaries are enforced in data, not prompts.** `auto` remedies may only call functions listed in `ops_remedies`. A remedy can never change `ops_remedies`, settings ceilings, Layer 4 admission, locks or budgets. Those changes go through a release, or through the Platform Admin.

## 3. Workstreams, ownership and order

| WS | Scope | Owns (functions and tables) | Migration | Spec |
|---|---|---|---|---|
| A | Controller and root-cause engine: correlation, diagnosis, remedy selection and execution, verification, reopen, one consolidated report | integration_issue_*, integration_validate_v1, integration_yield_checks_v1, ops_* | 20261104010000 | s244 |
| D | Self-healing and the job lifecycle: outcomes on every job, the not-needed path, stale leases, interrupted work (IQ-00064), false completion, persistence after extraction | admin_jobs_tick_v1, admin_job_watch_v1, admin_job_close_v1, enrich_plan_tick_v1, enrich_plan_v1 | 20261104020000 | s245 |
| B | Source discovery and gap recovery: per-class recovery routes, the D1 cohort of 1,222, shared identity defects (normalisation and matching before per-course search), evidence reuse | source_proof_feed_v1, course_relink_*, field_gap_*, field_absence_* | 20261104030000 | s246 |
| C | Scholarship and AER completeness: provider-level source-listing reconciliation, under-represented providers, coverage investigations | scholarship_*, fc_sch_*, aer_* coverage readers (not the AER Release C branch) | 20261104040000 | s247 |
| F | Cost and yield controller: plan value estimates, repeat-read and repeat-search prevention, circuit breakers, cost per verified improvement | new ops_cost_* and read-only reporting; no edits to D's functions (F exposes `ops_step_value_v1` for D to call) | 20261104050000 | s248 |
| G | Provider lifecycle and identity: register-backed website and identity validation (NEWGEN 03871F is the first case), reversible lifecycle transitions, relationship-aware housekeeping | provider_onboarding_tick_v1, provider lifecycle functions, new provider_identity_* | 20261104060000 | s249 |
| E | AI evaluation and controlled self-improvement: evaluation sets from verified Layer 4 decisions, versioned prompts and rules, offline regression, canary, rollback, a rejected-proposal ledger | new ai_eval_*, ai_instruction_versions | 20261104070000 | s250 |
| H | Integration, regression, release, operating docs and the 24-hour acceptance | Integration Controller (this session) | — | — |

Merge order: A first (shared contract), then D, B, G, F, C and E, in whichever order each passes integration. Each is a separate release. The Release C AER branch (20261103220000) stays held for the D6 decision.

Rules every agent follows:
- Read-only production SQL, inside the load windows.
- Every live function edited is md5-guarded.
- G2 settings, G3 consumer API frozen, and `-- Replaces:` / `-- Retires:` lines.
- No drops or deletes.
- Nothing that is paid or admission-changing ships on.
- Worker (`coverage-sweep`) edits only by B, which stays below v0.60.
- Agents do not merge, deploy, write to production or spend.

## 4. Decisions held for the Platform Admin (unchanged; not blocking)

- D1 paid course-page search (1,222 courses; the cost and yield case comes from B).
- D6 AER scheduled reading.
- The NEWGEN website: corrected only on register or first-party evidence, through a paste file (G).
- Firecrawl budget.
- Course description trust rule (D5 keeps review).
