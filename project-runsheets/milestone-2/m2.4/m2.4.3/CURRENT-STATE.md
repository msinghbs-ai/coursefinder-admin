# M2.4.3 Current State

**Status:** CLOSED / PASS — M2.4.3 ACCEPTED
**Updated:** 30 August 2026

## A15
- Change: CF-CHG-20260829-046.
- Target cohort: 52 AU + 8 NZ Provider profiles.
- UQ accepted proof: 8 first-party International Regional Manager territory assignments.
- Provider detail UI: implemented.
- PIM release: v2.15.10.
- Apollo adapter: implemented, Pilot credential absent; non-blocking.
- Current advisors: Security 135 INFO/0 WARN/0 ERROR; Performance 171 INFO/0 WARN/0 ERROR.
- Corrected targeted UAT: PASS `33227565016`.

## Quality rules
- first-party > governed manual > licensed enrichment;
- actionable row requires institutional email/phone or named person + territory;
- generic/noisy rows are rejected, retained historically;
- no personal-email/phone reveal from licensed enrichment;
- contact data cannot mutate Layer 1 identity/Search/Publication.

## Active rollout
Continue sequential nonce-backed batches until no Provider contact profile remains with `last_run_at is null`.


## A15 full-cohort freeze checkpoint

- 60/60 governed AU/NZ contact profiles attempted and successful.
- 0 current contact-profile errors.
- 31 current accepted contacts across 11 Providers.
- 17 territory-assigned current contacts.
- 30 contacts with institutional email; 18 with public work phone.
- 45 rejected historical/noisy observations retained for provenance.
- Direct HTTP: 319 attempts, 154 success, 165 failure/fallback, avg 599.41 ms, p95 1,944.5 ms, 0 vendor units.
- Firecrawl: 107/107 success, 107 page units, avg 3,996.84 ms, p95 7,132.2 ms.
- worker: `provider-contact-discover-scheduled-v1.3.2` / Edge v15.
- Wellington 410, CQU 403 and Bond Evidence-collision recovery cases are all terminal PASS.
- Security Advisor: 135 INFO / 0 WARN / 0 ERROR.
- Performance Advisor: 171 INFO / 0 WARN / 0 ERROR.
- Apollo remains configuration-blocked because `APOLLO_API_KEY` is absent; no personal email/phone reveal is requested.
- remaining A15 gate: post-freeze deployed UAT chain and closure documentation.


## A15 acceptance-suite inclusion

Permanent A15 UAT is now included in all relevant deployed validation tiers:
- targeted A15 change validation;
- bounded integration desktop/mobile;
- final acceptance desktop/mobile.

Pilot workflow contract commit: `b0b00f3f26d1e07bc1adc69061b3b16f9125c565`.

This closes the prior governance gap where A15 was present in targeted/integration but omitted from the acceptance suite list.


## A15 integration nomination

A15 integration candidate `8a49a2652758784926d42bc6114ceb4270d2cdaa` is nominated against:
- functional freeze `f9e4e530462b49cf5a83ad8e0d5137631255028a`;
- acceptance-suite workflow fix `b0b00f3f26d1e07bc1adc69061b3b16f9125c565`.

Pilot must remain frozen until the integration desktop/mobile matrix is terminal.


## A15 bounded integration correction — 29 August 2026

Frozen first-party rollout remains:
- 52/52 AU profiles successful;
- 8/8 NZ profiles successful;
- 60/60 total successful;
- 0 current profile errors;
- 31 current first-party contacts across 11 Providers;
- 17 current territory/market-assigned contacts;
- 45 rejected/noisy historical observations retained.

First bounded integration:
- candidate `8a49a2652758784926d42bc6114ceb4270d2cdaa`;
- run `33230112004`;
- desktop PASS;
- mobile FAIL;
- sole failure: inherited A13 `evidence_detail` HTTP 500 remained unrecovered on both test attempts.

Diagnosis:
- direct role-checked `security.admin_evidence_detail` remained logically correct;
- 25-call proof before hardening: 25/25 success, avg ~375 ms, max ~7.2 s;
- `security.admin_evidence_related_visual` searched `pipeline.layer2_provider_attempts` by raw/html/screenshot Evidence IDs without indexes.

Corrective performance hardening:
- added partial indexes for `raw_evidence_id`, `html_evidence_id`, and `screenshot_evidence_id`;
- no read semantics, authority or UAT assertion changed;
- existing bounded 5xx-only browser retry remains unchanged;
- 25-call proof after hardening: 25/25 success, avg ~164 ms, p95 ~134 ms, max ~2.04 s;
- Performance Advisor improved to 170 INFO / 0 WARN / 0 ERROR;
- Security Advisor remains 135 INFO / 0 WARN / 0 ERROR.

Post-freeze Wellington transport proof was reconciled back to the accepted first-party team record:
- International Student Experience;
- `international-support@vuw.ac.nz`;
- `+64 4 463 5350`;
- source `https://www.wgtn.ac.nz/students/support/international/contact-us`.

Corrected targeted UAT on `f3cf5001e5ac506d5edbac324bfbf25d706d4858`: PASS, run `33240216793`.

Corrective bounded integration candidate:
- `1197099ccedacd5d7946e45400c7bb36fe1dad26`;
- desktop/mobile result pending at this checkpoint.

Do not nominate final acceptance until this exact corrective integration candidate is terminal PASS on both desktop and mobile.


## A15 current gate — final acceptance nominated

- frozen functional source: `f9e4e530462b49cf5a83ad8e0d5137631255028a`;
- acceptance-suite inclusion: `b0b00f3f26d1e07bc1adc69061b3b16f9125c565`;
- final corrected integration source: `70bd290154b7d5f16d8f04569b90b6074a239611`;
- bounded integration run `33240736705`: desktop PASS / mobile PASS;
- final acceptance marker: `f6741a0cc29c5fea236e85b9042f8079762c6993`.

Current disposition:
- rollout and contact-quality baseline remain frozen at 60/60 profiles, 31 current first-party contacts across 11 Providers, 17 territory/market contacts and 45 retained rejected/noisy observations;
- Apollo remains configuration-blocked/non-blocking;
- Search/Publication/Layer 1 authority remains unchanged;
- CF-CHG-046 cannot close until the final acceptance desktop/mobile matrix is terminal PASS and documentation/runtime/advisor state is reconciled.


## A15 closure checkpoint

A15 contact intelligence is CLOSED / PASS under CF-CHG-20260829-046.

Final accepted Pilot:
- `f6741a0cc29c5fea236e85b9042f8079762c6993`.

Final acceptance:
- run `33251745111`;
- resolved deployed UAT tier: `acceptance`;
- 17 permanent suites;
- 48/48 desktop PASS;
- 48/48 mobile PASS.

Showcase/authority mapping:
- Layer 1: Provider/Course identity and canonical Provider website authority only; A15 does not overwrite it.
- Layer 2: source of truth for captured international contact observations, source URL, Evidence, freshness, territory text/codes, acquisition route and provider telemetry.
- Admin Provider blade: primary operator showcase via **International contacts** with source/Evidence/freshness.
- Course blade: optional read-only Provider context only; must stay explicitly labelled Provider context, never Course truth.
- Layer 3: may consume governed A15 Evidence for interpretation/change intelligence, not canonical authority.
- Layer 4: operator review/resolution for ambiguous or changed contacts when required.
- Search/public website: no A15 admission authorised yet.
- Zoho/API: no A15 consumer admission authorised yet; expose only through a separately governed curated API contract.

M2.4.3 remains ACTIVE because core Layer 3 AI Operations Maturity and the source-pattern benchmark are not closed by A15 acceptance.


## Core Layer 3 maturity — active checkpoint

- Source-pattern benchmark blocker: **RESOLVED / PASS** under `CF-CHG-20260829-047`.
- Benchmark run: `089befcf-a2f2-42ec-ad03-7bfe02816e1b` — 4/4 provider + 3/3 control PASS.
- Pinned source-pattern model: `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`.
- Retry telemetry proved one malformed-output recovery; threshold was not lowered.
- `layer3-interpret`: Edge v4 / JWT enforced.
- `layer3-source-pattern-benchmark`: Edge v9 / one-time nonce governed.
- `layer3-provider-control`: Edge v2 / JWT enforced.
- Current advisor reconciliation after Layer 3 runtime changes returned no current Security or Performance findings.
- 155 current Layer 2 `layer3_required` items were available for deterministic Layer 3 Evidence selection at the rollback-only contract checkpoint.
- Rollback-only contract proof passed for Layer-2-resolved zero-call, unchanged-Evidence zero-call and explicit governed revalidation; no test interpretation rows were retained.
- First bounded integration `33254320472` failed only on two stale checked-in assertions; 42 tests passed and the new M2.4.3 suite itself passed.
- Corrective source `3b43f0a8cb4d1758225b139a773b118be372be30` reconciles those assertions and the migration filename to deployed version `20260829130640`.
- M2.4.3 remains **ACTIVE** pending corrective targeted → bounded integration desktop/mobile → final acceptance.

## Final acceptance nomination — 30 August 2026

- Final bounded integration source: `ea6077e8e443a4a43adbf9f3285dac3dd3e631fd`.
- Integration run `33276423521`: **PASS**.
- Resolved tier: `integration`, 15 permanent suites.
- Desktop: **45/45 PASS**.
- Mobile: **45/45 PASS**.
- Frontend build `33276423532`: **PASS**.
- Final acceptance marker commit: `3a8a31310ea7147016374d6c818d08034ba0be64`.
- Final acceptance UAT run: `33284867253` — **QUEUED at handoff**.
- Final acceptance frontend build: `33284867261` — **QUEUED at handoff**.
- Do not create another acceptance candidate unless this exact run fails for a source/runtime defect requiring a corrective change.
- If `33284867253` resolves `acceptance` and both desktop/mobile PASS, reconcile advisors/runtime/heads, close CF-CHG-20260829-047, mark M2.4.3 CLOSED/PASS, update Master Project Plan / Running Build / DB Architecture / Admin-PIM decisions as required, then and only then assess M2.4.4.
- If it fails, retain the run as immutable evidence, diagnose the exact failing suite, correct only the defect/contract drift, rerun targeted then bounded integration as required before nominating a new acceptance candidate.

## Final acceptance live handoff — 30 August 2026

- Pilot final acceptance marker: `3a8a31310ea7147016374d6c818d08034ba0be64`.
- CourseFinder Deployed UAT run: `33284867253` — **IN PROGRESS at handoff**.
- Pilot Frontend Build run: `33284867261` — **IN PROGRESS at handoff**.
- The acceptance workflow has resolved the marker-driven final gate and has entered the desktop validation step.
- Do not wait/retrigger while these runs are active.
- Next action is a single status reconciliation:
  1. if build PASS and acceptance run PASS with both desktop/mobile success, reconcile Pilot/Admin heads, Supabase migrations/Edges/jobs, Security/Performance Advisors, then CLOSE/PASS `CF-CHG-20260829-047` and M2.4.3;
  2. update Master Project Plan, Running Build, DB Architecture/Admin-PIM decisions and continuity docs;
  3. only after the closure commit, assess/create M2.4.4;
  4. if either run fails, retain immutable evidence and diagnose the exact failing suite before any new candidate.

## Acceptance corrective checkpoint — 30 August 2026

- Final acceptance marker `3a8a31310ea7147016374d6c818d08034ba0be64`.
- Acceptance run `33284867253`: **FAIL** — desktop **50/50 PASS**; mobile **48 PASS / 1 persistent failure**, plus one performance retry that recovered.
- Frontend build `33284867261`: **PASS**.
- Persistent mobile failure was inherited Layer 2 provider-acquisition UAT observing `admin_read(operation=dashboard)` HTTP 500 on both attempts.
- Postgres logs at `2026-08-30T01:12:52.509Z` and `01:13:18.873Z` confirm both 500s were `canceling statement due to statement timeout`.
- No Layer 3 model, Evidence authority, prompt, threshold, retry or Layer 4 contract failed.
- Corrective runtime migration `20260830011809_m2_4_3_acceptance_dashboard_timeout_hardening` adds expression indexes matching dashboard `coalesce(...)` recent-activity/status access paths without changing output/access semantics.
- Verified Evidence recent-activity plan now uses `pipeline_evidence_activity_time_idx`; top-10 execution measured ~3.25 ms.
- Pilot corrective source: `eaab5a7b6fc7bfaddb2b6863e23f5033184fa4b7`.
- Corrective targeted UAT: `33285369673` — queued at checkpoint.
- Corrective frontend build: `33285369676` — queued at checkpoint.
- Required sequence remains targeted PASS → bounded integration desktop/mobile PASS → one replacement final acceptance candidate. M2.4.3 remains ACTIVE; M2.4.4 remains unauthorised.



## Corrective bounded integration nomination — 30 August 2026

Repository/runtime reconciliation before nomination:
- Pilot corrective implementation source remained exactly `eaab5a7b6fc7bfaddb2b6863e23f5033184fa4b7`; no parallel Pilot implementation commit superseded it.
- Admin head before this handoff was `b4cb9c34b0a83dd11935f6a72c48daff234a7d80`.
- deployed migration ledger confirms `20260830011809_m2_4_3_acceptance_dashboard_timeout_hardening` as the latest migration;
- all four corrective recent-activity indexes are present;
- Layer 3 housekeeping cron is active and recent executions complete successfully;
- available Postgres timeout errors correspond to the immutable failed acceptance attempt and predate the hardening migration;
- current Security/Performance Advisor output contains INFO-class findings only in the observed reconciliation; no new M2.4.3 Critical/High/WARN defect was identified.

Corrective bounded integration candidate:
- exact source before marker: `eaab5a7b6fc7bfaddb2b6863e23f5033184fa4b7`;
- marker commit / current Pilot head: `d1d5f78ab3673696845fedc96c1f467bd27b3e71`;
- marker path: `.github/m2-4-integration-candidate`;
- expected resolved tier: `integration`;
- required result: both chromium-desktop and chromium-mobile PASS.

Automation handoff:
- the GitHub workflow is triggered by the marker commit;
- at handoff the connected GitHub API has not yet published commit statuses/target URLs for `d1d5f78...`, so the exact Actions run ID is not yet exposed through the available connector;
- do not create a duplicate integration candidate;
- next chat must first query commit `d1d5f78ab3673696845fedc96c1f467bd27b3e71` status and capture the resulting integration run ID;
- if both platforms PASS, reconcile heads/runtime/advisors and nominate exactly one replacement final acceptance candidate;
- if either platform fails, retain immutable failure evidence and diagnose only the exact failing contract.

M2.4.3 remains ACTIVE. M2.4.4 remains unauthorised.


## Corrective integration PASS / replacement final acceptance nominated — 30 August 2026

Corrective bounded integration:
- marker `d1d5f78ab3673696845fedc96c1f467bd27b3e71`;
- run `33285703513`;
- chromium-desktop: PASS;
- chromium-mobile: PASS.

Pre-acceptance reconciliation:
- Pilot and Admin heads showed no superseding implementation drift;
- deployed corrective migration `20260830011809_m2_4_3_acceptance_dashboard_timeout_hardening` remains present;
- `layer3-interpret` Edge v5 / JWT enforced;
- `layer3-provider-control` Edge v2 / JWT enforced;
- `layer3-source-pattern-benchmark` Edge v9 / governed nonce contract;
- source-pattern profile remains enabled/unpaused on exact model `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`;
- Layer 3 housekeeping cron remains active;
- Security Advisor: 135 INFO / 0 WARN / 0 ERROR;
- Performance Advisor: 169 INFO / 0 WARN / 0 ERROR.

Replacement final acceptance:
- marker/current Pilot head `96de9add3762a0594ebc371fba49d4d990ff4b45`;
- marker path `.github/m2-4-acceptance-candidate`;
- expected resolved tier: `acceptance`;
- required outcome: chromium-desktop PASS and chromium-mobile PASS.

At handoff, the connector had not yet published commit statuses or the Actions run ID for `96de9add...`. Do not create another acceptance candidate. The next action is to check this exact commit first.

M2.4.3 remains ACTIVE. M2.4.4 remains unauthorised.


## Final authoritative state — 30 August 2026

M2.4.3 is **CLOSED / PASS** under `CF-CHG-20260829-047`.

Accepted Pilot:
`96de9add3762a0594ebc371fba49d4d990ff4b45`.

Replacement final acceptance run `33286437795`:
- desktop status PASS, with 49 passed + one timing-sensitive M2.3 Important Links/Important Dates flake recovered on retry;
- mobile 50/50 PASS;
- both governed commit-status contexts success.

Corrective integration `33285703513`: desktop/mobile PASS.

Closure runtime:
- migration `20260830011809_m2_4_3_acceptance_dashboard_timeout_hardening` present;
- Layer 3 Edges v5/v2/v9;
- source-pattern profile benchmark-passed/enabled/unpaused;
- housekeeping cron active;
- Security 135 INFO / 0 WARN / 0 ERROR;
- Performance 169 INFO / 0 WARN / 0 ERROR.

Historical failed final acceptance `33284867253` remains immutable evidence.

M2.4.4 is NEXT / READY, not started.
