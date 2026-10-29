# AER programme — handback to the governed completion boundary (29 Oct 2026)

**Mandate:** Platform Admin, 29 Oct 2026 16:59 AEDT (Workstreams 0–5).
**Read live from `fxcwkweaxjtknorudmwp`:** 17:00–18:00 AEDT. Every figure below was re-read at the time stated.
**Not "AER complete".** Proposed rows await human review, eligible courses remain unread, source holds remain, course reading is stopped at the credit floor, one deployed test is red (Universities payload regression, §6), and website rendering is the website team's.

Companion files:
- live status `2026-10-29-aer-live-status.md`;
- deadlock report `2026-10-29-scholarship-deadlock-reconciliation.md`;
- programme report `2026-10-29-aer-programme-consolidated-report.md`;
- Layer 4 manifest `2026-10-29-aer-layer4-manifest.md`;
- role guides `../AER-ROLE-GUIDES.md`;
- decisions W27–W29 in `../AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md` §7.

## 1. DELIVERED (merged, deployed and verified on live)

| Item | Release / commit | Evidence |
|---|---|---|
| **Scholarship paste: reconciled** | — (Platform Admin ran it) | First run deadlocked and rolled back (16:26). Second run committed at 16:57; "Failed to fetch" was the editor connection. 0 wrong-level field-only links on the 210 applied scholarships (was 8,042); block C's 383 links untouched; 0 hand links; 2,605 search documents regenerated; DP020 shows 4 undergraduate/pathway scholarships. **Do not re-run** (its precondition now reads 208). |
| **W27 one writer lock for search documents** (deadlock root cause) | PR #743, `15664910`, migration `20261029110000` | Migration md5 `196c6d38` equals the file; functions `fb55e935` / `402c1dae` / `6f3e46a7`. Local reproduction: 3 deadlocks before, 0 after. Rolled-back live dry run. Job 39 ran 17:26 AEDT under the lock and succeeded. Suite 1,187/0/0. |
| **W28 Read again reads only the newest stored copy** | PR #744, `33f53e50`, migration `20261029120000` | Migration md5 `c464bb04`; `aer_reread_v1` `ad0fbd35`. Live dry run on Otago Polytechnic re-queued exactly one run (the 29 Oct copy). Suite 1,191/0/0. |
| **W29 long course pages read in slices** (worker v0.53.0) | PR #745, `f7513737`, v2.15.369, migration `20261029130000` | Migration md5 `797b8da4`; `enrich_entry_record_v1` `857102dc`; 5 settings live; deployed worker v0.53.0 with every file byte-identical to main; release currentness green. Suite 1,199/0/0. No paid read. |
| **Resolver and consumer reconciliation** (read-only) | — | 6,030 course × country checks (RMIT, Monash, Federation, UWA, Wollongong × IN/NP/SG): website payload equals resolver in every case; six providers with 8–22 proposed India rows return 0 rows to the website; RMIT returns its 33 active India rows at provider level. |
| **Role guides** (six roles + quick-reference matrix) | admin `2b24140f`, 4.1 updated `c3f36374` | `docs/platform/AER-ROLE-GUIDES.md`; links the in-app SOPs and UI catalogue instead of duplicating them. |
| **Website developer handoff** | admin `2b24140f` | Developer guide §7.9 clarified (resolution `country`, `note`, `contact`; the contact-provider notes; case-by-case; live examples; the website team renders). No API change, so no §13 line and the issue number is unchanged. `WEBSITE-DEVELOPER-REQUIREMENTS.md` v2.3. |
| **Provider source inventory** | lane C (read-only) | 102 sources: 66 in reading scope plus RMIT's 36. Only Otago Polytechnic has a pending item on an older copy. 12 held for a reader change; 3 Macquarie PDFs never read. |

## 2. Why RMIT says "contact the provider" for India, Nepal and Singapore

- RMIT's 343 active rows are 267 band-ladder rows (a band printed on the course page selects the row) and 76 provider minimums.
- Its minimums for India and Nepal are all foundation level (Foundation Studies, University Pathways Fast Track), and RMIT has no foundation-level course in the catalogue.
- Its band ladders need a band printed on the course page; no admitted course-level read supplies one yet (DP020's page prints none).
- So all 509 RMIT courses resolve to rule 5 for these countries. That is a coverage fact, not a resolver defect.
- Other providers' rows are proposed and wait in Layer 4; none reaches the website until a person approves it.

## 3. Current counts (18:00 AEDT)

| Measure | Count |
|---|---|
| Provider matrix rows | active 343 (RMIT only) · proposed 2,186 (26 providers) · quarantined 20 · superseded 765 |
| Layer 4 pending (AER) | 241: 53 matrix first runs, 4 RMIT changes, 184 course first reads |
| Course rows | proposed 695, active 0 |
| Course reads | 203 (184 in review, 16 skipped, 3 failed; DP020 and BH126 in review) |
| Eligible for course reading | 4,156 AU + 421 NZ = 4,577 (AU was 4,977 at 14:45; see 5.3) |
| NZ courses read | 0 |
| Sources | 102 (99 read, 3 failed) |
| What reaches the website and Zoho | RMIT's 343 active rows only; no course row |
| OpenRouter balance | US$5.24 against the US$5 floor (falling with other platform AI work) |

## 4. BLOCKED — the single decision each needs

1. **Course reading spend.** Course reading is stopped at the floor.
   - Each 50-course batch costs about US$0.40–0.45 (US$0.008 a course).
   - Prepared, not run: the next 10 batches are all AU (Monash, then QUT, then RMIT), about US$4.00, ceiling US$6.00. NZ is reached at batch 80 in the current order.
   - **Decision:** a top-up amount and a scope. Options are AU in plan order; NZ first, either per NZ provider (18 batches, about US$3.40) or by moving NZ providers to the front of `entry.course_read_providers`.
2. **Three re-reads that have used their approved attempt:** ANU Croatian Matura, Melbourne India State Board `290bd250`, and ANU `509c8f82` (never approved).
   - Exactly 3 jobs through Read again (W28: newest copy only), maximum spend US$0.05.
   - **Decision:** approve or decline.
3. **Three failed Monash course reads** (`e58e7771`, `512b56fe`, `9cf18451`), now readable in slices by v0.53.0.
   - Exactly 3 course reads, maximum spend US$0.10.
   - **Decision:** approve or decline.
4. **Layer 4 review (human).** 241 items per the manifest:
   - Federation and Western Sydney row by row;
   - 4 RMIT governed decisions;
   - 18 Monash age-rule rows for reviewer judgement;
   - reject the stale Otago Polytechnic item `f14ae480`.
   - Nothing here is approved by the platform.
5. **Governance questions from the role guides** (Q2–Q5):
   - how a reviewer does "Approve except" on an AER item;
   - whether bulk decide should exclude AER item kinds (it can reject a whole AER group today);
   - whether AER Layer 4 decisions are Platform Admin only (the server lets Curators decide);
   - how printed requirements with no scale should be worded for the website.
6. **Bulk re-reads:** whether `admin_entry_matrix_reread` (bulk, md5-pinned elsewhere) should also take only the newest copy.
7. **Universities list paging** (§6): approve server-side paging so the deployed suite can return to green.

## 5. Findings and investigation items

1. **Unrecorded spend:** the three failed Monash reads cost about US$0.10 that was never recorded (9 calls, `cost_usd` 0). v0.53.0 now records cost on failed reads.
2. **G2 gap:** the worker's other field reads still use a fixed 2,000-token answer limit, a hard-coded operational value.
3. **Eligible-course drop:** 821 AU courses left the eligible set after 14:45.
   - 1,210 AU course pages are now "identity mismatch".
   - The `coverage-bind` job re-bound about 4,000 pages at 14:15–14:35 AEDT, 1,258 of them with no identity basis and 471 by title only.
   - The identity gate excludes these correctly. Whether the re-binding itself is right is for the coverage pipeline's owner to investigate. Not caused by today's releases.
4. **Branches:** this session's proxy refuses ref deletion. Lane branches remain on GitHub (Pilot: `cf247-search-writer-lock`, `cf247-aer-reread-newest-copy`, `cf247-aer-reread-newest-copy-int`, `cf247-aer-course-sliced-read`, `cf247-aer-course-sliced-read-int`, `cf247-deployed-suite-health`, `cf247-deployed-suite-health-int`; admin: `aer-role-guides`). All are merged into main or superseded; deletion needs a session that can delete refs. `cf247-zoho-dryrun` is kept identical to main.

## 6. Workstream 4 — release health

**DELIVERED (PR #746, `5b8d7e49`), with one FAILED item left red by rule.**

- All 31 acceptance-tier failures were classified with evidence:
  - most were obsolete or had drifted after the v2.15.225–v2.15.301 screen changes, and were repaired against the current screens without weakening assertions;
  - a shared navigation-helper bug was fixed (it checked for the tab bar before it was drawn).
- **6 tests retired** through the test-governance process; the retirement log is in `ui-audit/2026-10-26-test-governance.md` (`594115c6`). Deployed tests go from 97 to 89.
- Local suite 1,199/0/0. The post-merge targeted Deployed UAT passed. `deployed-uat.yml` lists updated.
- **FAILED — genuine product regression, left red (not weakened):** the Layer 2/3 › Universities read `admin_layer23('universities')` returns 1.97 MB against its 700 KB budget (about 3.2 s against 3 s). The spec had recorded server-side paging as later work once the list grew. The acceptance tier and the weekly deployed run stay red on this test until it is fixed.
  - **Containment:** nothing changes on live; the screen still works, just heavily.
  - **Decision:** approve server-side paging of the Universities list (UI plus server, non-AER).
- **Intermittent database statement timeouts** on five admin reads (`course_coverage`, `admin_field_coverage`, `admin_platform_notices_read`, `admin_progress_read`, `pipeline_jobs_page`) make some deployed runs flaky. One was hit by a real operator at 17:12 AEDT. This is for investigation; no test was loosened.

## 7. Next governed actions

1. The Platform Admin decides items 4.1–4.3 (spend and the six named reads); each runs through its migration route with a dry run and change control.
2. Layer 4 reviewers work through the manifest.
3. The coverage pipeline owner investigates the identity-mismatch growth (5.3).
4. The worker's remaining fixed answer limits become settings (5.2), under a new decision.
