

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
