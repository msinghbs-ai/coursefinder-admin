# M2.4.5 NEXT CHAT

## Active baseline — 13 September 2026

- Milestone: **M2.4.5 — Pre-Production Hardening**. M2.5 remains paused; no Production Supabase project exists.
- Active Change Control: **CF-CHG-20260910-093 — REOPENED**.
- Visible accepted release remains **v2.15.78**.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- PR #72 merged as `652c47326a99f3ce10f5b7479af30c4bed6d7391`.
- PR #80 merged as `84cab275d36ff7709945ce4e7d241bd03844258e`, repairing direct deployed-main UQ acceptance.
- PR #81 merged as `90f97a9ba2cbaee3eabb29506c457a6cee870427`, replacing stale UQ discovery-count literals with governed scope invariants.
- Pilot PR #79 remains open at the runtime-operations/efficiency follow-on; its browser-visible Runtime Health still requires release-currentness/version reconciliation before merge.
- Admin PR #36 is closed unmerged/superseded because its inherited history diverged from current main and contained stale governance assertions.
- Clean Admin PR #37 is the current-main governance reconciliation branch.

## Deployed runtime-operations state

Pilot runtime carries:

- `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`; repository source `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`.
- `20260913102217 cf_093_scheduled_runtime_metrics_read`; repository source `20260913102500_cf_093_scheduled_runtime_metrics_read.sql`.

Preserve runtime-ledger and repository-source identities separately; do not rewrite migration history.

`jobs_runtime` remains rank-4 only, rejects rank-3, denies anon/public helper execution, and does not expose raw payload/result/error text/URLs/storage paths/secrets. The deployed recent-50 wrapper proof measured about `21.4 ms`.

## Corrected deployed-main UQ acceptance

Authoritative workflow: **`34753552186`** on exact Pilot main `90f97a9b...`.

The workflow is **PASS for deployed-main authenticated Preview -> Run Now initiation**. It proves the repaired UAT path and the governed browser contract, but it is not end-to-end Layer 2 acceptance closure.

Current UQ scope:

- catalogue/scoped: **382**;
- queueable: **251**;
- actionable discovery: **42**;
- fresh terminal-negative: **89**;
- invariant: `251 + 42 + 89 = 382`;
- Preview-bound async discovery: true.

Preview token/job: `b0eb7e77-d31a-4cb7-b187-8226445a1b7c`.

Binding evidence:

- 382 sync IDs;
- 42 discovery IDs;
- identity fingerprint `ac308149eae5c818f8939566f39431ec`;
- queueable fingerprint `55df05826882ef427632b510bae5d7ec`.

## First genuine post-fix discovery telemetry

The UQ dispatch generated four bounded discovery worker jobs. Every terminal job now has a real `completed_at`, proving the observability correction in real consequential traffic:

- `b0dc9508-...`: 33 processed / 33 failed / ~60.61 s;
- `b1412cd6-...`: 41 / 41 / ~60.56 s;
- `3ef59638-...`: 42 / 42 / ~56.01 s;
- `2ae49a3b-...`: 10 / 10 / ~14.53 s.

Exact-token reconciliation proves all **42 courses received exactly 3 attempts**, matching governed retry `max_attempts=3`. The extra worker jobs are fairness/chunk continuation, not extra attempts per course.

No deterministic Layer 2 handoff occurred. The binding remained in operator-review/recovery state with no handoff started at the last check.

## Active blocker — provider / first-party discovery health

All UQ discovery courses ultimately failed. Current chain evidence:

- direct-http: HTTP 200 but no recognised qualified program link;
- Firecrawl: HTTP 200 but still no recognised qualified program link;
- scrape-do: HTTP 401, route correctly stops because 401 is not an authorised fallback;
- ScraperAPI: enabled but has no governed Vault secret reference.

Scrape-do had **224 successful 2xx responses through 07:45:50 UTC on 13 Sep 2026**, then switched to 401 at **07:46:03 UTC** with no provider-config or Vault-secret update at that boundary. Treat this as provider credential/account-health, not an adapter-format regression. Do not expose/manufacture credentials and do not add 401 to fallback merely to pass UAT.

Public UQ evidence confirms some current official program pages still exist, but several failed records are historical/exit-award structures. Nearest-title matching is therefore unsafe. The current UQ first-party profile has no qualified `zero_result_markers`; do not add markers or parser shortcuts until the current UQ search response shape is directly evidenced and identity-safe.

## Exact next gate

1. Keep CF-CHG-20260910-093 **REOPENED**: Preview/dispatch passes, downstream discovery/handoff does not.
2. Remediate scrape-do account/credential health through the governed provider/secret lifecycle **or** separately prove an identity-safe first-party UQ discovery/zero-result correction.
3. After recovery, rerun exact-main UQ Preview -> discovery -> deterministic Layer 2 -> Jobs/Evidence acceptance. Closure requires successful handoff or an authorised terminal outcome, not merely workflow PASS.
4. Do not use RMIT to conceal the unresolved UQ provider-health defect unless the current acceptance contract explicitly permits a replacement target.
5. Reconcile PR #79 browser-visible release metadata/version, then rerun exact-head CI/Gitar before merge.
6. Update REGISTER/RUNSHEET/CURRENT-STATE/FOLLOW-UPS when the active blocker materially changes.

## Authority/security boundary

Preserve Layer 1 authority, deterministic Evidence-preserving Layer 2, exact Preview-bound async continuation only where explicitly governed, Layer 3 Evidence/profile/model/revalidation governance, Layer 4 human authority, Search/Publication separation, rank/ACL/private-helper/service-role boundaries and immutable forward-only migration history. Missing telemetry remains unknown, never zero by assumption.

Codex remains deferred assurance where unavailable and must not be represented as completed. Gitar remains the active exact-head reviewer for material follow-on heads.