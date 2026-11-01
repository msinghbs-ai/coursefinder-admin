# E16 cohort confirmation list: summary (2 Nov 2026)

- **Scope:** read-only SQL on `fxcwkweaxjtknorudmwp`. No writes, no AI, Firecrawl or provider-site fetches. Repos read only; nothing committed.
- **CSV:** `docs/platform/ui-audit/e16-sibling-variant-cohort-2026-11-02.csv` in the admin repo (77 rows, one per course, 25 columns).
- **md5 convention:** `md5` of the sorted `course_id` (or fee `id`) uuids as text, joined with `,`. This convention reproduces the stream-B cohort md5.

## Method (stream B, rebuilt)

1. **Multi-link group (33):**
   - courses with more than one `active` `official_course` link in `catalogue.course_links`;
   - no link from a `layer4_human_review` source;
   - no `is_primary` link;
   - more than one distinct page after normalisation (lower case, strip scheme, `www.`, query, fragment and trailing `/`).
   - The full split reproduces stream B exactly: 239 courses and 491 links in all; 165 with a reviewer link; 23 with a primary link; 18 with the same page spelled differently; **33** with different pages.
2. **Level group (61):** on every `search.course_documents.official_course_url` (23,466 in all):
   - **title level** is the first match in the title of `graduate certificate`, then `graduate diploma`, then `master`, then `bachelor`;
   - **URL level** is the first match in the URL of `graduate-certificate`/`gradcert`, then `graduate-diploma`/`graddip`, then `master` or `/mc-` (Melbourne handbook Master code), then `bachelor`;
   - a course is kept when the two levels differ;
   - titles that contain both "bachelor" and "master" are excluded;
   - shown URLs that come from a `manual_entry` link are excluded.
   - Result: **61** courses, all AU, all on `provider_course_page_sweep` links.
3. **Cohort check:**
   - the union is 77 courses (17 are in both groups);
   - md5 `1374432181aca2abb3ec525448b66923` **matches**.
   - Note: this rebuild gives 75 raw level mismatches before exclusions, against stream B's stated 159. Stream B's raw step was probably defined differently. Its 61 and 77 reproduce exactly.
4. **Data read for each course:**
   - active official links (`course_links` joined to `pipeline.sources`);
   - `courses.course_url` and the shown URL;
   - active `provider_current_tuition` fees, with the evidence `pipeline.evidence_artifacts.source_url`;
   - `pipeline.manual_locks` (entity `course`);
   - `pipeline.coverage_course_pages`;
   - other catalogue courses at the same provider that hold the shown URL.
5. **Stored copies:**
   - Page bodies exist only in Supabase storage (`source_snapshot` gzip HTML and `provider_course_page_text`). The evidence metadata holds no title or h1, and `programme_candidates` has no title for these URLs.
   - Every row therefore records "stored copy not readable here", with the count of artefacts. No live site was fetched.
6. **Judgement basis:**
   - Classification and the own-page check are judged **from the course title and the URL slug only**, as the brief asks. The page content was not read.
   - Catalogue facts (another course holding the same URL) are recorded as context. On their own, they were not treated as proof.
   - Opaque handbook codes with no older-year signal are classed **unclear**.

## Counts

| Class | Courses | md5 of sorted course ids |
|---|---:|---|
| Confirmed sibling or older-year | **67** (62 sibling award, 5 older handbook year) | `e30cf5d986d2ace0ffe94b9e440853fe` |
| False positive | **1** (Lennox 108224J) | `e35721bbc7b03411168843d6b8571f41` |
| Unclear (needs a person) | **9** | `c88d5936b30660d357732503bf78dd79` |
| Total | 77 | `1374432181aca2abb3ec525448b66923` |

- **Provider fee shown:** 53 of 77, which matches the pack. On the 67 confirmed courses, 47 show a fee.
- **Fees read from the shown (sibling) page on confirmed courses: 31** (31 fees on 31 courses), which matches the expected 31.
  - md5 of the sorted fee ids: `fa15331cda52edbb2d4ea0cff1cd6c26`.
  - Courses (31):
    - Flinders 105122F;
    - Griffith 0101621, 046442E, 061457F, 082403B, 107421A, 114089E, 114091M;
    - La Trobe 043153E, 102427B;
    - RMIT 014891M, 055528B, 060584G, 076022K, 103217D, 103218C, 103220J, 103221H, 103222G, 103223F, 103224E, 103226C, 103227B, 103228A, 103229M, 103236A, 104982C;
    - SCU 121356K;
    - UniMelb 031944F (the 2026 fee only), 085950F (the 2026 fee only);
    - UQ 116548M.
  - **Reconciliation with stream B:**
    - Across the whole cohort, 32 fees come from the shown page after normalisation (md5 `d55e75e5c311259db0e0ce5513dc01df`). The 32nd is Lennox 108224J, whose own page this is.
    - An exact string match gives 31. That set includes Lennox and leaves out La Trobe 102427B, whose evidence URL carries a `#/overview?studentType=int` fragment. Stream B's 31 was probably this exact-match set.
    - The totals agree, but the two sets of 31 differ. Use the normalised confirmed set above for E16-5.
  - Not counted:
    - Fees whose evidence is the provider's own course page: SCU 081762J, 115300K, 086408J; La Trobe 104807G; RMIT 103219B.
    - UniMelb fees read from the 2027 international fee tables PDF.
- **Hand locks** (`pipeline.manual_locks`): 0 of 77.
- **The shown URL also equals `courses.course_url`** on 26 courses, so `course_url` is wrong too. 18 courses have no `course_url`.
- **Own correct page held as an active link** (slug judgement):
  - yes 25 (20 of the confirmed);
  - possible, from an opaque or older-year code, 14;
  - no 38 (all confirmed).
  - E16-2's "show the link equal to course_url" would fix only the courses where `course_url` is the own page. It would not help on the 26 where `course_url` is the sibling.
- **Coverage read flagged `identity_mismatch`** on 6 RMIT courses: 103218C, 103220J, 103227B, 103228A, 103229M, 103236A. The bind is still published.

**By provider (confirmed/unclear/false positive):**
- RMIT 18/0/0
- UniMelb 14/5/0
- La Trobe 8/3/0
- Griffith 7/0/0
- SCU 4/0/0
- Bond 3/0/0
- Canberra 2/1/0
- Collarts 2/0/0
- Federation 2/0/0
- USyd 2/0/0
- Flinders, SISTC, Torrens, UQ and UTS 1/0/0 each
- Lennox 0/0/1

## The 9 unclear courses (for a person)

| Provider | Courses | Shown handbook code(s) |
|---|---|---|
| La Trobe | 080515K, 107087K, 113897C | `AMIDV`, `bm009` |
| UniMelb | 041484B, 042903B, 075327A, 075333C, 120129G | `439fs`, `277aa`, `195aa`, `244cw` |
| Canberra | 071684A | `309JA/4` |

In each case the shown handbook code is opaque. In 8 of the 9, another catalogue course holds the same URL, usually the parent Master's.

## 10 worked examples

1. **RMIT 103222G, Graduate Diploma of Advertising:**
   - Shown: `…/masters-by-coursework/master-of-advertising-mc249`, which is also Master of Advertising 083949D's page.
   - The own page `…/graduate-diplomas/graduate-diploma-of-advertising-gd197` is held (= course_url), active and not primary, but it is older-verified (5 Oct, against 1 Nov 18:37).
   - Fee AUD 45,120 (2027) is read from the mc249 page.
   - **Confirmed sibling; sibling-page fee.**
2. **Griffith 107421A, Graduate Certificate in Professional Accounting:**
   - Shown: `master-of-professional-accounting-5683` (Master 088233M's page). It is the only link, and course_url is null.
   - Fee AUD 42,500 (2027) is read from that page.
   - **Confirmed sibling; sibling-page fee; own page not held.**
3. **Griffith 0101621, Graduate Certificate in International Law:**
   - The Master's page `master-of-international-law-studies-5738` is **primary** and shown, and equals course_url.
   - The own page `graduate-certificate-in-international-law-3354` is held but not primary.
   - Fee AUD 47,000 is read from the Master's page.
   - **Confirmed sibling.** E16-2 alone would not fix this one, because the wrong link is primary.
4. **UniMelb 095993A, Graduate Certificate in TESOL:**
   - Shown: handbook `2026/courses/mc-tesol` (Master of TESOL 095992B).
   - The own `gc-tesol` (= course_url) is held but not shown.
   - Fee AUD 52,960 is read from the 2027 fee-tables PDF, not from the sibling page.
   - **Confirmed sibling; fee not counted.**
5. **La Trobe 107089H, Graduate Diploma in Financial Analysis:**
   - Shown: handbook `2021/LMFAN` (also held by Master of Financial Analysis 079189G).
   - Held: `2024/bg005` (= course_url).
   - No fee.
   - **Confirmed older-year** (2021 against 2024, different code).
6. **Bond 107662F, Graduate Certificate in International Relations:**
   - Shown: `bachelor-of-global-studies-sustainability/graduate_outcomes`, which equals course_url. It is the only link.
   - No fee.
   - **Confirmed sibling; own page not held.**
7. **SCU 081762J, Graduate Diploma of Business:**
   - Shown: `master-of-business-administration-1207290`.
   - The own `graduate-diploma-in-business-1107295` (= course_url) is held.
   - Fee AUD 26,000 is read from the **own** GD page.
   - **Confirmed sibling; fee not counted.**
8. **UQ 116548M, Bachelor of Nutrition Sciences:**
   - Shown: `bachelor-nutrition-sciences-master-dietetics-studies-2534`, the combined degree page that is also held by 116549K. It equals course_url.
   - Fee AUD 60,952 is read from that page.
   - **Confirmed sibling (combined award page); sibling-page fee.**
9. **Lennox 108224J, Graduate Diploma of Management (Learning):**
   - Shown: `bsb80120-graduate-certificate-in-management-learning`. The words say "graduate certificate", but BSB80120 is this Graduate Diploma.
   - Fee AUD 16,342.86 is read from its own page.
   - **False positive.**
10. **UniMelb 120129G, Graduate Certificate in Public Health:**
    - Shown: handbook `2026/courses/244cw`, an opaque code also held by Master of Public Health 020358D.
    - The own named `gc-pubhlth` (= course_url) is held but not shown.
    - Fee from the fee-tables PDF.
    - **Unclear:** the slug alone does not name the award, so a person must open the stored or live page.
