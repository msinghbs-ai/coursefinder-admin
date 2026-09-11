# M2.4.5 NEXT CHAT

## Active baseline — 11 September 2026

- Accepted deployed Pilot `main`: **`cfc4702ba57a58ea31936dcabbd96fdd765194e2`**, visible **v2.15.78**.
- Functional target-builder PR #69 merged as **`85bc068d379ed3fc9231d167cf524e56419e80f9`**.
- Release-currentness PR #70 merged as **`cfc4702ba57a58ea31936dcabbd96fdd765194e2`**.
- **CF-CHG-20260910-093 is REOPENED. Do not describe it as CLOSED/PASS while the post-merge corrective gate is active.**
- Corrective Pilot PR #71 (`m245/cf093-postmerge-codex-20260911`) remains draft/open and unmerged.
- Current corrective exact head: **`4b46e6d683db002df9155b8ac64cbecf32ede670`**.
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

The `20260911095142` correction responds to six exact-head Codex findings on PR #71 reviewed head `a24f36b3e701391ab509c8c86c3820e02e234c9a`:

1. bind recent-dispatch dedupe to the current profile set;
2. require worker-usable acquisition routes;
3. validate the actual worker-selected discovery target as HTTPS;
4. expose University options only from executable Layer 2 scope;
5. construct preview counts and profile identity from one scope snapshot and reject construction-time drift;
6. bind dispatch to the exact runnable course/source-URL scope fingerprint approved by Preview.

Runtime reconciliation then confirmed the discovery worker uses the decrypted Vault secret, not only `vault_secret_id`; `20260911095420` therefore forward-tightens route qualification to require a non-empty decrypted credential for authenticated providers and keeps Parsebot excluded from the qualified route set.

## Current acceptance evidence

- Exact-head Pilot Frontend Build **`34586602099` — PASS** on `4b46e6d683db002df9155b8ac64cbecf32ede670`; build job **`103222143290`** passed Build, UAT suite discovery and local browser smoke.
- The six reviewed Codex threads from head `a24f36b3...` have forward-fix evidence and are resolved.
- Fresh exact-head Codex re-review requested in PR #71 comment **`5632743907`**; result remains pending.
- Security Advisor remains the known **191 INFO / 0 WARN / 0 ERROR** baseline.
- Browser ACL verification: anon Preview **denied**, authenticated Preview **allowed**; anon Run **denied**, authenticated Run **allowed**; the private exact-scope snapshot helper is **not executable by authenticated**.
- AU exact-scope snapshot: **21,093 scoped courses**, **445 queueable**, **20,648 requiring discovery**, fingerprint **`16c0defeb19917ad2695a5f27bab9c55`**.
- Runtime-usable AU acquisition route gaps: **0**.
- Worker-valid AU-wide discovery configuration gaps: **97**; AU-wide consequential dispatch therefore correctly fails closed until those profiles are qualified or a narrower eligible target is chosen.
- Nominated University of Queensland exact-scope check remains fully qualified without executing new paid work: **382 scoped courses**, **156 queueable**, **226 requiring discovery**, fingerprint **`41d2ae8ec7ae1bc73554cf6551e2c40f`**, and **0** execution-policy, oversize, route or discovery-config gaps.

## Exact next gate

1. Wait for Codex exact-head result on `4b46e6d683...`; if actionable, correct forward-only and repeat exact-head acceptance.
2. Do not merge PR #71 while Codex review is pending or any required check is red.
3. If exact-head Codex is clean, complete the required pre-merge targeted acceptance and merge only the accepted exact head.
4. After merge, run required deployed-currentness/UAT and only then consider returning CF-093 to CLOSED/PASS.
5. Keep the broader orchestrator capability explicitly open/outside this boundary; do not infer generic L3/L4, Evidence reprocess or recurring-scope support from this builder slice.

## Pickup text

> Continue CF-093 from repository/runtime truth. Deployed Pilot main remains `cfc4702ba57a58ea31936dcabbd96fdd765194e2` / v2.15.78. CF-CHG-20260910-093 is REOPENED and Pilot corrective PR #71 is draft/open at exact head `4b46e6d683db002df9155b8ac64cbecf32ede670`. Runtime migrations `20260911095142` and `20260911095420` are applied forward-only. Frontend Build `34586602099` is PASS; UQ exact scope is 382 courses with zero policy/size/route/discovery gaps; Security Advisor is 191 INFO / 0 WARN / 0 ERROR. Fresh Codex re-review request `5632743907` is pending. Preserve AU Course Facts / acquisition + deterministic Layer 2 only, mandatory exact Preview, scope fingerprint binding, rank/ACL controls and Layer 2 Jobs/Evidence truth. Generic L3/L4, Evidence reprocess, recurring country/state construction and implicit Search/Publication remain disabled. Do not merge until Codex and required exact-head acceptance are clean.
