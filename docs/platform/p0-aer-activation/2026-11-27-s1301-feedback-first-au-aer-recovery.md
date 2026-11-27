# s1301: Feedback-first AU academic entry recovery (S1-AER-Claude, 27 Nov 2026)

Assignment from SS-Programme-Control, 27 Nov 11:57 AEDT. All figures are live database reads on 27 Nov, taken between 12:00 and 13:30 AEDT. Spend: AI US$0, Firecrawl US$0. No reader was run, no on-demand work opened, no setting, source, lock or Layer 4 item changed. This session cannot invoke the worker or an admin re-read (no service credentials, and `admin_entry_matrix_reread` needs a signed-in Platform Admin); production reads stay with the scheduled path.

## 1. What the reported courses actually hold

The reported "academic entry missing" courses were checked three ways: active rows in `catalogue.course_entry_requirements`, the provider matrix, and what the consumer API returns (`website_v3_course` by course stable key, countries IN and NP).

| Feedback | Course | Active course rows | Consumer result, India / Nepal |
|---|---|---|---|
| FB-6.C01-01 | RMIT Bachelor of Business 106623K | 12 | course override, 3 rows, minimum 67 / same |
| FB-6.C10-01 | RMIT Master of Marketing 077512F | 8 | course override, 5 rows (no numeric minimum published) / same |
| FB-6.C02-01 | Swinburne Bachelor of Business 063366D | 4 | provider minimum 55.3 / **contact provider** |
| | Swinburne Bachelor of Business 088382J | 5 | provider minimum 60 / course override 60 |
| FB-6.C04-02 | VU Bachelor of Business 092820B | 4 | course override / course override |
| | VU Bachelor of Business 092944A | 1 (Layer 4 item pending) | provider minimum, 3 rows / **contact provider** |
| FB-4B.3-03 | VU Bachelor of Early Childhood Education and Leadership 115486F | 6 | course override, minimum 30 / same |
| | VU same title 105139H | 1 (Layer 4 item pending) | provider minimum, 3 rows / **contact provider** |
| FB-6.C06-02 | CQU Bachelor of Psychological Science 084516K | 2 | provider minimum 62 / same |
| FB-6.C08-01 | WSU Bachelor of Business 089205G | 0 (provider matrix 461 rows) | provider minimum, 3 rows / same |
| FB-6.C09-01 | Analytics Institute Bachelor of Business Transformation 111122M | 4 | course override, minimum 60 / same |
| FB-6.C13-01 | Deakin Master of Health Management 114205F | 6 | course override, minimum 70 / same |

Result: every reported course already delivers an academic entry requirement for India. Nepal is served on 10 of 13 course records. The three Nepal "contact provider" cases (Swinburne 063366D, VU 092944A, VU 105139H) are correct: the VU matrix holds India, Bangladesh, Pakistan and Sri Lanka rows, the Swinburne matrix holds India only, and no Nepal row is published, so none is inferred. These are not missing-data defects; where a user still sees nothing on the Portal, the fault is projection or display (D9), so these courses are not re-read.

Not resolvable from here: WSU Master of Health Science (Health Service Management) (FB-6.C03-01) is a catalogue and search item, not academic entry; Adelaide College Diploma in Business Studies and La Trobe Nursing stay with S2-AER (s1293).

## 2. Genuine remaining gaps (live, priority cohort)

Counts of courses with no active course row, no provider matrix and no pending Layer 4 item:

| Provider | Courses | With course rows | Matrix only | Layer 4 only | Nothing |
|---|---:|---:|---:|---:|---:|
| University of Newcastle | 457 | 89 | 0 | 41 | **327** |
| Charles Darwin University | 175 | 111 | 0 | 0 | **64** |
| Deakin University | 252 | 184 | 0 | 6 | **62** |
| Victoria University | 314 | 94 | 208 | 0 | 12 |
| Melbourne Institute of Technology (two records) | 30 | 21 | 0 | 0 | 9 |
| All other cohort providers (RMIT, Swinburne, WSU, CQU, Adelaide, Notre Dame, JCU, Tasmania, Charles Sturt, Kaplan, La Trobe, Analytics) | | | | | 0 |

Every course at the other twelve cohort providers holds either course rows or a provider matrix. The remaining work is concentrated at Newcastle, CDU and Deakin.

Why (from `pipeline.aer_course_outcomes`, built 26 Nov 15:05, so counts are indicative):
- **Newcastle.** Most of the 327 have no proven course page: 108 have no bound page, 91 a mismatched page, 4 an ambiguous page; 49 are bound without an identity basis. Reading cannot start until the page is proven. This is source integrity (S1-Build, PR #1271 contract) and link recovery (S1-Data-Gaps), not a reader fault.
- **CDU.** 21 mismatched pages; 26 skipped because a Layer 4 item was superseded; 13 bound by title and unread.
- **Deakin.** 46 identity-unresolved (37 mismatched pages): shared identity, S2-AER. Five held for page row limits (10 to 17 requirements).
- **Victoria University (`0f5373c8`).** 10 mismatched pages.
- **MIT.** 3 skipped after a superseded Layer 4 item.

## 3. Evidence and approvals carried forward

- **A1 CQU, A3 Excelsia, Le Cordon Bleu scope:** unchanged. All three wait on one read-only addition to `entry_inspect` (a `source_ids` input and anchors to the registered host), consolidated with S2-AER. Not applied.
- **A2 AIBT:** prepared for S1-Build (s1240 section 7.2).
- **A4 Greenwich:** unpublished and hidden, untouched.
- **D-R3:** no new quotation recovery in this pass.

## 4. Feedback register updated

Rows FB-4B.3-03, FB-6.C01-01, FB-6.C02-01, FB-6.C04-02, FB-6.C06-02, FB-6.C08-01, FB-6.C09-01, FB-6.C10-01 and FB-6.C13-01 now carry the evidence above. Six moved to Retest required (RMIT Bachelor of Business, CQU, WSU, Analytics, RMIT Master of Marketing, Deakin); three stay In progress or Retest required with the Nepal and Layer 4 detail (VU Early Childhood, Swinburne, VU Business).

## 5. Reusable knowledge

- Strategy that worked: check the consumer API by stable key and country before any re-read; most reported "missing" courses were already served.
- Strategy that failed: none run. A reader cannot be started from this session.
- Rule kept: a country with no published row resolves to contact provider; equivalence is never inferred from another country.

## 6. Exceptions and next actions

1. Newcastle (327), CDU (64), Deakin (62): page identity first. Owners S1-Build (source integrity) and S2-AER (shared identity); once a page is proven the scheduled first-read path (s1296) picks the course up.
2. Layer 4 decisions pending on VU 092944A and 105139H, and 41 Newcastle and 6 Deakin items (people decide).
3. Stored-file inspection addition (A1, A3, Le Cordon Bleu).
4. Platform Admin or provider statement on Nepal for VU and Swinburne, if a Nepal requirement is to be published.
