# RM1K Australia page: golden acceptance read

**22 Nov 2026 01:55 AEDT · Lane 1 (S1-API-Frontend-Delivery) · IR-002, RM1K; linked to REQ-59**

What this is: one verified Australian record for each section of the Australia page. Each record was read live through Website API v3 (the functions behind `website-api-v3`) in a rolled-back dry run. These are the golden records that an automated deployed check will assert on Admin and Website v3.

| Page section | v3 read | Records held (AU) | Golden record |
|---|---|---|---|
| Institutions | `website_v3_providers` | 1,283 | A B Paterson College (`provider:cricos:00902f`) |
| Courses | `website_v3_course_search` | 24,013 | 22603VIC Certificate IV in Cyber Security, SGSCC International (`course:cricos:03122k:119549h`) |
| Universities | `website_v3_rankings` | 76 ranked | First ranked item, with its logo and attribution |
| Scholarships | `website_v3_scholarships` | 828 | $15,000 scholarship to study at the Byron Bay campus, SAE University College |
| Visa and money; cost and work; work after study | `website_v3_destination`, section `study_rules` | 6 | Student visa (subclass 500) application charge (`f0dc0e92-…`); 12-month living cost (`8409e4eb-…`); work limit in session (`bc9b0cf9-…`); Temporary Graduate visa (subclass 485) stay after a bachelor degree (`362ddcce-…`) |
| Careers | `website_v3_destination`, section `career_outcomes` | 1,577 | JSA OSCA occupation outcome (`c455e025-…`) |
| Cities | `website_v3_destination`, section `localities` | 102 | Adelaide, 6 BOM climate metrics (`5facd96d-…`) |

**Result:** every section serves at least one record. Nothing was changed, and the read cost $0.

**Still to do:**
1. Turn this table into a deployed spec (`@deployed`) that opens each record in Admin and reads it from Website API v3 with the v3 key (the Website v3 key is still Not issued, so the spec reads with the bridged v2 key until it is).
2. Run the 10-provider QA (REQ-59) once Saurabh and Sujata send the list of 10 providers and what must pass for each, including whether research scholarships show on the website.

## Deployed check (s973, 22 Nov 2026 16:35 AEDT)

The golden acceptance now runs after every deploy. Pilot spec `cf-247-s973-rm1k-golden-acceptance` (`@deployed`, signed in) calls
`public.admin_golden_acceptance_v1` with the fixture `tests/fixtures/rm1k/australia-golden.json`. For each section, the function reads the record through Admin (the Course detail read and the tables Admin shows) and through Website API v3, and says whether the two agree. All ten sections must agree.

| Section | Golden record | What must agree |
|---|---|---|
| Course detail | Graduate Certificate in Publishing, The University of Sydney (`course:cricos:00026a:058180a`) | Title, course code, provider, study level |
| Entry requirements | "A bachelor's degree from the University of Sydney, with a major in the humanities or social sciences, …" | The website's requirement note is one of the course's active entry rows |
| English requirements | IELTS 6.5 | Tests and overall scores, both ways |
| Tuition fees | A$26,950 course total (CRICOS registered) | The website's amount is one Admin holds, in the same currency |
| Scholarships | 8 shown | Each one shown (name and page) is mapped to the course on Admin; the count matches |
| Campuses | Camperdown 2050 | City and postcode, both ways |
| Accreditations | CRICOS 058180A registered | The website's registration codes are ones Admin holds |
| Study rules | Student visa (subclass 500) Overseas Student Health Cover | Title and source page |
| Career outcomes | OSCA 1111 Corporate Services Managers, 10,000 employed | Code, title and employment count |
| Rankings | THE =51, QS 28, ARWU =79 | Each ranking body's latest published rank and year, side by side |

Rehearsal (rolled back, 22 Nov 2026 16:10 AEDT): 10 of 10 sections agree. The 10-provider QA (REQ-59) stays queued until its list and pass criteria arrive.
