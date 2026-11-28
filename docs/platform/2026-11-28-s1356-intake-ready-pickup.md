# s1356: a collected intake file is sent only when its submitter released it (READY_FOR_PICKUP)

**Direction:** PC-20261128-CONTINUOUS-BUILD-EXECUTE ("READY manifest pickup ... existing manifest readiness must be enforced at runtime before pickup, no extra scheduler") and DOT-EVENING-INTAKE-BOUNDARY-20261128.
**Pilot change:** `scripts/intake-ready.mjs` (new, pure checks), `scripts/structured-intake.mjs` and the input wording of `.github/workflows/structured-intake.yml`. Spec: `tests/uat/cf-247-s1356-intake-ready-pickup-contract.spec.mjs`. There is no migration, setting, job or spend.

| Check (s1326 Drive route, before the bytes are read) | Result |
|---|---|
| File name `drive/<submitter>/<package>-READY_FOR_PICKUP.jsonl`, no hold mark | Sent as before: sha256, size and source checks, then the writer, which still proves every quote on the stored copies |
| Name carries PRECHECK, PENDING, DO_NOT_SUBMIT, HELD, DRAFT, PARKED or NOT_READY | Refused, nothing sent ("not released") |
| Name not marked READY_FOR_PICKUP | Refused, nothing sent |
| A record that states `state`, `status` or `readiness` other than READY | Left out and counted (`held_not_ready` in the result); the rest of the file is sent |
| No record ready | Refused, nothing sent |

**The boundary negative from 17:55:** identical verified bytes under `PRECHECK_PENDING_DO_NOT_SUBMIT.jsonl` reached the writer stub. They now stop with exit 1 before any database call. The spec runs the real script with a dummy credential and confirms that no query is made.

**Unchanged:** the admin-repository route, which is reviewed by its commit; the writer `svc_structured_intake_v1` and its replay, binding and scope checks; admission. A tampered sha256, a missing source or a file over 4 MiB still fail as before.

**Local:** the s1356, s1326, s1321, s120, s32 and s810 specs passed (31), and every spec that reads a workflow or the intake script passed (619). One deployed-only spec needs UAT credentials and is not run locally.
