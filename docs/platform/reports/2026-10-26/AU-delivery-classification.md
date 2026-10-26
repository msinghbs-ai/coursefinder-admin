# AU delivery mode: classification of the 3,390 "not on page" rows

Platform Admin request 26 Oct 2026 21:12 (fix or build?) and 21:45 (counts only; queue a tighter re-run if more than 20% are recoverable).
Scope: delivery `not_on_page` courses under the 1,056 eligible (to-be-published) AU providers. Live data, 26 Oct 22:5x. The latest delivery attempt per course comes from `pipeline.field_enrich_items` (the existing "Enrich fields" AI reader of stored course pages).

## Result

| Class | Courses | Share | What it means | Fix |
|---|---|---|---|---|
| **A. Genuinely silent** (as judged by the reader on the course's own bound page) | **752** | 22% | The page was read and the AI found no delivery statement: 680 on a page that is still bound and read, 72 on a bound page not re-read since | Nothing to read. Only another source helps (see note) |
| **B. Recoverable by a tighter prompt or re-run** | **333** | 10% | The AI gave a value but its quote was not found on the page (332), or a JSON parse error (1) | Reader tuning: quote matching, then re-run |
| **C. Needs the right course page first** (not a reader problem) | **2,305** | 68% | 824 "page does not state it" on a page that is **no longer** the course's page; 693 + 209 "no allowed source had a value" (no page with an accepted proof); 548 + 31 values **taken back** because they were read from another course's page | The page lanes (search, binding, identity), which start for these providers when the publish paste is applied |
| Total | **3,390** | 100% | | |

## Answer: a FIX, not a BUILD

- No new delivery reader is needed. The reader exists, and 68% of the gap is the missing or wrong course page, not the reader.
- Reader tuning (class B) is 10% of the rows. That is under the 20% bar you set, so **no re-run was queued automatically**.
- Class A (752) is the reader's own judgement. It has not been checked by hand. A 20-page browser-extension sample would confirm it before it counts as "genuinely silent".

## Note: a source that is not the page

- 99.9% of these courses carry CRICOS course locations (campus) from the register.
- An "on campus (international students)" value derived from the register is possible, but it is an inference, not quote-on-page. It would be a rule decision for you, not part of this fix.
