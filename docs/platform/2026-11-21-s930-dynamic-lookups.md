# Dynamic database-driven lookups (CF-247 s930)

**Date:** 21 Nov 2026 · **Chat:** S1-Dynamic-Lookups · **Directive:** Platform Admin 21 Nov 2026 11:52, 11:55 and 12:11 AEDT · **Release:** v2.16.75 · **Pilot migration:** `20261121190000`

## 1. What was wrong (read live, rolled back, 21 Nov 2026 12:05 AEDT)

- **The Entry requirements Provider list was cut.** `public.admin_aer` 'options' took the first 300 of the 843 providers with entry rows, in no order, and only then sorted them.
  - Typing "charles" found Charles Institute of Technology only.
  - Charles Sturt University (7 active rows) and Charles Darwin University (129 rows) were outside the 300.
  - The rule was not "0 canonical rows": both had rows.
- **Countries were written into seven screens** as AU, NZ and CA: Layer 4 Grid pills, Providers › Onboarding approvals, Enrichment plan, Description edits, Field coverage, Data quality and the ops pulse bars.
- **Years.** No UI filter holds a year list (Intake year already came from the rows). No live year-rollover rule holds a written year; the year literals beside "intake" or "year" in live functions are in messages and comments only.

## 2. The change

| Part | What it does |
|---|---|
| `public.admin_aer` 'options' (md5-guarded edit) | The Provider list is every active provider (3,090) and any provider with entry rows, sources or course rows, in name order. Each shows its active and waiting matrix rows ("no matrix rows yet" when it has none). Used by Provider entry matrix, Course entry requirements, Sources and Add a requirement. |
| `public.admin_lookups_v1` (new, read only, any assigned role) | Countries (active providers or admission target countries, with provider and course counts), study levels (`ref.study_levels`) and the rolling intake years. |
| Setting `lookups.intake_years_ahead` | Pipeline toolset, 2 years (range 0 to 5): this year (Melbourne time) and the next two. |
| `src/lib/lookups.js` (`useLookups`) | One read a page load, shared by every screen. |
| Screens | Country lists and pills come from the lookups. Destination country adds every target country. Intake year joins the rolling years with the years the rows hold. Help › Platform guide shows where data is admitted now, with live counts. |
| Rule | "Dynamic Database-Driven Lookups" in `CLAUDE.md` and `AGENTS.md` of both repositories. Guard: Pilot spec `cf-247-s930-dynamic-lookups-contract`. |

Provider pickers elsewhere already read the server live: Courses, Campuses and Scholarships page through every provider (`catalogue_filter_page`), and the Layer 4 university list lists the universities with waiting items.

## 3. Guardrails

- G3: 75 functions and 48 tables; both functions are admin functions, not consumer API.
- Manual locks 7,585 and the active cron jobs are checked before and after; no job is added.
- Nothing is dropped or deleted. Spend: none.
