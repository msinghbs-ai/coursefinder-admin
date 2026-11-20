

**S1-ELR-Bands-And-Crawl, 21 Nov 2026 10:45 AEDT: s910 merged (Pilot #1448, d741077c; deployed 10:10 AEDT) and `elr-det-sweep` runs again (3 of 3 succeeded, 3.7 to 4.5 s). The live check found the two new worker modes unreachable; s913 is recorded before merge (Pilot #1451, migration `20261121140000`)**

- **The fault:**
  - Every s907 fetch call came back HTTP 422 "supported modes" from coverage-sweep.
  - In #1447 the band and fetch mode blocks sat after mode `read`'s return and before its closing brace, so they were unreachable code. esbuild and the type check both accept that.
  - Nothing was fetched and no Firecrawl credit was used. 30 pages were marked lost by the three refused calls.
- **s913 fix:**
  - The worker: the brace moves, so both modes are reachable. Spec s913 fails against the #1447 worker and passes with the fix.
  - The sweep: a fetch call refused with HTTP 422 returns its pages to the queue.
  - This migration queues the lost pages again. Rolled-back proof: 42 queued and 10 in flight, under the same on-demand request, open until 15:41 AEDT.
- **Live:** G3 75/48; manual locks 7,585; 137 active cron jobs, 0 unregistered.
- **v1.2 reads so far:**
  - 13 gave values without a study level;
  - 13 state no English test by level;
  - 6 add no level the approved policy lacks;
  - 4 are page texts already proposed (now held by s910);
  - 3 flagged as band pages;
  - 13 in flight.
- **Next:** auto-merge this record, then Pilot #1451, then read live.
