# Coursefinder Running Build v2.0

## Current Phase
Phase 3 — Layer 1 Regulatory ETL / AU CRICOS clean-room UAT.

## Execution Runtime
- Cloudflare serves the Pilot SPA only.
- Supabase Edge Function `layer1-register-etl` executes Layer 1.
- Supabase Edge Function `pilot-reset` provides the controlled clean-room reset.
- Both Edge Functions require JWT authentication; Platform Admin authorisation is enforced server-side.

## Reset Baseline
Reset now removes all business/runtime UAT data while preserving only platform configuration/reference seed required to authenticate and execute Layer 1.

Preserved:
- Supabase Auth users.
- `security.roles` / `security.user_roles`, including Platform Admin.
- reference seed required by Layer 1, including AU country and study levels.
- active PIM Provider and Course attribute families and PIM configuration.
- Regulatory Settings / integration systems / global pipeline sources and country source configuration.
- private `evidence` bucket definition.
- database functions, RLS/security configuration and migration schema.

Removed:
- Providers, Courses, Campuses, Collections and entity-bound PIM data.
- Scholarships.
- Search Documents, embeddings, embedding jobs and query cache.
- Pipeline Jobs, claims and evidence metadata.
- Review, suggestion, import/export and migration-runtime records.
- publishing entity states.
- provider-scoped runtime acquisition/extraction configuration.
- source health timestamps/runtime hashes.
- physical evidence files via `pilot-reset-v0.2.0` Storage `emptyBucket` call.

## Verified Database Reset
Migration 037 was applied and the reset RPC was executed against Mumbai Pilot.

Verified post-reset business/runtime state:
- Providers: 0
- Courses: 0
- Scholarships: 0
- Search Documents: 0
- Pipeline Jobs: 0
- Evidence metadata: 0
- Review Queue: 0
- CRICOS Course Registrations: 0
- CRICOS Provider Registrations: 0
- Search generation: 1

Reset removed 42 entity-registry rows, 9 pipeline jobs and 15 evidence metadata rows from the prior UAT state.

Verified execution seed remains:
- Auth users: 1
- User-role assignments: 1
- Platform Admin role: present
- active Provider/Course PIM families: 2
- AU country seed: present
- study-level seed: 9
- active regulatory sources: 9
- AU CRICOS integration system: present
- private evidence bucket definition: present

## Storage Note
The manual SQL invocation used to validate migration 037 removed evidence metadata but did not invoke the Edge Function's Storage cleanup. Two historical physical evidence objects remain until `Reset AU UAT` is invoked once through the UI. `pilot-reset-v0.2.0` now empties the evidence bucket as part of the reset transaction workflow.

## Next Gate
1. Deploy latest Pilot UI.
2. Invoke `Reset AU UAT` once from Settings to clear the remaining physical evidence objects.
3. Confirm all reset statistics are zero and Regulatory Settings still shows the configured sources.
4. Run AU CRICOS dry-run 100 from the clean baseline.
5. Apply first 100 and verify every Provider/Course/registration shown is Layer 1-derived.
6. Verify Search Documents equal canonical active Courses after Apply.
7. Re-run same 100 and prove idempotency.
8. Add CRICOS Locations and Course Locations before wider/full AU ingestion.
