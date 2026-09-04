# CF-CHG-20260904-125 — Scholarship Scope Immediate Admin Dispatch

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5

The existing Layer 2 Admin **Start production enrichment** action now immediately dispatches executable Scholarship jobs for the selected Country / State / University scope in addition to the existing Course path. Preview remains non-executing.

## Acceptance
- Federation University targeted start: succeeded; official first-party Scholarship catalogue acquired through governed Direct route; Evidence and child Layer 2 acquisition job retained.
- RMIT University targeted start: succeeded with the official international Scholarship catalogue and Evidence retained.
- Victoria preview: 609 geographically relevant Providers, 7 currently executable Scholarship profiles, 602 explicit catalogue-or-route gaps. A Victoria Start therefore fires 7 executable jobs, not 609 speculative jobs.

## Boundaries
- Pipeline Operator rank or higher.
- Only enabled, unpaused, versioned first-party Scholarship catalogue profiles with an enabled acquisition route are executable.
- All jobs remain visible in Recent Jobs.
- No canonical mutation or publication is authorised by firing.
- Search / Website / Zoho admission remains unchanged.