# SS-020 implementation review (Decision 269)

**Date:** 4 November 2026, 05:10 to 05:40 AEDT
**Asked by:** Platform Admin, 4 Nov 05:10: "Review if changes were implemented"
**Checked:** Pilot `main` at `66ac60f` (v2.15.458); live admin v2.15.458 in the browser pane as Platform Admin; execution register lines for SS-020 (3 Nov 22:50 to 4 Nov 05:10). Read only; nothing changed.

## 1. Result

Steps 1 to 5 are live (v2.15.452, 454, 455, 456, 457). The menu is **47 tabs on 20 pages**, matching the Final board. (The review and Decision 269 said 22 pages. That was a counting error in the review: the menu has always had 20 pages.)

| Step | Release | Planned | Live check |
|---|---|---|---|
| 1 Dead sections | v2.15.452 (screens shipped with v2.15.453 after a Workers build failure, IQ-00190, closed) | Retire 10 sections | 9 of 10 done: Serper, ScrapingBee, Search pass, dropped fetchers, Go-live Layer 3 and dropped-provider gates, Health checks Layer 3 block (renamed area), Progress duplicate, Capacity link. 20 component register rows marked retiring; nothing dropped yet. **Refresh schedules section kept** (decision required, §2) |
| 2 Paging and length | v2.15.454 | Page long screens | Course sources 74,424 → 8,073 px; Automations 40,811 → 17,092 px (areas closed); Course entry requirements 100 a page; header strip on Operations only; Key dates edit in a drawer. **Layer 4 › Inbox still 22,118 px and still hits the database time-out on load** |
| 3 Two new tabs | v2.15.455 | Queues & yield; Services & limits | Both live. Pipeline yield sits first on Queues & yield (PIM Admin and above; loads slowly). Services & limits shows Firecrawl and OpenRouter cards; no Serper, ScrapingBee or ZenRows anywhere in Settings, Models & services or the Go-live checklist |
| 4 Layer 2/3 | v2.15.456 | Progress, Build adapter, run controls, scholarship settings, Inbox readiness | Live. Build adapter is a Universities row action. Tab order Operations · Universities · Enrich fields · Enrichment plan · Adapter builder · Course sources · Flags · Scholarships. Engine items (plan redo hold, retry, export, spend preview) shipped earlier under SS-018 (v2.15.419 and the 3 Nov plan continuity and lifecycle migrations) |
| 5 Catalogue and settings | v2.15.457 | QILT/PRISMS → Datasets; Link refresh → Settings | View data live on Datasets (opens at Viewer rank). **Link refresh kept on Coverage › Courses** (decision required, §2) |
| 6 Docs | in each release | Guide, SOPs, UI catalogue, component register | SOPs v2.25; UI catalogue v1.17 (v2.15.457); component register rows marked retiring |

## 2. Open items raised by the development session

| Item | What the session found | Recommendation |
|---|---|---|
| Refresh schedules and one-off runs (Automations) | It is the only working cadence control for Layer 1 register runs; Layer 1 › Sources' Schedule writes a value no job reads. The review was wrong to call it dead | Make Layer 1 › Sources' Schedule edit the 3 Layer 1 refresh policies, then retire the section |
| Link refresh and portals | Moving them to Settings would take them away from Operators (Settings is Platform Admin only) | Leave them on Coverage › Courses |
| Page count | Decision 269 says 22 pages; there are 20 | Correct the decision text to 20 |
| Datasets rank | Datasets opens at Viewer rank so QILT/PRISMS keep their audience; register and imports stay at Operator rank | Confirm |

## 3. Still to do

1. Layer 4 › Inbox: database time-out on load and length (22,118 px).
2. Refresh schedules rows still say "Layer 2 → conditional Layer 3".
3. Retiring component register rows leave by Platform Admin paste file after `hygiene.retire_after_days`.
