# English language requirements: band label fix, English band to course matching, and a one-off fetch of known central English pages (s904 to s909)

**Session:** S1-ELR-Bands-And-Crawl · **Platform Admin request:** 21 Nov 2026 09:00 AEDT · **Change control:** CF-CHG-20260915-247 · **Pilot:** #1447, migration `20261121110000` · **Spend:** US$0 AI; Firecrawl only for the one-off fetch (estimate 52 credits) · **Follows:** `2026-11-21-s895-s896-elr-central-v11-all-universities.md`

## 1. Audit (live, rolled back, 21 Nov 2026 09:05 to 09:40 AEDT)

| Finding | Live |
|---|---|
| v1.1 "bands" flag | Fired on 27 of 63 pages read. Every sampled trigger was IELTS score wording ("IELTS Band 4", "no band less than 6.0"). No sampled page named a band scheme |
| Universities with gap courses, central page found, none stored | 89 universities, 561 gap courses, 137 pages |
| Why those pages were not stored | 71 old daily budget; 63 not on the scheduled Firecrawl target list; 1 answered 403; 2 empty; 1 site Firecrawl does not support |
| Pages fit to fetch | 52 pages of 40 universities, after leaving out the refusals, empty pages and addresses that are not admission pages (IELTS preparation, classes, blogs, research case studies) |
| Scheduled provider-facts job | Off |
| Firecrawl credit left on the plan | 67,187 |

The request named 70 universities and 346 courses. That count came from Table 1, which only covers courses with a stored course page. The wider count above is 89 universities. Of those, 40 have a page worth fetching.

## 2. Change

- **s904, reader `elr-central-v1.2`:** IELTS sub-score wording ("band 6.0", "no band less than 6.0", "IELTS band score 7") is no longer an English band scheme. A scheme is flagged only by:
  - "English band(s)" or "English level(s)";
  - a line, table row, table column or heading labelled "Band A", "Band 2" or "English level 3".

  Every page is read again by v1.2 at $0.
- **s905, band definitions:** the values a central page gives each named band are kept in `pipeline.elr_band_defs`.
  - One value per band and test; two values are a conflict, and that test is left out of the band.
  - A band is never a study-level default.
- **s906, `elr-band-v1.0`:** course pages of universities with band definitions are read for the band they name. When a page names exactly one defined band, the course gets that band's values.
  - The rows are insert only (key `elr-band:<band>:<test>`) and pass the same gates as the course-page reader: page identity, refused page, Layer 4, no overwrite, the 7,585 manual locks.
  - These go to Layer 4 for a person:
    - a page that names more than one band;
    - values that differ between the university's pages;
    - a regulated discipline (nursing, midwifery, medicine, allied health, teaching and education, law, social work);
    - a page shared by several courses;
    - the audit sample.
  - A band the central page does not define, or a page that names no band, is held.
- **s907, the one-off fetch:** 52 known, unstored central English pages are queued, with a limit of 100 (`elr_central_fetch.max`).
  - They run under one on-demand request: `claude_session`, Firecrawl only, scope `central`, open for 6 hours.
  - `elr-det-sweep` fetches 10 a run, at most 12 a call, through the same gate as provider-facts. Robots, directory and credit rules still hold.
  - Each fetched page is stored as provider-facts evidence and then read by the central sweep. No model is used and no proposal is made at fetch time.
  - A lost call is never re-sent. The request is closed and its report kept when the queue is empty.
- **s908 and s909:** everything runs inside `elr-det-sweep` with no new job. Five settings are added. Status read: `security.elr_band_status_v1()`.

## 3. Guardrails

- Every replaced function is md5-checked first.
- G3: 75/48, checked before and after.
- Manual locks and the active cron count are compared before and after.
- The claims are held to 300 ms. No drop or delete.

## 4. Validation before merge

- **Specs:** s904 to s906 (5 tests) and s907 to s909 (4 tests).
- **Updated expectation:** in s895, rows labelled with a band are now band definitions, so they are no longer untiered lines.
- **Other guards:** s884, s885, s886, s840 to s842, s42, s57, s120, s32 (non-browser), s811 and the AI-models spec pass. 85 passed in all.
- **Rolled-back live dry run:** passed. It queued 52 pages of 40 universities and opened the on-demand request with an estimate of 52 credits (at most 78), then rolled back.

## 5. After merge (closing record)

### s910 (found in the live check)
- **The failure:**
  - The central writer re-read a page whose identical text already had a superseded elr-central proposal, and its insert hit the unique key `provider_policy_proposals_key`.
  - The error was raised during the answer read-back, before the lost-call step. So every run failed on the same answer (request 898146, sent 08:42 AEDT), and nothing after it ran.
  - Nothing reached Firecrawl. The s907 fetch has not started: 52 pages are queued and no credits have been used.
  - The fault came in with s896, which explains why the earlier closing record's "5 of 5 runs succeeded" was true only up to 08:47.
- **s910 fix:**
  - A page text that already has a proposal is not proposed again, and its reads are held with that reason.
  - Each answer is recorded in its own sub-transaction; one that fails is marked failed and the run goes on.
  - Rolled-back proof: one sweep run completed in 1.2 s, reading back the stuck answer, applying 2 policies and sending 11 central pages and 10 fetch pages.
- **Live after #1447:** G3 75/48; manual locks 7,585; 133 active cron jobs, 0 unregistered; on-demand request open until 15:41 AEDT, estimate 52 credits, 67,177 credits left.
- **Validation:** spec s910 3 of 3; the guards pass.
- **Next:** auto-merge this record, then Pilot #1448, then read live.

(Filled in by the closing record.)

## 6. Comments and replies
