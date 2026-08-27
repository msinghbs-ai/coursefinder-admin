# CourseFinder Data Operations Admin Guide v1.2

**Status:** CURRENT M2.4 DATA OPERATIONS GUIDE  
**Date:** 26 August 2026  
**Supersedes:** `docs/coursefinder-m2-4-data-operations-admin-guide-v1.1.md`  
**Change Control:** `CF-CHG-20260826-043`  
**Pilot UI:** PIM Admin v2.15.7 and later until superseded

## 1. Authority model

CourseFinder uses four enrichment authority layers only:

`Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition/extraction → Layer 3 Evidence-aware AI interpretation → Layer 4 terminal human resolution`.

Search and Publication are downstream states. Layer 2, Layer 3 and Layer 4 must never redefine a Layer 1 regulatory identity.

## 2. Navigation

Routine regulatory operations are under **Data Operations → Layer 1 — Regulatory**. Generic Settings, parser qualification, destructive database reset and other experimental/UAT utilities are not normal Layer 1 controls.

The normal Layer 1 workspace is deliberately organised into:

1. Source Health;
2. Current / Next Job;
3. Progress;
4. Reconciliation;
5. Evidence / Provenance;
6. Schedule / Recheck;
7. Blockers / Required Actions.

## 3. Roles and authority

### Pipeline Operator — rank 4 or above

A Pipeline Operator may:

- open and read Layer 1 operations;
- inspect governed source URLs, authority domains, expected format and counts;
- inspect queue/progress/reconciliation/Evidence/schedule state;
- run **Validate source** against an already-governed AU or NZ source.

A rank-4 operator cannot change source configuration, queue APPLY/dry-run execution, pause a source, recover a stuck run, or bypass variance controls.

### Platform Admin — rank 6

A Platform Admin additionally may:

- save governed source configuration;
- queue dry-run and APPLY execution;
- explicitly acknowledge a variance warning before APPLY;
- pause/resume source processing;
- retry/resume a failed or blocked run;
- recover a genuinely stuck run after confirming its worker is no longer active.

All meaningful authority is rechecked server-side. Hiding a button is not the security boundary.

## 4. AU CRICOS source validation

The accepted AU authority is the Australian Government CRICOS dataset on `data.gov.au`.

Validation performs all of the following before execution is eligible:

- requires HTTPS;
- checks the actual host against approved authority domains;
- resolves the CRICOS CKAN package;
- verifies the required Institutions, Courses, Locations and Course Locations resources exist;
- retrieves the consolidated archive;
- identifies the authoritative Courses CSV;
- verifies the CRICOS Course Code identity column;
- counts active rows from source `Expired` semantics rather than using a hard-coded record count;
- hashes the Courses payload and records the source hash;
- compares the observed active count with the previous accepted baseline.

The M2.4.1 baseline was 26,648 active CRICOS Course rows. The count is a comparison baseline, not a hard-coded parser assumption.

## 5. NZ NZQA source validation

The accepted NZ authority is the NZQA Education Organisations directory on `nzqa.govt.nz`.

Validation checks HTTPS/approved authority domains, acquires the UNI, POLLY, WANA, PTE and GTE listing pages, deduplicates stable NZQA `providerId` values, hashes the authoritative listing content and compares the total with the accepted baseline.

During M2.4.1 live validation the source moved from the accepted baseline of 409 to 411 providers. The resulting variance was approximately 0.489%, therefore PASS under the configured guardrail rather than an automatic failure.

## 6. Expected counts and variance guardrails

Each governed source profile retains:

- expected-count kind;
- previous accepted count;
- latest observed count;
- warning percentage;
- block percentage;
- optional minimum/maximum bounds;
- latest variance percentage and decision.

Current initial guardrails are 5% warning and 20% block for AU and NZ unless changed through governed configuration.

A `warn` state requires explicit operator acknowledgement before APPLY. The browser must not silently acknowledge the warning. A `block` state prevents execution until the authority/count issue is resolved and the source is revalidated.

## 7. Queueing, progress and reconciliation

Only one queued/running Layer 1 operation may exist per source. Duplicate active work is blocked at database level.

The workspace exposes queue depth/position, stage, heartbeat, processed versus expected records, runtime and reconciliation counters for Created, Updated, Unchanged, Rejected, Conflicted and Failed.

Retries carry explicit linkage to the failed run and a resume cursor. Idempotency keys prevent accidental replay. A completed APPLY whose validated source hash matches the previously accepted source hash takes the `no_change` path and skips downstream ingestion.

## 8. Failed and stuck run recovery

A failed/blocked run may be retried/resumed using its recorded resume cursor.

A running job is considered stuck when its heartbeat is older than 30 minutes. **Recover stuck run** is available only to Platform Admin and only when the database independently confirms that the run is still `running` and its heartbeat is older than 30 minutes. Before using it, confirm the previous worker is no longer active. Recovery marks the stale run failed/recovered; it does not delete Evidence or canonical history.

## 9. Schedule / Recheck

Layer 1 has a dedicated authoritative-source verification scheduler running every 15 minutes at minutes 5, 20, 35 and 50.

Scheduled work is intentionally non-destructive by default. It uses the accepted one-time nonce mechanism, validates the authoritative AU/NZ source, updates health/count/hash state, and records one of:

- `completed_unchanged`;
- `completed_changed`;
- `failed`/blocked.

A changed source does not silently APPLY canonical data. It creates an operator-visible change condition for governed ingestion review.

Paused sources are excluded from scheduled verification dispatch. A scheduled request left running beyond the 30-minute heartbeat window is failed visibly rather than remaining indefinitely active.

## 10. Evidence and provenance

Layer 1 shows the source configuration version, current and accepted hashes, Evidence count/latest capture, Layer 1 run ID and downstream worker Job ID.

Use **Evidence** to inspect governed captured source material and **Jobs & Runs** to inspect execution details. HTTP success alone does not prove factual success.

Source-operation configuration versions and Evidence are governed history. They are not deleted by Layer 1 transient housekeeping.

## 11. Housekeeping

Transient terminal Layer 1 queue entries expire after 30 days. Daily housekeeping runs at 03:17 UTC and may delete only expired terminal queue records.

It must not delete:

- Evidence artifacts;
- source-operation configuration versions;
- canonical history;
- retained Job/Evidence lineage required by governance.

## 12. Source configuration

Platform Admin source configuration includes source URL, authority name/domains, expected source format, verification/ingestion cadence, variance thresholds and optional expected-record bounds.

Saving configuration creates a retained configuration version and forces the source back to `unverified`; validation must pass again before dry-run/APPLY execution. Reachability alone never overrides the approved authority-domain check.

## 13. Alerts and blockers

Treat these separately:

- source verification overdue/stale;
- authority/format validation failed;
- abnormal record-count variance;
- repeated validation/run failures;
- running heartbeat older than 30 minutes;
- scheduled-dispatch failure;
- Evidence/storage growth;
- worker/reconciliation failure.

Do not collapse them into a generic ingestion failure because recovery and governance decisions differ.

## 14. Escalation

Do not bypass a blocked source, authority mismatch, explicit variance acknowledgement, role boundary, Evidence requirement or idempotency guard to make a run succeed. Record the blocker under the active Change Control and use the applicable technical UAT/recovery path.

## 15. Layer 2 Course enrichment operations — M2.4.2

Routine Course enrichment is under **Data Operations → Layer 2 — Enrichment**.

The normal operator journey is:

`Country → Fetch scope (Country / State / University) → Preview → Discover & sync / Sync now → Progress → Results → Evidence / Jobs`.

Only executable, non-paused Course profiles appear as active scope options. A paused/source-limited profile is surfaced under **Blockers / required actions** rather than silently executed.

### Deterministic discovery and Course identity

Layer 2 may discover a first-party Course detail URL, but discovery does not redefine Layer 1 Course identity.

For RMIT, a search-result title match is not sufficient. The accepted M2.4.2 rule is:

1. candidate must be a first-party HTTPS RMIT Course-detail path;
2. title/path ranking must meet deterministic match rules;
3. the current first-party Course detail page must contain the expected CRICOS code;
4. only then may the candidate become `selected=true` and queueable.

Current detail verification retains separate native HTML Evidence and provider-attempt telemetry with `detail_cricos_verified` / `detail_cricos_missing`.

Legacy/current CRICOS title collisions must resolve conservatively. If the current Course page does not contain the expected CRICOS, the result is an identity mismatch, not a title-only success.

### Provider routing

The accepted routine order is governed by the source profile route list, currently Direct HTTP first then Firecrawl where configured, followed by remaining approved providers. Fallback reasons are explicit.

Direct HTTP remains the preferred zero-vendor-fee path when it provides sufficient source content. Rendered-search acquisition may fall through to Firecrawl. Unknown-cost fallback remains blocked.

Vendor concurrency, rate limits, credentials and billing model are Advanced controls. Provider credentials stay server-side/Vault-backed and are never displayed back to the browser.

### Managed batches and terminal state

Selected governed URLs are processed through managed Layer 2 batches. Terminal item states are retained as resolved L2, Layer 3 required, blocked or cancelled. Late runner reconciliation must not resurrect a cancelled batch.

Discovery restarts are idempotent for terminal evaluated outcomes of the current immutable profile version. Acquisition/provider failures remain retryable.

### Schedule / recheck

Layer 2 Course-profile refresh uses the common refresh-policy/request substrate plus the Layer 2 managed-batch dispatcher.

The dispatcher cron runs at minutes **03, 18, 33 and 48** each hour.

M2.4.2 initially creates weekly Course-profile refresh policies disabled. Enable a profile only after accepted full-run behaviour, cost/quota and source quality are known. A paused/source-limited profile must not be silently scheduled.

### Housekeeping

Layer 2 recovery housekeeping runs daily at **03:27 UTC**.

It may recover stale provider attempts, abandoned Layer 2 Jobs and stale managed batches. It is recovery-only and must not delete:
- Evidence;
- immutable source-profile versions;
- provider-attempt history;
- managed-run history;
- canonical history.

### Operational alerts

The Layer 2 blockers panel consumes governed computed alerts for:
- stale managed runs;
- paused Course profiles;
- blocked run items;
- repeated acquisition-provider failures;
- provider quota approaching the configured reserve.

Alert read failure must not prevent Country/Scope controls from loading.

## 16. Current M2.4.2 country boundary

- AU Course enrichment is the authorised current scope.
- NZ first-party Layer 2 Course enrichment remains **DEFERRED** pending source qualification/onboarding.
- UQ broad deterministic enrichment is accepted evidence.
- Federation is partially queueable and otherwise explicitly source-limited.
- RMIT broad discovery must use current first-party detail-page CRICOS verification; pre-v1.3.0 title-only decisions are superseded.
