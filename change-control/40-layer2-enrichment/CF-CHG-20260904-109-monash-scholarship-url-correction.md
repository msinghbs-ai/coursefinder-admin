# CF-CHG-20260904-109 — Monash Scholarship First-Party URL Correction

**Status:** CLOSED / PASS  
**Date:** 4 September 2026 (Australia/Sydney)  
**Milestone:** M2.4.5  
**Parent:** CF-CHG-20260904-108

## Correction
During first-party verification, the Monash International Leadership Scholarship detail route was resolved to the current live university URL:
`https://www.monash.edu/study/fees-scholarships/scholarships/find-a-scholarship/monash-international-leadership-scholarship-5571Z`

Runtime migration `cf_109_monash_leadership_first_party_url_correction` updates only the trace link and records the verification timestamp/change reference. No canonical scholarship facts or publication state were changed.

## Verification
The corrected URL resolves to the Monash University scholarship page and describes the International Leadership Scholarship for international students, including 100% course-fee support and four awards per year.
