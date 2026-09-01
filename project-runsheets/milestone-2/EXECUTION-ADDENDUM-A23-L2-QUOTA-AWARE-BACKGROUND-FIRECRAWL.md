# Execution Addendum A23 — Layer 2 Quota-aware Background Production Execution & Firecrawl Direct

**Status:** CLOSED / PASS — ACCEPTED M2.4.4 STANDING BEHAVIOUR
**Effective:** 31 August 2026  
**Change Control:** `CF-CHG-20260830-048`

## Purpose

Separate source qualification sampling from production enrichment volume and make Layer 2 production execution background, quota-aware and configuration-driven.

## A23.1 — Qualification is not production volume

The existing Course sample used during source qualification is a source-pattern/identity safety sample only.

- It must not be presented as the number of production websites/Courses processed.
- Qualification runs in the background.
- Provider qualification batch size and per-Provider sample size are Administration policy values, not primary-screen constants.
- The scheduled worker may keep a low per-invocation concurrency and continue via governed nonces; operator throughput is determined by the background scheduler, not manual clicks.

## A23.2 — Production execution

Production Course enrichment uses the Layer 2 execution-wave scheduler.

Default Pilot policy:
- target Course wave: 500;
- governed maximum Course wave: 1,000 unless current provider quota allows less;
- schedule remaining: enabled;
- primary acquisition route: Firecrawl direct;
- no silent paid fallback.

The accepted Course wave is clamped by configured provider entitlement, safety reserve and current-period usage.

## A23.3 — Firecrawl entitlement

Runtime/provider configuration is authority for quota values.

At A23 creation the Pilot configuration records:
- monthly Firecrawl page-unit entitlement: 5,000;
- stop/safety reserve: 250 units (5%);
- rate limit: 30/min;
- concurrency: 2;
- credential stored in Vault;
- provider budget engine must block requests that would breach the reserve.

Do not hard-code these numbers into business logic; the UI may display current effective values read from provider configuration.

## A23.4 — Operator experience

Layer 2 primary screen shows:
- selected scope;
- qualified vs still-qualifying Providers;
- executable Courses;
- effective production target wave;
- current Firecrawl used / remaining / reserve;
- background queue/runs;
- one primary action: **Start background enrichment**.

If source qualification remains:
- the action schedules qualification in the background;
- already-qualified Course work may proceed independently when safe;
- the screen reports the state as “qualification running in background”, not “Qualify 5/10 websites”.

Provider route weights, quota values, concurrency, paid-provider settings and fallback policy are edited only under Administration.

## A23.5 — Acceptance

A23 requires:
1. qualification planner sizes read from policy rather than hard-coded UI values;
2. planned qualification runs have an active scheduler/dispatcher;
3. production wave size is quota-aware;
4. Firecrawl direct is the default effective production route when enabled for the profile;
5. no silent paid fallback;
6. UI clearly distinguishes qualification samples from production Course waves;
7. scheduler/provider budget UAT and Advisor checks pass.

## Closure disposition — 1 September 2026
- Accepted under closed `CF-CHG-20260830-048` / M2.4.4.
- Replacement final acceptance `33468512515` PASS on desktop and mobile.
- This addendum remains standing behavioural/governance guidance where applicable, but does not keep M2.4.4 open.
