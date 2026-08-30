# M2.4.3 Follow-ups

| ID | Item | Status |
|---|---|---|
| M243-FU-001 | Complete 60-profile AU/NZ first-party contact rollout. | ACTIVE |
| M243-FU-002 | Apollo `APOLLO_API_KEY` not configured; keep no-reveal adapter blocked/non-blocking. | BLOCKED / CONFIGURATION |
| M243-FU-003 | Correct malformed canonical NZ Provider website strings through Layer 1/source governance; A15 transport profiles already normalised. | OPEN / NON-BLOCKING |
| M243-FU-004 | Reconcile full cohort contact/zero-contact/error/source-limited metrics and Firecrawl units. | ACTIVE |
| M243-FU-005 | Run bounded integration desktop/mobile after rollout freeze. | PENDING |
| M243-FU-006 | Continue core M2.4.3 Layer 3 maturity; do not treat A15 closure as Layer 3 benchmark closure. | STANDING |


## A15 full-cohort disposition

- M243-FU-001 — 60-profile first-party rollout: **CLOSED / PASS**.
- M243-FU-004 — cohort metrics/provider telemetry reconciliation: **CLOSED / PASS**.
- M243-FU-002 — Apollo credential: **BLOCKED / CONFIGURATION / NON-BLOCKING**.
- M243-FU-003 — stale/malformed canonical Provider website corrections: **OPEN / LAYER 1 SOURCE GOVERNANCE / NON-BLOCKING FOR A15**.
- M243-FU-005 — post-freeze integration/final browser acceptance: **ACTIVE**.
- M243-FU-006 — broader Layer 3 maturity remains standing; A15 closure must not imply Layer 3 benchmark closure.


## A15 post-integration follow-ups — 29 August 2026

- M243-FU-005 — bounded integration desktop/mobile: **CLOSED / PASS**, run `33240736705`.
- M243-FU-007 — final acceptance desktop/mobile against Pilot marker `f6741a0cc29c5fea236e85b9042f8079762c6993`: **ACTIVE / NOMINATED**.
- M243-FU-008 — promote VU/Otago/Wellington accepted team/person/territory corrections into durable reconciliation behaviour so parser refresh cannot recreate lower-quality semantics: **OPEN / NON-BLOCKING**.
- M243-FU-009 — map Firecrawl subscription cash cost to retained page-unit telemetry: **OPEN / NON-BLOCKING**.
- M243-FU-010 — maintain frozen contact-quality regression measures (team-vs-person correctness, unsupported territory removal, duplicate rejection, first-party source coverage, reconciliation persistence): **OPEN / NON-BLOCKING**.


## A15 closure disposition

- M243-FU-007 — final acceptance desktop/mobile: **CLOSED / PASS**, run `33251745111`, 48/48 desktop + 48/48 mobile.
- CF-CHG-20260829-046: **CLOSED / PASS**.
- Accepted A15 Pilot: `f6741a0cc29c5fea236e85b9042f8079762c6993`.
- M243-FU-008 — durable contact-quality reconciliation: **OPEN / NON-BLOCKING / CARRY FORWARD**.
- M243-FU-009 — Firecrawl cash-cost mapping: **OPEN / NON-BLOCKING / CARRY FORWARD**.
- M243-FU-010 — contact-quality regression metrics: **OPEN / NON-BLOCKING / CARRY FORWARD**.
- M243-FU-003 — stale/malformed Provider website corrections: **OPEN / LAYER 1 GOVERNANCE / NON-BLOCKING**.
- M243-FU-002 — Apollo credential: **BLOCKED / CONFIGURATION / NON-BLOCKING**.
- Core M2.4.3 Layer 3 maturity/source-pattern benchmark remains **ACTIVE** and is the next execution focus.


## Core Layer 3 maturity follow-ups — 30 August 2026

| ID | Item | Status |
|---|---|---|
| M243-FU-011 | Reconcile source-pattern model-quality blocker without weakening the threshold. | **CLOSED / PASS** — `089befcf-a2f2-42ec-ad03-7bfe02816e1b` |
| M243-FU-012 | Deterministic governed Layer 2 Evidence selection into Layer 3. | **IMPLEMENTED / TARGETED PASS** |
| M243-FU-013 | Zero-call, replay/revalidation and concurrency/idempotency contract. | **IMPLEMENTED / ROLLBACK CONTRACT PASS** |
| M243-FU-014 | Attempt-level retry/fallback/token/cost/latency provenance and A14 telemetry. | **IMPLEMENTED** |
| M243-FU-015 | Confidence fall-out and Layer 4 routing for low-confidence/no-candidate results. | **IMPLEMENTED** |
| M243-FU-016 | Layer 3 stale execution recovery / housekeeping schedule. | **IMPLEMENTED** |
| M243-FU-017 | Mature Layer 3 operator UI and permanent deployed UAT. | **IMPLEMENTED / TARGETED PASS** |
| M243-FU-018 | Correct stale inherited integration assertions and exact migration-version mirror. | **CORRECTED — DEPLOYED VALIDATION ACTIVE** |
| M243-FU-019 | Corrective bounded integration desktop/mobile. | **PENDING CORRECTIVE TARGETED PASS** |
| M243-FU-020 | Final M2.4.3 acceptance and closure reconciliation. | **PENDING** |

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

