# AU scholarship Layer 4 review items, 27 November 2026

Prepared by S1-Scholarship-Claude (SS-Programme-Control P0, 27 Nov 2026 16:30 AEDT). Source: `pipeline.scholarship_ai_reviews`, AU providers, `status = 'pending'` (35 items), read live. Nothing here was admitted, refused or published by this lane. Decisions stay with a person in Layer 4 (Decision 263 rules `l4-held-sch-settle-v1` still apply).

## A. International audience and value both proven by the AI re-check (5): ready for a person

| Review id | Provider page | Evidence the re-check relied on | Note for the reviewer |
|---|---|---|---|
| 1184 | Macquarie, Vice-Chancellor's International Scholarship (`students.mq.edu.au/.../staging/...`) | Awarded to international students; up to AUD 10,000 off tuition | URL is a staging host path; confirm the public page (`mq.edu.au/.../international/vice-chancellor-s-internation...`, review 2270, no re-check yet) and keep one of the two |
| 1230 | Bond, Abedian Foundation Master of Architecture Scholarship | Page states a broad offering for domestic and international applicants | Value sentence present |
| 2316 | Murdoch, Trillion Trees Shirley Fyfe Honours Scholarship | Student type lists International and Domestic; value AUD 5,000 | |
| 2335 | CSU, Jacob Berry (foundation, any year) | International students classified in Australia may apply; value AUD 2,500 | |
| 2337 | CSU, Elders Rural (foundation, first year) | Same eligibility wording; value AUD 24,000 | |

## B. Value proven, audience not proven (21): reviewer needs the page

The re-check could not prove an international audience (`audience_not_stated`). Do not admit without a page sentence that names international students.

- **Likely international** (the re-check read an international audience, unproven): Griffith College diploma/degree (1970), Griffith GELI direct entry (1972), UNSW MBA waiver (2251), Trinity College foundation (2317), Melbourne blog on the Arts Global Languages Scholarship (2301, a blog, not the award page), Griffith news item (2327, a news item), ANU SESI (2328).
- **Both audiences, eligibility not stated**: UNSW 1847, 1484, 1248; UniSC Buranga Headstart (2315), UniSC 1996 Society Honours (2321), UniSC ACPIR (2322), UniSC HDR conditions (2330), Melbourne vacation scholarships (2329), UWA travel awards (2334).
- **Audience and value unclear**: ANU Sir Roland Wilson (2314), Griffith news item (2324), UWA Forrest (2325, repository page), ANU Shell Malaysia (2326), Deakin Valerie Johnstone (2332), ACU Ramsay acceptance form (2339, a form page, not the award page).

Page types that should likely be refused rather than admitted (news, blog, form, repository): 2301, 2324, 2325, 2327, 2339.

## C. Other (9)

- 2320 UTAS Crown Princess Mary Scholarship (timeline page): international audience proven, value not stated.
- 1947 TAFE SA news item: unsettled; a news item.
- No re-check yet (queued by the hourly rule, stored copy needed): 2249 SCU research futures, 2270 Macquarie VC International (see 1184), 2309 SCU VC regional leadership, 2340 Monash KC Kuok.

## Counts at read time (27 Nov 2026, 16:30 AEDT)

AU published 898 (889 on 26 Nov), AU unpublished 373, none eligible under `security.scholarship_publishability_v1`. Canonical published, all countries, 1,225; `website_v2_scholarships` total 1,225. The five most recently published AU awards (Alice Siu Medicine Scholarship, Randall Silcock Scholarship, Joan Lawrence AM Scholarship Endowment, Faculty of Medicine Medical Endowment Scholarship, Crawford Family Scholarship) resolve in `website_v2_scholarship` and `website_v3_scholarship`. Zoho (`zoho_edge_scholarships_v1`) and Portal reads were not verified.

## Exceptions recorded, not re-investigated

- Listing picker holds 333 AU due listing pages for held providers (SCH-FU-10; owner S1-Build, one-line change recorded there).
- Candidate and AI calls return `waiting_scraper`; 273 AU candidates due and unread (SCH-FU-02, 27 Nov entry; owner S2-Build).
- Tier tables with an international tier not mapped to the canonical value; value kind set without a number; linked rates (SCH-FU-02).
