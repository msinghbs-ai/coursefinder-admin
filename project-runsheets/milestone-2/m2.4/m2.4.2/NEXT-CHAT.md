# M2.4.2 — Next Chat / Continuation Contract

**Status:** ACTIVE — continue current repository/runtime truth; do not restart from chat assumptions.

## Mandatory start

1. Read `PROJECT_INSTRUCTIONS.md`.
2. Read M2 Standing Instructions and A1–A7.
3. Read `change-control/README.md`, `change-control/REGISTER.md` and CF-CHG-20260827-044.
4. Read current Running Build, Master Project Plan, accepted database architecture and Admin/PIM decisions.
5. Read:
   - `project-runsheets/milestone-2/m2.4/CURRENT-STATE.md`
   - `project-runsheets/milestone-2/m2.4/FOLLOW-UPS.md`
   - this M2.4.2 `RUNSHEET.md`, `CURRENT-STATE.md` and `FOLLOW-UPS.md`.
6. Reconcile current Pilot main, deployed Edge versions, Supabase migrations/functions/jobs and Actions before changing anything.

## Accepted M2.4.2 evidence already established

### UQ
- current-profile discovery: 382/382 evaluated;
- governed selected URLs: 156;
- managed post-fix batch `eb52b6e2-c33b-4dfc-9e87-c107834218e0`: 156 processed / 153 resolved_l2 / 3 Layer 3 required / 0 blocked / USD 0 vendor cost;
- deterministic Course extractor: `layer2-course-fact-extract-v2.5`;
- canonical dry-run: 153/153 exact provider/Course CRICOS resolution;
- canonical apply: 153/153; 153 links, 153 guarded fees, 488 intakes, 453 English upserts, 153 descriptions;
- TOEFL apply mapping corrected to accepted `TOEFL_IBT`;
- Search/Publication mutation remain false;
- three explicit UQ Layer 3 exceptions: CRICOS `027288A`, `082599G`, `094716G`.

### Federation
- 10 identity-verified governed first-party URLs are current-version selected;
- managed batch `fef3ab42-de28-469d-84a2-22c908f0fad1` processed the 10 governed URLs;
- canonical dry-run passed 10/10 exact identity;
- canonical apply passed 10/10: 10 links, 5 safe fees, 17 intakes, 9 English rows;
- five fee-only Layer 3 cases remain guarded as `domestic_csp_fee_candidate`;
- remaining 180 Courses are source-limited unless current-version discovery proves otherwise or a separately qualified first-party mapping source is accepted.

### RMIT
- profile requires real `/study-with-us/levels-of-study/` detail URLs;
- discovery worker v1.2.4 fixed BP350 versus Honours ambiguity; control CRICOS `110982H` selects the BP350 Course page;
- broad discovery had a 50-record outer-dispatch timeout after 16 safely evaluated / 10 selected records;
- those candidates were retained;
- orphan attempt/job was explicitly recovered and marked failed with timeout-recovery evidence.

## Current runtime hardening

`layer2-scope-discover-scheduled-v1.2.5` is deployed and mirrored.

It adds:
- per-Course acquisition time budget across provider fallback hops;
- per-invocation time budget;
- continuation from the first unprocessed scoped Course ID before pg_net's 120-second outer timeout;
- unknown-cost provider guard remains active;
- detail-path and title/identity guards remain active.

The pre-fix orphan jobs/attempts for RMIT and Federation were closed with explicit recovery evidence.

## Active work at last update

RMIT and Federation scope discovery were restarted under v1.2.5:
- RMIT latest job at restart: `c7052e45-a262-42c0-bf3e-e1f04d2d922c`;
- Federation latest job at restart: `ab69d3cd-88ac-4c7d-9f6b-3f04d6645aee`;
- both must be re-read from current runtime; do not assume they remain active or use stale request IDs.

Immediate actions:
1. verify v1.2.5 invocations finish before the outer 120-second timeout and create continuation request IDs;
2. complete RMIT bounded discovery, then validate duplicate URLs, selection quality, provider economics and failure classes;
3. auto/manual managed enrich only governed RMIT selected URLs, then dry-run and apply through `layer2_apply_course_candidate`;
4. reconcile Federation current-version discovery without weakening source/identity rules;
5. retain all source-limited/ambiguous/mismatch records as explicit fall-out rather than fabricating coverage.

## Remaining M2.4.2 gates

- full RMIT/Federation final scope disposition;
- representative/full provider latency, throughput, quota/cost, Evidence growth and Layer 3 fall-out metrics;
- schedule/recheck and targeted stale-data refresh;
- alerts for stuck jobs/stale sources/provider quota or abnormal behaviour;
- safe Layer 2 housekeeping preserving governed Evidence/profile versions/provider attempts/canonical history;
- cancellation/recovery/replay/idempotency permanent UAT;
- anon/lower-rank/private-table/secret security negatives;
- Layer 1 identity regression;
- Jobs/Evidence/Data Quality navigation regression;
- current guides/runbook/release notes;
- final Security Advisor and Performance Advisor;
- Stage B desktop/mobile only after runtime slice is stable;
- exactly one final Stage C candidate only after freeze;
- Running Build/Master Project Plan advance only at final acceptance.

## Hard rules

- M2.4.2 is ACTIVE, not closed.
- Do not weaken Layer 1 authority, Course identity, Evidence, cost guard, Search or Publication boundaries.
- Do not use routine browser trial controls.
- Do not create Stage B/Stage C markers prematurely.
- Do not delete governed Evidence/history during recovery or housekeeping.
- NZ first-party Layer 2 Course enrichment remains deferred.
