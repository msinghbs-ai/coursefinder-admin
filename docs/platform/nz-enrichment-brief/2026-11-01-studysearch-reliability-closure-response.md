# StudySearch reliability closure: 24-hour checkpoint response

**Mandates:** Reliability Closure and Production Acceptance (1 Nov 2026 08:57); progress dashboard instruction (1 Nov 10:23). Both saved verbatim.
**Response lodged:** 1 Nov 2026, 11:20 AEDT. **Evidence:** transformation record §33 and §34.

**StudySearch Progress — 1 Nov 2026 11:15 AEDT**

`██████████░░░░░` **67%** (10 of 15, from this register)

| Total | Completed and verified | Deployed, awaiting verification | In progress | Blocked / awaiting approval | Not started |
|---:|---:|---:|---:|---:|---:|
| 15 | 10 | 4 (SS-004, SS-007, SS-010, SS-014) | 1 (SS-015) | 0 | 0 |

**Current task:** SS-015 (acceptance evidence) · **Next:** SS-010 (24-hour close at 13:55 today) · **Remaining:** 5 tasks: SS-004, SS-007, SS-010, SS-014, SS-015.
**Movement since the 1 Nov 00:15 checkpoint:** 0 completed; 5 remaining (unchanged). SS-004 remediated (v2.15.387, v2.15.388); SS-007 integrity regression found and repaired (v2.15.389).

| Outstanding | Next action | Human approval |
|---|---|---|
| SS-004 | 7-day window to 7 Nov 11:03; a fresh clean 24 h after the 1 Nov 09:25 fix (to 2 Nov 09:25) | No |
| SS-007 | Re-verify batch A daily; 154 releases and 1,012 verification reads stay held | Yes, for any further correction (D11) |
| SS-010 | Close the 24-hour futile-item window at 13:55 | No |
| SS-014 | 2 Nov 07:30: D13 pilot, D15, D14, D16; alert receipt | Yes: confirm the [TEST] alerts arrived |
| SS-015 | Two complete weeks (2–8 and 9–15 Nov); assess 16 Nov | Yes: acceptance |

**Layer 4 settlement (separate from engineering):** baseline pending 1,143 (31 Oct 10:24) · current pending 1,175 (36 new) · reviewed by a person 0 · reconciled automatically 2 · admitted 0 · deferred 0 · exceptions (past 14 days) 0. Oldest pending 10.5 days; reaches the 14-day target on **4 Nov 22:57** without review.

## 1. Remaining job failures and fixes

- **Read-job cancellations (31 Oct 15:00, 15:30):** deliberate idle pauses by the flag unit. They are now classified `paused`; every other failure still counts (v2.15.387).
- **Admission time-outs (31 Oct 17:10):** row-lock contention between three admission jobs that started together. The starts are now staggered at :00, :03 and :08 (v2.15.387). No admission control, lock or time-out was changed.
- **Health-check runtime regression from that release:** fixed the same morning (v2.15.388).
- **New finding, repaired:** SS-007's batch A had been undone by `coverage-admit` on 31 Oct 14:30 (167 wrong official links published again). Admission now honours the remediation hold, and the 167 links are removed again (v2.15.389). Verified: 0 shown, other content unchanged, no drift.
- **Since the 09:25 fix:** 0 failures in 2,840 runs.

## 2. Operational acceptance evidence

The SS-015 T1–T8 table is in record §34.3.
- **Pass:** T2, T3, T5, T8.
- **Fail:** T1 (24 h, the 17:10 time-outs), T4 (week, before D5a), T6 (search p95, week) and T7 (week, before D15).
- **Insufficient data:** the post-fix windows for T4, T6 and T7, and alert receipt.
- **Gate:** two complete weeks (2–8 and 9–15 Nov), assessable 16 Nov. **Not production-ready; not claimed.**

## 3. Direct-read pilot yield

No pages are eligible yet (the oldest last attempt is 2 Oct). The first results are due at the 2 Nov 07:30 check. 0 released, 0 Firecrawl.

## 4. Refresh performance (D15)

Since 31 Oct 23:19: 3 requests, maximum wait 10 minutes, 0 open, 0 failed runs. Insufficient data to judge p95.

## 5. Alert delivery

Delivery was recorded `sent` for the 3 [TEST] messages on 31 Oct. **Recipient receipt is not confirmed.** Since then, 0 alerts were raised (no issue stayed open 15 minutes) and 0 failed.

## 6. Outstanding genuine risks

| Risk | Why it matters | Action |
|---|---|---|
| Layer 4 oldest item reaches 14 days on 4 Nov 22:57 | T5 fails and the acceptance week is lost | Person review of the oldest items before 4 Nov |
| Other automatic writers on held courses | The admission path was unguarded; no other scheduled writer re-activates official links (checked) | Daily batch A re-verification |
| Coverage-queue health section 6.8–9.5 s (was 2.9–4.0 s) | Health run time; not caused by the stall-age change (0.7 s measured) | Observe at the 2 Nov check |
| No website search traffic | T6 p95 cannot be measured after SS-012 | Measure when traffic returns |

## 7. Decisions or confirmations needed

- **Alerts:** please confirm whether the three [TEST] messages (31 Oct, 22:00 and 23:00) reached you.
- **Layer 4:** review capacity before 4 Nov to keep T5.
- No other decisions are needed now.

## 8. References

| PR | Merge commit | Release | Migration | Spec |
|---|---|---|---|---|
| #779 | `0089e2fe` | v2.15.387 | `20261101010000` | s197 |
| #780 | `9396b085` | v2.15.388 | `20261101020000` | s198 |
| #781 | `ef64ad47` | v2.15.389 | `20261101030000` | s199 |

- **Local suites:** 1,329, 1,331 and 1,333 passed, 0 failed.
- **Post-merge workflows:** green.
- **Consumer drift:** none.
- **Admin:** §33 and §34; execution register with the progress dashboard; test register; `ui-audit/ss007-integrity-repair-links.csv`; both mandates.
