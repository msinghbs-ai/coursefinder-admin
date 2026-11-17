# Pre-AI admission gate: proposal files (not applied)

Proposal files for [`../studysearch-pre-ai-admission-gate-design.md`](../studysearch-pre-ai-admission-gate-design.md). Nothing here is merged, deployed or switched on.

| File | Goes to (Pilot repo) | Notes |
|---|---|---|
| `pre-ai-admission-gate-shadow.patch` | applied at repo root with `git apply` | Applies cleanly on `main` `c4ffa31` and `aa34395`. On #1139 it conflicts on one import line only (keep both lines). Contains the four files below except the migration. |
| `admission-gate.ts` | `supabase/functions/coverage-sweep/admission-gate.ts` | New pure module, pre-ai-admission-v1. Passes `deno check`. |
| `admission-harness.mjs` | `scripts/admission-harness.mjs` | `node --experimental-strip-types scripts/admission-harness.mjs --self-test` passes 16/16. |
| `DRAFT_cf247_pre_ai_admission_shadow.sql` | `supabase/migrations/<number>_cf247_pre_ai_admission_shadow.sql` | Number at bundling time and rehearse rolled back first. Ships with the gate and every enforcement switch off. Parsed with libpg_query; not executed. |

## Queue hygiene (14 Nov 2026)

| File | Goes to (Pilot repo) | Notes |
|---|---|---|
| `QUEUE-HYGIENE-FINDINGS.md` | stays here | Read-only findings: `svc_scholarship_read_record` and the search lock, `pipeline.search_refresh_signals` (retire it), and the terminal `rejected_admission` state. §3.3 lists two lines the gate patch must change before any reason is enforced |
| `DRAFT_cf247_sch_queue_hygiene.sql` | `supabase/migrations/<number>_cf247_sch_queue_hygiene.sql` | Number it after #1143 is applied. Guarded on the live md5s and on #1143's result |
| `QUEUE-HYGIENE-REHEARSAL.sql`, `queue-hygiene-rehearsal-result.json` | stays here | Rolled back against live: PASS (txid 17273009, aborted) |

`index.ts` is delivered as a patch, not a full file, because the open #1139 changes the same file. A full-file copy would undo it.
