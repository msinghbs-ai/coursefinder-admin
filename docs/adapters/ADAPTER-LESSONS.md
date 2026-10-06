# Adapter Lessons Learnt

**Status:** CURRENT · **Decision:** 254 · **Change control:** CF-CHG-20260915-247 · **As at:** 7 Oct 2026, 07:05 AEDT
**Companion documents:**
- `ADAPTER-PATTERN-SHEET.md` and `.csv`: one row per provider, showing where each attribute sits.
- `README.md`: the register and reviewed configurations.
- `docs/coursefinder-university-adapters-v1.0.md`: the design.

This is the working playbook for building a provider adapter. It collects what the university waves (5 Oct, 04:49 to 18:04) and the overnight run (5 Oct 21:44 to 6 Oct) taught about where providers put their course facts, and how an adapter has to be set up to read them. It is updated after every wave. Each lesson says what was seen, what to do, and where the fix lives (worker version or migration) when there is one.

## 1. Before building: is there anything to read?

| Seen | What to do |
|---|---|
| An adapter was saved almost only where at least 2 of the provider's course pages were already read. In track D (small providers), 108 adapters came from 300 providers. | Check the read pages first. Fewer than 2 read pages means page discovery comes before the adapter. The rest of track D was split on this basis (1690): track E has 2 or more read pages and is worked by agents, track H is held for discovery. |
| Many small providers have no website on record, and their stored links are all aggregators (oneuedu.com, higherstudy.com, search.acir.com.au, coursesearch.studymelbourne.vic.gov.au, findthecourses, courses.com.au, StudySpy). | Never set an aggregator as the website. Never read values from an aggregator page, because it often shows another provider's course. Exclude all fields for courses bound to one. Report the provider as "needs own site". |
| A website was set from evidence. | Set it only when at least 2 read pages on one domain carry the provider's own course codes or name. Never set it from zero read pages. |
| The website on record was an old domain (VUW, Notre Dame, Greenwich, MITT, AIT). | Set the live domain when central pages or stored links show it, then rebind the courses whose own pages are evidenced. |
| A site was compromised: casino or spam pages in the stored links or text (Contempo, Aim Institute, Hillshire, Linx, VCEA, George Brown, Gold Coast International College). | Ignore the spam. Anchor patterns on the CRICOS code. Flag the site to the Platform Admin. |
| A site refused the reader (403, 429, robots, fetch_failed with no status). | Re-read once only. Repeated re-reads cost credits and, before fix 1680, wiped earlier readings. |

## 2. Binding courses to their own pages

| Seen | What to do |
|---|---|
| Courses were bound to news, staff, blog, listing, policy, fees, FAQ or another course's page. This was the most common single blocker. | Rebind with `admin_course_edit(course_id, 'set_official_url', {url, reason})`. The page must be evidenced: its URL is in `coverage_provider_urls` or in a read page's stored links, and its slug or title clearly names the course, or the page prints the course's CRICOS or NZQA code. Never guess a URL. |
| Two candidate pages, or a slug that only half names the course (specialisation pages, "-sns" variants, Flexi variants). | Do not rebind. Report it for a person to decide. |
| A domestic and an international variant of the same course page exist (`-int`, `-i`, `/international/courses/`, `-international`). | Bind the international variant. A course bound to the domestic page gets its fee and intakes excluded. |
| A page is bound by hand (identity `manual`) but prints a training package code (CHC52021) instead of the CRICOS code. | Worker v0.17.12 reads the fields of any page already confirmed, including hand-bound ones. The order is: rebind, save the adapter, re-read, then apply. |
| One page covers several courses: shared diploma pages, a school's single international page, CIT subject-area pages with several levels. | Anchor fields on `{code}` when each course block prints its code. When values are printed per level name, not per code, the fields can't be separated, so do not admit them (CIT). |

## 3. Where attributes sit, and how to read them

### Intakes

| Seen | What to do |
|---|---|
| Months printed on the course page ("Intakes: February, July"). | Use an `intakes` pattern that must capture a capitalised month or term name. A banner such as "International students START" once matched first and captured nothing (Canterbury). |
| Term names ("Semester 1", "Term 2", "Trimester 3"). | Add a `term_months` map taken only from the provider's own key-dates page or the course page. |
| "Sept", "Sep" and similar abbreviations. | Worker v0.17.12 reads "Sept" as September. "Feb", "Apr" and the other three-letter forms are read already. |
| Separators that are not a plain space (William Angliss). | Use `\s` in patterns, not a literal space. |
| Start dates are rolling or have no month ("every Monday", "15th of every month", "monthly", "Next intake: 7 September"). | Not readable as a set of intakes. Report it and do not admit. |
| Numeric dates (14/09/2026), or dates in upper case ("10 NOV 26"). | Not read yet (open item). |
| Dates labelled with a past year (2024 or 2025 tables). | Stale. Do not read them, or tighten the pattern to require 2026 or 2027 (AIIT). |
| An enquiry-form drop-down repeated on every page (Future Skills). | Not intakes. Ignore it. |
| Dates only on a central key-dates or academic calendar page. | Attach the page with `admin_provider_central_page('add', kind 'intake_calendar')`. The URL must come from stored links. |
| Dates in a browser-only dropdown or accordion, or in an image-only PDF calendar. | Needs a rendered read or hand entry. |

### Fees

| Seen | What to do |
|---|---|
| An annual international fee is printed. | Use a `fee` pattern on the international figure only. |
| A whole-course total plus a duration. This is the most common layout in VET. | Use `fee_total` and `course_years`. The worker divides total by years and understands weeks, "wks", months, semesters and trimesters (v0.17.9 to v0.17.11). It accepts 0.25 to 8 years. |
| A programme of one academic year (35 to 44 weeks, "1 year", 120 NZ credits) with one total. | The total is the annual fee, so use `fee`, not `fee_total`. |
| A one-semester programme (15 to 26 weeks) with one total. | The annual fee is total × 2. Patterns cannot express this yet, so exclude the fee for that course (open item). |
| The domestic and international panels sit side by side (Holmesglen, Tower, Victoria University, NZ polytechnics). | Anchor on the international panel ("International Duration", the CRICOS code, "International Students Tuition Fee"). |
| Two international options are printed (onshore and offshore, 36 and 52 weeks, packaged and non-packaged). | Exclude the fee for that course and ask the Platform Admin which figure to use. |
| The fee is per week, per unit, per term or per semester (ELICOS, Victoria University Sydney, AAPoly cookery). | Do not read it. Report it. A per-semester annualisation is an open item. |
| The fee is not labelled international, or one figure is given for "Domestic / International". | Accept it only when the provider is CRICOS-only and the figure agrees with the catalogue's international tuition. Otherwise hold the fee. |
| An all-inclusive figure (tuition plus materials and enrolment). | Use tuition only when the page itemises the parts. If only the all-inclusive figure is printed, use it and say so in the notes. |
| Fees appear only on a central fees page (MIT, Rhodes, MITT, Gen, Sheridan, York, UMA). | Today an admin can attach only `english_policy` or `intake_calendar`. `fee_schedule` sources exist (458, from discovery) but cannot be attached by hand and are not mapped to courses. This is the biggest fee blocker (open item). |
| Fees behind a toggle or "View fees" button (Ozford, Alma Mater, Monash College, Griffith College). | Needs a `page_view` with render. Try it only when the toggle's address parameter is visible. |
| The catalogue holds the whole-course total as "annual". | Count it as "catalogue wrong", not a disagreement. It does not block admission. |

### English

| Seen | What to do |
|---|---|
| IELTS printed on the course page. | Use an `ielts_overall` pattern. Check it against the catalogue (most agree). |
| IELTS only on a central English page. | Attach the page with kind `english_policy`. The approved rule fills courses that have no English of their own. |
| Wording such as "e.g. IELTS 6.0", "IELTS 6.0+ (if required)" or "5.5 or 6.0". | Conditional or an example, so do not admit it. |
| PTE or TOEFL scores held as IELTS in the catalogue (42, 50, 52, 59, 60). | This is catalogue noise. It does not block admission. Report it. |

### Delivery

| Seen | What to do |
|---|---|
| "Face to face", "classroom", "in class", "onsite" or "on campus". | Reads as `on_campus` (1650). |
| "Online", "from home" or "distance". | Reads as `online`. |
| A real choice ("on campus or online"). | Reads as `on_campus_and_online`, which is correct. |
| A required mix ("16h face to face + 4h online", "67% F2F / 33% online", "two thirds face to face", "Blended (Face to Face + Online)"). | This is blended (1670). If the normaliser gives `on_campus` or `on_campus_and_online`, exclude delivery for those courses or do not admit it. |
| "Centre-Based" (NZ early childhood), "on site" with a space, "Workplace Delivery", "Face to face via Microsoft Teams". | Not understood yet, or misleading. Do not admit (open item). |
| Delivery exclusions. | They are stored in `pipeline.uni_adapter_delivery_exclusions`, not in `uni_adapter_exclusions`. The `exclude` action with field `delivery` works. |

## 4. Admission

- A field passes when it is read on at least half the read pages, the spot-checks are right, and at least 90% agrees with the catalogue where the catalogue holds values. Catalogue-wrong totals and noise do not count against it.
- When only some pages print an international panel (domestic-only variants of the same course), count the half rule over the pages that print the panel. Exclude the domestic pages first.
- Exclude wrong readings before admitting: wrong binding, domestic page, short course, two options, or a stale year.
- The `admit` list replaces the current list, so always send the full set.
- Domestic-only providers (NZ "Fees Free" programmes, Queensland-funded pages, programmes open only to residents) keep their adapter but do not admit.

## 7. Added after waves 9 and 10 (6 Oct, 07:39)

| Seen | What to do |
|---|---|
| The page prints the NZQA number as "NZ2891" or "1882-2", or a training package code in the heading ("Carpentry - CPC30220"), so the general reader calls it a mismatch even though it is the right page (Westport Deepsea, PEETO, Norton). | Confirm the same URL by hand with `set_official_url`, re-read, then apply. Worker v0.17.12 then reads its fields. |
| A rolling list of the next three start dates ("Next intakes 5 Oct 2026, 2 Nov 2026, 4 Jan 2027"), or a single "Next intake: January" (ACBI, Level Up). | Not a set of intakes. Do not admit unless it agrees with the catalogue on every page, and say so. |
| The website field holds two sites in one value ("https://www.ubss.edu.au, www.gca.edu.au", "ihbrisbane.com.au; alscertificates.com"). | Set one live domain, the one that carries the course pages. Report the other. |
| Many NZ private training establishments and ITOs ("Fees Free", "NZ Resident or citizen", employer-based apprenticeships: BCITO, Skills Active, Training For You, PCTI, VSTET, Apprentice Training NZ). | Domestic only. Keep any adapter, do not admit, report. |
| One merged catalogue provider for several unrelated trading names (Stott's / ASIT / Front Cooking / Melbourne Language Centre / Affectors). | Needs a person to split it before discovery. |
| A site whose stored links point to another provider's domain (Stott's → acknowledgeeducation.edu.au, Actors College → trades courses). | Do not set the website. Report it as possibly mis-mapped or compromised. |
| Fees per study period with a total for the whole course (Australian Institute of Music: three study periods plus total). | Read the international total with `fee_total` and the international full-time years. |
| Fees per term only (Academies Australasia, AAPoly cookery). | Not readable until per-term annualisation exists (open item 3). |
| Intakes printed as "Semester 1 each year" with no key-dates page (Cairnmillar). | Needs a `term_months` map from the provider's own key-dates page. Do not invent one. |

## 8. Added after waves 11 to 14 (6 Oct, 09:24), including the first Canadian providers

| Finding | What to do |
|---|---|
| Delivery printed as "Mixed", "20 hrs/week (mixed)", "face to face virtual", "classroom environment (face to face or virtual)" or "Face-to-Face / Online". | Not a single mode. Do not admit unless the page says which applies. "Face-to-Face / Online" may be a choice or a required mix; report it. |
| A legend of every study mode printed on every course page (Educare, Charlton Brown: "Entirely On-Campus / Entirely Online / Mixed Mode"). | Not a per-course delivery. Write no delivery pattern. |
| One whole-course figure headed "Tuition Fees" or "Course Fee" with no international label (King's School of Culinary Arts, Hallmark, Alpha Beta, Whitehouse, UHE). | Save the pattern if it helps, but hold the fee until someone confirms it is the international figure. |
| A fee table with Domestic, International and Temporary Resident columns (Charlton Brown). | Read the International column only. |
| A "No longer accepting applications" or closed-to-new-enrolment banner (HELI Master of eLearning). | Correctly no intakes. Not a reading failure. |
| Intakes as a dated Monday list ("2026 October Monday, 12th November Monday, 02nd …"). | Months can be read with pick "all", but on 8-weekly or monthly courses the set is only a window on a rolling schedule. Say so before admitting. |
| Intakes as month headings in capitals with day numbers underneath (ETEA "JAN FEB … 5 th 20 th"). | Not readable until open item 2 is built. |
| Domestic and international views on separate pages (Chisholm, Australian Nursing and Training Services). | Bind the international page. If only the domestic page is stored, do not read fees or delivery. |
| Course pages that are learning-management shells ("Enroll Now, Lessons 0") or blog author archives. | Not course pages. Rebind or report. |
| Template copy that contradicts the catalogue ("Duration 3 Years, AQF 7" on a graduate certificate, APEX). | Exclude the fee for that course and report it as site noise. |
| A careers block printing median salary (WorkBC, "Median Annual Earnings"). | The general reader takes it as a fee. Exclude the fee for that course. |
| **Canada:** courses carry a source GUID as course_code and no course URL, so the general reader calls most right pages mismatches. | Bind by exact title only and confirm with `set_official_url`. The page then reads as identity manual. |
| **Canada:** most courses are `lifecycle_status = inactive` (for example 205 of 213 at Camosun, 78 of 81 at College of the Rockies). | The builder, preview and apply only reach active courses. Rebinding alone gives inactive courses no adapter readings (open item 8). |
| **Canada:** intakes as terms (Fall, Winter, Spring, Summer). | Read printed month names only. Kwantlen prints "Fall (September)", which reads directly. NIC, Douglas, Selkirk and Northwestern print terms only and need a `term_months` map from the provider's own key-dates page. |
| **Canada:** fees in CAD as a whole-programme total (Camosun, NIC), a Year 1 international panel (College of the Rockies, Selkirk) or "approx. first year" (Okanagan). | Decision 220 already allows CAD tuition only from a page that prints the course's code. Canadian course pages print no code, so no Canadian fee is admitted. Patterns are saved for later. |
| **Canada:** one page per discipline serving several degrees (King's, Burman, Calgary). | Exact-title identity fails. Needs a person to map degrees to pages. |
| **Canada:** sites that refuse the reader (Emily Carr, HTTP 403) or put programme facts on a current-year calendar profile (Capilano 2026-27). | Use the current-year calendar profile, never an archive year. A 403 site needs a rendered read or hand entry. |

## 9. Added after the first scheduled overnight wave run (7 Oct, 00:09 AEDT, track E)

| Finding | What to do |
|---|---|
| A preview shows only 8 stored pages and puts identity-mismatch pages first, so for a provider with many mismatches it never shows a read page. | Explore with review-only fields instead: save the adapter in testing with wide capture patterns on the extra fields (`other_requirements`, `location`, `entry_requirement`, `mode`, `duration`, `campus`, `exit_awards`), run `apply` (stored pages, no credits), read `candidates->'adapter_extra'` per page, then replace them with the real patterns and apply again. The final apply clears the exploratory extras. |
| Patterns are checked by Postgres before saving, and Postgres refuses a repeat count above 255 (`{0,280}` fails with "cannot be read"). `[\s\S]` is also refused inside brackets. | Use `(?:.\|\n){0,250}`, and chain two or three of them for a longer window. |
| A fee table whose text ends in `-->` sits inside an HTML comment, so it is hidden on the live page (SITS: "Total Fees : $26000 -->", then "For fee details, please contact us"). | Do not read it. Hold the fee and say why. |
| A site builder prints every visibility tag on every page (Webflow, AIAS: "This course is online only", "available full time", "available part time" on all pages). | Same as a legend (section 8): write no delivery pattern. |
| A careers block prints "Average (median) salary $49,800" and the general reader takes it as a fee (AIAS). | Exclude the fee for that course, as with WorkBC (section 8). |
| Fees printed per term inside each qualification block of a shared study-area page ("CRICOS Course Code: 115292E Duration: 4 terms (36 college weeks) Cost: A$4,000 /term", Academies Australasia). | Read duration and the per-term cost per course with `{code}` for review only; exclude the general reader's per-term figure as a fee. Not admissible until open item 3. |
| Many small VET providers' stored pages print only the title, CRICOS code and units, or only the domestic view (Sydney College, AIAS, SITS domestic pages). | Two read pages (track E) does not mean there is anything to read. Expect about one provider in three to pass a field; the rest need Layer 2 (international or central pages) first. |
| A free, domestic-only NZ programme page ("There is no cost for this programme", "Start dates flexible", People Potential). | Domestic only: keep the adapter in testing, no patterns, do not admit. |
| A new adapter row takes the table default `admit_fields` (english, fee, intakes). | Never admit by switching admission on alone. Send only the fields that pass in the `admit` call. |

## 10. Added after the second scheduled overnight wave run (7 Oct, 01:11 AEDT, track E)

| Finding | What to do |
|---|---|
| Wide keyword patterns match the site's mega-menu first ("IELTS Preparation → Students Resources Fees and charges →", Innovative; "English General English IELTS Packages", Lawson), so the first exploratory capture shows menu text on every page. | Exclude the menu separator in the window (`[^→]{0,200}`) and anchor the real pattern on the course block's own label ("English language proficiency: IELTS", "English Requirement IELTS"). |
| HTML entities such as `&#038;` and `&#8211;` survive in stored text and contain digits. | A "digit nearby" test is not enough to find a score; anchor on the label. |
| A site prints the same VET entry block ("IELTS 6.0 (5.5 in each module)") on its ELICOS pages (General English, IELTS Preparation). | Exclude english for the ELICOS courses by course before proposing. The `exclude` action also withdraws any coverage-sweep catalogue value for that course and field, by design; say so in the proposal and the runsheet. |
| Course facts (delivery, location, duration, fees) sit only in a per-course international PDF ("... Tuition Fees etc. <course> - International 549KB", Lawson). | Not readable from stored pages. Report it for Layer 2 (read the PDFs) and do not pattern. |
| Facts sit on a support or knowledge-base subdomain rather than the course page (support.griffin.edu.au articles), and the fee reads "The maximum cost for this course is A$29,200 ... depends on country of passport". | A maximum, unlabelled whole-course figure: save it for review only and hold the fee (section 8). |
| Delivery is printed separately for local and international students ("International Students: The course is delivered through face-to-face lectures and live online sessions"). | Read only the international sentence. Face-to-face lectures plus live online sessions is a required mix (blended): no mode pattern. |
| The catalogue values a proposal agrees with were written earlier by the coverage sweep from the same page. | The agreement is not independent evidence. State it in the proposal so the Platform Admin can weigh it. |

## 11. Added after the third scheduled overnight wave run (7 Oct, 02:11 AEDT, track E)

| Finding | What to do |
|---|---|
| Adapter patterns are matched without regard to case: an exploratory `(IELTS\|PTE\|TOEFL)` matched "pte" inside "September" (Unity, NZ Welding School). | Anchor on a label with punctuation ("IELTS): A band score of"), never on a short code alone. |
| Every read course is bound to the provider's central fees page (Iona Columba `/fees/`), so the pages are "read" but none is a course page. | Read the table per course with `{code}` for review only. Hold the fee when the table is whole-course, not labelled international or differs from the catalogue. The courses need their own pages found before anything else. |
| A facts strip prints "Delivery Mode Contact Us" and "Cost Contact Us" on every course page (Construction Training Australia). | Nothing to read. Save duration for review only and report the provider for Layer 2. |
| The enrolment form's study-mode question ("Online Day - Full Time, Online Evening - Part Time") sits on every programme page (AIE). | A legend, not the course's delivery (section 8). Write no delivery pattern. |
| A track E provider with only 2 read pages among 7 to 12 courses (Unity, SAE Auckland, NZ Welding School). | Any proposal covers only those 2 courses. Say so in the proposal, and prefer rebinding and Layer 2 reads to more patterns. |
| An exclusion withdraws coverage-sweep catalogue values for that course and field (section 10). | When a wrong reading is already in the catalogue (NZ Welding School rolling intakes), leave the exclusion to the Platform Admin and report it rather than withdrawing values in an unattended run. |

## 12. Added after the fourth scheduled overnight wave run (7 Oct, 03:11 AEDT, track E)

| Finding | What to do |
|---|---|
| ELICOS-only colleges (AICOL, Milestones, MIT Institute) print "Intakes: Every Monday" or "Commencement Dates Any Monday", fees per week or on a central page, and no entry score on most courses. | Rolling weekly starts are not a set of intakes and per-week fees are not annual. Save the adapter in testing with review-only duration and report it; do not expect a proposal. Read English only where a course prints its own entry score (MIT OET Preparation "IELTS 6.5 or equivalent"). |
| A CRICOS course is bound to the provider's online product page ("from AUD 31 per class", "Single Option $500", Milestones Cambridge Exam Preparation). | Not the CRICOS course view. Never read its price as a fee; report it for rebinding. |
| A page title and its body name different CRICOS codes (Milestones: title "CRICOS 0101087", body "0101086"), and both courses are bound to it. | Site noise. Do not use the page to separate the two courses; report it. |
| Exploratory capture on `exit_awards` with "international student\|domestic" matched the site menu ("International Students Page") on every page (Aurora). | Menu text, as in section 10. Anchor exploratory windows on a facts-strip label, and treat a match on every page as a menu or legend. |
| The overlap-guard run log was written straight into `pipeline.uni_adapter_requests` (the table requires a provider, so the first wave provider was used). | Write run logs and proposals with `admin_uni_adapter_control('request', ...)` and close them with `('answer', ...)`, so they are logged as control events like other requests. |

## 13. Added after the fifth scheduled overnight wave run (7 Oct, 04:11 AEDT, track E)

| Finding | What to do |
|---|---|
| One all-inclusive programme fee with no international label ("Program fees are: BSB50120 Diploma of Business $13,500", AICBT), on 52-week courses, equal to the CRICOS international tuition for every course. | Read it with `fee` (one-year programme, lesson 3) and propose it, but say in the proposal that the Platform Admin must confirm the provider is CRICOS-only before admitting (lesson 3 rule for unlabelled figures). |
| A web-shop line on the course page ("initial payment of AU$4,050, along with an enrolment fee of AU$650, resulting in a total of AU$ 4,700") that the general reader takes as the fee. | Anchor the fee pattern on the programme-fee label, never on a "$" near "fee". A deposit is not a fee. |
| A course URL that serves a learning-management shell ("Duration 30 hours Enrolled 20 Students Lesson 0 Lessons", Woodstock). | Not a course page (section 8). Write no patterns and report it for Layer 2 or rebinding. |
| Track E providers with 4 to 6 courses whose stored pages carry no fee, date or English fact at all (Access Recognised Training, Bayside, Excel, Good Shepherd). | Expect nothing from stored pages. Save the adapter in testing with notes only, and point the provider to Layer 2 (international, fees and dates pages). |

## 14. Added after the sixth scheduled wave run (7 Oct, 05:09 AEDT, first run with admit authority)

| Finding | What to do |
|---|---|
| Schools (track E with 3 to 5 courses) bind every course to one international page that prints English as a table by year level (AEAS, IELTS, TOEFL) and fees on a separate fees page. | Write no English pattern (no single value per course). Point the provider to Layer 2 for the fees page. Expect nothing admissible from stored pages. |
| A shared school page says the year "commences in late January and concludes in early December"; the general reader reads January and December as intakes (Redlands). | Exclude intakes by course; December is the year end, not an intake. |
| Admitted values land at the next coverage sweep (about 4 minutes after `apply`). At UWA, admitting only intakes also wrote 17 English rows from the adapter reading, with no overwrite log. | Record every field's held count before admitting; after the sweep compare all fields, not only the admitted ones; if a field that was not admitted changed, switch admission off at once and report it. |
| `apply` on an adapter that reads page data (`json_source`) re-reads pages (Macquarie: 21 pages queued). | Before applying a held page-data adapter, say how many pages it will re-read; a stored-pages-only run should prefer adapters without `json_source`. |
| A held adapter that passes Qualify can still fail rule 7: a fee printed as a range with the lower figure read (Auckland), or a labelled international annual fee on pages that already list next-year starts (Yoobee). | Admit only the fields that pass every rule, and say why each other field is held. |

## 15. Added after the seventh scheduled wave run (7 Oct, 06:52 AEDT, held adapters)

| Finding | What to do |
|---|---|
| Track E providers with their own website now have 3 or fewer active courses (79 of 89); a 3-course provider passes the 3-page minimum only if every page reads. | Prefer wave 3 (held adapters) and queue thin cases as proposals; build track E only when a run has time left after held adapters. |
| Most held adapters that pass Qualify on fee fail rule 7: a whole-course figure with no international label (VIITE, IBMA, Austral, Unity Skills, Kingsford), a 2026 indicative fee on pages listing 2027 starts (UOW), or a standing decision (UTas sub-100-credit-point years). | Hold the fee and name the rule; a Platform Admin rule on unlabelled CRICOS-only fees and on the fee year would release several at once. |
| Excluding intakes for courses bound to domestic pages also withdraws the coverage-sweep values those courses already held, even when they agreed (Vision College: 10 rows to 8). | Record held counts before excluding, and say in the run entry which drop the exclusion explains. |
| A provider whose every page says it is not accepting new enrolments (TrEd College) still reads delivery. | Do not admit; report it so a person can decide whether the courses should stay active. |
| Qualify counts read pages over all pages; nested or domestic pages make the share low even when every relevant page reads (ASA, Vision). | Count the half rule over the pages that print the field's view, after excluding the others, and say so in the admit reason. |

## 5. Platform fixes made because of these lessons

| Fix | What it does |
|---|---|
| Worker v0.17.10 | Annual fee from a whole-course total for courses shorter than a year. |
| Worker v0.17.11 | "wks" read as weeks; years not rounded before dividing. |
| Worker v0.17.12 | An adapter reads the fields of pages already confirmed, including hand-bound ones; "Sept" read as September. |
| 1650, 1670 | Delivery wording: classroom, onsite and from home understood; a required mix becomes blended. |
| 1660 | Adapter apply no longer skips pages bound by hand. |
| 1680 | A failed re-read keeps the earlier reading. 193 pages lost tonight were restored. |
| 1690 | Small providers split into track E (worked) and track H (held for discovery). |

## 6. Open items (need a decision or a build)

1. **Central fee schedules:** let an admin attach `fee_schedule` pages and map their rows to courses. This is the biggest fee blocker.
2. **Numeric and upper-case start dates:** read dates such as 14/09/2026 and "10 NOV 26" as months.
3. **One-semester and per-semester fees:** annualise them (× 2).
4. **Delivery wording:** "Centre-Based", "on site" and "via Teams".
5. **Level-aware reading:** for pages that cover several qualification levels (CIT).
6. **Track H discovery:** 438 providers and 896 courses with no usable pages.
7. **Repeated fee decisions:** onshore or offshore; page or catalogue when they disagree; whether 2027 fees replace 2026.
8. **Inactive courses (Canada):** let the builder, preview and apply reach inactive courses, or activate the Canadian courses through the proper process. This blocks most of the 2,200 Canadian courses.
9. **Central page reads:** the Canadian `english_policy` and `intake_calendar` pages attached tonight are queued but not read ("budget" error). The provider-facts job needs another run.
10. **Providers with no own website or pages:** about 40 providers bound only to aggregator listings (higherstudy.com, search.acir.com.au, oneuedu.com, australiancourses.com.au) need their own site found before any adapter work.
