# English policies in force — report (Decision 262)

**Date:** 17 October 2026 · **Change control:** CF-CHG-20260915-247, e151 · **Migration:** `20261017040000_cf247_english_policy_in_force`

**Platform Admin, 17 Oct 2026 15:01:** "One policy per uni and report it as well, also record it in admin repo."

## What was wrong

Automatic approval of AI readings (15 Oct) and the earlier written-out policies left universities with more than one approved English policy for the same study level. The 10-minute English job applied all of them, so a course could take its value from whichever policy ran first.

## What changed

| Item | Result |
|---|---|
| Universities settled | 27 |
| Level overlaps settled | 88 |
| Course rows moved to the policy in force (same value) | 630 |
| Courses sent to Layer 4 (values differ) | 4 (TAFE Queensland) |
| Duplicate policies closed | 40 |
| English flags still raised | 0 |

The rule now runs first in every 10-minute English policy run, so the overlap cannot come back.

## Policy in force, by university

| University | Level: policy page in force | Rows moved | Layer 4 | Closed |
|---|---|---|---|---|
| Adelaide University | UG, PG: adelaideuni.edu.au/…/entry-requirements/english-language-proficiency/ | 0 | 0 | 4 |
| AIH Higher Education | PG: aih.edu.au/students/entry-requirements/international-students/ | 0 | 0 | 1 |
| Australian University College of Divinity | UG, PG: aucd.edu.au/courses/master-of-divinity-korean/ (**a course page; needs a real policy page**) | 0 | 0 | 1 |
| Box Hill Institute | UG: boxhill.edu.au/international-students/international-applications/ | 0 | 0 | 0 |
| Charles Darwin University | UG, PG: cdu.edu.au/international/how-apply/entry-requirements | 0 | 0 | 1 |
| Collarts | UG, PG: collarts.edu.au/study-information/international-students/ | 0 | 0 | 6 |
| Curtin University | UG, PG: curtin.edu.au/…/english-language-requirements/accepted-english-qualifications/ | 86 | 0 | 1 |
| Deakin University | UG, PG: deakin.edu.au/international-students/entry-requirements/english | 0 | 0 | 2 |
| Flinders University | UG, PG: flinders.edu.au/international/apply/entry-requirements/english-language-requirements | 0 | 0 | 1 |
| Kwantlen Polytechnic University | UG: calendar.kpu.ca/admissions/english-proficiency-requirements/ | 37 | 0 | 1 |
| La Trobe University | UG: policies.latrobe.edu.au (policy 72); research: latrobe.edu.au/international/applying/entry-requirements | 0 | 0 | 1 |
| Monash University | UG, PG: monash.edu/admissions/entry-requirements/english-language; research: monash.edu/graduate-research/…/english-language-proficiency-requirements-for-admission | 145 | 0 | 1 |
| Queensland University of Technology | UG, PG, research: qut.edu.au/research/study-with-us/how-to-apply (the English for Academic Purposes course page closed) | 3 | 0 | 4 |
| RMIT University | PG: rmit.edu.au/…/international-students/…/english-language-proficiency-tests; UG: rmit.edu.au/…/local-student-applications/…/minimum-english-language-requirement (**a domestic page; same value 6.5; to be replaced by the international page**) | 118 | 0 | 1 |
| Sydney Metro College | PG: sydneymetrocollege.edu.au/entry-requirements/ | 0 | 0 | 0 |
| TAFE Queensland | UG, PG: tafeqld.edu.au English Language Equivalencies Table (PDF) | 0 | 4 | 2 |
| TAFE South Australia | UG: tafesa.edu.au/international/entry-requirements | 0 | 0 | 0 |
| Canberra Business and Technology College | UG: cbtc.edu.au 2025 Student Admission and Enrolment Policy (PDF) | 0 | 0 | 0 |
| University of Newcastle | UG, PG: policies.newcastle.edu.au (policy 165) | 37 | 0 | 1 |
| University of Notre Dame Australia | UG, PG: notredame.edu.au/…/english-language-proficiency-requirements | 70 | 0 | 1 |
| University of Queensland | UG, PG: study.uq.edu.au/admissions/english-language-requirements; research: policies.uq.edu.au (policy 231) | 0 | 0 | 2 |
| University of Sydney | UG, PG: sydney.edu.au/…/international-students/english-language-requirements.html | 0 | 0 | 2 |
| University of Canberra | UG, PG: canberra.edu.au/…/core-admission-requirements/english-language-requirements | 0 | 0 | 2 |
| University of New England | UG, PG: une.edu.au/international/apply/eligibility/english-language-requirements | 0 | 0 | 2 |
| University of Tasmania | UG, PG: utas.edu.au/study/apply/admission-requirements/english-language-requirements | 50 | 0 | 1 |
| Victoria University | UG, PG: vu.edu.au/…/entry-requirements-for-international-students | 84 | 0 | 1 |
| William Angliss Institute | PG: angliss.edu.au/…/how-to-apply/entry-requirements/ | 0 | 0 | 1 |

UG undergraduate, PG postgraduate coursework. Full detail (every policy that gave up a level, with its page and parser) is in the admin events (area `policies`, action `in_force`, 17 Oct 2026 15:54 Melbourne).

## For a person

| Item | What to do |
|---|---|
| TAFE Queensland, 4 courses in Layer 4 | Two associate degrees and two bachelor degrees in Engineering Technologies hold IELTS 6.0 from a written-out policy; the policy in force (equivalencies table) gives 6.5. Confirm which is right |
| RMIT undergraduate | Same value (6.5), but the page in force is RMIT's domestic entry page; add the international English page as RMIT's central page |
| Australian University College of Divinity | Only course pages were approved; add the university's English policy page |

## Also in this change

- The policy parser (v0.2.5) no longer reads a default from a section for courses with alternative or higher English requirements. The University of Tasmania page now reads 6.0 for both levels, as approved.
- After the parser change every approved policy was read again for the Duolingo English Test: 568 courses at 5 universities now hold a DET score.
