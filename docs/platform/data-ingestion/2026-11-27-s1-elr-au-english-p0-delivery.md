# Australian English requirements: P0 delivery read and evidence-ready review pack (27 Nov 2026)

**Session:** S1-ELR · **Request:** SS-Programme-Control P0, 27 Nov 2026 16:29 AEDT ("continue processing eligible Australian … English requirements … through existing production readers; prepare evidence-ready review items; return actual canonical data gains and Website/Creator verification") · **Change:** none. Read only, no Pilot PR, no migration, US$0.

## 1. The readers are running; nothing is blocked

| Check (rolled-back live reads, 16:31 to 17:05 AEDT) | Result |
|---|---|
| `elr-det-sweep` (course pages, central pages, policy applies), last 24 h | 288 of 288 runs succeeded; longest 8.2 s |
| Stored course pages not yet read by `elr-det-v1.0` | 0 |
| Stored central English pages not yet read by `elr-central-v1.2` | 0 |
| `central-attach` (Data Delivery English job), last 24 h | 24 of 24 succeeded |
| Consumer API / manual locks / active cron jobs | 75/48, no drift / 7,585 / 136 |

Every eligible stored English source has now been read. What remains is either a decision for a person or a source that is not stored. No reader recovery is needed for English.

## 2. Canonical gains

| Measure | 21 Nov 2026 13:15 | 27 Nov 2026 16:35 | Gain |
|---|---:|---:|---:|
| AU active courses with an active English requirement | 16,818 | 16,849 | **+31** |
| AU courses without one, stored course page bound (Table 1) | 3,527 | 3,508 | −19 |
| AU courses without one, no stored course page (Table 2) | 5,358 | 5,346 | −12 |

Since 21 Nov, 87 AU courses carry English rows written or re-verified by the governed routes: 84 from approved university policies and 3 from course pages. The +31 is the net count of courses that went from no English requirement to at least one.

## 3. Website and Creator verification

- **Data Delivery consumer measure (all countries, measured 16:27 AEDT):**
  - Website: 21,039 matched of 21,334 expected, 0 missing, 24 pending.
  - Zoho: 21,039 matched of 21,334, 0 missing, 24 pending.
  - Not applicable: 271 courses closed to international students.
- **Targeted read-back of the AU courses gained since 21 Nov:** 16 sampled, read through `public.website_v2_course` and `public.zoho_v2_course`, the reads the website and Zoho (Creator) consume.
  - 16 of 16 return every active English row on both. No course came back empty and none differed.

## 4. Human decisions: the evidence-ready review pack

- **What is waiting:** 55 AU university English policy readings are waiting for a person in Universities › English. 28 of them would add English requirements to **315 AU courses** when approved, because the plan writes only to courses that have none. The other 27 would write nothing.
- **The pack:** `docs/monitoring/AU-ELR-REVIEW-PACK-2026-11-27.csv` (also in Drive Monitoring). One row per reading, giving:
  - the reading id and the official source page;
  - the proposed values;
  - the courses it would fill and the courses the plan holds;
  - a plain reviewer note and a suggested decision.

| Suggested decision | Readings | Courses that would gain English |
|---|---:|---:|
| Approve (official policy page, no conflict with the course pages) | 13 | 178 |
| Check then decide (old source, a value that looks wrong, or many differing courses) | 10 | 86 |
| Reject (source is not an entry policy, or a misread) | 5 | 51 |

- **Rejects:**
  - TAFE SA (one course page used as the VET default);
  - ACU (TOEFL iBT 120, the test maximum, read from UAC);
  - ECU twice (an English bands table, not a level default);
  - Flinders International College (an IELTS preparation page).
- **Older duplicates:** UNSW and TAFE International WA each also have an older reading waiting. Approve one and reject the other, because the auto-approve rule never acts while a second reading is waiting.
- **Related pack:** the 22 English items already in Layer 4 are covered by S1-Data-Gaps' P0 pack (Admin #1312). This pack is the separate university-policy set.

## 5. Exceptions recorded (not reachable by an existing reader at US$0)

- **No central English page found:** 523 universities / 2,296 courses (S1-ELR-Central-Policy audit; mostly private VET colleges and schools).
- **No stored course page:** 5,346 AU courses (Table 2). These belong to the course-page owners.
- **English bands:** the band reader (`elr-band-v1.0`) is live, but no university's central page labels bands with test values, so there are 0 definitions and 0 rows.

## 6. Next

The 315 courses move as soon as a person decides the pack in Universities › English. After the decisions, read one approved course per provider back through the website and Zoho reads.
