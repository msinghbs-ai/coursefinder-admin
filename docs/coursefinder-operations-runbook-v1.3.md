# CourseFinder Operations Runbook v1.3

**Status:** CURRENT M2.4 OPERATIONS RUNBOOK  
**Date:** 26 August 2026  
**Supersedes:** `docs/coursefinder-operations-runbook-v1.2.md`  
**Change Controls:** existing M2 controls plus `CF-CHG-20260826-043`

## 1. Operating boundary

CourseFinder operates four enrichment authority layers only:

`L1 authority → L2 acquisition/extraction → L3 Evidence-aware AI → L4 human resolution`.

Search/Publication are downstream product states. No operational convenience path may bypass Layer 1 identity or Evidence governance.

## 2. Layer 1 AU/NZ regulatory operating procedure

### Routine source check

1. Open **Data Operations → Layer 1 — Regulatory**.
2. Confirm Source Health, authority name, source URL, approved domains and expected format.
3. Confirm latest expected count versus previous accepted count and the variance decision.
4. Inspect Schedule / Recheck for last result/error and next verification.
5. Run **Validate source** when manual validation is required.
6. Do not queue execution while verification is failed, blocked, stale or the source is paused.

### AU CRICOS validation

Confirm the CKAN package resolves on the approved `data.gov.au` authority, the four required CRICOS resources exist, the consolidated archive is valid, the Courses CSV exposes CRICOS Course Code, and active/expired row semantics are derived from `Expired`. Do not reintroduce a hard-coded 26,648 assertion; it is only the accepted baseline used for variance comparison.

### NZ NZQA validation

Confirm all five governed NZQA organisation-listing classes are reachable on the approved NZQA authority and stable `providerId` values are deduplicated. During M2.4.1 the live count was 411 versus accepted 409; this was within the configured PASS guardrail.

## 3. Variance handling

- `pass`: source is eligible subject to other controls.
- `warn`: investigate the observed delta. APPLY requires an explicit Platform Admin confirmation in addition to the server-side acknowledgement flag.
- `block`: do not ingest. Resolve the authority/count/format issue and revalidate.

A simulated AU fall from 26,648 to 1,000 rows produces a blocking variance and is expected to reject APPLY.

## 4. Queue, retry and resume

Only one queued/running operation per source is permitted.

For a failed or blocked run:

1. inspect Job/Evidence/reconciliation and the recorded error;
2. confirm the prior worker is terminal;
3. use **Retry / resume**;
4. verify the retry links to the previous run;
5. verify the resume cursor advances from the last completed boundary;
6. verify reconciliation counters accumulate rather than reset;
7. never bypass idempotency-key protection.

## 5. Stuck run recovery

A regular Layer 1 run is stuck only when it remains `running` and its heartbeat is older than 30 minutes.

Before recovery:

1. inspect Jobs & Runs and worker logs/Evidence;
2. establish that the prior worker is no longer executing;
3. use **Recover stuck run** as Platform Admin.

The server refuses recovery for a non-running or fresh-heartbeat run. Recovery marks the stale run failed with `stuck_recovered`; it does not erase Evidence, configuration versions or canonical history. Retry/resume may then be used as a separate governed action.

## 6. Scheduled authoritative-source verification

The Layer 1 scheduler runs at minutes 5, 20, 35 and 50 of each hour.

Scheduled verification uses a two-minute, single-use nonce and is non-destructive by default. It validates the source and records changed/unchanged/failure state. It does not silently APPLY canonical data.

If a source is paused, no scheduled verification should be dispatched. A dispatched request older than 30 minutes is automatically failed with an operator-visible schedule error.

## 7. Housekeeping

Daily at 03:17 UTC, Layer 1 housekeeping deletes only terminal queue records whose 30-day retention has expired.

Operational verification after housekeeping must confirm:

- expired transient queue entry removed as expected;
- Evidence artifact count unchanged;
- source-operation version count unchanged;
- no canonical/source-history deletion.

## 8. Evidence handling

Preserve authoritative Evidence and its lineage. Failed-attempt Evidence remains valuable operational evidence and must not be deleted merely because a later retry succeeds.

Every consequential Layer 1 investigation should be able to identify:

- governed source/profile version;
- source URL and authority domains;
- current/accepted source hash;
- Layer 1 queue run;
- downstream worker Job where applicable;
- Evidence captured by the worker;
- reconciliation result.

## 9. Layer 2 provider comparison procedure

Compare Direct HTTP, Scrape.do, ScraperAPI, Firecrawl, ZenRows and future governed providers using successful bounded acquisition, access success, Evidence quality, deterministic extraction, correctness, duration/retries, cost/quota and downstream unresolved rate.

Do not silently reorder production routes from trial data. Record the accepted change under Change Control.

## 10. Extraction failure procedure

If acquisition succeeds but deterministic extraction cannot establish the required fact, retain Evidence, record the failure class, use permitted provider fallback, then route unresolved Evidence through L3 and finally L4 when required. Never manufacture a value to improve completeness.

## 11. Scholarship, QILT and PRISMS operations

Scholarships use the governed Layer 2 provider/Evidence substrate. `Not discovered` is not equivalent to `none`.

QILT/PRISMS remain contextual observations at their native grain and must not be projected as false Course-level regulatory truth.

## 12. Layer 4 terminal handling

Layer 4 receives unresolved/conflicting/consequential cases with the complete Evidence package. Human resolution is terminal for enrichment authority. There is no Layer 5 queue.

## 13. Incident classification

Treat separately:

- authoritative source unavailable;
- source authority/domain mismatch;
- source shape/format changed;
- abnormal count variance;
- scheduled verification failure;
- stuck Layer 1 run;
- idempotency/duplicate-active-run block;
- provider credential/access/rate-limit failure;
- malformed/low-value Evidence;
- deterministic extraction defect;
- L3 ambiguity;
- canonical mapping conflict;
- stale data;
- browser/UAT harness failure.

Do not collapse these into a generic `pipeline failed` condition.