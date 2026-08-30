# CourseFinder Master Project Plan v1.77

**Issued:** 30 August 2026  
**Status:** CURRENT  
**Supersedes:** v1.76  
**Programme position:** M1 FROZEN; M2.1–M2.3 CLOSED/PASS; M2.4 ACTIVE; M2.4.0–M2.4.3 CLOSED/PASS; M2.4.4 NEXT/READY

## 1. Programme position

M2.4.3 Layer 3 AI Operations Maturity is CLOSED / PASS under `CF-CHG-20260829-047`.

Accepted Pilot marker/head:
`msinghbs-ai/Coursefinder-Pilot@96de9add3762a0594ebc371fba49d4d990ff4b45`.

Final acceptance run `33286437795`:
- chromium-desktop: terminal PASS; 49 passed plus one timing-sensitive M2.3 Important Links/Important Dates test recovered on retry and retained as flaky evidence;
- chromium-mobile: 50/50 PASS;
- both governed acceptance commit-status contexts: success.

Corrective path before final acceptance:
- corrective source `eaab5a7b6fc7bfaddb2b6863e23f5033184fa4b7`;
- migration `20260830011809_m2_4_3_acceptance_dashboard_timeout_hardening`;
- targeted deployed UAT `33285369673` PASS;
- bounded integration marker `d1d5f78ab3673696845fedc96c1f467bd27b3e71`;
- bounded integration run `33285703513` desktop/mobile PASS.

Historical failed final acceptance `33284867253` remains immutable evidence.

## 2. Authority model

`Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition/extraction → Layer 3 governed AI Evidence interpretation → Layer 4 human resolution`.

Search Projection, Search Visibility, Publication, Website and Zoho remain separately governed downstream consumer states. Layer 3 has no direct canonical Layer 1/2 write authority.

## 3. Accepted M2.4.3 operating baseline

The accepted Layer 3 baseline includes:
- deterministic governed Layer 2 text-Evidence selection;
- screenshot Evidence excluded from AI text input;
- benchmark-passed enabled/unpaused model-profile enforcement;
- immutable profile/prompt/model/version provenance;
- zero-call paths for resolved, unchanged and in-flight duplicate work;
- governed replay/revalidation;
- bounded retry with attempt-level A14 telemetry;
- qualified fallback only when explicitly configured;
- confidence/no-candidate fall-out to Layer 4;
- entity/task/profile concurrency serialization;
- stale-execution recovery/housekeeping;
- operator Evidence → model/profile → result/confidence/provenance → review presentation;
- no automatic Search/Publication/Website/Zoho admission.

Source-pattern benchmark authority:
- run `089befcf-a2f2-42ec-ad03-7bfe02816e1b`;
- 4/4 governed Provider cases PASS;
- 3/3 controls PASS;
- exact model `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`;
- 8 calls, 4,454 input / 832 output tokens, estimated USD 0;
- threshold was not lowered.

## 4. Standing carried boundaries

- A1–A15 remain standing governance where applicable.
- A15 contact intelligence remains CLOSED/PASS and frozen under `CF-CHG-20260829-046`.
- RMIT frozen 212-record canonical promotion remains BLOCKED pending an already-authorised exact frozen-set executor.
- NZ first-party Layer 2 Course enrichment remains DEFERRED pending source qualification/onboarding.
- Apollo credential remains configuration-blocked/non-blocking.
- Production cutover, broad Publication and Zoho cutover remain later governed gates.

## 5. Next gate

M2.4.4 Cross-layer Checkpoint is **NEXT / READY**, but is not started by this document. It requires its own active governance/change-control entry before material execution.

M2.4.4 focus:
- cross-layer housekeeping and scheduling;
- recheck/replay orchestration;
- recovery and alerts;
- operational/documentation reconciliation;
- pre-blackout acceptance.

M2.4.4 is not Production cutover.

## 6. Execution discipline

All later M2 work inherits `PROJECT_INSTRUCTIONS.md`, Milestone 2 Standing Instructions, accepted addenda and closed-gate evidence. Do not weaken security, source authority, Evidence, telemetry, identity, paging/tablet, contextual-grain or UAT semantics merely to obtain PASS.
