# Coursefinder Admin Guide v1.6

## Pilot Reset — Layer 1 Clean Execution Seed
`Settings > Regulatory Sources > Reset AU UAT` is a destructive UAT control for Platform Admin.

The reset is not a catalogue rollback to the former 7-provider / 35-course seed. It returns the Pilot to a clean Layer 1 execution state so every subsequent catalogue record can be attributed to the regulator ingestion.

### Preserved seed/configuration
- Supabase Auth user(s).
- security roles and Platform Admin user-role mapping.
- reference data needed by reconciliation, including country and study-level seed.
- active PIM Provider and Course attribute families and platform PIM configuration.
- Regulatory Sources, integration system definitions and country/global source configuration.
- private evidence bucket definition.
- database functions, RLS and platform schema/migrations.

### Removed business/runtime data
- Providers, Courses and entity-bound PIM values/categories.
- Scholarships.
- Search Documents, embeddings, embedding jobs and query cache.
- Pipeline Jobs, claims and evidence metadata.
- Reviews, suggestions, import/export rows and migration-runtime records.
- publishing entity states.
- source health telemetry from earlier runs.
- evidence bucket objects through Supabase Storage cleanup.

### Confirmation
The administrator must type `RESET AU UAT` before the reset runs.

### Expected clean baseline
- Providers: 0
- Courses: 0
- Scholarships: 0
- Search Documents: 0
- Pipeline Jobs: 0
- Evidence metadata: 0
- Review Queue: 0
- CRICOS registrations: 0

Regulatory Settings and login must remain operational after reset.

## Layer 1 clean-room UAT sequence
1. Reset AU UAT.
2. Confirm zero business/runtime counts and configured CRICOS source remains visible.
3. Run dry-run 100: evidence and job telemetry may be created, but catalogue remains 0 Providers / 0 Courses.
4. Apply first 100: Provider/Course/CRICOS counts must now arise entirely from Layer 1.
5. Search Projection is rebuilt automatically after Apply and Search Documents must equal the active canonical Course count.
6. Re-run the same 100 and confirm no duplicate entities/registrations are created.
7. Reset again if another clean-room cycle is required.

## Operational principle
Reference/configuration seed is preserved; business/runtime state is disposable during Pilot UAT. Production will not expose this destructive reset control.
