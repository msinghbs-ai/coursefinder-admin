# Standing execution rules 9–10 and tonight's merges (decision record and response)

Platform Admin, 25 Oct 2026, 23:16 AEDT. CF-247.

## Rules as given (standing, every mandate)

1. **"MERGE YOUR OWN PRs."** A PR merges when:
   - the full suite is green;
   - the migration md5 has been verified against live;
   - a live dry run has passed, where applicable;
   - the change-control entries are written.

   Then: merge, deploy, confirm the live version string, and record the merge in the mandate file. The Platform Admin's review is retrospective, from the repo files. **Exception, unchanged:** destructive changes and consumer-API shape changes come as paste files and are never auto-merged.
2. **"LODGE EVERY RESPONSE IN THE ADMIN REPO."** The full response is written as a dated md in the right `docs/platform` folder before the chat reply. The chat reply is a pointer: the file path plus a three-line summary.

**Recorded:** `docs/platform/AGENT-OPERATING-MODEL.md` rules 9 and 10 (commit `abf35502`).

**Reading applied:** "full suite green" means no failures other than the named legacy ones (cf-091 and cf-103, desktop and mobile, failing on `main` since before CF-247). Any other failure blocks the merge.

## Merges under rule 9 (23:16–23:21)

| PR | Gates checked | Merge | Live confirmation |
|---|---|---|---|
| **#694 gate consolidation** (v2.15.352) | Suite 1,912 passed (4 legacy). Live md5 of all 8 edited functions = the guards (23:17). Live dry run passed (18:55; again as the base of SP-1's dry run). Change control written (19:05, 23:30) | `c478404e` (squash) | deploy-on-merge: `20261025002000` applied, history md5 `31410a56` matches the file. Release currentness on the deployed site passed. Post-merge md5: gate `6c23c9b7…`, AI-match prepare `049a7cab…` |
| **#696 SP-1** (v2.15.353) | Rebased on main after #694 (the base commit dropped; diff = SP-1 only). Suite 1,910 passed (4 legacy; 4 older contract tests updated to the renamed spend-check calls, 178 of 178 on re-run). Live md5 of all 8 edited functions = the guards (23:18). Live dry run on top of #694 passed. Change control written (23:30) | `859d2a7a` (squash) | deploy-on-merge: `20261025003000` applied, history md5 `5682b675` matches the file; coverage-sweep redeployed (version 206, 23:19:59). Release currentness passed. **The worker answers `coverage-sweep-worker-v0.47.0`** (23:20:57), and the Firecrawl panel shows its first named refusals: **20 `target_list_refused` in the first minute**, previously recorded as nothing |

**After SP-1, state is as designed:**
- `bind.no_page_on` = 0: proposals off; switching it on is the Platform Admin's step.
- Job `no-page-propose` scheduled hourly at :37 (scope refresh only while off).
- AI match scope live for Australian providers.
- `PIPELINE-LINEAGE.md` sections 2–4 updated in this commit (doc-as-code).

**Not merged tonight: #695 (Track C step A).** The Platform Admin's 18:54 instruction for Track C was "TONIGHT … NO merge", so the specific instruction stands for tonight. On 26 Oct it is rebased on SP-1:
- new md5 for `layer4_review_decide_impl` and `layer4_review_desk_v1_impl`;
- worker v0.48.0;
- migration timestamp after `20261025003000`.

It is then dry-run, suite-checked and merged under rule 9 (its reader stays off until Track B release 1). If you want it merged tonight instead, say so and it goes through the same gates.

## Rule 10 from here

Every response from 23:16 on is lodged before the reply; this file is the first under the rule. Tonight's earlier records (overnight outcomes, speed reconfiguration, Track C) were already in the repo.

## Activation (Platform Admin 23:24 "ACTIVATE NOW")

| # | Instruction | Done |
|---|---|---|
| 1 | Merge #694, then #696, under the new rule, with merge records | Already done at 23:17 / 23:21 (above), in that order. The suite state you accepted matches the gates applied |
| 2 | After #696: `bind.no_page_on` = 1 (logged) | **23:27**, `admin_toolsets_write` as the Platform Admin, reason logged in `admin_control_events`. The first run of `no-page-propose` is at 23:37 (hourly at :37); result below |
| 3 | Leave `bind.match_scope_top_n` at its default | Left at 100; the AU AI match scope is live (AI only) |
| 4 | Tranche 2 Part A: applied by the Platform Admin now; verify at 00:30 | Verification at the 00:30 checkpoint: 7 override rows, the 7 colleges included in the target cache, 18 fee pages re-queued and then fetched |

Carried to 08:00 (no action now):
- the ~60 matching-miss titles at the 8 NZ universities;
- Tranche 2 Part B from Monday's worst-named list;
- O8 / O9 from the Platform Admin.

### First run of `no-page-propose` (23:37, verified 23:39)

- The job succeeded and opened **10 Layer 4 first runs** (cap 10), universities first:
  - 9 "no page published": Newcastle, UTS, VU, Victoria University of Wellington, UNSW, Lincoln, RMIT, Auckland, Monash;
  - 1 conjoint rule: Waikato, 111 conjoint courses.
- Course rows: 45 no-page sample courses (5 per provider) and 111 conjoint courses, all `proposed`. **Nothing is recorded or held from search until a person decides**, and nothing is published by this lane.
- AI match scope: 104 Australian providers.
- The next 10 first runs open at 00:37, universities first (Otago, Massey, Canterbury, AUT and the remaining AU universities come next).

**For the Platform Admin:** each first run is in Layer 4 (task "No Page First Run" / "Conjoint Rule First Run") with its 5 sample courses and the provider's inventory size:
- approve if none of the samples has its own page;
- otherwise edit and approve with `{"has_page_course_ids": [...]}`.

At 60% confirmed, the provider is trusted.
