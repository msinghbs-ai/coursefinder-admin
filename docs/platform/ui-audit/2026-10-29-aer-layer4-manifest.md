# AER Layer 4 review manifest

**Total:** 205 pending items: 57 provider entry matrix items and 148 course items.

**As at:** 29 Oct 2026, about 14:35 AEDT, read live from `fxcwkweaxjtknorudmwp`. It was refreshed after programme batch 3: the four corrected sources were read on worker v0.52.0, and Monash course batch 3 finished.
**Authority:** Platform Admin decision 29 Oct 2026 09:57, item 6, and mandate 29 Oct 2026 12:23, B5. Human authority is preserved: nothing on this list has been approved by SQL, by bulk action or because a read is complete.

**Where to act:**
- Layer 4 Review › Inbox. Filter by provider, or follow the provider's Layer 4 link in Catalogue › Entry requirements.
- Item ids are the first 8 characters of `pipeline.layer4_review_items.id`.
- "Kept · not kept" is what the read sent to review and what the admission gates refused.

## Summary

| Class | Items | Meaning |
|---|---|---|
| Complete: ready for review | 43 matrix items + 148 course items | The read kept its rows with few losses. A person compares each row with its quote and stored copy, then approves or rejects. |
| Complete: stays unapproved until a person reviews | 2 (Federation `5e718b20`, Western Sydney `763ece39`) | Complete replacement reads. Under the mandate they are not approved as a batch; a person reviews them row by row. |
| Ready: governed decision | 4 RMIT change items | Decisions already framed for the Platform Admin. |
| Ready: note | 3 (Griffith, Newcastle, Victoria University of Wellington) | Confirm "no matrix published here". The rows not kept are regions, not countries. |
| Held for judgement: large share not kept | 1 (Otago Polytechnic `81d14690`) | v0.52.0 read: 104 kept, 30 refused by the gates (17 grade not in quote, 9 value without scale). Review the kept rows; the refusals are not admitted. |
| Stale: older stored copy | 1 (Otago Polytechnic `f14ae480`) | Read again re-ran the 28 Oct stored copy as well as the 29 Oct copy. Review `81d14690` (the 29 Oct copy) and reject this one as superseded. |
| Partial: re-read required | 3 (ANU `509c8f82`, Melbourne India State Board `290bd250`, Otago `1cf9d91f`) | One row kept. ANU `509c8f82` and Melbourne `290bd250` have used their approved attempt and are not retried without a new decision. Otago `1cf9d91f`'s six refusals are regions. |
| Superseded by a newer read | 765 matrix rows (no longer pending) | Closed by the re-reads. Not listed. |

**Batch 3 corrections (worker v0.52.0, quotes read with their table structure; every gate unchanged).** Figures are kept / not kept.

| Source | Before (v0.51.0) | After (v0.52.0) |
|---|---|---|
| Wollongong | 175 / 96 | 220 / 24 |
| Federation | 47 / 35 | 69 / 7 |
| UWA | 50 / 136 | 177 / 8 |
| Otago Polytechnic | 71 / 62 | 104 / 30 |

**Batch 2 Read again (13 approved actions).**
- ANU: 8 pages now keep 11 or 12 rows each (was 1).
- ANU Croatian Matura: kept 0 of 8. The header and the row were quoted together, a form v0.52.0 now accepts; the approved attempt is used, so there is no item.
- Melbourne: 2 pages keep 9 each; the India State Board page kept 1 of 8 (`290bd250`).
- UTS: kept 41 of 46.

## Provider entry matrix items (57 pending: 53 first runs, 4 RMIT changes)

| Item | Provider | Source | Kept · not kept | Not kept, by reason | Class | Read · worker |
|---|---|---|---|---|---|---|
| `fc687e13` | Adelaide University | PDF | 27 · 1 | unknown_country 1 | Complete: ready for review | 29 Oct 01:45 · v0.50.1 |
| `f6b8266d` | Ara Institute of Canterbury | web page | 11 · 1 | grade_not_in_quote 1 | Complete: ready for review | 29 Oct 00:30 · v0.49.1 |
| `7498294a` | Auckland University of Technology | web page | 61 · 12 | unknown_country 9, quote_not_on_page 1, grade_not_in_quote 1, value_not_in_quote 1 | Complete: ready for review | 29 Oct 03:40 · v0.50.2 |
| `a6e3bcb2` | Australian National University | web page | 1 · 0 | — | Complete: ready for review | 29 Oct 00:44 · v0.49.1 |
| `509c8f82` | Australian National University | web page | 1 · 4 | quote_not_on_page 4 | Partial: re-read required | 29 Oct 00:49 · v0.49.2 |
| `0210c6ac` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 01:05 · v0.49.2 |
| `11e999c9` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 02:04 · v0.50.1 |
| `c5dbff45` | Australian National University | web page | 14 · 0 | — | Complete: ready for review | 29 Oct 02:04 · v0.50.1 |
| `7e5bcc2e` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 02:04 · v0.50.1 |
| `a8f7825c` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 02:09 · v0.50.1 |
| `4effa6fd` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 02:09 · v0.50.1 |
| `d7eedd9f` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 02:09 · v0.50.1 |
| `726b51d7` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 02:09 · v0.50.1 |
| `d01d7b4f` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 02:14 · v0.50.1 |
| `36a9abd7` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 02:14 · v0.50.1 |
| `7e66129d` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 02:19 · v0.50.1 |
| `daae933c` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 02:19 · v0.50.1 |
| `e278c754` | Australian National University | web page | 10 · 0 | — | Complete: ready for review | 29 Oct 02:20 · v0.50.1 |
| `cad93a9a` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 12:45 · v0.51.0 |
| `02bc7d80` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 12:45 · v0.51.0 |
| `b79ab7db` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 12:45 · v0.51.0 |
| `2d021379` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 12:45 · v0.51.0 |
| `ea9d17c9` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 12:49 · v0.51.0 |
| `e537afa9` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 12:49 · v0.51.0 |
| `e615509e` | Australian National University | web page | 11 · 0 | — | Complete: ready for review | 29 Oct 12:49 · v0.51.0 |
| `4f6d54ad` | Australian National University | web page | 12 · 0 | — | Complete: ready for review | 29 Oct 12:54 · v0.51.0 |
| `060cfa14` | Curtin University | PDF | 33 · 3 | unknown_country 2, band_not_in_quote 1 | Complete: ready for review | 29 Oct 02:36 · v0.50.1 |
| `5e718b20` | Federation University Australia | PDF | 69 · 7 | quote_not_on_page 2, missing_quote_or_qualification 2, value_without_scale 2, grade_not_in_quote 1 | Complete: stays unapproved until a person reviews | 29 Oct 14:05 · v0.52.0 |
| `4dc3eb81` | Flinders University | web page | 13 · 1 | unknown_country 1 | Complete: ready for review | 29 Oct 00:09 · v0.49.1 |
| `a0e19f74` | Griffith University | web page | 0 · 4 | unknown_country 4 | Ready: note | 29 Oct 03:44 · v0.50.2 |
| `e960bd2b` | Lincoln University | web page | 71 · 9 | unknown_country 5, low_confidence 2, band_not_in_quote 1, value_not_in_quote 1 | Complete: ready for review | 29 Oct 11:24 · v0.51.0 |
| `040d7b41` | Manukau Institute of Technology and Unitec - MIT | web page | 68 · 8 | grade_not_in_quote 4, value_without_scale 2, unknown_country 2 | Complete: ready for review | 29 Oct 11:15 · v0.51.0 |
| `6e7ca89e` | Manukau Institute of Technology and Unitec - Unitec | web page | 17 · 2 | quote_not_on_page 2 | Complete: ready for review | 29 Oct 00:30 · v0.49.1 |
| `97867f50` | Massey University | web page | 38 · 3 | grade_not_in_quote 1, low_confidence 1, unknown_country 1 | Complete: ready for review | 29 Oct 00:30 · v0.49.1 |
| `cdb8ec0f` | Nelson Marlborough Institute of Technology (NMIT) | web page | 48 · 2 | unknown_country 2 | Complete: ready for review | 29 Oct 11:25 · v0.51.0 |
| `f14ae480` | Otago Polytechnic | web page | 106 · 28 | grade_not_in_quote 17, value_without_scale 9, unknown_country 2 | Stale: older stored copy | 29 Oct 14:05 · v0.52.0 |
| `81d14690` | Otago Polytechnic | web page | 104 · 30 | grade_not_in_quote 17, value_without_scale 9, low_confidence 2, unknown_country 2 | Held for judgement: large share not kept | 29 Oct 14:09 · v0.52.0 |
| `bcd9f55b` | RMIT University (RMIT) | web page | 9 · 0 | — | Ready: governed decision | 27 Oct 21:54 · v0.48.8 |
| `f56bd767` | RMIT University (RMIT) | web page | 13 · 0 | — | Ready: governed decision | 27 Oct 21:54 · v0.48.8 |
| `8a803c95` | RMIT University (RMIT) | web page | 13 · 0 | — | Ready: governed decision | 27 Oct 21:54 · v0.48.8 |
| `9adbeada` | RMIT University (RMIT) | web page | 2 · 0 | — | Ready: governed decision | 27 Oct 21:59 · v0.48.8 |
| `3346b371` | Southern Institute of Technology | web page | 54 · 6 | grade_not_in_quote 4, unknown_country 2 | Complete: ready for review | 29 Oct 00:25 · v0.49.1 |
| `69c1f2a9` | Swinburne University of Technology | web page | 7 · 0 | — | Complete: ready for review | 29 Oct 00:34 · v0.49.1 |
| `1aa57791` | The University of Melbourne (UniMelb) | web page | 9 · 0 | — | Complete: ready for review | 29 Oct 12:54 · v0.51.0 |
| `290bd250` | The University of Melbourne (UniMelb) | web page | 1 · 8 | quote_not_on_page 8 | Partial: re-read required | 29 Oct 12:54 · v0.51.0 |
| `261f23b6` | The University of Melbourne (UniMelb) | web page | 9 · 0 | — | Complete: ready for review | 29 Oct 12:59 · v0.51.0 |
| `5aa58072` | The University of Newcastle (UoN) | web page | 0 · 0 | — | Ready: note | 29 Oct 02:49 · v0.50.1 |
| `a0595bd2` | The University of Western Australia | web page | 177 · 8 | value_not_in_quote 8 | Complete: ready for review | 29 Oct 14:04 · v0.52.0 |
| `1cf9d91f` | University of Otago | web page | 1 · 6 | unknown_country 6 | Partial: re-read required (refusals are regions) | 29 Oct 03:44 · v0.50.2 |
| `9f87d125` | University of Technology Sydney (UTS) | web page | 41 · 5 | grade_not_in_quote 3, quote_not_on_page 1, unknown_country 1 | Complete: ready for review | 29 Oct 12:54 · v0.51.0 |
| `91d1be37` | University of Waikato | web page | 35 · 3 | grade_not_in_quote 2, unknown_country 1 | Complete: ready for review | 29 Oct 00:15 · v0.49.1 |
| `5cb14460` | University of Wollongong | web page | 220 · 24 | unknown_country 19, low_confidence 4, quote_not_on_page 1 | Complete: ready for review | 29 Oct 14:05 · v0.52.0 |
| `71f21b77` | Victoria University | PDF | 147 · 6 | unknown_country 5, grade_not_in_quote 1 | Complete: ready for review | 29 Oct 11:20 · v0.51.0 |
| `f6941f3d` | Victoria University of Wellington | web page | 0 · 4 | unknown_country 4 | Ready: note | 29 Oct 02:44 · v0.50.1 |
| `f7c76d5d` | Waikato Institute of Technology | web page | 135 · 24 | quote_not_on_page 15, grade_not_in_quote 3, unknown_country 3, low_confidence 2, value_not_in_quote 1 | Complete: ready for review | 29 Oct 11:24 · v0.51.0 |
| `763ece39` | Western Sydney University | PDF | 367 · 25 | grade_not_in_quote 16, unknown_country 7, quote_not_on_page 2 | Complete: stays unapproved until a person reviews | 29 Oct 11:20 · v0.51.0 |
| `f45beb27` | Whitireia and WelTec | web page | 44 · 2 | grade_not_in_quote 1, unknown_country 1 | Complete: ready for review | 29 Oct 02:45 · v0.50.1 |

## Course items (148 pending, Course entry first read)

| Provider | Items | Rows for review | Not kept by the gates |
|---|---|---|---|
| Monash University (batches 1–3) | 145 | 582 | 746 |
| RMIT University (DP020 and two earlier reads) | 3 | 7 | 4 |

Not kept across all course reads: quote_not_on_page 286, over_row_limit 238 (rows beyond the per-course limit), score_without_basis 214, others 8.

**Reviewer-judgement notes (mandate B3: flag, do not auto-publish or auto-reject).** 589 course rows are proposed: 323 minimum grade, 139 prior qualification, 62 subject prerequisite, 46 general note and 19 portfolio or interview.
- **Age rules:** 18 proposed rows repeat Monash's university-wide age rule ("At the time of enrolment in a course at Monash University, you must be at least 17 years of age"), or one course's 18-years rule (`ab822c0f`).
  - 14 are general notes.
  - Four are filed under another kind and need particular care: `68faa8c8` and `ab822c0f` as minimum grade, `32dbbc73` and `d48c936e` as prior qualification.
  - Whether an age rule is an academic entry requirement is the reviewer's decision.
- **Other general notes:** the remaining 32 are generic wording for reviewer judgement.

## What reaches the website and Zoho

Only RMIT's 343 active matrix rows. Every other row above is proposed and is not returned by the consumer API until a person approves it in Layer 4. The consumer API is unchanged (Decision 266).
