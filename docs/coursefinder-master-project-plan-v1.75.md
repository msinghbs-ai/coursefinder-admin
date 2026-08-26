# CourseFinder Master Project Plan v1.75

**Issued:** 27 August 2026  
**Status:** CURRENT  
**Supersedes:** v1.74  
**Programme position:** M2.3 CLOSED/PASS; M2.4 ACTIVE; **M2.4.0 CLOSED/PASS; M2.4.1 CLOSED/PASS; M2.4.2 NEXT**

## 1. Programme position

M1 remains frozen. M2.1, M2.2 and M2.3 are CLOSED/PASS for their accepted scope. NZ first-party Layer 2 Course enrichment remains explicitly deferred to future NZ source qualification/onboarding.

M2.4 remains ACTIVE. M2.4.0 and M2.4.1 are CLOSED/PASS. Current accepted Pilot source is:

`msinghbs-ai/Coursefinder-Pilot@ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`

Final M2.4.1 acceptance: build `32972106272` PASS; deployed Stage C `32972106291` desktop/mobile PASS.

The separate Production environment remains M2.5. Broad Publication and Zoho cutover remain later governed gates. No additional billable hours are inferred by this status transition; the engagement-time record remains authoritative.

## 2. Authority model

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 remains terminal. Search Projection, Search Visibility and Publication remain downstream product states.

## 3. Milestone sequence

| Milestone | Status | Planned-hours baseline | Outcome / focus |
|---|---|---:|---|
| M2.0 | COMPLETE | 8 | programme consolidation / Auto-UAT |
| M2.1 | CLOSED / PASS | 3 | Layer 2 platform foundation |
| M2.2 | CLOSED / PASS | 10 | Security & Production foundation + deterministic Search showcase |
| M2.3 | CLOSED / PASS — NZ L2 EXPANSION DEFERRED | 12 baseline | production-grade Layers 1–4 and decision operations |
| **M2.4** | **ACTIVE — M2.4.0 PASS / M2.4.1 PASS / M2.4.2 NEXT** | **7 baseline** | operational maturity, UX simplification, automation, monitoring, performance and pre-blackout checkpoint |
| Blackout 16–30 Sep | NO DELIVERY | 0 | no planned project delivery |
| M2.5 | PLANNED | 12 | clean Production stack deployment/restore/security acceptance |
| M3 | PLANNED | 10 | consumer API / Zoho integration |
| M4 | PLANNED | 8 | Search/publication/final Production handover |

## 4. M2.4.0 — CLOSED / PASS

Accepted Pilot checkpoint: `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`.

M2.4.0 closed the navigation/test integration liability, established the primary Data Operations information architecture and shared navigation adapters, introduced targeted → bounded integration → one final acceptance matrix CI discipline, and corrected the first Course-page performance contention without widening the 3,000 ms RPC budget.

## 5. M2.4.1 — CLOSED / PASS

M2.4.1 production-shaped Layer 1 Regulatory operations for AU CRICOS and NZ NZQA.

Accepted capabilities:

- governed/versioned source operations profiles;
- authority-domain and expected-source-format validation;
- dynamic AU CRICOS and NZ NZQA record-count assessment;
- warning/block variance guardrails before APPLY;
- one-active-source queue protection, idempotency, retry/resume and cumulative reconciliation;
- live progress/heartbeat/stuck visibility and bounded recovery;
- source-hash/no-change execution path;
- scheduled non-destructive authoritative-source rechecks through one-time nonce;
- paused-source exclusion and stale schedule recovery;
- safe transient housekeeping preserving governed Evidence/source versions/canonical history;
- simplified operator UX with direct Evidence/Jobs provenance.

Live proof:

- AU CRICOS: 26,648 active / 90 expired / 26,738 total Course rows;
- NZ NZQA: 411 current providers versus 409 accepted baseline, approximately 0.489% PASS variance.

Security/ACL/rank boundaries remain enforced server-side. Final Security Advisor has no new material M2.4.1 Critical/High/Warning finding. Final Performance Advisor has no unindexed Layer 1 foreign key.

Final staged UAT:

- Stage A `32971449084` — PASS;
- Stage B `32971584012` — desktop/mobile PASS;
- Stage C `32972106291` — desktop/mobile PASS;
- accepted Pilot `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`.

CF-CHG-20260826-043 is CLOSED/PASS.

## 6. M2.4 sub-milestone sequence

| Sub-milestone | Status | Purpose |
|---|---|---|
| M2.4.0 | CLOSED / PASS | integration cleanup, navigation/test-liability removal, accepted rebase |
| M2.4.1 | CLOSED / PASS | Layer 1 Regulatory Operations Maturity & Automation |
| **M2.4.2** | **NEXT / READY** | Layer 2 Full Enrichment, Operations Maturity & Performance |
| M2.4.3 | PLANNED | Layer 3 AI Operations Maturity |
| M2.4.4 | PLANNED | cross-layer operations, housekeeping, scheduling and pre-blackout acceptance |

## 7. M2.4.2 — Layer 2 Full Enrichment, Operations Maturity & Performance

M2.4.2 must mature Layer 2 across the accepted source/provider architecture without weakening Layer 1 authority or reopening accepted M2.4.0/M2.4.1 foundations.

Primary objectives:

- execute representative/full enrichment across accepted AU scope;
- mature the normal Layer 2 operator journey under Data Operations;
- make source/profile/provider routing and governed configuration clear;
- expose queue/job/progress/reconciliation/Evidence/log state with minimum navigation;
- prove retry/resume/recovery and idempotent execution;
- measure full-run throughput and latency;
- measure provider spend/economics/quota behaviour;
- measure Evidence/storage growth and Layer 3 fall-out;
- tune concurrency/schedules only after evidence is captured;
- add/verify operational alerts for Layer 2 provider/source/job states;
- evolve UI/UX using real full-run evidence;
- maintain Guides/Runbooks/release notes and automated UAT.

NZ first-party Layer 2 Course enrichment remains deferred unless separately qualified and authorised.

## 8. M2.4.3 — Layer 3

Mature Layer 3 provider/model operations, quality monitoring, revalidation, budgets, cost/latency/quality telemetry and queue handling without granting uncontrolled canonical write authority.

## 9. M2.4.4 — Cross-layer checkpoint

Complete cross-layer housekeeping, scheduling, recheck orchestration, recovery/replay, alerts, documentation and pre-blackout acceptance. Preserve the Production boundary; M2.4.4 is not Production cutover.

## 10. Execution discipline

All M2.4.x implementation inherits `PROJECT_INSTRUCTIONS.md`, M2 Standing Instructions and execution addenda A1–A7.

Material changes progress through:

1. targeted development validation;
2. bounded integration regression;
3. one nominated full deployed desktop/mobile acceptance matrix at the relevant checkpoint.

Permanent operational journeys/UAT use accepted primary navigation. Do not restore floating operational architecture, weaken role/security boundaries, alter Layer authority, or widen accepted performance assertions merely to obtain PASS.

## 11. Production / downstream boundary

M2.4 does not silently authorise:

- Production project establishment/cutover;
- broad Publication;
- consumer/website release;
- Zoho cutover;
- reclassification of Search as an identity authority.

These remain later governed gates.