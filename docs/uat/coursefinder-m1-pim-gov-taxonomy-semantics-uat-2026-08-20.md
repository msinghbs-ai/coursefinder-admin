# CourseFinder M1-PIM-GOV — Course Taxonomy Semantic UAT

**Date:** 20 August 2026  
**Change Control:** `CF-CHG-20260820-010`  
**Status:** **DB/RPC PASS — FRONTEND/DEPLOYED BROWSER UAT PENDING**

## Reference identity

Exact CRICOS Course Code `121174E` — Swinburne University of Technology, Bachelor of Artificial Intelligence.

## Study Level result

- source scheme: CRICOS;
- source registration: `121174E`;
- exact source value: `Bachelor Degree`;
- mapping status: `mapped`;
- canonical code/name: `bachelor` / `Bachelor`;
- status: current;
- validity/snapshot/observed/last-verified timestamps retained;
- CRICOS source/evidence and hashes retained.

## Field of Study result

- source field code: `0201`;
- source field name: `Computer Science`;
- canonical code: `asced-0201`;
- canonical name: `Computer Science`;
- primary observation: true;
- status: current;
- CRICOS source/evidence retained.

## Assertions

| Assertion | Result |
|---|---|
| Exact CRICOS identity used | PASS |
| Original Course Level vocabulary retained | PASS |
| Mapping status retained | PASS |
| Canonical Study Level retained | PASS |
| Source Field code/name retained | PASS |
| Canonical Field retained | PASS |
| Source/evidence retained | PASS |
| Canonical Course/taxonomy rows unchanged | PASS |

## Frontend acceptance

Course detail should expose a compact Taxonomy/source-mapping section with canonical labels first and source vocabulary/evidence available for audit. The decision grid can remain concise.

**Verdict:** technical semantic read PASS; frontend presentation and deployed browser UAT pending.
