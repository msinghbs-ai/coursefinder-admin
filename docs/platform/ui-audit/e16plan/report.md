# E16 containment plan: binding quarantine, fee suppression and Layer 4 reconciliation

Prepared 2 Nov 2026 (AEDT) by read-only SQL on Supabase `fxcwkweaxjtknorudmwp`. Nothing was written to production. No AI, Firecrawl or web fetches.
Authority: Platform Admin, 2 Nov 2026 07:21, `docs/platform/nz-enrichment-brief/2026-11-02-e16-final-disposition-decision.md` §2 and §6.
The E16 classification is a **candidate assessment from course title and URL slug, not proof**. Every count below keeps that distinction: "confirmed" means "classified confirmed sibling or older-year in the cohort file".

Files in this folder: `batches.json` (binding-quarantine calls), `fees.sql` (E1-style withdrawal and rollback, not run), this report. Working data: `state.json`, `analysis.json` (per-course live state, 2 Nov 20:29 UTC = 07:29 AEDT).

## 1. Cohort check (step 1): all md5s match

| Set | Count | md5 | Result |
|---|---:|---|---|
| Live rebuild, multi-link group | 33 | | matches summary |
| Live rebuild, level group | 61 (17 in both) | | matches summary |
| Live rebuild, union | 77 | `1374432181aca2abb3ec525448b66923` | **match** |
| Confirmed (CSV classification) | 67 | `e30cf5d986d2ace0ffe94b9e440853fe` | **match** |
| Unclear | 9 | `c88d5936b30660d357732503bf78dd79` | **match** |
| False positive | 1 | `e35721bbc7b03411168843d6b8571f41` | **match** |
| Sibling-page fees (live rebuild, fragment ignored; also with full normalisation) | 31 | `fa15331cda52edbb2d4ea0cff1cd6c26` | **match** |

The class split is the cohort file's judgement; the 77 and the 31 were rebuilt from live tables. The shown URL in `search.course_documents.official_course_url` still equals the CSV value for all 77, and recomputing the projection rule from live `catalogue.course_links` gives the same URL for all 77. No course is hand-locked, held, inactive or already rejected (`page_rejections`).

## 2. Headline findings

1. **The governed hold contains only 12 of the 67.** `security.binding_remediation_apply_v1` (def md5 `532863b3…`) acts only where `coverage_course_pages` is bound to exactly the wrong URL. It refuses **55**: 49 are bound to a *different* page (in most cases the course's own page), and 6 RMIT bindings are already `mismatch`. No course falls in class (b). The 12 are Bond 3, Collarts 2, USyd 2, Flinders, SISTC, Torrens, UQ, UTS; after the call none of them shows any link.
2. **The wrong links are being written by the hourly job `exit-awards-apply` (cron `37 * * * *`).** `security.exit_awards_apply_v2` passes the parent award's page as `course_url` to `security.coverage_apply_course_v1`, which upserts it as an **active** official link (`on conflict … set status = 'active', last_verified_at = now()`), and copies the parent's fee onto the child (same upsert pattern for fees). Its last run (1 Nov 19:37 UTC) re-verified 88 links, which is why the sibling page now outranks the course's own page in the projection order (`is_primary desc, last_verified_at desc`). It applies to **53 of the 67** confirmed courses and 8 of the 9 unclear. It does **not** consult `security.course_held_v1`, so a remediation hold, a link set `unverified` or a fee set `inactive` on these courses is reversed within the hour.
3. **Governed brakes for that job exist.** (i) `public.admin_exit_awards('off', {child_course_id, reason})`: Platform Admin (role rank 6, signed in), reason logged in `admin_control_events`, reversible with `'on'`; it sets `set_by = 'hand'`, which the detector (`exit_awards_detect_v2`) does not overwrite. (ii) `l4_api.block_decide('course', id, 'operational', 'block', …)`: PIM Admin; stops every coverage write for the course (`coverage_apply_course_v1` raises); does not hide the course from consumers (only scope `search` does); never used to date (0 rows in `layer4_block_decisions`). Option (i) is narrower and is recommended.
4. **All 31 sibling-page fees are proved** (evidence id present, stored `source_snapshot`, `source_url` without fragment equals the shown sibling page; 31 of 31 re-checked live). But **29 of the 31 were written on purpose by the exit-award rule** ("annual fee as the course"), and 17 of those 29 equal the CRICOS registered amount once scaled by the award length. Only Flinders 105122F and UQ 116548M are straight misreads. Whether a rule-derived parent fee counts as "unsupported" is a Platform Admin decision (D2).
5. **Side effect on `course-url-fill`:** the 12 quarantined courses each have an open URL fill from 23 Oct (inside the 30-day window). Retracting them lifts the retraction rate from 4.97% (1,044 of 21,026) to about 5.02%, over the 5% limit (`course_url.max_retraction_pct`); the job then sets `course_url.fill_enabled = 0` on its next run, platform-wide (D4).
6. **Layer 4:** none of the 77 has a pending course-link or fee item (only 6 RMIT `course_entry_first_read` items, a different kind). A remediation hold is not shown on any Layer 4 or remediation screen (it is only counted in `ops_scorecard_v1.remediation_holds_open`). Reuse 0; new link items needed for all 67 (plus 9 for the unclear if they are to be routed). There is no governed function to raise an ad-hoc item (D5).
7. **Further gap found:** USyd 000723J, 105221C and UTS 114585M already have `course_page_blocks` rows (Rule 6, 8 Oct: "page named for another course and the course's own CRICOS code is not on it"), yet the same page is still bound and shown. A page block does not unbind or unlink.

## 3. Class counts (confirmed 67)

| Class | Courses | Meaning |
|---|---:|---|
| (a) contained by the mechanism alone | 12 | bound to exactly the wrong page; after the call no active official link is left; not re-written by the exit-award job |
| (b) mechanism applies, another wrong link remains | 0 | none |
| (c) mechanism refuses | 55 | 49 "the bound page changed since review" (bound elsewhere); 6 "not bound (mismatch)" |

Course ids md5: (a) `c32e8f7a59dc91d1927e9f96d5ecf032`; (c) `632092863fb1479eb0ed3c5b079fd3fa`.

Of the 55 in (c): 53 are re-written hourly by `exit-awards-apply`; 2 (Federation 085206E, 085209B) are not (their exit-award rows are off and the adapter does not admit exit awards). After the wrong link is set aside, the next link shown would be: own page held and named in its slug 20; a held handbook page with an opaque or older-year code 9 (unconfirmed); nothing 26.

**Smallest governed alternative for (c) (needs Platform Admin decision, D1):**
1. Stop the re-write: `public.admin_exit_awards('off')` for each child the job applies (list in §9). Reversible with `'on'`.
2. Set the 56 wrong active links on the 55 courses to `unverified` (the status the hold uses) with a count-guarded paste in the E15 pattern, with rollback. No existing function does this for a link whose binding is not on the wrong page, so this is a consumer-visible correction outside the named mechanism. The link ids are in §9.
3. Raise one `official_course_url` Layer 4 item per course (D5). For the 29 with another held page, approving the own page in Layer 4 (`layer4_course_link_apply_impl`, post-E15) retires the other links and makes the own page primary; primary also survives the exit-award upsert, which does not touch `is_primary`.

Without step 1, steps 2 and 3, and the fee withdrawal, are undone at the next :37 run.

## 4. Per-course table (67 confirmed)

Shown = `search.course_documents.official_course_url` now. "After" = predicted after the mechanism (a) or after the §3 alternative (c), following the next search refresh. Fallback judgement is the cohort file's slug judgement. RW = written back hourly by `exit-awards-apply`. Fee = has a sibling-page fee in the 31.

| # | Provider | Code | Title | Class | Mechanism | Bound page | Shown now | After | RW | Fee |
|---:|---|---|---|---|---|---|---|---|---|---|
| 1 | Bond University Limited | 0101290 | Master of City Planning/Master of Project Manage | a | applies | = wrong page [bound] | …uate-diploma-project-management/graduate_outcomes | (none) |  |  |
| 2 | Bond University Limited | 098314E | Master of Business Data Analytics (Professional) | a | applies | = wrong page [bound] | …or-of-actuarial-science-honours/graduate_outcomes | (none) |  |  |
| 3 | Bond University Limited | 107662F | Graduate Certificate in International Relations | a | applies | = wrong page [bound] | …f-global-studies-sustainability/graduate_outcomes | (none) |  |  |
| 4 | Collarts | 118491G | Graduate Certificate of Creative Industries | a | applies | = wrong page [bound] | …stgraduate-progams/master-of-creative-industries/ | (none) |  |  |
| 5 | Collarts | 118493E | Graduate Diploma of Creative Industries | a | applies | = wrong page [bound] | …stgraduate-progams/master-of-creative-industries/ | (none) |  |  |
| 6 | Flinders University | 105122F | Graduate Diploma in Computer Science | a | applies | = wrong page [bound] | …tudy/courses/postgraduate-master-computer-science | (none) |  | Y |
| 7 | Sydney International Sch | 109071B | Graduate Diploma in Information Technology | a | applies | = wrong page [bound] | …raduate-courses/master-of-information-technology/ | (none) |  |  |
| 8 | The University of Queens | 116548M | Bachelor of Nutrition Sciences | a | applies | = wrong page [bound] | …-nutrition-sciences-master-dietetics-studies-2534 | (none) |  | Y |
| 9 | The University of Sydney | 000723J | Bachelor of Pharmacy | a | applies | = wrong page [bound] | …macy-honours-and-master-of-pharmacy-practice.html | (none) |  |  |
| 10 | The University of Sydney | 105221C | Bachelor of Pharmacy (Honours) | a | applies | = wrong page [bound] | …macy-honours-and-master-of-pharmacy-practice.html | (none) |  |  |
| 11 | Torrens University Austr | 089932J | Graduate Certificate of International Hotel Mana | a | applies | = wrong page [bound] | …pitality/master-of-international-hotel-management | (none) |  |  |
| 12 | University of Technology | 114585M | Bachelor of Education Futures | a | applies (+1 spelling) | …ures-master-of-teaching-in-primary-education [bound] | …ducation?student=international&type=international | (none) |  |  |
| 13 | Federation University Au | 085206E | Graduate Certificate in Professional Accounting | c | refuses: bound elsewhere | …n.edu.au/ords/r/curriculum/catalogue/browse1 [mismatch] | …u/courses/dbx9-master-of-professional-accounting/ | (none) |  |  |
| 14 | Federation University Au | 085209B | Graduate Diploma of Professional Accounting | c | refuses: bound elsewhere | …n.edu.au/ords/r/curriculum/catalogue/program [mismatch] | …u/courses/dbx9-master-of-professional-accounting/ | (none) |  |  |
| 15 | Griffith University | 0101621 | Graduate Certificate in International Law | c | refuses: bound elsewhere | …aduate-certificate-in-international-law-3354 [bound] | …/degrees/master-of-international-law-studies-5738 | …aduate-certificate-in-international-law-3354 (yes) | Y | Y |
| 16 | Griffith University | 046442E | Graduate Certificate in Public Health | c | refuses: bound elsewhere | …s/graduate-certificate-in-public-health-3147 [bound] | …edu.au/study/degrees/master-of-public-health-5263 | …s/graduate-certificate-in-public-health-3147 (yes) | Y | Y |
| 17 | Griffith University | 061457F | Graduate Certificate in Urban and Environmental  | c | refuses: bound elsewhere | …ate-in-urban-and-environmental-planning-3216 [bound] | …s/master-of-urban-and-environmental-planning-5576 | …ate-in-urban-and-environmental-planning-3216 (yes) | Y | Y |
| 18 | Griffith University | 082403B | Graduate Diploma of Finance | c | refuses: bound elsewhere | …a-women-in-finance-and-economics-scholarship [bound] | …ffith.edu.au/study/degrees/master-of-finance-5592 | (none) | Y | Y |
| 19 | Griffith University | 107421A | Graduate Certificate in Professional Accounting | c | refuses: bound elsewhere | …s.griffith.edu.au/9306-richard-copp/teaching [bound] | …dy/degrees/master-of-professional-accounting-5683 | (none) | Y | Y |
| 20 | Griffith University | 114089E | Graduate Diploma of Integrated Water Management | c | refuses: bound elsewhere | …ts.griffith.edu.au/9756-wade-hadwen/teaching [bound] | …egrees/master-of-integrated-water-management-5766 | (none) | Y | Y |
| 21 | Griffith University | 114091M | Graduate Certificate in Integrated Water Managem | c | refuses: bound elsewhere | …tificate-in-integrated-water-management-3346 [bound] | …egrees/master-of-integrated-water-management-5766 | …tificate-in-integrated-water-management-3346 (yes) | Y | Y |
| 22 | La Trobe University | 043153E | Graduate Diploma in Art Therapy | c | refuses: bound elsewhere | handbook.latrobe.edu.au/courses/2024/HGAT [bound] | latrobe.edu.au/courses/master-of-art-therapy | handbook.latrobe.edu.au/courses/2024/HGAT (possible) | Y | Y |
| 23 | La Trobe University | 067404D | Graduate Diploma in International Development | c | refuses: bound elsewhere | handbook.latrobe.edu.au/courses/2026/agid [bound] | handbook.latrobe.edu.au/courses/2025/AMIDV | handbook.latrobe.edu.au/courses/2026/agid (possible) | Y |  |
| 24 | La Trobe University | 080518G | Graduate Diploma in International Relations | c | refuses: bound elsewhere | handbook.latrobe.edu.au/courses/2026/AGIR [bound] | handbook.latrobe.edu.au/courses/2021/AMIRL | handbook.latrobe.edu.au/courses/2026/AGIR (possible) | Y |  |
| 25 | La Trobe University | 102427B | Graduate Diploma in Digital Health | c | refuses: bound elsewhere | handbook.latrobe.edu.au/courses/2025/hgdh [bound] | latrobe.edu.au/courses/master-of-digital-health | handbook.latrobe.edu.au/courses/2025/hgdh (possible) | Y | Y |
| 26 | La Trobe University | 104807G | Diploma of Science | c | refuses: bound elsewhere | latrobe.edu.au/courses/diploma-of-science [bound] | latrobe.edu.au/courses/bachelor-of-science | latrobe.edu.au/courses/diploma-of-science (yes) | Y |  |
| 27 | La Trobe University | 107086M | Graduate Diploma in International Business | c | refuses: bound elsewhere | handbook.latrobe.edu.au/courses/2027/BG003SY [bound] | handbook.latrobe.edu.au/courses/2022/lmibus | handbook.latrobe.edu.au/courses/2027/BG003SY (possible) | Y |  |
| 28 | La Trobe University | 107089H | Graduate Diploma in Financial Analysis | c | refuses: bound elsewhere | handbook.latrobe.edu.au/courses/2024/bg005 [bound] | handbook.latrobe.edu.au/courses/2021/LMFAN | handbook.latrobe.edu.au/courses/2024/bg005 (possible) | Y |  |
| 29 | La Trobe University | 111392M | Associate Degree in Sport Coaching and Developme | c | refuses: bound elsewhere | handbook.latrobe.edu.au/courses/2027/ha010 [bound] | handbook.latrobe.edu.au/courses/2021/hbscd | handbook.latrobe.edu.au/courses/2027/ha010 (possible) | Y |  |
| 30 | RMIT University (RMIT) | 014891M | Graduate Diploma in Marketing | c | refuses: bound elsewhere | …plomas/graduate-diploma-of-advertising-gd197 [mismatch] | …y/masters-by-coursework/master-of-marketing-mc197 | (none) | Y | Y |
| 31 | RMIT University (RMIT) | 055528B | Graduate Diploma in Professional Accounting | c | refuses: bound elsewhere | …certificate-in-professional-accounting-gc119 [mismatch] | …oursework/master-of-professional-accounting-mc194 | (none) | Y | Y |
| 32 | RMIT University (RMIT) | 060584G | Graduate Diploma in Finance | c | refuses: bound elsewhere | …-in-sustainable-finance-and-investment-gc219 [mismatch] | …udy/masters-by-coursework/master-of-finance-mc201 | (none) | Y | Y |
| 33 | RMIT University (RMIT) | 076022K | Graduate Diploma in Business Information Technol | c | refuses: bound elsewhere | …uate-diploma-in-information-technology-gd188 [mismatch] | …k/master-of-business-information-technology-mc200 | (none) | Y | Y |
| 34 | RMIT University (RMIT) | 103217D | Graduate Diploma in Media | c | refuses: bound elsewhere | …ate-diplomas/graduate-diploma-in-media-gd180 [bound] | …study/masters-by-coursework/master-of-media-mc188 | …ate-diplomas/graduate-diploma-in-media-gd180 (yes) | Y | Y |
| 35 | RMIT University (RMIT) | 103218C | Graduate Diploma in Urban Design | c | refuses: not bound (mismatch) | = wrong page [mismatch] | …asters-by-coursework/master-of-urban-design-mc193 | (none) | Y | Y |
| 36 | RMIT University (RMIT) | 103219B | Graduate Diploma in Energy Efficient and Sustain | c | refuses: bound elsewhere | …rgy-efficient-and-sustainable-building-gd189 [bound] | …f-energy-efficient-and-sustainable-building-mc209 | …rgy-efficient-and-sustainable-building-gd189 (yes) | Y |  |
| 37 | RMIT University (RMIT) | 103220J | Graduate Diploma of Animation, Games and Interac | c | refuses: not bound (mismatch) | = wrong page [mismatch] | …master-of-animation-games-and-interactivity-mc232 | (none) | Y | Y |
| 38 | RMIT University (RMIT) | 103221H | Graduate Diploma of Communication | c | refuses: bound elsewhere | …omas/graduate-diploma-of-communication-gd196 [bound] | …sters-by-coursework/master-of-communication-mc248 | …omas/graduate-diploma-of-communication-gd196 (yes) | Y | Y |
| 39 | RMIT University (RMIT) | 103222G | Graduate Diploma of Advertising | c | refuses: bound elsewhere | …plomas/graduate-diploma-of-advertising-gd197 [bound] | …masters-by-coursework/master-of-advertising-mc249 | …plomas/graduate-diploma-of-advertising-gd197 (yes) | Y | Y |
| 40 | RMIT University (RMIT) | 103223F | Graduate Diploma of Communication Design | c | refuses: bound elsewhere | …uate-diploma-of-writing-and-publishing-gd199 [mismatch] | …y-coursework/master-of-communication-design-mc250 | (none) | Y | Y |
| 41 | RMIT University (RMIT) | 103224E | Graduate Diploma of Writing and Publishing | c | refuses: bound elsewhere | …uate-diploma-of-writing-and-publishing-gd199 [bound] | …coursework/master-of-writing-and-publishing-mc262 | …uate-diploma-of-writing-and-publishing-gd199 (yes) | Y | Y |
| 42 | RMIT University (RMIT) | 103226C | Graduate Certificate in Energy Efficient and Sus | c | refuses: bound elsewhere | …rgy-efficient-and-sustainable-building-gc163 [bound] | …f-energy-efficient-and-sustainable-building-mc209 | …rgy-efficient-and-sustainable-building-gc163 (yes) | Y | Y |
| 43 | RMIT University (RMIT) | 103227B | Graduate Diploma in Urban Planning and Environme | c | refuses: not bound (mismatch) | = wrong page [mismatch] | …rk/master-of-urban-planning-and-environment-mc221 | (none) | Y | Y |
| 44 | RMIT University (RMIT) | 103228A | Graduate Diploma in Justice and Criminology | c | refuses: not bound (mismatch) | = wrong page [mismatch] | …oursework/master-of-justice-and-criminology-mc223 | (none) | Y | Y |
| 45 | RMIT University (RMIT) | 103229M | Graduate Diploma in Interior Design | c | refuses: not bound (mismatch) | = wrong page [mismatch] | …ers-by-coursework/master-of-interior-design-mc275 | (none) | Y | Y |
| 46 | RMIT University (RMIT) | 103236A | Graduate Diploma in Arts Management | c | refuses: not bound (mismatch) | = wrong page [mismatch] | …y-coursework/master-of-arts-arts-management-mc280 | (none) | Y | Y |
| 47 | RMIT University (RMIT) | 104982C | Graduate Diploma of Design Innovation and Techno | c | refuses: bound elsewhere | …plomas/graduate-diploma-of-advertising-gd197 [mismatch] | …/master-of-design-innovation-and-technology-mc231 | (none) | Y | Y |
| 48 | Southern Cross Universit | 081762J | Graduate Diploma of Business | c | refuses: bound elsewhere | …ourses/graduate-diploma-in-business-1107295/ [bound] | …ourses/master-of-business-administration-1207290/ | …ourses/graduate-diploma-in-business-1107295/ (yes) | Y |  |
| 49 | Southern Cross Universit | 086408J | Diploma of Science | c | refuses: bound elsewhere | ….au/study/courses/diploma-of-science-2127298 [bound] | …edu.au/study/courses/bachelor-of-science-3007420/ | …au/study/courses/diploma-of-science-2127298/ (yes) | Y |  |
| 50 | Southern Cross Universit | 115300K | Graduate Diploma of Business | c | refuses: bound elsewhere | …ourses/graduate-diploma-in-business-1107295/ [bound] | …ourses/master-of-business-administration-1207290/ | …ourses/graduate-diploma-in-business-1107295/ (yes) | Y |  |
| 51 | Southern Cross Universit | 121356K | Graduate Diploma of Educational Studies | c | refuses: bound elsewhere | …tudy/courses/master-of-teaching-1209001/2025 [bound] | ….edu.au/study/courses/master-of-teaching-1209001/ | (none) | Y | Y |
| 52 | The University of Melbou | 031944F | Graduate Certificate in Arts | c | refuses: bound elsewhere | handbook.unimelb.edu.au/2026/courses/gc-arts [bound] | …find/courses/graduate/master-of-arts-thesis-only/ | handbook.unimelb.edu.au/2026/courses/gc-arts (yes) | Y | Y |
| 53 | The University of Melbou | 040954G | Graduate Diploma in Environment | c | refuses: bound elsewhere | handbook.unimelb.edu.au/2026/courses/gd-env [bound] | handbook.unimelb.edu.au/2026/courses/mc-env | handbook.unimelb.edu.au/2026/courses/gd-env (yes) | Y |  |
| 54 | The University of Melbou | 045960B | Graduate Certificate in Engineering | c | refuses: bound elsewhere | …te/graduate-certificate-in-science/structure [ambiguous] | handbook.unimelb.edu.au/2026/courses/mc-eng | (none) | Y |  |
| 55 | The University of Melbou | 049410M | Graduate Diploma in Urban Planning | c | refuses: bound elsewhere | …ndbook.unimelb.edu.au/2026/courses/gd-anamgt [mismatch] | handbook.unimelb.edu.au/2026/courses/mc-urpl | (none) | Y |  |
| 56 | The University of Melbou | 075314F | Graduate Diploma in Human Rights Law | c | refuses: bound elsewhere | handbook.unimelb.edu.au/2026/courses/636aa [bound] | handbook.unimelb.edu.au/2026/courses/mc-humrlaw | handbook.unimelb.edu.au/2026/courses/636aa (possible) | Y |  |
| 57 | The University of Melbou | 075492K | Graduate Diploma in Film and Television | c | refuses: bound elsewhere | …with-us/discipline-areas/film-and-television [ambiguous] | …d/courses/graduate/master-of-film-and-television/ | (none) | Y |  |
| 58 | The University of Melbou | 075503A | Graduate Diploma in Contemporary Art | c | refuses: bound elsewhere | …dbook.unimelb.edu.au/2026/courses/mc-ctpyart [mismatch] | …find/courses/graduate/master-of-contemporary-art/ | (none) | Y |  |
| 59 | The University of Melbou | 075504M | Graduate Diploma in Transnational Arts | c | refuses: bound elsewhere | …/graduate/graduate-diploma-in-arts-advanced/ [mismatch] | handbook.unimelb.edu.au/2017/courses/mc-tranart | (none) | Y |  |
| 60 | The University of Melbou | 082254K | Graduate Certificate in Urban and Cultural Herit | c | refuses: bound elsewhere | handbook.unimelb.edu.au/2026/courses/gc-uch [bound] | …s/graduate/master-of-urban-and-cultural-heritage/ | handbook.unimelb.edu.au/2026/courses/gc-uch (yes) | Y |  |
| 61 | The University of Melbou | 085950F | Graduate Certificate in Science (Advanced) | c | refuses: bound elsewhere | handbook.unimelb.edu.au/2026/courses/gca-sci [bound] | …es/graduate/graduate-diploma-in-science-advanced/ | handbook.unimelb.edu.au/2026/courses/gca-sci (possible) | Y | Y |
| 62 | The University of Melbou | 092765D | Graduate Diploma in Commerce (Finance) | c | refuses: bound elsewhere | …ndbook.unimelb.edu.au/2026/courses/gd-busana [mismatch] | handbook.unimelb.edu.au/2026/courses/mc-comfin | (none) | Y |  |
| 63 | The University of Melbou | 095991C | Graduate Certificate in Modern Languages Educati | c | refuses: bound elsewhere | handbook.unimelb.edu.au/2026/courses/gc-mled [bound] | handbook.unimelb.edu.au/2026/courses/mc-mled | handbook.unimelb.edu.au/2026/courses/gc-mled (yes) | Y |  |
| 64 | The University of Melbou | 095993A | Graduate Certificate in TESOL | c | refuses: bound elsewhere | handbook.unimelb.edu.au/2026/courses/gc-tesol [bound] | handbook.unimelb.edu.au/2026/courses/mc-tesol | handbook.unimelb.edu.au/2026/courses/gc-tesol (yes) | Y |  |
| 65 | The University of Melbou | 096347A | Graduate Certificate in Genomics and Health | c | refuses: bound elsewhere | …dbook.unimelb.edu.au/2026/courses/gc-genohlt [bound] | …d/courses/graduate/master-of-genomics-and-health/ | …dbook.unimelb.edu.au/2026/courses/gc-genohlt (yes) | Y |  |
| 66 | University of Canberra | 103875C | Graduate Diploma in Communication | c | refuses: bound elsewhere | …stgraduate/eligible-courses-work-based-entry [mismatch] | …y-at-uc/about-our-courses/master-of-communication | (none) | Y |  |
| 67 | University of Canberra | 110293M | Graduate Diploma in Creative Industries | c | refuses: bound elsewhere | …ries/graduate-diploma-in-creative-industries [ambiguous] | …creative-industries/master-of-creative-industries | (none) | Y |  |

## 5. Predicted consumer view (website `official_url` / Zoho `official_course_url`), confirmed 67

| Step | Wrong page shown | Own page shown (slug) | Unconfirmed handbook page | No link |
|---|---:|---:|---:|---:|
| Now | 67 | 0 | 0 | 0 |
| After the 12-course batch only | 55 | 0 | 0 | 12 |
| …and an hour later if the exit-award rows are not switched off | 55 | 0 | 0 | 12 (the 12 are not exit-award re-writes) |
| After the §3 alternative as well | 0 | 20 | 9 | 38 |

`courses.course_url` is not read by the consumer API. For the 12, job `course-url-fill` (guard 3) empties it (each has a matching fill). On the 55, it stays wrong where it holds the sibling page (no fill to take back); that is internal only, but the admin course view will still show it.
Consumer API shape is unchanged by any step here (G3): only row values move, through the existing projection.

## 6. Unclear (9) and false positive (1): no change

| Provider | Code | Title | Shown now | Exit-award child (RW) | Pending Layer 4 link/fee item |
|---|---|---|---|---|---|
| Lennox Institute Pty Ltd | 108224J | Graduate Diploma of Management (Learning) (false positive) | …0120-graduate-certificate-in-management-learning/ | no | none |
| La Trobe University | 080515K | Graduate Certificate in International Development  | handbook.latrobe.edu.au/courses/2025/AMIDV | yes, parent 079183B | none |
| La Trobe University | 107087K | Graduate Diploma in Marketing  | handbook.latrobe.edu.au/courses/2025/bm009 | yes, parent 093383K | none |
| La Trobe University | 113897C | Graduate Certificate in Marketing  | handbook.latrobe.edu.au/courses/2025/bm009 | yes, parent 093383K | none |
| The University of Melbou | 041484B | Graduate Diploma in Food Science  | handbook.unimelb.edu.au/2026/courses/439fs | yes, parent 061970M | none |
| The University of Melbou | 042903B | Graduate Certificate in Food Science  | handbook.unimelb.edu.au/2026/courses/439fs | yes, parent 061970M | none |
| The University of Melbou | 075327A | Graduate Diploma in Intellectual Property Law  | handbook.unimelb.edu.au/2026/courses/277aa | yes, parent 075000B | none |
| The University of Melbou | 075333C | Graduate Diploma in Construction Law  | handbook.unimelb.edu.au/2026/courses/195aa | yes, parent 074998C | none |
| The University of Melbou | 120129G | Graduate Certificate in Public Health  | handbook.unimelb.edu.au/2026/courses/244cw | yes, parent 020358D | none |
| University of Canberra | 071684A | Graduate Diploma in Business Informatics  | canberra.edu.au/course/309JA/4 | yes, parent 087618B | none |

No existing pending item covers any of the 10. All 9 unclear are adapter-detected nested awards whose shown page is the parent's page (8 RW; Canberra 071684A has no fee admission). If D1 adopts a rule for nested-award pages, these 9 fall under it and need a person (the shown handbook code is opaque). Lennox 108224J (false positive) stays as is; its fee is read from its own page (it is the 32nd fee under normalisation and is **not** in the withdrawal).

## 7. Fees (step 4)

All 31 are proved; none is marked unprovable. Every row: `status active`, `provider_current_tuition`, international, `valid_to` null, source gated (shown to consumers), no fee lock.

| Code | Fee id | Year | Amount | Evidence id | Evidence page (= shown sibling) | How written | ≈ CRICOS? | RW | Provider fee shown now → after | CRICOS fee (kept) |
|---|---|---:|---:|---|---|---|---|---|---|---:|
| 0101621 | `36fb521a` | 2027 | 47,000 | `1afa1229` | …egrees/master-of-international-law-studies-5738 | exit-award rule x0.5 | no | Y | 47,000 → none | 21,047 |
| 014891M | `4b53cb71` | 2027 | 50,880 | `d9b11f97` | …masters-by-coursework/master-of-marketing-mc197 | exit-award rule x1.0 | yes | Y | 50,880 → none | 50,880 |
| 031944F | `8f6a080a` | 2026 | 50,976 | `8d30c69d` | …nd/courses/graduate/master-of-arts-thesis-only/ | exit-award rule x0.5 | yes | Y | 50,560 → 50560 (2027 fee-table PDF stays) | 25,280 |
| 043153E | `8ecb865a` | 2027 | 44,800 | `f96aa4da` | latrobe.edu.au/courses/master-of-art-therapy | exit-award rule x1.0 | no | Y | 44,800 → none | 43,000 |
| 046442E | `266cfa9b` | 2027 | 41,000 | `59988fcd` | …u.au/study/degrees/master-of-public-health-5263 | exit-award rule x0.5 | no | Y | 41,000 → none | 20,047 |
| 055528B | `712a5368` | 2027 | 50,880 | `542cac32` | …rsework/master-of-professional-accounting-mc194 | exit-award rule x1.0 | yes | Y | 50,880 → none | 50,400 |
| 060584G | `59b3859c` | 2027 | 50,880 | `89b533a7` | …y/masters-by-coursework/master-of-finance-mc201 | exit-award rule x1.0 | yes | Y | 50,880 → none | 50,400 |
| 061457F | `6462dc9f` | 2027 | 46,500 | `6216d4a3` | …master-of-urban-and-environmental-planning-5576 | exit-award rule x0.5 | no | Y | 46,500 → none | 21,797 |
| 076022K | `ed928df0` | 2027 | 50,880 | `db32d95f` | …master-of-business-information-technology-mc200 | exit-award rule x1.0 | no | Y | 50,880 → none | 49,440 |
| 082403B | `5802ffe3` | 2027 | 43,000 | `8064084b` | …ith.edu.au/study/degrees/master-of-finance-5592 | exit-award rule x1.0 | no | Y | 43,000 → none | 41,999 |
| 085950F | `67841648` | 2026 | 60,992 | `6942a32e` | …/graduate/graduate-diploma-in-science-advanced/ | exit-award rule x0.5 | no | Y | 64,640 → 64640 (2027 fee-table PDF stays) | 32,320 |
| 102427B | `fd2134f9` | 2027 | 43,000 | `652214c1` | latrobe.edu.au/courses/master-of-digital-health | exit-award rule x1.0 | no | Y | 43,000 → none | 41,400 |
| 103217D | `faceaf44` | 2027 | 45,120 | `035830d0` | …udy/masters-by-coursework/master-of-media-mc188 | exit-award rule x1.0 | yes | Y | 45,120 → none | 45,120 |
| 103218C | `191d4b0e` | 2027 | 54,060 | `5ab4c7b5` | …ters-by-coursework/master-of-urban-design-mc193 | exit-award rule x1.0 | no | Y | 54,060 → none | 50,880 |
| 103220J | `e630b018` | 2027 | 45,120 | `0f1a4927` | …ster-of-animation-games-and-interactivity-mc232 | exit-award rule x1.0 | yes | Y | 45,120 → none | 45,120 |
| 103221H | `548b8ad7` | 2027 | 45,120 | `84146b56` | …ers-by-coursework/master-of-communication-mc248 | exit-award rule x1.0 | yes | Y | 45,120 → none | 45,120 |
| 103222G | `5fb48e19` | 2027 | 45,120 | `e98b5b80` | …sters-by-coursework/master-of-advertising-mc249 | exit-award rule x1.0 | yes | Y | 45,120 → none | 45,120 |
| 103223F | `4942e2ea` | 2027 | 45,120 | `d5d6c905` | …coursework/master-of-communication-design-mc250 | exit-award rule x1.0 | yes | Y | 45,120 → none | 45,120 |
| 103224E | `e79c15a7` | 2027 | 45,120 | `9323583a` | …ursework/master-of-writing-and-publishing-mc262 | exit-award rule x1.0 | yes | Y | 45,120 → none | 45,120 |
| 103226C | `68c9a341` | 2027 | 48,000 | `4d600602` | …energy-efficient-and-sustainable-building-mc209 | exit-award rule x0.5 | yes |  | 48,000 → none | 24,000 |
| 103227B | `f14eb0b2` | 2027 | 41,280 | `f07f31b5` | …/master-of-urban-planning-and-environment-mc221 | exit-award rule x1.0 | yes | Y | 41,280 → none | 41,280 |
| 103228A | `34b2de4c` | 2027 | 41,280 | `755bcbef` | …rsework/master-of-justice-and-criminology-mc223 | exit-award rule x1.0 | yes | Y | 41,280 → none | 41,280 |
| 103229M | `9fbb1d35` | 2027 | 50,880 | `683a1955` | …s-by-coursework/master-of-interior-design-mc275 | exit-award rule x1.0 | yes | Y | 50,880 → none | 50,880 |
| 103236A | `9f056cbf` | 2027 | 43,200 | `b14c9ac1` | …coursework/master-of-arts-arts-management-mc280 | exit-award rule x1.0 | yes | Y | 43,200 → none | 43,200 |
| 104982C | `fd5c87a9` | 2027 | 48,960 | `ca52d51e` | …aster-of-design-innovation-and-technology-mc231 | exit-award rule x1.0 | yes | Y | 48,960 → none | 48,960 |
| 105122F | `7253f4a7` | 2026 | 42,900 | `7be3c2d1` | …dy/courses/postgraduate-master-computer-science | adapter read |  |  | 42,900 → none | 35,500 |
| 107421A | `8d9a1c5d` | 2027 | 42,500 | `643764b9` | …/degrees/master-of-professional-accounting-5683 | exit-award rule x0.5 | no | Y | 42,500 → none | 20,797 |
| 114089E | `eb97e07d` | 2027 | 41,000 | `b40fcbbf` | …rees/master-of-integrated-water-management-5766 | exit-award rule x1.0 | no | Y | 41,000 → none | 39,999 |
| 114091M | `37b7a8f9` | 2027 | 41,000 | `b40fcbbf` | …rees/master-of-integrated-water-management-5766 | exit-award rule x0.5 | no | Y | 41,000 → none | 20,047 |
| 116548M | `69c6da38` | 2027 | 60,952 | `35e7642f` | …utrition-sciences-master-dietetics-studies-2534 | adapter read |  |  | 60,952 → none | 171,150 |
| 121356K | `98cc7c9b` | 2026 | 27,000 | `f1d69aaa` | …du.au/study/courses/master-of-teaching-1209001/ | exit-award rule x1.0 | yes | Y | 27,000 → none | 27,000 |

Exit-award-rule fees consistent with the CRICOS registered total (annual × years within 2%): **17 of 29**.

- **Other active fees:** on every one of the 31 courses the CRICOS rows (`tuition` registered total, `non_tuition`, `estimated_total_course_cost`, source dataset `cricos-courses.csv`) are kept. Two UniMelb courses (031944F, 085950F) also keep a 2027 provider fee from the 2027 International Fee Tables PDF, which stays the provider fee shown; only the 2026 sibling-page option leaves their `provider_tuition_options`.
- **Website/Zoho fields before:** `provider_annual_tuition_amount` / `provider_tuition_options` / `has_fee` in `search.course_documents` (website `website_v2_course_item`, Zoho `zoho_course_search_v2` and `zoho_course_lookup_v1`), and `tuition_history` in `public.website_v2_course`, which reads `course_fees` directly (status active, no date filter). Before: all 31 show the amount in the table. After (next refresh): 29 show no provider fee (`has_fee` false), 2 show the 2027 PDF fee. Regulatory (CRICOS) fields unchanged on all 31.
- **Recurrence:** 28 of the 31 are re-written by `exit-awards-apply` (RW). `fees.sql` guard 5 refuses to run while any of them is still applicable; checked read-only now: **28**, so the file would stop with nothing changed today. Flinders 105122F and UQ 116548M are read by their university adapters from the bound page; they stop recurring once the 12-course batch has held those bindings, so run the batch first. RMIT 103226C is not re-written (its own page holds a fee value).
- `fees.sql` guards: id set and md5; each row still active with the same course, amount, year and evidence; evidence `source_url` (no fragment) still the sibling page; no fee lock; guard 5 as above; exactly 31 rows updated. Read-only check now: guards 1–4 pass (31/31), guard 5 fails (28). Rollback is in the same file.

## 8. Layer 4 reconciliation (step 5)

| Kind (`field_code`) | Pending on the 77 | Reusable for E16 |
|---|---:|---|
| `official_course_url` | 0 | – |
| `provider_current_tuition` | 0 | – |
| `provider_current_tuition_validation` | 0 (11 superseded on 8 courses) | – |
| `course_entry_first_read` | 6 (RMIT 103217D, 103219B, 103221H, 103222G, 103224E, 103226C) | no: entry requirements, and they read the own GD/GC page |

- **Reuse: 0. New needed: 67** `official_course_url` items for the confirmed courses (the 12 held and the 55 under the alternative); **+9** if the unclear are routed now. **Fee items: 0 new**: a withdrawn fee leaves "no supported fee", which the decision accepts; the fee comes back through the adapter once the own page is bound (via the link item).
- **Is a hold "visibly held"?** No. `pipeline.course_remediation_holds` is read only by the hold functions, the search/admission lanes and `security.ops_scorecard_v1` (a count). No `admin_*` RPC and nothing in `src/` lists holds. The 177 existing holds are invisible per record too. A hold is a stop, not a review route; its release is `security.binding_remediation_lift_v1` (`restore` or `release`, Platform Admin SQL).
- **How link items are normally created:** only `security.coverage_admission_apply_v1`, from coverage-sweep rows with action `differs` (reason text "The course page that shows this course's CRICOS code is a different address from the official page we hold…", ref `CF-CHG-20260915-247`; a page rule may decide it at once under Decision 263). Its dedupe is: (1) no pending item for the same course and `field_code`; (2) no identical proposal superseded within `waste.flipflop_window_days` (7); (3) no identical proposal ever decided (approved, edited, rejected). Held courses are never planned for admission (1 Nov fix), and the 55 refused are not "differs" today, so **no item will appear on its own**.
- **Dedupe check for new items:** the 77 have no `official_course_url` item in any status, so none of the three checks blocks a new one, and none would be a duplicate. No generic "raise an item" function exists, so the 67 (or 76) items need an insert paste using the same row shape (`entity_type course`, `field_code official_course_url`, `before_value` = current links, `proposed_value` = own page or null, `escalation_reason` naming E16, `change_control_ref` naming the decision) and the three dedupe checks as guards (D5).

## 9. Lists for the integrator

**Exit-award rows to switch off before anything else (53 confirmed; +8 unclear if D1 covers them):**

| Code | Child course id | Parent | Type | Set by | Register check |
|---|---|---|---|---|---|
| 0101621 | `e1596a78-53ad-463f-bd1a-1442109c6ac3` | 099995M | exit_award | hand | fail |
| 014891M | `40afad92-5a55-47d8-88e3-2015c41d11af` | 077512F | nested_award | adapter | pass |
| 031944F | `b86828bb-9b14-46b4-a9bc-50a8de61fa39` | 007306C | nested_award | adapter | pass |
| 040954G | `b444c1b8-9820-4cc9-a1b0-cb92beb56be1` | 076197J | nested_award | adapter | pass |
| 043153E | `4241f004-3144-4fd4-8468-960854850e38` | 077479B | nested_award | adapter | pass |
| 045960B | `9f50f886-8d83-40b9-8607-28a5d46b44a4` | 069275C | nested_award | adapter | pass |
| 046442E | `ebfc236d-1c66-4f5b-bd4d-815ad7655e33` | 002408D | exit_award | hand | pass |
| 049410M | `d5e7c833-7912-4046-8b6a-da966520a7c4` | 002524M | nested_award | adapter | pass |
| 055528B | `2d6d3d1c-8f6f-4455-8228-91d3f32ca491` | 077509A | nested_award | adapter | pass |
| 060584G | `196a1939-628d-4e86-8e4f-f40e0858be2e` | 077516B | nested_award | adapter | pass |
| 061457F | `264c5b84-eff8-49ac-b03f-c8cf12708198` | 076266A | exit_award | hand | fail |
| 067404D | `98610bb2-1c02-49cf-a7ce-0d4ab8fc137f` | 079183B | nested_award | adapter | pass |
| 075314F | `76339427-bad5-499f-94f0-3b158b6ff057` | 088072A | nested_award | adapter | pass |
| 075492K | `8a7a7b24-6ba1-4140-ac35-651552220afd` | 075498D | nested_award | adapter | pass |
| 075503A | `20f2aa2c-1e7f-44c6-950c-47afa7881428` | 075494G | nested_award | adapter | pass |
| 075504M | `8c317304-0728-42ca-8e14-0b308a5ffbb2` | 075506J | nested_award | adapter | none |
| 076022K | `6d42acd7-35e9-4975-aa9f-2b7f400d341d` | 077515C | nested_award | adapter | pass |
| 080518G | `8d1f1afd-96e1-44b3-bc61-a4dc42f54536` | 079184A | nested_award | adapter | pass |
| 081762J | `227e6abf-8897-4e35-9d6f-98de5c5a1160` | 016179G | nested_award | adapter | pass |
| 082254K | `19b048c5-3474-46d2-88a4-44b7c7eea8f5` | 082253M | nested_award | adapter | pass |
| 082403B | `111079e4-ca8d-4a72-bca1-145a141e201d` | 081667G | nested_award | adapter | pass |
| 085950F | `fa955ff0-37d1-4c91-826a-89c812cde021` | 023188D | exit_award | hand | pass |
| 086408J | `d7d1890f-a7f0-44c0-b16a-97f9f7445be8` | 104730A | nested_award | adapter | pass |
| 092765D | `670b7ce1-719e-4cdb-91e1-4111d0eba767` | 092762G | nested_award | adapter | pass |
| 095991C | `43cb1105-82cd-4479-a1ed-48478514b94f` | 095990D | nested_award | adapter | pass |
| 095993A | `5b6f8b6d-40c3-42ab-9d5a-52fb01f25c58` | 095992B | nested_award | adapter | pass |
| 096347A | `4e6f8c56-07cc-468b-97ff-5264276360ce` | 096349K | nested_award | adapter | pass |
| 102427B | `da0667c1-9818-4ab3-bbf7-c047f5de404d` | 0101684 | nested_award | adapter | pass |
| 103217D | `6f60c044-d710-420a-aed5-c6567c275f13` | 079084E | exit_award | adapter | pass |
| 103218C | `283a0dd2-0101-45c0-8a09-b0441f51d783` | 078873F | exit_award | adapter | pass |
| 103219B | `8b731ff6-2518-45a7-b73d-e6d03f22c405` | 084668E | exit_award | adapter | pass |
| 103220J | `ba8d7def-6f2e-48aa-a314-70603abe8d9c` | 084348K | exit_award | hand | pass |
| 103221H | `004b6c5c-4a6a-4b65-9f8d-1093049ea150` | 083948E | exit_award | adapter | pass |
| 103222G | `d3443473-9636-4a37-a6ed-e531c863a101` | 083949D | exit_award | adapter | pass |
| 103223F | `ff63eb8b-2705-4db7-8500-1db2c548216a` | 084351D | exit_award | hand | pass |
| 103224E | `a021a3df-3ad0-43c1-a9b2-54d479473078` | 088089C | exit_award | adapter | pass |
| 103226C | `1bfad09c-0734-4ef2-802a-52381c9d2ffa` | 084668E | exit_award | adapter | pass |
| 103227B | `de86b0d9-bb66-4a7d-8b05-ff1fa2c6d9cd` | 079932C | exit_award | adapter | pass |
| 103228A | `cdc06d73-f08b-40fc-9d30-1700df678e62` | 079595D | exit_award | hand | pass |
| 103229M | `d25f60bb-bd10-4956-8337-cdefdff8b1ce` | 0100719 | nested_award | adapter | pass |
| 103236A | `6b5874f1-770f-4000-9614-56a6df194724` | 103234C | exit_award | hand | pass |
| 103875C | `fcde61b0-f5fe-4618-814c-a76a4b4d1dc7` | 103874D | nested_award | adapter | pass |
| 104807G | `bf8dd977-b939-4138-a6cc-744cd5e3dedf` | 022039C | exit_award | hand | pass |
| 104982C | `60ebab30-d9a8-47f9-bf7f-85aebc49039f` | 080000D | exit_award | hand | pass |
| 107086M | `169b5258-0e1a-471a-807d-8473bdd0dcf2` | 078690B | nested_award | adapter | pass |
| 107089H | `d122606b-fe48-4a1a-b030-c9b84ea11ec1` | 079189G | nested_award | adapter | pass |
| 107421A | `7e117900-eab0-4c4d-8104-11b9ffaf9b26` | 088233M | nested_award | adapter | pass |
| 110293M | `87975d53-8b43-46c8-b209-9924fa43ea79` | 110292A | nested_award | adapter | pass |
| 111392M | `1a8df22a-2739-4226-8856-10dd228e0033` | 098511M | nested_award | adapter | pass |
| 114089E | `95fcd50f-257e-43d6-9920-f3599cacf374` | 117069G | nested_award | adapter | pass |
| 114091M | `2cf5c4ac-b56d-44e2-b69e-93b6ce39a475` | 117069G | exit_award | hand | pass |
| 115300K | `e5822674-6fca-47a7-980f-dce5b054859d` | 016179G | nested_award | adapter | pass |
| 121356K | `b2226705-305a-4e88-9af5-fd8b404239c5` | 110587H | exit_award | hand | pass |

**Wrong active links on the 55 refused courses (56 link ids):**

| Code | Link id |
|---|---|
| 0101621 | `bb5581a1-965a-4d17-9436-95ec5718bad9` |
| 014891M | `244bb9e3-c756-483c-aebc-67f0d3ebdeb4` |
| 031944F | `429b7c97-c2d1-4b81-b810-4dcb878360f4` |
| 040954G | `16567c1a-9132-42b9-88ee-f125b849ad1a` |
| 043153E | `edf4ba54-4f69-468a-bd6d-eda650509d1d` |
| 045960B | `e29eced9-aa22-4990-a0bf-04c54de0711d` |
| 046442E | `0afc091a-68df-47fe-8f4d-46d68176d64c` |
| 049410M | `2e19bd63-083a-4330-9f26-35ee3d2e765b` |
| 055528B | `cac260ab-8608-4233-8005-e7ef650ccadc` |
| 060584G | `8d3374b8-2059-4858-bf33-911665969ee6` |
| 061457F | `25b031b3-82aa-4fe7-b893-a6c61b3b87b4` |
| 067404D | `c680f285-99a7-4d67-88ce-1d9adeb6e981` |
| 075314F | `f06bde2f-7152-4308-9111-ef27f2565807` |
| 075492K | `3aa26679-9dd5-470a-b758-818b8490926a` |
| 075503A | `00f019f2-bfe1-4db8-8dc1-55915d17c75b` |
| 075504M | `c63e2bd2-6ec5-4c12-957a-434cc4af20e6` |
| 076022K | `492577a5-245d-42f9-9d29-51a9f05b6637` |
| 080518G | `9ff29058-6997-46d1-9be6-e5b6c8d6b478` |
| 081762J | `5495c427-47ff-442f-b08f-3740105ac07f` |
| 082254K | `16833db1-4c94-4c24-bc25-2a708a09bb47` |
| 082403B | `92427cc6-4b82-4550-a664-04b54b1a3b84` |
| 085206E | `7ec47cc4-83d8-4eda-a1a8-7ea313a4ab21` |
| 085209B | `b374f0f2-d90e-43e9-9b2e-ad0af0d85440` |
| 085950F | `9c3b1064-f3d3-4590-b7f6-5aa0f3d4c411` |
| 086408J | `f2aab75d-0584-4c22-a773-f528414ca450` |
| 092765D | `5b66b697-9672-4c2b-90a1-d67cda537791` |
| 095991C | `034e0b2d-6b92-46d9-8d26-768348cacdb3` |
| 095993A | `9966e1ee-3914-486b-8eb3-f7a25bad3dc1` |
| 096347A | `e620bfa5-210c-4b25-9ec5-245eec1b3810` |
| 102427B | `1115c991-bb77-4324-b483-940057320bb8` |
| 102427B | `b6d70d42-7f32-4c4a-9bb5-17cc0401d3d3` |
| 103217D | `48fd0c4d-3a65-403a-b732-246c8a80e035` |
| 103218C | `6dac18dd-0137-46a3-9554-4a8f401d6593` |
| 103219B | `35fd9bae-f6e6-46c8-9f0b-ed4bd9beb2f4` |
| 103220J | `34594cd0-993a-44c5-86d4-1a6d6555652c` |
| 103221H | `d0e2b6dd-aa1d-4e32-8698-9814392e03d3` |
| 103222G | `2fcb7384-c45b-4484-8aaa-5cc9f6af7a66` |
| 103223F | `ac6c69fd-33fa-40a7-9140-839a4bfffbe5` |
| 103224E | `ddfb378c-f30a-443d-9354-cec2989b2d5d` |
| 103226C | `44b2e897-03c4-4911-85db-0e3dd366239b` |
| 103227B | `e882e231-384f-4958-a8f0-930338fca1d3` |
| 103228A | `5aacfe2c-b49c-4fae-9f8d-5077c8bcf3cd` |
| 103229M | `08859f87-3c9f-477e-9d19-34dfd15c0ed2` |
| 103236A | `4e90e565-5881-48a2-8003-1dcdc4af33f1` |
| 103875C | `e6fb8f75-5d8d-46d4-b9bc-11d4bd18ea6c` |
| 104807G | `e4ac2971-bf69-4e7f-ac31-bbd35efc1dfc` |
| 104982C | `6fb25eac-aebf-4b1c-b3a3-8c7f238d090d` |
| 107086M | `5fe946ce-6085-495d-9e4e-fafeb6a72db1` |
| 107089H | `26215f0e-0a5e-4037-a559-fad5fa72541a` |
| 107421A | `73fdbbe8-3eeb-4cee-8c0d-2a21e8c71c2a` |
| 110293M | `f58bf30a-20e2-429e-b76e-46b06f9eec35` |
| 111392M | `62aa36fa-3518-416c-b86d-222949a4fc0d` |
| 114089E | `1a55d330-2ec7-4554-9cc6-a807e2497108` |
| 114091M | `4a5ee905-3124-474f-9635-1ffa0033fa2f` |
| 115300K | `399ba63c-3820-4998-a00c-220cf0b193c8` |
| 121356K | `aae09bf5-0eef-4ada-b193-b4d139efe77c` |

Link ids md5 (sorted): `dd107cba76d8f96d4f777cc6f0ffac8e`.

**Binding batches (`batches.json`):**

| Provider | p_expected | Codes |
|---|---:|---|
| Bond University Limited | 3 | 0101290, 098314E, 107662F |
| Collarts | 2 | 118491G, 118493E |
| Flinders University | 1 | 105122F |
| Sydney International School of Technology and Commerce | 1 | 109071B |
| The University of Queensland | 1 | 116548M |
| The University of Sydney | 2 | 000723J, 105221C |
| Torrens University Australia; Torrens University Language Centre; Chifley Business School at Torrens University Australia CBS at Torrens University Australia Blue Mountains International Hotel Management School at Torrens University Australia BMIHMS at To | 1 | 089932J |
| University of Technology Sydney (UTS) | 1 | 114585M |
| **Total** | **12** | course ids md5 `c32e8f7a59dc91d1927e9f96d5ecf032` |

Re-checked live just now: 12 of 12 pass every check in the function; 12 active links will be set unverified (UTS includes its `?student=international` spelling as `also_links`). `rejected_before` is already true for USyd 000723J, 105221C and UTS 114585M (Rule 6 page blocks), so a later `restore` lift leaves those blocks in place.

## 10. Decisions needed (Platform Admin)

- **D1. The 55 the hold refuses.** Options: (A) the §3 alternative (exit-award off, E15-pattern `unverified` paste, Layer 4 items); (B) extend `binding_remediation_apply_v1` to accept a link-only item where the binding is elsewhere (code change, E16-1 work, slower); (C) leave them shown until E16-1 lands, in which case E16 is **not** contained under §2 ("no confirmed wrong-programme destination exposed"). Recommended: A. (D) For the 4 refused courses whose binding is itself a wrong page (Griffith 082403B and 114089E/107421A bound to a scholarship or staff page; SCU 121356K bound to the Master of Teaching handbook page), the hold does apply to that binding, and listing the shown sibling URL in `also_links` would set it unverified as well. But `also_links` is documented as "reviewed spellings of the same page", so using it for a different page stretches the mechanism and needs an explicit decision. Do not use (D) on courses bound to their own page: the hold would reject the correct page permanently (`page_rejections`).
- **D2. The 29 exit-award fees.** Are fees copied from the parent award's page by `exit_awards_apply_v2` "unsupported"? Their provenance is the sibling page, as §2.4 of the decision describes; 17 match the CRICOS register when scaled. Options: withdraw all 31 (as `fees.sql` stands); withdraw only the 2 direct misreads plus the CRICOS-inconsistent ones; or withdraw none and treat the rule as approved. The file needs editing for anything other than 31.
- **D3. Switching off the exit-award rows.** Needed for any link or fee action on 53 confirmed courses to last beyond the next :37. The switch is per child, through `public.admin_exit_awards` as a signed-in Platform Admin (the integrator cannot call it as `postgres`: it needs `auth.uid()` with rank 6). Confirm who does this and that a turned-off exit award (no parent intakes, delivery or English copied any more) is acceptable.
- **D4. `course-url-fill` auto-pause.** The 12-course batch is expected to push the 30-day retraction rate over 5% and pause the fill job platform-wide. Accept the pause and re-enable with a reason afterwards, or raise `course_url.max_retraction_pct` for the window, with a reason, before running.
- **D5. New Layer 4 items by paste** (67, or 76 with the unclear), since no governed creator exists.

## 11. Risks and notes

- **Ordering and timing:** exit-award off (D3) → binding batch (12) → link paste (D1) → `fees.sql` (D2) → Layer 4 items (D5) → search refresh → read back the website and Zoho APIs. Run each step just after a :37 run, then re-check before the next one.
- **Read-back:** count against destination rows, not responses: `course_remediation_holds` (12 open rows with this batch's approval text), `course_links` unverified, `course_fees` inactive, `search.course_documents.official_course_url` and provider fee fields, then the website and Zoho endpoints.
- **Prevention (E16-1):** the binding validator must also cover `exit_awards_apply_v2` and `coverage_apply_course_v1`. They write official links and fees for a child award from the parent's page with no identity check of their own, and bypass holds. The 1 Nov 19:37 run re-verifying 88 links shows the reach. Separately, Rule 6 page blocks do not unbind (§2.7).
- **Wrong bindings left in place:** on the same 4 courses (D option), the current binding is to a non-course page. If they are not held, `coverage_admission_apply_v1` can later propose that page as the official link.
- **Nothing deleted.** Every step is a status change with before-state kept (hold rows, notes, `admin_control_events`) and a rollback: `binding_remediation_lift_v1`, the rollback in `fees.sql`, `admin_exit_awards('on')`.
- **Snapshot age:** live state read at 2 Nov 2026 07:29 AEDT. The job ran at 06:37 AEDT and runs hourly; re-run the read-only checks before execution.
