

**S1-ELR-Unblock-IQ00624, 21 Nov 2026 11:20 AEDT: IQ-00624 cleared and s926 recorded before merge (Pilot #1454, migration `20261121173000`)**

The Platform Admin's message came at 10:57 AEDT.

- **IQ-00624:**
  - s910 (Pilot #1448, d741077c) merged at 10:09 and deployed at 10:10. Its admin record #740 merged first.
  - Since then `elr-det-sweep` has run 11 of 11 times unattended (10:12 to 11:02 AEDT, 2.6 to 4.5 s) with no `provider_policy_proposals_key` error.
  - Superseded elr-central-v1.0 proposals are never reactivated. A page text that was already proposed is held with that reason (4 pages so far).
- **Downstream processing has started:** v1.2 central reads are running. So far:
  - 50 give values without a study level;
  - 48 state no English test by level;
  - 29 add no level the approved policy lacks;
  - 10 are flagged band pages;
  - 4 are page texts already proposed;
  - 11 are in flight.

  No band definitions yet: no page read so far labels a band with test values.
- **s913 (Pilot #1451, 31699db9)** merged and was deployed at 10:50. The worker modes are reachable, and pages lost to calls the worker refused went back to the queue.
- **Fetch:** the s907 request had been closed at 10:42 with 0 Firecrawl units used, while every call was refused.
  - The Platform Admin answered "Reopen and fetch" at 11:05.
  - s926 opens one new on-demand request (Firecrawl only, scope central) for the 52 queued pages. Estimate 52 credits (at most 78), from 67,120 left; AI US$0.
- **Live:** G3 75/48; manual locks 7,585; 136 active cron jobs, 0 unregistered.
- **Next:** auto-merge this record, then Pilot #1454; read the fetch live; close; sync Drive.

## 21 Nov 2026 12:40 AEDT — S1-RM-Design: s927 daily data gap register (course × field by country; institutions; closed since last register), not shared

The Platform Admin asked at 21 Nov 2026 12:19 AEDT for daily gap registers in Drive › Monitoring, with detail on the institutions being worked on and per-country daily updates, a row leaving once its field is admitted. He chose course × field rows, all open gaps (including "not published by the provider"), and no sharing yet.

- **Pilot (spec s927, no migration, no API change).**
  - `scripts/telemetry/data-gap-register.mjs` builds the register from the existing 07:30 readiness read (workflow `Course field readiness`).
  - It writes per-country course × field CSVs, institution × field CSVs, the gaps closed since the last register, the sheet tabs, and a gzip state that carries each gap's first-seen day.
  - The readiness SQL gains one read-only `raw` column holding the coverage state behind each non-admitted field (about 0.6 MB more per part).
- **Gap types:** Being checked; Waiting for a person; Page not found yet; No website on record; Site blocked; No reader yet; No scholarship found yet; Not published by the provider.
  - Not-started country scopes are counted on Summary only.
  - `fee_basis` is a gap only when the fee is held.
- **Drive.**
  - New Google Sheet `StudySearch_Data_Gap_Register` (`1GEbtc_I_EtubfJ7hDa4llp1QhDEHdiPhae8mDqcguGk`) in Monitoring, with tabs Summary, Institutions_Top, Closed_Today, Files and Run_Log.
  - New scheduled task "Data gap register to Drive (08:07)" (`trig_019UmEjiuMzPiWfev6ospuFJ`, automatic approval). It uploads the CSVs, keeping the latest only and the closed files for 14 days, then refreshes the sheet. It never shares anything.
- **Docs:** runbook `docs/platform/DATA-GAP-REGISTER.md`; test register row s927.
- **Next:** dispatch the workflow once now and run the task once, so today's first register is live; share only when the Platform Admin says so.

**S1-Dynamic-Lookups, 21 Nov 2026 12:45 AEDT: s930 recorded before merge (Pilot migration `20261121190000`, v2.16.75).** The Entry requirements Provider list held an arbitrary 300 of 843 providers; it now holds every active provider (3,090) with its matrix row counts. New `public.admin_lookups_v1` (countries, study levels, rolling intake years) and setting `lookups.intake_years_ahead`; seven screens and the Platform guide read it; standing rule "Dynamic Database-Driven Lookups" in CLAUDE.md and AGENTS.md. IQ-00445 closed (37.6 s, 50.9 s, 49.8 s). G3 75/48, locks 7,585, cron 135.
