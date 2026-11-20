

**S1-ELR-Bands-And-Crawl, 21 Nov 2026 10:15 AEDT: s904 to s909 merged (Pilot #1447, f779b439; migration `20261121110000`; deployed 09:41 AEDT). The live check found `elr-det-sweep` failing on every run since 08:47 AEDT; s910 is recorded before merge (Pilot #1448, migration `20261121120000`)**

- **The failure:**
  - The central writer re-read a page whose identical text already had a superseded elr-central proposal, and its insert hit the unique key `provider_policy_proposals_key`.
  - The error was raised during the answer read-back, before the lost-call step. So every run failed on the same answer (request 898146, sent 08:42 AEDT), and nothing after it ran.
  - Nothing reached Firecrawl. The s907 fetch has not started: 52 pages are queued and no credits have been used.
  - The fault came in with s896, which explains why the earlier closing record's "5 of 5 runs succeeded" was true only up to 08:47.
- **s910 fix:**
  - A page text that already has a proposal is not proposed again, and its reads are held with that reason.
  - Each answer is recorded in its own sub-transaction; one that fails is marked failed and the run goes on.
  - Rolled-back proof: one sweep run completed in 1.2 s, reading back the stuck answer, applying 2 policies and sending 11 central pages and 10 fetch pages.
- **Live after #1447:** G3 75/48; manual locks 7,585; 133 active cron jobs, 0 unregistered; on-demand request open until 15:41 AEDT, estimate 52 credits, 67,177 credits left.
- **Validation:** spec s910 3 of 3; the guards pass.
- **Next:** auto-merge this record, then Pilot #1448, then read live.
