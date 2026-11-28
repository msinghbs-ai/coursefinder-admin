# s1371: cut scholarship answers get the two-part read; stranded candidate pages get one recovery read

S2-Build, 28 Nov 2026 22:45 AEDT (renumbered 23:00 AEDT from s1363, which S2-RM-Design holds for the binding fix; PC-20261128-2223-QUT-SETTLED). Instructions: PC-20261128-LEAN-SESSION-BOOTSTRAP and PC-20261128-CONTINUOUS-BUILD-EXECUTE (scope: scholarship reader, listing and coverage machinery; fix reusable bottlenecks only). Agent Operating Model, S2-Scholarship rule 2 (long-page failures are a technical recovery lane) and DR-19.

Pilot branch `s1371-scholarship-candidate-cut-recovery` (commit on it; PR to be opened by S1-Build, see below). Migration `20261201163700_cf247_s1371_scholarship_candidate_cut_recovery.sql`, spec `tests/uat/cf-247-s1371-scholarship-candidate-cut-recovery-contract.spec.mjs`.

## The defect (live read-only reads, 28 Nov 2026 22:05 to 22:40 AEDT)

- 120 scholarship candidate pages are read (stored copy and rule facts held) with no admission decision. 114 of them used all 3 AI attempts and every attempt failed; the oldest was read on 2 Nov.
- Errors on those candidates: `held_partial: output_truncated` 293 calls on 98 candidates (qwen3-30b), `no_answer` 78 calls on 56, `unreadable_answer` and others on the rest.
- Cause 1: s985 (23 Nov) reads a cut answer next as the two-part read (`sectioned-v1`), but only when the answer escalates to the next model. The active chain is qwen3-30b alone (`security.scholarship_ai_next_model_v1('qwen3-30b')` is null), so the same whole-page request is retried word for word until the cap: 316 cut calls on 187 items in 7 days, US$0.51 spent on discarded answers.
- Cause 2: the long-page recovery queue `security.scholarship_detail_recovery_queue_v1` takes admitted scholarships only. No `sectioned-v1` item has ever been queued for a candidate.

## The fix (two anchored edits; no table, column, job, setting, route or data change)

1. `public.svc_scholarship_ai_record` (live md5 `0f6ec455ebeb693fd042667a87f30a6e`): when a cut answer is retried by the same model, the retry carries `sectioned-v1`. Only prompt version 3 or later, only while a try is left, and an existing variant is kept.
2. `security.scholarship_detail_recovery_queue_v1` (live md5 `26eac00f82dacef4ab0b3dd6bbb0c6b1`): within the same limit, after the scholarship items, a candidate page with a stored copy, no successful version 3 read, a version 3 read that was cut, empty or unreadable, and no recovery item yet, is queued once as an `admit` item with `sectioned-v1`. It runs from the existing `scholarship-ai-extract` job (`security.scholarship_ai_fire_v1` -> `scholarship_detail_backfill_v1`, `batch.sch_detail_backfill` 40) when nothing else is due. Provider hidden, directory site, the route's switch and cap, and the US$5.00 daily ceiling apply as before.

At most one recovery item per candidate. Expected first cohort: 103 candidates at 50 providers (97 cut). Estimated spend: 2 calls per read at about US$0.0005 each, about US$0.10, under US$1 at the worst case of 3 tries each.

## Checks

- Pre-flight: `node scripts/ci/migration-preflight.mjs --base origin/main` passes (above `20261201150000`).
- Specs (local, minimal runner since packages cannot be installed in this session): s1371 3/3, s42 3/3, s57 3/3, s120 6/6, s980 5/5, s985 2/2, s1360 3/3. s32 has one browser-page case that the minimal runner cannot run; it fails the same way on `main`, unrelated to this change.
- Scratch PostgreSQL 16: the full live recovery-queue definition and a reduced record function with the exact anchored statement. The migration applies; a second run reports all three edits already applied. Behaviour: of seven seeded candidates, only the two stranded ones are queued (cut and no answer), once each; a good read, an existing recovery item, a directory site, no stored copy and a decided candidate are left alone. Record: a cut answer with a try left gets `sectioned-v1`; no answer, the attempt cap and prompt version 2 do not.
- G3 75/48, manual locks and active cron are asserted inside the migration.

## For S1-Build (integration owner)

1. Confirm spec `s1371` and version `20261201163700` (no other claim seen on main, the admin current-state index or remote branches at 22:40 AEDT).
2. Open the Pilot PR from the branch, run the rolled-back rehearsal on the exact head, then add `live-dry-run` and `automerge` after this admin record merges. Regenerate the test register with the release.
3. After deploy: read back both live md5s, the first recovery items (`recovery = 'sectioned-v1' and candidate_id is not null`), their extractions and any admissions and publications.

This session's GitHub CLI token is invalid, so it cannot open the PR or add labels; the branch push worked.
