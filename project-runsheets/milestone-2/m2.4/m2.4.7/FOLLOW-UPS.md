

**S1-ELR-Bands-And-Crawl, 21 Nov 2026 10:05 AEDT: s904 to s909 recorded before merge: band label fix, English band to course matching (`elr-band-v1.0`) and a one-off bounded fetch of 52 known central English pages (Pilot #1447, migration `20261121110000`)**

- **Request:** Platform Admin, 21 Nov 2026 09:00 AEDT.
- **Audit:**
  - The v1.1 band flag fired on 27 of 63 pages, every sampled trigger being IELTS score wording.
  - 89 universities (561 gap courses) have central pages found but not stored. 52 of those pages, at 40 universities, are fit to fetch.
- **s904:** reader v1.2; IELTS sub-score wording is no longer a band scheme.
- **s905:** band definitions are kept per university, never a study-level default.
- **s906:** a course whose page names exactly one defined band gets that band's values (insert only, s842 gates). Regulated disciplines and ambiguous cases go to Layer 4.
- **s907:** one-off fetch of at most 100 pages (52 queued) under an on-demand request scoped to central. Estimate 52 Firecrawl credits, from 67,187 left. No model.
- **Validation:** 85 specs passed and the rolled-back dry run passed. G3 75/48, manual locks 7,585, no new job.
- **Design:** `docs/platform/2026-11-21-s904-s909-elr-bands-and-central-fetch.md`.
- **Next:** auto-merge this record, then Pilot #1447, then read live.
