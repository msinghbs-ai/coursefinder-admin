# CF-CHG-20260908-244 — M2.4.5 architectural hardening and CF-241 runtime reconciliation

**Status:** CLOSED / PASS  
**Initiated:** 8 September 2026, Australia/Melbourne  
**Primary category:** 70-security-platform  
**Related surfaces:** architecture/data model, Admin/PIM UX, UAT/release operations  
**Milestone:** M2.4.5 pre-production hardening

## Purpose

Close the four-phase non-breaking architectural hardening of the Pilot application and the reserved CF-241 forward reconciliation of retained CF-239 runtime changes, while preserving governed browser-read, Evidence, PIM, consumer-contract and Production boundaries.

## Accepted implementation

### Architectural hardening

- PR #45 — architectural guardrails and typed/domain boundaries.
- PR #46 — governed Course-detail PIM payload and dynamic Course PIM rendering.
- PR #47 — exact deployed-revision Course PIM UAT and deployment-currentness hardening.
- TypeScript migratory mode, ESLint, Vitest, typecheck/lint/unit/build scripts and architectural CI are active.
- Browser reads remain through `public.admin_read` / `src/lib/supabase.js`; no direct browser PIM/catalogue table reads were introduced.
- Course PIM rendering preserves hardcoded core fields and enforces accepted review state, family membership, current validity, locale/channel partitions, JSON fidelity and scope-safe option labels.

### CF-241 runtime reconciliation

- PR #48 — forward reconciliation of superseded CF-239 runtime routing.
- Accepted merge commit: `4a927057e86935f8c5e101e434355da0b8f9bf7d`.
- `public.admin_read('evidence_page',...)` restored to governed `security.admin_evidence_page(...)`.
- `public.admin_read('layer2_ops_overview',...)` restored to governed `security.admin_layer2_ops_read(...)`.
- Superseded fast helper definitions/indexes are retained for separate planner review but are no longer selected by those dispatcher routes.
- Missing Evidence replay dependencies were restored into migration history, including lineage and entity-link derived caches, helpers, trigger topology and remaining Evidence helper functions.
- Browser roles cannot directly execute internal SECURITY DEFINER cache mutators/trigger functions.
- Evidence stale/current/expired and rejected/extracted precedence was reconciled.
- No canonical catalogue/scholarship data semantics were changed.

## Pilot/UAT evidence

### PR #47 closure

- Merge commit `259ddff8a1cfe90db77586a47f335c329f75488a`.
- Course PIM Deployed UAT `34214752684` — PASS.
- Pilot Frontend Build `34214752780` — PASS.
- CourseFinder Deployed UAT `34214752629` — PASS.

### PR #48 / CF-241 closure

- Exact reviewed head `e7f4e281fb7ead0215002f6071f43a6bfd549761`.
- Architectural Refactor Guardrails `34223507733` — PASS: typecheck, lint, unit tests, build, exact Cloudflare preview verification and bounded governed UAT.
- Pilot Frontend Build `34223507751` — PASS.
- Post-merge Pilot Frontend Build `34224432855` — PASS, including browser smoke and evidence upload.
- Post-merge CourseFinder Deployed UAT `34224432694` — PASS targeted desktop validation, evidence upload and commit-status publication.
- All published Codex P1/P2 review threads were resolved before merge.

## Runtime verification

- Governed Evidence route active; CF-239 Evidence fast route absent from dispatcher.
- Governed Layer 2 overview route active; CF-239 Layer 2 fast route absent from dispatcher.
- Course PIM projection preserved.
- Evidence lineage derived cache: 847 rows; accepted 30-trigger topology present.
- Evidence entity-link derived cache: 136,101 rows; accepted 29-trigger topology present.
- Direct `anon` / `authenticated` execution of derived-cache mutators/trigger functions denied.
- Zoho and Website lookup smoke remained clean and do not depend on the reconciled Admin routes.

## Defect/recovery notes

- PR #47 corrected a false-negative post-merge UAT routing/currentness problem without rewriting historical A16 tests.
- During CF-241 Pilot application, one migration-2 attempt correctly failed closed because migration 1 had already changed the expected function shape; the transaction rolled back, sequencing was corrected in source, exact-head CI re-passed and the migration then applied successfully.
- Codex reviews exposed migration-history/runtime drift for Evidence helper/cache dependencies; each valid finding was restored as governed replayable source rather than weakening tests or runtime semantics.

## Rollback / recovery

- Source rollback is via the merge-parent history preceding PRs #45–#48; do not delete the retained backup branch `backup/2.15.74_8-9-2026_10AM` without separate authorisation.
- Database recovery must be forward-corrective and preserve canonical data/Evidence history; do not restore superseded CF-239 as a unit.
- Production was not changed by this work and remains a separate explicit-authorisation trust boundary.

## Programme outcome

The original four-phase hardening objective is complete for the current scope, and CF-241 is CLOSED / PASS. M2.4.5 remains ACTIVE for its remaining follow-ups. The next recorded feature priority is H11 Provider logo completeness/source discovery, followed by H12 ranking/contextual dataset work, subject to the standing M2.4.5 priority and security gates.
