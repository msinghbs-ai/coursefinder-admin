# Independent production health check — CourseFinder Admin + Pilot
Date: 31 October 2026, approximately 10:10 AEDT
Mode: read-only; no SQL mutations, deployments, consumer changes or paid reads.

## Scope and evidence
- Governance model: `docs/platform/AGENT-OPERATING-MODEL.md`; session index: `docs/platform/nz-enrichment-brief/INDEX.md`.
- Execution rules: Pilot `CLAUDE.md`; current Pilot head observed as merge commit `6f0066196de22971e5a46c6820fdce900a1b7554` (v2.15.375 / PR #765).
- Direct Supabase connector read-only SQL against production project `fxcwkweaxjtknorudmwp` at 30 Oct 23:10 UTC (31 Oct 10:10 AEDT).
- Supabase project service status: ACTIVE_HEALTHY. This does not certify the business workflow.
- GitHub latest Admin commit at inspection: `042252c70d45b9cff9d4fbc28bee029557269244`. The 31 Oct field reports and daily admission running sheet are present in recent admin commits.
- GitHub commit status for Pilot head: targeted Chromium desktop deployed UAT success, run 41050259817. The commit-workflow-run lookup returned no PR-triggered runs, so full CI and release/deploy workflow could not be independently certified from this connector response.
- Production migrations contain `20261030280000` and `20261030290000`. Edge functions list returns active functions. Cloudflare Worker runtime version/traffic, public Website/Zoho authenticated end-to-end behaviour and live deployment SHA were **not** independently established.

## Production findings
| Check | Result | Status |
|---|---|---|
| Supabase status/connectivity | ACTIVE_HEALTHY; SQL queries succeed | PASS |
| Migrations | D5 migrations 20261030280000/290000 in production | PASS (DB only) |
| Active courses | 35,689 (44,391 total rows) | Observed |
| Page bindings | bound 26,090; mismatch 7,948; ambiguous 1,586 | HIGH data quality risk |
| Scheduler 24h | 41,265 runs across 135 job IDs; 28 failures | WARN |
| waste-guard | 14 failed of 24, statement timeouts | P1 |
| coverage-ai-match-prepare | 11 failed of 720, statement timeouts | P1/P2 |
| coverage-read-2 | 2 failed of 1,603 | P2 |
| l4-rule-low-agreement | 1 failed of 1 | P2 |
| Layer 4 pending | 1,141 records | P1 workload |
| Current Pilot head | 6f0066196d... v2.15.375 | Observed |
| Targeted deployed UAT | success, chromium-desktop | PASS, limited scope |
| Full CI/deployment/Worker release parity | not independently verified | UNVERIFIED |

The SQL timeouts name actual functions `security.enrichment_flags_refresh_v1`, `security.waste_guard_v1`, `coverage_ai_match_prepare_v1` and helper paths including `site_not_checked_v1`, `enrich_focus_v1`, `coverage_country` and provider-site checks. Investigate with safe EXPLAIN (no ANALYZE initially) and sampling; do not blindly extend timeouts.

Coverage-state data should not be interpreted as final admission yields because `not_on_page` conflates source-silent, mismatched and no-copy causes (diagnostic TD5).

## Security adviser
Observed advisor groups: RLS enabled/no policy 421 INFO; mutable search path 2 WARN; PUBLIC/anon executable SECURITY DEFINER 1 WARN; authenticated executable SECURITY DEFINER 169 WARN. These are lint findings, not 172 proven exploitable vulnerabilities. Validate grants, allowed callers and actual API exposure for high-impact functions before changes. Useful references:
- https://supabase.com/docs/guides/database/database-linter?lint=0011_function_search_path_mutable
- https://supabase.com/docs/guides/database/database-linter?lint=0028_anon_security_definer_function_executable
- https://supabase.com/docs/guides/database/database-linter?lint=0029_authenticated_security_definer_function_executable

## Admin repository governance assessment
Admin is the decision/documentation system, not production deployment. The INDEX last-updated stamp (26 Oct) is behind current 30–31 Oct work; latest releases, actual pending decisions, source-of-truth status and next-chat links should be reconciled with recent 31 Oct reports and PR #765. Avoid representing the stale index as definitive current state. Existing 31 Oct report commit f2695a... added Courses, Entry requirements and Scholarships sheets; check row-count/field definition reconciliation with live data and the standing change-control decision trail. The prior status-review commit was documentation only.

## Pilot repository execution assessment
Current main merge #765 includes approved additive `scale_stated` consumer marker and AER workspace changes. DB migrations are applied. GitHub reports targeted deployed UAT success; last PR description reports 1,271 local passing tests, zero failures/skips (not independently rerun). Need verify complete CI run, deployed Worker version, Cloudflare route, Supabase Edge versions, consumer API shape and response, zero-fail deployed safe suite, and rollback readiness before production sign-off. Do not conflate the GitHub PR test claim with an independently executed suite.

## Next steps, proposed—not authorised deployment
P0 (immediate, read-only):
1. Release attestation across Pilot main SHA, GitHub deploy-on-merge execution, Supabase migration ledger, edge function revisions and Cloudflare Worker version; verify API routes with appropriately scoped test credentials.
2. Sample `waste-guard` timeouts and `coverage-ai-match-prepare` helper-function execution plans; establish query timings, rows scanned and index choices.
3. Check consumer API contract baselines and `consumer-api-guard` status; do not expose service role secrets. Confirm Wix and Zoho sync with owners.
4. Reconcile Admin INDEX (26 Oct stamp) with current release and decision files; correct stale go-live date, reviewer queue data and risks through a governance-only PR.

P1 (governed design/PR):
5. TD1: sample 50 shared/unproven URL bindings; introduce course-specific proof gates through approved record → migration → regression tests. Manual bindings remain untouched.
6. TD2/TD3: avoid mismatch/no-copy Enrich re-queues; replay 23 Oct withdrawn values only after valid page+stored copy, bounded and count guarded.
7. Separate source-silent, wrong-page and no-copy states; show admission flow separate from net stock reports (TD4/TD5).
8. Triage 1,141 pending Layer 4 records by type, age and country; prioritise time-critical AER and fee decisions. Do not auto-approve.
9. Review adviser warnings for anonymous SECURITY DEFINER exposure first, and then authorised-user exposure; preserve legitimate permissions.

P2 (release gate):
10. Run complete CI/deployed safe desktop and phone UAT, validate role-based denied/allowed access, API pagination and latency, background-job SLO, error budget and country-specific data quality. Obtain explicit Platform Admin approval for consumer-visible changes and all destructive changes.

## Acceptance criteria
- Zero unexplained failed mandatory cron jobs over agreed 24h/7d windows; high-failure jobs rechecked for successful completion and normal duration.
- All new bound pages have documented identity evidence; manual bindings protected; sampled shared URLs pass course identity review.
- Controlled re-reads have documented admitted vs held/no-value counts and provenance.
- API contract and live consumer reads green with approved `scale_stated` shape, without regressions.
- Version parity and deploy evidence recorded, full applicable CI green, no skipped tests outside permitted deployed holds.
- Pending review age buckets and daily decision throughput visible; go-live date not asserted until production gates pass.

No production modifications made in this audit.
