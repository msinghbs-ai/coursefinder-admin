# AER and enrichment programme: handback 2 (30 Oct 2026, mandate 06:53)

**Mandate:** Platform Admin, 30 Oct 2026 06:53 AEDT. It approved A1–A5, the paid lines B1–B4 and R1, cached snapshots for the four slow admin reads, and the run time for "Why values are missing". It asked for:
- the stuck-drafts paste, prepared but not executed;
- a read-only assessment of edge capacity;
- branch cleanup.

Every figure here was read live from `fxcwkweaxjtknorudmwp` at the AEDT time stated. The previous handback, `2026-10-30-aer-enrichment-handback.md`, covers the 00:01 mandate.

**AER and enrichment are not complete.**
- 1,014 AER items wait for one-at-a-time human review in Layer 4. Nothing read in this mandate has been admitted.
- 4,132 eligible AU courses have never been read. B5 is not approved; its tranches are prepared in §6.
- 46 course pages are held because they are longer than `entry.course_page_chars` (§7, decision D1).
- Website rendering of the A4 wording, and of AER generally, is website-team work.

## 1. Releases (merged, deployed and verified live)

| Release / step | PR, commit | What | Live verification |
|---|---|---|---|
| B1 and B2 | #749 `8e4e859f` | 3 source re-reads; 3 Monash course reads | B1 delivered; B2 held at US$0 (§3) |
| R1 | #750 `b7b7402c` | Recovery of 714 displaced AU pages (event 25561) | §2 |
| v2.15.372 | #751 `b1cf6189` | A1–A3 review path; A5 bulk Read again on the newest copy, with its role check corrected | md5s match the dry runs (change control 07:33) |
| B3 batches 1–3 | #752 `ea944cb5`, #753 `6ee5e8b1`, #754 `9a42f877` | 500 AU courses | §3 |
| B4 batches 1–3 | #755 `bce2d60b`, #756 `70f9b0fc`, #758 `95766871` | 421 NZ courses | §3. `entry.course_read_countries` restored after each (`["AU","NZ"]`, `updated_at` unchanged) |
| v2.15.373 | #757 `b74abefb` | W34 and W35 cached snapshots; "Why values are missing" run time | §4 |

## 2. R1: identity recovery (final, 08:24 AEDT)

**Queued:** 714 pages (manifest A 451 and B 263). Each page got one read attempt.

| Outcome | Pages |
|---|---:|
| Bound on a fresh CRICOS proof, eligible again | 677 |
| Bound on an exact title, not eligible for entry requirements | 2 |
| Read, still ambiguous: 13 are adapter-code proofs (the reader promotes only on CRICOS); 7 found no code | 20 |
| Needs render | 6 |
| Fetch failed | 4 |
| Identity mismatch | 3 |
| Blocked | 2 |
| **Total** | **714** |

- **Spend:** 3 Firecrawl credits against the 714-credit ceiling, and no AI.
- **Identity counts:**
  - restored: 679;
  - still displaced: 35 (the 20 + 6 + 4 + 3 + 2 above);
  - held and not touched: 73 past-year handbook pages, 3 refused pages, 32 others.
- **Eligible now:** AU 4,834 (it was 4,157 before R1) and NZ 438.
- **Next decision (D3):** whether the 13 adapter-code proofs may be promoted on the adapter code (today only CRICOS promotes), and whether the 6 needs-render pages get a rendered read (Firecrawl credits).

## 3. Paid reads: spend against each ceiling and outcomes

| Line | Ceiling | Actual | Read | Layer 4 review | Skipped (page states none, or no row met the rules) | Held | Proposed rows | Admitted |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| B1, 3 source re-reads | US$0.05 | **US$0.0155** | 3 | 3 items (21 rows) | 0 | 0 | 21 | 0 |
| B2, 3 Monash courses | US$0.10 | **US$0** | 0 | 0 | 0 | 3 (pages 100,365–108,295 characters) | 0 | 0 |
| R1, 714 pages | 714 credits | **3 credits** | 714 | — | — | — | — | — |
| B3, 500 AU courses | US$6 | **US$2.6874** | 457 | 424 | 33 | 43 (QUT) | 1,714 | 0 |
| B4, 421 NZ courses | US$4.50 | **US$0.8207** | 419 | 348 | 71 | 2 (AUT 108,958 and 880,128 characters) | 925 | 0 |

**Notes on the paid lines:**
- **Final:** every B3 and B4 item is settled (0 entry reads waiting at 08:27 AEDT).
- **B3 by batch:**
  - Monash 155 and QUT 45: US$1.18.
  - RMIT 200: US$1.14.
  - RMIT 100: US$0.38.
- **QUT paused.** 43 of 45 QUT pages were held before any AI call, so QUT was not continued (mandate: "stop on repeated truncation", "use covered slices"). B3 continued with RMIT, the next provider in plan order. Each batch was dry-run live and rolled back first. Held reads count toward the 500, so B3 was not extended.
- **B4:** the 17 eligible NZ courses beyond the approved 421 (438 − 421) were not read.
- **Setting restored:** `entry.course_batch_size` was 50 → 200 for B3 and B4, and is restored to 50 by `20261030210000` (§8).
- **Total AI spend this mandate:** US$3.52 across B1–B4. OpenRouter balance US$101.35 (observed about 08:20), floor US$5.

## 4. v2.15.373: cached snapshots (W34, W35)

| Read | Before (live) | After (dry run, same answer) |
|---|---:|---:|
| `admin_read('course_coverage')` AU top 10 | 2,460 ms | 33 ms |
| `pipeline_jobs_page` | 1,607 ms | 300 ms |
| `courses_page` | 1,188 ms | 700 ms |
| `providers_page` (4 cases) | 364 / 124 / 238 / 71 ms | 37 / 33 / 187 / 60 ms, 4 of 4 identical |
| `admin_platform_notices_read` | 1,721 ms | 6 ms (same kinds and counts) |
| `admin_field_coverage` NZ | 3,040 ms | 1,283 ms (identical figures) |

**What was verified live after the merge (08:18 AEDT):**
- First builds, all with no error:
  - notices 1.7 s;
  - publishability 0.9 s;
  - field coverage 1.6 s;
  - coverage totals 2.4 s (48,402 rows).
- Jobs `admin-read-snapshots` (every minute) and `course-coverage-snapshot` (`2-59/5`) are scheduled and catalogued.
- `gap-causes` now runs `gap_causes_run_v1()`, and one run is seeded from the cron history.
- `admin_read` is unchanged (`6b1bb9d5`).
- Component register rows are at `20261030190000` and `20261030200000`.

**What did not change:**
- **Read-only and derived:** no consumer API or admission change; permissions unchanged.
- Drill-downs and one university's figures stay live.
- Each screen shows "Counted <time> (<age>)" and a **Stale** chip once a snapshot is past its setting.

**Tests:**
- Local suite: 1,252 passed, 0 failed, 0 skipped.
- The register was regenerated (admin `65f11971`).
- **Deployed:** the weekly run was dispatched after the release (run `40956651633`, safe mode). Its result is in §5.

## 5. Deployed weekly run after v2.15.373

Run `40956651633`: dispatched 08:18 AEDT on `b74abefb` (v2.15.373), safe mode, finished 08:30 with **success**. Results are on `deployed-weekly-results`, `weekly/2026-10-30*`.

| Viewport | Tests | Passed | Failed | Skipped |
|---|---:|---:|---:|---:|
| Desktop | 79 | 79 | 0 | 0 |
| Phone | 80 | 80 | 0 | 0 |

Live-acting tests held (switch off): 10.

**The four tests red at 01:00 now pass at the first attempt:**

| Test | Desktop | Phone |
|---|---:|---:|
| `performance-deployed` › core workspaces | 8.0 s | 7.7 s |
| `cf-209` Scheduler and Jobs | 2.6 s, 4.2 s | 2.3 s, 3.8 s |
| `cf-247-field-coverage` | 4.8 s | 8.2 s |

- No assertion, budget or timeout was changed, and no live-acting control was skipped.
- One unrelated desktop test was flaky: `cf-061` QILT comparison. Its course-row locator was not visible on the first attempt, and it passed on retry. It is recorded here, not hidden.

## 6. B5: prepared, not approved

- **Remaining:** 4,132 eligible AU courses have never been read. Of these, 137 are QUT, which waits for D1.
- **Cost basis:** B3 measured US$0.0059 per course read; the plan adds 25% for the estimate.
- **Shape:** each tranche is in plan order, one provider at a time where possible, with a ceiling of US$6. Every tranche would use the B3 migration pattern: live dry run, preconditions, post-checks, one batch at a time.

| Tranche | Providers (never-read courses) | Courses | Estimate |
|---|---|---:|---:|
| T1 | RMIT 32, Flinders 336, Western Sydney 245, Macquarie 33 | 646 | about US$4.80 |
| T2 | UNSW 416, Swinburne 183, Wollongong 195, Sydney 6 | 800 | about US$5.90 |
| T3 | UWA 277, Curtin 264, Federation 2 | 543 | about US$4.00 |
| T4 | UTS 292, Victoria University 108, Adelaide 235 | 635 | about US$4.70 |
| T5 | Melbourne 309, ANU 320 | 629 | about US$4.65 |
| T6 | Queensland 313, Newcastle 187, Griffith 242 | 742 | about US$5.50 |
| **Total** | 3,995 (QUT excluded) | **3,995** | **about US$29.55** (ceilings US$36) |

## 7. AER coverage the consumer can see, and the review queue

**Admitted and visible to the consumer API:**
- **Provider level:** one provider. RMIT has 343 active entry-matrix rows (admitted 27 Oct).
- **Course level:** 0 active course entry rows. Every course read waits in Layer 4.

**Waiting rows (proposed, not visible):**
- Course rows: AU 2,409 rows for 608 courses; NZ 925 rows for 348 courses.
- Provider matrix rows: 2,205 across 26 providers (plus 20 unverified for RMIT).

**Layer 4 AER queue (pending, 08:24 AEDT):**

| Kind | Pending |
|---|---:|
| `course_entry_first_read` | 956 |
| `entry_matrix_first_run` | 54 |
| `entry_matrix_change` | 4 (reject until the open point in decision §10 is decided) |
| **Total** | **1,014** |

**Review rules:**
- Review is human and one item at a time (A1–A3). Bulk and batch decide skip AER items (A2), and only the Platform Admin decides them (A3).
- **No bulk.** Approve except keeps excluded rows visible and unadmitted.
- **A4:** for an unscaled grade, use the reviewer rule in role guide §5.2. The API marker (`scale_stated: false`) is website decision O9 and has not been built.

## 8. Health at close-out (08:20 AEDT)

**W30 duplicate scrapes** (same URL scraped within 5 s):

| Window | Duplicates | Rate |
|---|---|---:|
| After W30, 00:40–07:22 AEDT | 7 of 161 | 4.3% |
| The same-length window before W30 | 48 of 227 | 21% |
| The day before | 202 of 538 | 37.5% |

The remaining 7 are pages shared by 2–4 courses, not the race.

**Jobs and reads:**
- **Source finder:** 72 runs in 24 h. No statement time-out since about 00:00 AEDT; before that, 1–3 an hour.
- **Course list read:** 18 runs in 3 h, median 0.04 s, max 0.20 s.
- **Capture:** 6 capture and 6 propose runs in 24 h. The volume is low because Vardhan and AIBT are blocked by the stuck drafts (the paste is in §9).
- **`adapter-overwrite`:** 1 statement time-out in 18 runs over 3 h. Added to capacity proposal P1/P2.
- **Waiting:** entry reads still waiting at 08:27: 0.

## 9. Prepared, not executed (operator actions)

| Item | Where | State |
|---|---|---|
| Five stuck adapter drafts → `error` | `docs/platform/pastes/PASTE-20261030-stuck-adapter-drafts.sql` (with reconciliation) | **Not executed.** Preconditions re-verified at 07:58 AEDT: 5 drafts capturing, snapshot `b8e5c62a` |
| Edge capacity, P1–P7 | `docs/platform/ui-audit/2026-10-30-edge-capacity-assessment.md` | Read-only. No schedule, binding or capacity changed |
| Delete 3 lane branches | §10 | **BLOCKED** by this session's proxy |

## 10. Branches

- `cf247-zoho-dryrun` was fast-forwarded to main (`6ee5e8b1`).
- `cf247-enrich-reliability` (`739d7145`), `cf247-reader-answer-limits` (`0644db73`) and `cf247-universities-paging` (`f6bf116d`) were verified to hold no unique work. Every added line is in main except:
  - integration renumbering (`XXXXXX`);
  - worker version labels, since superseded by v0.54.1.
- **BLOCKED:** this session's proxy refused the deletion (git push and the REST API both returned 403). Operator action: `git push origin --delete cf247-enrich-reliability cf247-reader-answer-limits cf247-universities-paging`.
- The integration branches of this mandate (`cf247-aer-b3-*`, `cf247-aer-b4-*`, `cf247-v373-int`) are squash-merged. Local worktrees are removed.

## 11. Each open item and the exact next decision

| # | Item | State | Exact next decision |
|---|---|---|---|
| D1 | 46 pages over `entry.course_page_chars` (100,000): QUT 43 (173k–201k), Monash 3 (B2, 100k–108k), AUT 2 (109k, 880k) | **BLOCKED** at US$0 | Raise the setting to 205,000 (18 slices of 12,000 with 600 overlap) and approve one bounded re-read of these 46, plus the 137 unread QUT courses, at an estimated US$0.03 per long page (ceiling about US$6). Or keep 100,000 and leave QUT unread. The 880k AUT page stays held either way. |
| D2 | B5, the AU remainder | Prepared (§6) | Approve tranches T1–T6, each with a ceiling of US$6, one at a time. |
| D3 | R1 residue: 35 pages | Reconciled | Promote the 13 adapter-code proofs on the adapter code (an identity-rule change), or keep CRICOS-only. Separately, allow a rendered read for the 6 needs-render pages (Firecrawl, about 6–30 credits). |
| D4 | Approving an `entry_matrix_change` supersedes an active row whose replacement was excluded | Open point (decision §10) | Decide the supersede rule. Until then reviewers reject such change items (role guide §5.1). |
| D5 | A4 marker in the API (`scale_stated: false`) | Documented (O9) | Approve the additive API field. The developer guide is reissued with it. |
| D6 | `admin_adapter_measures` uses the same role-check idiom that never fired | Reported, not changed | Approve a correction in the A5 pattern. |
| D7 | Stuck drafts paste | Prepared | Platform Admin runs the paste, or instructs a session to. |
| D8 | Edge capacity, P1–P7 | Assessed | Choose which proposals to apply. P6 (one deployed UAT run at a time) is the largest single load reduction. |
| D9 | Lane branch deletion | BLOCKED (proxy) | Run the one command in §10. |
| — | Layer 4 review of 1,014 AER items | Human work | No decision; the reviewer works through them with role guides §5. |
| — | Website rendering (A4 wording; AER display) | Website team | Requirements O9 and §2.4. |
