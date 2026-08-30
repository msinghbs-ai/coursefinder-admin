# CourseFinder Database Architecture v2.10.44

**Status:** CURRENT — M2.4.3 ACCEPTED ADDITIVE ARCHITECTURE  
**Date:** 30 August 2026  
**Supersedes:** v2.10.43; all unspecified accepted structures and semantics remain inherited unchanged.  
**Change Controls:** prior accepted controls plus `CF-CHG-20260829-046` and `CF-CHG-20260829-047`

## 1. Authority model

The accepted four-layer authority remains:

`L1 authoritative/regulatory → L2 deterministic acquisition/extraction → L3 governed AI Evidence interpretation → L4 human resolution`.

Layer 3 does not gain direct canonical Layer 1/2 write authority. Search, Publication, Website and Zoho are downstream governed consumers.

## 2. Layer 3 accepted persistence

Existing accepted Layer 3 structures remain authoritative, including:
- `pipeline.layer3_interpretations`;
- `pipeline.layer3_model_profiles`;
- `pipeline.layer3_quality_benchmark_runs`;
- Layer 3 provider credential audit/provenance structures;
- concurrency/reservation/recovery structures introduced by the M2.4.3 migration lineage.

M2.4.3 preserves:
- effective profile/model/prompt/version provenance;
- deterministic Evidence references;
- input/output token counts where returned;
- external-call count;
- latency;
- estimated provider cost where available;
- retry/fallback attempt provenance;
- confidence and Layer 4 fall-out state.

Unavailable vendor usage remains null/explicitly unavailable and is never invented.

## 3. Accepted M2.4.3 migration lineage

- `20260829125553_m2_4_3_layer3_operations_maturity_foundation`;
- `20260829125717_m2_4_3_source_pattern_benchmark_provenance`;
- `20260829130640_m2_4_3_layer3_concurrency_recovery_housekeeping`;
- `20260829212940_m2_4_3_evidence_verification_lookup_hardening`;
- `20260829213038_m2_4_3_prompt_profile_provenance`;
- `20260830011809_m2_4_3_acceptance_dashboard_timeout_hardening`.

The final migration adds recent-activity expression indexes used by governed dashboard access paths. It changes no source authority, output semantics or access-control boundary.

## 4. Evidence and AI boundary

Layer 3 consumes governed Layer 2 Evidence. Screenshot Evidence remains secondary visual Evidence and is excluded from Layer 3 text interpretation inputs. AI results are interpretations/proposals subject to governed confidence and Layer 4 resolution, not automatic canonical truth.

## 5. Runtime at closure

- `layer3-interpret` v5 / JWT enforced;
- `layer3-provider-control` v2 / JWT enforced;
- `layer3-source-pattern-benchmark` v9 / governed nonce contract;
- Layer 3 housekeeping cron active every 15 minutes;
- source-pattern profile enabled/unpaused on `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`.

Source-pattern benchmark `089befcf-a2f2-42ec-ad03-7bfe02816e1b` passed 4/4 Provider cases and 3/3 controls with exact-model enforcement.

## 6. Closure evidence

Accepted Pilot marker/head:
`96de9add3762a0594ebc371fba49d4d990ff4b45`.

Final acceptance `33286437795`: both governed desktop/mobile status contexts PASS. Desktop retained one recovered timing-sensitive M2.3 UI flake; mobile 50/50 PASS.

Security Advisor at closure: 135 INFO / 0 WARN / 0 ERROR.  
Performance Advisor at closure: 169 INFO / 0 WARN / 0 ERROR.

## 7. Carried architecture boundaries

RMIT 212-record promotion remains blocked; NZ first-party Layer 2 Course enrichment remains deferred; A15 contact intelligence remains frozen; no M2.4.3 structure authorises broad Publication, Production or Zoho cutover.
