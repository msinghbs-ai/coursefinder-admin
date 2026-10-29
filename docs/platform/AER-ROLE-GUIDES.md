# Academic entry requirements (AER) — role guides

**Version:** 1.0, 29 Oct 2026 (Pilot release v2.15.368 on `main`, Pilot commit `fabda0cb`).
**For:** everyone who reads, corrects, reviews, re-reads or consumes academic entry requirement data.
**Status:** guidance. It adds no rule. Where it and a decision record disagree, the decision record wins.

## How to use this guide

Each role section is a set of tasks: what you are trying to do, where you do it, what evidence you need, what record it leaves, and who you go to when it does not fit. Find your role, then the task.

This guide does not repeat what is already written elsewhere. It points to it:

| You need | Read |
|---|---|
| What each screen, column and button is | `UI-CATALOGUE.md` §2 "Entry requirements — `entry`", §3 "Layer 4 Review — `layer4`", §3 "Layer 2 Discovery & reading › Operations › Governed actions", §4 "Evidence — `evidence`" |
| The in-app step lists (kept current every release) | Guides › Operator SOP (`docs/sops/operator-sop.md`, "An entry requirement that is wrong, missing or no longer published") and Guides › Platform Admin SOP (`docs/sops/admin-sop.md`, the six entry-requirement triggers and the two governed-action / break-glass triggers). Both are generated from Pilot `src/guide/sops.js`. Guides › Platform guide, page "Entry requirements" (Pilot `src/guide/platformGuide.js`) |
| The decisions behind the workspace | `AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md` (W1–W27) |
| How the data model, readers and resolver work | `AER-TECHNICAL-DESIGN.md` (§4 data model, §5 resolver, §8 consumer feed, §9 settings) |
| What is waiting in Layer 4 now | `ui-audit/2026-10-29-aer-layer4-manifest.md` |
| Programme status and decisions waiting | `ui-audit/2026-10-29-aer-programme-consolidated-report.md` (Part B, B9) |
| The website contract | `../integrations/developer-pack/StudySearch-Website-API-v2-Developer-Guide.md` §7.9 |
| How agents and people change the platform | `AGENT-OPERATING-MODEL.md`, Pilot `CLAUDE.md` (G1–G4) |

Screens are named as the app names them. Where no screenshot is available, the guide gives the element's attribute from the code (for example `data-aer-edit-toggle`) so it can be found in the page or a test.

---

## 1. Shared ideas every role needs

### 1.1 The screens

| Screen (menu) | Who can open it | What it is for |
|---|---|---|
| Catalogue › Entry requirements (`/entry-requirements`; `src/AerWorkspace.jsx`) | Every assigned role (rank 1 and above) | The one place where entry requirement rows are filtered, inspected, corrected, added, withdrawn, quarantined, restored and re-read (W1, W2) |
| — tab **Provider entry matrix** (`data-aer-view="matrix"`) | rank 1 | What each provider publishes for a student's country of prior education |
| — tab **Course entry requirements** (`data-aer-view="course"`), with the **Course-level reading** panel (`data-aer-programme`) | rank 1 (batch controls: Platform Admin) | What a course's own page asks for; the bounded course-reading programme |
| — tab **Sources, reads and holds** (`data-aer-view="sources"`) | rank 1 (Read again: Platform Admin) | Every official page or PDF the reader uses, its stored copy, its latest read and its holds |
| — tab **Resolution inspection** (`data-aer-view="resolve"`) | rank 1 | Which of the five rules answers a course for a country, and why earlier rules did not |
| Catalogue › Providers › provider drawer › Academic entry requirements (`src/EntryRequirements.jsx`, `data-entry-matrix`) | rank 1 | Read only. "Open in Entry requirements" (`data-entry-workspace-link`) goes to the workspace filtered to the provider |
| Catalogue › Courses › Course detail › Academic entry requirements (`data-course-entry`) | rank 1 (Read from the stored page: Platform Admin) | Read only, plus the country selector and the resolved answer. "Open in Entry requirements" and "Inspect resolution" go to the workspace |
| Course detail › Evidence and history overlay (`src/CourseAudit.jsx`, `data-course-evidence`) | rank 1 | One timeline for the course, including entry requirement rows (filter "Entry requirements", `data-ca-area="aer"`) |
| Layer 4 Review › Inbox (`layer4`, tab `inbox`) | Curator and above (rank 3) | Where AI-read rows are approved or refused. The only admission route (W3) |
| Evidence (`evidence`) | Curator and above (rank 3) | Opens a stored copy ("Open the stored copy" in the row drawer) |
| Layer 2/3 Build & enrich › Operations › Governed actions (`src/GovernedActions.jsx`) | Platform Admin | Approved operations with preview, rolled-back dry run and a run-once guard (Decision 268) |

### 1.2 Row statuses and pills

Every pill shows words, never colour alone (W16, `ROW_PILL` in `AerWorkspace.jsx`).

| Stored status | Pill text | Reaches the website and Zoho? | Who moves it |
|---|---|---|---|
| `active` | Active | **Yes** | Layer 4 approval; a person adding a row; Restore |
| `proposed` | Waiting in Layer 4 (with a Layer 4 link) | No | Only a Layer 4 decision |
| `unverified` | Quarantined | No | Quarantine in the workspace |
| `inactive` | Withdrawn | No | Withdraw in the workspace; a Layer 4 refusal (its reason starts "quarantined (…)" or "excluded by the reviewer") |
| `superseded` | Superseded | No | A newer approved read of the same source (W15) |

"by hand" next to a status (drawer: "Added by hand") means the row was added in the workspace (provenance `manual`).

**Proposed versus active.** A proposed row is an AI reading that no person has approved. It never reaches a consumer, cannot be edited and cannot be activated in the workspace. Only Layer 4 can admit it. An active row is the published fact the website receives.

### 1.3 Source read states

| Pill | Meaning |
|---|---|
| Read | Latest read finished |
| Reading | A read is queued or running |
| Held | The read is held (for example `held_unparsed`: unreadable until a reader change, or held as incomplete) |
| Fetch failed | The page or PDF could not be fetched |
| Not read | Never read |
| Rendered, no table: in Layer 4 | A rendered page kept no row; a Layer 4 note waits (W18) |
| No matrix published (confirmed) | That note was approved: the provider publishes no table there |

### 1.4 Scale, basis and completeness

- **Scale** (`percentage`, `points`, `aggregate`, `gpa`, `letter`, `rank`, `none`). A numeric value always needs a scale other than `none` (W7). `none` means the row carries no numeric scale.
- **Printed basis.** A course score is meaningless without the words printed with it, for example `75` with "2027 Guaranteed ATAR". A score without its basis is refused (W7).
- **Band.** A band (for example "65%") is only held where the source prints it. It is never worked out from a score.
- **Completeness of a read.** The Sources tab shows "Rows · not kept" and the reasons rows were not kept (for example `quote_not_on_page`, `grade_not_in_quote`, `value_without_scale`, `unknown_country`). A read with many rows not kept is incomplete. Completeness is information for the reviewer; it is never admission.

### 1.5 The five rules and their outcomes

The resolver (`security.entry_resolve_v1(course, country)`) answers "what applies to a student from this country for this course". The first rule that applies is used:

1. a rule the course page states for itself (`course_override`);
2. the provider's row for this course and country (`course_country_row`);
3. the course's printed band, looked up in the provider's band table for the country (`band_ladder`);
4. the provider's minimum for the country at the course's level (`provider_minimum`), including a published label that names several levels (W19);
5. otherwise, contact the provider (`contact_provider`).

Three outcomes:

| Outcome | Pill (Resolution inspection) | What it means |
|---|---|---|
| `minimum_published` | A minimum is published | At least one returned row carries a minimum on a scale |
| `case_by_case` | Considered case by case | Rows apply, but none states a minimum on a scale (`min_grade` empty or scale `none`) |
| `contact_provider` | Contact the provider | No active published row applies (rule 5). The `note` says why |

**Case by case is not contact the provider.** Case by case means the provider *has* published something for this qualification and says it decides individually. Contact the provider means nothing published applies. Never present either as "not eligible" or "eligible"; the platform looks requirements up, it never decides eligibility.

Rule 5 has four reasons, worded by the resolver: a band table exists but the course prints no band; the course's band has no row for this country and level; rows exist for the country but none at this level; nothing for the country.

---

## 2. Viewer (read only)

**Who:** any assigned role (rank 1 and above), for example a stakeholder, auditor or counsellor. Nothing here lets you change data.

### 2.1 Find a provider's or course's requirements

1. Open Catalogue › Entry requirements. The summary tiles (`data-aer-summary`) show Active, Waiting in Layer 4, Quarantined, Withdrawn or superseded, Sources held and Courses with requirements, for the provider filtered or for everything.
2. Choose the tab: **Provider entry matrix** for tables by country; **Course entry requirements** for what a course page asks for.
3. Filter with the filter bar (`data-aer-filters`). Every filter runs on the server. Status defaults to Active on the matrix tab; choose "Any status" to see the rest. Chips (`data-aer-chips`) show what is set; **Clear filters** (`data-aer-clear`) resets.
4. Sort by clicking a column header. Lists show 50 rows a page (`Pager`); the server never returns more than 100.
5. **Columns** (`data-aer-columns`) shows or hides columns. Your choice and your filters are remembered in this browser only.
6. Coming from a provider drawer or Course detail, "Open in Entry requirements" opens the tab already filtered.

### 2.2 Inspect one row

Click a row. The drawer (`data-aer-drawer`) shows:
- status and version pills, and the status reason;
- the requirement (provider, country, level as published and mapped, qualification, kind, band, minimum, scale, edition and intake year, as at, valid to);
- conditions (best of N, subject minimums, alternative routes);
- **Evidence**: the full quote (`data-aer-quote`), the source link and "Open the stored copy" with its capture time and hash;
- **Reading and review**: the model, worker, basis and cost, or "Added by hand", and the Layer 4 item;
- **History** (`data-aer-history`): every change by a person, with when, who, what, before, after and reason.

Note: "Open the stored copy" and "Open in Layer 4" go to screens that need Curator (rank 3). A Viewer sees the quote, source link and history but cannot open those two screens.

### 2.3 Check what a student from a country is shown

1. Open **Resolution inspection**, choose a course (title or code) and a country of prior education. India, Nepal and Singapore are listed first, then A to Z (W22).
2. Read the outcome pill and "Rule N: …". The steps table (`data-aer-steps`) shows each rule, the active rows it found, and "Used", "Did not apply: …" or "Not reached".
3. The line "Not used by the website" (`data-aer-not-used`) counts rows that exist but are not active (waiting in Layer 4, quarantined). These are not part of the answer.

The same answer appears on Course detail when you choose a country there. Changing the country only asks the resolver; it never starts an AI read (W19 extended).

This screen is an operator check of the live resolver. It is not a preview of the website's page and not an eligibility check.

### 2.4 Read holds and sources

On **Sources, reads and holds**, filter Read state = Held to see why a source gave no or few rows. The column "Hold, error or rows not kept" gives the reason in words.

### 2.5 History of one course

Course detail › Evidence and history opens one timeline. Choose "Entry requirements" to see only those events.

### 2.6 When to escalate

| You see | Tell |
|---|---|
| A value that does not match its quote or the provider's page | A Curator (they can correct it in the workspace) |
| A row Waiting in Layer 4 for a long time | A Curator or the Platform Admin (Layer 4 backlog) |
| A source Held or Fetch failed | The Platform Admin |
| A question about what the website shows | Check Resolution inspection first, then the website integration owner (section 6) |

---

## 3. Curator and AER operator

**Who:** Curator and above (rank 3+). The server checks the role on every write (`public.admin_aer`, W9).

**Your tools:** **Edit in list**, **Add requirement**, and the drawer's **Withdraw**, **Quarantine**, **Restore** and conditions **Edit**. Every write goes through `public.admin_aer`; nothing writes a table directly.

### 3.1 Correct an active or quarantined row (Edit in list)

1. Filter to the row. Open it and compare its quote with the stored copy (Evidence) and the provider's page.
2. Press **Edit in list** (`data-aer-edit-toggle`).
3. Type the **Reason for these changes** (`data-aer-reason`) first: at least 5 characters, for example "corrected from the provider's 2027 table". It is kept with every change you make in this session.
4. Click a cell (`data-aer-cell`), change it, press Enter or leave the cell to save; Esc cancels. One save at a time; a tick shows success; an error appears under the row (`data-aer-row-error`).
5. Press **Done editing**.

Editable fields (W4):
- matrix rows: qualification, level as published, mapped level, band, minimum, value, scale, edition, intake year, as at; conditions are edited as parts in the drawer;
- course rows: requirement, minimum, value, scale, course score, printed basis, band, as at.

Never editable: the quote, the source address, the stored copy and the provenance.

The server refuses, in plain words:
- a band, minimum, value or course score not printed in the quote;
- a value without a scale, or a course score without its printed basis;
- a change that would duplicate another active row (same provider, country, level, band and qualification): "correct that row instead";
- a proposed row: "a proposed row is decided in Layer 4, not edited here";
- a withdrawn or superseded row: "restore it first".

**Evidence needed:** the row's own quote must support the corrected value. If the quote itself is wrong or out of date, do not edit around it: Withdraw the row and Add a new one from the current source, or Quarantine it and escalate.
**Record:** one `pipeline.manual_edit_log` row per changed field (entity `entry_matrix` or `course_entry`, before, after, reason, actor, time); a matrix row's version rises. Shown in the drawer's History.

### 3.2 When someone else changed the row (optimistic concurrency)

Every save carries the row's last-updated time as you read it (W8). If someone else saved first, you see: "this row was changed by someone else since you opened it; reload and try again" (server code `40001`).

1. Do not retype your change straight away. Reload the list or reopen the drawer.
2. Read the History: who changed what, and why.
3. If their change already fixes it, stop. If not, make your change on the new values, with a reason that mentions theirs.
4. If you disagree with their change, do not overwrite it back and forth. Talk to them, or escalate to the Platform Admin.

### 3.3 Add a missing requirement

1. Press **Add requirement** (`data-aer-add`) on the matrix or course tab.
2. Fill in the provider (and the course for a course row or a course-minimum matrix row), country, kind, level, qualification or requirement, and the minimum with its scale, or the course score with its printed basis.
3. Paste the **exact quote** (up to 300 characters) and the **official source address**.
4. Choose the **stored copy of that address** (`aria-label="Stored copy"`). The list offers copies already held for the provider or address. If none is listed, the page has not been stored yet: stop and ask the Platform Admin; do not use another page's copy (the server refuses a copy of another address).
5. Give the as-at date and a reason, then **Add requirement** (`data-aer-add-submit`).

The row is **active at once** with provenance `manual` (W5) and reaches the website through the existing consumer functions. So only add what the provider's own source prints.
**Record:** one `manual_edit_log` row with action `add` and the whole row.

### 3.4 Withdraw, quarantine and restore

In the row drawer (`data-aer-lifecycle`), each with a reason:

| Action | When | Effect |
|---|---|---|
| **Withdraw** (`aer-withdraw`) | The provider no longer publishes it | Active → `inactive`; it stops reaching the website |
| **Quarantine** (`aer-quarantine`) | You doubt the evidence (wrong page, unclear quote) | Active → `unverified`; it stops reaching the website; it stays correctable |
| **Restore** (`aer-restore`) | A row you or another curator withdrew or quarantined here was right after all | Back to `active` |

Restore is refused for a row that was never admitted or was refused in Layer 4: those are decided in Layer 4. There is no delete and no bulk action (W6).
**Record:** one `manual_edit_log` row with action `withdraw`, `quarantine` or `restore`.

### 3.5 Case by case or contact the provider?

When a source prints a qualification **without a minimum** ("considered on a case-by-case basis", "completion of …"), record the qualification with the quote and no numeric minimum (scale `none`). The resolver then answers case by case for it.

When a source does **not mention** a qualification or country at all, add nothing. The resolver answers contact the provider. Never add a row to "fill a gap", and never copy a minimum from another level, country or provider.

### 3.6 Prohibited

- Approving or activating AI rows by editing them, adding a copy of them, or restoring them. A proposed row is admitted only in Layer 4 (W3).
- Writing to `catalogue.provider_entry_matrix` or `catalogue.course_entry_requirements` directly (SQL editor, scripts, other tools).
- Adding a row from an unofficial source, or with a stored copy of another address.
- Inferring a band, a level, international applicability or a minimum that is not printed.

### 3.7 Escalate

| Situation | To |
|---|---|
| The source has changed and needs reading again | Platform Admin (Read again, section 4.1) |
| A whole provider's table looks wrong | Platform Admin; quarantine only the rows you have checked |
| A conflict with another curator | The other curator, then the Platform Admin |
| A proposed row is wrong | The Layer 4 reviewer (section 5) |

---

## 4. Platform Admin

**Who:** rank 6. You have every Curator tool plus the governed re-read, the course-reading batches, governed actions and the release controls.

### 4.1 Read a source again

1. Sources, reads and holds: filter to the source and read its hold or error.
2. Press **Read again** (`data-po-action="aer-reread"`) and give a reason. It goes through `security.aer_reread_v1` (via `admin_aer('reread')`), one source at a time.
3. Two possible messages: "Asked. The read waits for the next run of the entry reader; its rows go to Layer 4." or, for a page stored as markdown, "Asked. The page is fetched again as HTML (the markdown copy stays as evidence) …" (W12a).

It is refused when the provider is outside the reading scope (`entry.providers`), AI reading is stopped (AI limits), a read is already waiting or running, the page is waiting to be fetched, the source is held as unreadable (`held_unparsed`; only a reader change under change control reads it again), the site's robots.txt disallows it, or the source has never been read.
**Record:** `pipeline.admin_control_events`; the new run is on the source row; its rows wait in Layer 4.

**Newest stored copy (W28, live 29 Oct 2026, PR #744).** A source may have more than one stored copy. Read again reads only the run on the source's current stored copy. Runs on older copies keep their history; their still-proposed rows and still-pending Layer 4 item are closed as superseded, and decided items are not touched. The one item left over from before W28 (Otago Polytechnic `f14ae480`, older copy) is for the Layer 4 reviewer to reject as stale; `81d14690` is the current item. Bulk re-reads through `admin_entry_matrix_reread` still re-run every copy (open question).

**One attempt.** A programme-approved re-read is one governed attempt. A source that has used its attempt (for example ANU `509c8f82`, Melbourne India State Board `290bd250`) is not read again without a new decision.

### 4.2 Source holds and reader failures

- A Held source with `held_unparsed` is a reader problem, not a data problem. It waits for a reader change under change control; Read again is not offered.
- A read with many rows not kept is classed in the Layer 4 manifest (for example "Held for judgement: large share not kept"). It is not approved as a batch.
- A deterministic failure (the same failure on every attempt, such as the three Monash course reads cut off at about 8,000 characters) is not retried. It becomes a decision (consolidated report B9 item 7).

### 4.3 Course-level reading batches and the US$5 floor

On Course entry requirements › **Course-level reading** (`data-aer-programme`):
1. Read the cost line (`data-aer-programme-cost`): cost a course (measured or estimate), OpenRouter balance and its floor, batch size, course reads waiting.
2. Choose a provider or "Next by priority", press **Preview next batch** (`data-aer-batch-preview`). The preview gives the course count and estimated cost, or a refusal.
3. Press **Read next batch** (`data-po-action="aer-batch"`) with a reason.

A batch is refused when: no course is left; an earlier course read is still waiting; AI reading is stopped; or the estimate would take the balance below the floor (`security.course_entry_batch_v1`). Batches are at most `entry.course_batch_size` (50) courses.
**Record:** `pipeline.admin_control_events`, one Enrich fields task in `pipeline.admin_jobs`; every course read goes to Layer 4.

**The floor is not changed to make room.** The floor (US$5, Models & services › Toolsets & limits) protects all AI work. When the margin is thin, pause rather than rely on it: on 29 Oct the function would have allowed a fifth batch with US$0.003 to spare, but measured batches had cost up to US$0.45, so reading paused and the spend went to the Platform Admin as a decision (consolidated report B9 item 1). A top-up or a floor change is a separate, recorded decision. **A top-up is not a spend decision either:** on 30 Oct the balance rose to about US$105 while no batch was approved, and no batch was started (decision paper `ui-audit/2026-10-30-platform-admin-decision-paper.md`, Part B).

### 4.4 Coordinating Layer 4 without bulk approval

- Use the manifest (`ui-audit/2026-10-29-aer-layer4-manifest.md`) as the work list; refresh it after each read.
- Approve each item from its evidence (section 5). A complete read is not an approval.
- **Do not use Layer 4 bulk decisions on AER items.** The generic bulk tool (`layer4_review_bulk_decide`, Pipeline Operator and above) cannot approve, but it can reject, ask for more evidence or send back a whole group, which would refuse every row in it. It has no AER-specific guard (verified live, 29 Oct 2026). See open question Q3.
- A decision already framed (for example the RMIT change items, "approve except" on BH126) is taken one item at a time, with the reason naming the decision.

### 4.5 SQL, migrations and deploys

The rules are in Pilot `CLAUDE.md` and `AGENT-OPERATING-MODEL.md`. In short, for AER:

| Step | Control |
|---|---|
| Routine operation | A governed action (Layer 2/3 › Operations › Governed actions): Preview against the live system (preconditions expected and now, a rolled-back dry run, an action hash, an expiry), then Approve and run with a reason. Runs once; a repeated click runs nothing (Decision 268) |
| Break-glass SQL | Supabase SQL editor for project `fxcwkweaxjtknorudmwp` only, and only when the change control names it as break-glass; check the expected counts the paste states |
| Paste files | Drops, deletes and consumer-API shape changes come as paste files under `docs/platform/pastes/`, with count guards. Never an applied migration |
| Migration editing a live function | md5-guarded: the migration compares the live `pg_get_functiondef` md5 with the one it was written against and refuses if they differ; each edit must apply an exact number of times (`pg_temp.edit_n`) |
| Before merge | Full suite 0 failed and 0 skipped; a rolled-back live dry run; live md5 checks just before merge; change control written |
| After deploy | Pull the deployed definition back and compare md5 with the file; confirm the live version |
| Consumer API | Frozen (G3). A change needs your recorded approval line in the migration and a re-baseline |

### 4.6 Exceptional actions and their audit

| Action | Where | Record |
|---|---|---|
| Read again | Sources tab | `pipeline.admin_control_events` |
| Course batch | Course-level reading | `pipeline.admin_control_events`, `pipeline.admin_jobs` |
| Read one course from its stored page | Course detail (`data-course-entry-read`, "Read once") | read run; rows wait in Layer 4 |
| Governed action | Governed actions | `pipeline.admin_jobs` (task kind `governed_action`) and a linked `pipeline.admin_control_events` event |
| Paste file | SQL editor (break-glass) | The paste's own post-checks; a reconciliation note in `docs/platform/ui-audit/` |

---

## 5. Layer 4 reviewer

**Who:** the server allows Curator and above (rank 3) to decide AER items (`security.layer4_review_decide_impl`). The programme has so far listed AER decisions as the Platform Admin's (see Q4).

**Item kinds:**
- `entry_matrix_first_run` and `entry_matrix_change` (provider tables);
- `course_entry_first_read` (one course page);
- the rendered no-table note (an `entry_matrix_first_run` or `entry_matrix_change` item with no rows).

### 5.1 What approval does

**Approval admits the whole run.**
- Approve: every proposed row of the run becomes active; the source's earlier active rows become `superseded` (W15, `security.entry_matrix_review_apply_v1`, `security.course_entry_review_apply_v1`).
- Approve except: excluded rows become `inactive` ("excluded by the reviewer"), the rest are admitted. The server takes the excluded row ids in the decision's final value (`exclude_row_ids`).
- Reject, Ask for more evidence, or Send back: every proposed row of the run becomes `inactive` with the reason.

Nothing is half-admitted. There is no per-row approve.
**Record:** `pipeline.layer4_decisions` (who, action, reason, before and final value); Layer 4 › Inbox › Decided shows it.

### 5.2 Checks before approving

Open the source and its stored copy (Evidence) beside the rows. For each row:

| Check | Pass when |
|---|---|
| Quote on page | The quote is in the stored copy, word for word (the reader already refused rows whose quote it could not find) |
| Stored copy | The copy is of the source address and is the newest copy (W28 pending, see 4.1) |
| Identity | Course items: the stored page is this course's own official page (strong identity, for example a CRICOS code; for New Zealand an NZQA code or another approved proof; never title only). Matrix items: the source is this provider's official site |
| Country | The row's country is the country the source names. A region ("Asia", "EU") is not a country; those were not kept |
| Level | The published level label is as printed; the mapped level fits it |
| Scale and basis | A number has its scale; a course score has its printed basis; a band only where printed, never from an ATAR |
| Completeness | Compare "kept · not kept". A large share not kept means the table was only partly read: do not approve as if complete |
| Reviewer judgement | Generic notes (for example a minimum age) are not academic entry requirements by default; decide them, and exclude them if they are not |

Admit the whole run only when every row you keep passes. If some rows fail, use Approve except. If the read is materially incomplete, Reject with the reason, or leave it and escalate for a re-read.

### 5.3 Rendered no-table note

Open the page and its stored copy. If no requirements table is shown, **Approve**: the provider is recorded as publishing no matrix there, and the website says "contact the provider". Nothing is admitted. If a table is shown, **Reject** with the reason and raise it for a reader change.

### 5.4 Stale and duplicate items

- **Stale:** an item from an older stored copy when a newer read of the same source exists (Otago Polytechnic `f14ae480`). Reject it as superseded, with the reason naming the newer item.
- **Duplicate:** two pending items for one source. Do not approve both. Review the newer one and escalate the pair to the Platform Admin if it is not clear which is newer.
- **Already decided:** if another reviewer decided first, the server refuses with "review item already decided". Reload; do not re-decide.

### 5.5 Review versus operational correction

| You find | Do |
|---|---|
| A proposed row is wrong | Decide it in Layer 4 (Approve except, or Reject). Do not approve and then fix it in the workspace |
| An active row is wrong | Correct it in the workspace (section 3) with a reason |
| A whole source is misread | Reject in Layer 4; the Platform Admin decides on a re-read or a reader change |

### 5.6 Telling queue items apart (30 Oct 2026)

The pending queue is not a list of defects. On 30 Oct it held 515 items: 241 AER and 274 others (`ui-audit/2026-10-30-enrichment-health-reconciliation.md` §2.2). Sort each item into one of four groups before deciding.

| Group | How to tell | What to do |
|---|---|---|
| **Actionable new evidence** | Status `pending`; the run is on the source's newest stored copy; the rows carry quotes | Read it and decide it (section 5.2) |
| **Stale or superseded duplicate** | The source has a newer run, or the item is already `superseded` (W28 closes older-copy items itself when a source is read again) | Reject a still-pending stale item, with the reason naming the newer item. Never approve it. |
| **Held incomplete read** | It does not reach Layer 4. The AER workspace shows the course read as held partial, skipped or failed. | Nothing for the reviewer to do. A re-read needs the Platform Admin's approval of a spend line. |
| **Awaiting another correction** | A tuition or official-URL item on a course that already has a newer active value (31 tuition and 22 URL items on 30 Oct) | Compare it with the current value. Decide it only once you know which is right. Do not approve over a newer value. |

No group is cleared in bulk. Until the Platform Admin decides "approve except" (decision paper A1), reject an item whose rows are partly wrong, with the reason.

---

## 6. Website and Zoho integration owner

**Who:** the person who owns the consumer side: the website team's contact and the Zoho workflow owner.

**Your contract:** the developer guide §7.9 (`docs/integrations/developer-pack/StudySearch-Website-API-v2-Developer-Guide.md`) and the register `docs/integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md` (R19). This section explains what sits behind that contract. It does not repeat it.

### 6.1 What reaches the consumer

- Only **active** rows. Proposed, quarantined, withdrawn and superseded rows never reach `website_v2_course` `entry` or `website_v2_provider` `entry_matrix` (W14).
- Active rows come only from a Layer 4 approval or a person's governed add or restore. A row corrected in the workspace reaches the website with its correction.
- The payloads are additive within Website API v2. Nothing is renamed or removed.

### 6.2 Rendering rules (owned by the website team)

The platform returns data. It does not build or host any website page. How the student sees it is the website team's work, and is not built yet (consolidated report, "Status in plain words"). The developer guide §7.9 states the three outcomes and their wording.
- No inference: no "eligible", no estimated band, no minimum copied from another level or country.
- `null` or empty means not held, not "no requirement".
- Show `as_at` with each row.

### 6.3 Zoho

`zoho-api-v2` is unchanged and carries no entry requirements. A Zoho workflow that needs them calls Website API v2 `course` with the lead's country of prior education, using a key issued for that use (developer guide §7.9).

### 6.4 Prohibited

- Asking for, or making, a change to a consumer function, column, table or edge function to suit one page (G3; Decision 266). New needs are new additive fields, agreed through the requirements register.
- Treating a proposed or quarantined row as published, for example by reading admin screens or tables.
- Describing platform fixes or internal work in the developer guide (§13 lists API changes only).

### 6.5 Escalate

| Situation | To |
|---|---|
| A value the website shows looks wrong | A Curator, with the course, country and what was shown; they check Resolution inspection |
| A new field or filter is needed | Platform Admin, through the requirements register |
| A response shape changed unexpectedly | Platform Admin at once. Job `consumer-api-guard` checks this daily |

---

## 7. Incident and concurrency response

**Who:** the Platform Admin, or the agent working under a Platform Admin mandate. Others report and stop.

**Worked example:** the scholarship paste deadlock of 29 Oct 2026 (`ui-audit/2026-10-29-scholarship-deadlock-reconciliation.md`, decision W27).

### 7.1 First minutes: contain

When a statement fails with **40P01** ("deadlock detected"):
1. **Stop.** Do not run the statement again.
2. Note the exact time, the process, the statement, and what else was scheduled then.
3. Postgres cancels one transaction as the victim and rolls it back whole. The other one carries on. Nothing is half-applied by the deadlock itself.

In the example, the paste was the victim at 16:26:43. Job 39 (`search-refresh-requested`) continued.

### 7.2 Reconcile before anything else

Read only. Establish:
- **Did the failed transaction roll back completely?** It was one transaction, so yes. Confirm with the counts its pre- and post-checks name.
- **Did anything commit later?** In the example, a second run committed at 16:57 although the editor showed "Failed to fetch": the server had finished and the dashboard connection dropped. The live post-conditions proved it.
- **Will a re-run be refused?** The paste's precondition (214) no longer matched (208), so it must not be run again.
- **Migration history and md5:** confirm prerequisite migrations are recorded and equal their files.

Write the reconciliation as a dated note in `docs/platform/ui-audit/` before proposing a fix.

### 7.3 Diagnose: competing writers and lock order

1. From the postgres log, find both processes and what each was waiting for ("still waiting for ShareLock on transaction …", "while updating tuple … in relation …").
2. From `cron.job_run_details`, find any scheduled job running at that time and how long it took against its usual time.
3. List every writer of the contended table and read each deployed definition with its md5. In the example: `security.search_refresh_requested_v1` (`bb78c854`), `search.refresh_course_documents_v3` (`40dc6d97`), `search.refresh_course_enrichment_scoped_v1` (`52bff5be`), `search.refresh_course_enrichment_core_scoped_v1` (`3f0b051f`), `security.scholarship_sweep_apply_v1` (`ccd52459`).
4. Ask:
   - Do the writers coordinate (an advisory lock)?
   - In what order does each lock rows?
   - Does a long transaction gather locks across many calls?

   In the example, nothing coordinated. A long paste locked document sets call by call, while the full rebuild locked in one pass, so ordering rows within a call could not prevent the cycle.
5. Identify who was **not** the cause. In the example, the Layer 4 reviewer working at the same time was not the competing writer.

### 7.4 Coordinate with people working live

- Tell active Layer 4 reviewers and curators what happened, and whether their decisions are affected. A Layer 4 decision is its own transaction; it either committed or it did not, and Inbox › Decided shows which.
- Ask them to pause large or repeated actions on the affected area until the fix is deployed. Single decisions can continue.
- Do not cancel their sessions.

### 7.5 Prohibited

- A blind retry of the failed statement.
- Splitting approved SQL into smaller pieces to "get it through". An approved paste is approved whole, with its checks.
- Killing sessions that are not part of the incident.
- Weakening a lock, a guard, a precondition or a timeout to make the error go away.
- Changing data by hand to "finish" what the failed run would have done.

### 7.6 Fix sequence

1. **Decision:** lodge the proposed correction as a decision record entry before code (W27: one transaction-scoped advisory lock taken by every writer of `search.course_documents`; the scheduled job only tries it and leaves its requests for the next tick; rows locked in ascending `course_id` within a scoped call).
2. **Fix:** a migration that edits the live functions under md5 guards. The lock key is a fixed technical constant marked `-- fixed:` (G2).
3. **Concurrency test:**
   - reproduce the deadlock locally (overlapping sets in opposing orders) and show it fixed;
   - add a contract spec;
   - run a rolled-back live dry run;
   - run the full suite with 0 failed and 0 skipped.
4. **Deploy:** after change control. Verify the deployed md5s and observe one job tick.
5. **Guarded reapplication:** only if the reconciliation shows the work is still missing. Use a fresh paste whose preconditions match the live state now, with count guards. In the example, no reapplication was needed because the second run had committed.

**Status at the time of writing:** W27 is decided but not deployed. The three functions above are live with their 17:05 md5s and no advisory lock (read live, 29 Oct 2026). Until it is deployed, avoid running long multi-call pastes that refresh search documents while job 39 is due (every 10 minutes).

---

## 8. Quick reference

Abbreviations for the role column: **V** = Viewer (rank 1+); **C** = Curator and above (rank 3+); **PO** = Pipeline Operator (rank 4+); **PA** = Platform Admin (rank 6).

| Operation | Role | Evidence required | Audit record | Escalation path |
|---|---|---|---|---|
| Filter, sort, inspect, resolve | V | — | none (read) | C for a wrong value |
| Open the stored copy or Layer 4 item | C | — | none (read) | — |
| Edit in list (active or quarantined row) | C | The row's quote prints the new value | `pipeline.manual_edit_log` per field (`edit`); version +1 | PA when the quote itself is wrong |
| Edit conditions | C | As printed in the quote | `manual_edit_log` (`edit`, field `conditions`) | PA |
| Add requirement | C | Official source, exact quote, stored copy of that address | `manual_edit_log` (`add`) | PA when no stored copy exists |
| Withdraw | C | The provider no longer publishes it | `manual_edit_log` (`withdraw`) | — |
| Quarantine | C | A stated doubt about the evidence | `manual_edit_log` (`quarantine`) | PA for a re-read |
| Restore | C | Why the withdrawal or quarantine was wrong | `manual_edit_log` (`restore`) | Layer 4 for never-admitted rows |
| Approve or Approve except in Layer 4 | C (server); PA in practice (Q4) | Quote on stored copy, identity, scale and basis, completeness | `pipeline.layer4_decisions` | PA for duplicates, stale items, incomplete reads |
| Reject or ask for more evidence in Layer 4 | C | The reason the rows fail | `pipeline.layer4_decisions` | PA |
| Bulk decide in Layer 4 | PO (server) — **not used for AER** | — | `pipeline.layer4_mass_operations` | PA (Q3) |
| Read again (one source) | PA | A reason; the source in scope and not held as unreadable | `pipeline.admin_control_events` | Change control for a reader change |
| Read one course from its stored page | PA | A reason | read run; Layer 4 item | — |
| Course-level batch | PA | Preview count and cost; balance stays above the US$5 floor | `pipeline.admin_control_events`, `pipeline.admin_jobs` | Spend decision when the floor stops it |
| Governed action | PA | Preview: preconditions, dry run, hash | `pipeline.admin_jobs` (`governed_action`), `admin_control_events` | — |
| Paste file (break-glass SQL) | PA | Change control names it; count guards | The paste's checks; reconciliation note | — |
| Migration or deploy | PA (agent under mandate) | md5 guards, dry run, full suite, change control | Change control; deployed md5 | — |
| Incident (40P01) | PA | Logs, cron runs, live counts, md5s | Reconciliation note; decision entry | — |
| Consumer API change | PA only, with explicit approval | Approval line, re-baseline | Migration and consumer-api baseline | — |

---

## 9. Verification notes

**Checked against code (Pilot `main` `fabda0cb`):**
- `src/AerWorkspace.jsx`, `src/EntryRequirements.jsx`, `src/CourseAudit.jsx`, `src/nav-map.js`, `src/guide/sops.js` (SOP 2.08 / 2.05), `src/guide/platformGuide.js`;
- `src/m2-3-intelligence-entry.jsx` (Layer 4 decision buttons);
- migrations `20261026001000`, `20261028001000`, `20261029010000` to `20261029100000`.

**Checked live, read only (`fxcwkweaxjtknorudmwp`, 29 Oct 2026):**
- `security.layer4_review_decide_impl`: rank 3; refuses an item already decided; writes `pipeline.layer4_decisions`;
- `l4_api.layer4_review_bulk_decide`: rank 4; reject, more evidence and send back only; no AER guard;
- the insert targets of `admin_aer`, `security.aer_reread_v1` and `security.course_entry_batch_v1`;
- the resolver's case-by-case rule and its four rule-5 notes;
- the md5s of the three search writers (no advisory lock yet).

**Not verified:**
- I found no control in `src/` that sends excluded row ids for "Approve except". The server accepts them; the 29 Oct "approve except" decisions were framed as governed decisions. Q2 asks how it is meant to be done.
- The live phone drawer is not visually accepted (consolidated report A5); its fix is reported in Part B B1.
- The client accepts a 4-character reason in `ReasonAction`, but the server requires 5 for workspace actions and Layer 4 decisions. This guide states 5.

**Open questions for the Platform Admin:**
- **Q1 (W28):** should Read again read only the newest stored copy?
- **Q2:** how should a reviewer take "Approve except" for an AER item: a UI control, or a governed action each time?
- **Q3:** should Layer 4 bulk decisions exclude AER item kinds (`entry_matrix_first_run`, `entry_matrix_change`, `course_entry_first_read`)?
- **Q4:** are AER Layer 4 decisions Platform Admin only by policy, or open to Curators, as the server allows?
- **Q5:** a matrix row with a printed requirement but no numeric scale (for example "Completion of Senior High School Diploma", scale `none`) is returned with `case_by_case` true. Is "considered case by case" the intended wording for these, or should the printed requirement be shown with it? The developer guide now tells the website to show both.

## History

| Version | Date | Change |
|---|---|---|
| 1.0 | 29 Oct 2026 | First issue (lane F, Workstream 5): six role guides, quick-reference matrix, verification notes and open questions |
