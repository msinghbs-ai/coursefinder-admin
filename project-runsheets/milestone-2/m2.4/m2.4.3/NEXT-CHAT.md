# M2.4.3 Next Chat — Core Layer 3 AI Operations Maturity

A15 contact intelligence is CLOSED / PASS. Do not restart or broad-rerun the A15 cohort.

## Mandatory start
1. Read `PROJECT_INSTRUCTIONS.md`.
2. Read `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md`.
3. Read all current execution addenda A1–A15.
4. Read `change-control/README.md`, `change-control/REGISTER.md` and closed `CF-CHG-20260829-046`.
5. Read the latest Master Project Plan, Running Build, DB Architecture and Admin/PIM design decisions.
6. Read this M2.4.3 `RUNSHEET.md`, `CURRENT-STATE.md`, `FOLLOW-UPS.md`, and current `NEXT-CHAT.md`.
7. Reconcile current heads of `msinghbs-ai/coursefinder-admin` and `msinghbs-ai/Coursefinder-Pilot`.
8. Reconcile deployed Supabase/Edge state, migrations/functions/jobs, current Security/Performance Advisors and latest GitHub Actions before changing anything.

## Accepted A15 baseline
- CF-CHG-20260829-046: CLOSED / PASS.
- Functional contact freeze: `f9e4e530462b49cf5a83ad8e0d5137631255028a`.
- Accepted Pilot: `f6741a0cc29c5fea236e85b9042f8079762c6993`.
- Final acceptance run: `33251745111`.
- Acceptance tier: 17 permanent suites.
- Desktop: 48/48 PASS.
- Mobile: 48/48 PASS.
- Cohort: 60/60 profiles successful, 0 current errors.
- Current contacts: 31 across 11 Providers; 17 territory/market contacts.
- Rejected/noisy history: 45 retained.
- Worker: provider-contact-discover-scheduled-v1.3.2 / Edge v15.
- Apollo: configuration-blocked/non-blocking; no personal-email/phone reveal.

## Data/showcase boundary to preserve
- Layer 1 remains canonical Provider/Course identity and source authority.
- A15 contact intelligence is Layer 2 deterministic enrichment backed by first-party Evidence.
- Showcase captured contacts primarily in Provider detail → International contacts, with team/person, title, territory, institutional work contact, source class, freshness and Evidence.
- Course detail may show Provider contact context only as clearly-labelled Provider context; never convert Provider contact facts into Course truth.
- Layer 3 may interpret governed Layer 2 Evidence for contact-change, source-pattern or operational intelligence, but cannot overwrite Layer 1/Layer 2 source facts.
- Layer 4 is for human resolution of ambiguity/change where required.
- Search/public website admission is not authorised by A15 closure.
- Zoho/API consumption is not authorised by A15 closure and needs a separate curated consumer/API contract.

## Next execution objective
Continue **M2.4.3 Layer 3 AI Operations Maturity** from the accepted A15 baseline. Do not treat A15 closure as M2.4.3 closure.

Focus on:
- the existing blocked Layer 3 source-pattern/model-quality benchmark;
- deterministic Evidence selection into Layer 3;
- model/provider routing and pinned model/profile controls;
- prompt/input/output provenance;
- zero-call/revalidation paths;
- token/cost/latency telemetry under A14;
- retry/failure/fallback semantics;
- concurrency/scheduling/housekeeping;
- confidence/quality thresholds without lowering the accepted benchmark;
- human-review handoff to Layer 4;
- operational UI that explains what Layer 3 is doing without exposing secrets;
- final Layer 3 acceptance criteria and permanent UAT inclusion.

Preserve all accepted A10–A15 UI/Evidence behaviour and do not regress Layer 1/Layer 2 authority.

## Carry-forward, non-blocking
- durable VU/Otago/Wellington contact reconciliation across refresh;
- Firecrawl subscription cash-cost mapping;
- Layer 1 correction of stale/malformed Provider website values;
- contact-quality regression metrics;
- Apollo configuration/licensed enrichment.

If the core Layer 3 maturity gate closes, then assess whether M2.4.3 itself can close and whether M2.4.4 should formally start. Do not start M2.4.4 merely because A15 closed.
