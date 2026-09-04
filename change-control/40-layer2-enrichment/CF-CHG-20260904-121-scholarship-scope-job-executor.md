# CF-CHG-20260904-121 — Scoped Scholarship Job Executor

**Status:** IMPLEMENTED / RUNTIME TARGETED PASS  
**Milestone:** M2.4.5

Scoped Scholarship jobs are dispatched through a dedicated automation worker which reuses `layer2-acquire-v2` and the existing provider-page fan-out. The parent Recent Job retains the selected provider, execution profile, Evidence result and child acquisition job reference.

No separate scraper stack was introduced. Direct/Firecrawl/provider routing, Evidence, cost controls and canonical/publication boundaries remain those of the governed Layer 2 platform.