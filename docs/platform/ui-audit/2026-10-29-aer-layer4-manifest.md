# AER Layer 4 review manifest

**Total:** 106 pending items: 57 provider entry matrix items and 49 course items.

**As at:** 29 Oct 2026, about 11:45 AEDT, read live from `fxcwkweaxjtknorudmwp`.
**Authority:** Platform Admin decision 29 Oct 2026 09:57, item 6. Human authority is preserved: nothing on this list has been approved by SQL, by bulk action or because a read is complete.

**Where to act:**
- Layer 4 Review › Inbox. Filter by provider, or follow the provider's Layer 4 link in Catalogue › Entry requirements.
- Item ids are the first 8 characters of `pipeline.layer4_review_items.id`.
- Rows show how many rows the read kept and how many it did not keep.

## Summary

| Class | Items | Meaning |
|---|---|---|
| Complete: ready for review | 33 matrix items (Western Sydney included) + 48 course items | The read kept its rows with few or no losses. A person compares each row with its quote and stored copy, then approves or rejects. |
| Ready: governed decision | 4 RMIT change items, plus BH126 `cf71cca1` | Decisions already framed for the Platform Admin. BH126: approve except `dab50fa7`, per the 28 Oct decision. |
| Ready: note | 3 rendered notes (Griffith, Newcastle, Victoria University of Wellington) | Confirm "no matrix published here". Griffith and Victoria University of Wellington each had 4 rows not kept as an unknown country (regions, not countries). Reject if the page does show a country table. |
| Held: rows not kept for a named source reason | 4 (Federation, Otago Polytechnic, UWA, Wollongong) | The authorised re-read finished, but a large share of the table was not kept. The reasons are named. Do not approve as complete. **Federation stays unapproved.** |
| Partial: Read again first | 9 ANU items, each keeping 1 row of 8 to 12 | Read before worker v0.50.1 fixed numeric tables. Read again in the workspace, then review the new item. |
| Partial: Read again as HTML first | 4 (Melbourne ×3, UTS) | Read from a Firecrawl markdown copy. Read again now fetches the page as HTML. |
| Superseded by a newer read | 21 matrix items (no longer pending) | Closed by the re-reads and refetches. Not listed. |
| Duplicate or stale | 0 | No pending item has a newer read of the same source. |

**Western Sydney.** The complete replacement read (`763ece39`) kept 367 rows. 25 were not kept: 16 grade not in quote, 7 unknown country, 2 quote not on the page. It is "Complete: ready for review", but under the decision it **stays unapproved until a person confirms the source-anchored checks**. The earlier 13-row partial read was superseded, not approved.

## Provider entry matrix items (57 pending: 53 first runs, 4 RMIT changes)

| Item | Provider | Source | Kept · not kept | Not kept, by reason | Class | Read |
|---|---|---|---|---|---|---|
| `fc687e13` | Adelaide University | PDF | 27 · 1 | unknown_country 1 | Complete: ready for review | 28 Oct 14:45 |
| `f6b8266d` | Ara Institute of Canterbury | web page | 11 · 1 | grade_not_in_quote 1 | Complete: ready for review | 28 Oct 13:30 |
| `7498294a` | Auckland University of Technology | web page | 61 · 12 | unknown_country 9, quote_not_on_page 1, grade_not_in_quote 1, value_not_in_quote 1 | Complete: ready for review | 28 Oct 16:40 |
| `9385e9ab` | Australian National University | web page | 1 · 10 | quote_not_on_page 10 | Partial: Read again first | 28 Oct 13:44 |
| `8cb04c0d` | Australian National University | web page | 1 · 10 | quote_not_on_page 10 | Partial: Read again first | 28 Oct 13:44 |
| `a6e3bcb2` | Australian National University | web page | 1 · 0 | — | Complete: ready for review | 28 Oct 13:44 |
| `509c8f82` | Australian National University | web page | 1 · 4 | quote_not_on_page 4 | Complete: ready for review | 28 Oct 13:49 |
| `58df4748` | Australian National University | web page | 1 · 10 | quote_not_on_page 10 | Partial: Read again first | 28 Oct 13:55 |
| `7e02bb04` | Australian National University | web page | 1 · 10 | quote_not_on_page 10 | Partial: Read again first | 28 Oct 13:55 |
| `a0aa92e7` | Australian National University | web page | 1 · 10 | quote_not_on_page 10 | Partial: Read again first | 28 Oct 13:59 |
| `49dbf996` | Australian National University | web page | 1 · 10 | quote_not_on_page 10 | Partial: Read again first | 28 Oct 13:59 |
| `c924ca35` | Australian National University | web page | 1 · 10 | quote_not_on_page 10 | Partial: Read again first | 28 Oct 13:59 |
| `0210c6ac` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 28 Oct 14:05 |
| `563bd772` | Australian National University | web page | 1 · 11 | quote_too_short 11 | Partial: Read again first | 28 Oct 14:09 |
| `11e999c9` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 28 Oct 15:04 |
| `c5dbff45` | Australian National University | web page | 14 · 0 | — | Complete: ready for review | 28 Oct 15:04 |
| `7e5bcc2e` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 28 Oct 15:04 |
| `a8f7825c` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 28 Oct 15:09 |
| `4effa6fd` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 28 Oct 15:09 |
| `d7eedd9f` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 28 Oct 15:09 |
| `726b51d7` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 28 Oct 15:09 |
| `d01d7b4f` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 28 Oct 15:14 |
| `ba2f129c` | Australian National University | web page | 1 · 7 | quote_not_on_page 7 | Partial: Read again first | 28 Oct 15:14 |
| `36a9abd7` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 28 Oct 15:14 |
| `7e66129d` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 28 Oct 15:19 |
| `daae933c` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 28 Oct 15:19 |
| `e278c754` | Australian National University | web page | 10 · 0 | — | Complete: ready for review | 28 Oct 15:20 |
| `060cfa14` | Curtin University | PDF | 33 · 3 | unknown_country 2, band_not_in_quote 1 | Complete: ready for review | 28 Oct 15:36 |
| `381f479f` | Federation University Australia | PDF | 47 · 35 | quote_not_on_page 28, grade_not_in_quote 3, missing_quote_or_qualification 2, value_without_scale 2 | Held: rows not kept (stays unapproved) | 29 Oct 00:19 |
| `4dc3eb81` | Flinders University | web page | 13 · 1 | unknown_country 1 | Complete: ready for review | 28 Oct 13:09 |
| `a0e19f74` | Griffith University | rendered note | 0 · 4 | unknown_country 4 | Ready: note (confirm no matrix published) | 28 Oct 23:51 |
| `e960bd2b` | Lincoln University | web page (HTML refetch) | 71 · 9 | unknown_country 5, low_confidence 2, band_not_in_quote 1, value_not_in_quote 1 | Complete: ready for review | 29 Oct 00:24 |
| `040d7b41` | Manukau Institute of Technology (MIT) | web page | 68 · 8 | grade_not_in_quote 4, value_without_scale 2, unknown_country 2 | Complete: ready for review | 29 Oct 00:15 |
| `6e7ca89e` | Unitec | web page | 17 · 2 | quote_not_on_page 2 | Complete: ready for review | 28 Oct 13:30 |
| `97867f50` | Massey University | web page | 38 · 3 | grade_not_in_quote 1, low_confidence 1, unknown_country 1 | Complete: ready for review | 28 Oct 13:30 |
| `cdb8ec0f` | NMIT | web page (HTML refetch) | 48 · 2 | unknown_country 2 | Complete: ready for review | 29 Oct 00:25 |
| `5e40fcd8` | Otago Polytechnic | web page (HTML refetch) | 71 · 62 | quote_not_on_page 45, grade_not_in_quote 11, unknown_country 4, value_without_scale 1, value_not_in_quote 1 | Held: rows not kept for a named source reason | 29 Oct 00:21 |
| `bcd9f55b` | RMIT University (Singapore page) | web page | 9 · 0 | — | Ready: governed decision (RMIT change) | 27 Oct 10:54 |
| `f56bd767` | RMIT University (Thailand page) | web page | 13 · 0 | — | Ready: governed decision (RMIT change) | 27 Oct 10:54 |
| `8a803c95` | RMIT University (Sri Lanka page) | web page | 13 · 0 | — | Ready: governed decision (RMIT change) | 27 Oct 10:54 |
| `9adbeada` | RMIT University (Qatar page) | web page | 2 · 0 | — | Ready: governed decision (RMIT change) | 27 Oct 10:59 |
| `3346b371` | Southern Institute of Technology | web page | 54 · 6 | grade_not_in_quote 4, unknown_country 2 | Complete: ready for review | 28 Oct 13:25 |
| `69c1f2a9` | Swinburne University of Technology | web page | 7 · 0 | — | Complete: ready for review | 28 Oct 13:34 |
| `45f8b3c9` | The University of Melbourne | web page (markdown copy) | 15 · 0 | — | Partial: Read again as HTML first | 28 Oct 15:39 |
| `e5b2a9b4` | The University of Melbourne | web page (markdown copy) | 9 · 0 | — | Partial: Read again as HTML first | 28 Oct 15:39 |
| `b8de43e2` | The University of Melbourne | web page (markdown copy) | 9 · 0 | — | Partial: Read again as HTML first | 28 Oct 15:44 |
| `5aa58072` | The University of Newcastle | rendered note | 0 · 0 | — | Ready: note (confirm no matrix published) | 28 Oct 23:51 |
| `c70b3d2a` | The University of Western Australia | web page | 50 · 136 | band_not_in_quote 101, quote_not_on_page 27, value_not_in_quote 8 | Held: rows not kept for a named source reason | 29 Oct 00:14 |
| `1cf9d91f` | University of Otago | web page | 1 · 6 | unknown_country 6 | Complete: ready for review | 28 Oct 16:44 |
| `921422a0` | University of Technology Sydney (UTS) | web page (markdown copy) | 40 · 5 | quote_not_on_page 2, grade_not_in_quote 2, unknown_country 1 | Partial: Read again as HTML first | 26 Oct 11:45 |
| `91d1be37` | University of Waikato | web page | 35 · 3 | grade_not_in_quote 2, unknown_country 1 | Complete: ready for review | 28 Oct 13:15 |
| `50b5cbf6` | University of Wollongong | web page | 175 · 96 | quote_not_on_page 75, unknown_country 12, band_not_in_quote 4, low_confidence 4, value_not_in_quote 1 | Held: rows not kept for a named source reason | 29 Oct 00:15 |
| `71f21b77` | Victoria University | PDF | 147 · 6 | unknown_country 5, grade_not_in_quote 1 | Complete: ready for review | 29 Oct 00:20 |
| `f6941f3d` | Victoria University of Wellington | rendered note | 0 · 4 | unknown_country 4 | Ready: note (confirm no matrix published) | 28 Oct 23:51 |
| `f7c76d5d` | Waikato Institute of Technology (Wintec) | web page (HTML refetch) | 135 · 24 | quote_not_on_page 15, grade_not_in_quote 3, unknown_country 3, low_confidence 2, value_not_in_quote 1 | Complete: ready for review | 29 Oct 00:24 |
| `763ece39` | Western Sydney University | PDF | 367 · 25 | grade_not_in_quote 16, unknown_country 7, quote_not_on_page 2 | Complete: ready for review (stays unapproved until a person confirms) | 29 Oct 00:20 |
| `f45beb27` | Whitireia and WelTec | web page | 44 · 2 | grade_not_in_quote 1, unknown_country 1 | Complete: ready for review | 28 Oct 15:45 |

## Course entry items (49 pending, `course_entry_first_read`)

Each course read opens one item. The rows are the course page's own requirements: a minimum with its printed basis, a prior qualification, a prerequisite, or a general note. None infers international applicability.

| Item | Course | Code | Rows | Class |
|---|---|---|---|---|
| `cf71cca1` | RMIT Bachelor of Engineering (Honours) BH126 | 0100714 | 3 | Governed decision (28 Oct): approve except `dab50fa7`, then Read from the stored page once |
| `bee8bdcc` | Monash Bachelor of Accounting | 097256G | 4 | Complete: ready for review |
| `70344309` | Monash Bachelor of Actuarial Science | 097257F | 2 | Complete: ready for review |
| `db416fd6` | Monash Bachelor of Actuarial Science and Master of Actuarial Studies | 113701J | 6 | Complete: ready for review |
| `bd527972` | Monash Bachelor of Applied Data Science | 099359F | 4 | Complete: ready for review |
| `75d8d50b` | Monash Bachelor of Applied Data Science Advanced (Honours) | 099360B | 3 | Complete: ready for review |
| `306ea6d5` | Monash Bachelor of Architectural Design | 059372G | 1 | Complete: ready for review |
| `7dbd8b8d` | Monash Bachelor of Architectural Design and Master of Architecture | 090745B | 2 | Complete: ready for review |
| `0474ba53` | Monash Bachelor of Architectural Studies and Bachelor of Business | 117721F | 2 | Complete: ready for review |
| `4335116e` | Monash Bachelor of Architectural Studies and Bachelor of Design | 117722E | 5 | Complete: ready for review |
| `92c9efa7` | Monash Bachelor of Architectural Studies and Bachelor of Fine Art | 117724C | 1 | Complete: ready for review |
| `3ed11337` | Monash Bachelor of Architectural Studies and Bachelor of Global Studies | 120810A | 3 | Complete: ready for review |
| `24f5677c` | Monash Bachelor of Architectural Studies and Bachelor of Information Technology | 117723D | 6 | Complete: ready for review |
| `c8bbc612` | Monash Bachelor of Art History and Curating and Bachelor of Business | 119809D | 3 | Complete: ready for review |
| `c5a04d93` | Monash Bachelor of Art History and Curating and Bachelor of Media Communication | 119810M | 6 | Complete: ready for review |
| `f76c199a` | Monash Bachelor of Artificial Intelligence | 120433K | 6 | Complete: ready for review |
| `e85c2f45` | Monash Bachelor of Artificial Intelligence and Bachelor of Biomedical Science | 121111J | 5 | Complete: ready for review |
| `c2a95999` | Monash Bachelor of Arts | 075404D | 4 | Complete: ready for review |
| `1f42e432` | Monash Bachelor of Arts (Honours) | 084608F | 6 | Complete: ready for review |
| `b691807f` | Monash Bachelor of Arts and Bachelor of Art History and Curating | 120808F | 5 | Complete: ready for review |
| `b3995c18` | Monash Bachelor of Arts and Bachelor of Criminology | 0101331 | 6 | Complete: ready for review |
| `1f7f21f3` | Monash Bachelor of Arts and Bachelor of Fine Art | 075402F | 2 | Complete: ready for review |
| `9040c604` | Monash Bachelor of Arts and Bachelor of Global Studies | 113071A | 6 | Complete: ready for review |
| `a5606e0e` | Monash Bachelor of Arts and Bachelor of Health Sciences | 111153D | 6 | Complete: ready for review |
| `2f48382d` | Monash Bachelor of Arts and Bachelor of Media Communication | 113072M | 6 | Complete: ready for review |
| `52183be7` | Monash Bachelor of Arts and Bachelor of Music | 041539C | 4 | Complete: ready for review |
| `b890840c` | Monash Bachelor of Banking and Finance | 084684E | 6 | Complete: ready for review |
| `e51cfb00` | Monash Bachelor of Biomedical Science | 028805K | 4 | Complete: ready for review |
| `f21b5f68` | Monash Bachelor of Biomedical Science (Honours) | 041538D | 3 | Complete: ready for review |
| `3e23219d` | Monash Bachelor of Business | 056414D | 6 | Complete: ready for review |
| `f2a790e8` | Monash Bachelor of Business Administration | 079046M | 6 | Complete: ready for review |
| `128ad449` | Monash Bachelor of Business and Bachelor of Accounting | 086377M | 4 | Complete: ready for review |
| `aa9a2c58` | Monash Bachelor of Business and Bachelor of Arts | 077153B | 5 | Complete: ready for review |
| `0bf6dbb0` | Monash Bachelor of Business and Bachelor of Banking and Finance | 086378K | 3 | Complete: ready for review |
| `149e71b5` | Monash Bachelor of Business and Bachelor of Information Technology | 085441E | 5 | Complete: ready for review |
| `b318efcb` | Monash Bachelor of Business and Bachelor of International Relations | 118023B | 1 | Complete: ready for review |
| `aaa43a35` | Monash Bachelor of Business and Bachelor of Marketing | 086379J | 6 | Complete: ready for review |
| `46d97ded` | Monash Bachelor of Business and Bachelor of Media Communication | 094680D | 3 | Complete: ready for review |
| `ee541559` | Monash Bachelor of Climate, Society and Economy | 121272C | 2 | Complete: ready for review |
| `06287442` | Monash Bachelor of Commerce | 013382G | 2 | Complete: ready for review |
| `890c3fba` | Monash Bachelor of Commerce (Honours) | 083903G | 3 | Complete: ready for review |
| `64cdba3b` | Monash Bachelor of Commerce and Bachelor of Actuarial Science | 097258E | 3 | Complete: ready for review |
| `38d64306` | Monash Bachelor of Commerce and Bachelor of Arts | 013385D | 2 | Complete: ready for review |
| `982e76a5` | Monash Bachelor of Commerce and Bachelor of Biomedical Science | 084690G | 6 | Complete: ready for review |
| `05fbda49` | Monash Bachelor of Commerce and Bachelor of Computer Science | 085151D | 5 | Complete: ready for review |
| `f3bb6df0` | Monash Bachelor of Commerce and Bachelor of Economics | 021276J | 2 | Complete: ready for review |
| `1650bc70` | Monash Bachelor of Commerce and Bachelor of Finance | 086382C | 5 | Complete: ready for review |
| `11179e72` | Monash Bachelor of Commerce and Bachelor of Global Studies | 083204A | 6 | Complete: ready for review |
| `a8eff3ab` | Monash Bachelor of Commerce and Bachelor of Information Technology | 085443C | 5 | Complete: ready for review |

**Reviewer notes for the Monash course items.** Most rows are domestic ATARs or Monash pathway scores (Foundation Year, Diploma, Advanced Preparation Program), each with its printed basis. Some rows are general notes, such as "at least 17 years of age at enrolment". Reject a row that is not an academic entry requirement. Only active rows reach the website, through the existing course `entry` payload.
