# s1358 (main-green fix): the trace and cause edits move to their own migration version

**What happened.** Pilot #1765 (S2-RM-Design, titled s1356) merged at 19:01 with migration `20261201120000_cf247_s1356_enrich_refusal_no_attempt.sql`. That version is already applied as s1355 (#1766). Deploy on merge (run 46123897374) refused it: "an applied migration was changed. Nothing was run." The live database is unchanged and correct: head `20261201120000`, and s1355 is live and read back. Main's deploy was red from then on.

**Fix (Pilot, labelled `main-green-fix`).**
- The file at `20261201120000` from #1765 is removed. It was never applied.
- Only its new edits move to `20261201140000_cf247_s1358_pim_trace_lease_expired.sql`: `security.pim_record_trace_v1` names an expired lease at the attempt cap as an operational failure with the registry remedies for `lease_orphaned`, and a deferred refusal as in progress with the attempt not counted. `security.pim_failure_cause_v1` reads the settled reason ("lease expired at the attempt cap") as `lease_expired`.
- The account-refusal edits are already live as s1355 and are not repeated.
- The spec is renamed `cf-247-s1358-pim-trace-lease-expired-contract`. Its guard is unchanged in substance; the refusal assertions stay with the s1355 spec.

**Rehearsed rolled back** on the live head `20261201120000`:

| Check | Result |
|---|---|
| Cause of "lease expired at the attempt cap (3): … User not found." | `lease_expired` (was `account_refusal`) |
| Cause of "Key limit exceeded" | `account_refusal` (unchanged) |
| Trace edit present | yes |
| G3 | 75/48 |

Locally the s1358, s1355, s42, s32, s120, s980 and s57 specs passed (50), and pre-flight passed.

**Prevention.** Migration pre-flight already refuses a version that is not above main. #1765's version was above main when its branch was cut, but not when it merged. Names and versions for these lanes are assigned in `2026-11-28-s1359-intake-ready-pickup.md`; the next free name is s1360.
