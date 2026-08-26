# M2.4.1 — Next Chat

Continue **M2.4.1 — Layer 1 Regulatory Operations Maturity & Automation** only. Do not begin M2.4.2 feature work until formal M2.4.1 closure.

## Mandatory checkpoint

Read the M2.4.1 RUNSHEET, CURRENT-STATE and FOLLOW-UPS plus current Change Control `CF-CHG-20260826-043`, then reconcile current Pilot main/runtime/Supabase before changing anything.

Accepted starting M2.4.0 baseline remains `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`.

## Current frozen implementation

- frozen working Pilot: `fcb77befb797e98f9369b33a79ab29a4950717ff`;
- final targeted Stage A run: `32968177074` — PASS;
- Stage B integration marker: `69c21bab97cee34505787403af4f6065ddcd79f7`;
- active Stage B run: `32968310102`;
- Admin documentation commit: `09b20d1fe74b2b9a3ce3a36af98305a051fb3d14`.

Pilot repository truth includes all live M2.4.1 migrations through `20260826121631_m2_4_1_layer1_recovery_housekeeping_metadata.sql` and both deployed Edge sources.

## Proven operational state

- AU CRICOS validation: 26,648 active / 90 expired / 26,738 total; dynamic source semantics, no hard-coded baseline assertion.
- NZ NZQA validation: 411 current providers versus 409 accepted baseline, approximately 0.489% PASS variance.
- rank >=4 validation; rank >=6 consequential queue/configuration/recovery actions.
- explicit warning acknowledgement before APPLY; blocking variance cannot execute.
- duplicate active-run/idempotency guards, retry/resume linkage/cursor and cumulative reconciliation proven rollback-safe.
- scheduled source verification through one-time nonce path; changed/unchanged/failure state only, no unattended APPLY.
- paused-source exclusion and stale schedule dispatch recovery proven.
- bounded regular stuck-run recovery proven.
- 30-day transient queue retention and daily 03:17 UTC housekeeping preserve Evidence/source versions/canonical history.
- final security advisor has INFO-only findings; final performance advisor has no unindexed Layer 1 FK.

## Immediate next action

1. Read the exact result of Stage B run `32968310102`.
2. If FAIL, diagnose the deterministic failing suite and only then change the candidate. Any Pilot/runtime change requires Stage A → Stage B again.
3. If PASS, do not change Pilot/runtime. Nominate one frozen Stage C acceptance marker.
4. Execute exactly one full deployed desktop/mobile Stage C permanent matrix.
5. If Stage C PASS, perform final advisor/ACL/runtime reconciliation, close Change Control/REGISTER, update runsheet/current-state/follow-ups/this file, then reconcile Running Build/Master Project Plan.
6. Only after those closure records are committed may M2.4.2 begin.

Do not update Running Build/Master Project Plan or call M2.4.1 PASS before the exact Stage C candidate passes.