# M2.4.5 NEXT CHAT

## Active baseline — 11 September 2026

- Accepted deployed Pilot `main`: **`cfc4702ba57a58ea31936dcabbd96fdd765194e2`**, visible **v2.15.78**.
- Functional target-builder PR #69 merged as **`85bc068d379ed3fc9231d167cf524e56419e80f9`**.
- Release-currentness PR #70 merged as **`cfc4702ba57a58ea31936dcabbd96fdd765194e2`**.
- **CF-CHG-20260910-093 is REOPENED. Do not describe it as CLOSED/PASS while the post-merge corrective gate is active.**
- Corrective Pilot PR #71 (`m245/cf093-postmerge-codex-20260911`) remains draft/open and unmerged.
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

## Runtime truth / acceptance so far

- AU exact-scope snapshot currently reports **21,093 scoped courses**, **445 queueable**, **20,648 requiring discovery**, fingerprint **`16c0defeb19917ad2695a5f27bab9c55`**.
- Runtime-usable acquisition route gaps: **0**.
- Worker-valid discovery configuration gaps at AU-wide scope: **97**; therefore AU-wide dispatch correctly fails closed until those profiles are qualified or a narrower eligible target is selected.
- Security Advisor after the corrections remains the known **191 INFO / 0 WARN / 0 ERROR** baseline.

## Exact next gate

1. Treat Pilot PR #71 current head and CI/Codex result as authoritative; do not merge while exact-head review/checks are pending or red.
2. Run the targeted CF-093 exact-scope acceptance, including the new source contract test and required existing builder tests.
3. Resolve all six latest Codex threads only with forward-migration/runtime evidence, then request exact-head Codex re-review after the material corrections.
4. Merge PR #71 only after exact-head CI, required targeted acceptance and Codex are clean; then run required deployed-currentness/UAT before CF-093 can return to CLOSED/PASS.
5. Keep the broader orchestrator capability explicitly open/outside this boundary; do not infer generic L3/L4, Evidence reprocess or recurring-scope support from this builder slice.

## Pickup text

> Continue CF-093 from repository/runtime truth. Deployed Pilot main remains `cfc4702ba57a58ea31936dcabbd96fdd765194e2` / v2.15.78, but CF-CHG-20260910-093 is REOPENED because post-merge Codex corrections are still under acceptance in Pilot PR #71. Latest immutable runtime migrations are `20260911095142 cf_093_scheduler_exact_scope_codex_finalizer` and `20260911095420 cf_093_scheduler_runtime_route_credential_finalizer`. Preserve AU Course Facts / acquisition + deterministic Layer 2 only, mandatory exact preview, profile/policy/route qualification, course/source scope fingerprint binding, rank/ACL controls, and Layer 2 Jobs/Evidence truth. Generic L3/L4, Evidence reprocess, recurring country/state construction and implicit Search/Publication remain disabled. Do not merge PR #71 until exact-head CI/UAT and Codex are clean.
