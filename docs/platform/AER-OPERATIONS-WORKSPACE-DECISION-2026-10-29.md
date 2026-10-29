# AER operations workspace — decision record

**Lodged 29 Oct 2026, about 08:3x AEDT, before any Pilot code for this mandate.**

**Mandate.** Platform Admin, 29 Oct 2026 08:06: "AER operations workspace: complete UI, data management and visual parity". It authorises governed human editing of academic entry requirement (AER) data. It supersedes the read-only limit of the 28 Oct Step B decision (B5: "nothing here edits a row"). It does not weaken AI admission, evidence, identity or consumer API controls.

**Related records.**
- `ENTRY-REQUIREMENTS-IMPLEMENTATION.md`: the build-order authority.
- `ENTRY-REQUIREMENTS-STEP-B-DECISION-2026-10-28.md`: B5 read-only drawers. Superseded here for editing only.
- `ENTRY-REQUIREMENTS-PROGRAMME-DECISION-2026-10-28.md`: the consolidated programme.

## 1. Decisions

| # | Topic | Decision |
|---|---|---|
| W1 | Where it lives | A new menu page, **Catalogue › Entry requirements** (`/entry-requirements`), placed after Scholarships. It has four tabs: **Provider entry matrix**, **Course entry requirements**, **Sources, reads and holds** and **Resolution inspection**. |
| W2 | One editing route | Editing exists only in the workspace. The Provider drawer and Course detail sections stay read-only and gain an "Open in Entry requirements" shortcut to the filtered workspace. There are never two editing implementations. |
| W3 | Layer 4 stays the only admission route | Proposed AI rows are not editable and cannot be activated from the workspace. They show a link to their Layer 4 item. The workspace has no approve button and no bulk action. |
| W4 | Governed edits | An operator may correct an **active** or **unverified** row. The editable fields are:<ul><li>matrix rows: qualification, published level label and mapped level, band, minimum grade, numeric value, scale, conditions (structured), edition, intake year and as-at;</li><li>course rows: requirement text, minimum grade, value and scale, course score and its printed basis, band and as-at.</li></ul>The quote, source URL, stored evidence and provenance are never editable. |
| W5 | Add a requirement | An operator may add a row backed by official evidence. The row needs:<ul><li>the provider, and the course for a course row;</li><li>the country, level, qualification or kind;</li><li>the minimum with its scale, or the course score with its printed basis;</li><li>the exact quote, the official URL and a **stored evidence copy of that URL**;</li><li>the edition or as-at date, and a reason.</li></ul>It is a human-supplied row, not an AI row, so it is created **active** with provenance `manual`. It is audited like an edit. |
| W6 | Lifecycle | All three actions use the existing status vocabulary only. No new status is added, there is no delete and there is no bulk action.<ul><li>**Withdraw:** an active row becomes `inactive`. The withdrawal reason and `valid_to` are kept.</li><li>**Quarantine:** an active row becomes `unverified` because its evidence is doubtful.</li><li>**Restore:** a row becomes `active` again, but only when its last workspace action was a withdrawal or quarantine. A row never admitted, or excluded in Layer 4, cannot be restored here.</li></ul> |
| W7 | Validation | <ul><li>A numeric value needs an explicit scale other than `none`.</li><li>A course score needs its printed basis.</li><li>A band, a minimum grade's number and a numeric value must appear in the row's quote (source-supported, the same rule as the AI reader).</li><li>A changed identity may not collide with another active row (the active `row_hash` unique index). The collision is refused in plain words.</li></ul> |
| W8 | Concurrency | Every write carries the row's `updated_at` as read. A stale value is refused ("changed by someone else; reload"). A matrix row's `version` rises with each change. |
| W9 | Permissions | <ul><li>Reading: every assigned role (rank ≥ 1).</li><li>Edit, add and lifecycle: Curator and above (rank ≥ 3), the same as Scholarships › Edit in list.</li><li>Source re-read: the existing governed mechanism, Platform Admin (rank 6).</li><li>Course re-read: the existing "Read from the stored page", Platform Admin.</li></ul>All checks are made on the server. |
| W10 | Reason and audit | Every write needs a reason of at least 5 characters. Each changed field is written to `pipeline.manual_edit_log` with the entity (`entry_matrix` or `course_entry`), row id, field, action, before value, after value, reason, actor and time. The row's history in the drawer is read from that log. |
| W11 | Bounded reads | Lists are at most 100 rows a page (fixed: page bound), and every filter runs on the server. The summary is one aggregate query. Option lists are capped. There is no unbounded read. |
| W12 | Re-read | Re-reads are bounded and go through existing mechanisms only.<ul><li>A source is re-read through `admin_entry_matrix_reread`, one source at a time, with a reason. It is refused when the provider is out of reading scope, a read is already queued, or the latest read is a terminal evidence hold (`held_unparsed`, which only a reader change clears).</li><li>A course is re-read through the existing "Read from the stored page".</li></ul>There is no "read everything" button and no new job. |
| W13 | Resolution inspection | An operator diagnostic, not a consumer preview and not an eligibility calculator. It calls the live resolver (`security.entry_resolve_v1`) unchanged, then shows for each of the five rules whether it applied and why not (counts of active rows), with the case-by-case and contact-provider distinction. |
| W14 | Consumer API | Unchanged (G3). Active rows edited by a person reach the course `entry` and provider `entry_matrix` payloads through the existing functions, which read active rows only. Proposed, unverified, inactive and superseded rows never reach them. No consumer function, column or shape changes. |
| W15 | Later AI reads | An admitted re-read of the same source still supersedes that source's active rows, human-corrected ones included. The person approving it in Layer 4 sees the new rows, and the corrected row and its edit history are kept. |
| W16 | Visual parity | The workspace uses the Scholarships and catalogue patterns:<ul><li>the shared `DataTable` (fluid, resizable, sorting headers, sticky first column);</li><li>`Pager`, `StatusChip` tones, the filter bar and chips, and the right-hand drawer;</li><li>`ListEdit`-style cells: click or Enter to edit, Enter or blur to save, Esc to cancel, one save at a time, a tick on success, the error under the row;</li><li>a Columns menu (show or hide, remembered per browser).</li></ul>Every pill has readable text. |

## 2. Pill tones (existing `statusTone` system, text always shown)

| Meaning | Status | Tone |
|---|---|---|
| Active / success | `active` | success |
| Proposed / waiting | `proposed` (waiting in Layer 4) | info |
| Quarantined / error | `unverified` | danger, labelled "Quarantined" |
| Inactive / withdrawn | `inactive`, `superseded` | neutral, labelled "Withdrawn" or "Superseded" |
| Running / reading | read `queued` or `leased` | info, labelled "Reading" |
| Held / incomplete | `held_unparsed`, `held_incomplete`, failed read | warning, labelled "Held" |

## 3. What does not change

- The AI reader gates: quote, scale, completeness, identity and Layer 4 first-run review.
- The resolver, the consumer payload functions and the edge functions.
- The status vocabulary (`proposed`, `active`, `inactive`, `superseded`, `unverified`).
- The jobs: no new job and no new setting.

## 4. Build and acceptance

- **One Pilot release (v2.15.363).** It contains:
  - migration `20261029010000_cf247_aer_workspace.sql`, which adds `public.admin_aer(action, args)` (additive; md5-guarded where it touches existing functions);
  - `src/AerWorkspace.jsx`, the nav entry and the drawer shortcuts;
  - the shared `DataTable` moved to its own module, unchanged;
  - specs `s152` (server contract), `s153` (UI contract) and `s154` (deployed acceptance).
- **Per the operating model:**
  - decision before code;
  - full suite with 0 failed and 0 skipped;
  - live md5 checks and a rolled-back dry run;
  - change control before merge;
  - deployed verification.
- **Deployed acceptance** uses the existing UAT user. It opens the workspace, applies combined filters, changes columns, and opens the drawer, pills and resolution inspection, checking for no console errors and bounded reads. It is read-only by default. The live edit of a governed fixture runs only under the live-acting switch (G4 `@live-acting`).

## 5. Addendum, 29 Oct 2026: course-level programme, rendered no-table note and HTML refetch

**Authority:** Platform Admin decision, 29 Oct 2026 09:57 ("Continue the full AER programme — consolidated authority and remaining delivery"), items 1, 3 and 4. This addendum was recorded before code (release v2.15.364).

### W12a. Read again and the parked reader settings (item 1)

- Two settings are added or changed:
  - `entry.matrix_slice_concurrency` (new, 6, range 1–12): `svc_entry_matrix_next` passes it to worker v0.51.0, which already reads slices that many at a time;
  - `entry.matrix_slice_chars`: changed from 20,000 to 8,000.
- **One mechanism.** Read again moves into `security.aer_reread_v1`, which is owner only. `admin_aer('reread')` calls it after the Platform Admin check, and an approved programme migration may call it too.
- **Markdown-stored web pages.** When a web page's stored copy is Firecrawl markdown, Read again fetches the page again instead of re-reading the copy:
  - its proposed rows and its pending Layer 4 item are superseded with the reason;
  - the source returns to `found`;
  - the fetch keeps the page's own HTML;
  - the markdown copy stays as evidence.
- **Refusals.** Every earlier refusal is kept: out of scope, AI stopped, a read waiting, held as unreadable, and robots. A page already waiting to be fetched is also refused.

### W17. Course-level reading programme (item 3)

- **Lane and rules.** Course-level reading runs on the existing Enrich fields lane and the B1 rules are unchanged:
  - a stored official course page and strong identity;
  - the quote must be on the page;
  - a band only when printed;
  - no English-test rows;
  - no inferred international applicability;
  - one Layer 4 `course_entry_first_read` item a course.
- **Settings:**
  - `entry.course_read_providers`: the approved plan's Australian providers in priority order. Monash and QUT come first because they publish requirements on course pages only, then RMIT for its band ladder, then the plan's other Australian providers.
  - `entry.course_batch_size`: 50 courses a batch, range 1–200.
  - `entry.course_read_cost_usd`: the estimate used until 20 course reads are measured.
  - `entry.course_read_countries` stays `["AU"]`. Reading New Zealand courses needs an identity proof rule for entry requirements there, which is a separate decision.
- **The workspace.** Course entry requirements › Course-level reading shows, by provider:
  - eligible, read, reading, waiting in Layer 4, admitted, with no row kept, and remaining;
  - the estimated cost left;
  - the cost a course and the OpenRouter balance against its existing credit floor.
- **Batches.** A Platform Admin previews the next batch (its count and estimated cost), then asks for it with a reason. A batch:
  - is one Enrich fields task;
  - is never larger than the batch size;
  - only takes courses never read;
  - is refused while an earlier course read waits, when AI is stopped, or when the estimate would take the balance below the floor.
- **What is not added:** no job, no reader lane, no status, and no consumer API change.

### W18. Step C rendered page with no requirements table (item 4)

- **The note.** A page read rendered (`entry.render_hosts`) that keeps no row opens one Layer 4 note in the existing vocabulary: `entry_matrix_first_run` or `entry_matrix_change`, status `pending`, no rows.
- **Approval** confirms "no matrix published here", and the website then says "contact the provider". It admits, quarantines and supersedes nothing.
- **The workspace** shows the two states apart, in words:
  - "Rendered, no table: in Layer 4" while the note waits;
  - "No matrix published (confirmed)" once it is approved.
- **Backfill.** The three rendered reads that already kept no row get their note: Newcastle, Griffith and Victoria University of Wellington.

### Build

- Release v2.15.364 contains migrations `20261029020000` and `20261029030000`, plus specs `s155` and `s156`.
- After it is deployed, a separate count-guarded migration runs the approved programme batch:
  - the ten named re-reads, one governed attempt each;
  - the first bounded course batch.
- Layer 4 decisions stay with people.

### W19. A published level label that names several levels (29 Oct 2026, recorded before code)

- **Evidence.** The Platform Admin's phone screenshot, 29 Oct 12:20, showed RMIT Diploma of Commerce DP020 (CRICOS 111278B) for India.
  - RMIT publishes its India diploma rows under the label "Diploma/Associate degrees".
  - `security.entry_level_map_v1` takes the first level it recognises, so those rows map to Associate degree only.
  - A Diploma course therefore finds no row at its level, and the resolver says "none for this course's level".
- **Decision.** A row whose **published** level label names several levels counts for each level it names. `security.entry_label_levels_v1(label)` splits the label on "/", ",", "&", "and" and "or", and maps each part with the existing mapping.
  - The resolver (`security.entry_resolve_v1`) and the workspace's Resolution inspection both match `study_level_id` or a level named in the label.
  - Nothing is inferred: the provider printed the level.
  - Active rows only; the five rules are unchanged; the consumer API shape is unchanged (G3). Values change only where a printed label now matches.
- **Effect for DP020 / India.** RMIT's diploma rows are band-table rows, and DP020's page prints no band, so the answer stays rule 5, "contact the provider". The reason becomes the true one: a band table exists for this level, and the course prints no band to enter it with.
- **Build.** Migration `20261029050000`, md5-guarded edits of the resolver and `admin_aer`, spec `s160`, a rolled-back live dry run listing every course whose resolution changes, and change control before merge.
