# Prompt for the ongoing development session: SS-020 follow-up

**Date:** 4 November 2026 · **Decisions:** Platform Admin about 05:40 (Decision 269 amendments)

Paste everything below the line.

---

**SS-020 follow-up (Decision 269 amendments, 4 Nov).** Read `docs/platform/ui-audit/2026-11-04-ss020-implementation-review.md` and the Decision 269 amendments first.

1. **Rewire, then retire Refresh schedules.** Make Layer 1 › Sources' Schedule edit the three Layer 1 refresh policies in `pipeline.refresh_policies` (the rows `refresh_scheduler_tick_impl` reads), with the same role checks as today. Stop writing `layer1_source_operations.verification_cadence_days` or retire it in the same change. Verify that one register's next run moves when its schedule is changed on Layer 1 › Sources. Then remove "Refresh schedules and one-off runs" from Scheduled jobs › Automations (`ScheduledJobsWorkspace.jsx` via `Refresh` in `m2-3-intelligence-entry.jsx`), mark it and its now-unused functions retiring in `pipeline.component_register`, and redirect any old address.
2. **Link refresh stays** on Coverage › Courses; no move. Note it in the UI catalogue.
3. **Layer 4 › Inbox:** it still hits the database time-out on load and renders about 22,000 px on v2.15.458. Fix the slow read and page each university group, keeping phone width working.
4. **Text:** remove "Layer 2 → conditional Layer 3" wording left in schedule rows, and say "47 tabs on 20 pages" wherever 22 pages is stated.

Standing release rules apply (full suite, md5 against live, version-pill entry, change control, no consumer API change). Report a Task / Status / Result table per item.
