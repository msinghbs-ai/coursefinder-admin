# CF-CHG-20260910-093 — Runtime Operations Follow-on

This document supersedes continuation through Admin PR #34. It does not rewrite or invalidate merged Pilot PR #72 or any applied Pilot migration.

## Current continuity

- Pilot PR #72 is merged.
- Remaining closure/operational work continues in a new Pilot follow-on PR linked to Coursefinder-Pilot issue #74.
- Admin PR #34 is superseded by the replacement Admin follow-on PR from the same exact head plus this continuity record.
- Codex exact-head review is deferred assurance only because usage was exhausted. It must not be represented as completed.
- Gitar is the active reviewer for the replacement follow-on PRs.

## Governance corrections carried forward

The replacement Admin PR must resolve, not suppress, the previously identified governance defects:

1. use the full scheduler authority identifier `CF-CHG-20260910-093` where ambiguity with older `CF-093` shorthand could occur;
2. preserve mandatory server-side Preview before consequential dispatch;
3. remove obsolete Pilot-head and target assumptions and use current-main, policy-qualified target selection;
4. do not dispatch a target with an execution-policy/profile/route gap;
5. keep applied migration history immutable and forward-only.

## Next operational objective

Scheduled Tasks now moves from functional acceptance toward runtime operational maturity. The next workstream must collect real runtime evidence and tune only from observed data.

Required operational measurements include:

- queue wait and execution duration;
- processed items and effective throughput;
- deterministic Layer 2 versus discovery workload mix;
- retry/attempt/exhaustion behaviour;
- dedupe/replay outcomes;
- failure/completion classes;
- Evidence yield and accepted/applied results where exposed by governed interfaces;
- per-policy/provider/scope last success and failure;
- scheduler/acquisition/processing phase timing where runtime already exposes those boundaries.

Missing values remain unknown. Do not manufacture measurements, routes, policies, profiles, URLs, capabilities or credentials.

## Tuning authority

Tuning is allowed only when the relevant setting already exists in governed configuration and a before/after bounded comparison can be produced. Candidate areas are batch/chunk size, concurrency, retry bounds, freshness/cadence, query/index performance and dedupe windows.

Every material tuning change must preserve:

- Layer 1 regulatory/identity authority;
- deterministic, Evidence-preserving Layer 2;
- exact Preview/token/fingerprint/identity provenance;
- Layer 3 Evidence/profile/model/revalidation governance;
- Layer 4 human resolution;
- Search/Publication separation;
- rank/ACL/private-helper/service-role boundaries;
- fail-closed generic async discovery outside explicitly governed Preview-bound continuation contracts.

## Closure

`CF-CHG-20260910-093` does not return to CLOSED/PASS merely because PR #72 merged. Closure still requires current-main consequential acceptance on genuinely governed targets, deployed-currentness/UAT evidence and authoritative Admin reconciliation. Runtime-efficiency work may continue in parallel, but must not be used to manufacture closure evidence.