# Layer 4 AER review manifest (30 Oct 2026, read live 09:55 AEDT)

**Purpose:** a stable list of the AER items waiting for one-at-a-time human review in Layer 4 › Inbox, grouped by provider, source and run, with what each needs from the reviewer. Mandate: Platform Admin, 30 Oct 2026 08:45 ("Layer 4 review enablement — immediate programme priority").

**Rules for using it:**
- This session decides **no** item.
- No generic bulk decide, bulk approve or auto approve is used (A2).
- Only the Platform Admin decides AER items (A3), through Approve all rows, Approve except, or Reject (A1).
- Kimi Work's one-at-a-time decisions are its own. None were recorded in the last 24 hours (0 AER decisions between 29 Oct 09:55 and 30 Oct 09:55 AEDT).

Regenerate with the SQL in Appendix A. Counts change as reviewers decide and as D1 reads finish.

## 1. Totals (baseline before review activity, 09:55 AEDT)

| Kind | Pending | Actionable | Not actionable | Proposed rows |
|---|---:|---:|---:|---:|
| Course first read (`course_entry_first_read`) | 961 | 961 | 0 | 3,363 |
| Provider table, first run (`entry_matrix_first_run`) | 54 | 50 | 4 (see below) | 2,168 |
| Provider table, change (`entry_matrix_change`) | 4 | 4 (decide after D4 is live) | 0 | 37 |
| **Total** | **1,019** | **1,015** | **4** | **5,568** |

**What changed since 08:24 (1,014):**
- 5 D1 probe reads were added: Monash 3, AUT 1 and QUT 1.
- The D1 step 2 reads (36 QUT) will add up to 36 more items as they finish.

**Not actionable:**
- **Otago Polytechnic item `f14ae480`, 106 rows:** a newer item on the same source is pending (`81d14690`). Decide the newer one; reject the older one as superseded by the newer read.
- **Three zero-row items: Griffith `a0e19f74`, Newcastle `5aa58072`, Victoria University of Wellington `f6941f3d`.** Each is a rendered page with no requirements table (decision W18). There are no rows to admit:
  - Approve records "the provider publishes no table here";
  - Reject records that the page does show one.

  These are quick decisions, but they admit no data.

**Held or superseded items** are not in these counts. They are decided rows already, or closed by W28 as superseded.

**Active rows today:**
- **Provider tables:** RMIT, 343 rows. Visible in the Website API `entry_matrix`.
- **Course rows:** 0.

## 2. What admission changes for the consumer

**Every provider below is Published**, so every admitted row reaches the additive Website API v2:
- **Course rows** appear in the course payload's `entry` object (`min_score`, `prerequisites`, `selection_tasks`, `requirements_note`) and in `entry.resolution` for a chosen country.
- **Provider table rows** appear in the provider payload's `entry_matrix`.

**What admission does not do:** nothing renames or removes an existing key, and admission never publishes a course that is not published.

**Website rendering is the website team's work.**

## 3. Dependencies on D4 and D5

| Dependency | Items | What the reviewer does |
|---|---|---|
| **D4 (Approve except with an active row)** | 4 RMIT `entry_matrix_change` items (Qatar, Singapore, Sri Lanka, Thailand). Each is the first read of a new country page, with 0 active rows on its own page. 0 course items have active rows | Approve all rows or Reject can be decided now. Use Approve except only after D4 is live (v2.15.374): until then an exclusion can still supersede an active row on the same source |
| **D5 (printed grade, no stated scale)** | Course rows: 414 rows print a grade with no score and no structured scale (Monash 61, RMIT 140, AUT 71, VUW 54, EIT 58 and others). Provider tables: 0 such rows (all 2,168 proposed rows carry a scale or are case by case, 423) | **Course rows:** the course reader stores no scale, so after D5 these show `scale_stated: null`. The website does not show the A4 wording for them. Check the quote and approve only when the printed grade is clear on its own. **Provider tables:** no D5 dependency |

## 4. Provider tables, by provider, source and run (58 items)

Columns: **New** is a first run and **Change** a change item. **Rows** is the proposed row count. **CbC** counts case-by-case rows (no minimum printed; shown as "assessed case by case"). **Read** is the time the run finished (AEDT). Every run's state is `done` and every row carries its quote.

| Provider | Item | Run | Kind | Source (page) | Rows | CbC | Read |
|---|---|---|---|---|---:|---:|---|
| Adelaide University | fc687e13 | f5a342af | New | AU_Undergraduate_Admission_By_Country.pdf | 27 | 0 | 29 Oct 01:45 |
| Ara Institute of Canterbury | f6b8266d | 4c3a91a2 | New | ara.ac.nz/academic-equivalence | 11 | 7 | 29 Oct 00:30 |
| AUT | 7498294a | 11d827a4 | New | …/international-student-entry-requirements | 61 | 34 | 29 Oct 03:40 |
| ANU (24 country pages) | c5dbff45, a6e3bcb2, 02bc7d80, cad93a9a, 987dac71 (B1), 11e999c9, 7e5bcc2e, b79ab7db, a8f7825c, 2d021379, 4effa6fd, e615509e, 726b51d7, e537afa9, ea9d17c9, 0210c6ac, 2b491c25 (B1), d7eedd9f, 7e66129d, daae933c, 36a9abd7, 4f6d54ad, d01d7b4f, e278c754 | one each | New | study.anu.edu.au/…/indicative-entry-requirement/<country> | 247 | 0 | 29 Oct 00:44 to 30 Oct 07:14 |
| Curtin University | 060cfa14 | 8b4e3d3b | New | 2026-Overseas-qualifications-recognised-by-Curtin-University.pdf | 33 | 0 | 29 Oct 02:36 |
| Federation University | 5e718b20 | 1f327610 | New | academic-entry-requirements-by-country-guide2.pdf | 69 | 27 | 29 Oct 14:05 |
| Flinders University | 4dc3eb81 | c52f67b1 | New | …/undergraduate-entry-requirements | 13 | 0 | 29 Oct 00:09 |
| Griffith University | a0e19f74 | c20d671a | New (no table) | …/understanding-entry-requirements | 0 | 0 | 29 Oct 10:51 |
| Lincoln University | e960bd2b | af779553 | New | …/international-undergraduate-entry-criteria | 71 | 1 | 29 Oct 11:24 |
| MIT (Manukau) | 040d7b41 | 9bbe17c9 | New | …/entry-requirements-academic | 68 | 37 | 29 Oct 11:15 |
| Unitec | 6e7ca89e | 5f583e4b | New | …/country-specific-criteria | 17 | 3 | 29 Oct 00:30 |
| Massey University | 97867f50 | 31ea7684 | New | …/entry-requirements-for-international-students | 38 | 14 | 29 Oct 00:30 |
| NMIT | cdb8ec0f | ea083a7f | New | nmit.ac.nz/international/entry-requirements | 48 | 1 | 29 Oct 11:25 |
| Otago Polytechnic | **f14ae480 (older; not actionable)** | 0d4ca5a0 | New | op.ac.nz/…/entry-requirements | 106 | 32 | 29 Oct 14:05 |
| Otago Polytechnic | 81d14690 | 55ace659 | New | op.ac.nz/…/entry-requirements | 104 | 29 | 29 Oct 14:09 |
| RMIT | 9adbeada | e07eeaf5 | **Change** (D4) | …/country-equivalency/qatar | 2 | 0 | 27 Oct 21:59 |
| RMIT | bcd9f55b | b4aecc1c | **Change** (D4) | …/country-equivalency/singapore | 9 | 0 | 27 Oct 21:54 |
| RMIT | 8a803c95 | 10995ef9 | **Change** (D4) | …/country-equivalency/sri-lanka | 13 | 0 | 27 Oct 21:54 |
| RMIT | f56bd767 | 494bcd84 | **Change** (D4) | …/country-equivalency/thailand | 13 | 0 | 27 Oct 21:54 |
| Southern Institute of Technology | 3346b371 | ecc6e4bb | New | sit.ac.nz/International/How-to-Apply | 54 | 0 | 29 Oct 00:25 |
| Swinburne | 69c1f2a9 | 1c2b177c | New | …/countries/india | 7 | 2 | 29 Oct 00:34 |
| University of Melbourne | 261f23b6, dcf9300f (B1), 1aa57791 | eb92d57d, e1870f69, 59891357 | New | …/qualifications/<India CBSE/ISC, India State Board, GCE A Levels> | 27 | 6 | 29 Oct 12:54 to 30 Oct 07:14 |
| University of Newcastle | 5aa58072 | d68f8166 | New (no table) | …/uon-agents/entry-requirements | 0 | 0 | 29 Oct 10:51 |
| UWA | a0595bd2 | 4edb1e9f | New | …/international-and-overseas-qualifications | 177 | 0 | 29 Oct 14:04 |
| University of Otago | 1cf9d91f | 9b57dda6 | New | …/international-entrance-requirements | 1 | 0 | 29 Oct 03:44 |
| UTS | 9f87d125 | 4ef170a5 | New | …/academic-entry-requirements | 41 | 20 | 29 Oct 12:54 |
| University of Waikato | 91d1be37 | c89d4995 | New | …/entry-requirements-for-international-students | 35 | 9 | 29 Oct 00:15 |
| University of Wollongong | 5cb14460 | 0ff79fe4 | New | …/international-entry-requirements | 220 | 3 | 29 Oct 14:05 |
| Victoria University | 71f21b77 | 66ee8100 | New | academic-entry-requirements-listed-by-country.pdf | 147 | 2 | 29 Oct 11:20 |
| Victoria University of Wellington | f6941f3d | 73f5d9c4 | New (no table) | wgtn.ac.nz/international/applying/entry-requirements | 0 | 0 | 29 Oct 10:51 |
| Wintec | f7c76d5d | 510cc148 | New | …/international-academic-entry-requirements | 135 | 90 | 29 Oct 11:24 |
| Western Sydney University | 763ece39 | 6f7e117b | New | INTL0910_Entry_Qualifications_v07.pdf | 367 | 81 | 29 Oct 11:20 |
| Whitireia and WelTec | f45beb27 | dd5e4890 | New | …/academic-entry-requirements | 44 | 25 | 29 Oct 02:45 |

## 5. Course first reads, by provider (961 items)

| Provider | Items | Proposed rows | Rows with a printed minimum score or grade | Printed grade, no score or scale (D5) | Course already has active rows (D4) |
|---|---:|---:|---:|---:|---:|
| Monash University | 311 | 1,080 | 400 | 61 | 0 |
| RMIT University | 299 | 1,341 | 225 | 140 | 0 |
| Auckland University of Technology | 141 | 381 | 46 | 71 | 0 |
| Victoria University of Wellington | 93 | 149 | 22 | 54 | 0 |
| Eastern Institute of Technology | 29 | 143 | 15 | 58 | 0 |
| MIT (Manukau) | 21 | 69 | 9 | 4 | 0 |
| Ara Institute of Canterbury | 20 | 55 | 0 | 2 | 0 |
| University of Auckland | 19 | 70 | 20 | 11 | 0 |
| NMIT | 10 | 30 | 2 | 1 | 0 |
| Lincoln University | 9 | 14 | 4 | 8 | 0 |
| University of Otago | 4 | 10 | 2 | 3 | 0 |
| Toi Ohomai | 2 | 7 | 1 | 1 | 0 |
| Queensland University of Technology | 2 | 12 | 8 | 0 | 0 |
| Massey University | 1 | 2 | 0 | 0 | 0 |
| **Total** | **961** | **3,363** | **754** | **414** | **0** |

**Status of every course item:**
- Each is one complete read: every slice was answered and the coverage check passed, so a held or partial read never becomes an item.
- Every row's quote is on the page; rows whose quote was not on the page were already dropped by the reader.
- No course has two pending items, and no course has active rows.
- Every course is active and its provider Published.

## 6. Suggested review order (most consumer value for the least risk)

1. **The three no-table notes** (Griffith, Newcastle, VUW), and reject the superseded Otago Polytechnic item `f14ae480`. These are quick, and they clear the queue noise.
2. **Provider tables with no case-by-case rows and a single clear source:**
   - UWA (177 rows);
   - Wollongong (220);
   - Victoria University (147);
   - Curtin (33);
   - Adelaide (27);
   - SIT (54);
   - the 24 ANU country pages (247).

   Each admission makes the provider's whole country matrix visible.
3. **Course first reads, one provider at a time.** Start with QUT, Massey, Toi Ohomai and Otago, which are small. Then work through the large sets (Monash 311, RMIT 299) in sittings.
4. **The four RMIT change items after D4 is live**, if you want to use Approve except.

## 7. Reviewer capacity (assumption, to be measured)

**The assumption:**
- About 1 minute per course item (3.5 rows on average, quote visible).
- About 3 minutes per provider table item (34 rows on average).
- The current queue then needs about 16 hours of focused review for the course items and 3 hours for the provider tables.

**Queue growth from further reads:**
- **D1, the rest:** at most about 170 course items.
- **B5, if approved:** each tranche of 550–800 courses adds about 470–690 course items, at B3's yield of 85% of reads reaching review.

**Implication:** B5 should wait until the queue is substantially reviewed. That is the mandate's condition.

## 8. Before and after reconciliation

| Count (live) | Baseline 09:55 | After review activity |
|---|---:|---|
| AER items pending | 1,019 | to be completed at handback |
| Approved / rejected today | 0 / 0 | |
| Rows proposed (course / provider table) | 3,363 / 2,205 | |
| Rows excluded (approve except) | 0 | |
| Rows superseded (provider table, all time) | 767 | |
| Rows active (course / provider table) | 0 / 343 | |
| Consumer-admitted (published providers) | RMIT provider table only | |

The provider-table proposed count here (2,205) includes rows on runs that are not pending. The pending runs carry 2,205 − 37 = 2,168 new and 37 change rows.

## Appendix A. Regeneration queries (read-only)

```sql
-- items by kind and status
select field_code, status, count(*) from pipeline.layer4_review_items
 where field_code = any (security.aer_review_kinds_v1()) group by 1, 2;
-- course items with their rows
select i.id, c.provider_id, count(x.*) filter (where x.status = 'proposed') rows_proposed
  from pipeline.layer4_review_items i join catalogue.courses c on c.id = i.entity_id
  left join catalogue.course_entry_requirements x on x.provenance->>'review_item_id' = i.id::text
 where i.field_code = 'course_entry_first_read' and i.status = 'pending' group by 1, 2;
-- provider-table items with their run and rows
select i.id, i.field_code, r.id run_id, r.source_id, count(m.*) filter (where m.status = 'proposed') rows_proposed
  from pipeline.layer4_review_items i left join pipeline.entry_matrix_runs r on r.review_item_id = i.id
  left join catalogue.provider_entry_matrix m on m.run_id = r.id
 where i.field_code in ('entry_matrix_first_run', 'entry_matrix_change') and i.status = 'pending' group by 1, 2, 3, 4;
```
