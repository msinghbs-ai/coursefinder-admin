# Production-parity capture tool (validation item 1)

Validator: agent E (independent validation). Decision 19:14 §8 (Platform Admin, 5 Nov 2026).

- **Pilot draft PR:** #888, branch `cf247-validation-parity`, commits `fe370695` and `d83d5995`, on main `cf77ef78`. Not merged.
- **Files:** `scripts/prod-parity-capture.mjs`, `tests/fixtures/prod-parity/` (`capture.sql`, `run.sh`, `sample-source.sql`, `README.md`, `manifests/`), `tests/uat/cf-247-s310-prod-parity-tool-contract.spec.mjs`, `.github/workflows/prod-parity.yml`, and the register row.

## What it is for

The intake releases passed simplified fixtures, and then production rejected the operation. The fixtures had no `admin_jobs_outcome_fkey` and no `manual_locks` mode check or primary key. The tool turns "read the real constraints from production" into a repeatable step:

1. **Capture.** `capture-sql` prints one read-only `SELECT`. Agents run it through `mcp__Supabase__execute_sql` (light catalogue read; never at :35–:42 or :47–:48 Sydney time).
2. **Save.** `save` stores the result as a manifest and refuses any function definition that does not equal its captured md5.
3. **Build.** `fixture` builds the shapes in an isolated local database: keys, foreign keys with production code values seeded, checks, indexes, triggers with their functions, RLS and policies, exact grants, schema usage, role time-outs and the `search_path`.
4. **Check.** `check-sql` is a read-only `SELECT` that lists every differing fact. Run against production, it proves the manifest is exact and current. Run against any fixture, it lists what the fixture lacks. `--digest` does the same in one row.

## Verified

**Local round trip** (`tests/fixtures/prod-parity/run.sh`, PostgreSQL 16): passed.

- A fixture built from a manifest checks clean, inside a `READ ONLY` transaction.
- A simplified fixture is caught with 36 differences, including the two intake lessons, and the digest flags it.
- A personal-data lookup is refused and nothing is copied.
- A tampered definition is refused.

**Production manifest** `intake-lessons-admin-jobs-manual-locks.json`, captured 19:28 AEDT, 107 facts:

- The fixture built from it checks clean against the manifest locally (0 differences; lookup row md5s equal across PostgreSQL 16 and 17).
- It rejects what production rejected: `admin_jobs.outcome = 'run_now_queued'` (`admin_jobs_outcome_fkey`, 8 production codes), `manual_locks.mode = 'hold'` (`manual_locks_mode_check`: `value` or `removed`), and a duplicate lock key (`manual_locks_pkey`).
- **Production digest check** (one read-only `SELECT`): run 5 Nov 2026 19:43 AEDT. Result: `facts 107, md5 508e924224e6e99a01b4379483c506ea, matches_manifest true`. The manifest is byte-exact with production and still current. (For this run the unused structural parts of the outer `jsonb_build_object` were left out of the pasted query; the `facts` expression was unchanged.)

**Applied to PR #875's fixture:** the check found its `pipeline.progress_transitions` stub missing 20 of 26 columns, three checks, a foreign key and RLS. See the #875 report.

**Pilot Playwright** (local, `pw-5291`): s310 (6) plus s32, s42, s57 and s120: 24 passed.

## Things the tool caught while it was built

These are recorded so that future fixtures avoid them.

- **`search_path` changes function md5s.** Under the MCP session path (`"\$user", public, extensions`), three `api` functions using `extensions.vector` print differently from the empty path the consumer guard uses, which gives false "changed" md5s. Every manifest now records its path, and the fixture sets it.
- **Production `pipeline.manual_locks` is in schema `pipeline`, not `catalogue`.** Its `mode` is text with a check (`value`/`removed`), not an enum. Its trigger has a `WHEN` clause calling `security.ops_remedy_guard_active_v1()`. That is a function dependency a hand-written fixture would miss; the tool captures it.
- **Schema USAGE matters.** Without it, a fixture refuses reads for the wrong reason. It is now captured.
- **`pipeline.admin_jobs` grants and policies.** It has no non-owner table grants and no policies (RLS on), so only owner functions reach it.

## Limits

These are in the README.

- Ownership is not reproduced.
- Column-level grants and default privileges are not captured.
- `MAINTAIN` (PostgreSQL 17) cannot be granted on PostgreSQL 16; CI runs 17.6.
- Role-wide settings from other local databases can show.
- Function bodies are not validated, so add their dependencies to the scope.

## Next step for the Integration Controller

1. Review and integrate #888 when convenient. It has no production effect.
2. Then require release candidates that touch tables or functions to attach a manifest of what they touch, and a clean `check-sql` of their fixture.
