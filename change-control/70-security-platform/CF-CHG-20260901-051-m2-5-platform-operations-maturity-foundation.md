# CF-CHG-20260901-051 — M2.5 Platform Operations Maturity Foundation

**Status:** IMPLEMENTED / TARGETED UAT PENDING  
**Category:** 70-security-platform  
**Initiated:** 1 September 2026  
**Owner:** M2.5  
**Parent readiness gate:** `CF-CHG-20260901-049`  
**Design authority:** `CF-CHG-20260901-050`

## Purpose

Implement the authorised non-billable M2.5 platform-maturity foundation without provisioning Production and without reopening M2.4.

## Entry authority

- M2.4 CLOSED/PASS at Pilot `95f2991e97e76e644bd74f73512b8bf2725fd4b7`.
- Final M2.4.4 acceptance `33468512515`: desktop 75 / mobile 76 PASS.
- Production Supabase does not exist.
- Organisation remains `techM`; Production region/cost approval remains unresolved.
- No billable Production resource creation is authorised by this change.

## Implemented Pilot changes

Pilot commits:
- `cd919ddefae65c0f31a91c5e95ffaab9c7311f76` — platform operations maturity foundation;
- `ecc3f56ec9032a4866cc13a00d1c6a00b7872a52` — capacity/integrity alert classification;
- `1010cb7617f43c2b15ac9ef07e20805f50b30fde` — Pilot gate reconciliation + Layer 4 blocking;
- `55a26d2d05772bd73d5373e54fd44f569adbdf5e` — permanent M2.5 source-contract UAT;
- `dac23d68e6df230bc30c306fa7b61e720ecb431c` — deployed-UAT routing/integration.

Deployed Pilot migrations:
- `20260901060826 m2_5_platform_operations_maturity_foundation`;
- `20260901061041 m2_5_capacity_integrity_alert_classification`;
- `20260901061233 m2_5_environment_gate_reconcile_layer4_blocking`.

### PM-A1 — country/source environment separation

Added `pipeline.environment_source_gates` with explicit environment + capability + lifecycle state:
`seed_only → source_identified → source_qualified → pilot_ingestion → pilot_uat_pass → production_approved → production_enabled → monitored`.

Capabilities remain independently gated:
- Provider ingestion;
- Course ingestion;
- Scholarship ingestion;
- Layer 2 enrichment;
- consumer/Search exposure.

Only accepted AU CRICOS and NZ NZQA Layer 1 Provider/Course Pilot capability rows were reconciled to `pilot_uat_pass`. No Production gate row exists.

### PM-A6 — scraper onboarding/Production enablement foundation

Added `pipeline.layer2_provider_environment_gates`.

Only Direct HTTP and Firecrawl were reconciled to Pilot-qualified based on accepted M2.4.4 runtime history. Other configured acquisition adapters remain registered/disabled in the new gate until independently qualified.

No Production scraper gate exists or is enabled.

### PM-A7 — AI onboarding/Production enablement foundation

Added `pipeline.layer3_profile_environment_gates`.

The three enabled/unpaused benchmark-PASS Pilot profiles were reconciled to Pilot-qualified:
- `openrouter-free-router-v1`;
- `openrouter-source-pattern-v1`;
- `openrouter-international-contact-v1`.

No Production AI profile gate exists or is enabled. Existing Layer 3 authority remains Evidence interpretation only; no canonical mutation is added.

### PM-A8 — storage/capacity reporting

Added:
- `pipeline.platform_capacity_policy`;
- `pipeline.platform_capacity_observations`;
- secured capacity snapshot functions;
- daily `coursefinder-platform-capacity-observation` cron at 04:12 UTC.

Current Pilot snapshot:
- DB logical size ~611 MB;
- cumulative temp activity ~216.6 GB / 51.1k files;
- Evidence Storage 8,623 objects / ~4.62 GB;
- Evidence planning envelope 60 GiB; current ~7.18%;
- 205 storage objects have no current Evidence artifact row;
- 18 regulatory Evidence artifact rows have no current Storage object;
- integrity severity HIGH under configurable 1/100/1000 warning/high/critical thresholds;
- backup/PITR state is deliberately reported as `platform_api_required` until reconciled through Supabase platform metadata rather than inferred from SQL.

The initial “critical” classification was corrected: historical orphan/missing-object integrity findings no longer masquerade as DB/storage-capacity exhaustion.

### PM-A9 — retention/housekeeping foundation

Added `pipeline.retention_class_policies` and secured dry-run reporting.

Normally immutable classes include:
- regulatory Evidence;
- accepted source versions;
- Layer 4 decisions;
- publication decisions;
- material audit.

Potential transient classes are policy-defined only. No destructive purge was implemented. Any future purge must use dry-run, immutable exclusions, bounded deletion and post-delete integrity verification.

### PM-A4 — reversible blocking foundation

Added append-only `pipeline.layer4_block_decisions` with independent:
- operational block;
- publication block;
- Search block;
- data-quality quarantine.

Block/unblock requires rank-5 PIM Admin, reason, actor/time, optional comment/expiry/review and supersession history. It performs no deletion and does not silently change canonical values. A secured effective-state helper exists for later enforcement by owning consumer/operation changes.

### PM-A11 — UAT catalogue

Added `pipeline.platform_uat_catalogue`:
- 21 accepted M2.4.4 permanent domains point to acceptance `33468512515`;
- Production/maturity gates are explicitly designed/not-run, including country canary, storage, retention, scraper, AI, workload concurrency and restore/DR.

### PM-A12 — workload isolation

Added `pipeline.performance_workload_profiles` for:
- steady-state consumer API reads;
- scheduled refresh;
- bulk re-ingestion;
- representative concurrent serving/Admin/background activity.

Hard gates remain unchanged:
- RPC/detail <= 3,000 ms;
- management/page payload <= 250,000 bytes;
- filter/options payload <= 60,000 bytes;
- API reads may not trigger acquisition.

## Runtime reconciliation

Current Layer 2 state after the historical M2.4.4 closure snapshot:
- request `1bb1504d-7bad-42d9-b059-4adeaf9118c7` is terminal `completed`;
- 42 items completed;
- 219 items failed;
- 6,562 scope candidates recorded `missing_url`;
- the M2.4.4 “42 scheduled remainder” was closure-time state and must not be repeated as current runtime truth.

Current active platform cron includes the new daily capacity observation plus existing L1/L2/L3/Scholarship jobs.

## Security/performance validation

After deployed migrations:
- Security Advisor: **146 INFO / 0 WARN / 0 ERROR**;
- Performance Advisor: **174 INFO / 0 WARN / 0 ERROR**.

The extra Performance INFO entries are new unused-index observations immediately after schema creation, not WARN/ERROR findings.

ACL proof:
- `anon` cannot execute Layer 4 block decision;
- authenticated execution routes through rank-5 server-side enforcement;
- internal block predicate remains service-role only.

## UAT

Permanent test:
`tests/uat/m2-5-platform-readiness-deployed.spec.mjs`.

Workflow:
`.github/workflows/deployed-uat.yml` now resolves `m2_5` changes to the M2.5 targeted contract and includes it in integration/acceptance.

At this checkpoint the final Pilot head is `dac23d68e6df230bc30c306fa7b61e720ecb431c`; GitHub had not yet published a terminal commit status. Do not poll indefinitely. Next decision:
- PASS → record run/build IDs and move CF-051 to targeted PASS;
- FAIL → preserve run, fix only the demonstrated defect; do not weaken gates.

## Explicit non-authorisations

This change does not authorise:
- Production project creation;
- broad Publication;
- Website/Zoho Production cutover;
- RMIT frozen canonical promotion;
- NZ first-party Layer 2 expansion;
- generic AI authority;
- destructive retention;
- automatic enforcement of newly recorded block state across every consumer before its owning integration change.

## Open findings

1. Reconcile the 205 unmatched Evidence Storage objects and 18 missing regulatory Storage objects. Do not delete either side until lineage is understood.
2. Reconcile actual Supabase backup/PITR configuration via platform API during Production/Pilot operations review.
3. Decide notification destination and escalation policy.
4. Add Admin UI surfaces for environment gates/capacity/UAT/blocking in an authorised UX change.
5. Production provisioning remains blocked by organisation/region/cost approval under CF-049.
