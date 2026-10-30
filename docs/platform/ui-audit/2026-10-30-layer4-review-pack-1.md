# Layer 4 AER review pack 1 (30 Oct 2026, read live 16:48 AEDT)

**Who it is for:** the Platform Admin reviewer, working through Layer 4 › Inbox one item at a time (A1–A3, D4). It follows manifest §6 steps 1 and 2.

**What it does:**
- gives each item's source, its stored copy (evidence id) and its run hash;
- picks out the rows to check against the stored copy before approving.

**What it does not do:**
- **This session decides nothing.** Decisions are the reviewer's.
- No bulk, automatic or batch decide.

**State at 16:48:** 1,055 pending (997 course reads, 54 provider-table first runs, 4 change items). 0 decided since 29 Oct.

## The rules that matter for these items

- **Approve all rows:** only when every row's quote is on the stored copy, the country, level and qualification are right, and the scale is as printed.
- **Approve except:**
  - Tick the wrong rows and give one reason.
  - **D4:** an active row whose replacement you tick out stays active (it applies only to RMIT change items; none of the items below has active rows).
  - A clash between approved rows holds the decision with nothing changed.
- **Unscaled grades (A4, role guide §5.2):**
  - A row whose printed grade has no stated scale (for example "An overall grade of 4") must not be approved with a scale the reader supplied.
  - **Until D5 is live, exclude such rows** with the reason "no grading scale stated on the page".
  - D5 is blocked: the paste is not live, see the live status.
  - After D5 is live, these rows can be kept, recorded as "Not stated on the page".
- **Band ladders** (a row per band, the quote a table row such as `70 | 324 | 446 | 522 …`):
  - The quote does not include the column header.
  - Open the stored copy and confirm which column the minimum came from and what scale that column states.
  - If the page does not make the column and scale clear, exclude the band rows with that reason.

## Step 1: queue noise (no data admitted)

| Item | Provider | Source | Stored copy | What the read found | Reviewer action |
|---|---|---|---|---|---|
| `a0e19f74` | Griffith University | griffith.edu.au/apply/international/understanding-entry-requirements | `ada19786` | Rendered page with no requirements table (4 candidate rows dropped) | Approve to record "no table here", or Reject if the stored copy shows a table |
| `5aa58072` | University of Newcastle | newcastle.edu.au/…/uon-agents/entry-requirements | `4e611830` | Rendered page with no requirements table | As above |
| `f6941f3d` | Victoria University of Wellington | wgtn.ac.nz/international/applying/entry-requirements | `f235a4fd` | Rendered page with no requirements table (4 dropped) | As above |
| `f14ae480` | Otago Polytechnic | op.ac.nz/…/entry-requirements (run hash `fb572a9f`) | `62aa74ff` | Superseded by the newer read `81d14690` (hash `370a12ce`) of the same page | **Reject** as superseded by the newer read; decide `81d14690` instead |

## Step 2: provider tables with one clear source

**About the flag column:** "Grades to check" counts rows whose printed grade has no scale word (%, GPA, points, out of, letter). Most are bare numbers taken from a table, where the scale sits in a column header that the quote does not include. The flag is a prompt to look, not a finding.

| Item | Provider | Source (stored copy) | Rows | Countries | Band rows | Grades to check | Checks before approving |
|---|---|---|---:|---:|---:|---:|---|
| `060cfa14` | Curtin University | 2026-Overseas-qualifications-recognised-by-Curtin-University.pdf (`3eb25964`) | 33 | 27 | 0 | 2 | **DE** "An overall grade of 4." and **FR** "An overall grade of 10." print no scale. The reader set `points`, so exclude both under A4 until D5 is live. Three rows are case by case ("Successfully completed": FI, NL, SE). Rows with a printed scale (%, points tables, GPA) read as printed |
| `fc687e13` | Adelaide University | AU_Undergraduate_Admission_By_Country.pdf (`4d15ff28`) | 27 | 22 | 0 | 0 | **AU** "Selection Rank (ATAR) of at least 70" carries `points`; the ATAR is a rank, so confirm you accept this scale label or exclude it. **KR** "Minimum score of 300" prints no scale; check the stored copy. US is case by case |
| `3346b371` | Southern Institute of Technology | sit.ac.nz/International/How-to-Apply (`05c18010`) | 54 | 29 | 0 | 3 | NC "minimum grade 12" and "minimum grade 10", and BN "2xE grade": check the scale on the stored copy |
| `71f21b77` | Victoria University | academic-entry-requirements-listed-by-country.pdf (`9204ad87`) | 147 | 24 | 3 | 17 | Mostly table values (MY, LK, ID, NG): confirm each column's scale on the PDF |
| `a0595bd2` | University of Western Australia | …/international-and-overseas-qualifications (`5a1824fd`) | 177 | 15 | 170 | 177 | **A band ladder across 15 qualifications.** Every row is a table cell (for example GB 7–18; DE 1.5–3.6, where a lower number is better; CN Gao Kao 324…). Confirm on the stored copy that each minimum came from the column the reader chose and that its header states the scale. This is the largest single item, so plan a sitting for it |
| `5cb14460` | University of Wollongong | …/international-entry-requirements (`0f573983`) | 220 | 36 | 14 | 137 | Mixed tables (KR CSAT, VN, TH, DE, JP and others). The same column-and-scale check applies; 24 rows were already dropped by the reader |
| ANU (24 items) | Australian National University | study.anu.edu.au/…/indicative-entry-requirement/&lt;country&gt; | 247 | 24 | most | see note | Each page is one country's band ladder. Items for **China (`0210c6ac`), Croatia (`2b491c25`), Hong Kong (`7e66129d`), Bosnia (`987dac71`), Austria (`a6e3bcb2`), AP (`c5dbff45`), ACT (`d01d7b4f`) and Vietnam (`e278c754`)** have bare numbers, so check the scale on each stored copy. The other 16 items print their scale in the grade |

## After each sitting

Re-run manifest Appendix A, or ask for the reconciliation. It covers:
- items decided;
- rows approved, excluded and rejected;
- active rows created and retained;
- decisions held;
- courses and countries that now resolve in the consumer API.

It is recorded in the live status and the next handback.
