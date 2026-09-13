# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** REOPENED — IMPLEMENTATION MERGED; REPLACEMENT CONSEQUENTIAL ACCEPTANCE / RUNTIME-OPS HARDENING ACTIVE  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-13 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Visible accepted release:** v2.15.78  
**Accepted Pilot main before follow-on:** `9b450f9ebb48de70bdcdd409f24909ba39cc3a85`

## Objective

Provide a governed Scheduled Tasks control plane for AU Course Facts while preserving CourseFinder authority boundaries: Layer 1 identity/regulatory authority, deterministic Evidence-preserving Layer 2, governed Layer 3 interpretation, Layer 4 human resolution, and separate Search/Publication admission.

## Current repository/runtime truth

PR #72 (`CF-093: complete Preview-bound async Layer 2 discovery`) is **MERGED**. Merge commit is `652c47326a99f3ce10f5b7479af30c4bed6d7391`; Pilot `main` then advanced to `9b450f9ebb48de70bdcdd409f24909ba39cc3a85` to initiate replacement UQ acceptance.

PR #72 retained the explicit narrow async-discovery authority contract:

- same-actor Preview before consequential dispatch;
- exact Preview token/fingerprint/binding/identity provenance;
- policy/profile/route/URL/credential/budget qualification;
- deterministic Layer 2 and Evidence truth;
- generic async discovery remains fail-closed outside the explicitly Preview-bound governed continuation;
- no generic scheduler Layer 3/Layer 4 automation;
- no implicit Search/Publication consequence.

Applied Pilot migration history remains immutable and forward-only through `20260913082845 cf_093_final_review_authority_retry_reconcile` plus the runtime-operations migrations listed below. No applied migration may be renamed, retimestamped, removed or rewritten.

## Runtime-operations follow-on

Pilot PR #79 (`CF-093 follow-on: Scheduled Tasks runtime operations and efficiency`) is open on branch `m245/cf093-runtime-ops-efficiency-20260913`.

Current reviewed/runtime work includes:

- read-only Scheduled Tasks Runtime Health;
- truthful queue wait, execution and total duration with missing values left unavailable;
- forward-only `layer2_discovery` terminal timestamp correction;
- governed rank-4 `jobs_runtime` metrics read;
- processed/failed counts and throughput only where runtime data supports them;
- Evidence produced and verified kept separate rather than manufacturing an acceptance/yield metric;
- recorded retry exhaustion/dedupe and sanitised failure classes where present;
- no raw payload/result/error text, URLs, storage paths or secrets exposed to the browser.

Deployed Pilot runtime identities:

- `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability` — repository source `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`;
- `20260913102217 cf_093_scheduled_runtime_metrics_read` — repository source `20260913102500_cf_093_scheduled_runtime_metrics_read.sql`.

The differing repository filename/deployment ledger timestamps are retained as separate immutable identities; do not rewrite either history.

Runtime ACL proof confirms authenticated rank-4 access succeeds, authenticated rank-3 is rejected with `42501 pipeline_operator role required`, and `anon/public` cannot execute the private metrics helper. The deployed recent-50 metrics wrapper measured about `21.4 ms` execution in the bounded proof.

## Provider/runtime evidence

Queue scheduling is not the primary observed bottleneck. Discovery/provider acquisition is.

Measured UQ provider-path evidence includes fast direct HTTP successes plus materially slower Firecrawl/scrape-do/ZenRows fallback paths. Fifty scrape-do HTTP 401 failures were observed in the measured window. ScraperAPI also has credential-unavailable evidence on relevant fallback attempts.

A provider 401 remains an authentication/provider-health failure. It must not be added to fallback semantics merely to improve throughput. Provider/credential remediation must use the governed provider/secret lifecycle without exposing secrets or weakening fail-closed behaviour.

No legitimate natural `layer2_discovery` job has yet occurred after deployment of the terminal timestamp correction, so post-change successful discovery throughput remains **not yet observed**. Do not manufacture a run to create performance evidence.

## Replacement consequential acceptance recovery

After PR #72 merged, Pilot `main` added `CF-093 UQ Acceptance Dispatcher`. Workflow run `34749286102` on exact main `9b450f9e...` remains queued after three attempts with **zero jobs materialised**. It is acceptance-infrastructure evidence only and is not a PASS.

The dispatcher also delegated to a corrective acceptance workflow that still targeted the old PR #72 branch-preview URL, which would not prove deployed-main currentness.

Pilot PR #80 (`CF-093: repair exact-main UQ acceptance trigger`) therefore owns the smallest-safe UAT recovery:

- direct acceptance trigger on merge to `main`;
- browser target `https://coursefinder-pilot.techm.workers.dev`;
- exact workflow SHA checkout;
- normal authenticated Admin/PIM Preview -> Run Now path;
- evidence artifact retention;
- no DB/runtime authority, routing, retry, Layer 3/4, Search or Publication semantic change.

PR #80 must pass its review/CI gate before merge. After merge, the resulting direct deployed-main UQ acceptance run becomes the authoritative replacement closure evidence.

## Release-currentness gate for PR #79

PR #79 contains browser-visible Runtime Health UI. The branch currently retains package `0.1.5` / visible v2.15.78 metadata. `PROJECT_INSTRUCTIONS.md` requires browser-visible changes to correlate to the visible UI version. Therefore PR #79 is **not merge-ready** until release-currentness metadata is reconciled and the resulting exact head is revalidated/reviewed.

Do not promote a new visible release merely because the runtime migrations are already deployed; the version bump belongs to the accepted browser-visible merge.

## Current closure gates

CF-CHG-20260910-093 remains **REOPENED**. The following are required before CLOSED/PASS:

1. PR #80 exact-head CI/review clean and merge of the direct deployed-main acceptance trigger.
2. New deployed-main UQ Preview -> dispatch -> Preview-bound discovery continuation -> deterministic Layer 2 -> Jobs/Evidence proof.
3. Same-token replay/dedupe/cancel/authority validation and proof of zero generic Layer 3/Layer 4 auto-approval and zero implicit Search/Publication side effects.
4. Bounded RMIT proof only if UQ is clean and still required by the current acceptance contract.
5. PR #79 release-currentness reconciliation, exact-head validation/review and merge only when its browser-visible gate is clean.
6. Observe legitimate post-fix discovery executions before making throughput/concurrency/batch/retry optimisation claims.
7. Reconcile Admin continuity and Change Control to the final merged/deployed truth.

Codex remains deferred assurance where usage is unavailable and must not be represented as completed. Gitar remains the active exact-head reviewer for current material follow-on heads.

## Rollback / recovery

- Never rewrite applied migration history.
- Database rollback is forward-only through a new migration.
- If a scope or continuation cannot be proven server-enforceable, keep it disabled/fail-closed.
- Do not fabricate policy/profile/route/URL/credential/Evidence configuration for acceptance.
- UAT infrastructure corrections must not weaken the authority/data contract they are meant to prove.

**Current outcome:** implementation and source/runtime reconciliation are merged; CF-093 remains reopened for genuine deployed-main consequential acceptance and completion of the governed runtime-operations/release-currentness follow-on.