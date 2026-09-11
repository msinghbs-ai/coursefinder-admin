# M2.4.5 NEXT CHAT

## Active baseline — 11 September 2026

- Accepted deployed Pilot `main`: **`cfc4702ba57a58ea31936dcabbd96fdd765194e2`**, visible **v2.15.78**.
- Functional target-builder PR #69 merged as **`85bc068d379ed3fc9231d167cf524e56419e80f9`**.
- Release-currentness PR #70 merged as **`cfc4702ba57a58ea31936dcabbd96fdd765194e2`**.
- **CF-CHG-20260910-093 is REOPENED. Do not describe it as CLOSED/PASS while the post-merge corrective gate is active.**
- Corrective Pilot PR #71 (`m245/cf093-postmerge-codex-20260911`) remains **draft/open and unmerged**.
- Current corrective exact head: **`25b51d435411c56c2c87172d4004ecafc61dd06d`**.
- Production is unchanged; M2.5 remains paused unless governance explicitly advances it.

## Preserved CF-093 authority boundary

The Scheduled Tasks builder remains deliberately narrow:

- AU Course Facts Layer 2 only;
- server-authorised Country / State-Territory / University-Provider scopes;
- Acquisition + deterministic Layer 2 only;
- mandatory server preview before consequential dispatch;
- valid current profile version, deterministic execution policy, runtime-usable acquisition route and bounded profile size;
- underlying Layer 2 Jobs/Evidence remain authoritative processing truth;
- Layer 1 authority is unchanged;
- Layer 3 remains Evidence/profile/model/revalidation governed and is not generically dispatched;
- Layer 4 remains human/exception resolution and is not generically dispatched;
- Search and Publication remain separately governed downstream actions.

Still disabled: generic L2 -> L3 -> L4 orchestration, generic Evidence reprocess, NZ Layer 2 Course enrichment, arbitrary Layer 1 construction, recurring country/state construction, unsupported recurring university construction, and implicit Search/Publication.

## Current immutable Pilot runtime lineage

Applied identities must not be retimestamped or rewritten. Latest relevant forward migrations are:

- `20260911085724 cf_093_scheduler_postmerge_codex_finalizer`
- `20260911095142 cf_093_scheduler_exact_scope_codex_finalizer`
- `20260911095420 cf_093_scheduler_runtime_route_credential_finalizer`
- `20260911103931 cf_093_scheduler_runtime_semantics_finalizer`

The latest migration responds to the five P2 findings from Codex's exact-head review of `4b46e6d683db002df9155b8ac64cbecf32ede670`:

1. post-start exact fingerprint/profile recheck with transactional rollback on scope drift;
2. provider route qualification mirrors worker budget and unknown-cost gates;
3. strict HTTPS parsing rejects malformed targets/invalid ports;
4. Preview is consumed only after real exact work starts, not `already_running`/no-op/partial results;
5. queueable URLs must pass the current profile's acquisition host allowlist before Preview can be executable.

## Current acceptance evidence

- Exact-head Pilot Frontend Build **`34590366728` — PASS** on `25b51d435411c56c2c87172d4004ecafc61dd06d`.
- All five latest Codex review threads have forward-fix evidence and are resolved.
- Fresh exact-head Codex re-review requested in PR #71 comment **`5633260076`**; result is pending.
- Security Advisor remains **191 INFO / 0 WARN / 0 ERROR**.
- Private strict URL/allowlist helpers: anon/authenticated **EXECUTE denied**; private Run bridge anon/authenticated **denied**, service-role **allowed**, with independent rank enforcement retained in the bridge.
- URL parser proof: HTTPS port **65535 accepted**; **65536 and 99999 rejected**.
- UQ queueable-host proof: `study.uq.edu.au` accepted; `evil.example` and malformed `study.uq.edu.au:99999` rejected.
- Nominated University of Queensland exact scope remains fully qualified without executing new paid work: **382 scoped courses**, **156 queueable**, **226 requiring discovery**, fingerprint **`41d2ae8ec7ae1bc73554cf6551e2c40f`**, with **0** execution-policy, oversize, route or URL/discovery gaps.

## Exact next gate

1. Inspect Codex exact-head result for `25b51d435...`; if actionable, correct forward-only and repeat exact-head acceptance.
2. Do not merge PR #71 while Codex review is pending or any required check is red.
3. If exact-head Codex is clean, complete the required consequential/nominated pre-merge acceptance and merge only that accepted exact head.
4. After merge, run required deployed-currentness/UAT and only then consider returning CF-093 to CLOSED/PASS.
5. Keep broader orchestrator capability explicitly open/outside this boundary; do not infer generic L3/L4, Evidence reprocess or recurring-scope support from this builder slice.

## Pickup text

> Continue CF-093 from repository/runtime truth. Deployed Pilot main remains `cfc4702ba57a58ea31936dcabbd96fdd765194e2` / v2.15.78. CF-CHG-20260910-093 is REOPENED and corrective PR #71 is draft/open at exact head `25b51d435411c56c2c87172d4004ecafc61dd06d`. Runtime migration `20260911103931 cf_093_scheduler_runtime_semantics_finalizer` is applied forward-only after five P2 Codex findings on `4b46e6d683...`. Pilot Frontend Build `34590366728` is PASS; UQ exact scope remains 382 courses with zero policy/size/route/URL gaps; Security Advisor is 191 INFO / 0 WARN / 0 ERROR. Codex exact-head re-review request `5633260076` is pending. Preserve AU Course Facts / acquisition + deterministic Layer 2 only, mandatory exact Preview, fingerprint binding, worker-equivalent URL/provider qualification, rank/ACL controls and Layer 2 Jobs/Evidence truth. Generic L3/L4, Evidence reprocess, recurring country/state construction and implicit Search/Publication remain disabled. Do not merge until Codex and required exact-head acceptance are clean.
