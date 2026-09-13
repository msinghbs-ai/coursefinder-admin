# M2.4.5 NEXT CHAT

## Active baseline — 13 September 2026

- Milestone: **M2.4.5 — Pre-Production Hardening**. M2.5 remains paused; Production is unchanged.
- Accepted visible PIM Admin release remains **v2.15.78**.
- Merged Pilot PR #72 remains immutable CF-093 implementation history.
- Active Pilot runtime-operations PR: **#79**, branch `m245/cf093-runtime-ops-efficiency-20260913`, exact current head **`3d6b6a90893cf12a7fef9346dcacd24d2ddd2e8f`**.
- Canonical Pilot tracker: issue #74.
- Active Admin governance PR: **#36**, branch `m245/cf093-runtime-ops-followon-20260913`. PR #34 is superseded/closed without merge and its carried-forward work must not be lost.
- Admin governance tracker: issue #35.
- `CF-CHG-20260910-093` remains **REOPENED**. Runtime-efficiency work does not close consequential acceptance.
- Codex remains deferred assurance only. Gitar is the active reviewer.

## Pilot PR #79 accepted candidate state

Exact head `3d6b6a90893cf12a7fef9346dcacd24d2ddd2e8f` contains:

1. read-only Scheduled Tasks **Runtime Health** UI;
2. truthful queue-wait/execution/total-duration calculation with missing values shown as `Unavailable`;
3. explicit visibility of terminal Jobs missing completion timestamps;
4. Jobs/Evidence follow-through while preserving existing search, personalised columns/order, owner/creator, schedule edit, Run on Demand and Layer navigation;
5. targeted Runtime Health contract coverage;
6. forward-only migration source `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql` plus targeted contract test.

Exact-head checks:

- CF-093 Fresh Reconstruction run `34750872835` — **PASS**.
- CF-093 Targeted Recovery run `34750872803` — **PASS**.
- Pilot Frontend Build run `34750872795` — **PASS**.
- Cloudflare exact-head preview — **PASS**.
- Gitar exact-head response — **Approved / no issues**.

## Deployed Pilot runtime correction

Pilot Supabase: `fxcwkweaxjtknorudmwp`.

- Deployed migration ledger identity: **`20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`**.
- Repository migration filename remains **`20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`**. Preserve both identities; do not rename, retimestamp, delete or rewrite applied history.
- Live trigger `pipeline.layer2_discovery_terminal_timestamp_v1` stamps `completed_at=clock_timestamp()` only when a `layer2_discovery` Job enters a terminal state without an existing completion timestamp.
- Historical completed discovery rows remain unmodified. Their missing completion times remain unknown.
- Rollback-only proof created a synthetic terminal discovery Job inside one transaction, verified a real completion timestamp and measurable `2.009 s` duration, then rolled back. No ingestion, Evidence or canonical mutation occurred.
- Reversion, if required, must be a new forward-only migration that removes the trigger/function.

## Runtime performance baseline

Initial direct runtime evidence:

- Deterministic `layer2_acquisition_v2` successes: 773 Jobs; average queue `0.049 s`; average execution `1.44 s`; median `1.06 s`.
- Before correction, 111 `layer2_discovery` Jobs were terminal `completed` but all 111 lacked `completed_at`, so completed-run duration was not trustworthy.
- Three-day failed-discovery baseline: 25 Jobs / 111 processed / `1244.86 s` measurable execution / weighted throughput **`5.35 records/min`**.
- Queue scheduling is not the primary bottleneck; discovery/provider acquisition is.

UQ profile `au-uq-course-catalogue` provider evidence over the measured three-day window:

- direct-http: 912 successful attempts, ~`1047.8 ms` average;
- Firecrawl extraction failure: 201, ~`2293.7 ms` average;
- scrape-do extraction failure: 149, ~`4175.5 ms` average;
- ZenRows extraction failure: 141, ~`5621.9 ms` average;
- scrape-do HTTP 401: 50 attempts, ~`236.9 ms` average;
- ScraperAPI is configured later in the chain but relevant runtime attempts report credential unavailable.

Do **not** add 401 to fallback merely to improve throughput. It is an authentication/provider-health failure and remains fail-closed until corrected through the governed provider/secret lifecycle.

## Preserved authority/security boundary

- Layer 1 authority and identity remain unchanged.
- Layer 2 acquisition remains deterministic/Evidence-preserving and policy/profile/route qualified.
- Mandatory actor-bound Preview/dispatch contracts remain unchanged where applicable.
- Layer 3 remains Evidence/profile/model/revalidation governed; no generic L3 automation.
- Layer 4 remains human-resolution authority; no generic L4 automation.
- Search and Publication remain separately governed; no implicit publication.
- rank/ACL/RLS/private-helper/service-role boundaries remain intact.
- provider secrets must remain server/Vault-side and must not appear in Admin/browser output.
- applied migration history is immutable and forward-only.

## Exact next operational gate

1. Observe the next **legitimate/natural** `layer2_discovery` terminal Job and confirm it now carries a real `completed_at`. Do not dispatch consequential work solely to make this proof green.
2. Extend the governed rank-4 Jobs read contract only if necessary to expose trustworthy `processed`, selected/accepted/failed, throughput, failure class, retry exhaustion/dedupe and Evidence-yield metrics. Preserve secret/private Evidence boundaries and distinguish unavailable from zero.
3. Surface provider-health/failure classes operationally so an operator can distinguish route extraction failure from authentication/credential failure.
4. Remediate scrape-do/ScraperAPI provider health through the governed credential/provider lifecycle; do not weaken 401/fallback semantics.
5. Collect enough post-correction discovery history for a genuine **Before → Change → After → Result** comparison.
6. Only after that evidence exists consider batch/chunk size, concurrency, retry bounds/fairness, dedupe or provider-route efficiency changes.
7. Keep CF-CHG-20260910-093 closure separate and perform consequential acceptance only on a legitimate current policy-qualified target.

## Immediate recovery pickup

> Continue CourseFinder M2.4.5 from repository/runtime truth. Read `PROJECT_INSTRUCTIONS.md`, `docs/README.md`, M2 Standing Instructions/addenda, the troubleshooting protocol, current RUNSHEET/CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT, CF-093 runtime-ops follow-on and overlapping Change Controls. Pilot PR #79 current exact head is `3d6b6a90893cf12a7fef9346dcacd24d2ddd2e8f`; exact-head Fresh Reconstruction `34750872835`, Targeted Recovery `34750872803`, Frontend Build `34750872795`, Cloudflare preview and Gitar are green. Pilot runtime has forward-only deployed migration `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`; repository source is `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`. Preserve both identities and all historical migrations. The telemetry defect is corrected and rollback-only proof passed; historical missing timestamps were not backfilled. Discovery/provider acquisition is the active bottleneck, with 50 measured scrape-do 401 failures and materially slower fallback providers. Do not weaken 401/fallback/security rules. First verify a natural post-migration discovery terminal timestamp, then expand the governed read surface for trustworthy counts/throughput and address provider health before tuning concurrency or batch size. CF-CHG-20260910-093 remains reopened and M2.5 remains paused.