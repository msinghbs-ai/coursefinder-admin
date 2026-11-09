# AER and enrichment-health programme: handback (30 Oct 2026)

**Mandate:** Platform Admin, 30 Oct 2026 00:01 AEDT (Workstreams 1–8). Every figure was read live from `fxcwkweaxjtknorudmwp` at the time stated; counts are dated query results.

**Not "AER complete" and not "enrichment complete":** four deployed tests are still red on database load (§6);
- eligible courses remain unread, because paid reading is stopped pending decision B3–B5;
- 240 actionable AER items await human review;
- 714 wrongly displaced pages await the R1 spend line;
- the decisions in the decision paper are open.

Website rendering remains website-team work.

**Companion files:**

| File | Contents |
|---|---|
| `2026-10-30-enrichment-health-reconciliation.md` | Workstream 1 |
| `2026-10-30-gap-causes-needs-a-change.md` | The complete 47-row gap report |
| `2026-10-30-platform-admin-decision-paper.md` | Workstreams 6 and 8 |
| `2026-10-30-bulk-reread-newest-copy-spec.md` | Workstream 5 |
| `../AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md` §8 | Decisions W30–W33 |
| `../AER-ROLE-GUIDES.md` §5.6 | Telling queue items apart |
| `2026-10-29-aer-live-status.md` | The live checkpoint |

## 1. Workstream ownership

| WS | Owner | Branch | Deliverable | State |
|---|---|---|---|---|
| 1 Reconciliation | integrator | admin main | Reconciliation and gap report | DELIVERED |
| 2 Source finder, capture, slow reads | lane G, then integrator | `cf247-enrich-reliability` → `cf247-w30-int` | W30 in v2.15.370 (#747) | DELIVERED |
| 3 Release health | lane J, then integrator | `cf247-universities-paging` → `cf247-w33-int` | W33 in v2.15.371 (#748); timeout snapshots | DELIVERED; snapshots BLOCKED (decision) |
| 4 Identity and eligibility | lane H, then integrator | `cf247-w31-int` | W31 in v2.15.371 (#748); R1 manifest | DELIVERED; R1 BLOCKED (spend) |
| 5 Reader hardening | lane I, then integrator | `cf247-reader-answer-limits` → `cf247-w30-int` | W32 in v2.15.370; bulk Read again spec | DELIVERED; bulk BLOCKED (decision A5) |
| 6 Layer 4 policy | integrator | admin main | Decision paper Part A; role guides 5.6 | DELIVERED; decisions BLOCKED |
| 7 Reporting freshness | integrator | scheduled task, admin main | Hourly report corrected; gap report | DELIVERED; panel run-time label BLOCKED (decision) |
| 8 Paid reads | integrator | admin main | Decision paper Part B | BLOCKED (decision) |

## 2. Releases (merged, deployed and verified on live)

| Release | PR / main | Live verification |
|---|---|---|
| **v2.15.370**: W30 + W32, worker v0.54.0 | #747, `85955c5e` | Function md5s match the dry run: `svc_source_find_next` `061d6252`, `svc_coverage_read_next` `748954a5`, `provider_onboarding_job_v1` `247e93da`. 12 `reading.answer_tokens.*` settings. Worker v0.54.0 answering. Deployed UAT, release currentness and history contract green. |
| **v2.15.371**: W31 + W33, worker v0.54.1 | #748, `cd97b53d` | Function md5s match the dry run: `coverage_bind_v2` `ec5087e3`, `admin_layer23` `604b67d3`. 2 `layer23.*` settings. Worker v0.54.1 answering. Deployed UAT, release currentness and history contract green. |

**Each release went through, in order:**
1. a decision lodged before code (`cb1974b9`);
2. md5-guarded edits;
3. a rolled-back live dry run;
4. a full local suite, with each one-spec failure fixed and re-run and no assertion weakened (v2.15.370: 1,212; v2.15.371: 1,222);
5. change control in all five files (`f055dc4f`, `bbafbe14`);
6. TEST-REGISTER regenerated and UI catalogue 1.15;
7. deploy by the merge workflow;
8. live read-back.

`cf247-zoho-dryrun` = main.

**Early effect on live (00:40–01:06 AEDT):**
- **Source finder:** the first run after the fix (00:56) finished with 3 universities and no failure. It had been timing out on 80 of 143 calls.
- **Duplicate scrapes:** 0 in the first scrapes after W30, against 38 of 261 in the 100 minutes before. That's a small sample, to be re-checked on the next report.
- **Page reads:** 53 calls, none failed.

## 3. Findings (summary; detail in the companion files)

1. **Layer 4 queue "7 → 304".**
   - It counts items created over 24 h against the 24 h before, not one hour.
   - 259 of the 304 are authorised AER work. 23 matrix items were legitimately superseded by W28 Read again.
2. **The 515 pending items** (00:20 and again at 00:55 AEDT):

   | Group | Items | Classification |
   |---|---:|---|
   | AER | 241 | 240 actionable, 1 stale (Otago Polytechnic `f14ae480`) |
   | Non-AER | 274 | 151 tuition items older than 3 days, 31 of them probably overtaken by a newer fee; 22 URL items awaiting a check against an existing link; 49 no-page and 11 conjoint first runs; 3 English |

   - 0 claimed. Nothing cleared.
3. **The 28 pages read.** 19 identity mismatch, 6 read with no new value, 2 blocked, 1 fetch failed. Zero admissions is correct gating, not a reader fault.
4. **NZ and CA zero.** The reads were identity re-checks of pages the gate already excludes. The CA `nzqa_code` mislabel is corrected for future reads by W31.
5. **Three new AU official pages.** All three are Kulin Institute, exact-title identity, on the provider's registered domain with the matching training code. Valid, not duplicated, title-based.
6. **Source finder, adapter capture, 115 s read.**
   - Source finder: a database time limit, fixed by W30.
   - Capture: one external edge boot error, plus a ledger shape that showed working captures as "0 of 0" (fixed). Five drafts are stuck; cleanup is by paste file.
   - The 115 s read is within design.
   - The duplicate paid reads were a claim race, fixed.
7. **Snapshot freshness.** The job stamps the hour start; the report misread its age. The report now uses the run time and flags stale after 75 minutes. All 47 rows are in the gap report.
8. **AU/NZ eligibility and identity exclusions (00:55 AEDT).**
   - Eligible: AU 4,157, NZ 421.
   - Identity mismatch: AU 3,686, NZ 2,539, CA 1,240.
   - The 29 Oct drop (AU 4,977 → 4,156) is explained. The re-map binder displaced 789 code-proved pages: 714 wrongly and 75 correctly or defensibly.
   - Prevention is live (W31). Recovery is R1, BLOCKED on spend.
   - Past-year handbook currency is a decision (92 held, plus 110 currently eligible).
9. **Coverage at 00:55 AEDT:**
   - Sources: 102.
   - Provider matrix: 343 active (RMIT), 2,186 proposed, 20 unverified, 765 superseded.
   - Course reads: 184 in review, 16 skipped, 3 failed.
   - Layer 4: 515 pending, 241 of them AER.
   - What reaches the website and Zoho: RMIT's 343 active rows only; no course row yet.
   - OpenRouter balance: US$104.98, after a top-up at about 00:15. This is monitoring information only; nothing was queued.

## 4. Tests and release evidence

| Run | Result |
|---|---|
| Local, v2.15.370 | 1,211 passed, 1 failed (s173 version pin), fixed and re-run green |
| Local, v2.15.371 | 1,221 passed, 1 failed (nz-coverage: a reader rule regression caught), fixed in code and re-run green with assertions unchanged |
| Post-merge (both releases) | Deployed UAT, release currentness, history contract, build and deploy green |
| Weekly deployed run (safe mode, live-acting held) | Desktop 78/79, phone 77/80. The Universities regression is fixed; four load-timing failures remain (§6) |

## 5. BLOCKED: the single decision each item needs

The decision paper sets each item out in full.

| # | Item | Decision needed |
|---|---|---|
| A1 | "Approve except" for AER runs | Approve or decline |
| A2 | Exclude AER items from bulk decide | Approve (recommended) or decline |
| A3 | Who decides AER items | Platform Admin only (recommended), or Curators with sign-off |
| A4 | Website wording for an unscaled printed grade | Approve the wording, or keep "contact the provider" |
| A5 | Bulk Read again on the newest copy | Option A (recommended), Option B, or decline |
| B1 | Three source re-reads | ≤ US$0.05 |
| B2 | Three Monash course reads | ≤ US$0.10 |
| B3 | Next 500 AU course reads | Ceiling US$6 |
| B4 | NZ course reads | Form (a) or (b), ceiling US$4.50 |
| B5 | The AU remainder | Approve in tranches of US$6 |
| R1 | Recovery of 714 displaced pages | ≤ 714 Firecrawl credits, no AI |
| — | Past-year handbook pages | May AER read them? |
| — | Admin-read timeout snapshots | Approve the four designs for build (notices, course coverage totals, publishability, field coverage) |
| — | "Why values are missing" panel | Show the run time on the panel |
| — | Five stuck adapter drafts | Paste file |
| — | Edge-runtime capacity against job frequency | Platform Admin decision |
| — | Retire the old `'universities'` action | A later md5-guarded edit once the new screen is confirmed |

Layer 4 review of the 240 actionable AER items is human work: the reviewer works through the manifest using the role guides §5.6.

## 6. Weekly deployed run (01:00–01:15 AEDT, run `40886434507`, safe mode)

Results are on the `deployed-weekly-results` branch, `weekly/2026-10-30*.json`.

| Viewport | Tests | Passed | Failed | Skipped |
|---|---:|---:|---:|---:|
| Desktop | 79 | 78 | 1 | 0 |
| Phone | 80 | 77 | 3 | 0 |

Live-acting tests held (switch off): 10.

**Fixed:** the Universities budget regression left red on 29 Oct. "Layer 2 Adapters stay within management-view budgets" now passes on desktop and phone after W33.

**Still red: FAILED, left red by rule.** All four failures come from database response time under load, not from a screen or contract regression:

| Test | Failure |
|---|---|
| `performance-deployed` › core workspaces (desktop and phone) | `providers_page` 3,552 ms and 3,043 ms, `courses_page` 3,020 ms and 3,018 ms, against the 3,000 ms budget |
| `cf-209` Scheduler and Jobs (phone) | `admin_read('pipeline_jobs_page')` returned HTTP 500, a statement timeout |
| `cf-247-field-coverage` (phone) | `admin_read('course_coverage')` returned HTTP 500 twice, a statement timeout |

- One desktop drawer check (Country of prior education) failed once and passed on retry.
- These are the intermittent admin-read timeouts that lane J measured: about 200 in 48 h, all under concurrent load. `course_coverage` re-totals 524,000 snapshot rows on every open.
- **No assertion was loosened. The deployed suite is not green.**
- **Decision needed:** approve the cached snapshot designs for build (notices, course coverage totals, scholarship publishability, field coverage), and/or reduce the load. Several workers fire every 30–60 seconds, and the edge runtime is degraded in the evening. Each design needs a new table and a catalogued job (G1, G2).
- Until then the weekly run and the acceptance tier stay red on these four tests.

## 7. Branches

Merged into main by squash:
- `cf247-w30-int` (#747);
- `cf247-w33-int` (#748), which contains `cf247-w31-int`.

The lane branches are superseded by these:
- `cf247-enrich-reliability`;
- `cf247-reader-answer-limits`;
- `cf247-universities-paging`.

This session's proxy refuses ref deletion, so they are recorded here for deletion by a session that can delete refs. Local worktrees were removed after the merge. No agent work is left unmerged.
