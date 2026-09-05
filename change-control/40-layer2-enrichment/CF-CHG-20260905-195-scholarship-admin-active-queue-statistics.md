# CF-CHG-20260905-195 — Scholarship Admin Active Queue Statistics

**Status:** IMPLEMENTED / RUNTIME PASS / RELEASED v2.15.64  
**Milestone:** M2.4.5

## Change

`security.admin_scholarship_runtime_read()` now reports `detail_ready` and `needs_review` from active `status='discovered'` candidates only. Historical acquired/rejected/superseded rows may retain their last classification for audit but no longer inflate the Admin executable-work summary.

## Reason

CF-189 through CF-194 fixed the operational queue itself. The guarded Admin read still counted classification text without lifecycle state, so the UI could show stale detail-ready work after the actual queue reached zero.

## Acceptance

Pilot post-change checks:

- canonical international Scholarships: **263**;
- published: **0**;
- active discovered/detail-ready: **0**;
- active Scholarship scope jobs: **0**;
- reconciliation-ready: **0**;
- applied generic/support source records: **0**;
- canonical-unpublished trace rows missing Evidence/source record: **0**;
- invalid calculated financial rows: **0**;
- `authenticated` and `anon` cannot execute canonical Scholarship reconciliation directly.

UI release **v2.15.64** records this queue-truth correction. CF-102 Provider Logo functionality is unchanged.
