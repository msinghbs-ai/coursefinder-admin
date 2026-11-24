# Parallel Lane Conflict-Prevention Checklist (S2-RM-Design and S2-Scholarship-Readers)

**24 Nov 2026 11:00 AEDT (S2-Build, integration owner; Platform Admin 10:43).**

This lets the AER lane and the scholarship lane each ship 10 to 15 provider batch PRs in parallel without colliding. It is based on the collisions actually seen on 23 and 24 Nov 2026. `S2-Scholarship-Readers` is not yet named in the master plan section 3a; until it is, scholarships stay single-writer under the scholarships owner (S2-Build), and the new lane should be registered there first (plan rule: a session not named asks the Platform Admin which lane it is in).

## 1. Who touches what (single writer)

| Area | AER lane (S2-RM-Design) | Scholarship lane |
|---|---|---|
| Worker modules (`supabase/functions/coverage-sweep/`) | `entry*.ts`, `pdf*.ts`, `aer-*.ts`, `course-entry.ts` | `scholarship.ts`, `sch-extract.ts`, `eligibility.ts` |
| Shared worker file `index.ts` | Only its own mode branch and dispatch lines | Only its own mode branch (`scholarship_listing`, `scholarship_ai`) |
| Database | `pipeline.entry_matrix_*`, `catalogue.provider_entry_matrix`, `catalogue.course_entry_requirements`, `pipeline.aer_*` | `pipeline.scholarship_*`, `scholarship.*` |
| Queue column | `aer_status` | `scholarship_status` |
| Never | Scholarship tables, the G3 consumer surface (75/48), AER v1 code, the 7,585 manual locks | AER tables, the G3 consumer surface, the manual locks |

Shared gates (s1020, s1021, s1023) belong to S1-Build: read them, never edit them inside a batch PR.

## 2. Spec numbers

1. Claim the next number in plan section 3a ("Next free") in a small admin PR before opening the Pilot PR. One row per spec, with the lane named.
2. Never reuse a number seen in another lane's open PR. On 23 Nov, s990 was claimed by S1-API while S2-Build had planned it; claiming first avoided a clash.
3. Batch PRs: one spec per batch (for example "s10xx AER batch 3: <providers>"). Do not add a spec per provider.

## 3. Migration timestamps (s980)

1. **Strictly above main and every open PR, checked at push time.** Before every push, run `node scripts/ci/migration-preflight.mjs --base origin/main`. Also list open PRs' migration files (`gh api repos/msinghbs-ai/Coursefinder-Pilot/pulls?state=open`, then each PR's files) and take a version above the highest.
2. **Expect to renumber.** If another PR merges first with an equal or higher version, the pre-push hook refuses the push.
   - On 23 Nov S2-INT's s994 took `20261123190000` while S2-Build's s992 held the same number.
   - Fix: `git mv` the file to a higher version, update the version inside the file and in its spec, run the pre-flight again, push.
   - The dry-run gate re-runs on the new file.
3. **Proposed lane bands (not yet a rule; for the Platform Admin to confirm).** Within each day, AER uses `HH0000` to `HH2959` minute-seconds and scholarships use `HH3000` to `HH5959`, so two lanes picking "the next hour" do not pick the same number. The version must still be above main.
4. **Rehearse before labelling.** Run the hand-started rolled-back run (workflow_dispatch, job `rehearsal`), then label the PR `live-dry-run`. Auto-merge counts only the `dry-run` check.
5. **Read-back carriers** (rolled-back probes) live only on read-only branches and must also be above the live head, or the rehearsal skips them with a pre-flight warning (seen 24 Nov).

## 4. `TEST-REGISTER.md` (generated; never hand-edit)

1. **One regeneration per admin PR, from Pilot `main` after the Pilot merge**, not from a feature branch.
   - A feature-branch register drops other lanes' merged specs or carries unmerged ones; on 23 Nov a copy carried three s990 specs from an unmerged branch.
2. **Use a full clone** with `git config core.abbrev 9`.
   - A shallow clone dates every spec to a recent PR in the "added in" column (seen 23 Nov).
   - A different hash length rewrites every row.
3. **If `npx playwright test --list` fails on a missing frontend package** (for example `lucide-react` with installs blocked): a local, uncommitted stub that only lets the files load is acceptable for listing. Remove it afterwards; never commit it.
4. **On an admin merge conflict in the register,** do not merge by hand. Take `main`'s file, rerun `node scripts/test-register.mjs` from Pilot `main` and commit the output.

## 5. Shared worker version and documents generated from it

1. **The worker version is pinned by about 17 specs.** Any worker change bumps `const WORKER = "coverage-sweep-worker-vX.Y.Z"` in `index.ts`, and the specs pinning it must follow in the same PR. If both lanes bump, the second to merge rebases, takes the next version and updates the same specs.
2. **Line-number documents.** Inserting lines in `index.ts` moves every model call site.
   - `docs/platform/AI-CALL-PATHS-2026-11-13.md` lists each `await cascadeFetch(` site as `index.ts:<line>` (guard `cf-247-ai-models-services-contract`).
   - `docs/platform/ai-prompts.json` is regenerated with `node scripts/ai-prompts-export.mjs`.
   - Regenerate both after every rebase of a worker change; on 23 Nov, s992's CI failed on exactly this.
3. **Before pushing a worker change,** run every spec that reads the worker or those documents (`grep -l "coverage-sweep/index.ts\|ai-prompts.json\|AI-CALL-PATHS" tests/uat/*.mjs`). Locally, only the mocked-browser tests are expected to fail.

## 6. `PROVIDER-ENRICHMENT-QUEUE.csv` claims

1. **Claim, ship and advance by admin PR,** as section 3 of the delivery design sets out:
   - set `<lane>_status` = `CLAIMED:<lane>`;
   - set `active_spec_id`;
   - after the Pilot merge and live read-back, set `DONE` or `HELD:<reason>` (`NO_SOURCE`, `SITE_BLOCKED`, `BUDGET_GATE`, `G3_FREEZE`, `IDENTITY_UNRESOLVED`, `NON_ACADEMIC_ONLY`).
2. **Edit only your own status column** in your rows. Rewrite the file with a CSV writer that keeps the existing line endings and quoting, so the diff shows only your rows.
3. **Conflict to resolve: `active_claim_lane` and `active_spec_id` are single shared columns.**
   - If the AER lane and the scholarship lane claim the same university, they overwrite each other's claim, and the design's "skip a row with `active_claim_lane` set" rule blocks the second lane.
   - Until the integration owner splits these into per-lane columns, the lane's own status column (`CLAIMED:<lane>`) is the lock. A lane leaves `active_claim_lane` alone when it already names another lane, and never skips a row only because another lane's name is there.
4. **Pick disjoint batches.** The AER lane takes universities grouped by `source_type`; the scholarship lane takes universities with a registered hub (`has_registered_source = Yes` in `Scholarship_University_Reader_Status.csv`).
5. **Rebase the admin claim PR immediately before merge.** If the file changed, re-apply your rows on top of `main` and do not resolve the conflict by hand.

## 7. Admin record files (append-only hot spots)

- `docs/CURRENT-STATE.md`: insert your entry directly above the newest entry from your own lane, not at a fixed line, and rebase just before merging.
- `docs/platform/CONTINUOUS-DELIVERY-MASTER-PLAN.md`: edit only your lane's status table rows, your spec claim row and one status-log line.
- The five runsheet files get the identical entry appended at the end; on a conflict, keep both entries in time order.
- `docs/Roadmap/2026-01/ROADMAP-ENGAGEMENTS.csv`: append one row, unique id `<timestamp>-claude-<lane>-<spec>`.

## 8. Merge order and live checks

Merge the admin record PR first (automerge label), then the Pilot PR, on green CI plus a passed `dry-run`. Then check live:
- the deploy ran;
- G3 75/48 with no drift;
- 7,585 locks;
- active cron at most 140;
- the day's paid spend at most US$5.00 (Firecrawl credits from `pipeline.firecrawl_calls`; see the inventory's section 3.4 metering warning).
