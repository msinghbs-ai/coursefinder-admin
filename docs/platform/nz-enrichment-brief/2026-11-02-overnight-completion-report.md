# Overnight completion report: 1 Nov 22:01 to 2 Nov 02:05 AEDT

**Mandate:** Overnight Autonomous Execution Mandate, Platform Admin 1 Nov 2026 22:01 (`2026-11-01-overnight-autonomous-execution-mandate.md`).
**Record type:** the authoritative morning record. Detail sits in the documents referenced; nothing here replaces them.
**Integrator:** Claude, one controller. No other settlement controller acted on Layer 4 refs overnight.

## 1. Progress

| Area | Start (22:01) | Now (02:05) |
|---|---|---|
| Engineering SS-001 to SS-015 | 11/15 completed and verified | 11/15 (3 verifying, 1 in progress; observation windows running) |
| SS-016 accepted | 2 (UR-06, UR-13) | 2 (acceptance needs your walkthrough or lower-role sessions) |
| SS-016 implemented, awaiting acceptance | 8 | **13**: UR-01, 02, 03, 04, 05, 07, 08, 09, 10, 11, 12, 16, 17 |
| SS-016 not implemented | 7 | **2**: UR-14, UR-15 (investigation only, as directed) |
| UR-18 provider bulk review | Design in progress | Design done; not built (D-B1 to D-B3 unratified) |
| Current release | v2.15.395 | **v2.15.400** (5 releases overnight: 396–400) |

## 2. Role simulation (live and fixture kept separate)

| Role | Fixture journey (isolated, mocked) | Live session |
|---|---|---|
| Platform Admin (6) | Pass | **Pass** (the signed-in Platform Admin session) |
| PIM Admin (5) | Pass | Not tested (no session) |
| Pipeline Operator (4) | Pass | Not tested (no session) |
| Curator (3) | Pass | Not tested (no session) |
| Counsellor (2) | Pass | Not tested (no session) |
| Viewer (1) | Pass | Not tested (no session) |

The fixture specs are s207 to s211. No production user was impersonated, no session or JWT was fabricated, and no role assignment was changed. A real UAT account per role is needed to accept UR-02, UR-09 and UR-17 live.

## 3. Defects found and fixed overnight

| Defect | Found by | Fixed in |
|---|---|---|
| Automation refusal named the role for every automation, not the one that changes it | Walkthrough | v2.15.397 |
| Operating words disagreed between catalogue, notices, Automations and Health (UR-08, 10, 11, 12, 16) | Review | v2.15.396 |
| **E15:** "Use the new page" left two active official links. On hand-locked courses it recorded "approved" while applying nothing | Layer 4 audit | v2.15.398 (verified live by decision #28588) |
| **P1:** the guide said Curators decide Layer 4 items, but the server needs rank 4 | Fixture walkthrough | v2.15.399 (text follows the server; no rank changed) |
| **P2:** the Counsellor guide promised shortlists that do not exist | Fixture walkthrough | v2.15.399 |
| The new SOP mirror guard refused every routine sync, because Pilot merges by squash | The v2.15.399 Admin sync | v2.15.400 (proven by the v2.15.400 sync) |

## 4. Releases

| Release | Pilot | Migration | Full suite | After merge |
|---|---|---|---|---|
| v2.15.396 | `10b575c1` #788 | `20261101100000` (md5 `09f81312`) | 1,366 / 0 / 0 | All succeeded; live verified |
| v2.15.397 | `30b249dc` #789 | `20261101110000` (fn `431aff60`) | 0 failed / 0 skipped | All succeeded; live verified |
| v2.15.398 | `8f15da35` #790 | `20261101120000` (md5 `214aae7e`; fn `75a53dbb`) | 0 failed / 0 skipped | All succeeded; live verified |
| v2.15.399 | `64d98034` #791 | none | 1,405 / 0 / 0 | All succeeded; live verified |
| v2.15.400 | `1f7d41aa` #792 | none | 1,406 / 0 / 0 | All succeeded; live verified |

v2.15.395 (`73f46d1a`, #787) was live before the mandate (21:25) and is not counted here.

For each release:
- Before an existing function was replaced, its live md5 was checked against the expected value. The after md5 came from a rolled-back dry run.
- After deploy, the migration history md5 matched the file.
- SOP mirrors and TEST-REGISTER were synced.

The consumer API (G3) was not touched.

## 5. Layer 4

- **Pending:** 1,355 at the start of the overnight period; 1,352 now.
- **Decisions:** 2, made one at a time in the UI with a reason, each verified in the database:
  - **#28585:** SITI fee, the only item eligible under the existing rules (eligibility analysis in checkpoint 12).
  - **#28588:** Otago Polytechnic, Bachelor of Applied Management, course link. This also live-verified the E15 fix: the new link is active and primary, the `/print` link is inactive, course_url follows, and the regulator link is untouched.
- **Total verified decisions:** 521.
- **Holds:** kept on RMIT, QUT and ANU.
- **Not used:** no SQL settlement, bulk decision, paid read or re-read.

## 6. Unresolved exceptions (no action taken without your approval)

All are in `2026-11-01-consolidated-approval-pack.md`, with exact ids, md5s, rollback and ceilings.

| # | Waiting for |
|---|---|
| E1 | Withdraw 41 of 46 fees admitted 30 Oct (paste file and rollback ready) |
| E14 | Withdraw 105 entry rows on 18 courses (my approval errors of 1 Nov; Entry requirements screen preferred, paste file as fallback) |
| E15 | Data repair: Part 1 (4 TAFE courses) and Part 2 (Waikato WI0194, MITO 4226; option A or B, B recommended). The code fix is already live |
| E11 / E12 | RMIT and QUT international-only reads: ceilings about US$2.45 and a US$0.05 pilot |
| E13 | Reader gate for reads that drop rows at the cap |

## 7. UR-18 (provider bulk review)

- The design is complete: `2026-11-01-provider-bulk-review-design.md`, §10 admission contract.
  - The current decide RPC needs an existing review item, so the design creates one decided item per course, using the coverage-admission pattern.
  - New apply functions are needed for campus link, campus region, intake and delivery mode.
  - English reuses Decision 262.
  - About 8 days.
- **Nothing is built.** D-B1 to D-B3 are not ratified, and D-B4 (activation) is a separate later decision.

## 8. Tests

- **Suite:** 1,406 tests, 0 failed, 0 skipped (v2.15.400).
- **Added overnight:** s204 (Back), s206 (guide truth: UR-01/02/03/08/10/11/12/16/17, the mirror guard, P1, P2), s207 to s211 (six role fixtures) and s212 (E15).
- **Register:** regenerated after each release (`docs/platform/TEST-REGISTER.md`).

## 9. Platform health (02:00)

- **Website and Zoho APIs:** operational. Each release's Deployed UAT passed.
- **Migration head:** `20261101120000`.
- **Observation windows:** SS-004 and SS-014/SS-015 are still open (see the execution register dashboard).

## 10. Remaining tasks and owners

| Task | Owner |
|---|---|
| Decide the consolidated approval pack (E1, E14, E15 repair, E11–E13, D-B1–D-B3) | Platform Admin |
| Provide lower-role UAT sessions (ranks 1–5) for live acceptance | Platform Admin |
| Confirm the SS-014 [TEST] alerts arrived (UR-01 acceptance) | Platform Admin |
| Walk through and accept the 13 implemented SS-016 items | Platform Admin with Claude |
| 2 Nov 07:30: SS-014 checks (D13 pilot, D15 waits, D14 guard, D16 24 h); SS-004 clean 24 h at 09:25 | Claude |
| UR-14 recovery baseline: the manifest says v2.15.79 but the governance doc says v2.15.78; the capture dates from 10 Oct; no restore has ever been exercised | Platform Admin decision; Claude evidence |
| UR-15: settings backups do not cover catalogue data | Platform Admin decision |

## 11. Resumption

1. Read this report, then checkpoint 16 in `2026-11-01-layer4-batch-L4B-1253.md`, then the execution register dashboard (2 Nov 02:00).
2. Pilot `main` is `1f7d41aa` (v2.15.400) and Admin `main` is the commit that holds this report. Confirm with `git log -1` in each.
3. Before any Layer 4 decision:
   - confirm the item is still pending;
   - one controller, one at a time;
   - keep the RMIT, QUT and ANU holds.
4. Run no withdrawal, repair, paid read or bulk build until the matching approval is recorded verbatim.
5. Release steps: full suite with 0 failed and 0 skipped, a md5 dry run, ship, then check the version, migration head, function md5s and workflows; then the SOP mirror (`node scripts/export-sops.mjs --write-mirror <admin>/docs/sops`) and the test register.

## 12. Honesty notes

- I did no work after the session went idle. Anything not timestamped in the checkpoints did not happen.
- Only the Platform Admin role was tested live; the other five roles were tested as fixtures only.
- The E14 rows exist because of my approval errors on 1 Nov. I disclosed them, and the approval checks now cover dropped rows and the programme or variant named.
- The v2.15.399 mirror guard was released with a defect that the tests did not catch, because they did not model squash merges. It was found at the first sync and fixed in v2.15.400.
