# M2.4.1 — Layer 1 Regulatory Operations Maturity & Automation

**Status:** NEXT / READY TO START
**Parent:** M2.4

## Objective

Turn Layer 1 from an implementation/diagnostic surface into a mature regulatory-operations workspace for Platform Admin/operators, initially proving the complete lifecycle for Australia and New Zealand.

## Required operator journey

`Regulatory source → validate source → estimate/identify available records → approve/enable ingestion → queue/run → live progress → retained logs/Evidence → reconciliation → scheduled recheck → housekeeping`

## Scope

### Source administration
- remove/suppress experimental, probe, reset and qualification buttons from the normal operator path;
- allow authorised Admin users to add/edit regulatory source URL/location and source metadata without exposing secrets;
- validate URL/source reachability, MIME/content type, expected authority/domain and parser compatibility before enabling;
- version source changes and retain who/when/why;
- prevent one country/source from silently redefining another source's identity contract;
- support at minimum current AU CRICOS and NZ NZQA sources.

### Pre-ingestion assessment
- automatically inspect the source and show expected/available record count where deterministically measurable;
- show prior accepted count, latest discovered count and variance;
- flag abnormal drops/growth before canonical apply;
- show source freshness, last successful acquisition and next scheduled recheck.

### Queue and execution
- authorised operator can enable/disable ingestion and schedule/manual-run a bounded job;
- create governed queue/batch/job state rather than blocking browser requests;
- show queued/running/completed/failed/cancelled/retry-required;
- show progress bar with discovered/selected/downloaded/parsed/validated/accepted/rejected/unchanged/failed counts;
- show elapsed time, current stage, last heartbeat and retry/resume state;
- prevent duplicate concurrent ingestion for the same governed source unless explicitly supported.

### Evidence and logs
- every acquisition retains source URL/version, timestamp, hash, job/run identity and Evidence;
- job detail links directly to Evidence and affected Providers/Courses;
- logs use progressive disclosure: management summary → operational detail → diagnostics;
- errors must be actionable and redact credentials/secrets;
- failed parse/validation retains diagnostic Evidence without creating partial canonical corruption.

### Reconciliation and safe apply
- stable Layer 1 identity remains authoritative;
- show creates/updates/unchanged/rejected/conflicts before/after run;
- abnormal identity/count changes require governed warning/approval path;
- apply must be idempotent/replayable where contract expects it;
- Search/Publication side effects remain separately governed.

### Scheduling, rechecks and housekeeping
- configurable source-specific recheck schedule;
- missed/failed schedule visibility and retry policy;
- cleanup of expired transient queue/nonce/temp state after safe completion;
- Evidence retention follows governed policy, never blind destructive age cleanup;
- job/log retention and archiving policy;
- stale source and stuck-job detection;
- daily/weekly housekeeping metrics in Admin.

### UI/UX maturity
- one Layer 1 Regulatory landing page with country/source cards, health, freshness and next action;
- no normal operator dependency on Settings/Supabase;
- clear Add/Validate/Enable/Schedule/Run/Recheck actions according to role;
- progress bars and job timeline;
- concise successful-run summary plus drill-through;
- responsive desktop/mobile status and review experience;
- contextual help links and maintained in-product release notes.

## Automated UAT

At minimum prove for AU and NZ:
- valid source validation;
- malformed/unapproved URL rejection;
- inaccessible source handling;
- record-count assessment;
- queue creation and duplicate-run guard;
- successful end-to-end ingestion;
- progress state transitions;
- parser/validation failure rollback/no partial corruption;
- Evidence/log lineage;
- role/rank/anon negative access;
- secret leakage checks;
- replay/idempotency;
- retry/resume where supported;
- scheduled recheck contract;
- housekeeping cleanup;
- desktop/mobile deployed UAT;
- frozen M1/M2 regression.

## Exit gate

M2.4.1 closes only when AU and NZ can be operated end-to-end from the mature Layer 1 UI with validated sources, governed queue/progress, retained Evidence/logs, safe reconciliation, scheduling/recheck and housekeeping without relying on experimental controls or direct Supabase operations.
