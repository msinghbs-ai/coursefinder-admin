# Auto-admit escalation for Layer 4 first runs (SP-2a)

Date: 26 Oct 2026 (AEDT)
Decision: Platform Admin, 26 Oct 2026 08:25. "Layer 4 stops being the stopgap. Apply the learning-loop auto-admit escalation now, with its designed safeguards. My attendance becomes audit, not gate."
Change control: CF-CHG-20260915-247 (entry 26 Oct 2026, SP-2a)
Release: v2.15.356 (SP-2a), branch `cf247-sp2a-auto-admit`

## 1 What was done straight away (items 4 of the decision)

| Item | Result | Checked against the live system |
|---|---|---|
| `bind.no_page_on` = 1 | Already 1 since 25 Oct 23:27; confirmed | settings row read back |
| Tranche 2 Part A paste (agent authorised) | Applied 08:2x: 7 target overrides, 18 fee pages requeued; logged in `admin_control_events` (`tranche_2_part_a`) | 7 rows in `firecrawl_targets` with reason "Tranche 2…"; all 23 fee pages of the 7 providers fetched by 08:40 (HTTP 200, stored copies) |

Tranche 2 first outcome (fee reader, 08:25–08:41): North Island College 4 fees admitted; College of New Caledonia 9 rows domestic only; Selkirk 21 rows with no matching course; North Island 25 no course and 21 not yearly; Okanagan's 2026-27 schedule PDFs (new and continuing students) are queued for the reader now (4 queued). Coast Mountain, Vancouver CC and Yukon pages were read but the deterministic parse found no fee table (VCC shows 13 course codes, so it is a reader candidate, not a dead page). Reported in full at the next check.

## 2 How "proven pattern" is checked (items 1–2)

A no-page or conjoint first run is approved without a person when all three hold. Every check reads stored data only; nothing is fetched.

| Check | Rule (setting) | What it means in plain words |
|---|---|---|
| Course list verified | A course list page read within 30 days (`layer4.auto_admit_list_days`); its links hold at least 70% of the provider's bound official pages (`layer4.auto_admit_list_recall`), with at least 20 bound pages (`layer4.auto_admit_min_bound`) | The provider's own list is current and demonstrably complete, so "not on the list" means something |
| Sample confirmed | At least 80% of the sample (4 of 5; `layer4.auto_admit_sample_pct`) has no unbound list address whose words cover 60% of the course title (`layer4.auto_admit_match_share`); sample at least 3 (`layer4.auto_admit_min_sample`) | The machine does the person's check. A sample course that does have a look-alike address is marked "has a page" and stays in the search, as a person's edit-and-approve would. A conjoint rule needs every course confirmed, because the rule takes them all |
| Shape already approved | The list shape matches a provider a person has approved: how the list was read (map, sitemap, direct, firecrawl), provider type, depth of course page addresses, plus "pdf" and "extra-domain" flags | New shapes stay with a person: the first PDF list, the first ITO / extra-domain site, any shape not yet approved |

One limit stated plainly: the CMS itself is not visible in the stored data (list pages are kept as links, not page source), so the list shape is the stand-in for "same CMS/shape". If the sampling audits show errors inside one shape, that shape can be split further.

Sampling audit: 1 in 10 first runs that pass every check stays in Layer 4 (`layer4.auto_admit_sample_rate`, default 10), with "Sampling audit: passed every auto-admit check; please confirm" at the top of the item.

Recording: every outcome, with its evidence (list address, read date, bound pages on the list, sample result, shape), is in `pipeline.layer4_auto_admissions`. Every auto-admission is also in `pipeline.layer4_decisions` (system automation account, Decision 263) and in Layer 4 › Decided as "Auto: <reason>".

Unchanged (items 3 and 6): trust escalation (60% rule), later cases for trusted providers recorded by job `no-page-propose`, any later page re-opens a course, nothing deleted.

## 3 The bootstrap, said plainly

No first run has been approved by a person yet, so on day one no shape is "already approved" and nothing can auto-admit. The design handles this without a seeding exception: the first provider of each shape is NOVEL and stays in Layer 4, and its item now says how many waiting first runs share its shape. Approving one leader per shape unlocks the rest of that shape on the next hourly run (job `layer4-auto-admit`, :47).

Dry run on live (26 Oct, rolled back): of the 60 waiting, 0 auto-admitted before any approval (as designed). After simulating one person approval of the commonest shape (`map|university|d3`), the next run auto-admitted 5 (Southern Cross, Flinders, Griffith and two more), wrote 5 decisions and 5 Decided rows, and 6 providers became trusted. Run time 30 seconds.

What holds the rest back today (dry run, 60 waiting):

| Outcome | First runs | Why |
|---|---|---|
| Novel shape (waiting for a leader approval) | about 17 | shape not yet approved by a person |
| Course list not verified | about 23 | list links hold less than 70% of bound pages (e.g. Monash 2%, Melbourne 11%, Curtin 4%); these lists are partial or are search pages |
| Sample not confirmed | about 7 | look-alike addresses on the list (Deakin, UTas, Sydney 2 of 5) — exactly where errors live |
| No course list read | 8 | Adelaide, CQU, Murdoch, Notre Dame, UWA, AUT (theology): no list page yet |

The leaders to approve are listed at the next check (by shape, with the count each unlocks), after the release is live.

## 4 Values admitted per day (item 5; also in the speed record)

| Day (AEDT) | Official pages bound | Fee rows written | Fee reader admitted | Courses recorded no page / conjoint |
|---|---|---|---|---|
| 20 Oct | 4 | 0 | 0 | 0 |
| 21 Oct | 61 | 156 | 150 | 0 |
| 22 Oct | 38 | 157 | 212 | 0 |
| 23 Oct | 24 | 339 | 383 | 0 |
| 24 Oct | 72 | 174 | 189 | 0 |
| 25 Oct | 2 | 49 | 52 | 0 |
| 26 Oct (to 08:45) | 0 | 1 | 4 | 0 |

English and intake rows carry no creation time, so they cannot be counted per day from the tables; they are left out rather than estimated.

Binding at the change (official page bound, active courses): AU 71.3% (18,622 of 26,103), NZ 47.0% (3,042 of 6,474), CA 69.8% (2,664 of 3,814). Recorded no-page courses: 0. Note: recording a course as "no page published" does not raise the binding %; it takes the course out of the search lane. The next check reports both the binding % and the resolved % (bound plus recorded).

## 5 Next check reports

- First runs auto-approved vs sent to Layer 4 (split by reason, sampling audits counted separately).
- Values admitted since this change, per day.
- Binding % and resolved % movement.
- Tranche 2: fee reader outcome for the Okanagan schedule PDFs and the rest.
- Leaders per shape for the Platform Admin to approve (each unlocks its shape).
