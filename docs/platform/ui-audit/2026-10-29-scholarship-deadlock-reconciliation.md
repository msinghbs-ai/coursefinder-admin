# Scholarship paste deadlock: reconciliation, root cause and correction (29 Oct 2026)

**Mandate:** Platform Admin, 29 Oct 2026 16:59 AEDT, Workstream 0.
**Subject:** `docs/platform/pastes/PASTE-20261029-scholarship-research-links-reapply.sql`, run by the Platform Admin in the Supabase SQL editor.
**Read live (read-only) from `fxcwkweaxjtknorudmwp`:** 17:00–17:15 AEDT. No session was cancelled, and nothing was written while investigating.

## 1. What happened

| Time (AEDT) | Event | Evidence |
|---|---|---|
| 16:26:00 | Scheduled job 39 `search-refresh-requested` starts. It found refresh requests outside the gap, so it ran a full `search.refresh_course_documents_v3(true)`. Usually it takes 0.5 s; this run took 76 s (16:26:00 → 16:27:16). | `cron.job_run_details` |
| about 16:2x | First run of the paste (SQL editor, process 514504). | postgres log |
| 16:26:24 | Job 39 (process 514608) waits for a lock on a `search.course_documents` row held by the paste, while upserting the full base projection (`insert … on conflict (course_id) do update`). | postgres log: "process 514608 still waiting for ShareLock on transaction 11205794" |
| 16:26:43 | The paste, inside `security.scholarship_sweep_apply_v1` → `search.refresh_course_enrichment_scoped_v1` → `refresh_course_enrichment_core_scoped_v1`, waits for a row (tuple 7160,3) held by job 39. This completes the lock cycle. Postgres cancels the paste as the victim; job 39 continues and succeeds. | postgres log: "deadlock detected … while updating tuple (7160,3) in relation course_documents" |
| 16:57 | Second run of the paste **commits**. The editor shows "Failed to fetch" because the connection to the dashboard dropped after the server finished. | 1,544 links written and 2,605 search documents regenerated in that minute; post-conditions hold (section 2) |

Kimi Work's Layer 4 review was **not** the competing writer.

## 2. Rollback and current-state reconciliation

| Check | Result |
|---|---|
| First run rolled back completely | Yes. It was one transaction, and the deadlock aborted it. Nothing from it remains (the 16:26 job 39 refresh succeeded on its own data only). |
| Second run state | Committed at 16:57. |
| Migration history | The paste is a paste file and writes no `schema_migrations` entry, by design. The prerequisite `20261029070000` is recorded live (md5 `1b4d0c0a`, equals the file). |
| Field-only links to non-research courses on the 210 applied scholarships | **0** (was 8,042 published, of 13,584 field-only links). |
| Field-only `postgraduate_research` links remaining | 1,927 = 1,544 research-level links on applied scholarships + 383 on the 4 not-applicable scholarships. |
| The 4 not-applicable scholarships | 383 links unchanged; 334 of them to non-research courses. Optional block C is **untouched and unauthorised**. |
| Links made by a person | 0 before, 0 after. |
| Affected-set count | Now 208 scholarships (6 applied scholarships keep no field-only link). The paste's precondition (214) would refuse a re-run, so it **must not be run again**. |
| Search documents | 2,605 regenerated at 16:57. DP020 lists 4 undergraduate/pathway scholarships, with the two RMIT PhD scholarships gone. Research-named scholarships still on non-research courses are undergraduate research awards outside the 214 set, plus block C's four. |

The paste's own post-checks (210 applied / 4 not applicable; no wrong-level field-only link on an applied scholarship; hand links unchanged) are inside the transaction and raise on failure. The commit therefore proves they passed, and the live counts agree.

**Reapplication state:** applied and verified. No guarded reapplication is needed.

## 3. Root cause

Writers of `search.course_documents` (deployed md5s, 29 Oct 17:05):

| Function | md5 | How it locks document rows |
|---|---|---|
| `security.search_refresh_requested_v1()` (job 39, every 10 min) | `bb78c854` | Calls the full `search.refresh_course_documents_v3(true)` |
| `search.refresh_course_documents_v3(boolean)` | `40dc6d97` | Full base upsert (`refresh_course_base_v3`, `d9b021b2`), then a full enrichment update; staging-table order |
| `search.refresh_course_enrichment_scoped_v1(uuid[],boolean)` | `52bff5be` | Shared choke point for 35 scoped writers (Layer 4 apply, admissions, sweeps, admin edits). Calls the core, then a second update of the same rows |
| `search.refresh_course_enrichment_core_scoped_v1(uuid[],boolean)` | `3f0b051f` | `update … from cf_search_enrichment_stage` in join order; rewrites every staged row even when unchanged |
| `security.scholarship_sweep_apply_v1(uuid)` | `ccd52459` | Calls the scoped refresh once per scholarship |

Other full writers (`publishing.refresh_course_publication_search_v1`, `search.rebuild_course_documents`) go through `refresh_course_documents_v3`. `search.refresh_course_documents_v2` is legacy and has no caller.

**Cause:**
1. No writer of `search.course_documents` coordinates with any other. There is no advisory lock anywhere in the chain.
2. Within each statement, rows are locked in plan order (join or staging order), not a defined order.
3. A transaction that calls the scoped refresh many times (the paste made 214 calls over several minutes) builds up row locks across thousands of documents in an order unrelated to the full rebuild's.

So when job 39's full rebuild ran during the paste, each held rows the other needed. **Ordering rows within each call cannot prevent this:** the paste locks set A in call 1 and set B in call 2, while the full rebuild locks in one ascending pass. Only serialising the full rebuild against any open document-writing transaction removes the cycle.

## 4. Proposed correction (decision W27, lodged before code)

1. **One writer lock.** Every document writer takes the same transaction-scoped advisory lock, a fixed technical constant marked `-- fixed:` (G2):
   - `search.refresh_course_enrichment_scoped_v1` takes it waiting, so all 35 scoped writers serialise and a long transaction keeps it until commit;
   - `search.refresh_course_documents_v3` takes it waiting, covering every full rebuild path.
2. **The scheduled job never waits.** `security.search_refresh_requested_v1` first tries the lock; if another transaction holds it, it returns `held` and leaves the requests unprocessed for the next 10-minute tick. Nothing is lost, and nothing piles up behind a long paste.
3. **Deterministic row order inside a scoped call.** Before updating, the scoped refresh locks the requested documents in ascending `course_id`. This is belt and braces; the writer lock already serialises.
4. **Unchanged:**
   - the documents written, every column value, `generated_at` behaviour, and the consumer API shape (G3);
   - scholarship relationship rules, admission gates and Layer 4.
   - Nothing is dropped; `refresh_course_documents_v2` is left as is (no caller).
5. **Effect on interactive writers:** a Layer 4 apply that arrives while a long paste or rebuild holds the lock waits for it (rebuilds take seconds; a large paste, minutes) instead of risking a deadlock. If it exceeds its statement timeout it rolls back cleanly and can be retried.

**Verification before merge:**
- a local Postgres reproduction of the deadlock with overlapping course sets in opposing orders, shown fixed by the correction;
- a contract spec;
- md5 guards on the three edited functions;
- a rolled-back live dry run;
- the full suite with 0 failed and 0 skipped;
- change control.

**After deploy:** deployed-source md5 verification and one job 39 tick observed.

**Not done:** no blind re-run, no splitting of approved SQL, no session cancelled, no lock disabled, no guard weakened.
