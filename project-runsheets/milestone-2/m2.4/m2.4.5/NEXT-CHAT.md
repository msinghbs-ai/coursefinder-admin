# M2.4.5 NEXT CHAT

## Active baseline — 11 September 2026

- Accepted deployed Pilot `main`: **`cfc4702ba57a58ea31936dcabbd96fdd765194e2`**, visible **v2.15.78**.
- Functional target-builder PR #69 merged as **`85bc068d379ed3fc9231d167cf524e56419e80f9`**; current forward corrective work is Pilot PR #71.
- Release-currentness PR #70 merged as **`cfc4702ba57a58ea31936dcabbd96fdd765194e2`**.
- **CF-CHG-20260910-093 is REOPENED. Do not describe it as CLOSED/PASS while the post-merge corrective gate is active.**
- Corrective Pilot PR #71 (`m245/cf093-postmerge-codex-20260911`) remains **draft/open and unmerged**.
- Current corrective exact head: **`f3622ff51654969fcd37961392b82449eb372218`**.
- Production is unchanged; M2.5 remains paused unless governance explicitly advances it.

## Preserved CF-093 authority boundary

The Scheduled Tasks builder remains deliberately narrow:

- AU Course Facts Layer 2 only;
- server-authorised Country / State-Territory / University-Provider scopes;
- Acquisition + deterministic Layer 2 only;
- mandatory server Preview before consequential dispatch;
- valid current profile version, deterministic execution policy, runtime-usable acquisition route and bounded profile size;
- underlying Layer 2 Jobs/Evidence remain authoritative processing truth;
- Layer 1 authority is unchanged;
- Layer 3 remains Evidence/profile/model/revalidation governed and is not generically dispatched;
- Layer 4 remains human/exception resolution and is not generically dispatched;
- Search and Publication remain separately governed downstream actions.

Still disabled: generic L2 -> L3 -> L4 orchestration, generic Evidence reprocess, NZ Layer 2 Course enrichment, arbitrary Layer 1 construction, recurring country/state construction, unsupported recurring university construction, implicit Search/Publication, and now **generic discovery-backed Scheduled Tasks dispatch** until Preview-bound async worker inputs/continuations are implemented and accepted.

## Current immutable Pilot runtime lineage

Applied identities must not be retimestamped or rewritten. Latest relevant forward migrations are:

- `20260911085724 cf_093_scheduler_postmerge_codex_finalizer`
- `20260911095142 cf_093_scheduler_exact_scope_codex_finalizer`
- `20260911095420 cf_093_scheduler_runtime_route_credential_finalizer`
- `20260911103931 cf_093_scheduler_runtime_semantics_finalizer`
- `20260911105517 cf_093_scheduler_browser_bridge_and_scope_binding_finalizer`
- `20260911111431 cf_093_scheduler_query_binding_and_ipv4_finalizer`
- `20260911114056 cf_093_scheduler_discovery_failclosed_and_runtime_parser_finalizer`

Important migration-history reconciliation: Pilot runtime had already applied `20260911111431 cf_093_scheduler_query_binding_and_ipv4_finalizer`; PR #71 had carried the same source under stale filename `20260911111622`. Source now uses the immutable runtime identity `20260911111431`; the stale timestamp alias was deleted. No applied migration was retimestamped.

## Latest Codex findings and correction

Codex reviewed PR #71 head `f280cc712071428c9ee28e811ae628a54f4d476b` and returned **six actionable findings: one P1 and five P2**:

1. **P1:** asynchronous discovery jobs were not bound to the exact Previewed profile/course/query inputs and could consume live values after Preview;
2. discovery-backed profiles could be accepted while an active deterministic batch later causes auto-sync to no-op;
3. non-direct provider `base_url` was not validated before Preview;
4. dummy `{query}` substitution did not prove the actual expanded discovery URL;
5. delimiter-concatenated fingerprint fields were ambiguous for arbitrary text;
6. hexadecimal/legacy WHATWG IPv4 forms could bypass the canonical-decimal URL guard.

The smallest safe forward correction is runtime/source migration `20260911114056 cf_093_scheduler_discovery_failclosed_and_runtime_parser_finalizer`:

- generic discovery-backed Scheduled Tasks now fail closed whenever the scope contains `source_url is null`; no async discovery request can be launched or Preview consumed through this builder until Preview-bound async payload/continuation verification exists;
- queueable deterministic Layer 2 remains supported under the existing exact Preview/run gates;
- non-direct provider routes require a strict HTTPS-valid provider base URL in addition to enabled/non-Parsebot/credential/budget/cost qualification;
- scope fingerprinting now hashes ordered structured JSON arrays rather than delimiter-concatenated arbitrary text;
- numeric/hex-like hosts are accepted only as exactly four canonical decimal IPv4 octets; legacy/hex WHATWG forms fail closed.

This is an authority reduction, not a relaxation. The six Codex threads were answered with evidence and resolved, and exact-head re-review was requested in PR #71 comment **`5633932810`**.

## Current acceptance evidence

- Exact-head Pilot Frontend Build **`34595439211` — PASS** on `f3622ff51654969fcd37961392b82449eb372218`; job **`103250001746` — PASS**. Build, UAT suite discovery and local browser smoke all passed.
- Pilot runtime migration **`20260911114056`** is applied after immutable `20260911111431`.
- URL parser proof: canonical `1.2.3.8` and HTTPS port `65535` accepted; `01.02.03.08`, `0x7f000001`, `0x7f.0.0.1`, `0x100000000` and port `65536` rejected.
- Nominated University of Queensland scope remains **382 courses / 156 queueable / 226 discovery** with **0** execution-policy, oversize and route gaps; it now intentionally has **1 discovery gate gap** and is non-executable from generic Scheduled Tasks until async binding exists.
- Queueable-only Nova Higher Education and Stamford scopes remain discovery-gap-free but currently each has an existing execution-policy gap, so neither is being used to manufacture a consequential acceptance pass.
- Security Advisor remains the known **191 INFO / 0 WARN / 0 ERROR** baseline.

## Exact next gate

1. Inspect the new Codex exact-head result for `f3622ff516...`; if actionable, correct forward-only and repeat exact-head acceptance.
2. Do not merge PR #71 while Codex review is pending or any required check is red.
3. Do not re-enable discovery-backed generic dispatch merely to satisfy UAT; implement a separate accepted Preview-bound async target/continuation contract first.
4. If exact-head Codex is clean, complete required queueable deterministic Layer 2 acceptance on a genuinely governed policy-qualified target; do not fabricate policy/configuration for test convenience.
5. Merge only the exact accepted head; after merge run deployed-currentness/UAT before returning CF-093 to CLOSED/PASS.
6. Keep broader orchestrator capability explicitly open/outside this boundary.

## Pickup text

> Continue CF-093 from repository/runtime truth. Deployed Pilot main remains `cfc4702ba57a58ea31936dcabbd96fdd765194e2` / v2.15.78. CF-CHG-20260910-093 is REOPENED and corrective PR #71 is draft/open at exact head `f3622ff51654969fcd37961392b82449eb372218`. Codex returned 1 P1 + 5 P2 findings on `f280cc712...`; runtime/source migration `20260911114056 cf_093_scheduler_discovery_failclosed_and_runtime_parser_finalizer` is applied forward-only. Generic discovery-backed Scheduled Tasks are now fail-closed until a separate Preview-bound async worker/continuation contract is implemented; queueable deterministic L2 remains the only executable intent. Applied migration identity `20260911111431 cf_093_scheduler_query_binding_and_ipv4_finalizer` is synchronised in source without retimestamping runtime. Pilot Frontend Build `34595439211` / job `103250001746` PASS, Security Advisor remains 191 INFO / 0 WARN / 0 ERROR, and exact-head Codex re-review request `5633932810` is pending. Preserve Layer 1 authority, Layer 2 Evidence truth, Layer 3 profile/model governance, Layer 4 human resolution, Search/Publication separation and rank/ACL boundaries. Keep generic L3/L4, Evidence reprocess, recurring country/state, NZ Layer 2 and implicit Search/Publication disabled. Do not merge until exact-head Codex and required targeted acceptance are clean.
