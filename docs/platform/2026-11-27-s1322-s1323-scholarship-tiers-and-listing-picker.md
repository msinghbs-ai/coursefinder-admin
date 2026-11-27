# Course-specific scholarship tiers (s1322) and the bounded listing picker (s1323)

S1-Build, 27 Nov 2026. Assignment: SS-Programme-Control 27 Nov 2026 21:08 AEDT, items 2 and 5.
- Pilot migrations `20261130203000` (s1322) and `20261130210000` (s1323).
- Both were rehearsed on the live head and rolled back.

## s1322: VU Sydney & Brisbane 2027 International Scholarship (`c377de6f`)

**The problem.** The record holds 30% as a maximum (the page's "up to"), so all 14 mapped courses calculated as `award_not_structured`. The official 2027 table (evidence `db338b04`) is recorded as two tiers:

| Tier | Label | Rate |
|---|---|---|
| `official_rate_2` | Graduate Diploma in Early Childhood Education (EGEC) | 30% |
| `official_rate_1` | All other eligible courses | 20% |

The tiers had no link to courses.

**The change.**
- New table `scholarship.course_tier_assignments`, filled by `scholarship.assign_course_tiers_v1(scholarship, apply)`. A tier is assigned only when one of these holds:
  - its label is the course's registered title exactly, with an optional trailing "(CODE)". Case and spacing are ignored; there is no fuzzy matching;
  - it is the table's single "All other eligible courses" tier, which is assigned to every other mapped course.
- A tier without evidence or a percentage, a label that names no course or more than one, or a second catch-all assigns nothing.
- `scholarship.refresh_course_financial_calculation` (md5 `c1232842`) takes the assigned tier's exact percentage. The record-level "up to" now stops only untiered courses.
- The change is applied to `c377de6f` only.

**Rehearsed result (on the live head, rolled back).** 14 of 14 calculated:
- 13 courses at 20%, for example Bachelor of Business (Accounting): AU$33,400 estimated a year, AU$6,680 saving;
- Graduate Diploma in Early Childhood Education at 30%: AU$33,800, AU$10,140 saving.

The fees are estimated from the registered CRICOS cost (Decision 247). All 14 courses are unpublished, so there is no consumer change today.

## s1323: scholarship listing picker

**Measured live at 22:10 AEDT.** 72 providers had due listing pages. `public.svc_scholarship_listing_next` took 6.7 s of its 8 s limit and returned no page: `fc_sch_held_v1` held all 72 (3.6 s).

**The change (D12, bounded).** Providers are checked one at a time, in the order of their first due page:
- a provider is skipped when it is hidden or fails discovery eligibility (`fc_sch_listing_held_v1`);
- the check stops when the released providers hold the call's pages, or after a fixed 2.5 s fire guard;
- the existing global order then applies among the released providers' pages.

A provider held only by the paid cap now gets its free listing read. Every paid scrape is still refused by `svc_fc_spend`.

**Rehearsed result (on the live head, rolled back).** 6 pages in 0.2 to 0.9 s, and 20 pages in 0.3 to 0.8 s. The release refuses itself if the picker takes over 4 s.

## Unchanged

Both changes leave these as they were: the consumer API (75/48), locks, Layer 4 decisions and cron. Neither change spends anything.
