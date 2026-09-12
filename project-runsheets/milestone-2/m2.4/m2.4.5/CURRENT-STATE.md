# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CODEX RECOVERY / DISCOVERY ACCEPTANCE REOPENED  
**Reconciled:** 2026-09-12 AEST  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Visible accepted release:** v2.15.78  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Active implementation candidate

- Pilot PR #72: `CF-093: complete Preview-bound async Layer 2 discovery`.
- Branch: `m245/cf093-async-discovery-20260912`.
- Exact head: `c5226c2bcadd7ee7102935088130262ca2a3a2a2`.
- Base main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- PR state: OPEN / DRAFT / mergeable but governance-blocked.
- Exact-head Pilot Frontend Build `34687938846`: PASS.
- Cloudflare exact-head commit/branch preview: PASS/deployed.
- Codex returned nine actionable findings on the predecessor head; eight are forward-corrected and review threads resolved. One P1 repository-reconstruction blocker remains open.

## Runtime corrective state

Forward migration `20260912100539_cf_093_codex_async_token_identity_dedupe_hardening` is applied and checked in. It:

- requires the exact Preview token throughout Preview-bound discovery context, continuation and handoff;
- revalidates bound profile/course identity before discovery Evidence writes;
- records async handoff batch IDs for completion-anchored dedupe;
- requires all referenced batches to be reusable before dedupe;
- makes cancellation set-based for multi-profile previews;
- rejects terminal-only scopes at Preview.

`layer2-scope-discover-scheduled` is deployed as Edge v27 / worker v1.3.9 / SHA `15c958609f6f6787a4de2e449d15e3e3e9718480da4c8599743c0da92a3d4ef2`. The existing one-time nonce/service authentication model remains unchanged. Preview-bound calls require `scheduler_preview_token`; missing or mismatched token fails closed. First-party HTTP 200 pages with no required-prefix links no longer become terminal negatives without an explicit profile-qualified zero-result marker. Current UQ/RMIT profiles have no such marker and none was fabricated.

Forward migration `20260912101339_cf_093_terminal_negative_basis_hardening` invalidates legacy `current_page_not_found` freshness suppression. `ambiguous` and `identity_mismatch` remain accepted terminal negatives. Current v1.3.9 `current_page_not_found` rows are not freshness-authoritative.

## UQ 382-course state — discovery acceptance REOPENED

Historical deterministic execution evidence remains retained:

- batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f` = 248 `resolved_l2` + 3 `layer3_required`;
- previous same-token replay and completion-dedupe proofs remain historical evidence;
- no generic Layer 3/Search/Publication side effects were observed.

After terminal-basis hardening, the current UQ snapshot is:

- 382 scoped;
- 251 queueable;
- **54 require rediscovery**;
- 77 retained governed terminal negatives;
- scope fingerprint `2661fefb086294a948862eac08f0c297`.

The previous statement “131 terminal negatives accepted” is superseded. Only stronger terminal evidence remains fresh under current rules. No corrective UQ rediscovery has yet been dispatched.

## RMIT 500-course state — discovery acceptance REOPENED

Historical deterministic execution evidence remains retained:

- batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f` = 213 `resolved_l2` + 50 `layer3_required`;
- 263 succeeded L2 jobs; zero Search refresh signals; canonical/Search authority false during that historical run.

After terminal-basis hardening, the current RMIT snapshot is:

- 500 scoped;
- 263 queueable;
- **27 require rediscovery**;
- 210 retained governed terminal negatives;
- scope fingerprint `cd360b3d2b6ba4ba8c2a5a9442cc761a`.

No corrective RMIT rediscovery has yet been dispatched.

## Open P1 — repository migration reconstruction

`20260912005948_cf_093_uq_native_program_discovery_profile.sql` is already applied in Pilot but is not safely replayable from repository genesis. The Layer 2 foundation seed creates UQ without `discovery_strategy`; nested `jsonb_set` in `20260912005948` therefore leaves configuration unchanged, and inserting the resulting version reuses the configuration hash. Runtime confirms `layer2_source_profile_versions` enforces `unique(profile_id, configuration_hash)`, so a fresh replay aborts.

This historical applied migration must not be edited or retimestamped. No direct repair of `supabase_migrations.schema_migrations` is authorised. A governed reconstruction/baseline strategy is required before PR #72 may merge.

## Layer 3 state — PAUSED behind CF-093 recovery

The previously inspected Layer 3 contract remains qualified, JWT-protected and separate from scheduler execution, but its bounded live-provider gate is paused until the CF-093 reconstruction and reopened discovery gates are clean. Generic scheduler Layer 3 remains prohibited.

## Exact next gate

1. Resolve the historical repository-reconstruction P1 through a governed baseline/reconstruction approach without modifying applied migration history.
2. Obtain fresh Codex review on the corrected exact head.
3. Through the normal authenticated scheduler surface, rediscover only the reopened 54 UQ + 27 RMIT Courses.
4. Re-run deterministic Layer 2 only for newly selected/changed actionable work and prove side-effect boundaries.
5. Resume bounded authenticated Layer 3 only after CF-093 closes its discovery/reconstruction gates.
6. Merge/release remains prohibited until final exact-head Codex, CI/UAT/runtime and governance gates are clean.

M2.4.4 remains CLOSED/PASS/FROZEN and M2.5 remains paused.
