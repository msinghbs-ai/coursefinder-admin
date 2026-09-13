# M2.4.5 NEXT CHAT

## Active baseline — 14 September 2026 AEST

- Milestone: **M2.4.5 — Pre-Production Hardening**.
- M2.5 remains paused; no Production Supabase project exists.
- Active Change Control: **CF-CHG-20260910-093 — REOPENED for final runtime/governance/release follow-on**.
- Visible accepted release remains **v2.15.78** until candidate v2.15.79 passes merge + deployed-currentness/UAT.
- Current Pilot main: **`854727e09c473d7ebc71c070fdb75da0a458c2bb`**.
- Accepted recovery baseline remains **`7cf5cc72296ca82e6e026606a61f449ede4ead45` / v2.15.78 / package 0.1.5** until deployed acceptance changes that state.
- Candidate v2.15.79 implementation PR #85 is merged; post-merge recovery commit `854727e09c473d7ebc71c070fdb75da0a458c2bb` is now on `main`.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Admin PR #37 remains the governance reconciliation vehicle.

## Release/version governance correction

The PR #85 release-currentness failure was classified as a governance/implementation-model defect: browser release identity had been independently repeated across the shell, retained release history, currentness overlay, HTML title, package metadata and hard-coded tests.

The corrected model is governed by `docs/01-governance/coursefinder-release-version-control-recovery-v1.0.md`, selected as CURRENT by `docs/README.md`.

Pilot release contract:

- `src/release-manifest.js` is the **single candidate release authority**;
- candidate: **v2.15.79 / package 0.1.6**;
- `PREVIOUS_ACCEPTED_RELEASE` explicitly records **v2.15.78 / package 0.1.5 / Pilot `7cf5cc72296ca82e6e026606a61f449ede4ead45`**;
- `src/release-currentness-entry.js` imports the manifest and renders candidate title/pill/release note;
- `index.html` is version-neutral at bootstrap;
- `src/mature-main.jsx` and `src/pim-version-entry.js` remain the last accepted v2.15.78 fallback/history until v2.15.79 is accepted;
- `scripts/verify-release-contract.mjs` fails any manifest/package/changelog/recovery-baseline drift;
- `npm run release:verify` runs before `dev`, before `build` and in Release History Contract CI;
- deployed release-notes UAT derives its expected version/title from the manifest rather than a hard-coded historical release;
- legacy source contracts that assumed `shell literal == current release` were moved to the accepted-fallback/candidate-manifest model.

Do **not** promote v2.15.79 into retained accepted history until deployed acceptance passes.

## v2.15.78 recovery point

If browser/application recovery is required, use the governed recovery document and verify all identifiers before restoring:

| Item | Recovery value |
|---|---|
| Visible release | v2.15.78 |
| Package | 0.1.5 |
| Accepted Pilot source | `7cf5cc72296ca82e6e026606a61f449ede4ead45` |
| Release title | Governed Scheduled Tasks target builder |

Application rollback does **not** authorise rewriting/rolling back applied Supabase migrations. Database/runtime compatibility remains a separate forward-only recovery concern.

## PR #85 — dispatcher tuning and run metrics

PR #85 merged as `250b4c3e5cc319556c6f3b178129bfcedd6521b3` and added Administration → Scraper Config dispatcher tuning and comparable run metrics while preserving provider/security/authority boundaries.

Runtime/backend proof established:

- rank-4 sanitized metrics read allowed; lower rank/anonymous denied;
- rank-5+ tuning only;
- governance reason mandatory at Edge and DB boundary;
- audit records actual changed fields, actor, before/after and reason;
- provider credentials/routing remain separate controls;
- existing running batches retain immutable policy snapshots;
- ordinary transport cap 4, scraper-first cap 2, pg_net ceiling 120 seconds remain enforced;
- tuning metrics read improved from about 1.40 s with temp spill to about 256 ms without temp spill;
- no identity/Evidence/Layer 3/Layer 4/Search/Publication boundary was weakened.

## Post-merge deployed UAT regression — current blocker

Pilot `main` advanced to **`854727e09c473d7ebc71c070fdb75da0a458c2bb`** with `CF-093: recover deployed release-currentness UAT routing` after PR #85 merged.

The resulting **CourseFinder Deployed UAT** run **34788361028** nevertheless completed **FAIL** on 13 September 2026 UTC:

- preflight governed UAT credentials: PASS;
- Worker deployment settle: PASS;
- Chromium/setup/suite resolution: PASS;
- deployed governed desktop validation: **FAIL**;
- mobile gate: skipped because desktop failed;
- UAT evidence upload and commit-status publication: PASS.

Therefore **v2.15.79 remains unaccepted**. Treat this as a deployed-UAT/runtime-control regression requiring diagnosis, not as permission to weaken UAT, ACL/RLS, release-currentness, identity, Evidence or authority contracts. Re-read uploaded UAT evidence/logs and determine the exact failing contract before another release-state change.

## Six-university discovery baseline

Six-university Preview-bound discovery is terminal at **1,676 / 1,676 distinct courses accounted for**. Firecrawl completed the discovery wave; ZenRows fallback was not invoked. Do not relax identity matching to improve yield.

Key identity-quality signal remains Flinders: 10 selected, 237 not found, 38 ambiguous and 176 identity mismatches across a 461-course scope.

## RMIT deterministic Layer 2 terminal baseline

RMIT batch `74b4b16f-20f0-4b61-a9e0-632d824f001a` is terminal `partial` at **263 / 263 processed**, **263 Layer 3-required**, **0 blocked/failed**.

Latest comparable runtime measurements:

- average Job queue wait: about **59.5 ms**;
- average Job execution: about **16.78 s**;
- provider response p50/p95: **9.384 s / 24.857 s**;
- extraction p50/p95: **1.673 s / 2.400 s**;
- fields resolved: **935 / 1,307 (71.5%)**;
- retries: **2**;
- item-level Evidence counter: **526**;
- persisted Evidence rows linked to RMIT jobs: **789 total** = 263 raw JSON + 263 extraction-input + 263 screenshot; **0 verified / 789 unreviewed**;
- final self-continuation response IDs **6194–6228** were HTTP 200, wave size 4, with the last response processing the final single item;
- no ZenRows fallback occurred for this deterministic run.

The evidence supports provider/source latency as the dominant cost; hold dispatcher settings steady until another legitimately comparable large governed run exists.

## Provider budget / control baseline

Current September telemetry:

- Firecrawl: **6,629 / 11,000 attempts/units recorded**, 6,091 succeeded, 538 non-success; nominal headroom **4,371**, usable headroom before the 250-unit stop reserve about **4,121**;
- Firecrawl provider controls remain concurrency **5**, rate **30/min**, timeout **90 s**;
- ZenRows: **188 monthly attempts**, no new fallback associated with the RMIT completion;
- current deterministic policy snapshot remains `batch_size=10`, `max_concurrency=1`, `stale_after_minutes=30`, `max_paid_attempts_per_entity=2`, `direct_then_best_value`, stop-on-identity-mismatch enabled.

Do not auto-change these settings from monitoring data alone.

## Runtime load / admin_read follow-up

Latest 24-hour Job counts sampled after RMIT completion: **153 completed, 276 succeeded, 13 failed**, with no running/queued Layer 2 batch remaining from RMIT/Curtin/Flinders. No recent Job error text matched `admin_read`, dashboard or layer-status failures in the latest six-hour sample.

Earlier deployed UAT `34756359424` saw intermittent `admin_read` HTTP 500 responses under large concurrent load. Read-only profiling later showed `admin_dashboard_maturity()` about 107 ms and `admin_layer_status_summary()` about 233 ms in isolation. The new deployed-UAT failure means read-path reliability cannot yet be declared cleared even though recent Job error text is quiet.

## Exact next gate

1. Inspect deployed UAT run `34788361028` evidence/logs and identify the exact desktop validation failure on `854727e09c473d7ebc71c070fdb75da0a458c2bb`.
2. Preserve v2.15.78 as accepted/recovery baseline until a subsequent nominated deployed UAT passes.
3. Reconcile current PR #79 against current `main` before any merge; do not let its older branch baseline overwrite merged PR #85/release-currentness work.
4. Keep collecting comparable dispatcher/provider/Evidence metrics only when a new governed Layer 2 run exists; do not create synthetic load merely for measurement.
5. Merge Admin PR #37 only after exact-head governance review reflects final Pilot/runtime truth.
6. Reconcile CURRENT-STATE/RUNSHEET/FOLLOW-UPS/REGISTER when v2.15.79 acceptance and CF-093 closure state genuinely change.
7. Keep M2.5 paused unless separately authorised.

## Authority/security boundary

Preserve Layer 1 identity/regulatory authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model gating, Layer 4 human authority, Search/Publication separation, rank/ACL/RLS/private-helper/service-role boundaries and immutable forward-only migration history. Release recovery must never be used to rewrite migration history or bypass runtime authority controls.
