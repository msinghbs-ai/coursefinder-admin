# CourseFinder M2.5 Platform Operations Readiness v1.0

**Status:** ACTIVE OPERATIONS BASELINE
**Date:** 1 September 2026
**Change Control:** CF-CHG-20260901-051

## Environment gate procedure

Before enabling any source or integration:
1. identify Pilot or Production;
2. identify the exact capability/task;
3. attach qualification/UAT evidence;
4. set lifecycle/qualification state;
5. enable only when that environment's state permits it.

Never copy Pilot enablement into Production as a shortcut.

## Capacity procedure

Review the daily observation and separate:
- database logical size;
- Evidence object count/bytes and planning-envelope use;
- temp-spill trend;
- Evidence lineage integrity;
- backup/PITR platform status.

Current Pilot is not DB-capacity constrained: approximately 611 MB logical database and 4.62 GB Evidence objects, about 7.18% of the existing 60 GiB Evidence planning envelope.

Current HIGH state is an integrity finding, not disk exhaustion:
- 205 Evidence Storage objects have no current artifact-row match;
- 18 regulatory Evidence artifact rows have no current Storage-object match.

Do not delete either side while investigating.

## Evidence integrity follow-up

Classify unmatched records as one of:
- historical pre-ledger object;
- migrated/renamed path;
- incomplete upload;
- deleted object;
- duplicate/superseded Evidence;
- genuine orphan.

Only a separate controlled remediation may delete or repair records.

## Retention procedure

Current M2.5 retention is policy + dry-run only.

Normally immutable:
- regulatory Evidence;
- accepted source versions;
- Layer 4 decisions;
- publication decisions;
- material audit.

Future purge requires immutable exclusions, bounded deletion and post-delete integrity proof.

## Block/unblock procedure

Blocking is append-only state. Select one independent scope:
- operational;
- publication;
- Search;
- data-quality quarantine.

Record reason, actor/time, optional comment, expiry/review and history. Unblock is a superseding decision. Confirm the owning operation/consumer enforces the block before relying on it as a safety control.

## Scraper onboarding

Configured does not mean qualified. Require capabilities, credential reference, quota/cost, rate/concurrency/timeout, Evidence behaviour, retry/fallback, sample identity UAT, telemetry and explicit Pilot qualification. Production requires a separate Production gate.

## AI onboarding

Require exact task class, model, prompt/schema version, Evidence inputs, output validation, confidence and negative controls, token/call/cost ceilings, retry/fallback, benchmark and explicit environment enablement. No model receives generic canonical authority.

## Workload validation

Record separately:
- consumer read steady state;
- scheduled refresh contention;
- bulk re-ingestion;
- representative concurrent Admin/UAT/background activity.

Do not size steady-state Production solely from Mumbai Pilot ingestion/UAT contention.

## Production provisioning

Still blocked under CF-CHG-20260901-049 until organisation, region and quoted project cost are explicitly approved. Pilot must not be renamed or promoted.
