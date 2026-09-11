# M2.4.5 NEXT CHAT

## Active baseline — 12 September 2026

- Accepted deployed Pilot `main`: **`cfc4702ba57a58ea31936dcabbd96fdd765194e2`**, visible **v2.15.78**.
- Functional target-builder PR #69 merged as **`85bc068d379ed3fc9231d167cf524e56419e80f9`**; release-currentness PR #70 merged as `cfc4702...`.
- **CF-CHG-20260910-093 is REOPENED.** Do not describe it as CLOSED/PASS while consequential acceptance remains blocked.
- Corrective Pilot PR #71 (`m245/cf093-postmerge-codex-20260911`) exact head: **`00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575`**.
- Exact-head Pilot Frontend Build **`34597632959` — PASS**.
- Exact-head Codex review: **CLEAN / no major issues**, PR #71 comment **`5634309865`**.
- PR #71 changed-file inventory is eight already-applied forward migration source files plus two maintained CF-CHG-20260910-093 UAT contract files; no browser UI source change.
- **Repository/runtime reconciliation merge is now authorised** for PR #71 exact clean head. This does not close CF-CHG-20260910-093 and does not waive consequential acceptance.
- Production is unchanged; M2.5 remains paused at P0.

## Preserved CF-CHG-20260910-093 authority boundary

The Scheduled Tasks builder remains deliberately narrow:

- AU Course Facts Layer 2 only;
- server-authorised Country / State-Territory / University-Provider scopes;
- Acquisition + deterministic Layer 2 only;
- mandatory server Preview before consequential dispatch;
- authenticated rank-4 execution only;
- valid current profile version, deterministic execution policy, bounded profile size, worker-compatible route/credential/budget/cost and URL allowlist checks;
- exact Preview fingerprint/revalidation before and after start;
- Layer 1 authority unchanged;
- Layer 3 remains Evidence/profile/model/revalidation governed;
- Layer 4 remains human/exception resolution;
- Search and Publication remain separately governed downstream actions.

Generic asynchronous discovery-backed Scheduled Tasks are intentionally fail-closed until a separately accepted Preview-bound worker/continuation contract exists. Generic L3/L4 orchestration, Evidence reprocess, NZ Layer 2 Course enrichment, recurring country/state construction, unsupported recurring university construction and implicit Search/Publication remain disabled.

## Immutable Pilot runtime lineage

Applied identities must not be retimestamped or rewritten. Latest CF-CHG-20260910-093 corrective migrations are:

- `20260911085724 cf_093_scheduler_postmerge_codex_finalizer`
- `20260911095142 cf_093_scheduler_exact_scope_codex_finalizer`
- `20260911095420 cf_093_scheduler_runtime_route_credential_finalizer`
- `20260911103931 cf_093_scheduler_runtime_semantics_finalizer`
- `20260911105517 cf_093_scheduler_browser_bridge_and_scope_binding_finalizer`
- `20260911111431 cf_093_scheduler_query_binding_and_ipv4_finalizer`
- `20260911114056 cf_093_scheduler_discovery_failclosed_and_runtime_parser_finalizer`
- **`20260911120131 cf_093_scheduler_operator_reason_and_route_chain_finalizer`**

Repository branch source matches the actual applied identities. Stale pre-apply filename aliases were removed without rewriting runtime history.

## Current runtime eligibility truth

- University of Queensland: **382 courses / 156 queueable / 226 discovery** — discovery-backed and intentionally non-executable in generic Scheduled Tasks.
- RMIT University: **500 courses / 261 queueable / 239 discovery** — discovery-backed and intentionally non-executable in generic Scheduled Tasks.
- RMIT and UQ are the only enabled AU Course Facts profiles with existing deterministic execution policies.
- Nova Higher Education: **1 queueable / 0 discovery**, route gaps 0, oversize 0, but **execution-policy gap 1**.
- Stamford International College: **1 queueable / 0 discovery**, route gaps 0, oversize 0, but **execution-policy gap 1**.
- Nova and Stamford are qualification-only profiles under earlier source-qualification governance; do not create execution policies merely for UAT.
- Every inspected AU State/Territory scope remains discovery-backed and contains execution-policy gaps.

Do **not** manufacture an execution policy, source profile, route or runtime configuration merely to force a consequential acceptance pass.

## Source/runtime reconciliation decision

Pilot runtime already contains all eight forward corrective migrations through `20260911120131`, while Pilot `main` still lacks their source files. Under the recovery protocol, leaving PR #71 unmerged would preserve source/runtime drift and weaken clean replay/recovery.

Therefore PR #71 may merge exact head `00c98f0cea...` **for repository/runtime reconciliation only**. This merge:

- does not add new runtime authority beyond what is already deployed;
- does not change browser UI source and does not itself require a visible release bump;
- does not close the Change Control;
- does not waive the requirement for a genuinely governed policy-qualified fully queueable deterministic Layer 2 consequential acceptance target;
- must be followed by main CI and deployed UAT/currentness verification.

## Exact next gate

1. Mark Pilot PR #71 ready and merge only exact head `00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575` as source/runtime reconciliation.
2. Verify post-merge Pilot main CI, Cloudflare deployment/currentness and CourseFinder Deployed UAT. Record exact merge SHA and run IDs.
3. Keep CF-CHG-20260910-093 **REOPENED** after the merge.
4. Consequential acceptance remains blocked until a legitimate operational lifecycle produces a policy-qualified fully queueable deterministic Layer 2 target; do not create one solely for UAT.
5. Reconcile CURRENT-STATE, RUNSHEET, FOLLOW-UPS and Change Control after the merge, then obtain a fresh exact-head Admin PR #34 Codex review and merge governance if accurate.
6. Once CF-CHG-20260910-093 is truly closed, resume the **QS-focused** M2.4.5 continuation; stale ARWU/Diversity immediate-next pointers remain superseded.

## Pickup text

> Continue CF-CHG-20260910-093 from repository/runtime truth. Deployed Pilot main before source reconciliation is `cfc4702ba57a58ea31936dcabbd96fdd765194e2` / v2.15.78. Corrective PR #71 exact head `00c98f0cea22e8ef2d8f12adb16a1e6cc5e3f575` has Pilot Frontend Build `34597632959` PASS and clean Codex comment `5634309865`. Runtime already contains all eight PR #71 migrations through immutable `20260911120131`; PR #71 changes only those migration source files plus two UAT contract files. Governance now authorises merging PR #71 solely to eliminate repository/runtime drift. Do not mark CF-CHG-20260910-093 CLOSED/PASS after merge: consequential acceptance remains blocked because RMIT/UQ are discovery-backed while Nova/Stamford are qualification-only and lack execution policies. Preserve Layer authority, Evidence, rank/ACL and fail-closed async discovery. After merge verify main CI, Cloudflare/deployed currentness and deployed UAT, then reconcile continuity/Admin PR #34.
