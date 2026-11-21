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
