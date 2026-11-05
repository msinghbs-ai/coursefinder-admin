# PR #877 Provider descriptions: independent pre-release validation

Validator: agent E. Decision 19:14 §8 (Platform Admin, 5 Nov 2026).

- **Branch:** `codex/provider-description-autonomy`, head `33a7cce3`, base `cf77ef78` (v2.15.485). Migration `20261106200000_cf247_provider_description_autonomy.sql` (1,003 lines). Inspected read-only; the branch was not modified.
- **Production:** `fxcwkweaxjtknorudmwp`, light reads only (20:58–21:02 AEDT).
- **Fixture not run.** The PR's fixture needs a Docker daemon (`pdesc-autonomy-pg`), which this workspace does not have. Its CI job `provider-description` passed on `33a7cce3`. I re-tested the claim policy functions in my own database `e_pr877_claim` (since dropped).

**Verdict: not ready (small rework).** Most checks pass: md5s live, course descriptions untouched, rank 3 refused on every path, no auto-approval, reservation before every paid AI call, five-provider scope unchanged, and nothing switches itself on. Two findings need a fix before release:

1. Two of the new validation rules hold legitimate supported claims by keyword or by number formatting. That is against the Platform Admin's 20:03 §2 instruction ("Do not reject legitimate supported claims solely by keyword").
2. The forward-recovery and deploy text claims an old worker cannot make a paid call against the new database. It can.

A third item needs a Controller decision: a new direct writer of the website feed table.

## (a) The six replaced-function md5s are still live

Read 5 Nov 2026 20:58 AEDT.

| Function | Before-guard | Live | Result |
|---|---|---|---|
| `security.provider_description_validate_v1(uuid,text,timestamptz,jsonb)` | `528d5a3d2e3780fcb58e2c19db31c199` | `528d5a3d2e3780fcb58e2c19db31c199` | match |
| `security.provider_description_enqueue_v1()` | `97e6b926a545c4032159f9dbf52e3cf3` | `97e6b926a545c4032159f9dbf52e3cf3` | match |
| `public.svc_provider_description_next(integer)` | `5342ae3f9279f6c2ec0849ec4fe0fffd` | `5342ae3f9279f6c2ec0849ec4fe0fffd` | match |
| `public.svc_provider_description_record(jsonb)` | `d5aec36ddd55c4a0bdc823fb8a02fec0` | `d5aec36ddd55c4a0bdc823fb8a02fec0` | match |
| `security.provider_description_fire_v1()` | `8f5918c9c26445d9347988d850aba6f5` | `8f5918c9c26445d9347988d850aba6f5` | match |
| `security.layer4_provider_description_apply_impl(uuid,uuid,jsonb,text)` | `875b25c4f35568cb9ac6379812546d42` | `875b25c4f35568cb9ac6379812546d42` | match |

- **Guard design.** The migration refuses unless each function is at its before-md5 or its after-md5. After the bodies it requires the after-md5 (refusing a partial apply).
- **Search path caveat.** The after-md5s were computed on isolated PostgreSQL 17.6 with the default local `search_path`. These functions take only built-in argument types, so production's `"\$user", public, extensions` path should not change their `pg_get_functiondef` text. If the after-check refuses in production, the path is the first thing to check.
- **Version.** `20261106200000` sorts after the latest applied `20261105090000` and collides with nothing. The old `20261105010000` collision was fixed by renumbering.

## (b) Course descriptions are unchanged

- **`security.course_description_check_v1(uuid,jsonb)`.** Live `ff3d6dd7b0f88c85b1fdff6c8a8cd86b`. The migration names it once, in a comment only. It does not create, replace or edit it.
- **`pdesc.claim_words`.** The migration does not update it; the live list is unchanged (26 words). Provider descriptions get a separate new list, `pdesc.evidence_claim_words`, read only by `provider_description_validate_v1`.
- **Worker.** `supabase/functions/coverage-sweep/description.ts` gains new exports and one comment line, and no line is removed. `descriptionSentences` and `descriptionPageText`, which `course-text.ts` imports, are unchanged, so the course-text path is unchanged.

## (c) Claim policy: does it hold only unsupported claims?

I created `security.pdesc_has_term_v1` (live definition from `20261102090000`) and the new `security.pdesc_claim_check_v1` in a scratch database, then tried 15 sentence and quote pairs.

**The evidence check itself (campus, scholarship, guarantee) is sound.** It passes:

- supported plurals and tenses (campuses/campus, guaranteed/guarantees);
- on-campus;
- "not only … campus" and "not just … campus";
- negated sentences with negated quotes.

It correctly holds a sentence with no supporting quote, and a sentence the quote contradicts ("does not guarantee entry").

**Two edge cases in it:**

- **False hold:** "Support is available no matter which campus you attend" makes a positive sentence about every campus `claim_negated_in_source`, because "no" is within two words of "campus".
- **Missed negation:** "None of our campuses are in Sydney" does not hold "The university has a campus in Sydney". The negation list has no `none` or `neither`. The general support check (`pdesc_support_v1`) and the human Layer 4 review remain behind it.

**The other new rules in `provider_description_validate_v1` hold legitimate supported claims:**

| Rule (new) | Sentence | Its own official quote | Result |
|---|---|---|---|
| `unsupported_numeric_claim` | "The university has more than 80,000 students." | "Over 80 000 students study with us." | held |
| `unsupported_numeric_claim` | "The university has 4 campuses." | "The university has four campuses." | held |
| `historic_claim_context` | "The university offers more than 300 courses." | "In 1958 it became a university; today it offers more than 300 courses." | held |
| `historic_claim_context` | "It is a public research university." | "Formed when two colleges merged, it is a public research university." | held |
| `historic_claim_context` (true positive) | "The university operates a campus in Gippsland." | "…formerly operated a campus in Gippsland, which closed in 2018." | held (correct) |

- `historic_claim_context` is a pure keyword trigger: a quote containing became, merged, renamed, closed, former or similar, with a present-tense sentence. That is the "reject legitimate supported claims solely by keyword" that decision 20:03 §2 rules out.
- `unsupported_numeric_claim` compares digit strings exactly (`80,000` is not `80 000`, and `4` is not `four`).
- Both are holds, never publications, so they fail safe. But a held read never reaches Layer 4, so legitimate descriptions are lost from the pilot's five providers.

**Required:**

1. Make `historic_claim_context` evidence-aware: hold only when the sentence's own claim is the one the quote places in the past.
2. Normalise number formats (thousands separators, spaces, number words up to ten) before comparing.
3. Optionally, add `none` and `neither` to the negation list, and treat "no matter" as not a negation.
4. Add these cases to `tests/fixtures/provider-description-autonomy/claim-policy.mjs`.

## (d) Rank changes

- **The only approval route to the change** (live callers read at 20:58): `security.layer4_review_decide_impl(uuid,text,text,jsonb)` is the only function that calls `security.layer4_provider_description_apply_impl`. It passes `v_actor := auth.uid()`.
  - Today `layer4_review_decide_impl` admits rank 3 and above, and has no provider-description rank of its own. A Curator could therefore approve through `public.layer4_review_decide` directly.
  - The new `apply_impl` refuses unless `p_actor` holds an active role of rank 4 or above. That closes the route on every path that reaches it.
- **Inbox.** Live `public.admin_layer4_inbox('decide')` refuses below `coalesce(choice.rank, 4)`. The provider-description choices (`approve`, `reject`; live `layer4_inbox_kinds_v1()`) name no rank, so 4 applies. The rank check runs before any kind's branch, hook or not.
- **Batch.** Live `security.layer4_batch_decide_v1_impl` returns `one_at_a_time` for `provider_description` at any rank, deciding nothing.
- **Other Layer 4 kinds are unchanged.** The migration does not create or replace `layer4_review_decide_impl`, `layer4_review_decide`, `admin_layer4_inbox` or the batch function. The PR's `run.sh` hashes them, and the other kinds' apply functions, before the migration.
- **Inbox md5 in the fixture against live.** The fixture loads `tests/fixtures/p1-provider-descriptions/live-before/public.admin_layer4_inbox.sql` (md5 `764db4e6…`, 167 lines, a 2 Nov definition). Live is `1895ed9870fdbcb332639befffd5a6ec` (260 lines). The PR's `navigation-contract.json` holds the live text, and its md5 checks out as `1895ed98…`. I diffed the two `decide` branches:
  - **The same in both:** the rank lines (`if v_rank < 3` for access, `if v_rank < coalesce((v_c->>'rank')::int, 4)` for a choice).
  - **Live only:** the hook dispatch, the duplicate-decision guard, the explicit `provider_description` branch (approve or reject through `layer4_review_decide`), course_link refuse, course_page_needed and held_scholarship duplicate, and the still-waiting group closing.
  - **Impact:** the difference does not hide a rank difference. It does mean the fixture's approve path is not the live path: live sends `layer4_review_decide(ref, approve|reject, reason, null)`. The rank result is the same either way, because `apply_impl` enforces rank 4 itself.
  - **Recommended:** load the live inbox definition (`navigation-contract.json` `items_definition`) in the fixture.

## (e) No auto-approval; spend limits; scope

- **No auto-approval.** A read only ever reaches `proposed` (a pending Layer 4 item) or `held`. Admission happens only in `apply_impl` after a rank-4 human decision. Batch is refused.
  - The two new `pipeline.ops_remedy_knowledge` rows are knowledge records for retry and learning: `provider_description:official_about` (authority `auto`: proposal yield) and `…:human_admission` (`layer4_human`).
  - They carry no `remedy_code`, so no remedy can be executed from them. Live readers of that table are the `ops_learning_*` functions only.
- **Reservation before every paid AI call.** In `coverage-sweep` `index.ts`, every OpenRouter chat call follows, in order:
  1. the source-identity proof;
  2. a pricing quote from the public models list, a free GET;
  3. `svc_provider_description_reserve_v1`;
  4. `reservation?.ok !== true`, which holds the item with no AI call.

  The reservation function (service role only) runs under an advisory lock. Under the existing per-lane checks (`pdesc.enabled`, `ai_use_allowed_v1('provider_description')`), it refuses on:
  - the lifetime ceiling `pdesc.ai_usd_max` = 1: spent plus all open reservations plus this quote;
  - the daily guard `openrouter.guard_provider_description`;
  - unchanged rejected evidence;
  - a learning no-retry;
  - an identity change since lease;
  - an existing uncertain reservation.

  Unknown costs keep their reservation. The request carries `max_price`. Firecrawl reads stay under the existing `pdesc.firecrawl_reads_max` (20).
- **Five-provider scope unchanged.** The migration does not touch:
  - `pdesc.provider_keys` (live: 5 CRICOS keys `00102e`, `00025b`, `00008c`, `00300k`, `00004g`);
  - `pdesc.countries` (`["AU"]`);
  - `pdesc.provider_types` (`["university"]`);
  - `security.provider_description_scope_v1`.

  Every new path (cohort selection, lease, record, publication check, apply) checks `provider_description_scope_v1`. The cohort selector can only narrow it.

## (f) coverage-sweep against the live deployed version (v2.15.481)

- **Deployed equals main.** Deployed `coverage-sweep` is version 238, updated 5 Nov 2026 13:43 AEDT (02:43 UTC). That is the `deploy-on-merge` run for `a2317a26` (v2.15.481) at 02:42 UTC. No later main commit touches `supabase/functions/coverage-sweep/`, and the daily edge drift check passed at 00:54 UTC. So `cf77ef78`'s folder is the deployed folder, and the branch diff against `cf77ef78` is the diff against production.
- **`index.ts`** (44 lines). Every changed hunk is inside the `provider_description` mode:
  - import list;
  - cohort lease;
  - pricing lookup;
  - final-URL capture in the Firecrawl reader;
  - host and final-URL checks;
  - identity proof;
  - reservation;
  - `max_price`;
  - claim check;
  - `providerDescriptionSentences`.

  The Firecrawl final-URL change is in the provider-description `readPage` helper.
- **Unchanged:** the course-text, fees, entry, intake, scholarship and logo paths. Their imports (`course-text.ts`, `catalogue.ts`, `logo.ts`) are identical, and their files are not in the diff.
- **`description.ts`.** New exports only, plus one comment line inside `descriptionSentences`.

## (g) Deploy order and forward recovery

The documented order is sound:

1. Pause `provider-description-read` (live: active, at :06, :16, :26 and :56).
2. Apply the migration.
3. Deploy `coverage-sweep`.
4. Deploy the UI.
5. Resume.
6. Verify ranks.
7. Only then add Run Now.

`deploy-on-merge` applies migrations and then edge functions automatically on merge, so step 1 must be done **before merging**.

**Worker before migration** (the new worker on the old database):

- The new worker requires `w.verbatim_span_max_chars` from `svc_provider_description_next`. The old function does not return it, so each item is held `invalid_verbatim_limit` **before any AI call**. The reserve RPC also does not exist yet.
- So there is no spend. But each read leased in that window ends `held`, and needs a recovery or re-queue after the migration.
- Pausing the job (step 1) avoids this.

**Migration before worker, or a worker rollback** (the old worker on the new database): **the doc is wrong here.** Its forward recovery says "The new database functions fail closed for an old worker: no reservation means no paid call." That is not true.

- The new `svc_provider_description_next` still leases items whenever spend is below the ceiling.
- The old worker never calls the reservation function. It makes the OpenRouter call directly.
- Only afterwards does the new `svc_provider_description_record` hold the result (`source_identity_proof_missing`).
- So the call is paid, bounded by the lifetime $1 ceiling and the daily guard, and wasted.

**Required:**

- Correct the doc. To roll the worker back: pause the job, or set `pdesc.enabled` to 0, first.
- Optionally, make `svc_provider_description_next` return items only when the caller declares the reservation-capable worker version, so an old worker is refused before a paid call.

**Database fault.** The plan (a forward migration guarded on the after-md5s; drop nothing) is sound.

## (h) Nothing switches on by itself

- **The migration does not change:**
  - `run_now.jobs` (live `["intake-dates-apply"]`);
  - any `cron.job`;
  - `pdesc.enabled`, `pdesc.acquire_direct` or `pdesc.acquire_firecrawl`;
  - the scope or spend settings.

  It inserts only new settings (`pdesc.ui_preview_minutes`, `pdesc.verbatim_span_max_chars`, `pdesc.reason_min_chars`, `pdesc.evidence_claim_words`) with `on conflict do nothing`.
- **Run & Validate.** It parks as `job_not_allowlisted` until the Platform Admin adds the job to `run_now.jobs`.
- **Context, not a defect.** `provider-description-read` is already active in production, with `pdesc.enabled`, `acquire_direct` and `acquire_firecrawl` all 1. After deployment the existing scheduled job runs the new reader in its existing approved-acquisition mode. Nothing is newly enabled, but the new validation rules (including the false holds in (c)) apply to the scheduled reads from the first run.

## Consumer API (G3)

- **No shape change.** The migration creates no consumer function and changes no consumer column. It reads `public.website_v2_provider` and `public.zoho_v2_provider` through `security.provider_description_consumer_read_v1` (read back, errors caught).
- **For the Controller to confirm:** `security.provider_description_sync_provider_v1` **writes `pipeline.website_sync_items`** (the website feed) for one admitted provider. It uses the existing item builder (`security.website_sync_item_v1`), the existing `website_sync_seq`, and the shared `website-sync-check` advisory lock, tried without waiting. It refreshes only when the provider's catalogue description equals an admitted, approved read.
  - This is a second writer of the feed, beside the existing website sync job. It writes rows, not shape, so it is not a G3 shape change.
  - Decision 19:14 §6 asks for no duplicate publication mechanisms. The Controller should confirm this on-demand refresh is acceptable, or route it through the existing sync job.

## Other gates

| Check | Result |
|---|---|
| CI on `33a7cce3` | Workers Builds, provider-description, build-and-smoke and isolated-postgres: success |
| Fixture | Not run here (no Docker daemon). Its parity layer includes captured production grants, indexes, triggers, roles and settings. |
| G2 | New settings have label, range, unit and `used_by`. Code values are marked `-- fixed:` (claim timer, advisory locks, API time-outs). |
| Housekeeping | `-- Replaces:` lists the six functions; `-- Retires: nothing`. RLS is on for both new tables. No drop. |

## Required before release

1. **Claim rules.** Make `historic_claim_context` evidence-aware and normalise numbers in `unsupported_numeric_claim`, so legitimate supported claims are not held (decision 20:03 §2). Add the cases above to the claim-policy fixture.
2. **Recovery text.** Correct the forward-recovery and deploy text about an old worker against the new database. Pause the job, or set `pdesc.enabled` to 0, before any worker rollback. Optionally gate the lease on the worker version.
3. **Feed writer.** The Controller confirms the on-demand write of `pipeline.website_sync_items` by `provider_description_sync_provider_v1`, or routes it through the existing sync.
4. **Recommended, not blocking:** load the live `admin_layer4_inbox` in the fixture. Optionally handle the "no matter which" and "none of" negation edge cases.
