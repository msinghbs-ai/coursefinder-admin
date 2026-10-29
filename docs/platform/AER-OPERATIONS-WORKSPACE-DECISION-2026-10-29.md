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

## 6. Addendum, 29 Oct 2026 12:23 (consolidated bug-fix and programme continuation mandate, sections A–D), recorded before code

- **W20 (A1). Course evidence overlay.**
  - The evidence/history button on Course detail opens a consolidated overlay: a dialog on desktop, full screen on a phone. The embedded "What happened to this course" history leaves the blade.
  - The overlay reads the existing authoritative evidence read; there is no new dataset. It shows one chronological timeline: discovery and reads, page changes, AI matches and fills, admissions and refusals, fee reader, cross-checks, manual edits, AER reads and admissions, and scholarship checks. Each entry has its date, outcome, source link and evidence reference.
  - It is built on a shared accessible overlay primitive (dialog role, focus in and back, Escape, close, scroll lock, internal scrolling on a phone) that the AER row drawer also uses where appropriate.
- **W21 (A2). DP020 scholarships.**
  - Trace the empty relationship through identity, provider association, audience, publication, relationship rules and earlier checks.
  - Fix only a demonstrated defect, through the existing scholarship mechanisms. Never attach scholarships wholesale, manufacture a relationship or publish a proposed scholarship.
  - A genuinely empty result keeps an honest, explained empty state and a working "Check scholarships for this course".
- **W19 extended (A3).**
  - Country selection refreshes only the bounded resolver read and never starts an AI read.
  - Rule 4 returns active provider-minimum rows at the course's level, with no band required; rules 3 and 4 match a level named in a published label (W19).
  - A genuine empty result keeps the precise contact-provider explanation.
- **W22 (A4). Country ordering.** One shared helper orders countries India, Nepal, Singapore, then the rest A–Z. It uses only the countries available from reference data or published rows, with no duplicates. It is used by the Course detail selector and every workspace country selector, and the selection is remembered per viewer.
- **W23 (A5). Phone drawer and banner.**
  - The real phone defect is fixed, not the mock: a row tap at phone width opens the drawer with complete evidence, and it closes reliably with no horizontal overflow.
  - The shared OpenRouter notice never clips or overlaps at phone width. Its other uses are checked.
- **W24 (B1). Reader corrections.** Structure-driven corrections to how cells become lines, or to normalisation applied to both sides of the comparison, so that genuinely printed cells can be quoted (Federation, Wollongong, Otago Polytechnic, UWA band evidence). No provider-specific expected grades, and no blanket normalisation that admits paraphrases. Each source is re-read once afterwards, and the earlier incomplete items stay unapproved.
- **W25 (B2, B3).**
  - **B2:** the 13 approved Read again actions (ANU ×9, Melbourne ×3, UTS), one governed attempt each, through `security.aer_reread_v1`.
  - **B3:** course batches continue only while the OpenRouter balance stays above its US$5 floor. The balance and the measured cost a course are rechecked before each batch. When the floor stops a batch, course reading pauses cleanly and the measured evidence goes into one spend decision. The floor is never changed. Generic notes (for example a minimum age) are flagged for reviewer judgement only.
- **W26 (B4). New Zealand course identity.**
  - New Zealand course pages are read with the already-approved strong New Zealand proofs: an NZQA code on the official course page, or another proof already approved for New Zealand fields. Each needs a stored official page and a provider and course identity match.
  - A title-only basis is refused. The Australian rules are unchanged, and no separate lane is added.
  - Contract and rolled-back live dry-run coverage come before activation (`entry.course_read_countries` gains NZ only after the dry run passes).
- **Unchanged:** quote, identity, completeness and admission gates; the consumer API shape; the status vocabulary; Layer 4 as the only approval; the spend floor.

## 7. Addendum, 29 Oct 2026 16:59 (programme to governed completion, Workstreams 0–5), recorded before code

- **W27 (Workstream 0). One writer lock for search documents.**
  - Root cause, evidence and reconciliation: `ui-audit/2026-10-29-scholarship-deadlock-reconciliation.md`.
  - Every writer of `search.course_documents` takes one transaction-scoped advisory lock (fixed technical constant, `-- fixed:`):
    - the shared scoped refresh `search.refresh_course_enrichment_scoped_v1` and the full rebuild `search.refresh_course_documents_v3` wait for it;
    - the scheduled `security.search_refresh_requested_v1` only tries it and, when it is held, leaves its requests for the next tick (result `held`).
  - The scoped refresh locks its documents in ascending `course_id` before updating.
  - Unchanged: document values, consumer API (G3), scholarship relationship rules, admission gates, Layer 4. Nothing is dropped.
  - Verified by:
    - a local reproduction of the deadlock (overlapping course sets in opposing orders), shown fixed;
    - a contract spec;
    - md5 guards on the three functions;
    - a rolled-back live dry run;
    - the full suite;
    - deployed-source md5 after merge.
  - The scholarship paste is already applied and verified (16:57), so no reapplication is prepared.
- **W28 (Workstream 1). Read again targets the newest stored copy.**
  - Authority: mandate 29 Oct 2026 16:59: "Correct Read again behaviour so it targets the newest stored source copy. A re-read must not create duplicate current review items."
  - `security.aer_reread_v1` reads again only the run on the source's current stored copy (`entry_matrix_sources.content_hash`, falling back to the latest run).
  - Runs on older stored copies are not re-queued and keep their history. Their still-proposed rows and still-pending Layer 4 item are closed with the existing status `superseded`; decided items and their rows are not touched.
  - No new status, action or setting; quote, identity, completeness and admission gates unchanged.
  - `public.admin_entry_matrix_reread` (bulk, md5-pinned by `governed_aer_close_snapshot_v1`) is unchanged; whether bulk re-reads should also take only the newest copy is a separate question (open).
  - The existing duplicate Otago Polytechnic item `f14ae480` is left for the Layer 4 reviewer (reject as stale); it is not closed by this change.
  - Verified by: the s169 contract (Otago two-copy fixture), a local Postgres test of the live definition before and after, a rolled-back live dry run on d74fcba4 (exactly one run re-queued), the full suite, and deployed md5.
- **W29 (Workstream 2). Course-level reading of long pages in bounded slices.**
  - Cause of the three failed Monash course reads (`e58e7771`, `512b56fe`, `9cf18451`): the course entry read asked for the whole page in one call with a fixed 2,000-token answer and did not check for a cut answer, so a long answer (many per-country minimums) failed as broken JSON at about 8,000 characters. Page size was not the cause.
  - Correction (worker next minor after v0.52.0):
    - a long course page is read in consecutive overlapping slices with recorded character coverage;
    - each slice has its own answer limit and a cut, empty or unreadable answer fails that slice by name;
    - every quote must be on its slice, rows are merged in page order and duplicates from overlaps kept once;
    - if any slice fails, nothing from the course is proposed and the item is held as partial;
    - a page longer than the configured maximum is held before any call;
    - cost is recorded on failed and held reads.
  - Limits are settings (G2): slice size, overlap, maximum slices, answer limit, slices at once.
  - Unchanged: quote, identity, scale/basis, completeness and admission gates; one Layer 4 item per course read; short pages are asked exactly as before.
  - No paid read is part of this change. The three failed courses need a separately approved re-read once it is live (bounded decision).

## 8. Addendum, 30 Oct 2026 00:01 (enrichment-health reconciliation and incident, Workstreams 1–8), recorded before code

Evidence:
- `ui-audit/2026-10-30-enrichment-health-reconciliation.md` (Workstream 1);
- `ui-audit/2026-10-30-gap-causes-needs-a-change.md` (complete gap list);
- lane handbacks, summarised in the 30 Oct handback.

Each decision below is an md5-guarded edit of a live definition. No decision weakens a gate, adds a status value, binds a page manually or spends.

- **W30 (Workstream 2). Enrichment reliability.**
  - **Source finder:** `public.svc_source_find_next` exceeded the 8-second API limit on 80 of 143 calls in 48 h. Its candidate scan is now worked out once per set, with the same candidates in the same order, finishing in about 0.3 s.
  - **Course page reads:** `public.svc_coverage_read_next` re-checks the lease on the locked row, so a page is claimed by exactly one call. Jobs 49 and 159 had paid twice for 767 of 3,083 scrapes in 7 days.
  - **Onboarding:** `security.provider_onboarding_job_v1` tracks only its own university's job.
  - **Worker ledger:** worker modes `adapter_capture` and `adapter_propose` report `items` and `failed`, and a partial capture is never counted as complete.
  - **External, not coded around:** edge-runtime failures (BOOT_ERROR, 502, 546) are reported as external. Edge capacity versus job frequency is a Platform Admin decision.
  - **Not changed:** the 115 s course-list read is within design.
- **W31 (Workstream 4). The site-map binder keeps code-proved pages.**
  - **Cause:** on 29 Oct the routine 30-day re-map and job 47 demoted or replaced 789 AU pages that the reader had proved with the course's CRICOS code. 714 of these were wrongly displaced. No weak page became eligible.
  - **Correction in `security.coverage_bind_v2`:**
    - a page read with a `cricos_code`, `nzqa_code`, `adapter_code` or `manual` proof is never re-scored, demoted or released unless it has been refused;
    - the release step releases only rows the binder bound itself.
  - **Reader (worker v0.54.1):** the labelled NZQA number rule applies to NZ pages only. College of the North Atlantic (CA) had 53 pages labelled `nzqa_code`.
  - **Not done by this change:** re-binding or re-reading. Recovery of the 714 runs through the existing promotion path, where a fresh read must find the code. It is a manifest, BLOCKED on a spend line.
  - **Open:** whether past-year handbook pages are current enough to be read (92 held, plus 110 currently eligible).
- **W32 (Workstream 5). AI answer limits are settings.**
  - Twelve `reading.answer_tokens.*` settings. Their defaults are the values formerly fixed in code; the fee reader gets 32,000.
  - A cut answer holds the whole read as `held_partial: output_truncated` on the existing path. Nothing of it is parsed or proposed.
  - Cost is recorded on failed and held reads.
- **W33 (Workstream 3). Layer 2/3 › Universities reads in pages.**
  - A new `admin_layer23('universities_page')` action, beside the existing actions.
  - Filters, search and order run on the server; the page size and tick limit are settings.
  - The 700 KB / 3 s budget assertion is unchanged.
  - The old `'universities'` action is kept until the screen release is live, then removed by a later md5-guarded edit.
- **Reporting (Workstream 7).** The hourly phone report:
  - states the gap snapshot's run time and age, and marks it stale after 75 minutes;
  - labels Layer 4 growth as 24 hours;
  - gives the complete "needs a change" count and where the full list is;
  - reports reader health;
  - marks spend as monitoring only.

  This changes the scheduled report only, not the platform. Showing the run time on the "Why values are missing" panel is proposed in the decision paper.

## 9. Addendum, 30 Oct 2026 06:53 (Platform Admin approvals A1–A5, bounded paid reads, snapshots), recorded before code

**Authority:** the Platform Admin mandate of 30 Oct 2026 06:53 AEDT, which decides the items in `ui-audit/2026-10-30-platform-admin-decision-paper.md`.

**Approved for design and implementation.** Each item's detailed implementation decision is lodged below before its code merges.
- **A1:** governed "approve except".
- **A2:** AER items excluded from generic bulk decide.
- **A3:** AER Layer 4 decisions restricted to the Platform Admin.
- **A4:** the no-scale wording principle: "Published requirement: [grade]. The provider does not state a grading scale on this page; check the source or contact the provider." The printed value is preserved, no scale is inferred, and it stays distinct from case-by-case and no published requirement.
- **A5:** bulk Read again targets the newest stored copy only (specification `ui-audit/2026-10-30-bulk-reread-newest-copy-spec.md`, Option A for the governed snapshot pin).
- **W34 and W35:** cached snapshots for the slow admin reads.
- The "Why values are missing" run time.

**Approved paid reads, with hard ceilings.** These are ceilings, not targets. They run one at a time, in this order:

| Order | Line | Scope | Hard ceiling |
|---|---|---|---|
| 1 | B1 | Three source re-reads (ANU Croatian Matura `87f40035`, ANU Bosnia-Herzegovina `6aee5653` (item `509c8f82`), Melbourne India State Board `467c7a0c` (item `290bd250`)) | US$0.05 |
| 1 | B2 | Three Monash course reads (`e58e7771`, `512b56fe`, `9cf18451`) through worker v0.54.1 | US$0.10 |
| 2 | — | Verify evidence, completeness, cost recording and Layer 4 output | — |
| 3 | R1 | Recovery reads for up to 714 displaced AU pages | 714 Firecrawl credits, no AI |
| 4 | B3 | The next 500 eligible AU courses after R1 reconciliation | US$6 |
| 5 | B4 | The 421 eligible NZ courses | US$4.50 |

**Before each paid step, preconditions are checked in the migration itself:**
- newest-copy identity and active eligibility;
- exact counts, and that nothing duplicate is queued;
- the deployed worker version;
- AI reading allowed and the balance above the floor.

**Controls:** no admission is automatic; the floor is unchanged. B5 is **not** approved; its next tranche is prepared only.

**Past-year handbook pages:** not admitted as current. The 92 holds stay unless current-intake applicability is independently evidenced. No weakening of currency or source gates.

**Prepared only, not executed:**
- the stuck adapter drafts paste;
- the edge capacity assessment (read-only; any schedule change needs a further decision).

## 10. Implementation decisions for §9, recorded before merge (30 Oct 2026, 07:25 AEDT)

- **A1–A3: the AER review path** (migration `20261030070000`).
  - **Kinds:** the three AER Layer 4 kinds (`entry_matrix_first_run`, `entry_matrix_change`, `course_entry_first_read`) take one path only, in Layer 4 › Inbox kind `aer_review`. Each item shows every row with its quote, the source, the stored-copy hash and completeness.
  - **A1, Approve except:**
    - The Platform Admin ticks the rows to leave out and gives one reason.
    - Ticked rows become the existing row status `inactive`. Their `status_reason` reads "excluded by approve except (Layer 4 item …, reviewer …): …", and `provenance.aer_exclusion` records item, run, hash, reviewer, reason and time.
    - No automatic writer touches `inactive` rows: Read again and bulk Read again supersede only `proposed` rows, and later approvals supersede only `active` rows. Excluded rows therefore stay unadmitted and identifiable, and are never staled or reclassified by themselves.
    - Every other row is admitted only through the unchanged apply functions (identity, completeness, scale/basis checks).
    - The completeness rule becomes "every row of a complete read is admitted or explicitly excluded". The read must still be complete and fully waiting.
    - An AER item cannot be edited inline: the only edit accepted is the Approve except shape.
    - Lineage (item → run → source → stored-copy hash → waiting rows, plus the excluded rows' snapshot) is kept on the decision and in `admin_control_events` (area `layer4`, actions `aer_*`).
  - **A2:** the generic bulk decide and the generic batch decide skip AER kinds, decide nothing and return `skipped_aer`.
  - **A3:** deciding an AER kind needs rank 6 (Platform Admin), enforced server-side. Curators can read the item, and `admin_aer` workspace editing is unchanged.
  - **Open point for the Platform Admin:** approving a provider-table *change* still supersedes the source's earlier active rows (W15), including a row whose new reading was excluded. That country then has no active row until a later read. The alternative, keeping the earlier active row when its new counterpart is excluded, is a separate decision. Until it is made, the reviewer guide tells reviewers to reject a change item rather than exclude a row that replaces an active one.
  - **Live dry run (rolled back, 07:18 AEDT):**
    - Inbox shows 242 AER items as `aer_review`.
    - Curator decide and Inbox reject were refused (42501); the Curator can still read the item (2 rows, `can_decide` false).
    - Bulk reject skipped 184 items and batch approve skipped 2; pending stayed at 242 before and after.
    - Approve except on RMIT Qatar `9adbeada` kept `36cbc6ba` active and `438c2bee` inactive "excluded by approve except", item `edited_approved`. The decision carries run `e07eeaf5` and hash `64edc4fe`, and the events are `aer_approve_except` and `inbox_decide`.
    - The excluded row stayed inactive after a Read again attempt.
- **A5: bulk Read again on the newest copy** (migration `20261030080000`).
  - Implements the specification `ui-audit/2026-10-30-bulk-reread-newest-copy-spec.md`, with the governed snapshot on Option A. The approval line is in the migration.
  - **Security defect found and corrected here:** the function's role check (`current_user <> 'postgres'`) never fires inside a security-definer function, so any signed-in user could call it over the API. API calls must now be Platform Admin; a direct owner session (a migration) is still allowed.
  - The same idiom guards `admin_adapter_measures`. That function is reported for a separate decision and not changed here.
  - **Live dry run (rolled back):** the Curator was refused. Otago Polytechnic re-queued 1 run (the newest copy). The older copy keeps its history, both items were superseded, 210 rows superseded, and the unknown id was skipped as `not_found`.
- **W35: snapshots for notices, publishability and field coverage, and the gap-cause run time.** Design: `ui-audit/2026-10-30-W35-snapshots-design.md`.
  - One derived table, `pipeline.admin_read_snapshots`.
  - A catalogued job, `admin-read-snapshots`, rebuilds a snapshot when it reaches its setting age: notices 5 minutes, the others 10. It takes an advisory try-lock, so builds never run concurrently.
  - Screens never rebuild a snapshot. They show its time, age and a stale marker.
  - Permissions and drill-downs stay exact and live. The consumer API and `scholarship_publishability_v1` are unchanged.
  - The gap-causes job records its run, and the panel shows the last run's finish time, stale after 75 minutes.
- **W34: `admin_read` slow operations** (`course_coverage`, `pipeline_jobs_page`, `providers_page`, `courses_page`). Design: `ui-audit/2026-10-30-W34-snapshots-design.md`, lodged 08:30 AEDT before the deployed proof.
  - **`course_coverage`:** answers from a derived snapshot, `pipeline.course_coverage_snapshot` and `course_coverage_totals`.
    - Job `course-coverage-snapshot` (`2-59/5`, catalogued) rebuilds it only when an hourly source build has changed, at most once every `snapshot.course_coverage_min_interval_minutes`.
    - It is single flight (advisory try-lock). The screen shows the build and check time and is marked stale after `snapshot.course_coverage_stale_minutes`.
    - Course lists opened from it stay live.
  - **`pipeline_jobs_page`, `courses_page` and `providers_page`:** choose the page first on light columns, then work out the per-row figures for that page only. The rows, order and fields are the same. Each is md5-guarded; `providers_page` is replaced whole after its md5 is confirmed.
  - **Unchanged:** `admin_read` itself, permissions and the consumer API.
  - **Shipped:** W34 and W35 shipped together in v2.15.373 (#757; migrations `20261030190000` and `20261030200000`).
  - **Proof:** the weekly deployed run (`40956651633`, safe mode) passed 79 of 79 desktop and 80 of 80 phone tests, including the four tests left red at 01:00. No assertion, budget or timeout was changed.
