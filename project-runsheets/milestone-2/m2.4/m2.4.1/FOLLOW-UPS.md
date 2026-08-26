# M2.4.1 — Follow-ups

## P0 — active gate

1. Complete bounded Stage B deployed integration run `32968310102` against marker `69c21bab97cee34505787403af4f6065ddcd79f7` / frozen working SHA `fcb77befb797e98f9369b33a79ab29a4950717ff`.
2. Treat any Stage B failure as candidate evidence. Diagnose the exact deterministic/runtime defect; do not increase waits or bypass security/authority contracts.
3. If any Pilot application/runtime change is required, invalidate the candidate and rerun targeted Stage A before another Stage B marker.
4. If Stage B passes with no Pilot/runtime change, nominate exactly one Stage C acceptance candidate.

## P1 — Stage C closure gate

- Execute exactly one full permanent deployed desktop/mobile Stage C matrix on the frozen acceptance candidate.
- Reconfirm Security Advisor, Performance Advisor and Layer 1 ACL/rank negatives against the final runtime.
- Reconcile the exact final Pilot SHA, deployed Edge versions, migration chain and cron jobs.
- Record Stage A, Stage B and Stage C Actions evidence in the RUNSHEET and Change Control.
- Update `CURRENT-STATE.md`, `FOLLOW-UPS.md` and `NEXT-CHAT.md` to final closure truth.
- Close `CF-CHG-20260826-043` and update `change-control/REGISTER.md` only after Stage C PASS.
- Reconcile latest Running Build / Master Project Plan only after the final acceptance SHA is known.

## Completed functional proof

- real AU CRICOS authority/package/count validation: 26,648 active / 90 expired / 26,738 total;
- real NZ NZQA validation: 411 live versus 409 accepted, approximately 0.489% PASS variance;
- warning/block variance guardrails and APPLY block proof;
- rank-4 validation versus rank-6 execution/configuration authority split;
- one-active-run, idempotency, retry/resume, resume cursor and cumulative reconciliation;
- scheduled non-destructive source verification through the existing M2.3 substrate and one-time nonce path;
- paused-source scheduler exclusion and >30-minute scheduled-dispatch failure recovery;
- bounded Platform Admin recovery of a genuinely stuck regular run;
- transient housekeeping preserving Evidence/configuration/canonical history;
- final live migrations and Edge source mirrored to Pilot repository truth;
- final Security Advisor with no M2.4.1 Critical/High/Warning finding;
- final Performance Advisor with no unindexed Layer 1 foreign key;
- Data Operations Admin Guide v1.2, Operations Runbook v1.3 and PIM Admin Guide v1.21 published.

## Stage progression

- **Stage A:** PASS — `fcb77bef…`, deployed UAT `32968177074`.
- **Stage B:** ACTIVE — marker `69c21bab…`, deployed UAT `32968310102`.
- **Stage C:** NOT YET AUTHORISED — exactly one frozen candidate after Stage B PASS.

M2.4.2 feature implementation remains blocked until M2.4.1 is CLOSED/PASS.