# CF-CHG-20260910-093 — Runtime Operations Follow-on

**Status:** ACTIVE FOLLOW-ON / CF-093 REMAINS REOPENED  
**Updated:** 13 September 2026 AEST

## Purpose

Record the post-PR #72 Scheduled Tasks runtime-operations, observability and efficiency work without rewriting the accepted Preview-bound async Layer 2 authority contract or treating operational maturity as consequential acceptance closure.

## Current implementation

- PR #72 merged as `652c47326a99f3ce10f5b7479af30c4bed6d7391`.
- Acceptance-infrastructure repair PR #80 merged as `84cab275d36ff7709945ce4e7d241bd03844258e`.
- UQ acceptance-contract reconciliation PR #81 merged as `90f97a9ba2cbaee3eabb29506c457a6cee870427`.
- Pilot PR #79 remains the browser-visible runtime-operations/efficiency follow-on and is not merge-ready until release-currentness/version metadata is reconciled.
- Visible accepted release remains v2.15.78 until a browser-visible follow-on is accepted and versioned.

## Observability corrections deployed

Forward-only runtime migrations:

1. Runtime ledger `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`; repository source `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`.
2. Runtime ledger `20260913102217 cf_093_scheduled_runtime_metrics_read`; repository source `20260913102500_cf_093_scheduled_runtime_metrics_read.sql`.

Neither identity is to be renamed, retimestamped, removed or rewritten.

The terminal timestamp guard applies only when a `layer2_discovery` job reaches a terminal state without an existing `completed_at`. Historical rows are not backfilled.

The rank-4 `jobs_runtime` read returns only operationally safe derived fields. Runtime proof confirmed authenticated rank-4 succeeds, authenticated rank-3 fails with `42501 pipeline_operator role required`, anon/public cannot execute the private helper, malformed `limit` input degrades to the bounded default, and raw payload/result/error text/URLs/storage paths/secrets are not returned. A bounded recent-50 deployed wrapper proof measured about `21.4 ms` execution.

## Runtime baseline and first real post-fix evidence

Initial pre-tuning measurements:

- `layer2_acquisition_v2` succeeded: 773 jobs; average queue wait about `0.049 s`; average execution about `1.44 s`; median about `1.06 s`.
- historical `layer2_discovery` completed: 111 jobs had no trustworthy execution duration because `completed_at` was missing.
- failed discovery sample: average execution about `62.22 s`, median about `64.61 s`.
- three-day failed-discovery comparison baseline: 25 failed jobs / 111 processed / `1244.86 s` measurable execution / weighted throughput about `5.35 records/min`.

The corrected deployed-main UQ run produced the first genuine post-fix discovery telemetry. All terminal jobs now carried real `completed_at` values:

| Job | Processed | Failed | Execution |
|---|---:|---:|---:|
| `b0dc9508-2a4b-42c8-bc3a-11a8ef359a84` | 33 | 33 | ~60.61 s |
| `b1412cd6-fba9-4047-bbf7-44ad6998ce52` | 41 | 41 | ~60.56 s |
| `3ef59638-039f-4700-9ab9-2b778f93d64a` | 42 | 42 | ~56.01 s |
| `2ae49a3b-0e31-4310-9a64-4aa5d633346d` | 10 | 10 | ~14.53 s |

The four worker jobs are fairness/chunk continuation, not four attempts per course. Exact-token reconciliation proves all **42 UQ discovery courses received exactly three governed attempts**, matching profile retry `max_attempts=3`, and then required operator review. No successful deterministic handoff occurred.

## Corrected deployed-main UQ acceptance

Workflow `34753552186` on exact Pilot main `90f97a9b...` is **PASS for the authenticated Preview -> Run Now initiation contract**. It proves the acceptance infrastructure repair worked and that the deployed-main browser path can perform governed Preview and consequential dispatch initiation.

The corresponding Preview job/token is `b0eb7e77-d31a-4cb7-b187-8226445a1b7c`.

Current authoritative UQ scope truth:

- scoped/catalogue courses: **382**;
- queueable: **251**;
- actionable discovery: **42**;
- fresh terminal-negative: **89**;
- invariant: **251 + 42 + 89 = 382**;
- executable Preview: true;
- Preview-bound async discovery: true.

The exact async binding persisted 382 sync IDs, 42 discovery IDs, identity fingerprint `ac308149eae5c818f8939566f39431ec` and queueable fingerprint `55df05826882ef427632b510bae5d7ec`.

The workflow PASS is **not end-to-end consequential acceptance closure**. Downstream discovery exhausted all 42 courses at three attempts each and never reached deterministic Layer 2 handoff. `CF-CHG-20260910-093` therefore remains REOPENED.

## Provider-path blocker

The UQ discovery failures are operational/provider-health failures, not Preview/authority failures.

Current evidence:

- direct-http returns HTTP 200 but does not expose a recognised qualified program link for the affected searches;
- Firecrawl also returns HTTP 200 but the required program-link extraction remains unresolved;
- scrape-do then returns HTTP 401 and correctly stops the route because 401 is not an authorised fallback condition;
- ScraperAPI is enabled but has no governed Vault secret reference.

Scrape-do configuration is unchanged: enabled scraper-api adapter, query-param auth field `token`, Vault reference present. The same configuration/secret produced **224 successful 2xx responses through 2026-09-13 07:45:50 UTC**, then began returning 401 at **07:46:03 UTC**, with no provider configuration or Vault-secret update at that boundary. This isolates the current scrape-do issue as a provider credential/account-health condition rather than an adapter-format regression.

Do not add 401 to fallback merely to improve throughput. Do not invent, expose or substitute credentials. Provider/account remediation must occur through the governed provider/secret lifecycle.

## First-party discovery investigation

Public UQ evidence confirms current official `/study-options/programs/...` pages still exist for some related programs, while some failed CRICOS records are historical/exit-award structures. Nearest-title matching is therefore unsafe and must not be used as a shortcut.

The current UQ first-party search profile has no `zero_result_markers`. The worker only treats a no-link first-party search as a governed terminal negative when a profile-qualified zero-result marker is observed. Without such evidence, it correctly continues/fails closed rather than manufacturing a retirement result.

No profile/parser change is authorised yet. A future correction requires direct evidence of the current UQ first-party search response shape and an identity-safe deterministic rule.

## Read-path optimisation evidence

Before deployment, the equivalent recent-50 metrics plan projected wide Job rows and measured roughly `112.5 ms` execution / `146.8 ms` planning in the initial run. Narrowing the projection to required operational fields reduced projected row width from about `1477` bytes to about `60` bytes and the measured comparison run to about `2.6 ms` execution / `5.0 ms` planning. Cache warmth may contribute; do not attribute the whole delta solely to projection narrowing. The deployed authenticated wrapper later measured about `21.4 ms` execution and is the runtime reference point.

## PR #79 release gate

Runtime Health is browser-visible. PR #79 currently retains package `0.1.5` and visible v2.15.78 release metadata. Current project instructions require visible UI version correlation, so PR #79 must reconcile release metadata/version before merge and then rerun exact-head CI/review. Already-deployed observability migrations do not by themselves authorise promoting the browser-visible release.

## Exact next actions

1. Treat workflow `34753552186` as **Preview/dispatch PASS but downstream discovery BLOCKED**, not CF-093 closure.
2. Resolve scrape-do account/credential health through the governed provider/secret lifecycle, or separately prove an identity-safe first-party UQ discovery/zero-result correction.
3. Do not run RMIT as a substitute for an unresolved UQ provider-health failure unless the current acceptance contract explicitly permits it.
4. After provider/first-party recovery, run a fresh exact-main UQ Preview -> discovery -> deterministic Layer 2 -> Jobs/Evidence acceptance and prove the exact-token binding reaches handoff or an authorised terminal result.
5. Reconcile PR #79 release metadata/version, rerun exact-head CI/review, then merge only if clean.
6. Update REGISTER/RUNSHEET/CURRENT-STATE/FOLLOW-UPS from current-main truth when the acceptance blocker materially changes.

## Authority boundary

Do not weaken Layer 1 authority, Layer 2 deterministic Evidence truth, Layer 3 governance, Layer 4 human authority, Search/Publication separation, ACL/RLS/private-helper/service-role controls or Preview-bound continuation semantics merely to obtain a test or performance PASS.

`CF-CHG-20260910-093` remains reopened until current deployed-main consequential acceptance and final governance reconciliation are complete.