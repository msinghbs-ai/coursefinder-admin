# CF-CHG-20260904-122 — Scholarship Scope Executor Private RPC Boundary

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5

The first executor attempt confirmed that direct REST access to private `pipeline.jobs` is not an accepted boundary. No schema exposure was widened. Narrow service-role-only RPCs now provide job execution context and job-state mutation.

`anon` and ordinary `authenticated` roles receive no direct private-table access. This preserves the existing private pipeline/RLS architecture.