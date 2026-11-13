# RM1 Australia destination page — next chat

**Written:** 13 Nov 2026, 19:05 AEDT · **For:** a new chat continuing RM1 (Australia) on the destination roadmap.

Copy everything inside the box into a new chat in the StudySearch-Pilot project.

```
Continue RM1 (Australia destination page) on the StudySearch destination roadmap.

Read first, in this order (msinghbs-ai/coursefinder-admin, main):
1. docs/README.md (document router)
2. docs/Roadmap/2026-01/ROADMAP-ENGAGEMENT-REGISTER.md (logging rules; log one engagement row per work session in ROADMAP-ENGAGEMENTS.csv)
3. docs/Roadmap/2026-01/RM1-AUSTRALIA-PAGE-TRACEABILITY.md (summary, findings F1–F9, column mechanism, row-by-row trace, Admin module, Website v3 page contract)
4. docs/Roadmap/2026-01/mockups/australia-destination-mockups.html (six mockup views)
5. docs/Roadmap/2026-01/DESTINATION-DATA-DESIGN.md, sections "S1-RM-Design" and "RM delivery plan" (tables, DDL sequence M3–M5, build waves)
6. docs/Roadmap/2026-01/ROADMAP-MILESTONES.csv (RM0C–RM0F, RM1A–RM1K)
7. docs/integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md (consumer register; v3 additions recorded here)

Background: the Study Square destination brief (Australia sheet) is confidential. Its text copy is in this Claude project as claude/study-square-destination-data-sources.md. Never copy the workbook, its figures or staff comments into the admin repo (public). Design, topics and public official sources only.

Supabase project fxcwkweaxjtknorudmwp only (never coursefinder-demo). Verify live before claiming anything.

Steps, in order (stop and ask me only at a real decision):
1. RM1J: load THE 2027 through the existing ranking import; accept the edition; read it back on Website v3 provider ranking_summary and rankings. Record in the register and milestones.
2. Wave 2 per the delivery plan: RM0C destination core (destination schema, dataset_edition, locality, campus_locality, city_observation, publication_generation) plus the three new pipeline.sources columns from F9 (rights_mode, cadence, page_section). Dry run, md5-guarded, full suite 0 failed / 0 skipped, PR-first.
3. RM1B: register ABS ERP and the postcode-to-urban-area correspondence in Layer 1 › Sources with rights; load one edition; map campuses; ambiguous matches to Layer 4.
4. Wave 3: RM0D study rules core, then RM0F Destination data module with the Study rules tab first (match the mockup views 1, 2 and 4), then RM1C application routes.
5. Wave 4: RM0E destination action on Website v3 (module study_rules, cities, careers; paged, pinned to generation; statuses available / not_available / under_review / stale / not_applicable); then RM1H (scope per traceability §3 and F7), RM1I, RM1D (QILT permission gate F3).
6. RM1K: one golden fixture per traceability §3 row, checked on Admin and Website v3, before the Australia page is called complete.

Rules: Website v3 additions merge on green and are recorded in the developer register and v3 field definition; no v3 handover document until v3 release (RM0B). v2 stays frozen. Nothing activates in production because a check passed; activation is its own approved step. Every background job is registered in Automations or Jobs. Decisions still open: D-3 (accreditations, RM1F; Study Square confirmed global scope 13 Nov), D-4 (primary campus, RM1E), OET letter grades, QILT permission (Saurabh).

Report at each step: what was built, test evidence, live read-back, and the register and milestone rows updated.
```
