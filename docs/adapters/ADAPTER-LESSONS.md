# Adapter Lessons Learnt

**Status:** CURRENT · **Decision:** 254 · **Change control:** CF-CHG-20260915-247 · **As at:** 6 Oct 2026, 08:20 AEDT
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
