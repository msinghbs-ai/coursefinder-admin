# Cloudflare Worker Boost and production launch rehearsal

**Requested by:** the Platform Admin, Mon 16 Nov 2026 20:31 AEDT ("Cloudflare Worker Compute-to-Storage Boost Program" and "Production Launch & Migration Consolidation Plan").
**Built by:** Claude, 16 Nov 2026 20:31–21:10 AEDT. **Change control:** CF-247. **Register:** `docs/integrations/CONSUMER-REQUESTS.csv` (REQ-52 study load, REQ-57 / D-3 accreditations).
**State:** built and tested locally. Nothing is deployed, applied or switched on. The Worker is not on Cloudflare. The staging SQL has not been applied to `fxcwkweaxjtknorudmwp`. No job, setting or route changed.
**Live reads:** read only, `fxcwkweaxjtknorudmwp`, 16 Nov 2026 20:35–20:50 AEDT. Every query ran with `set transaction read only` and a 20 s limit.

## 1. Summary

The Boost program moves AI reading of four bottleneck fields off the Supabase edge function's daily caps. A free-tier Cloudflare Worker does the reading.
1. A read-only exporter builds batches of stored pages. It reuses the live worker's own page converter and section selector.
2. The Worker reads each batch through a free-tier failover chain.
3. Every answer must pass deterministic checks before it is written back to Storage. Its quotes must appear on the page, and its values must be allowed.
4. The results then load into a staging table in one transaction.
5. A promotion function, run in the 01:00–05:00 AEDT quiet window, decides what (if anything) is admitted.

As built, **nothing is admitted from a model that has not passed qualification for its lane.** The qualification list is empty, so every verified answer stays as a shadow reading until you qualify a model (section 3).

## 2. Decisions taken (the plan's A/B rules)

| Step | Rule | Path taken | Why (as read) |
|---|---|---|---|
| 0 | Residue | **A, clean** | Admin and Pilot clean. The S2 - SS Build schedule is untouched: PR 1 cutover 22:30, PR 3 from 23:15, PRs A/B/E and PR 2 on Tuesday, PRs C/D on Wednesday. |
| 1 | Queue source | **B, fixture** | `pipeline.field_execution_registry` is not live (S2 - SS Build PR 3 creates it from 23:15). The exporter switches to path A by itself once the registry declares a lane. |
| 2 | Worker scaffold | **B, standalone** | The admin repository's `wrangler.jsonc` serves the admin site's static assets. No Worker scaffold exists, so the Worker is standalone in `workers/cf-boost-extractor/`. |
| 3 | Ingress | **B, staging table** | There is no Layer 4 intake function that takes rows from an outside reader. The only match, `security.layer4_intervention_raise_v1`, raises interventions. So the change adds `pipeline.boost_inbound_staging` plus a promotion function. |

## 3. How the request was reconciled with standing rules

The request asked for a failover chain across four providers. Two standing rules apply to that:
- **lesson 8** (`layer4-clearance-and-model-benchmark-2026-11-16.md` §5): individually pinned models, no fallback across models;
- **the 16:52 decision** (§6 there): the 2,090 held AER items are re-read only after a model passes the gate.

Both are kept as follows:

| Rule | How it is kept |
|---|---|
| Each result is bound to one model | The chain changes model only between whole attempts. The row names the one provider and model that answered, plus every earlier attempt and why it moved on. OpenRouter calls set `allow_fallbacks: false` and `require_parameters: true`, and an answer from any model other than the pinned one is refused. |
| A passing benchmark switches nothing on | `pipeline.boost_model_qualifications` starts **empty**, and only you add a (lane, provider, model) row, with a reason. Until then every verified row is a `shadow` reading. |
| AER v1 is frozen; AER v2 admits only through its own rule | Lane `aer_entry` is **never promotable** by Boost. Results sit beside the held Layer 4 item as a shadow reading, for comparison with benchmark round 3 (Tue 17 Nov 07:30). |
| Study load only from stated words (REQ-52) | A study-load quote must contain "full-time" or "part-time" for the value it claims. Delivery mode is never used. |
| Accreditations against official lists (D-3) | A qualified Boost reading is only `proposed`. PR C's official-list match decides. |
| No `updated_at` noise (v2 sync deltas) | `catalogue.courses` has no `updated_at` trigger, and the promotion never sets it. A course is written only where `study_load` is null. Rehearsal: 1 written, 0 `updated_at` touched. |
| Manual locks win | A course with a manual lock on any study-load column is `refused`, with the reason stated. Silently keeping the old value would misreport the course as admitted. |
| Consumer API frozen (G3) | Nothing the website or Zoho v2 reads is touched. `study_load` is a v3 column, and v3 is open to additions until go-live (Decision 277). |

## 4. Lanes in scope

| Lane | Live (20:40 AEDT) | Promotion when qualified |
|---|---|---|
| `study_load` (REQ-52 stage 2) | 35,700 active courses without a study load. 2,671 have a stated full-time or part-time quote, which PR B's stage 1 covers deterministically. | `admitted` where the course has none |
| `provider_accreditations` (D-3) | 0 rows | `proposed` (PR C's official lists decide) |
| `aer_entry` | Pending Layer 4: `course_entry_first_read` 2,578, `entry_matrix_first_run` 77, `entry_matrix_change` 6. The plan's 2,090 is an earlier count of the AER-held subset. | never (shadow only) |
| `course_description`, `course_fees` (overflow) | Both queues empty at 08:15 AEDT (no waiting description items; fee reader 6,317 done, 6 failed) | `proposed` (each lane's own rule decides) |

Not exported: `campuses.is_primary`, `empty_reason_code`, `grade_scale_conversions` and `destination.*`. These are deterministic, and S2 - SS Build owns them.

## 5. What was built

| Path | What it is |
|---|---|
| `scripts/boost-export-queue.sql` | Read-only blocks:<br>• `header`: live CHECK values, field dictionary rows, whether the registry exists;<br>• `fixture`: 75 rows, 50 frozen AER cases (set 5) + 15 study load + 10 accreditations;<br>• `registry`: path A, per lane. |
| `scripts/boost-export-queue.ts` | Runs the SQL through `psql` in read-only transactions, then fetches each stored page (bucket `evidence`; Firecrawl markdown when kept).<br>• Imports the page converter, `[B#]` blocks and section selector (`lean-sections-v3`, the #1179 long-page rule) **from a Pilot checkout**, so nothing is copied and a batch matches the live worker.<br>• Writes `staging-boost/outbound/*.ndjson`; `--upload` sends the batch to the `staging-boost` bucket.<br>• Refuses coursefinder-demo and any project other than production. |
| `workers/cf-boost-extractor/` | The Worker: `src/router.ts` (failover chain), `src/verify.ts` (shape, allowed values, `quote_on_page`, quote states the value), `src/lanes.ts`, `src/index.ts`, plus `prompts/` (study load and accreditation prompts, versioned and sha-256 checked), `wrangler.toml` and tests. |
| `sql/boost-ingestion/001_boost_inbound_staging.sql` | DRAFT migration:<br>• staging table;<br>• qualification table, empty;<br>• three G2 settings (window 01–05 Melbourne, 1,000 rows per run);<br>• component register rows. |
| `sql/boost-ingestion/002_boost_promote.sql` | DRAFT `security.boost_promote_v1(batch, dry, now)`: one transaction, quiet window, advisory lock, the decision table in section 3. |
| `sql/boost-ingestion/003_load_results.sql` | Loads one result file into staging in one transaction (`psql … < result.ndjson`). Idempotent. |
| `sql/boost-ingestion/004_rehearsal.sql` | Promotion rehearsal on synthetic rows. Rolls back. Test database only. |
| `sql/boost-ingestion/local-stub.sql` | Minimal stand-in schema for a local rehearsal. Never run on a Supabase project. |
| `scripts/test-boost-e2e.sh` | The 4-point harness (section 7). |

**Chain:**
1. Google AI Studio `gemini-2.5-flash`, then `gemini-2.5-flash-lite`;
2. Groq `llama-3.3-70b-versatile`;
3. Mistral `mistral-small-latest`;
4. OpenRouter `mistralai/mistral-small-3.2-24b-instruct`, then `xiaomi/mimo-v2-flash`.

When a provider returns 429, it is cooled for its `Retry-After` and the chain moves on. A 5xx, a time-out, an empty answer or an answer that isn't JSON also moves on.

**Free-tier fit:**
- **CPU:** the exporter does the page work. The Worker only builds requests and compares flat strings: 12 items took 1.71 ms of CPU (limit 10 ms).
- **Subrequests:** 50 per call. One storage read, one write and up to 6 steps per item gives 12 items per call (`BOOST_ITEMS_PER_RUN`). `POST /run` returns `next_offset` for the next call.

**This repository is public.** Keys are wrangler secrets only, and `staging-boost/` (page text and results) is git-ignored. When Boost becomes a production component, its code moves to Pilot under the release contract (the two-repository rule). It is placed here now because the request said so.

## 6. Production launch rehearsal (migration consolidation)

- **Live has 2,043 migrations** (`20260810200601` to `20261116150000`, all with statements). **Pilot holds 696 files**, from `20261010006400`. A replay from the repository cannot rebuild production. Point 4 exports the **live record** in pages of 50 (read-only, 20 s each) and replays it in order on an empty test project.
- Expect the first failures where production relies on platform features a new project lacks: extensions (`pg_cron`, `pg_net`, vault), Supabase roles, storage buckets, and the one RPC known to exist only live. `CONTINUE_ON_ERROR=1` lists every failure for the gap register instead of stopping at the first.
- After a clean replay the harness runs the G3 check (75 functions, 48 relations, no drift) and the Pilot local suite.

## 7. Test harness (`scripts/test-boost-e2e.sh`) and results

| Point | Checks | Result (16 Nov 2026, this session) |
|---|---|---|
| 1 | Worker CPU under 10 ms a call; 429 failover; OpenRouter binding | **Pass**:<br>• Google 429, then its second model skipped while cooling, then Groq answers and the row names Groq;<br>• 12 items in 1.71 ms. |
| 2 | 100% of ungrounded quotes blocked before ingress | **Pass**:<br>• 50 of 50 blocked;<br>• delivery-mode quotes, wrong fee amounts and unnamed bodies refused;<br>• values outside the live CHECK lists refused. |
| 3 | 1,000 rows in one transaction under 5 s; no `updated_at` moved; promotion rehearsal | **Pass on a local Postgres 16 stand-in**:<br>• 1,000 rows in 0.10 s, re-run loads 0, `updated_at` unchanged;<br>• rehearsal: 1 admitted, 2 shadow, 2 refused, window refusal enforced.<br>Must be re-run on the parallel Supabase test project. |
| 4 | Replay of every live migration; G3; Pilot suite | **Not run.** Needs the parallel test project and a read-only production role. |

Also run once, offline, before commit:
- exporter, with a fake `psql` and a local Storage stand-in → Worker on that batch → verified rows via Groq after a Google 429;
- `tsc --noEmit` clean;
- `wrangler deploy --dry-run` bundles.

The fixture query ran read-only on live: 75 rows (50 AER, 15 study load, 10 accreditations). 8 AER cases have no stored page and are skipped with that reason.

## 8. Setup checklist for the Platform Admin (5 steps)

1. **Parallel test project.** Create a new Supabase project (not coursefinder-demo). Note its database URL as `TEST_DB_URL`. Create a read-only role on production for the migration export, as `PROD_RO_URL`.
2. **Storage.** On production, create a **private** bucket `staging-boost` (folders `outbound/` and `inbound/`). Nothing else is needed; the Worker uses the service role for Storage only.
3. **Provider keys.** Get keys for Google AI Studio, Groq, Mistral (La Plateforme) and OpenRouter. Free tiers may use prompts to improve their models; the pages are public, but check each provider's terms before production use. Then in `workers/cf-boost-extractor/`, run `npx wrangler secret put` for:
   - `BOOST_TOKEN` (a new random value);
   - `SUPABASE_SERVICE_ROLE_KEY`;
   - `GOOGLE_AI_STUDIO_KEY`, `GROQ_API_KEY`, `MISTRAL_API_KEY`, `OPENROUTER_API_KEY`.
4. **Run the harness on the test project.** Run `TEST_DB_URL=… scripts/test-boost-e2e.sh 3`, then `TEST_DB_URL=… PROD_RO_URL=… CONTINUE_ON_ERROR=1 scripts/test-boost-e2e.sh 4`. Send me the failures file (`staging-boost/harness/point4-failures.txt`) for the gap register.
5. **First live batch, shadow only.**
   - `npx wrangler deploy`.
   - Export and upload the fixture: `BOOST_DB_URL=… SUPABASE_URL=… SUPABASE_SERVICE_ROLE_KEY=… node --experimental-strip-types scripts/boost-export-queue.ts --upload`.
   - Call `POST /run` with `{"batch_path": "outbound/<file>", "offset": 0}` and header `x-boost-token`, repeating with `next_offset`.
   - The staging SQL reaches production only as a Pilot migration after its rolled-back dry run. Until then results stay in Storage.
   - Qualifying a (lane, provider, model) for admission is a separate decision you take.

## 9. Risks and open decisions

| Item | Effect | Proposed handling |
|---|---|---|
| Unqualified models on the chain | Groq Llama 3.3 70B, Mistral `mistral-small-latest` (La Plateforme) and Gemini 2.5 Flash-Lite have no benchmark here. Gemini 2.5 Flash scored 27.5% on AER set 5. | Shadow until each passes its lane's gate. Study load and accreditations need small gold sets (about 30 person-decided cases each). |
| Study load stage 2 overlaps PR B | PR B plans stage 2 through the existing `enrich_ai` reader | One owner per lane: S2 - SS Build decides whether Boost is that lane's stage 2 when it declares the lane in the registry |
| Provider terms on free tiers | Prompts may be used for training; rate limits change without notice | Check terms before production; paid tiers keep the same code |
| Path A columns of the registry | PR 3 defines them tonight; the exporter reads them generically (`lane`, `lane_key` or `field`) | Re-check after PR 3; a mismatch fails loudly ("lane not declared") |
| Migration replay gaps | Extensions, roles, buckets and live-only objects | Point 4 lists them; each becomes a gap-register item, not a silent workaround |

## 10. Not changed

- **Production:** no write. The only exceptions are reads (`set transaction read only`, 20 s).
- **Settings, jobs and dispatchers:** no setting, job, route, prompt or switch changed. The PR 1 cutover (tonight 22:30) and PR 2 (Tue 22:30) are untouched.
- **Consumer API:** no consumer API object touched (G3).
- **AER:** v1 frozen. Benchmark round 3 is unchanged.
