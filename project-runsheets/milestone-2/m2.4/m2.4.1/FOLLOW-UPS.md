# M2.4.1 — Follow-ups

**Status:** CLOSED / PASS

No M2.4.1 P0/P1 closure blocker remains.

## Closed evidence

- AU CRICOS live validation: 26,648 active / 90 expired / 26,738 total;
- NZ NZQA live validation: 411 current versus 409 accepted baseline; approximately 0.489% PASS variance;
- rank >=4 validation versus rank >=6 consequential action boundary;
- explicit warning acknowledgement and blocking-variance APPLY rejection;
- one-active-run, idempotency, retry/resume, cursor and cumulative reconciliation proof;
- scheduled non-destructive verification through one-time nonce;
- paused-source exclusion and stale scheduled-dispatch recovery;
- bounded stuck-run recovery;
- transient housekeeping preserving Evidence/source-operation versions/canonical history;
- final Security Advisor with no new material M2.4.1 Critical/High/Warning finding;
- final Performance Advisor with no unindexed Layer 1 foreign key;
- Data Operations Admin Guide v1.2, Operations Runbook v1.3 and PIM Admin Guide v1.21 current.

## Final staged UAT

- Stage A: `721658a732c763892179250fee1c0268bd27051d`, run `32971449084` — PASS;
- Stage B: `98172a4f616291212253c23f16fe1ab633b9c34b`, run `32971584012` — desktop/mobile PASS;
- Stage C: `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`, run `32972106291` — desktop/mobile PASS;
- final build `32972106272` — PASS.

The earlier rejected Stage C run `32970866977` exposed only a stale permanent-test pin to PIM Admin v2.15.6; it was corrected and the full staged chain was restarted without product/runtime semantic change.

## Carry-forward outside M2.4.1

- NZ first-party Layer 2 Course enrichment remains deferred pending future source qualification/onboarding.
- M2.4.2 must capture full-run Layer 2 performance, provider economics, Evidence growth and Layer 3 fall-out before tuning concurrency/schedules.
- Cross-layer operational alert consolidation remains for M2.4.2/M2.4.4 where it spans provider quota/spend and multiple layers.
- Guides/Runbooks/release notes remain a standing closure requirement for every later sub-milestone.

M2.4.2 is now authorised to begin.