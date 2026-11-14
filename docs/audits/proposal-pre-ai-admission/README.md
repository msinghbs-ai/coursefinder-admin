# Pre-AI admission gate: proposal files (not applied)

Proposal files for [`../studysearch-pre-ai-admission-gate-design.md`](../studysearch-pre-ai-admission-gate-design.md). Nothing here is merged, deployed or switched on.

| File | Goes to (Pilot repo) | Notes |
|---|---|---|
| `pre-ai-admission-gate-shadow.patch` | applied at repo root with `git apply` | Applies cleanly on `main` `c4ffa31` and `aa34395`. On #1139 it conflicts on one import line only (keep both lines). Contains the four files below except the migration. |
| `admission-gate.ts` | `supabase/functions/coverage-sweep/admission-gate.ts` | New pure module, pre-ai-admission-v1. Passes `deno check`. |
| `admission-harness.mjs` | `scripts/admission-harness.mjs` | `node --experimental-strip-types scripts/admission-harness.mjs --self-test` passes 16/16. |
| `DRAFT_cf247_pre_ai_admission_shadow.sql` | `supabase/migrations/<number>_cf247_pre_ai_admission_shadow.sql` | Number at bundling time and rehearse rolled back first. Ships with the gate and every enforcement switch off. Parsed with libpg_query; not executed. |

`index.ts` is delivered as a patch, not a full file, because the open #1139 changes the same file. A full-file copy would undo it.
