# D6 design note: `public.admin_adapter_measures` role check

Lane D6, CF-247. Platform Admin decision 30 Oct 2026 08:45 (D6). Worktree branch `cf247-d6-lane` from `origin/main` c4c49979. Everything below was read from live project `fxcwkweaxjtknorudmwp` on 30 Oct 2026 using read-only queries and rolled-back dry runs. Nothing was changed.

## 1. Live definition and the check that does not work

- Function: `public.admin_adapter_measures(uuid[])`. Security definer, owner `postgres`, `STABLE`, `search_path ''`, no comment.
- Live md5 of `pg_get_functiondef`: **`b1417eafad2aa7a9ed11e3af65e848e8`**.
- Grants (`proacl`): `{postgres=X/postgres,authenticated=X/postgres,service_role=X/postgres}`. anon has no grant. No later migration changed it: the only source is `supabase/migrations-archive/20261005001390_cf247_adapter_measures.sql`, plus the live-capture baseline.
- The check that does not work (archive migration line 10, the same in the live body):

```sql
if current_user <> 'postgres' and (auth.uid() is null or coalesce(v_rank, 0) < 5) then raise exception 'Platform Admin or Operator required' using errcode = '42501'; end if;
```

Inside a security definer function owned by `postgres`, `current_user` is always `postgres`. The first condition is therefore always false and the check never runs. This was proven live with rolled-back dry runs:

| Caller (simulated) | Result today |
|---|---|
| Curator `b9ba5d27…` (rank 3), `set local role authenticated`, claims `{sub, role: authenticated}` | **Returned `[]`. Not refused (this is the defect).** Inside the call, `current_user` was `authenticated` at the caller level and `postgres` within the function. |
| `service_role`, claims `{role: service_role}`, no user | Returned `[]`. Not refused. |
| `anon`, claims `{role: anon}` | `42501 permission denied for function` (refused by the grant, not by the body). |

## 2. The originally intended boundary

The intended rule is **a signed-in user with a role rank of 5 or more, or a direct owner session (no user)**. Everyone else is refused. This is not a new rule. Evidence:

- `supabase/migrations-archive/20261005001390_cf247_adapter_measures.sql` line 10: `auth.uid() is null or coalesce(v_rank, 0) < 5` raises 'Platform Admin or Operator required'. The exemption `current_user <> 'postgres'` was meant for direct owner sessions only.
- The same file, lines 29–30: `revoke all … from public, anon; grant execute … to authenticated`. The function is meant to be called over the API by signed-in users. No `service_role` grant was written; that grant comes from default privileges.
- Admin repo `docs/coursefinder-university-adapters-v1.0.md` line 245: "It is limited to the Platform Admin and Operators."
- Admin repo `docs/adapters/ADAPTER-COVERAGE-WAVE-PLAN.md` lines 62 and 85: the function is a per-wave measuring step.
- There is no UI caller. No file in `src/`, `supabase/functions/` or `scripts/` calls it. Wave measures were taken from direct database sessions (change-control log entries at lines ~4563–4622 of `CF-CHG-20260915-247-…md`: "read through `admin_adapter_measures`" during adapter runs).
- Twelve functions in the same family share the exact idiom `coalesce(v_rank, 0) < 5` → 'Platform Admin or Operator required' (`20261004001260`, `…1320`, `…1340`, `20261005001390`, `20261008000100`). Rank 5 is the consistent adapter-family threshold.

**One point to note, with no change proposed:** live `security.roles` ranks are `platform_admin` 6, `pim_admin` 5, `pipeline_operator` 4, `curator` 3, `counsellor` 2 and `viewer` 1. The message says "Operator", but rank 5 is `pim_admin`. `pipeline_operator` (rank 4) has never passed this rank test. I am keeping the numeric threshold of 5 and the message text exactly as they are. Lowering the threshold to 4 would widen the policy and raising it to 6 would narrow it, and the decision rules out both. If the Platform Admin wants the label or the threshold changed, that needs a separate decision.

## 3. Callers that run it without a user

| Path | Found | Effect of the new check |
|---|---|---|
| `cron.job` (146 jobs) | None reference it | Not applicable |
| Other database functions (`pg_proc` bodies) | None reference it | Not applicable |
| Frontend `src/`, edge functions, `scripts/`, `.github/` | None | Not applicable |
| API logs (`edge_logs`, last 24 h) | 0 calls | Not applicable |
| Direct owner sessions: migrations, SQL editor, Supabase MCP `execute_sql` (how wave measures are taken) | Yes. Live `auth.uid()` = null, `auth.role()` = null, no `request.jwt.claims` | **Still allowed.** With no claims, the first condition is false, so the check is skipped. |
| `service_role` over the API (claims `role: service_role`, no `sub`) | No caller found | **Refused**, as originally intended (`current_user <> 'postgres'` was meant to exempt the owner only, and service_role has no user, so `auth.uid() is null` raises). This matches A5. Allowing service_role would widen the policy, so I am not proposing it. The grant is left unchanged. |

## 4. Replacement check (A5 idiom, rank kept at 5)

```sql
-- a request through the API (JWT claims present) must be a signed-in user of rank 5 or above (Platform Admin or Operator, as written on 5 Oct 2026); a direct database session (the owner, a migration) has no claims. (current_user is always the owner inside a security definer function, so it cannot tell them apart)
if (auth.uid() is not null or coalesce(auth.role(), '') <> '') and (auth.uid() is null or coalesce(v_rank, 0) < 5) then raise exception 'Platform Admin or Operator required' using errcode = '42501'; end if;
```

| Caller | claims | uid | rank | Outcome |
|---|---|---|---|---|
| anon over the API | role anon | null | 0 | refused by the grant (42501) and by the body |
| signed-in curator | sub, authenticated | set | 3 | **refused 42501** (today: allowed) |
| signed-in pipeline_operator | sub, authenticated | set | 4 | refused (unchanged intent) |
| signed-in rank 5 (`pim_admin`) | sub, authenticated | set | 5 | allowed |
| Platform Admin | sub, authenticated | set | 6 | allowed |
| service_role over the API | role service_role | null | 0 | refused (today: allowed) |
| owner session, no claims | none | null | 0 | allowed (unchanged) |

## 5. Migration shape (Step 2)

- One file: `supabase/migrations/20261030XXXXXX_cf247_d6_adapter_measures_role_check.sql`. The integrator assigns the number.
- Before any change, a guard on live md5 `b1417eafad2aa7a9ed11e3af65e848e8`.
- The edit uses the A5 `pg_temp.edit_n` pattern: one edit to the check line, applied exactly once, plus the comment line. The query body stays byte-identical.
- `revoke all … from public, anon; grant execute … to authenticated` is restated unchanged, and service_role's existing grant is left as it is. A `comment on function` records the boundary.
- A post-check covers the new md5, the presence of the new check line, the absence of `current_user` in the body, unchanged grants, and that the function still returns `[]` for an empty array in the owner session.
- `-- Replaces: public.admin_adapter_measures (same name and signature, md5-guarded edit of its role check only)` / `-- Retires: nothing`. Nothing is dropped. There is no new table, job or setting, and the consumer API is not touched (G3).

## 6. Spec number and tests

- The highest spec in `tests/uat` is `s179`, and no remote branch carries `s18x`. The next free number is s180, which the other lane takes. **D6 takes `s181`.**
- G4/S120 counts a spec as deployed only when *all* of its tests are `@deployed`, and a skip for a missing environment is allowed only in a deployed spec. The direct-over-the-API tests therefore need their own file. **Proposed: `s181` contract and `s182` deployed.** The integrator owns numbering, so please confirm or reassign s182.
- `tests/uat/cf-247-s181-adapter-measures-role-check-contract.spec.mjs`
  `// Guards: CF-247 decision D6 (Platform Admin 30 Oct 2026 08:45): public.admin_adapter_measures enforces its original boundary (rank 5 or above, 'Platform Admin or Operator required') for every API caller using JWT claims instead of current_user, which never fired inside the security definer function; a direct owner session without claims still runs it; grants unchanged; md5-guarded; nothing else in the function changed`
  - The migration is md5-guarded on `b1417eaf…`, the edit applies exactly once, and the query body is byte-identical to the archive's.
  - The exact new check line is present, the threshold is still `< 5`, the message and errcode are unchanged, and no `current_user` appears in the new body.
  - Caller truth table: a JS model of the SQL predicate checked against all seven rows of §4 (anon, curator, rank 4, rank 5, Platform Admin, service_role, owner without claims).
  - Grants and housekeeping: the revoke/grant lines are unchanged, nothing is dropped or deleted, Replaces/Retires are present, and nothing touches the consumer API.
- `tests/uat/cf-247-s182-adapter-measures-role-check-deployed.spec.mjs` (`@deployed`, not `@live-acting`, because the function is STABLE and read-only)
  `// Guards: CF-247 decision D6 deployed: over the live REST API, public.admin_adapter_measures refuses anonymous callers and answers the signed-in Platform Admin`
  - **anon**: POST `/rest/v1/rpc/admin_adapter_measures` with the publishable key only → 401/403, code 42501.
  - **Platform Admin**: sign in as the UAT user and reuse the captured `authorization`/`apikey` headers (the pattern from `layer1-operations-deployed`) → 200 and a JSON array.
  - **Signed-in curator** over the API needs a curator login, and the deployed environment has only `UAT_EMAIL`/`UAT_PASSWORD`. Options: (a) the integrator supplies `UAT_CURATOR_EMAIL`/`UAT_CURATOR_PASSWORD` and the test runs only when they are set (a deployed-only skip, which S120 allows), or (b) curator refusal is proven by s181's model plus the live rolled-back dry run. **I recommend (b) for this change and (a) as a later improvement.** Please choose.
  - **service_role / no user**: proven by the live dry run. The service key is never put into a test.
- Live rolled-back dry run in Step 2 (nothing persisting): apply the migration inside `begin … rollback`. Then, as owner with no claims, call the function and get `[]`. As curator (authenticated, rank 3), expect 42501. As Platform Admin (63ba56cb…), expect a result. As rank 5, use a temporary `security.user_roles` row for the curator inside the same rolled-back transaction and expect a result. As service_role with no user, expect 42501. As anon, expect 42501. Then report the new md5.

## 7. Read-only sweep of related security definer functions (reported, not fixed)

Scope: every security definer function in non-system schemas whose body mentions `current_user`, `session_user`, `current_role` (other than `current_role_rank`), `current_setting('role')` or `pg_has_role`. Each was checked for whether `authenticated` or `anon` can execute it. A further sweep covered all 370 security definer functions executable by `authenticated` in `public.admin_*` and `security.*`, looking for other ways to bypass the check.

| Function | md5 | Line | Finding |
|---|---|---|---|
| `public.admin_adapter_measures(uuid[])` | `b1417eafad2aa7a9ed11e3af65e848e8` | `if current_user <> 'postgres' and (auth.uid() is null or coalesce(v_rank, 0) < 5) then raise …` | **The subject of D6.** |
| `public.admin_entry_matrix_reread(uuid[],text)` | `e2566cb6c2153d2414adb77dcfefb8c8` | Only the comment mentions `current_user` | Already corrected by A5. Not a finding. |

**No further finding of the D6 pattern.** Supporting observations:

- 282 security definer functions use `current_user`, all owned by `postgres`. Only the two above can be executed by `anon` or `authenticated`. In the other 280, the `current_user` test is redundant: it never fires, and the boundary is the EXECUTE grant (273 are service_role-only, the rest owner-only). They are not reachable by a signed-in or anonymous API caller. Common idioms: `current_user not in ('postgres','service_role')` (no effect inside a security definer function) and `current_user <> 'service_role' and coalesce(auth.role(),'') <> 'service_role'` (effective through `auth.role()`). **Observation for a later decision, not a defect:** if any of these functions is ever granted to `authenticated`, it would carry the same defect. A central guard (an S-spec or `security.controls_check_v1` notice that fails on `current_user` in an authenticated-executable security definer body) would stop it coming back.
- Bypasses where a null uid skips the check, in authenticated-executable functions: `security.scholarship_selection_for_course_browser_bridge(uuid)` (md5 `130fd0822670e0d8696f40728031354d`) and `security.scholarship_selection_for_provider_browser_bridge(uuid)` use `if auth.uid() is not null and security.current_role_rank()<3 then raise`. For signed-in callers the check works. anon cannot execute them, and only service_role (no uid) skips the check, which looks deliberate. **Not a finding**, listed for completeness.
- `public.admin_*` functions with no visible check: `public.admin_coverage_fetch_area(text,jsonb)` (md5 `acc07b0a9926e60f778439a666691e8a`) delegates to `security.coverage_fetch_area_v1` (md5 `cc69c46ac00b76f93be4846c721ca4df`), which checks `auth.uid() is null or v_rank < 4` correctly. `public.admin_ui_error_report(...)` (md5 `a9bde04f6eb8f2bf15abb36a8e87f63b`, anon-executable) requires `auth.uid()` and is intended for any signed-in user. **Not findings.**
- 73 `security.*` security definer functions can be executed by `anon` through the default PUBLIC grant, but `anon` has no USAGE on schema `security`, so they cannot be reached. **Observation only**, outside D6.
