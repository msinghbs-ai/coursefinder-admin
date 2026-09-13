# M2.4.5 NEXT CHAT

## Active baseline — 14 September 2026 AEST

- Milestone: **M2.4.5 — Pre-Production Hardening**.
- M2.5 remains paused; no Production Supabase project exists.
- Active Change Control: **CF-CHG-20260910-093 — REOPENED for final runtime/governance/release follow-on**.
- Visible accepted release remains **v2.15.78** until candidate v2.15.79 passes merge + deployed-currentness/UAT.
- Accepted/recovery Pilot main: **`7cf5cc72296ca82e6e026606a61f449ede4ead45`**.
- Accepted package baseline: **0.1.5**.
- Candidate PR #85: **v2.15.79 / package 0.1.6** on `m245/cf093-admin-dispatcher-tuning-20260914`.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Admin PR #37 remains the governance reconciliation vehicle.

## Release/version governance correction

The PR #85 release-currentness failure was classified as a governance/implementation-model defect: browser release identity had been independently repeated across the shell, retained release history, currentness overlay, HTML title, package metadata and hard-coded tests.

The corrected model is now governed by `docs/01-governance/coursefinder-release-version-control-recovery-v1.0.md`, selected as CURRENT by `docs/README.md`.

Pilot release contract:

- `src/release-manifest.js` is the **single candidate release authority**;
- current candidate: **v2.15.79 / package 0.1.6**;
- `PREVIOUS_ACCEPTED_RELEASE` explicitly records **v2.15.78 / package 0.1.5 / Pilot `7cf5cc72296ca82e6e026606a61f449ede4ead45`**;
- `src/release-currentness-entry.js` imports the manifest and renders candidate title/pill/release note;
- `index.html` is version-neutral at bootstrap;
- `src/mature-main.jsx` and `src/pim-version-entry.js` remain the last accepted v2.15.78 fallback/history until v2.15.79 is accepted;
- `scripts/verify-release-contract.mjs` fails any manifest/package/changelog/recovery-baseline drift;
- `npm run release:verify` runs before `dev`, before `build` and in Release History Contract CI;
- deployed release-notes UAT now derives its expected version/title from the manifest rather than a hard-coded historical release;
- legacy source contracts that assumed `shell literal == current release` have been moved to the accepted-fallback/candidate-manifest model.

Do **not** promote v2.15.79 into retained accepted history until it has merged, deployed and passed the nominated deployed-currentness/UAT gate.

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

PR #85 adds Administration → Scraper Config dispatcher tuning and comparable run metrics while preserving provider/security/authority boundaries.

Runtime/backend proof already established:

- rank-4 sanitized metrics read allowed; lower rank/anonymous denied;
- rank-5+ tuning only;
- governance reason mandatory at Edge and DB boundary;
- audit records actual changed fields, actor, before/after and reason;
- provider credentials/routing remain separate controls;
- existing running batches retain immutable policy snapshots;
- ordinary transport cap 4, scraper-first cap 2, pg_net ceiling 120 seconds remain enforced;
- tuning metrics read improved from about 1.40 s with temp spill to about 256 ms without temp spill;
- no identity/Evidence/Layer 3/Layer 4/Search/Publication boundary was weakened.

Latest exact-head release-recovery checks at `6dbcd01b06480bcaf72886c196970dbd4fc334b5` were all PASS:

- CF-093 Fresh Reconstruction `34787548064`;
- Release History Contract `34787548085`;
- CF-093 Targeted Recovery `34787548061`;
- Pilot Frontend Build `34787548078`;
- Cloudflare exact-head preview PASS.

Further legacy-test cleanup advanced PR #85 after that head; always re-read the current PR head/checks before merge.

## Six-university discovery baseline

Six-university Preview-bound discovery is terminal at **1,676 / 1,676 distinct courses accounted for**. Firecrawl completed the discovery wave; ZenRows fallback was not invoked. Do not relax identity matching to improve yield.

Key identity-quality signal remains Flinders: 10 selected, 237 not found, 38 ambiguous and 176 identity mismatches across a 461-course scope.

## RMIT deterministic Layer 2 recovery

RMIT batch `74b4b16f-20f0-4b61-a9e0-632d824f001a` exposed the 120-second transport-budget defect. PR #84 bounded ordinary runner waves to four items. Same-batch requests 6167 and 6168 both returned HTTP 200, processed four items and self-generated continuations. Continue the same batch only; do not create a duplicate batch.

Hourly metrics automation remains enabled and should continue collecting meaningful dispatcher/provider/Evidence/policy measurements without auto-changing configuration.

## Separate read-path reliability follow-up

Earlier deployed UAT `34756359424` saw intermittent `admin_read` HTTP 500 responses under large concurrent load. Read-only profiling later showed `admin_dashboard_maturity()` about 107 ms and `admin_layer_status_summary()` about 233 ms in isolation. Keep this as a reliability follow-up until deployed UAT proves it clear; do not weaken read/security contracts.

## Exact next gate

1. Re-read current PR #85 head, exact-head CI, Cloudflare preview and Gitar result after the release-contract/legacy-test cleanup.
2. If all required exact-head checks are green, merge PR #85.
3. Verify post-merge main build/Cloudflare and run nominated deployed release-currentness/release-notes + functional UAT.
4. Only after deployed acceptance: declare **v2.15.79 accepted**, promote it into retained release history, and make it the previous-accepted baseline before opening any v2.15.80 candidate.
5. Merge Admin PR #37 only after its exact-head governance review confirms the new release/version governance and final Pilot truth.
6. Reconcile CURRENT-STATE/RUNSHEET/FOLLOW-UPS/REGISTER when v2.15.79 acceptance and CF-093 closure state genuinely change.
7. Keep M2.5 paused unless separately authorised.

## Authority/security boundary

Preserve Layer 1 identity/regulatory authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model gating, Layer 4 human authority, Search/Publication separation, rank/ACL/RLS/private-helper/service-role boundaries and immutable forward-only migration history. Release recovery must never be used to rewrite migration history or bypass runtime authority controls.
