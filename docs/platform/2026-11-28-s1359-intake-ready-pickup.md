# s1359: a collected intake file is sent only when its submitter released it (READY_FOR_PICKUP)

**Direction:** PC-20261128-CONTINUOUS-BUILD-EXECUTE ("READY manifest pickup ... existing manifest readiness must be enforced at runtime before pickup, no extra scheduler") and DOT-EVENING-INTAKE-BOUNDARY-20261128.
**Pilot change:** `scripts/intake-ready.mjs` (new, pure checks), `scripts/structured-intake.mjs` and the input wording of `.github/workflows/structured-intake.yml`. Spec: `tests/uat/cf-247-s1359-intake-ready-pickup-contract.spec.mjs`. There is no migration, setting, job or spend.

| Check (s1326 Drive route, before the bytes are read) | Result |
|---|---|
| File name `drive/<submitter>/<package>-READY_FOR_PICKUP.jsonl`, no hold mark | Sent as before: sha256, size and source checks, then the writer, which still proves every quote on the stored copies |
| Name carries PRECHECK, PENDING, DO_NOT_SUBMIT, HELD, DRAFT, PARKED or NOT_READY | Refused, nothing sent ("not released") |
| Name not marked READY_FOR_PICKUP | Refused, nothing sent |
| A record that states `state`, `status` or `readiness` other than READY | Left out and counted (`held_not_ready` in the result); the rest of the file is sent |
| No record ready | Refused, nothing sent |

**The boundary negative from 17:55:** identical verified bytes under `PRECHECK_PENDING_DO_NOT_SUBMIT.jsonl` reached the writer stub. They now stop with exit 1 before any database call. The spec runs the real script with a dummy credential and confirms that no query is made.

**Unchanged:** the admin-repository route, which is reviewed by its commit; the writer `svc_structured_intake_v1` and its replay, binding and scope checks; admission. A tampered sha256, a missing source or a file over 4 MiB still fail as before.

**Local:** the s1359, s1326, s1321, s120, s32 and s810 specs passed (31), and every spec that reads a workflow or the intake script passed (619). One deployed-only spec needs UAT credentials and is not run locally.

## Integration assignment (S1-Build, 28 Nov 2026 19:40 AEDT)

Four lanes used s1355 to s1357 at once. Names and versions are now assigned as follows; shared objects are disjoint.

| Change | Lane | Name and migration | Shared objects | State |
|---|---|---|---|---|
| Worker currency guard and completion verifier | S1-Build | s1354, no migration | `coverage-sweep` `extract.ts`, `adapters.ts`, `scholarship.ts`, `course-entry.ts` | Live 18:37 (#1762) |
| AI account refusal does not use an attempt | S2-RM-Design, integrated by S1-Build | s1355, `20261201120000` | `public.svc_enrich_ai_record`, setting `pim.refusal_defer_minutes` | Live (#1766; head `20261201120000`, both branches, setting 60, G3 75/48, no drift) |
| Portal fee currency label | S1-API-Frontend-Delivery | s1355 portal (frontend only) | `src/` portal fee display | Merged (#1763) |
| Compare lowest fee within one currency | S1-API-Frontend-Delivery | s1356 (frontend only) | `src/` compare | Merged (#1767) |
| Fee writers record the source or provider-country currency | S1-RM-Design | s1357, `20261201130000` | the fee writer functions | Open (#1764); S1-Build reviews it against s1354 before merge |
| Trace terminal and expired states | S2-RM-Design | **s1358, `20261201140000`** (new file) | `security.pim_record_trace_v1`, `security.pim_failure_cause_v1` | #1765 reuses the version `20261201120000`, which is already live as s1355, and repeats the refusal edit. Move only the trace and cause edits to a new migration above the head; the refusal branches are already live. |
| READY pickup enforced before intake pickup | S1-Build | s1359, no migration | `scripts/structured-intake.mjs`, `scripts/intake-ready.mjs`, workflow wording | This release (#1768) |

The next free name is s1360.
