

**S1-ELR-Bands-And-Crawl and S1-ELR-Unblock-IQ00624, 21 Nov 2026 13:20 AEDT: closed and parked. s926 (Pilot #1454, 22d12bfd) merged by automerge after one re-run of a failed Workers preview build; migration `20261121173000` applied 12:28 AEDT; read live 13:15 AEDT**

- **IQ-00624 accepted:**
  - 34 completed `elr-det-sweep` runs since s910, every one succeeded (the 35th was still running at the read). The longest took 8.2 s, inside the 10 s limit.
  - There has been no `provider_policy_proposals_key` error since the fix.
- **Fetch under the new on-demand request:**
  - 48 pages stored, 2 failed (no content), 2 still in flight. About 61 Firecrawl credits were reported against an estimate of 52 (at most 78).
  - The sweep closes the request when the last two are in.
  - The first s907 request used 0 units.
- **Fetched pages read by v1.2:**
  - 9 gave new study-level proposals;
  - 18 state no test by level;
  - 11 give values without a study level, 2 of them band pages;
  - 1 adds no new level;
  - 8 are in flight.
- **All v1.2 proposals:** 4 approved (approved automatically under the disagreement check), 5 waiting for a person in Universities › English, 1 superseded.
- **Band reader:** live, but no university's central page labels a band with test values, so there are 0 band definitions and 0 band rows. Nothing has been spread or written.
- **Table 1:** 5,919 (AU 3,527, NZ 1,091, CA 1,301), down from 5,930.
- **Table 2:** 8,836 (AU 5,358, NZ 3,023, CA 455).
- **Live:** G3 75/48, no drift; manual locks 7,585; 136 active cron jobs, 0 unregistered. AI: US$0.
- **Lessons:**
  - Mode blocks are now guarded for reachability (spec s913).
  - An on-demand request must not close while calls are being refused (s913 returns their pages to the queue).
  - One answer can no longer stop a run (s910).
- **Next:** none in this lane.
  - 5 central readings wait for a person in Universities › English.
  - The sweep keeps reading pages by itself.
  - A band-to-course rule needs a university whose central page actually labels bands with values; none does today.

**S1-Impl-Layer4-Human-UI-Guide, 21 Nov 2026 13:40 AEDT: s931 recorded before merge (Pilot migration `20261121200000`, v2.16.76).** Decision 279 §5 to §8 built and live on deploy: Layer 4 primary row and Advanced filters (N); card zones with Yes / No / Resubmit to Review with AI and More options; reject chips; AI budget line; Lock this value; FieldGap pills and Add official URL; CoverageNotice; Platform guide Filters & badges, Layer 4 guide, worked examples. Fixes: Approve all verified for provider count, Course / University description split, one read for every Layer 4 count, CRICOS/NZQA code proof of course descriptions (12 admitted in the dry run). D3 filter arguments md5-guarded. s930 (v2.16.75) live and read back. G3 75/48, locks 7,585, cron 135.
