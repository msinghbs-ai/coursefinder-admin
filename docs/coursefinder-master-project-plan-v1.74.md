# CourseFinder Master Project Plan v1.74

**Issued:** 26 August 2026  
**Status:** CURRENT  
**Supersedes:** v1.73  
**Programme position:** M2.3 CLOSED/PASS; M2.4 ACTIVE; **M2.4.0 CLOSED/PASS; M2.4.1 NEXT**

## 1. Programme position

M1 remains frozen. M2.1, M2.2 and M2.3 are CLOSED/PASS for their accepted scope. NZ first-party Layer 2 Course enrichment remains explicitly deferred to future NZ source qualification/onboarding.

M2.4 remains ACTIVE. Its mandatory M2.4.0 cleanup/integration rebase is now CLOSED/PASS against accepted Pilot SHA `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`.

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
| **M2.4** | **ACTIVE — M2.4.0 PASS / M2.4.1 NEXT** | **7 baseline** | operational maturity, UX simplification, automation, monitoring, performance and pre-blackout checkpoint |
| Blackout 16–30 Sep | NO DELIVERY | 0 | no planned project delivery |
| M2.5 | PLANNED | 12 | clean Production stack deployment/restore/security acceptance |
| M3 | PLANNED | 10 | consumer API / Zoho integration |
| M4 | PLANNED | 8 | Search/publication/final Production handover |

## 4. M2.4.0 — CLOSED / PASS

M2.4.0 resolved the Go 7 navigation/test integration liability before further feature work.

Accepted Pilot runtime:

`msinghbs-ai/Coursefinder-Pilot@ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`

Evidence:

- build `32958795576` — PASS;
- full deployed UAT `32958795547` — PASS;
- desktop `98146317262` — PASS;
- mobile `98146317373` — PASS.

Accepted primary information architecture:

`Overview → Catalogue → Data Operations → Insights → Quality & Review → Decision Tools → Governance & Platform → Help & Guides`.

M2.4.0 also established shared primary-navigation test adapters, targeted → integration → acceptance CI tiers, bounded deterministic navigation waits and a separate lightweight UX/content audit workflow.

The first Course page load was corrected from an inherited >3 s desktop miss by prioritising Course page data ahead of Course filter metadata. Retained bounded-integration evidence measured `courses_page` at 1,985 ms against the unchanged 3,000 ms budget. No security/data boundary or UAT threshold was weakened.

CF-CHG-20260826-040 is CLOSED/PASS. CF-CHG-20260826-042 remains standing M2 governance and is validated by the completed staged-UAT sequence.

## 5. M2.4 sub-milestone sequence

| Sub-milestone | Status | Purpose |
|---|---|---|
| **M2.4.0** | **CLOSED / PASS** | integration cleanup, navigation/test-liability removal, accepted rebase |
| **M2.4.1** | **NEXT / READY** | Layer 1 Regulatory Operations Maturity & Automation |
| M2.4.2 | PLANNED | Layer 2 Full Enrichment, Operations Maturity & Performance |
| M2.4.3 | PLANNED | Layer 3 AI Operations Maturity |
| M2.4.4 | PLANNED | cross-layer operations, housekeeping, scheduling and pre-blackout acceptance |

## 6. M2.4.1 — Layer 1 Regulatory Operations Maturity & Automation

M2.4.1 must production-shape the normal Layer 1 operator journey for at least AU and NZ while preserving accepted Layer authority/security.

Primary objectives:

- simple, primary-navigation Layer 1 operations workspace;
- source/profile URL or endpoint entry/validation where supported by the source model;
- source availability/schema/identity qualification before run;
- discoverable source record counts and explicit variance guardrails;
- governed queue/job creation with duplicate/concurrent-run protection;
- progress bars and processed/accepted/rejected/unchanged/failed counts;
- job progress, logs, errors and Evidence/provenance within minimum navigation;
- retry/resume and stuck-job/heartbeat visibility;
- scheduled rechecks/freshness monitoring based on accepted source/profile cadence;
- hash/change detection to avoid unnecessary ingestion;
- cleanup/housekeeping for transient execution state without deleting governed Evidence;
- alerts/operational status for stale sources, abnormal count changes and failed/stuck runs;
- role-appropriate progressive disclosure so experimental, qualification and destructive controls do not dominate routine operations;
- maintained Guides/Runbooks/release notes and automated desktop/mobile evidence.

M2.4.1 must explicitly address carry-forward M24-FU-003 and M24-FU-004 before unattended scheduling is accepted.

## 7. M2.4.2 — Layer 2

After M2.4.1 closure, mature Layer 2 full enrichment across the accepted source/provider architecture. Capture full-run performance, provider economics, Evidence growth and Layer 3 fall-out before tuning schedules/concurrency. NZ first-party Layer 2 remains deferred unless separately qualified/authorised.

## 8. M2.4.3 — Layer 3

Mature Layer 3 provider/model operations, quality monitoring, revalidation, budgets, cost/latency/quality telemetry and queue handling without granting uncontrolled canonical write authority.

## 9. M2.4.4 — Cross-layer checkpoint

Complete cross-layer housekeeping, scheduling, recheck orchestration, recovery/replay, alerts, documentation and pre-blackout acceptance. Preserve the Production boundary; M2.4.4 is not Production cutover.

## 10. Execution discipline

All M2.4.x implementation inherits `PROJECT_INSTRUCTIONS.md`, M2 Standing Instructions and A1–A6.

Material changes progress through:

1. targeted development validation;
2. bounded integration regression;
3. one nominated full deployed desktop/mobile acceptance matrix at the relevant checkpoint.

Permanent operational journeys/UAT use accepted primary navigation. Do not restore floating operational architecture, weaken role/security boundaries or widen accepted performance assertions merely to obtain PASS.

## 11. Production / downstream boundary

M2.4 does not silently authorise:

- Production project establishment/cutover;
- broad Publication;
- consumer/website release;
- Zoho cutover;
- reclassification of Search as an identity authority.

These remain later governed gates.
