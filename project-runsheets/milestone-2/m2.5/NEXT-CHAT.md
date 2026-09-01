# M2.5 NEXT CHAT — Production Readiness + Platform Maturity

Continue CourseFinder from repository/runtime truth. Do not rely on stale chat assumptions.

## Mandatory start

1. Read `PROJECT_INSTRUCTIONS.md`.
2. Read `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md`.
3. Read current programme baselines:
   - `docs/coursefinder-master-project-plan-v1.81.md`
   - `docs/coursefinder-running-build-v2.81.md`
4. Read active M2.5 Production readiness:
   - `change-control/70-security-platform/CF-CHG-20260901-049-m2-5-clean-production-stack-establishment.md`
   - `project-runsheets/milestone-2/m2.5/RUNSHEET.md`
   - `project-runsheets/milestone-2/m2.5/CURRENT-STATE.md`
   - `project-runsheets/milestone-2/m2.5/FOLLOW-UPS.md`
5. Read platform-maturity design baseline:
   - `change-control/00-governance-programme/CF-CHG-20260901-050-platform-maturity-design-backlog.md`
   - `docs/coursefinder-platform-maturity-design-v1.0.md`
   - `docs/coursefinder-uat-performance-baseline-v1.0.md`
   - `project-runsheets/milestone-2/m2.5/PLATFORM-MATURITY-IMPLEMENTATION-BACKLOG.md`
6. Read closed M2.4.4 authority:
   - `change-control/00-governance-programme/CF-CHG-20260830-048-m2-4-4-cross-layer-checkpoint.md`
7. Reconcile live Supabase projects, Pilot runtime, GitHub workflows and any newly created Production identity before material implementation.

## Closed baseline — do not reopen

M2.4 is CLOSED/PASS.

Accepted Pilot:
- `msinghbs-ai/Coursefinder-Pilot@95f2991e97e76e644bd74f73512b8bf2725fd4b7`
- build `33468512538` PASS
- final deployed acceptance `33468512515` PASS
- desktop 75 passed
- mobile 76 passed
- Security Advisor: 146 INFO / 0 WARN / 0 ERROR
- Performance Advisor: 172 INFO / 0 WARN / 0 ERROR

M2.4.2, M2.4.3 and M2.4.4 must not be reopened merely because scheduled/deferred/platform-maturity work remains.

## M2.5 current state

M2.5 is ACTIVE / READINESS under `CF-CHG-20260901-049`.

Current Supabase inventory:
- `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp` / Mumbai `ap-south-1`
- `coursefinder-demo` / `gfryvshbeptxwbzjomhe` / `ap-southeast-2`
- no CourseFinder Production Supabase project currently exists

Visible Supabase organisation:
- `techM`
- organisation ID `rszbvkqopqfvjldvfnbh`
- organisation plan is Pro

Do not create a billable Production project without the explicit organisation / region / quoted-cost approval required by the Supabase provisioning workflow.

Do not rename/promote Pilot into Production.

## Pilot compute note

The existing Mumbai Pilot is on Pro and can be vertically scaled.

Current sizing evidence previously observed:
- database ~580 MB
- Micro-class settings / ~1 GB memory profile
- substantial historical temp spill (~201 GB cumulative temp writes), showing ingestion/UAT memory pressure

Design implication:
- Pilot may be temporarily scaled for heavy ingestion/UAT;
- Production steady-state sizing must be benchmarked against read-heavy API traffic, not bulk ingestion;
- Website and Zoho are expected to cache compact reference/search payloads where appropriate;
- future consumer APIs should use dataset/reference version invalidation rather than repeated full downloads.

## Platform maturity backlog

CF-CHG-20260901-050 is DESIGN BASELINE only. Implement items only in their owning gate.

PM-A1 — Country & Source Onboarding Maturity  
PM-A2 — Provider Collections / G8  
PM-A3 — Scholarship Relationship Operations  
PM-A4 — Manual Intervention & Blocking  
PM-A5 — Manual Entity Creation  
PM-A6 — Scraper Onboarding Framework  
PM-A7 — AI Onboarding Framework  
PM-A8 — Storage, Capacity & Notification  
PM-A9 — Retention, Purge & Housekeeping  
PM-A10 — Consumer Cache & Dataset Versioning  
PM-A11 — Platform UAT Catalogue  
PM-A12 — Performance & Workload Isolation

Priority for M2.5:
- PM-A1 country/source Production separation
- PM-A4 operational block/unblock where required for safe Production operations
- PM-A6 scraper onboarding foundation
- PM-A7 AI onboarding/security foundation
- PM-A8 storage/capacity monitoring
- PM-A9 retention/housekeeping
- PM-A11 Production UAT traceability
- PM-A12 serving-vs-ingestion workload isolation

Likely M3:
- PM-A2 Provider Collections/G8 consumer filtering
- PM-A3 Scholarship relationship consumer exposure
- PM-A10 Website/Zoho cache/version contracts

Future:
- PM-A5 mature manual Provider/Course authoring
- unit/subject-level academic model

## Current design answers that must be preserved

- Scholarships use typed scopes/course links/Evidence; Provider-wide structural scope must not be presented as student eligibility.
- Course-unit Scholarship mapping remains deferred until a governed unit/subject model exists.
- G8/Go8 uses `institution_collections` + Provider memberships, not `is_g8` boolean.
- new-country Layer 1 Production enablement is environment-specific and requires Production canary/UAT.
- Layer 2 = deterministic acquisition/extraction.
- Layer 3 = Evidence-led AI interpretation; no direct canonical mutation.
- Layer 4 = audited human intervention; source truth remains retained.
- new scrapers and AI models require explicit profile/benchmark/Pilot qualification before Production enablement.
- manual create is provisional pending authoritative reconciliation.
- block/quarantine is reversible state, not hard deletion.
- purge/retention is class-based with immutable Evidence/audit exclusions.
- consumer caching/version invalidation is part of the performance architecture.

## Standing performance budgets

Never weaken:
- RPC/detail interaction ≤ 3,000 ms
- management/page payload ≤ 250,000 bytes
- filter/options payload ≤ 60,000 bytes

Normal consumer reads must remain independent of active acquisition calls.

## Parallel work / boundaries

`CF-CHG-20260827-045` Zoho Pilot remains ACTIVE/PARTIAL.

M2.5 does not authorise:
- broad Publication
- Website Production cutover
- Zoho Production cutover
- RMIT frozen canonical promotion
- deferred NZ first-party Layer 2 expansion
- autonomous Layer 3 canonical mutation

16–30 September 2026 remains the no-planned-delivery blackout unless separately authorised.

## Recommended next action

First reconcile the live Mumbai Pilot and M2.5 readiness state.

Then choose the next authorised action from repository/runtime truth:
1. Production provisioning decision and cost/region gate; or
2. non-billable M2.5 design/readiness implementation such as storage reporting, environment-specific source controls, Production UAT design, scraper/AI onboarding framework or workload isolation.

Keep governance, design docs, UAT coverage, architecture and handover current as work proceeds.
