# AER programme — consolidated report (operations workspace and implementation status)

**Mandates:**
- Platform Admin, 28 Oct 2026 23:22: "Consolidated programme mandate — complete the approved AER plan".
- Platform Admin, 29 Oct 2026 08:06: "AER operations workspace: complete UI, data management and visual parity".

**Decision records:** `ENTRY-REQUIREMENTS-PROGRAMME-DECISION-2026-10-28.md` and `AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md`. Both were lodged before code. The build-order authority is `ENTRY-REQUIREMENTS-IMPLEMENTATION.md`.

- Platform Admin, 29 Oct 2026 09:57: "Continue the full AER programme — consolidated authority and remaining delivery". This is the latest authority, reported in **Part A**.

**Updated:** 29 Oct 2026, about 12:00 AEDT. Live figures in Part A were read from `fxcwkweaxjtknorudmwp` between 11:30 and 11:50 AEDT.
- Part A is the latest state.
- Parts 1 to 6 below are the 09:50 report, kept as written; where they differ, Part A supersedes them.
- The Layer 4 manifest is in `2026-10-29-aer-layer4-manifest.md`.

## Status in plain words

- **This is not "AER complete".**
  - 1,786 provider rows (26 providers) and 200 course rows wait in Layer 4.
  - Course-level reading has covered 50 of 4,977 eligible Australian courses (plus BH126).
  - 15 sources are held for named reasons.
  - The website display is the website team's work and is not built.
- **What reaches the website and Zoho:** only RMIT's 343 active matrix rows, unchanged; for India, 33 rows. No course row is active.
- **Delivered since 09:57:**
  - the approved reader settings and HTML refetch (v2.15.364);
  - the ten re-reads, all finished, with the rows kept rising from 169 to 1,179;
  - the course-level programme, its first batch of 50 Monash courses, and Course-level reading in the workspace;
  - the Step C no-table Layer 4 note;
  - live read-only screenshots of the workspace at desktop and phone width, with two layout defects found and fixed (v2.15.365);
  - the reconciled Layer 4 manifest;
  - branch checks.

---

# Part A — Continued programme (Platform Admin decision 29 Oct 2026 09:57)

## A1. Settings migration and deployment evidence

- **Release:** v2.15.364 (Pilot #734, merge `60d2be1b`). The decision addendum W12a, W17 and W18 was recorded before code (`fb77a43d`).
- **Migration `20261029020000`** (history md5 `7ae33c61` equals the file):
  - `entry.matrix_slice_concurrency` 6 (new) and `entry.matrix_slice_chars` 8,000;
  - `svc_entry_matrix_next` passes the concurrency (live before `dc1bab7a`, after `3eb6ca3b`);
  - Read again moves into `security.aer_reread_v1` (owner only) and fetches a markdown-stored web page again as HTML.
- **Migration `20261029030000`** (md5 `ac325995` equals the file): the course-level programme and the Step C note. Every existing function it edits was md5-guarded against live:
  - `admin_aer` `bc7fe780` after `020000`, as computed beforehand;
  - `svc_entry_matrix_record` `15fb11f8`;
  - `entry_matrix_review_apply_v1` `f1152d19`.
- **Rolled-back live dry runs before merge:**
  - **Settings:** the values took effect.
  - **Read again:**
    - Curator refused;
    - Wintec fetched again as HTML (13 rows and 1 item superseded);
    - the same source a second time refused;
    - a failed read re-queued;
    - a done read re-read.
  - **Programme:** 4,977 eligible courses, read in 2.9 s. Curator batch refused; preview 50 courses at US$0.25; a Platform Admin batch of 3 queued 3 items; a second batch refused while the first waits.
  - **Notes:** three notes opened; approving one admitted 0 and superseded 0.
  - **Consumer:** RMIT 343 unchanged.
- **Approval prompt:** the first three attempts at these dry runs were cancelled at the approval prompt. With "DRY RUN" made explicit, the next ones ran; nothing was retried blind.
- **Local suite:** 1,139 passed, 0 failed, 0 skipped.
- **Deployed:** Deploy on merge, Release History Contract, Deployed UAT (targeted), Release Currentness Deployed and Frontend Build all succeeded. The live pill reads v2.15.364.

## A2. The ten authorised re-reads (one governed attempt each)

- **Mechanism:** migration `20261029040000` (Pilot #735, merge `3b98257a`, md5 `02a434be` equals the file), approved as one bounded batch. It used the same mechanism as Read again; the actor was the Platform Admin.
- **Rolled-back dry run:** all ten were accepted.
- **Earlier partial reads were superseded, never approved:** 33 rows from 3 items by re-read, and 136 rows from 4 items by refetch.
- **Every read finished at its first governed attempt.** Western Sydney used two worker tries: the first stopped on the time budget, which the existing rule allows.

| Source | Before | Now (pending in Layer 4) | Not kept, by reason | New cost | Item |
|---|---|---|---|---|---|
| Western Sydney (PDF) | 13 kept, 65 not | **367** kept in 12 slices, 64 countries | 16 grade not in quote, 7 unknown country, 2 quote not on page | US$0.159 | `763ece39` |
| Victoria University (PDF) | failed (cut reply) | **147** kept in 5 slices, 24 countries | 5 unknown country, 1 grade not in quote | US$0.040 | `71f21b77` |
| Wollongong | failed (time budget) | **175** kept in 9 slices, 43 countries | 75 quote not on page, 12 unknown country, 4 band, 4 low confidence, 1 value | US$0.074 | `50b5cbf6` |
| Manukau (MIT) | failed (cut reply) | **68** kept, 41 countries | 4 grade, 2 value without scale, 2 unknown country | US$0.019 | `040d7b41` |
| UWA | 9 kept, 68 not | **50** kept, 9 countries | 101 band not in quote, 27 quote not on page, 8 value | US$0.037 | `c70b3d2a` |
| Federation (PDF) | 11 kept | **47** kept, 41 countries | 28 quote not on page, 3 grade, 2 missing, 2 value without scale | US$0.022 | `381f479f` |
| Wintec (HTML refetch) | 13 kept, 47 not (markdown) | **135** kept, 46 countries | 15 quote not on page, 3 grade, 3 unknown country, 2 low confidence, 1 value | US$0.039 | `f7c76d5d` |
| Otago Polytechnic (HTML refetch) | 18 kept, 39 not | **71** kept, 40 countries | 45 quote not on page, 11 grade, 4 unknown country, 2 value | US$0.037 | `5e40fcd8` |
| Lincoln (HTML refetch) | 63 kept, 23 not | **71** kept, 40 countries | 5 unknown country, 2 low confidence, 1 band, 1 value | US$0.021 | `e960bd2b` |
| NMIT (HTML refetch) | 42 kept, 12 not | **48** kept, 25 countries | 2 unknown country | US$0.014 | `cdb8ec0f` |

- **Total re-read cost:** about US$0.46.
- **Completeness:**
  - **Complete for review:** Western Sydney, Victoria University, Manukau, Wintec, Lincoln and NMIT.
  - **Still not complete, for named source reasons:** Federation, Wollongong, Otago Polytechnic and UWA. Their dropped rows are quotes the gate could not find on the stored copy, or bands not printed in the quote. They are held, not approved.
  - **Federation** stays unapproved as decided.
  - **Western Sydney** is complete but stays unapproved until a person confirms its source-anchored checks.
  - No further retry was made. A structure-driven reader correction for the UWA band column and the Federation and Otago Polytechnic quote matching is open programme work. It is not a Platform Admin click.

## A3. Course-level rollout (W17)

- **Scope.** The approved plan's Australian providers, in the setting's priority order: Monash and QUT first, because they publish requirements only on course pages; then RMIT, for its band ladder; then the plan's other Australian providers.
- **Eligible courses:** an active course, a bound stored official page, and a strong identity proof.
- **New Zealand courses are not eligible.** `entry.course_read_countries` is AU, and New Zealand has no identity proof rule for entry requirements yet. That is a separate decision; see A6.

| Provider | Eligible | Read | Waiting in Layer 4 (courses · rows) | Admitted | No row kept | Remaining |
|---|---|---|---|---|---|---|
| Monash University | 356 | 50 | 48 · 197 | 0 | 2 (the page does not state it) | 306 |
| Queensland University of Technology | 184 | 0 | 0 | 0 | 0 | 184 |
| RMIT University | 334 | 1 (BH126) | 1 · 3 | 0 | 0 | 333 |
| UNSW Sydney | 430 | 0 | 0 | 0 | 0 | 430 |
| Flinders University | 351 | 0 | 0 | 0 | 0 | 351 |
| Australian National University | 349 | 0 | 0 | 0 | 0 | 349 |
| The University of Queensland | 314 | 0 | 0 | 0 | 0 | 314 |
| The University of Melbourne | 312 | 0 | 0 | 0 | 0 | 312 |
| University of Technology Sydney | 294 | 0 | 0 | 0 | 0 | 294 |
| The University of Western Australia | 279 | 0 | 0 | 0 | 0 | 279 |
| Curtin University | 276 | 0 | 0 | 0 | 0 | 276 |
| Western Sydney University | 247 | 0 | 0 | 0 | 0 | 247 |
| Griffith University | 242 | 0 | 0 | 0 | 0 | 242 |
| Adelaide University | 234 | 0 | 0 | 0 | 0 | 234 |
| University of Wollongong | 195 | 0 | 0 | 0 | 0 | 195 |
| The University of Newcastle | 189 | 0 | 0 | 0 | 0 | 189 |
| Swinburne University of Technology | 188 | 0 | 0 | 0 | 0 | 188 |
| Victoria University | 108 | 0 | 0 | 0 | 0 | 108 |
| Macquarie University | 78 | 0 | 0 | 0 | 0 | 78 |
| The University of Sydney | 9 | 0 | 0 | 0 | 0 | 9 |
| Federation University Australia | 8 | 0 | 0 | 0 | 0 | 8 |
| **Total** | **4,977** | **51** | **49 · 200** | **0** | **2** | **4,926** |

- **Measured cost:** the first batch cost US$0.45 for 50 courses, about US$0.009 a course. The setting's estimate was US$0.005; the measured average replaces it after 20 reads.
- **Finishing the remaining 4,926 courses** would cost about **US$45**.
- **This is the one spending-limit decision genuinely required.** The OpenRouter balance is US$7.37 against its US$5 floor, about US$2.37 of headroom shared with every other AI use.
  - The remaining batches are bounded and ready. Each is 50 courses at about US$0.45, through Preview next batch, then Read next batch (Platform Admin) in Course entry requirements › Course-level reading.
  - They wait on a top-up, or on a Platform Admin decision to spend the headroom.
- **What the Monash rows look like:**
  - domestic ATARs with their printed basis (for example "2027 intake ATAR 77.5");
  - Monash pathway scores (Foundation Year 76.25%, Diploma Part 2 70%);
  - prior-qualification rules.
  - Some general notes (minimum age 17) are not academic entry requirements. The manifest asks reviewers to reject those.
  - No row infers international applicability, and there are no English-test rows.

## A4. Rendered no-table Layer 4 behaviour (W18)

- **A rendered page with no row** now opens one Layer 4 note in the existing vocabulary (`entry_matrix_first_run`, pending, no rows). Approving it confirms "no matrix published here", and the website says "contact the provider". It admits, quarantines and supersedes nothing (verified in the dry run).
- **The three existing reads got their notes:**
  - Griffith `a0e19f74`;
  - Newcastle `5aa58072`;
  - Victoria University of Wellington `f6941f3d`.
- **The workspace shows the two states apart, in words:** "Rendered, no table: in Layer 4" while the note waits, and "No matrix published (confirmed)" once it is approved.
- **Reviewers note:** Griffith and Victoria University of Wellington each had 4 rows not kept as unknown countries. Check the page before confirming.

## A5. Live read-only visual acceptance

- **How it was captured:**
  - the existing UAT identity (role Pipeline Operator) and the existing UI review screenshots workflow, with a new read-only tour (`tools/ui-review/aer-tour.mjs`, `screens: aer-tour`);
  - the live-acting switch was off, and no live row was edited;
  - run 48 (29 Oct, 11:22 AEDT) is in `assets/2026-10-29-aer-workspace-live/`, with the tour's own `manifest.json`;
  - run 49 (11:50 AEDT, from `main` with v2.15.365 live) repeated it: 13 screens, no sideways scroll, no clipping, no console error, 33 bounded reads and 0 writes; it is kept on the `ui-review-snapshots` branch, folder `20261029-0050-run49`.
- **Screens captured:**

  | Screen | File |
  |---|---|
  | Provider matrix, all | `aer-01` |
  | RMIT + India (33 rows, three chips) | `aer-02` |
  | Columns menu | `aer-03` |
  | Row drawer: quote, source, stored copy, run and model, Layer 4 approved, history | `aer-04` |
  | Waiting in Layer 4 filter | `aer-05` |
  | Course entry requirements with the live Monash rows | `aer-06` |
  | Course-level reading panel on live counts | `aer-06b` |
  | Course drawer | `aer-07` |
  | Sources, reads and holds | `aer-08`, `aer-08b` |
  | Resolution inspection: BH126 for India, rule 5 "Used" with why rules 1 to 4 did not apply | `aer-09` |
  | Phone width (390 px): matrix, course, sources and resolution | `aer-10` to `aer-13` |

- **Checks on every screen:**
  - no page-level sideways scroll;
  - no clipped element found by the tour's check;
  - no console error;
  - 33 `admin_aer` calls, every list at most 50 rows a page, and 0 writes.
- **What looking at them found** (not caught by the automatic check):
  1. On Sources, the "Rendered, no table: in Layer 4" pill and the Cost value ("US$0…") were cut at their column edges. Fixed in v2.15.365 (Pilot #736): the pill wraps in its cell and both columns are wider; s156 guards it.
  2. On a phone, the shell's OpenRouter low-credit banner clips its first letter ("penRouter"). This is the shared shell notice, not the AER workspace. It is recorded for the shell owner and not changed here.
  3. The live phone tour did not open a row's drawer, in run 48 or in run 49 (a middle-cell tap, run from `main` after v2.15.365).
     - A probe of the same tap at Pixel 7 width against the mock harness opens the drawer with its quote.
     - The desktop drawer was captured live.
     - So the live phone drawer is **not** visually accepted. The gap is either the tour's tap target or a live-only phone behaviour, and it is open work, not claimed.
  4. A Firecrawl-fallback HTML page (AUT, Lincoln) is labelled "Rendered page" in the Source type line. The label is cosmetic; the read route is correct.
- **Compared with Scholarships**, the screens use the same shell, filter bar, chips, table, drawer and pills.

## A6. Layer 4: reconciled manifest and the remaining human decisions

**106 pending AER items:** 57 provider entry matrix items and 49 course items. Each is classified once in `2026-10-29-aer-layer4-manifest.md`, with ids, providers, rows kept and not kept, reasons, class and links.

| Class | Items |
|---|---|
| Complete: ready for review | 33 matrix (Western Sydney included, which stays unapproved until confirmed) + 48 Monash courses |
| Governed decision | BH126 `cf71cca1` (approve except `dab50fa7`), and the 4 RMIT change items (37 rows) |
| Note | 3 rendered no-table notes |
| Held for a named source reason | Federation (stays unapproved), Wollongong, Otago Polytechnic and UWA |
| Partial: Read again first | 9 ANU items; 4 markdown-read items (Melbourne ×3, UTS) to Read again as HTML |
| Superseded by a newer read | 21 matrix items, closed today |
| Duplicate or stale | none |

Nothing was approved by SQL or by bulk, and reader completeness was never treated as admission.

**The exact remaining human decisions (Platform Admin):**
1. **Layer 4:**
   - BH126 `cf71cca1`;
   - the 4 RMIT change items;
   - the 33 complete matrix items and 48 Monash course items;
   - the 3 notes.
2. **Read again in the workspace (13 clicks):** the 9 partial ANU items, plus Melbourne ×3 and UTS (now fetched as HTML).
3. **The OpenRouter top-up or spend decision** for the remaining 4,926 courses (about US$45; A3). Then each batch is Preview next batch, then Read next batch.
4. **Course reading in New Zealand:** whether to add an identity proof rule for entry requirements there.
5. **Branch deletion** (A10).

## A7. Live totals and what reaches the website and Zoho

| Measure | Now (11:45 AEDT) | At 09:50 |
|---|---|---|
| Provider matrix rows active | 343 (RMIT) | 343 |
| Proposed (waiting in Layer 4) | 1,786 (26 providers) | 776 (23) |
| Quarantined | 20 | 20 |
| Superseded | 340 | 171 |
| Course rows proposed | 200 (49 courses) | 3 |
| Course rows active | 0 | 0 |
| Sources | 102 (0 never read) | 102 |
| Held or failed sources | 15 | 22 |
| AI spend: matrix reads / course reads | US$1.44 / US$0.46 | US$0.98 / US$0.007 |
| OpenRouter balance | US$7.37 (floor US$5) | US$8.04 |

- **Website and Zoho:** `website_v2_provider` for RMIT returns 343 `entry_matrix` rows, and 33 for India; `website_v2_course('0100714','IN')` returns rule 5, contact the provider.
- **Nothing proposed reaches either consumer.** The consumer API is unchanged since #720 (G3), and the developer pack (issue 5) needs no reissue because no new data has been admitted.

## A8. Provider-by-provider coverage of the plan

| Outcome | Providers |
|---|---|
| **Admitted (reaches the website)** | RMIT (343 rows; 37 changed rows await their governed decision) |
| **Awaiting review: complete read** | Adelaide, Ara, AUT, ANU (partly), Curtin, Flinders, Lincoln, Manukau, Unitec, Massey, NMIT, SIT, Swinburne, Otago, Waikato, Victoria University, Wintec, Western Sydney (confirm before approving), Whitireia/WelTec, Monash (course level, 48 courses) |
| **Awaiting review: held for named reasons** | Federation, Wollongong, Otago Polytechnic, UWA |
| **Awaiting a re-read first** | Melbourne (markdown copy), UTS (markdown copy), ANU (9 early pages) |
| **Fail-closed PDF holds (unchanged)** | UQ, UNSW, Sydney, Auckland ×2. Each has its named column-fidelity reason; no structure-driven correction proves their cells yet |
| **External source constraints (not coverage)** | Macquarie ×3 (HTTP 403 to a direct read); ANU listing pages 2–4 (robots.txt) |
| **Rendered, no table (note in Layer 4)** | Griffith, Newcastle, Victoria University of Wellington |
| **Genuine no-publication outcomes (contact the provider)** | QUT and Monash (no matrix: course pages only, now read at course level), Canterbury (checker app), EIT, NorthTec (course pages or prospectus only), UCOL (site refused), Toi Ohomai (English-only extract) |

## A9. Full-suite, dry-run, md5, deployment and release evidence

| PR | Merge | What | Migration md5 = file | Suite | Deploy |
|---|---|---|---|---|---|
| #734 | `60d2be1b` | v2.15.364 | `7ae33c61`, `ac325995` | 1,139 passed, 0 failed, 0 skipped | Deploy, Release History, Deployed UAT, Release Currentness and Frontend Build all succeeded |
| #735 | `3b98257a` | programme batch | `02a434be` | 1,141 passed, 0 failed, 0 skipped | Deploy, Deployed UAT and Frontend Build succeeded |
| #736 | `869a4953` | v2.15.365 pill and cost width; aer-tour | — | 1,142 passed, 0 failed, 0 skipped | Release Currentness, Release History, Deployed UAT and Frontend Build all succeeded |

- Each change had its rolled-back live dry run, its live md5 check before edits, change control written to all five files before merge (verified by a fresh clone), and the register regenerated.

## A10. Branch cleanup

- **Checked:** all 19 merged `cf247-aer-*` and `cf247-track-c-step-b-*` branches were compared with their PR's merge commit, and none has a file that did not land.
- **Deletion was attempted once** (`cf247-aer-workspace-uat`) by git push and by the API. Both were refused by this session's proxy ("Write access to this GitHub API path is not permitted"). That is recorded once and not retried.
- **For the Platform Admin to delete:**
  - the 19 branches;
  - `cf247-aer-programme-continue`, `cf247-aer-programme-batch` and `cf247-aer-visual-tour` (all merged; verify-landed check as above).
- **`cf247-zoho-dryrun`** was fast-forwarded to `main` and is kept as the designated scratch branch.

---

# Parts 1 to 6 — report as at 09:50 AEDT (kept as written)

## 1. AER operations workspace (mandate 29 Oct 08:06)

### 1.1 Navigation
**Catalogue › Entry requirements** (`/#entry-requirements`) sits in the menu between Scholarships and Rankings & statistics. It has four tabs:

| Tab | Address | Who |
|---|---|---|
| Provider entry matrix | `/#entry-requirements` | All roles read. Curator and above edit, add, withdraw, quarantine and restore |
| Course entry requirements | `/#entry-requirements?tab=course` | As above |
| Sources, reads and holds | `/#entry-requirements?tab=sources` | All read. Platform Admin can use Read again |
| Resolution inspection | `/#entry-requirements?tab=resolve` | All roles |

The Provider drawer and Course detail sections stay read-only. Each has "Open in Entry requirements" (and, on a course, "Inspect resolution") leading into the workspace, so there is one editing implementation (W2). Layer 4 stays the only approval route for AI rows; a waiting row links to its Layer 4 item and cannot be edited (W3).

### 1.2 Operator capabilities delivered

| Area | Delivered |
|---|---|
| **Summary** | Six tiles over the selected provider (or all):<ul><li>Active (reaches the website);</li><li>Waiting in Layer 4;</li><li>Quarantined;</li><li>Withdrawn or superseded;</li><li>Sources held, with sources total and reading;</li><li>Courses with requirements, with active course rows and courses waiting.</li></ul>Every tile carries words as well as colour (token colours only). |
| **Pills** | Active (success), Waiting in Layer 4 (info), Quarantined (danger), Withdrawn or Superseded (neutral), Reading (info), Held (warning), Fetch failed (danger), Not read (neutral). All carry text. |
| **Matrix filters** | Provider, country, study level (mapped or as published), status, kind, band, edition, intake year, read state, and text on qualification, quote and level. All are combined on the server, shown as chips, with Clear filters. |
| **Course filters** | Provider, course title or code, kind, for (audience), status, band, as-at from and to, and text. |
| **Tables** | The shared catalogue `DataTable`: fluid widths that can be resized and are saved per browser, sticky first column, sorting on the server (whitelisted keys), 50 a page (server cap 100), and a Columns menu (show or hide, saved per browser). Loading, empty, error and permission states are handled. The phone width keeps the page from scrolling sideways (s153 `@responsive`). |
| **Drawer** | <ul><li>Status and version pills;</li><li>provider, course, country and level, published and mapped;</li><li>qualification, band, minimum, value, scale and conditions;</li><li>edition, intake year, as-at and valid-to;</li><li>the **full quote**, the source URL and **Open the stored copy** (Evidence);</li><li>the reading run (model, worker, page basis, cost) and **Open in Layer 4**;</li><li>created and updated;</li><li>**History** of every change by a person: when, who, what, before, after and why.</li></ul> |
| **Edit in list** | Curator and above, on active or quarantined rows. A reason is required once per session and sent with each save. One cell at a time: Enter or leaving the cell saves, Esc cancels, one save in flight, a tick on success, the error under the row.<ul><li>Matrix fields: qualification, level as published, mapped level, band, minimum, value, scale, edition, intake year, as-at.</li><li>Course fields: requirement, minimum, value, scale, course score, printed basis, band, as-at.</li><li>Conditions are edited in the drawer as parts (best of N, subject minimums, alternative routes), never as raw JSON.</li></ul> |
| **Add requirement** | Matrix or course, from the provider's own source and **its stored copy** (the copy must be of the same address). The row is active at once with provenance `manual` and audited like an edit. |
| **Lifecycle** | Withdraw (`inactive`, with reason and valid-to), Quarantine (`unverified`) and Restore. Restore applies only to a row this workspace withdrew or quarantined; a row never admitted is decided in Layer 4. There is no delete and no bulk action. |
| **Sources, reads and holds** | <ul><li>Source and type (web page, PDF, rendered page);</li><li>fetch state, stored copy (date and hash, opens Evidence);</li><li>latest read pill and tries;</li><li>rows and rows not kept, and the hold, error or reasons rows were not kept;</li><li>cost, Layer 4 item, last read and next refresh.</li></ul>**Read again** (Platform Admin, one source, a reason) goes through `admin_entry_matrix_reread`, or re-queues a failed read. It is refused when the source is out of scope, AI is stopped, a read is waiting, or the source is held as unreadable. |
| **Resolution inspection** | For a course and a country of prior education:<ul><li>the outcome pill and the rule used;</li><li>a five-row table (what each rule looks for, the active rows found, Used / Did not apply and why / Not reached);</li><li>the rows returned with their quotes;</li><li>what the website does not use (waiting, quarantined, course rows waiting).</li></ul>It calls the live resolver unchanged. |

### 1.3 Controls (server: `public.admin_aer`, migration `20261029010000`)

- **Roles:** reads need any assigned role. Writes need Curator (rank 3) or above, as for Scholarships › Edit in list. Re-reads need Platform Admin. Every check is on the server.
- **Reason and concurrency:** every write needs a reason of at least 5 characters and the row's `updated_at` as read. A stale value is refused with "changed by someone else since you opened it; reload" (40001). Edits never silently overwrite.
- **Source support:** a band, a minimum's number, a value and a course score must be printed in the row's quote. A value needs a scale other than `none`; a course score needs its printed basis. The quote, source URL, stored copy and provenance are never editable.
- **Identity and statuses:** an active identity collision (the `row_hash` unique index) is refused in plain words. No status vocabulary was added.
- **Audit:** one `pipeline.manual_edit_log` entry per changed field (entity `entry_matrix` or `course_entry`, before, after, reason, actor, time). A matrix row's `version` rises with each change.
- **Consumer API:** unchanged (G3). Active rows edited by a person reach the course `entry` and provider `entry_matrix` payloads through the existing functions; nothing else does.

### 1.4 Example governed edit and audit record

The rolled-back live dry run ran as the Curator UAT user (`uat2`), 29 Oct. It changed an active RMIT India row's as-at from 26/10 to 27/10, reason "dry run: as-at correction", and returned:

```
edit: {changed: 1, as_at: "2026-10-27", version: 2,
       log: [{f: "as_at", b: "2026-10-26", a: "2026-10-27", reason: "dry run: as-at correction"}]}
stale:    "this row was changed by someone else since you opened it; reload and try again"
band:     "the band "99%" is not printed in the row's quote"
scale:    "a numeric value needs its scale (percentage, points, GPA, ...)"
reason:   "give a reason (kept in the history)"
proposed: "a proposed row is decided in Layer 4, not edited here"
restore of a proposed row: "only a row withdrawn or quarantined here can be restored; a row never admitted is decided in Layer 4"
withdraw → consumer India rows 33 → 32; restore → 33; history: restore, withdraw, edit
add (matrix, by hand) → active, version 1; the same row again → "another active row already has this provider, country, level, band and qualification"
wrong stored copy → refused; minimum not in the quote → refused; conditions as parts → version 2; unknown condition key → refused
course row: add → edit → quarantine → restore; a course score without its basis → refused
re-read: Curator refused; held PDF (Auckland) refused; a failed VU read re-queued (Platform Admin)
no role → "assigned StudySearch role required"
```

All of it was rolled back. **No live row has been edited through the workspace yet.** The live edit, with its history, is the `@live-acting` test of s154; it runs only when the live-acting switch is on.

The dry run also caught a real fault before merge: a variable clash in `security.aer_conditions_v1`. It was fixed, and s152 guards it.

### 1.5 Visual evidence

The screenshots below show the real UI build with the local mock harness (`tests/uat/support/admin-mock.mjs` plus the s153 fixtures), not live data. The red "newer version" banner is a mock artefact.

- `assets/2026-10-29-aer-workspace/matrix.png`: summary, filters, Columns and the list.
- `assets/2026-10-29-aer-workspace/drawer.png`: quote, stored copy, Layer 4 and history.
- `assets/2026-10-29-aer-workspace/edit.png`: Edit in list with the session reason.
- `assets/2026-10-29-aer-workspace/sources.png`: sources, holds and Read again.
- `assets/2026-10-29-aer-workspace/resolve.png`: BH126 for India, step 5 used and why rules 1 to 4 did not apply.

**Live evidence:**
- **Read checks (live, as Curator):** summary 75 ms; RMIT India active 33 rows in 60 ms; proposed 776 (100 a page) in 72 ms; held sources 15 in 44 ms.
- **Deployed acceptance s154** opens the live workspace and checks:
  - the summary and combined filters (India and RMIT);
  - the Columns menu and the drawer;
  - Sources and Resolution (0100714, India: five rules, "Used");
  - every list read bounded, with no console or server error.

  It ran on the deploy after #733 and succeeded (§6).

### 1.6 Tests

| Spec | Guards | Kind |
|---|---|---|
| s152 `aer-workspace-server-contract` | RPC roles, bounds, whitelisted sort, writes, source support, concurrency, history, lifecycle, re-read, resolver and consumer untouched, the conditions fix | source contract (6) |
| s153 `aer-workspace-ui-contract` | menu, four views, one editing route, pills with words; mocked browser: summary, combined filters, server sort, Columns, drawer and history, Edit in list (reason first, then reason and `updated_at` sent), band refusal shown, a proposed row not editable, withdraw; course, sources, Read again (one source, never on a held PDF) and resolution; Viewer has no controls; phone width; deployed acceptance wired | contract and browser (6) |
| s154 `aer-workspace-deployed` | live workspace acceptance (read-only); live edit and history put back (`@live-acting`) | deployed |

- Updated with the same guards: s81 (menu now 20 pages), `ui-standard` (the one table component now in `src/DataTable.jsx`), m245 (release strings).
- Register regenerated (`48356f2b`).
- **Local suite before each merge:**
  - #732: 1,129 passed, 0 failed, 0 skipped;
  - #733: 1,130 passed, 0 failed, 0 skipped.

---

## 2. Implementation status against the plan

### 2.1 Step A (HTML) and its residue
- **Waves:**
  - Wave H: 58 sources, scope 29 (#721);
  - Wave J: 4 sources, scope 33 (#724).
  - Sources are seeded `manual` and count-guarded. RMIT stays outside matrix reading scope.
- **Reader corrections, all structure-driven, with gates unchanged:**
  - answer length and slice size as settings (v0.49.2, #722);
  - numeric tables named by column header (v0.50.1, #725; ANU, UWA);
  - Firecrawl-fallback pages kept as their own HTML, not markdown (v0.50.2, #729). AUT went from 0 rows to 61 proposed after its refetch (#730);
  - no-answer reasons named (v0.50.2);
  - reads closed when stopped on their last try (#728).
- **BH126 decisions stand:**
  - no ATAR 75 → 75% band;
  - the exact VCE 65% sentence may support the 65% band for BH126 only;
  - exclude the 2026 ATAR.
- **Residue:** item `cf71cca1` (BH126), 4 RMIT change items (37 rows), the 20 quarantined RMIT rows and UTS's pending item all remain with the Platform Admin in Layer 4 (section 4).

### 2.2 Step B (PDF)
- **Route:** worker v0.50.0 (#723), switched on in its own change (#724). Fixtures were added, with sha256 values in the README.
- **Read (rows proposed):**

  | Provider | Proposed rows |
  |---|---|
  | Adelaide | 27 |
  | Curtin | 33 |
  | Federation | 11 of 55 table rows |
  | Western Sydney | 13 of 78 read |

- **Held (fail closed, with the page and text):**
  - UQ: page 3 has columns of text with no drawn rules;
  - UNSW: "ACT" is in a column without row rules;
  - Sydney: "38" lies outside the columns;
  - Auckland A–I and J–Z: merged cells cross a column edge.
- **Refused:** Macquarie (3 PDFs, HTTP 403 to a direct read, `blocked_pdf`).
- **Failed:** Victoria University. The reply was cut by the call time-out while a 20,000-character slice streamed ("no choices; slice 2 of 2").
- **Worker v0.51.0 (#731), live:**
  - a table of 5 or more columns is given one cell per line with its row's first cell (the WSU shape);
  - a page's slices can be read several at once;
  - a cut reply is named.

  The **settings that switch the parallel slices on, and the WSU / VU / Manukau / Wollongong re-reads, are parked** (section 4).

### 2.3 Step C (rendered)
- Worker v0.50.0. `entry.render_hosts` covers VUW, Whitireia/WelTec, Newcastle and Griffith; robots.txt is respected and the Firecrawl budget check applies.
- **Results:**
  - Whitireia/WelTec: 44 rows proposed;
  - Newcastle: rendered, 0 rows (contact provider);
  - Griffith: rendered after its refetch (#730), 0 rows (contact provider);
  - VUW: rendered, 0 rows (4 not kept, `unknown_country`).
- **Not built:** the plan's "Layer 4 note" for a rendered page with no requirements table. The outcome is visible in Sources, reads and holds as a read with 0 rows; it is not raised as a Layer 4 note.

### 2.4 Course-level (B1)
- Built on the Enrich fields lane (#717–#719): AU stored page only; strong identity; quote on page; a band only when printed; no English test rows.
- **Read so far:** one course, BH126 (3 rows proposed, item `cf71cca1` pending).
- Widening to more courses is a Platform Admin decision on volume: one Layer 4 item per course.
- The workspace's Course entry requirements tab and the Course detail section show and manage these rows.

### 2.5 Resolver
`security.entry_resolve_v1` is live and unchanged. It applies five rules over active rows only. BH126 for India gives step 5, "contact the provider", because the course prints no band to enter RMIT's India band table. The Resolution inspection tab shows why.

### 2.6 Consumer API and `edu_country`
- **Unchanged since #720** (G3; `consumer-api-guard` succeeding daily).
- **Live checks:**
  - `website_v2_provider('provider:cricos:00122a')` returns 343 `entry_matrix` rows; with `IN`, 33 rows, all `IN`;
  - `website_v2_course('0100714','IN')` returns step 5, `contact_provider`;
  - providers with proposed rows only (Flinders, Lincoln, UTS, ANU, and others) return 0 `entry_matrix` rows;
  - a manual active row added in the rolled-back dry run reached the payload, and a withdrawn row left it.
- **Website display:** not claimed. It is the website team's work.

### 2.7 Developer pack
Issue 5 (`35c5573c`) contains:
- section 7.9 (fields, the five rules, a worked example from admitted rows, notes for Wix, Zoho and others);
- refreshed measured figures;
- acceptance tests 20–22;
- an issue 5 line in section 13.

There is no new API change since issue 5, so it is not reissued.

---

## 3. Provider-by-provider coverage (the plan's 40, plus Federation from the pilot)

"Proposed" means rows waiting in Layer 4. Only "Admitted" rows reach the website.

| Provider | Route | Sources | Outcome now | Rows | Note |
|---|---|---|---|---|---|
| RMIT | HTML per country | 36 | **Admitted** | 343 active, 37 proposed (4 change items), 20 quarantined | Outside matrix reading scope. 7 sources held for named reasons (not a country table, no printed scale, incomplete) |
| Flinders | HTML | 1 | Proposed | 13 | — |
| UOW | HTML | 1 | Held | 0 | Stopped after 3 tries (time budget); needs the parked slice settings |
| UWA | HTML | 1 | Proposed | 9 | 68 not kept before v0.50.1; a re-read would now name the numbers |
| Melbourne | HTML per qualification | 4 | Proposed | 33 (3 items) | IB page: 0 rows after refetch |
| ANU | HTML per qualification | 27 | Proposed | 156 (24 items) | Listing pages 2–4 disallowed by robots.txt; sources are partial |
| Monash | Course pages | 0 | Not seeded | — | Course-page route (B1 widening, Platform Admin decision) |
| UNSW | PDF | 1 | Held | 0 | "ACT" in a column without row rules |
| Sydney | PDF | 1 | Held | 0 | "38" outside the columns |
| UQ | PDF | 1 | Held | 0 | Page 3: text columns with no drawn rules |
| Adelaide | PDF | 1 | Proposed | 27 | — |
| UTS | HTML (stored) | 1 | Proposed | 40 | Earlier UTS item also pending |
| Curtin | PDF | 1 | Proposed | 33 | — |
| Western Sydney | PDF, plus HTML page | 2 | Proposed | 13 | 65 of 78 not kept before v0.51.0; re-read after the parked settings |
| Victoria University | PDF | 1 | Failed | 0 | Reply cut on a 20,000-character slice; needs the parked settings. The second VU provider record (`0f5373c8`) has no source |
| Macquarie | PDF | 3 | Refused | 0 | HTTP 403 to a direct read (`blocked_pdf`) |
| Newcastle | Rendered | 1 | Read, no rows | 0 | Contact provider |
| Swinburne | HTML (India page) | 1 | Proposed | 7 | Only the India page publishes a minimum |
| Griffith | Rendered | 1 | Read, no rows | 0 | Contact provider |
| QUT | — | 0 | Not seeded | — | No international matrix: contact provider |
| Federation (pilot) | PDF | 1 | Proposed | 11 | 11 of 55 table rows read; a re-read with smaller slices is advised before approval |
| AUT | HTML (Firecrawl fallback) | 1 | Proposed | 61 | 0 before v0.50.2; refetched as HTML (#730) |
| Waikato | HTML | 1 | Proposed | 35 | — |
| Massey | HTML | 1 | Proposed | 38 | — |
| Otago | HTML (Firecrawl fallback) | 1 | Proposed | 1 | Refetched as HTML (#730) |
| Lincoln | HTML (markdown copy) | 1 | Proposed | 63 | 17 not kept; refetch as HTML is parked |
| Unitec | HTML | 1 | Proposed | 17 | — |
| MIT (Manukau) | HTML | 1 | Failed | 0 | Reply cut ("no choices; slice 2 of 2"); needs the parked settings |
| Otago Polytechnic | HTML (markdown copy) | 1 | Proposed | 18 | 27 not kept; refetch as HTML is parked |
| Wintec | HTML (markdown copy) | 1 | Proposed | 13 | 45 not kept; refetch as HTML is parked |
| Ara | HTML | 1 | Proposed | 11 | — |
| NMIT | HTML (markdown copy) | 1 | Proposed | 42 | 10 not kept; refetch as HTML is parked |
| SIT | HTML | 1 | Proposed | 54 | — |
| Auckland | PDF A–I, J–Z | 2 | Held | 0 | Merged cells cross a column edge |
| Canterbury | — | 0 | Not seeded | — | Checker app: contact provider |
| VUW | Rendered | 1 | Read, no rows | 0 | 4 not kept (`unknown_country`) |
| Whitireia and WelTec | Rendered | 1 | Proposed | 44 | — |
| EIT | — | 0 | Not seeded | — | Course pages or prospectus only |
| NorthTec | — | 0 | Not seeded | — | Course pages or prospectus only |
| UCOL | — | 0 | Not seeded | — | Site refused; contact provider |
| Toi Ohomai | — | 0 | Not seeded | — | English-only extract; contact provider |

**Totals:**
- Sources: 102 sources for 34 providers; reading scope is 33.
- Rows: 343 active (RMIT), 776 proposed (23 providers), 20 quarantined, 171 superseded.
- Layer 4: 52 entry items pending (47 first reads, 4 RMIT change items, 1 course).
- Course rows: 3 proposed (BH126).
- AI spend: US$0.98 on entry-matrix reads to date, of which US$0.65 is this programme's providers.

---

## 4. Platform Admin actions (consolidated)

1. **Layer 4 decisions:**
   - BH126 `cf71cca1`: Approve except `dab50fa7` (the 2026 ATAR row), then Read from the stored page once, per the 28 Oct decision.
   - The 4 RMIT change items (37 rows).
   - UTS's pending item.
   - The 47 first-read items of the 22 newly read providers: Flinders, UWA, Melbourne ×3, ANU ×24, Adelaide, UTS, Curtin, Western Sydney, Federation, Swinburne, AUT, Waikato, Massey, Otago, Lincoln, Unitec, Otago Polytechnic, Wintec, Ara, NMIT, SIT, Whitireia/WelTec.
   - **Advised before approving:** Federation (11 of 55 rows) and Western Sydney (13 of 78) are partial reads. Re-read them first (item 3).
2. **Parked migration (your go-ahead needed).** Its rolled-back dry run was cancelled at the approval prompt, as was the earlier SQL re-read. I have not retried either. It would:
   - switch on slices read at once (`entry.matrix_slice_concurrency` 6, a new setting);
   - set `entry.matrix_slice_chars` to 8,000;
   - let the workspace's **Read again** fetch a markdown-stored source again as HTML.

   Until then:
   - Victoria University, Manukau, Wollongong and the wide Western Sydney table will not fit a read;
   - Wintec, Otago Polytechnic, Lincoln and NMIT can only be re-read from their markdown copies.
3. **Read again in the workspace, after item 2:** Western Sydney PDF, UWA, Federation, Victoria University, Manukau, Wollongong; then Wintec, Otago Polytechnic, Lincoln and NMIT (refetched as HTML). Each is one click with a reason, and its rows go to Layer 4.
4. **Course-level widening (B1):** decide the volume (one Layer 4 item per course) and the providers.
5. **Repository housekeeping:** delete the merged branches; the proxy refuses deletion. They are:
   - `cf247-aer-wave-h-sources`, `cf247-aer-reader-limits`, `cf247-aer-steps-b-c`, `cf247-aer-switch-on-b-c`, `cf247-aer-numeric-tables`, `cf247-aer-anu-reread`, `cf247-aer-admin-sources`, `cf247-aer-stale-lease`, `cf247-aer-no-answer-reason`, `cf247-aer-html-reread`, `cf247-aer-wide-and-parallel`, `cf247-aer-workspace`, `cf247-aer-workspace-uat`, `cf247-aer-pr-a-structure`, `cf247-aer-v11-schema`;
   - `cf247-track-c-step-b-consumer-api`, `cf247-track-c-step-b-full-page`, `cf247-track-c-step-b-slice`, `cf247-track-c-step-b-slice-reread`;
   - `cf247-zoho-dryrun`.
6. **Optional:** turn on the live-acting switch for one deployed run, so s154 makes and puts back a live edit and checks its history.

## 5. External dependencies

- **Website team:** rendering `entry` and `entry_matrix` on the website (developer pack issue 5). Not live.
- **Customer spreadsheet:** unavailable (not requested again). Acceptance is source-anchored.
- **Providers:**
  - Macquarie: PDFs refuse a direct read (403).
  - ANU: listing pages disallowed by robots.txt.
  - Canterbury: checker app.
  - QUT, EIT, NorthTec, UCOL, Toi Ohomai: no matrix published.
- **Firecrawl:** the daily budget governs refetches and rendered reads.

## 6. Releases, md5 and deploy evidence

| PR | Merge | What | Migration | History md5 = file | Deploy |
|---|---|---|---|---|---|
| #721 | `65e01e2e` | Wave H sources, scope 29 | `20261028006000` | `03296de1` | succeeded |
| #722 | `f6ed4481` | reader limits, worker v0.49.2 | `20261029001000` | `dd9dd556` | succeeded |
| #723 | `ed627894` | Steps B and C, worker v0.50.0 | `20261029002000` | `438c7757` | succeeded |
| #724 | `9cca6401` | switch-on, Wave J | `20261029003000` | `9ccb7631` | succeeded |
| #725 | `91b1298f` | numeric tables, worker v0.50.1 | — | — | succeeded |
| #726 | `b2c0659f` | ANU re-read, time-budget try | `20261029004000` | `1acb4866` | succeeded |
| #727 | `d9f5c1bb` | v2.15.362 Sources and reads | `20261029005000` | `c2df15a5` | succeeded |
| #728 | `94d538fc` | exhausted lease closed | `20261029006000` | `644a3968` | succeeded |
| #729 | `58ffd006` | worker v0.50.2 | — | — | succeeded (bundle v221) |
| #730 | `dc153122` | HTML refetch, no-answer re-read | `20261029007000` | `de2b8416` | succeeded |
| #731 | `40e69cae` | worker v0.51.0 | — | — | succeeded (bundle v222) |
| #732 | `145626bb` | **v2.15.363 AER operations workspace** | `20261029010000` | `c925e283` | succeeded: Deploy, Deployed UAT, Release History, Release Currentness, Frontend Build |
| #733 | `7e58aac8` | s154 runs on deploy | — | — | succeeded: Deployed UAT (targeted, desktop), Frontend Build |

**Process for every change:**
- the decision was lodged before code;
- the full local suite ran before merge with 0 failed and 0 skipped;
- the live md5 was checked before each edit of an existing function;
- rolled-back dry runs were run;
- change control was written to all five files and verified by a fresh clone;
- deployed results were verified after merge.

**#733 deployed run (29 Oct 2026, 09:37 AEDT):**
- Run `40781257332` "Deployed UAT (targeted)" succeeded, and the commit status `coursefinder/deployed-uat/targeted/chromium-desktop` is success.
- The live API log shows eleven `admin_aer` calls from the run's headless Chrome between 22:37:07 and 22:37:15 UTC, every one HTTP 200. These were the workspace's summary, options, list, row, sources, course search and resolve reads.
- `pipeline.manual_edit_log` has no `entry_matrix` or `course_entry` entries. This confirms that the `@live-acting` edit test was held: the switch is off by default, and no live row was changed.
- What cannot be shown: the job log and the evidence download are refused by GitHub's storage (403 through this session's proxy). The per-test lines are therefore not quoted here; the workflow and commit-status conclusions are.
