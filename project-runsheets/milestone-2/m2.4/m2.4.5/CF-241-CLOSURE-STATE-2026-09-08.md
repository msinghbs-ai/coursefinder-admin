# CF-241 CLOSURE STATE — 8 September 2026

**Status:** CLOSED / PASS  
**Owning Change Control:** CF-CHG-20260908-244  
**Accepted Pilot main:** `4a927057e86935f8c5e101e434355da0b8f9bf7d`

## Outcome

CF-241 forward runtime reconciliation is complete. The superseded CF-239 fast Evidence/Layer 2 dispatcher routes are no longer selected, the accepted governed routes are restored, migration history now contains the Evidence derived-runtime dependencies required for clean replay, and Course PIM/consumer boundaries remain preserved.

## Accepted evidence

- PR #48 exact reviewed head: `e7f4e281fb7ead0215002f6071f43a6bfd549761`.
- PR #48 merge commit: `4a927057e86935f8c5e101e434355da0b8f9bf7d`.
- Exact-head Architectural Refactor Guardrails `34223507733` — PASS.
- Exact-head Pilot Frontend Build `34223507751` — PASS.
- Post-merge Pilot Frontend Build `34224432855` — PASS including local browser smoke/evidence.
- Post-merge CourseFinder Deployed UAT `34224432694` — PASS targeted desktop/evidence/status publication.
- All published Codex P1/P2 review threads resolved before merge.

## Live Pilot/UAT state

- `evidence_page` uses governed `security.admin_evidence_page(...)`.
- `layer2_ops_overview` uses governed `security.admin_layer2_ops_read(...)`.
- CF-239 fast helpers remain retained but are not selected by these dispatcher routes.
- Course PIM projection remains active.
- Evidence lineage derived cache: 847 rows / 30 triggers.
- Evidence entity-link derived cache: 136,101 rows / 29 triggers.
- Direct browser-role execution of internal cache mutators/trigger functions denied.
- No canonical catalogue/scholarship data mutation.
- Production untouched.

## Recovery note

One migration-2 Pilot attempt failed closed during sequencing verification and rolled back transactionally. The repository sequence was corrected, exact-head CI passed again, and the migration then applied successfully. Do not restore CF-239 as a unit; any future correction must remain forward-only and evidence-first.

## Next gate

M2.4.5 remains ACTIVE. Continue the open follow-up priority order from `FOLLOW-UPS.md`; the next feature workstream is H11 Provider logo completeness/source discovery. H12 ranking/contextual datasets follows H11. M2.5 remains paused until M2.4.5 closes, and Production remains a separate explicit-authorisation boundary.
