# CF-CHG-20260905-201 — Scholarship Stale Layer 2 Job Truth Cleanup

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5  
**Layer:** Layer 2 — Jobs / operational truth

## Problem

Nine historical Scholarship `layer2_acquisition_v2` jobs remained `running` for more than 12 hours even though they had no terminal result. They were from earlier Federation, ANU, Melbourne and Monash acquisition attempts and caused the Admin/runtime active-job count to overstate executable work.

## Correction

Only Scholarship jobs meeting all of the following are closed by CF-201:

- `domain = scholarship`;
- `job_type = layer2_acquisition_v2`;
- `status = running`;
- `started_at` older than 12 hours.

Those rows are marked **failed**, never succeeded. Existing Evidence and lineage remain untouched. Each row records a CF-201 stale-close reason and timestamp.

## Runtime proof

- stale jobs closed: **9**;
- active Scholarship jobs after cleanup: **0**;
- active `detail_ready`: **0**;
- canonical Scholarships: **266**;
- published Scholarships: **0**.

## Boundary

CF-201 is operational truth cleanup only. It does not retry jobs, alter canonical Scholarship data, remove Evidence, create Course mappings or authorise Publication.
