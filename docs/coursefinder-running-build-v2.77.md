# CourseFinder Running Build v2.77

**Status:** M1 FROZEN / M2.1–M2.3 CLOSED-PASS / M2.4.0–M2.4.3 CLOSED-PASS  
**Date:** 30 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.76.md`  
**Master Project Plan:** `docs/coursefinder-master-project-plan-v1.77.md`  
**Change Controls:** `CF-CHG-20260827-044`, `CF-CHG-20260829-046`, `CF-CHG-20260829-047`

## Accepted Pilot runtime

Final M2.4.3 accepted marker/head:

`msinghbs-ai/Coursefinder-Pilot@96de9add3762a0594ebc371fba49d4d990ff4b45`

Visible browser release remains PIM Admin `v2.15.11`.

## Acceptance evidence

- source-pattern benchmark `089befcf-a2f2-42ec-ad03-7bfe02816e1b`: 4/4 Provider cases + 3/3 controls PASS;
- corrective targeted UAT `33285369673`: PASS;
- corrective frontend build/local smoke `33285369676`: PASS;
- bounded integration `33285703513`: desktop PASS / mobile PASS;
- replacement final acceptance `33286437795`:
  - desktop governed status PASS, with one M2.3 Important Links/Important Dates visibility flake recovered on retry (49 passed + 1 flaky);
  - mobile 50/50 PASS;
  - both commit-status contexts success.

Historical failed final acceptance `33284867253` remains immutable evidence of the pre-hardening dashboard statement-timeout defect.

## Runtime state at closure

- corrective migration `20260830011809_m2_4_3_acceptance_dashboard_timeout_hardening` deployed;
- `layer3-interpret` Edge v5 / JWT enforced;
- `layer3-provider-control` Edge v2 / JWT enforced;
- `layer3-source-pattern-benchmark` Edge v9 / governed one-time nonce contract;
- Layer 3 housekeeping cron active every 15 minutes;
- source-pattern profile enabled/unpaused on exact accepted Nemotron model;
- Security Advisor: 135 INFO / 0 WARN / 0 ERROR;
- Performance Advisor: 169 INFO / 0 WARN / 0 ERROR.

## Accepted Layer 3 behaviour

- governed L2 Evidence input only;
- no screenshot Evidence in AI text input;
- qualified profile/model enforcement;
- replay/revalidation and zero-call paths;
- bounded retry/fallback with A14 telemetry;
- confidence fall-out to Layer 4;
- concurrency and stale-work recovery;
- complete provenance;
- no direct Layer 1/2 canonical mutation;
- no automatic Search/Publication/Website/Zoho admission.

## Carried boundaries

- A15 contact intelligence remains frozen CLOSED/PASS;
- RMIT 212-record promotion remains BLOCKED;
- NZ first-party L2 Course enrichment remains DEFERRED;
- Apollo remains configuration-blocked/non-blocking;
- Production, broad Publication and Zoho cutover remain unauthorised.

## Gate state

- M2.4.2 — CLOSED / PASS;
- M2.4.3 — **CLOSED / PASS**;
- M2.4.4 — **NEXT / READY, NOT STARTED**.

M2.4.4 requires separate active governance before material work.
