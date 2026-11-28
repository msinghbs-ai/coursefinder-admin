# s1355: an AI account refusal does not use an enrichment attempt (DR-19)

**Direction:** PC-20261128-CONTINUOUS-BUILD-EXECUTE (S1-Build: "combine ... account-refusal attempt accounting ... in smallest coherent release(s)"). S2-RM-Design prepared the branch `s1354-refusal-no-attempt` (DR-19). S1-Build renumbered it as s1355, because s1354 is the worker currency release, and integrated it.
**Pilot change:** migration `20261201120000_cf247_s1355_enrich_refusal_no_attempt.sql`, spec `tests/uat/cf-247-s1355-enrich-refusal-no-attempt-contract.spec.mjs`. There is no job, table or queue.

| | |
|---|---|
| Cause | `public.svc_enrich_ai_record` counted an account refusal (OpenRouter key limit, "User not found.") as a failed attempt. One outage took 554 items to the cap of 3 (s1277). The recovery policy `ai_account_refusal` (s1282: defer and recheck, `counts_attempt` false) was never read. |
| Change | In the error and retry branches, when `security.pim_failure_cause_v1` classes the message as `account_refusal` and the policy does not count the attempt, the attempt is refunded. The item waits `pim.refusal_defer_minutes` (new G2 setting, 60 minutes, range 5 to 1,440), then the existing claim takes it back: a lease that has expired with attempts under the cap is claimable. |
| Unchanged | Every other error keeps today's behaviour exactly. |
| Rollback | Set the policy's `counts_attempt` back to true (configuration, no release). |
| Guards | Both edits are anchored and found exactly once. The consumer API is at 75/48 before and after. The manual locks and the active job count do not change. Nothing is dropped. |

**Rehearsal** (rolled back, 28 Nov 2026 18:45 AEDT, live head `20261201110000`):

| Test | Result |
|---|---|
| Classifier patterns (`service_limit`) | `%Key limit exceeded%`, `%refused the call (key limit%`, `%"User not found."%` |
| Policy `counts_attempt` | false |
| Item leased at attempts 2, given "Key limit exceeded" | leased, attempts 1, deferred about 60 minutes, reason "deferred (account refusal, attempt not counted): …" |
| Item leased at attempts 2, given "model returned invalid JSON" | ai, attempts 2, as before |
| Claim condition (live) | `state = 'leased' and leased_until < now() and attempts < 3` |

**Local:** the s1355 spec and s32, s42, s57, s120 and s980 passed (26). Migration pre-flight passed.
