# Coursefinder — Running Build v1.8

**Status:** Current implementation record  
**Runtime:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Pilot code:** `msinghbs-ai/Coursefinder-Pilot`  
**Documentation/design:** `msinghbs-ai/coursefinder-admin`

## Current Position

- Phase 0 — Pilot Runtime: Complete.
- Phase 0A — RLS / Privilege Hardening: Complete.
- Phase 1 — PIM/Admin UI: In progress.
- Phase 1A — Regulatory Settings: Complete.
- Phase 3 — Layer 1 Regulatory Worker: In progress; AU CRICOS dry-run passed and controlled 100-record apply UAT is now active.

## Layer 1 AU CRICOS UAT

Successful dry-run job: `39f345a3-0d4f-4f9f-899c-c39b3c518b16`.

Verified result:

- Worker version: `layer1-v0.1.2`.
- Mode: dry-run.
- CRICOS course records parsed: 26,738.
- Selected Pilot records: 100.
- Evidence files: CRICOS Institutions CSV + CRICOS Courses CSV.
- Evidence retained in private Supabase Storage bucket `evidence`.
- SHA-256 hashes recorded.
- Pipeline job completed successfully.
- Provider CRICOS registrations after dry-run: 0.
- Course CRICOS registrations after dry-run: 0.
- No catalogue mutation occurred.

## Controlled 100-record Ingestion UI

Pilot PR #6 merged to `main` as `9b362cee9f9b7815a858ffd855c081ce98ce3ced`.

Settings → Regulatory Sources now includes a guarded AU CRICOS UAT control with three stages:

1. **Dry-run 100** — evidence/parse/telemetry only.
2. **Apply first 100** — requires explicit confirmation text `APPLY 100` before catalogue writes.
3. **Re-run same 100** — idempotency validation against the same deterministic record slice.

The result panel shows parsed/selected counts, provider/course created and linked counts, conflicts, evidence files and job ID.

Full-dataset ingestion is intentionally not exposed from the UI until the 100-record reconciliation/idempotency gate passes.

## Active Gate

Run controlled AU apply for 100 records and validate:

- provider identities created or linked correctly;
- course identities created or linked correctly;
- CRICOS registrations attached correctly;
- no unsafe/ambiguous merges;
- conflicts are visible;
- repeated apply creates no duplicate entities or registrations.

## Next Steps

1. Deploy Pilot commit `9b362cee9f9b7815a858ffd855c081ce98ce3ced` through Cloudflare.
2. Run **Apply first 100** from Settings → Regulatory Sources.
3. Inspect reconciliation counts and sampled entities/registrations.
4. Run **Re-run same 100** and prove idempotency.
5. Add CRICOS Locations + Course Locations for Campus and course-campus reconciliation.
6. Run wider AU validation, then full AU ingestion only after reconciliation controls pass.
7. Rebuild Search Projection after the canonical AU catalogue changes are accepted.
8. Continue remaining country Layer 1 adapters.
