# Platform Admin decision paper: Layer 4 policy and bounded paid reads (30 Oct 2026)

**Mandate:** 30 Oct 2026 00:01 AEDT, Workstreams 6 and 8.

Each line below can be approved or declined on its own. **Nothing here has been executed.**

**Until each line is decided, the current restrictive behaviour stays:**
- Layer 4 is decided by people only;
- no bulk approval;
- AER course reading stays stopped (no reads are queued);
- no re-read runs.

> **Balance note (revalidated 00:15 AEDT, 30 Oct):** the OpenRouter balance rose from US$4.99 (00:00) to **US$104.99** (00:15), which is a top-up. This is monitoring information, not authority to spend.
> - Checked live: no AER course read and no entry-matrix run is queued, so nothing starts on its own because of the top-up.
> - General platform AI work, which was already authorised (field reading, fee reader, page match), is no longer held near the floor and will spend inside its daily guards.

---

## Part A: Layer 4 policy (Workstream 6)

### A1. How "Approve except" works for an AER run

| | |
|---|---|
| **Today** | An AER item, whether a matrix run or a course read, is decided as a whole: Approve admits every proposed row, and Reject closes every row. A reviewer who disagrees with some rows has to reject the whole run. |
| **Proposed** | "Approve except" on an AER item: the reviewer ticks the rows to leave out and gives one reason. The ticked rows are closed as `rejected`, using the existing row status, with the reason and the reviewer. All other rows are admitted. |
| **What is kept** | The item keeps its run id, stored-copy hash and evidence; each row keeps its quote. The excluded rows stay visible in the run's history. Nothing is re-read. |
| **Why** | Reviewers can admit the good rows of a long run, such as 18 Monash age-rule rows, without losing them or bulk-approving. |
| **Effort** | One md5-guarded edit of the Layer 4 decide function plus a row checkbox on the AER item. About 4 to 6 hours, plus tests. |
| **Decision** | Approve / decline. |

### A2. Exclude AER items from generic bulk decide

| | |
|---|---|
| **Today** | The generic Layer 4 bulk decide can reject a whole group of AER items in one action. |
| **Proposed** | Bulk decide skips the AER kinds (`entry_matrix_first_run`, `entry_matrix_change`, `course_entry_first_read`) and says how many it skipped. AER items are decided one at a time, in the AER workspace or Layer 4. |
| **Why** | Each AER item carries quotes and country rules that need reading. A bulk reject would discard reviewed evidence and force a paid re-read. |
| **Effort** | One md5-guarded edit. About 2 hours, plus tests. |
| **Decision** | Approve (recommended) / decline. |

### A3. Who may decide AER items

| | |
|---|---|
| **Today** | The server lets a Curator (rank 3) decide AER items. The role guides ask that only the Platform Admin does so (role guides, question Q4). |
| **Option 1 (recommended for now)** | Platform Admin only, enforced on the server, until the first 241 items have been reviewed and the AER review procedure has been proven in practice. |
| **Option 2** | Curators may decide AER items, with Platform Admin sign-off for `entry_matrix_change`. |
| **Effort** | Either option is one md5-guarded role check. About 2 hours. |
| **Decision** | Option 1 / Option 2. |

### A4. Website wording for a printed requirement with no explicit scale

| | |
|---|---|
| **Today** | A row whose source prints a grade without its scale (for example "minimum 75" with no "%" or "out of") is held from the resolver. The website shows "contact the provider". |
| **Proposed wording** | "The university lists a minimum of **75** for this qualification but does not state the scale. Check with the university before applying." It is returned only when the row is admitted and the reviewer confirmed the printed number. |
| **G3 / Website API v2** | Additive only: a new optional note value on the existing response. Rendering it is website-team work. |
| **Decision** | Approve the wording / keep "contact the provider". |

### Safe reviewer procedure until A1–A3 are decided

The role guides (`../AER-ROLE-GUIDES.md` §5.6) give the detail.

1. **Decide one item at a time.** Never use bulk decide on an AER kind.
2. **Sort each item into one of four groups before deciding:**

   | Group | How to tell | What to do |
   |---|---|---|
   | **Actionable new evidence** | `pending`, on the newest stored copy, rows with quotes | Read and decide |
   | **Stale or superseded duplicate** | An older copy of a source that has a newer run, or a status of `superseded` | Reject as stale (for example Otago Polytechnic `f14ae480`) |
   | **Held incomplete read** | Not in Layer 4. The AER workspace shows it as held partial or failed. | Nothing for the reviewer. It needs an approved re-read (Part B). |
   | **Awaiting another correction** | A tuition or URL item on a course that already has a newer active value (31 tuition, 22 URL items on 30 Oct) | Check it against the current value, then decide. Do not approve over a newer value. |

3. **If some rows of a run are wrong,** reject the item with the reason until A1 is approved.

---

## Part B: bounded paid reads (Workstream 8)

### Cost basis

- **AER course read:** observed US$0.008 a course on 29 Oct, about US$0.40–0.45 per 50-course batch. The cost setting `entry.course_read_cost_usd` (US$0.005) under-estimates this. The ceilings below use the observed rate plus 25%.
- **Coverage page re-read:** at most 1 Firecrawl credit per page (a direct fetch costs nothing). The monthly limit is 100,000 credits.

Each line runs only after its own approval. Each runs through its governed route with a rolled-back dry run, and stops at its ceiling.

| # | Line | Exact scope | Expected | Hard ceiling | Stop conditions |
|---|---|---|---|---|---|
| B1 | Three source re-reads | ANU Croatian Matura, Melbourne India State Board `290bd250`, ANU `509c8f82`; through Read again (W28: newest copy only) | ≤ US$0.05 | US$0.05 | Any run fails, or a run would read an older copy |
| B2 | Three Monash course reads | `e58e7771`, `512b56fe`, `9cf18451`; worker v0.54.x reads long pages in slices (W29) | ≤ US$0.10 | US$0.10 | Any slice cut (it holds, never proposes in part) |
| B3 | AU course reading, plan order | 10 batches of 50 from 155 Monash, 182 QUT and 163 of 250 RMIT courses (500 courses) | about US$4.00 | US$6.00 | Read failure rate over 10% in a batch; any partial row admitted; spend reaches the ceiling |
| B4 | NZ course reading (choose one form) | **(a)** per NZ provider: 421 eligible NZ courses across 15 providers in about 9 batches (AUT 146, Victoria Wellington 120, Eastern 29, Ara 21, MIT 23, Auckland 23, Toi Ohomai 15, Lincoln 11, NMIT 10, Waikato 9, Otago 8, Canterbury 4, Massey 1, NorthTec 1); or **(b)** move NZ to the front of `entry.course_read_providers` | about US$3.40–3.80 | US$4.50 | As B3 |
| B5 | AU remainder (later, separately) | 3,455 further AU eligible courses after B3, in about 70 batches | about US$28–31 | per tranche of 10 batches (US$6.00 each) | As B3; one approval per tranche |
| R1 | W31 recovery: code-proved pages wrongly displaced on 29 Oct | 451 pages: set the next read now (same page). 263 pages: restore the previous address as ambiguous, then read. The page counts only if a fresh read finds the course's CRICOS code. | ≤ 714 Firecrawl credits (< 1% of the monthly limit); no AI | 714 credits | Any page bound without a fresh code proof (must be 0); a robots or blocked rate over 30% |
| R2 | Source-finder and adapter-capture recovery | None needed. The source finder retries on its own schedule once W30 is live (it was a timeout, so nothing was spent or lost). The stuck Kulin draft was superseded by the 23:40 draft. | US$0 | — | — |

**Not in this schedule (separate decisions):**
- Past-year handbook pages. 92 are held and 110 are currently eligible (WSU 2023–24 74, Monash 24, ANU 12). A CRICOS code proves which course a page is, not that the page is current. **Decision:** may AER read a past-year page, or must a current-year page be found first?
- Five adapter drafts stuck in `capturing`: cleanup by paste file.
- Edge-runtime capacity against job frequency. Several jobs fire every 30 to 60 seconds, and there were about 30–45 edge errors an hour from 21:00 AEDT on 29 Oct.
- **Admin read timeouts (Workstream 3):** about 200 in 48 h, mainly under load. Each fix needs a cached snapshot table and a catalogued job (notices, course coverage totals, scholarship publishability, field coverage).
  - **Decision:** approve the four snapshot designs for build.
- **"Why values are missing" panel:** show the last successful run time beside the snapshot label (UI only).
  - **Decision:** approve or decline.

### What one approval looks like

> "Approve B1 and B2. Approve B3 at ceiling US$6. B4 form (a). Hold B5 and R1."

Anything not named stays BLOCKED.
