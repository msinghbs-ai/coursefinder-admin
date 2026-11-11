# AER mandate 12 Nov 2026 09:23: response and production state (11:00 AEDT)

Mandate (Platform Admin, 12 Nov 2026 09:23): continue both AER workstreams under the Operating Model; merge on green CI except consumer API changes (Operating Model v1.15, rule 9); fix the reader faults at the reader level; course grid linking; reissue the interrupted dry run; recover the ~6,000 held minimums; UTas evidence; production reporting.

## Releases (all merged on green CI, deployed, verified live)
| PR | What | Live check |
|---|---|---|
| #1050 | F-AER.08: aligned PDF grid reader, course links (`catalogue.entry_course_links`), Layer 4 course-link panel, worker v0.73.0 | migration applied; four md5-guarded edits live; worker answers v0.73.0; 15 waiting labels linked, 76 unresolved; the same 8 items approvable |
| #1052 | Grid re-read of UNSW, Sydney, UQ (stored copies, no model, no Firecrawl) | Sydney 1,869 rows + 178 qualification rows, 0 dropped; UQ 1,268 + 162 (28 N/A cells); UNSW stopped (see below) |
| #1053 | F-AER.10 reusable reader fixes, worker v0.74.0 | settings on; GCE_O and BTEC_NED served; worker answers v0.74.0 |
| #1054 | Production verification: printed course in the row identity; ATAR a course fact; one stored PDF per worker call (v0.74.1); grid reads read again | deploy green (md5 guard and post-checks passed) |
| #1055 | Course-title key indexes; UNSW read again | open: merges after its live dry run |

## Production verification failures found and corrected (root cause, not retries)
1. **Same identity** (Sydney 168 groups / 630 rows, UQ 47 / 117): several printed streams of one CRICOS course ("B Science", "(Advanced)", "(Health)") collided. Fix: the printed course is part of the row identity (#1054). Dry run: 0 groups.
2. **ATAR column** (Sydney 89, UQ 49): read as an Australian qualification row; the gate's rule refuses a rank as a qualification's minimum. Fix: ATAR is a course fact (#1054). Fixture counts without it: UNSW 1,932 + 260, Sydney 1,780 + 178, UQ 1,214 + 162 = 5,526 minimums.
3. **UNSW CPU limit**: the three PDFs were read in one worker call; UNSW was stopped after Sydney and UQ. Fix: one stored PDF per call (v0.74.1, `reading.entry_pdf_per_call`).
4. **UNSW statement timeout** (`svc_entry_matrix_record`): title linking computed 667 courses' title keys per new label. Fix: expression indexes (#1055).

## Workstream A: reader fixes (v0.74.0, reusable)
| Fault | Universities | Fix |
|---|---|---|
| Heading + cell quote not on the page | CSU 16, CDU 8, UTS 2, Curtin, Federation | quote proven by its parts, in order, within 600 characters |
| Band with its label | UWA 41 | printed number only, when the label names a rank word |
| Invented range midpoint | UWA China 8 | the range's printed lower bound (existing switch, on) |
| Subject rows of one identity | UWA AP, HKDSE | one subject-prerequisite row (existing switch, on) |
| Count with no scale | Federation 2, Curtin College 2 | printed grade kept, no number (existing switch, on) |
| No country (AQF) | Wollongong 7 | AQF=AU (governed list) |
| Unknown qualification | VU (GCE O Level), VUW (BTEC) | added to `ref.aer_qualifications` |

Re-reads after v0.74.0 (from #1048): Adelaide 40 rows + 1 qualification row, 0 dropped (Approve except available, 1 flagged row); Federation 77 / 5 dropped; Charles Darwin 43 / 12; UWA 185 / 8 dropped, 41 band, 2 duplicate groups. The v0.74.0 re-read of UWA, Federation, CDU, CSU, UTS, Curtin, Wollongong and VU is next (one model read each; stored copies, no Firecrawl).

## Course links (decision 2)
- Sydney: 89 of 89 course labels by CRICOS code; every one of its 1,869 rows linked.
- UQ: 49 by exact title and level, 5 wait for a person (1,150 of 1,268 rows linked).
- UNSW: 44 of 65 by title expected (fixture measurement); its read follows #1055.
- Earlier AI-read course labels: 15 linked by title; 76 unresolved, most of them study areas or subjects the AI reader put in the course field ("Arts", "Biology", "recognised University"): a reader item, not a linking one.
- AI suggestions with a pinned, qualified model: next (until then, suggestions by shared title words; nothing links by itself).

## UTas (prepared for the Platform Admin; human decisions)
Both items are complete by D-R3 (27 rows, 20 countries, IB and GCE A Level, 0 dropped, current stored copies of two UTas pages). 25 of 27 rows are identical; the 2 others differ only in naming, and 5284a753 keeps the board names exactly as printed ("India Accepted State Boards of Education ..."). Proposed: approve 5284a753; reject 73615b9a as a duplicate. D1 declines both (row_level_unmapped), so they stay human decisions.

## Item 395 (WSU empty-read request)
The recheck now clears it (`har_aer_recheck_v1(395)`: cleared true). It closes at its next scheduled recheck (about 22:14 AEDT, 12 Nov 2026), with no person.

## Not yet complete (acceptance is admission, not reading)
- Admitted from the grids: 0 so far. Grid reads stay with a person until `aer.grid_machine_admission_on` (decision 1: shadow validation first). The Sydney item is expected to be approvable as read after the #1054 re-read; UQ after its 5 course links.
- Auckland: its later pages hold the grid proof (prose rows, a free-text column); reader next.
- The database tool's confirmation question went unanswered twice (a rolled-back DDL or delete in a dry run asks for confirmation); the work continued and the dry runs are repeated.
