# Decision package from the 23:24 direction — status (Integration Controller, 2 Nov 2026 23:30 AEDT)

Source: `2026-11-02-overnight-continuous-delivery-direction-2324.md` §1. The direction calls these "recommended dispositions to prepare and validate", recorded as **proposed** until the Platform Admin's explicit approval where required. Each is built switched off or at current values, regression-tested, and released only as preparation; activation is a separate recorded step.

| Item | Disposition (proposed) | Workstream / branch | Activation needs explicit approval? | Status |
|---|---|---|---|---|
| Scholarships: non-university eligibility | Through existing provider-type governance, subject to verified source identity and scope | B · cf247-scholarship-recovery | Yes | Building (ships off) |
| Scholarships: 30-course minimum | Replaced by evidence-based legitimacy checks | B | Yes | Building (ships at current value) |
| Scholarships: past records | Kept as historical "closed", never shown as currently open; evidence kept | B (F9) | Yes if the consumer API field semantics change (G3) | Building; G3 impact assessed in the branch |
| Firecrawl after 02:57 | Normal approved limits restored and verified | Integrator (scheduled 03:05–03:08) | No (restores prior approved values) | Scheduled |
| AER D-R1 global qualifications | No fabricated country; issuer, identity, level, scale, evidence, restrictions, provider kept | Qualification model (D-A5 approved) | Yes for any consumer API field (D-A6, G3) | Next after A |
| AER D-R2 supersession | Atomic, immutable history, no duplicate active review, no auto-approval, reviewer diff, locks protected | A · cf247-aer-dr2-dr3 | Yes (changes the Layer 4 lifecycle) | Building |
| AER D-R3 matrix completeness gate + the 170 E13 bypasses | Approval refused when completeness can't be shown | A | Yes (changes admission gating) | Building |
| Descriptions 1,200 characters | Setting 900 → 1,200 with regression fixtures; no truncation | C · cf247-pdesc-page-choice | Yes (setting value) | Building |
| Intake "Semester 1 and 2" | Both periods named; dates only from the approved calendar's dated start | D · cf247-intake-semester-pairs | Yes (rule change) | Building |
| Weekly AER report | Existing mechanisms only: e-mail via the alert route, snapshot branch `aer-weekly-snapshot`, Admin dashboard; no new credential | Released in v2.15.408 (switched off) | Switch-on is routine after verification | Ready |

Other overnight work (authorised, no new approval): v2.15.409 integration queue (F); course-url-fill respects pending Layer 4 items (E); pipeline yield and hidden-failure checks (F follow-up).
