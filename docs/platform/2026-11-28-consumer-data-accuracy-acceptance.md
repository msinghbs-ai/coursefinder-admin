# Consumer data accuracy and reported-feedback acceptance (S1-API-Frontend-Delivery, 28 Nov 2026, about 09:30 AEDT)

Assignment: SS-Programme-Control 28 Nov 2026 07:07 (P0). Read only. No row, setting, function or migration was changed; the consumer API (G3) is untouched. Every read below was made on the live database through `public.website_v3_course(key, country)` and `public.zoho_v3_course(key, country)`, which return the same payload.

Course-level delivery was proved for each course by a search on its code and a detail read, not inferred from an active canonical row or a published provider. The live provider pages were not re-read (the page fetch was not approved in this session); the source comparison uses the stored evidence and the S2-AER correction pack.

## 1. Result table

| Item | Course | Consumer read now | Verdict | Owner |
|---|---|---|---|---|
| FB-6.C10-01 | RMIT Master of Marketing 077512F | Serves GPA 2.7 / 4.0 ("to be considered for a CSP") to international readers; routes not grouped | **Still defective** (not accepted) | S2-AER, then S1-Build |
| FB-6.C13-01 | Deakin Master of Health Management 114205F | Serves Weighted Average Mark 70 and 60 as entry minimum scores; routes not grouped | **Still defective** (not accepted) | S2-AER |
| FB-6.C10-03 | RMIT 077512F scholarships | 10 awards, identical for India, China and no country | **Still defective** | S1-Build (G3 held) |
| FB-6.C13-02 | Deakin 114205F scholarships | 4 awards, identical for India, Vietnam and no country | **Still defective** | S1-Build (G3 held) |
| Fees and intakes, UNE and TAFE Queensland (s1327) | UNE 000376A sampled | Live fee is the 2026 amount (33,216, `provider_current`); s1327 records the 2027 schedule as rehearsed only | **Not yet live**; nothing to accept | S1-Build |
| Intake dates | RMIT 106623K, WSU 089205G, CQU 084516K, VU 115486F, Analytics, VU 092820B | Intakes with no start date or year; Analytics and VU 092820B have none | **Open**, as reported | S1-Data-Gaps |

No feedback item was moved to Verified closed. The register's Summary tab still shows 0.

## 2. RMIT 077512F and Deakin 114205F: why D9 does not fix them

- **RMIT.** The active row `e12fc2fe` (GPA 2.7/4, a Commonwealth supported place minimum) is stored with audience `all`. The payload function serves `all` to an international reader. D9 (s1286, Pilot #1709, held for the Platform Admin's Wix/Zoho notice) drops domestic-only rows, but not rows whose audience is wrongly `all`. The S2-AER correction pack (Master Plan, 28 Nov 07:50) already names the rows to change (`e12fc2fe`, `59a41640`, `66c49515`) and the same class at 14 rows in 5 providers. It needs a person with a role to apply it, or the narrow worker rule (treat a CSP statement as domestic), which needs a freeze exception.
- **Deakin.** Two rows are stored as `minimum_grade`, audience `all`, with `min_entry_score` 70 (`a41dec2a`) and 60 (`c0ea0653`). Their text is a Weighted Average Mark needed for a specialisation or a unit (Course Director approval, Minor Research Project A), not an admission minimum. They surface as the course's "70 minimum" in the consumer entry block. The four admission routes (`1e07dedc` related-discipline bachelor, `e6b8b074` any-discipline bachelor, `903a8d79` two years of work experience, `c54b6026` interview and merit) are not grouped into routes. Fix for S2-AER: reclassify the two WAM rows as a note with no `min_entry_score` (or withdraw them), and group the routes.
- **Scope check.** Neither course has a pending Layer 4 item or a manual lock, so the correction does not collide with the 7,585 protected locks. Both courses sit in the 956 first-read items only as approved or superseded history.
- **The earlier register text was wrong in one respect.** The 27 Nov notes for FB-6.C10-01 and FB-6.C13-01 say the consumer returns "5 rows" and "a 70 minimum (course override)" and mark both Retest required. A retest will fail until the rows above are corrected. Both are set back to In progress (owner S2-AER) below.

## 3. New consumer defect: scholarships ignore the reader's country

`website_v3_course` and `zoho_v3_course` return the same scholarship list whatever `country` is passed. Hash of the list: RMIT identical for IN, CN and none; Deakin identical for IN, VN and none. The scholarship rows hold the nationality limits (`scholarship.scholarships.nationalities`, read by the nationality reader), so the data is correct and the payload does not use it. Effect for an Indian reader of RMIT 077512F: the list includes the China pathway award (CN), the Vietnam awards (VN), Africa and South East Asia awards, which are not open to them. For Deakin, the Southeast Asia Priority Bursary (BN, ID, KH, LA, MY, PH, SG, TH, TL, VN) is shown to every country, and the India-only 20% Merit Scholarship is shown to every country.

Other scholarship payload gaps seen in the same read:
- Deakin Sanctuary Scholarships holds `award_amount` 6,000 per year but the payload has `saving_per_year` null; the amount shows only in the note text.
- The Deakin International 20% Merit Scholarship shows "Up to 65%" because the stored percentage is the maximum; the 20% lower bound is lost from the note.
- RMIT awards show AUD 10,176 a year (20%) computed from the course fee, which is correct only where the fee year matches.

This is a change to the frozen payload (G3): it needs the Platform Admin's explicit approval, recorded as a consumer API change, and S1-Build. It is not done here. Request to the Platform Admin: approve filtering by the `country` argument for scholarships whose nationality list is non-empty (a reader with no country keeps the full list), with the approval line and baseline re-take required by G3.

## 4. Other defects seen on the consumer payloads (for the owners, no change here)

- RMIT 077512F February intake has the label February but `start_date` 2027-03-01 (S1-Data-Gaps; Rule B: a day is never inferred from a month).
- CQU serves the 2026 fee (36,720); the feedback (FB-6.C06-05) expects the 2027 fee.
- VU courses serve `regulatory_registered` fees with no year.
- Swinburne 063366D and 088382J share a title and URL but differ in fee year (2026 43,430; 2027 46,700); the identity needs a person's decision.
- `cricos_course_code` is null in the course payload for every course sampled.
- Performance (HELD:G3, with IQ-00615): the course-by-key lookup scans `search.course_documents` (about 1.9 s idle, 7.4 s under load, when about 11 background jobs run together). A key index needs no payload change, so S1-Build can deliver it as an index-only migration.

## 5. Register entries

- Feedback sheet rows FB-6.C10-01 and FB-6.C13-01: back to In progress; verification text as in section 1.
- Feedback sheet rows FB-6.C10-03 and FB-6.C13-02: In progress; the scholarship payload defect in section 3 added.
- Master Plan status log and CURRENT-STATE: one line each (this change).
- No "Verified closed" was recorded. The nearest to closing is an item whose consumer read now shows the corrected value for the exact course, audience and field.

## 6. Decisions needed

1. Platform Admin: approve the G3 change for scholarship nationality filtering (section 3).
2. Platform Admin or a person with an AER role: apply the RMIT correction pack and a matching Deakin correction (section 2), or approve the worker rule for CSP and WAM statements.
3. Platform Admin: confirm the D9 notice to Wix and Zoho (unchanged).
4. S1-Build: key index for the course-by-key lookup (index only).
