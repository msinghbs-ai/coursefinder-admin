# CF-CHG-20260907-238 — M2.4.5 Recovery Bounded Integration

**Status:** ACTIVE / INTEGRATION RUNNING  
**Milestone:** M2.4.5  
**Type:** RECOVERY / BOUNDED INTEGRATION  
**Date:** 7 September 2026

## Entry criteria

The bounded integration gate was nominated only after:

- v2.15.72 Compare/currentness build and targeted deployed proof passed;
- H3 Scholarship, H4 Jobs, H5 Manual PIM and H6 Publication Controls were retained closed by unchanged-contract impact analysis;
- CF-235 Layer 4 RPC security boundary closed targeted-pass;
- CF-236 remaining RPC security boundary closed with Security Advisor at 0 WARN;
- H11/provider-logo surfaces were re-proved targeted-pass after shared-host changes.

## Candidate

Pilot candidate head: `eaedfb2bb2926bb87a37f7a8ad59e89c808ca2ff`.

The existing permanent M2.4 integration suite is intentionally unchanged. It must run desktop and mobile and retain its encoded Layer 1–4, Evidence, performance, responsive, navigation, QILT/PRISMS Compare and currentness invariants.

## Governed decision rule

- PASS desktop + PASS mobile is required before any nominated acceptance.
- Any failure is immutable evidence.
- Correct only demonstrated defects.
- Do not weaken security, role/rank, Evidence, data-quality, Layer 1 authority, Layer 4 fail-closed, or publication-isolation semantics.
- Do not remove historical invariant suites merely because their names refer to later planning work; the bounded suite itself is part of the current acceptance contract.
- Do not perform an unchanged rerun.

## Active evidence

- CourseFinder Deployed UAT run `34070394953` — running.
- Pilot Frontend Build run `34070394985` — running.

## Next decision

If and only if bounded integration passes, reconcile the duplicate visible-version source and re-prove currentness before exactly one M2.4.5 acceptance nomination.
