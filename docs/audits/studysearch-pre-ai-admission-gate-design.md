# Pre-AI admission and enrichment gate: design proposal (pre-ai-admission-v1)

**Date:** 14 November 2026 (AEDT) · **Status:** design direction approved (Decision 278, §9). Nothing is merged, deployed or switched on.
**Evidence:** [`studysearch-ingestion-validation-report.md`](studysearch-ingestion-validation-report.md) (findings R1–R9, §4).
**Builds on:** `SHARED-SOURCE-TO-PUBLISHED-ENRICHMENT-DESIGN.md` §11 (F2 slicer, F3 high-recall negative filter, F4 content cache, F5 split or park, F6 observability) and the Lean AI Input Phase 1/1b designs.
**Does not add:** an orchestration engine, a dashboard, a new job family, a new block format, a consumer API shape (G3), an AER v1 reader (Decision 276) or an automatic switch-on.

---

## 1. Purpose

One check sits between a stored evidence copy and a paid AI read. It answers one question: **should this read be sent?**

The answer is recorded every time, with reason codes and the tokens a rejection would save. A reason only stops reads after the Platform Admin switches it on, and only once the data shows it has never stopped a read whose answer was admitted.

## 2. Where it sits

```
stored copy (evidence bucket) ──► manifest check ──► Stage A: sanitise + section ──► Stage B: domain gates ──► decision
                                    (§3)              (lean-md-v1 → lean-blocks-v1     (page, AER, scholarship,     │
                                                        → lean-sections)                fees, cache)                │
                                                                                                                    ├─ admit  → the reader's request, unchanged
                                                                                                                    ├─ park   → reuse an earlier answer / split, with reason
                                                                                                                    └─ reject → Stage C: recorded, item settles 'rejected_admission'
                                                                                                                               (only when that reason is enforced)
every decision ──► pipeline.pre_ai_admission_decisions (beside ai_input_observations and ai_invocations)
```

It runs **inside the worker reads that already exist**: `scholarship_ai` first, then `enrich_ai` and `aer_v2_shadow`. There is no new job, and the gate never fetches anything.

## 3. Storage contract: `ArtifactManifest`

### 3.1 Departures from the brief

The brief asked for three files per URL (`raw.html`, `clean.md`, `meta.json`) and a crawl job state `READY_FOR_ENRICHMENT`. The platform already has a stronger form of the same contract, so the design keeps it rather than adding a parallel one:

| Brief | Platform today | Design |
|---|---|---|
| `raw.html` | Content-addressed `…/<sha256>.html.gz`, private, upsert | **Keep.** This is the source of truth (§11 F1: never overwritten). |
| `clean.md` | Derived locally on read by lean-md-v1. Not stored | **Optional sidecar**, versioned by converter, carrying `of_sha256` = the raw copy's hash. Stored only where the Phase 1 measurement shows re-conversion cost matters; never a second source of truth. |
| `meta.json` | `pipeline.evidence_artifacts` row | **Keep the row as the manifest.** A `meta.json` file would be a second copy that can drift from the row. |
| `READY_FOR_ENRICHMENT` | The queue functions only hand out items with a stored copy | **Replace it with a check:** the manifest must pass before the AI read (§3.3). There is no new job state. |
| HTTP 200 verification | Transport status only; the page's own status is usually not kept (R7) | **Add `page_status`** to the record. Until it is recorded on every path, an unknown status is a **warning**, not a rejection. |
| SHA-256 checksum | Already in the name and the row (0 disagreements, report §4.2) | **Keep, and re-verify on read** (the harness and the gate both recompute it). |

### 3.2 The contract

TypeScript, in `coverage-sweep/admission-gate.ts`:

```ts
export type ArtifactManifest = {
  evidence_id: string | null;           // pipeline.evidence_artifacts.id
  bucket: "evidence";
  storage_path: string;                 // …/<sha256>.<ext>.gz
  container: "gzip" | "none";           // how the object is stored
  content_mime: "text/html" | "text/markdown" | "text/plain" | "application/pdf" | "application/json";
  content_sha256: string;               // of the decompressed bytes; = evidence_artifacts.content_hash
  stored_bytes: number;                 // > 0
  content_bytes?: number | null;        // > 0 when opened
  source_url: string; final_url?: string | null;
  fetched_via?: "direct" | "firecrawl" | "upload" | null;
  http_status?: number | null;          // transport
  page_status?: number | null;          // the page's own status (2xx required when known)
  captured_at: string;
  sidecar?: { converter: string; storage_path: string; content_sha256: string; of_sha256: string } | null;
};
```

`checkManifest(m, computedSha)` returns `{ ok, problems, warnings }`:

- **Problems:** `missing_field`, `zero_bytes`, `hash_format`, `hash_mismatch`, `path_hash_disagrees`, `page_not_ok`, `content_mime_unknown`, `sidecar_of_other_copy`.
- **Warning:** `page_status_unknown`.

The worker has no npm dependencies today, so the contract is a dependency-free validator rather than Zod. Adding an npm package to the edge function adds supply-chain review for no gain here. If a Zod schema is wanted for the admin UI or the harness, it maps one to one: `z.object({ storage_path: z.string().regex(/[0-9a-f]{64}\.[a-z.]+$/), content_sha256: z.string().regex(/^[0-9a-f]{64}$/), stored_bytes: z.number().int().positive(), page_status: z.number().int().min(200).max(299).nullable(), … })`.

### 3.3 Rule

The AI read goes ahead only when the manifest has no problems. `manifest_invalid` and `page_not_ok` are reasons like any other: recorded in shadow, enforced only when switched on. The measured base rate is 0 (report §4.2), so these two can be switched on first.

## 4. The pipeline

### 4.1 Stage A: sanitise and section (deterministic, local, no new format)

1. **Convert:** `leanText` (lean-md-v1). It drops scripts, styles, `noscript`, `svg`, `template`, `nav`, `header`, `footer` and `aside`; keeps headings; emits each table row as `Header: cell | Header: cell`; and keeps every block's offset in the stored copy.
2. **Label:** `aerV3Blocks` (lean-blocks-v1). Page data lines come first, then `[B<n> @<offset>]` blocks. This is the one block contract shared with AER v2 and Lean AI.
3. **Segment by lane** with `selectSections` (lean-sections; v2 arrives with #1139). The lanes and their typed segments are:

   | Lane (typed segment) | lean-sections fields | Read whole? |
   |---|---|---|
   | `aer` (`aer_requirements`) | `entry_requirements` + `english` | — |
   | `tuition_fees` | `fees` | — |
   | `course_overview` | `description` | — |
   | `course_fields` | `duration`, `campus`, `delivery`, `intakes`, `international` | — |
   | `scholarship` | — | Yes: one award page is read whole, and its gate is page-level |

   **No selection means the page is read whole.** That is the lean-sections rule: high recall, and a missing selection is reported, never acted on.
4. **Leak check** on the exact text that would be sent. It counts residual markup tags, base64 runs of 240+ characters, `data:` URIs and JSON blobs. Any hit gives `prompt_leak`. The audit found none in the prompt builders, so this guards regressions, including future converters.
5. **Budget:** when the segment is longer than the read's own limit, the reason is `over_budget_split` and the decision is **park** (split or hold with a reason). The text is **never cut** (F5; the same pattern as AER v2 `page_too_long`).

### 4.2 Stage B: admission gates

All thresholds are settings (G2). The defaults are values the worker already uses.

| Reason code | Lane | Rule | Basis in the audit | Expected false-negative risk |
|---|---|---|---|---|
| `manifest_invalid`, `page_not_ok` | all | §3 contract | Base rate 0 (§4.2) | None |
| `soft_block` | all | `firecrawl.ts readOutcome` words (captcha, `cf-chl`, access denied …) and main text under 4,000 | Used today only in `fc_run` (R7) | Very low |
| `soft_not_found` | all | Title or h1 says "page not found" / 404, or a short page opening with it | Rendered error pages stored as read (R7) | Low; check on real pages |
| `thin_page` | all | Main text under `admission.min_main_chars` (300) | 623 calls on 346 near-empty copies, 0 admits (R1) | Very low (300 is the direct reader's own floor) |
| `prompt_leak` | all | §4.1 step 4 | None found | None (guard) |
| `over_budget_split` | all | §4.1 step 5 → **park** | Silent cuts (R4) | None: it holds rather than skips |
| `duplicate_input` | all | Same fingerprint (`sha256(gate, input_sha256, lane, prompt, model, schema)`) already answered → **park** to reuse the answer | US$2.27 of repeats in 14 days (R3) | None if the answer is reused, not dropped |
| `aer_no_signal` | aer | Preflight `no_signal` for **both** entry requirements and English on the selected text; the whole page is recorded beside it | §11 F3: high-recall negative filter only | **Must be measured.** The recall report puts the entry-requirements selector at 0.9375; stays shadow until `would_reject_but_admitted` = 0 |
| `scholarship_listing` | scholarship | `isListingPage` (15+ award links, or a plural title and 5+) → listing traversal, not a single-award read | 1,047 `listing` verdicts, US$1.59 (R2) | Low; measure |
| `scholarship_low_signal` | scholarship | Six deterministic signals (award word in title, award word in text, value, eligibility, how to apply, who may apply); score under `admission.scholarship_min_score` (2) | Requested in the brief. **The audit shows it separates poorly:** 96% of `not_scholarship` URLs carry award words, and a long course page scores 3 | **High.** Ships as a **measurement only**; the score is recorded with every decision so the threshold can be set from data |
| `fees_no_amount` | tuition_fees | `hasFeeAmount` | The fee reader's existing gate | Known (already live in `fee_ai`) |

**AER-specific requirements:**

- **Exact spans travel unchanged.** The gate passes forward the labelled lines it selected and their `block_ids`. Ordered proximity (`exact_block` / `lead_in_block` within `reading.aer_v3_lead_in_max_blocks`) and the offset back into the stored copy are kept.
- **Scope.** The gate never applies to AER v1 readers (frozen, Decision 276). It applies to the AER v2 shadow and the enrichment entry read only.

### 4.3 Stage C: audit and dead-letter routing

Every decision becomes one row in `pipeline.pre_ai_admission_decisions`. A row holds:

- lane, item and evidence;
- `decision` (what happened), `would` (with every reason enforced) and `shadow`;
- `reason_codes` and their detail;
- `sent_chars`, `tokens_saved_estimate` (characters ÷ 4: an estimate; real tokens are in `ai_invocations`);
- `input_sha256`, `fingerprint`, and the signals (main text, preflight, scholarship score, leak counts).

When a reason is enforced:

- **reject** → the item records the error `rejected_admission: <codes>` and spends nothing. In the scholarship lane this goes through `svc_scholarship_ai_record`. A small SQL follow-up (not in the draft) gives it a terminal `rejected_admission` state, so the queue does not retry it.
- **park** → the item is re-queued with its reason (`duplicate_input` reuses the earlier answer; `over_budget_split` waits for the split reader).

**Report:** `security.pre_ai_admission_report_v1(hours)` gives, per lane and reason:

- how many reads it would have stopped, and the tokens saved;
- **`would_reject_but_admitted`**: reads it would have stopped whose answer was admitted anyway. This is the false-negative count, and it must be 0 before that reason's `admission.enforce.<reason>` is proposed;
- `would_reject_but_spent_usd`: what those reads actually cost.

## 5. Settings and database objects (draft migration)

The draft is `DRAFT_cf247_pre_ai_admission_shadow.sql` in [`proposal-pre-ai-admission/`](proposal-pre-ai-admission/) (not numbered, not applied; it goes to `supabase/migrations/` once numbered). It adds:

- **Table** `pipeline.pre_ai_admission_decisions`, with a table comment, indexes and RLS on.
- **Insert function** `public.svc_pre_ai_admission_record_v1(p_rows jsonb)`: service role only; skips rows that do not fit, never raises; removes expired rows in bounded batches.
- **Report function** `security.pre_ai_admission_report_v1(p_hours)`: read-only.
- **Settings** (all `pipeline` toolset, each with a label, range, unit and `used_by`):

  | Setting | Value at ship | Meaning |
  |---|---|---|
  | `admission.gate_on` | 0 | Off |
  | `admission.min_main_chars` | 300 | Thin-page floor |
  | `admission.scholarship_min_score` | 2 | Scholarship score floor |
  | `admission.retention_days` | 30 | History kept |
  | `admission.purge_batch` | 2,000 | Rows removed per insert |
  | `admission.enforce.<reason>` × 12 | 0 | One switch per reason, all off |

- **Post-checks** fail the migration unless the gate and all 12 switches ship off.
- **Housekeeping and governance:** `-- Replaces: nothing`, `-- Retires: nothing`; no job (G1); no consumer API object (G3); nothing dropped.
- **Syntax:** parsed with libpg_query (`pglast`). It has not been executed against any database; it must get the rolled-back production-parity rehearsal before apply.

## 6. Verification harness

`scripts/admission-harness.mjs` runs on Node 22 with `--experimental-strip-types`. It imports the worker's own modules, so it reports exactly what the worker would decide. It is read-only.

| Mode | What it does |
|---|---|
| `--self-test` | 16 fixed checks: admit cases for AER, scholarship and fees; one per reason; enforcement is explicit per reason; a duplicate parks; over budget parks without cutting; AER segments keep `[B#]` labels. **16/16 pass** against `main` + the proposal. |
| `--manifest sample.json --dir ./objects` | Copies already downloaded |
| `--manifest sample.json --supabase` | Downloads each object with `SUPABASE_URL` + `SUPABASE_SERVICE_ROLE_KEY` (GET only) |

`sample.json` is query H1 in `sql/admission-integrity-checks.sql`. The run gunzips each object, recomputes SHA-256, checks the manifest, runs Stages A and B and prints a tally by reason. **Exit 1 means a storage-contract failure** (missing object, zero bytes, hash mismatch). Gate rejections are measurements and never fail the run.

**What has been verified:**

- Self-test: 16/16.
- Manifest mode on synthetic objects: it caught a hash mismatch, a path/hash disagreement and a missing object, and exited 1.
- Six real stored pages from the repo fixtures (`tests/fixtures/entry-matrix`, `course-entry`): all six admitted for AER (no false negative). Five were judged low-signal for scholarship and the long course page scored 3 (it would admit), which is the evidence for ships-as-measurement-only in §4.2.
- **Not run yet:** `--supabase` against live objects. It needs the service key on a machine with storage access; this session's shell cannot reach Supabase Storage.

## 7. Proposed implementation diff

The diff is `pre-ai-admission-gate-shadow.patch` (copy in [`proposal-pre-ai-admission/`](proposal-pre-ai-admission/)), against Pilot `main` `c4ffa31`. It applies cleanly there and on the current `main` `aa34395`. On #1139's head it conflicts on one import line only (`lean-sections.ts` import): keep both lines.

| File | Change |
|---|---|
| `supabase/functions/coverage-sweep/admission-gate.ts` | New pure module (§3, §4) |
| `supabase/functions/coverage-sweep/index.ts` (+20/−4) | `scholarship_ai` only. Gate behind `admission.gate_on` (default off): judge each read, enforce only switched-on reasons, record decisions at the end of the call, never fail the call. Also keeps the cost of a paid answer whose record failed (`errorCost(e) \|\| spent`, R5) |
| `tests/uat/cf-247-s173-reader-answer-limits-contract.spec.mjs` | Its exact-text assertion follows the R5 fix. The guard is unchanged |
| `scripts/admission-harness.mjs` | The harness (§6) |

**Checks run on the patch:**

- **`deno check`:** `admission-gate.ts` is clean. `index.ts` has the **same 24 pre-existing type errors** as `main` and none new.
- **Scholarship-related contract specs** (37 files, 307 tests) compared with `main`: the only new failure was the s173 assertion, which is fixed in the patch, and s173 then passes 6/6.
- **Not yet run:** the full suite through the PR CI.

**Still needed before a PR** (G4 and housekeeping): a contract spec with `// Guards: <decision>` for the gate, the test register regenerated, a worker version number allocated after #1139/#1128, the draft migration numbered and rehearsed rolled back, and `docs/platform/AI-CALL-PATHS` updated.

## 8. Rollout (each step a separate approval)

1. **Shadow on the scholarship lane:** apply the migration, deploy the worker, set `admission.gate_on` = 1. No read changes.
2. **Measure for 7 days:** `security.pre_ai_admission_report_v1(168)`. Expected first candidates for enforcement: `manifest_invalid`, `page_not_ok`, `thin_page`, `soft_block`, `duplicate_input` (park), `scholarship_listing`. Each needs `would_reject_but_admitted` = 0.
3. **Enforce one reason at a time,** through a migration that names the approval and the measured window.
4. **Extend shadow to `enrich_ai` and `aer_v2_shadow`** after the Lean AI Phase 1 observations exist (report R9). There the gate's `over_budget_split` replaces the silent 24,000 cut only together with the split reader (Phase 1b-3/1b-4, separate approvals).
5. **`aer_no_signal` and `scholarship_low_signal` stay measurement-only** until labelled false-negative sets show they are safe.

## 9. Decisions (Platform Admin, 14 November 2026, 16:10 AEDT; recorded as Decision 278 in the Design Reference)

| # | Decision | Answer |
|---|---|---|
| D1 | Storage contract | **Keep the record as the manifest.** The raw copy stays the only stored artifact (sidecar optional); no three files per URL and no `READY_FOR_ENRICHMENT` state |
| D2 | Scholarship keyword score | **Measure only.** Recorded with every decision, never used to stop a read |
| D3 | Next step | **Bundle after #1139:** one Pilot PR with the patch, numbered migration, contract spec, test register, worker version and rolled-back rehearsal |
| D4 | Fold the R5 cost fix into the same release | Included in the D3 bundle (it is already in the patch) |
