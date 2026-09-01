# CourseFinder UAT & Performance Baseline v1.1

**Status:** CURRENT M2.5 BASELINE
**Date:** 1 September 2026
**Supersedes:** v1.0 while preserving its accepted evidence.
**Change Control:** CF-CHG-20260901-051

## Frozen M2.4 acceptance

M2.4 remains CLOSED/PASS:
- Pilot `95f2991e97e76e644bd74f73512b8bf2725fd4b7`;
- build `33468512538` PASS;
- final acceptance `33468512515` PASS;
- desktop 75 passed;
- mobile 76 passed;
- Security 146 INFO / 0 WARN / 0 ERROR;
- Performance 172 INFO / 0 WARN / 0 ERROR.

M2.5 changes do not reopen this evidence.

## M2.5 permanent source-contract coverage

`tests/uat/m2-5-platform-readiness-deployed.spec.mjs` validates:
- environment lifecycle and capability separation;
- no inferred Production source enablement;
- scraper and AI environment gates;
- dry-run retention and immutable classes;
- capacity/integrity threshold separation;
- fixed performance ceilings and no acquisition-on-read;
- reversible Layer 4 block scopes and rank boundary;
- no deletion/canonical mutation from block decisions.

The deployed UAT workflow routes M2.5 changes to this suite and includes it in integration/acceptance.

## Production/maturity catalogue

Required before Production acceptance:
- country Production canary;
- storage/capacity alerts;
- retention/purge dry-run;
- scraper Production enablement;
- AI Production enablement;
- serving-vs-ingestion load profile;
- representative concurrent workload;
- Production restore/DR.

These remain designed/not-run until a Production environment exists.

## Hard performance gates

Never weaken:
- RPC/detail interaction <= 3,000 ms;
- management/page payload <= 250,000 bytes;
- filter/options payload <= 60,000 bytes.

Bulk ingestion is measured separately from steady-state serving.

## Current M2.5 validation snapshot

Post-migration Pilot:
- Security Advisor 146 INFO / 0 WARN / 0 ERROR;
- Performance Advisor 174 INFO / 0 WARN / 0 ERROR.

Final implementation/UAT-wiring head at issue:
`dac23d68e6df230bc30c306fa7b61e720ecb431c`.

At issue time no terminal commit status had yet been published for that head. Record exact CI run IDs when terminal rather than polling indefinitely.
