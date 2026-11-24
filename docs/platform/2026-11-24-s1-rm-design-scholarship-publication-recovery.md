# Scholarship publication recovery from existing data — S1-RM-Design, 24 November 2026

Mandate: Platform Admin 24 Nov 2026 18:02 AEDT (scholarship publication recovery, existing data only; no new readers, no new jobs, US$0 AI, zero Firecrawl,
no relaxation of admission or publication rules). Lane boundary: S1-RM-Design owns the existing admission and publication backlog; readers stay with
S1-Scholarship-Claude (AU), S2-Scholarship-Readers (CA) and S3-Scholarship-ChatGPT (NZ); shared function changes are coordinated with S1-Build.

## Baseline (live, 24 Nov 2026 18:10 AEDT)

| Metric | Live |
|---|---:|
| Published scholarships (active) | 1,096 (AU 837, CA 148, NZ 111) |
| Publishing providers | 114 (AU 66, CA 37, NZ 11) |
| Active unpublished | 492 (AU 335, CA 108, NZ 49); the brief's 488 was AU 331 |
| Scholarship Layer 4 pending (`pipeline.scholarship_ai_reviews`) | 72 (AU 33, CA 21, NZ 17, 1 without a country) |
| Providers with Layer 4 pending | 31 |

Active unpublished is moving during the session as reader lanes admit new records (AU 340, CA 112 at 18:18).

## Every unpublished award by its exact publication blocker (`security.scholarship_publishability_v1`)

| Blocker | Awards | Disposition |
|---|---:|---|
| None (publishable; not yet reached by the hourly `scholarship-auto-publish`) | 18 (AU 4, CA 14) | Published by the scheduled run, no change needed |
| No stated award value, alone | 191 (AU 118, CA 48, NZ 25) | Genuine for 187: the stored verdict says not stated (118), non-monetary (22: accommodation, airfare, waivers with no figure), or a number that is not the award (see below). 4 hold a value a person can confirm (below) |
| Applications have closed (with or without no value) | 143 | Genuine: no stored page shows a later closing date than the record |
| Held after hand-check / refused in Layer 4 | about 60 | Human decisions, preserved |
| Not for international students, domestic only, page does not mention international | about 45 | Genuine eligibility, preserved |
| **Provider page limits it to citizens and residents, alone** | **14** | **9 technical false holds, fixed by s1073** (below); 5 genuine or ambiguous |
| Another edition listed, news item, other combinations | rest | Genuine |

## s1073 (technical fix): international students named in other words

The check held an award whenever its stored eligibility excerpt named citizens or permanent residents and did not contain the word "international".
Excerpts that open the award to international students in other words were held: "Open to foreign nationals holding Canadian study permits" (BMO,
Mike Wolowyk, Bill Preshing, Chevron, Mahatma Gandhi, J Macgregor Smith), "or foreign national enrolled in a doctoral program" (Pierre Elliot Trudeau),
"Visa Students. Foreign students ... are eligible" (Ontario Graduate Scholarship) and "must: not be a domestic student" (Griffith International
Postgraduate Research Scholarship). The check now also accepts precise international phrases (foreign national(s), foreign student(s), overseas
student/applicant/candidate(s), student visa, study permit, subclass 500, "not be a domestic student"); bare "overseas" stays out ("be born overseas"
describes a resident), and excluding wording ("must not hold a student visa", "overseas students are not eligible") still holds. The rehearsal proved
no other reason moved for any record and the check only clears. Expected: 9 publications (8 CA, 1 AU) on the next hourly run after deploy.

## Not fixed by machine: decisions for a person

1. **Award value stated on the page, international value (4 awards).** Decision 245's page-tier rule (`security.scholarship_award_tiers_from_page_v1`,
   never scheduled) would write wrong values for most of its candidates (months read as dollars, a part-time stipend share read as a tuition
   discount, a book allowance read as the award, domestic figures shown to international students), and a general text rule picked the wrong figure in
   4 of 8 cases, so no rule was applied. A person can set these in the Scholarship record (Admin › Scholarships › record › Edit):
   - `a4d0fb6c` Undergraduate Scholars Entrance Scholarship (CA): "$140,000 for international students" (domestic $20,000 to $60,000).
   - `bbf88709` Access Scholarship (AU): "International Students: up to $1,000 per scholarship".
   - `0e9f6a73` ACU Industry PhD Scholarship (AU): "Living allowance of AUD $34,315 per annum (full-time)".
   - `81a72eb4` Graduate Research Scholarship Package (AU): international stipend AUD $35,550 a year and tuition scholarship AUD $35,768 a year.
2. **"Citizen of a country other than Australia or New Zealand" (4 refused verdicts).** The worker's audience proof needs international wording or a
   named foreign country, and Australia and New Zealand do not count for each other, so these verdicts were refused. The fix belongs in the reader's
   proof rule (S1-Scholarship-Claude / S2-Scholarship-Readers), and no $0 replay of proof checks exists today; a person can admit them in Layer 4.
3. **Pathway colleges (scope, about 470 refused candidates).** "Not a university provider in a scholarship country": RMIT University Pathways (122),
   UQ College (110), University Senior College at Adelaide (56), UWS College (9) and private VET colleges. Admitting them widens scholarship scope (as
   the Platform Admin decided for ten Canadian colleges); it is the Platform Admin's decision, not a technical fault.
4. **Layer 4 pending (72):** 50 re-checked as "who it is for is not stated" (genuine); 2 meet every condition of the settle rule but are correctly held
   (`/staging/` page; candidate already admitted); 11 have no re-check because there is no stored copy; the rest are unclear values or unsettled.

## Spend

No model calls, no tokens, US$0, no Firecrawl credits. No new job (active cron unchanged), G3 75/48, manual locks 7,585 unchanged.
