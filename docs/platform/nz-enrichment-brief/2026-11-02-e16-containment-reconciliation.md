# E16 containment reconciliation (2 Nov 2026, 10:30 AEDT)

**Authority:** Platform Admin 2 Nov 2026 07:21 (`2026-11-02-e16-final-disposition-decision.md`) §2 and §6; 07:41 §5.
**Controller:** integrator, the only writer. Every write ran in an allowed minute under `PRODUCTION-VALIDATION-LOAD-POLICY.md`.
**Prepared files:** `ui-audit/e16plan2/` (report.md with the per-course table, apply-hold.sql, contain-links.sql, fees.sql, layer4.sql, layer4-BC2.sql).
**Classification:** a candidate assessment (title and address), not proof. Every hold has a route back.

## Sequence

| Time (AEDT) | Step | Audit |
|---|---|---|
| 09:15 | v2.15.402 live: one page check for every linking lane, including the award lane; projection prefers the course's own page when it passes | PR #794, migrations `20261102030000` and `20261102040000` |
| 09:16 | Search refresh #7725: **24 of 67 confirmed courses now show their own page** (projection choice) | — |
| 10:05 | **Part B:** 15 award links the new check refuses set to `unverified`, not primary, with a page rejection each | event #28603 |
| 10:05 | **Part C2:** 2 Federation sweep links (award rows already off) set the same way | event #28604 |
| 10:15 | **F2a:** 6 fees copied from a refused parent award link withdrawn (amount not consistent with the register) | event #28605 |
| 10:15 | **F2b:** 4 fees copied from a refused parent award link withdrawn (the amount matches the CRICOS register, but the source is another programme's page; the CRICOS fee remains shown) | event #28606 |
| 10:25 | **Layer 4:** 17 course-link items (`official_course_url`), one per contained course, through `binding_refusal_route_v1` | event #28608 |

## §6 metrics

| Metric | Value |
|---|---|
| Records assessed | 77 courses (snapshot 2 Nov 07:29, re-read after refresh #7725 at 09:16): 67 confirmed (candidate), 9 unclear, 1 false positive |
| Valid records | 1 false positive (Lennox 108224J), unchanged. 14 award links accepted by v2.15.402 on recorded or page-named evidence (C1), unchanged pending decision |
| Wrong or unsupported published values before containment | 67 links (all 67 confirmed showed a sibling or older-year page at 07:29); 31 sibling-page fees active |
| Contained: links | **24** by the projection choice (own page now shown), plus **17** by status `unverified` (parts B and C2). Read-back: 17 of 17 `unverified`, 0 still shown, 17 show no link. Website `item.official_url` and Zoho `item.official_course_url` are null on 107421A, 085206E and 014891M |
| Contained: fees | **10** withdrawn (F2a 6, F2b 4): read-back 10 inactive. CRICOS fields unchanged |
| Routed to Layer 4 | **17** course-link items (kind course_link, field `official_course_url`) |
| Existing pending items reused | 0 (none existed on these courses) |
| New items created | 17. Dedupe: the route's own lock and Decision 263 check; post-run check of 0 courses with more than one pending item |
| Automatically resolved | 24, by the v2.15.402 projection rule (show the course's own page when it passes the page check) |
| Needing new evidence | 17 contained courses show no link until a reviewer confirms their own page in Layer 4 (no paid acquisition) |
| Manual locks preserved | Guards: 0 hand locks on any changed link or fee; no link set by a person was changed |
| Consumer-visible incorrect values remaining | **26** links: **12** group (a), awaiting the hold decision below, and **14** group C1, awaiting the evidence decision below. **2** fees in F1 (Flinders 105122F, UQ 116548M), waiting on group (a). **14** fees in F3, tied to C1 |
| Records deleted | **0** |
| Regression tests | s214 (16 fixture groups), s215; full suite 1,431 / 0 / 0 on v2.15.402 |
| Unresolved exceptions | Below |

## Unresolved (decisions for the Platform Admin)

1. **Group (a), 12 courses:** the existing SS-007 hold (`binding_remediation_apply_v1`) fits these; their bound page is the wrong page. Side effect: the hold takes back 12 recent URL fills, so the fill retraction rate goes over 5% and job `course-url-fill` **pauses itself platform-wide**.
   - **Option 1:** accept the pause and re-arm it after review.
   - **Option 2:** contain these 12 the same way as part B (link `unverified` plus page rejection, no URL-fill retraction), then use the hold later.
   - The integrator recommends **option 2**: same consumer effect, no platform-wide pause.
   - F1 (2 misread fees) follows group (a).
2. **Group C1, 14 courses:** v2.15.402 accepts these award links on recorded or page-named evidence (your evidence rule), but the cohort classed them as sibling pages from title and address.
   - Contain them only if you rule that the title and address classification overrides the recorded evidence. Otherwise they stay as valid nested-award links.
   - F3 (14 fees) follows the same ruling.
3. **The 9 unclear courses:** no change. They need a person (handbook codes that do not name the award).
4. **The 24 projection-fixed courses:** the wrong link is still active but hidden. Clean-up is part of E16-3 (housekeeping, multi-link courses).
