# Milestone 2 Execution Addendum A7 — UAT Efficiency Review

**Status:** AUTHORITATIVE EXECUTION ADDENDUM  
**Effective:** 26 August 2026  
**Applies to:** M2.4 and later M2.x / M2.x.y workstreams unless explicitly superseded.

This addendum extends `PROJECT_INSTRUCTIONS.md`, `STANDING-INSTRUCTIONS.md` and A1–A6.

## Purpose

Automated UAT remains mandatory, but the harness itself must be treated as an evolving delivery component. Test coverage, runtime, setup overhead and duplicated work must be reviewed at major milestone boundaries so the test system does not become the delivery bottleneck.

## First optimisation point

Before substantial M2.4.1 feature work continues, reconcile and optimise the current UAT harness.

Priority changes:

1. routine push/development validation should be desktop-targeted rather than a full desktop/mobile permanent matrix;
2. mobile remains mandatory at appropriate integration/sub-milestone acceptance and release gates, not every UI iteration;
3. use change-targeted test selection during development;
4. keep one nominated full desktop/mobile acceptance matrix for closure;
5. reduce deterministic missing-selector waits to fail-fast bounds;
6. use shared navigation/test adapters;
7. separate visual/screenshot audit from functional acceptance;
8. reduce repeated Node/npm/Playwright setup overhead using deterministic `npm ci`, package caching and browser/runtime caching or an equivalent prebuilt Playwright runtime where safe;
9. avoid repeating Worker deployment-readiness waits for desktop and mobile when one readiness gate can safely serve both;
10. where desktop and mobile use the same Chromium runtime, prefer one prepared environment for acceptance where this preserves evidence isolation and failure clarity.

No optimisation may weaken RBAC/security/authority tests or remove required final mobile acceptance.

## Mandatory milestone-boundary review

At the close of every major milestone, and before starting the next major milestone, perform a bounded UAT-harness review covering:

- total workflow wall-clock duration;
- runner/job minutes consumed;
- dependency-install time;
- Playwright/browser-install time;
- deployment-settle/probe time;
- test execution time by suite/project;
- retries/timeouts and deterministic selector waits;
- desktop vs mobile duplication;
- test suites that no longer match the accepted navigation/runtime;
- flaky/transient failures versus real product failures;
- artifact generation/storage overhead;
- opportunities for targeted/integration/acceptance split improvement;
- whether caches/prebuilt runtimes remain valid and secure;
- whether any test can be retired, merged, split or moved to a less frequent gate without reducing accepted coverage.

Record the review outcome in the outgoing milestone runsheet or follow-up register before the next major milestone begins.

## Required cadence

- During active sub-milestone development: optimise only when test overhead materially blocks delivery or evidence shows a clear inefficiency.
- At every sub-milestone closure: verify the selected test tier still matches the risk/scope.
- Between major milestones: **mandatory harness-efficiency review and tuning checkpoint**.
- Before Production acceptance: re-enable/confirm the full required desktop/mobile/security/performance/recovery matrix regardless of development-time shortcuts.

## Evidence

Each review should retain, where available:

- workflow/run IDs sampled;
- observed duration before/after;
- changed workflow/test files;
- coverage intentionally retained/deferred;
- rollback path if optimisation causes missed regression or unstable CI.

## Closure rule

A UAT optimisation is successful only if it reduces delivery overhead without weakening the evidence needed to call the applicable milestone PASS.
