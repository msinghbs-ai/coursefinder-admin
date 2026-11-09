# Prompt for the ongoing development session: admin menu 53 → 47 tabs (SS-020, Decision 269)

**Date:** 3 November 2026
**Owner:** the ongoing StudySearch development session (integrator). The review session does not change Pilot.
**Approved:** Platform Admin, 3 Nov 2026 about 22:05 AEDT ("Approve all, build in order") and 20:49 ("let it handle the build and align with design").

Paste everything below the line into the development session.

---

**SS-020 — Admin menu consolidation (Decision 269). Build it, in order, aligned with the current design.**

Read first, in this order:
1. `docs/coursefinder-design-reference-v1.4.md` › Decision 269 (the approved scope and rules).
2. `docs/platform/ui-audit/2026-11-03-admin-menu-keep-merge-retire-review.md` (verdict per tab C01–C53, target menu, sections to retire, defects seen).
3. Mock-ups: Design canvas "StudySearch Admin Menu Review" (https://claude.ai/artifact/8hxx9qgcFkxNkXSsVJJyGw). Current board = C-ids; Final board = F-ids with the target outline of each tab and where each section comes from.
4. `docs/platform/nz-enrichment-brief/2026-11-03-enrichment-controls-audit.md` §3 and §6 (engine defects behind the Layer 2/3 fixes).

Baseline: Pilot `main` `793f642`, v2.15.439. Re-check `main` before starting; other sessions are releasing in parallel. If a tab or section named here has already changed, align with what is live and record the difference.

**Build in this order, one release per step, each with a version-pill entry:**

1. **Retire dead sections (no working control lost).**
   - Scheduled jobs › Automations: remove "Refresh schedules and one-off runs" (`ScheduledJobsWorkspace.jsx`, mounted as `RefreshWorkspace` in `mature-main.jsx`). Layer 1 registers keep Run now on Layer 1 › Sources. Mark the Layer 2 refresh policies retired in `pipeline.component_register`; deal with the 206 stale queued Layer 2 `refresh_requests` (close them, data kept 14 days).
   - Remove the "Layer 3 AI" area from Automations and the "Layer 3" block from Health checks (`PlatformHealth.jsx` `KEY_LABEL.layer3_stuck_over_1h` and its check).
   - Models & services: remove the Serper, ScrapingBee and Search pass cards (`Toolsets.jsx`) and the dropped acquisition providers (ScraperAPI, Scrape.do, ZenRows, Parsebot) from Fetchers. Retire any job, setting or table that only served them.
   - Go-live checklist: remove the Layer 3 model profiles and dropped Layer 2 provider gates.
   - Coverage › Progress: drop "Courses with each field" (duplicate of Attributes).
   - Fix the Health checks Capacity link (`#platform-health?tab=readiness` → Go-live checklist).
2. **Paging and length.** Page on the server: Layer 2/3 › Course sources (50 universities; about 74,000 px today), Entry requirements › Course entry requirements (100 rows; about 49,000 px), Layer 4 › Inbox groups (and the slow load seen 3 Nov), Reference data (edit a row in a drawer). Collapse Automations areas and Layer 1 › Sources rows by default; page "All layers". Show the Layer 2/3 header strip on Operations only.
3. **Two new tabs from merges.**
   - Platform health › **Queues & yield** = Work queues (`QueueWatch.jsx`) + Pipeline yield (from `IntegrationQueue.jsx`). Integration queue keeps the defect register only.
   - Models & services › **Services & limits** = Services + Toolsets & limits + Fetchers, one card per service (Firecrawl: switch, monthly cap, course-page search budget, credits today; direct read; OpenRouter balance and spend today; database jobs and edge calls; notices). AI model switches move to AI & OpenRouter.
4. **Layer 2/3 consolidation.**
   - Coverage › Progress → Layer 2/3 › Operations (journeys, hourly history); Firecrawl and AI today → Services & limits.
   - Build adapter tab → Adapter builder step 0 and a row action on Universities (Decision 267's one-click build stays).
   - Coverage › Attributes run controls (Fill the gaps, Stalled fields Fill now, Provider descriptions) → Enrich fields. Attributes keeps read-only measures with a "Fill on Enrich fields" link carrying country and field. Layer 4 review readiness → a header line on the Inbox.
   - Scholarships › Coverage "Settings and jobs" fold → Layer 2/3 › Scholarships.
   - Engine fixes from the controls audit: item 4 (Enrichment plan redo hold), 7 (Enrich fields dedupe), 8 (plan Cancel stops child tasks), 9 (spend estimate), 10 (retry and export).
   - Target Layer 2/3 tab order: Operations · Universities · Enrich fields · Enrichment plan · Adapter builder · Course sources · Flags · Scholarships.
5. **Catalogue and settings moves.** QILT and PRISMS tabs → Rankings › Datasets "View data"; Overview cards link there. Coverage › Courses Link refresh and portals → Settings.
6. **Same releases:** Platform guide, both SOPs and `docs/sops/` mirrors use the new names (UR-09); component register updated; UI catalogue updated.

**Rules (all from the design reference):**
- Old addresses of every merged or removed tab redirect via `LEGACY` in `nav-map.js` (page + tab + filter), and the guide's Open buttons land on the exact tab (UR-09).
- A retirement removes its scripts, jobs and tables in the same change; data kept 14 days (Decision 260 housekeeping). No growing leftovers.
- No consumer API change (Decision 266); run the frozen-surface guard each release.
- Roles unchanged: each moved section keeps its current minimum role and server-side checks.
- Phone width must keep working for Courses, the course blade and Layer 4 › Inbox.
- Standing release rules apply: full suite green, migration md5 checked against live, live dry run where applicable, change-control entries, deploy, confirm the live version string, record in the mandate file. Destructive table drops still go to the Platform Admin as paste files.
- If anything in the review conflicts with what is now live, or a merge would remove a control someone still needs, stop and raise it as "DECISION REQUIRED — SS-020" instead of guessing.

**Report back:** at each step, a compact Task / Status / Result table, the release number, and the before/after tab count. Finish at 47 tabs on 22 pages, matching the Final board.
