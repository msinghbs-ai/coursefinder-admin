# CourseFinder Admin/PIM Design Decisions v1.34

**Status:** CURRENT M2 DESIGN DECISIONS  
**Date:** 26 September 2026  
**Supersedes:** v1.33  
**Change Controls:** CF-CHG-20260903-083, CF-CHG-20260903-084, CF-CHG-20260915-247

## Decisions 38–128
Decisions 38–83 from v1.31, 84–123 from v1.32 and 124–128 from v1.33 remain authoritative and unchanged.

## Decision 129 — Old addresses stay routable when pages merge or move
When pages are merged, renamed or moved, their previous addresses keep working: they remain as hidden routes or aliases, so bookmarks, shared links and refreshes open the right page. Found when #jobs, #scheduled-tasks and #refresh-scheduling fell back to the Dashboard after the Jobs & Schedules merge (v2.15.91); fixed in v2.15.93.