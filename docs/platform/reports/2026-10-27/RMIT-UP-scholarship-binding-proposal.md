# RMIT University Pathways (RMIT UP): scholarship binding and duplicate decisions — proposal

Platform Admin mandate 27 Oct 2026 12:27, item 4.
- **Read only.** Nothing was changed, no page was re-read and no AI or Firecrawl credit was spent.
- All 23 reviews stay pending until the Platform Admin makes the binding decision.
- Proposed paste: `docs/platform/pastes/PASTE-20261027-rmit-up-duplicate-reviews.sql` (count-guarded, **not applied**). Its rolled-back dry run on live passed (run 40433236252): 23 closed, 0 pending left, and review 1965 still pending.

> **Revised 27 Oct 2026 13:5x (Platform Admin 13:44): the closing paste now covers 22 reviews, not 23.**
> - China pathway review **1368** is **excluded**. It stays pending under RMIT UP for a human ownership judgement.
> - No provider ownership is changed and no admission is created.
> - The revised file (md5 `bc39ad5b…`) adds guards that 1368 is pending before the paste and still pending after it.
> - Rolled-back dry run on live (run of 27 Oct 13:5x) passed:
>   - 22 closed;
>   - 1 RMIT UP review left pending (1368);
>   - 1965 still pending;
>   - RMIT UP scholarships still 0.
> - **Held for separate application.** Sections 2–3 below list all 23 as investigated. The recommendation now applies to the 22, with 1368 excluded.

## 1 The two providers

| | RMIT University | RMIT University Pathways, RMIT UP |
|---|---|---|
| Provider id | 8e1adb6c-e069-43db-9584-bd054255e702 | 30b81368-9003-4775-81af-60439fc3b109 |
| CRICOS | 00122A (active) | 01912G (active) |
| Website | https://www.rmit.edu.au | https://www.rmit.edu.au/up |
| Active courses | 507 | 3 |
| Scholarships held (published) | 315 (47) | 0 (0) |
| Scholarship page candidates | 407 | 402, all from one sitemap run on 2 Oct; **none under /up**; 401 are the same pages as RMIT University's |
| Scholarship reviews | 104 | 85 (23 pending, 62 superseded) |

**Relationship:** RMIT UP is a separately registered provider (its own CRICOS code) that shares RMIT University's host.
- Its 402 candidates are the RMIT University scholarship sitemap (`/scholarships/...`), bound to RMIT UP because the two share a host.
- An identical address does not by itself prove the same provider scope. But none of these pages sits under RMIT UP's own path (`/up`), and every page except one is already a candidate of RMIT University.
- **Canonical owner of the 23 pages: RMIT University.**
- The one possible exception is review 1368 ("Four reasons to apply for RMIT's Pathway Scholarship for China", `/study-with-us/discover-rmit/...`). Its subject is a pathway scholarship. It was refused under RMIT University on 26 Oct (review 1955), so it is a person's call whether RMIT UP should hold its own record of it.

**Consumer risk today: none.** All 402 RMIT UP candidates are admit_status `rejected`, and RMIT UP holds 0 scholarships. The risk is in the future: admitting any of the 23 under RMIT UP would create a second scholarship for the same page under the pathways provider and its 3 courses. For 1570 and 1576 that would duplicate RMIT's published Vietnam PhD (review 1967) and the Australia Awards item (review 1965).

## 2 The 23 pending RMIT UP reviews

| RMIT UP review | Page (rmit.edu.au) | RMIT University counterpart | State there |
|---|---|---|---|
| 1636 | /scholarships/coursework/cpp | review 1969 | refused 26 Oct |
| 1627 | /scholarships/coursework/cultural-visions | review 1816 | refused 26 Oct |
| 1641 | /scholarships/coursework/unilodge-melbourne-flagstaff | review 1809 | refused 26 Oct |
| 1631 | /scholarships/coursework/hh-group-indigenous | candidate 254 | withdrawn (domestic only) |
| 1576 | /scholarships/international-scholarships/australia-awards-scholarships | **review 1965** | **pending** (approved pending technical resolution, event 21727) |
| 1623 | /scholarships/research/gold-based-drugs-for-the-effective-treatment-of-ovarian-cancer | review 1968 | refused 26 Oct |
| 1622 | /scholarships/research/phd-in-human-centric-cyber-security-… | review 1959 | refused 26 Oct |
| 1610 | /scholarships/research/phd-scholarship-for-women-in-stem | review 1320 | refused 26 Oct |
| 1592 | /scholarships/research/phd-scholarship-in-arc-coe-combs | candidate 140 | withdrawn (international not stated) |
| 1603 | /scholarships/research/phd-scholarship-in-computer-science-human-computer-interaction | review 1317 | refused 26 Oct |
| 1612 | /scholarships/research/phd-scholarship-in-hydrogen-ecosystem | review 1318 | refused 26 Oct |
| 1437 | /scholarships/research/phd-scholarship-in-organisational-ai-readiness-… | review 1802 | refused 26 Oct |
| 1605 | /scholarships/research/rmit-phd-scholarship-in-vietnam | candidate 32 | duplicate ("already held") |
| 1579 | /scholarships/research/rmit-phd-scholarship-in-vietnam-agent-based-machine-learning | review 1314 | refused 24 Oct |
| 1502 | /scholarships/research/rmit-phd-scholarship-in-vietnam-enhancing-education-with-ai | review 1298 | refused 24 Oct |
| 1590 | /scholarships/research/rmit-phd-scholarship-in-vietnam0 | review 2027 | refused 26 Oct |
| 1609 | /scholarships/research/rmit-vietnam-phd-scholarship-science | review 1369 | refused 26 Oct |
| **1613** | **/scholarships/research/rmit-vietnam-phd-scholarship-stem** | candidate 44 | **duplicate ("already held")** |
| 1611 | /scholarships/research/rmit-vietnam-scholarship | review 1297 | refused 24 Oct |
| 1453 | /scholarships/research/scholarships-for-vietnam-based-phd-candidates | review 1310 | refused 24 Oct |
| 1570 | /scholarships/research/school-of-science-engineering-and-technology-vietnam | review 1967 | **admitted 26 Oct** (the published Vietnam PhD) |
| 1591 | /scholarships/research/technology-assisted-professional-development-in-southeast-asian-… | review 1786 | refused 26 Oct |
| 1368 | /study-with-us/discover-rmit/reasons-to-apply-for-china-pathway-scholarship | review 1955 | refused 26 Oct (see 1 above) |

**Vietnam PhD (STEM), review 1613:**
- Under RMIT University, its page's candidate (44) is marked `duplicate` ("already held"): RMIT already holds a scholarship for it.
- It is **not related to review 1965** (Australia Awards). The RMIT UP twin of 1965 is review 1576.
- The Vietnam PhD published in the 26 Oct triage is review 1967 (School of SET Vietnam). Its RMIT UP twin is review 1570.

## 3 Recommendation (count-guarded; for a Platform Admin decision)

**Retain RMIT University's decisions as the only ones.** Close the 23 RMIT UP reviews as `superseded` (an existing status). Each note names its RMIT University counterpart.
- No provider ownership change, no merge, no transfer and no bulk approval.
- Review 1965 is untouched.

Guards in the paste:
1. Exactly these 23 reviews are pending under RMIT UP, and RMIT UP has no other pending review.
2. Each RMIT counterpart is in the state listed above.
3. 23 are closed; one event is logged.

**Follow-up for a later decision (not in the paste):**
- The binding that put RMIT University's sitemap under RMIT UP still exists: 402 rejected candidates. A later discovery run could create new RMIT UP reviews for the same pages.
- A provider-binding rule ("a provider whose website is a sub-path of another's takes only pages under its own path") would prevent this, but it is a code or rule change and is not proposed under this mandate.
