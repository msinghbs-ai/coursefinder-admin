# Consumer request consolidation for Website API v3 (12 Nov 2026, 21:20)

**Mandate (Platform Admin, 12 Nov 2026):** review email (Gmail) and the platform to find every field the developers asked for and what was confirmed back; review the live code and strike out what is delivered; then (21:18) "all changes to consumer API is getting merged in next version API v3 as recorded in operational model ... check if apiv3 design document exists or how apiv2 is designed"; (21:20) "proceed and give the required files for v3 API so I can share with other continuous developing sessions"; (21:21) "file location or links from admin repo would be better to share".

**Result:** `docs/integrations/api-v3/` — build brief, 83-row request register (CSV) and a paste-ready build prompt.

## Summary

- 83 requests found (Divya 35, Raghav 43, Sujata and Saurabh 5), 14 May to 11 Nov 2026, from email and Raghav's four PDFs.
- Checked against deployed `website_v2_*`, `api.website_v2_*` and `zoho_v2_*` and live data: 34 delivered, 20 partly delivered, 18 open, 9 needing a new field, 2 declined.
- No standalone v3 design document existed. The design is Decision 277 (design reference), operating model §3.6 and the requirements register v2.11. v3 is not built yet (no `website_v3_*` function or v3 edge function on 12 Nov 2026).
- Decision 277 covers the Website API only; the Zoho functions sit in the frozen v2 surface. Zoho requests REQ-31, 34, 35 and the Zoho side of REQ-28 have no path: decision D-1.
- New repo items proposed for the register: R29 scholarship linked-course paging, R30 business school accreditations, R31 scholarships page link and last reviewed date per provider, R32 primary campus, R33 field dictionary with null meanings.
- Five Divya questions of 3 Nov are already answered by live v2 functionality (REQ-11, 25, 26, 29, 33); they need a reply, not a build.
- Ranking history with bands, ties and accepted editions is live (repo R25); Raghav can switch the Ranking Journey back on.

## Decisions requested (one at a time, brief §5)

D-1 Zoho path · D-2 study load and admission test data design · D-3 accreditations in scope · D-4 primary campus rule · D-5 rebuild repo R23/R24 in v3 and close the v2 draft.

## Source workbook

The working sheet (claude.ai artifact "StudySearch Requirements Register") holds the same 83 rows with live links to the original requests, the Platform Admin's replies tab and the v1 snapshot.
