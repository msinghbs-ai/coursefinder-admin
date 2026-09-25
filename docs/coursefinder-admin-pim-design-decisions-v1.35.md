# CourseFinder Admin/PIM Design Decisions v1.35

**Status:** CURRENT M2 DESIGN DECISIONS  
**Date:** 26 September 2026  
**Supersedes:** v1.34  
**Change Controls:** CF-CHG-20260903-083, CF-CHG-20260903-084, CF-CHG-20260915-247

## Decisions 38–129
Decisions 38–83 from v1.31, 84–123 from v1.32, 124–128 from v1.33 and 129 from v1.34 remain authoritative and unchanged, except where Decision 133 below supersedes the A24 unified dark Layer header (CF-CHG-20260830-048).

## Decision 130 — Screen reviews use captured screenshots
Screen-by-screen reviews use the "UI review screenshots" workflow: it signs in as the UAT user, waits until the screen's data has loaded, captures the full screen and commits the images to the separate ui-review-snapshots branch, never to main. E-mail addresses and the signed-in user's details are always masked; screens showing personal data are not captured unless masked, because the repository is public.

## Decision 131 — The UQ rule also matches UQ's fee explanation
The UQ provider rule also admits a fee when UQ's fee explanation ("Approximate yearly cost of full-time tuition") is followed by the exact amount, with no exclusion words beside it. The year is recorded only when it is printed beside the amount and no other year appears in the same text; otherwise it is left blank. Applied 26 September 2026: 24 items, 14 courses.

## Decision 132 — One current provider tuition per course
Each course has one current provider tuition record per audience. When several active records have the same amount, one stays: a person's Layer 4 decision first, then a stated year, then a provider-rule admission, then the most recently verified. The kept record takes the approved provider rule's wording where one applies. Others are marked "superseded" and kept for audit, never deleted. Records with different amounts are left for a person. A database trigger applies this to every new admission; the first run resolved 14 courses.

## Decision 133 — One title per screen (supersedes A24)
Each Layer screen shows its title once, as the page title. The Layer header is a slim, light bar with the screen's one-line purpose and its refresh button; it no longer repeats the title in a dark banner. This supersedes A24 (CF-CHG-20260830-048), which required all four Layer screens to share a dark header. Pop-up versions keep their own title because it is their only one.