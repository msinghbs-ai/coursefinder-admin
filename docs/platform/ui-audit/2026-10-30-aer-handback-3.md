# AER programme: handback 3 (30 Oct 2026, mandate 08:45)

**Mandate:** Platform Admin, 30 Oct 2026 08:45 AEDT, covering D1–D9 and making Layer 4 review enablement the priority. Every figure here was read live from `fxcwkweaxjtknorudmwp` at the AEDT time stated.

**Records used:**
- Decisions: `AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md` §11 and §11.1–§11.3.
- Manifest: `2026-10-30-layer4-aer-review-manifest.md`.
- Capacity: `2026-10-30-D8-capacity-decision-paper.md`.

**Not complete.** The next milestone is reviewed and admitted course-level AER data reaching the additive consumer API. As of 10:15 AEDT:
- 0 course-level rows are admitted;
- 1,055 AER items wait for human review;
- consumer-visible AER is still RMIT's 343 provider-table rows only.

## 1. Releases and live changes (merged, deployed, verified)

| Change | PR | What | Verified live |
|---|---|---|---|
| D1 step 1 | #760 | Page limit 205,000 (range up to 250,000), up to 19 slices, slice concurrency 10; 5-course probe | Settings live 08:57 |
| D3, D1 step 2 | #761 | R1 leftover recovery; 36 held QUT pages | Queued 09:06 |
| D1 pause | #762 | Slice concurrency back to 4 | 4 / 19 / 205,000 |
| **v2.15.374** | **#763** | **D4 supersede rule; D6 role check** | md5s `db3fde75`, `ce8d0bad`, `629fcbda`, `8ad49afc`, matching the dry runs |
| D7 | Operator paste, run by this session under the approval | 5 stuck drafts set to `error` | 08:50:59 |

## 2. D1: long course pages (ceiling US$6)

**Unique scope**, reconciled at 08:48: 48 held long pages and 137 never-read QUT courses.
- The held pages are QUT 43, Monash 3, AUT 1 and NorthTec 1. Handback 2 said 46 and named AUT for the 880,128-character page; both were errors.
- NorthTec (880,128 characters) stays held, because it is over 205,000.

| Batch | Courses | Complete | Held | Rows proposed | Spend |
|---|---:|---:|---:|---:|---:|
| Probe (Monash 3, AUT 1, QUT 1) | 5 | 5 | 0 | 29 | US$0.1064 |
| Step 2 (QUT held) | 36 | 36 | 0 | see Layer 4 | US$1.5827 |
| **Total** | **41** | **41** | **0** | | **US$1.6891** |

**Stopped at the ceiling check.**
- Measured cost: QUT US$0.00259 a slice (Monash about US$0.0018).
- The 125 unread QUT pages that are readable on their newest copy need about 1,811 slices, about US$4.69. Only US$4.31 is left.

**Not read, and why:**
- 15 QUT courses are bound to an older copy while a newer copy of the same page exists (shared double-degree pages). That is 6 held and 9 unread.
- 3 unread QUT pages are estimated over 205,000 characters.

**Settings now:** `entry.course_page_chars` 205,000; `enrich.course_entry_max_slices` 19; slice concurrency 4.

**Exact decision:**
- (a) Raise D1's ceiling to about US$7.70 and read the 125;
- (b) read about 90 of them within the US$4.31 left;
- (c) leave QUT unread until the queue is reviewed (recommended, in line with review-first).

## 3. D3: R1 leftovers (ceiling 35 credits, no AI)

Spend: 0 Firecrawl credits, no AI. No page was restored.

| Category | Count | Outcome | Remaining gap and next decision |
|---|---:|---|---|
| Single attempt already made | 7 | Attempt complete (CRICOS not found). Curtin 5 are their course pages; UniMelb 1 is a fees page; Newcastle 1 is a pathway page | Curtin 5 may need a rendered read |
| Needs render | 6 (Federation 5, UNSW 1) | Retried at 09:06 but read directly: the worker renders only bound or priority pages, and these are ambiguous | A rendered read needs a worker rule change (render ambiguous pages once on request), or permanent course-priority rows that a migration can never remove. **Decision:** approve one of these |
| Fetch failed | 4 | Retried once and still failing; 1 is a Sydney PDF the HTML reader cannot read | Leave displaced |
| Adapter-code proofs (Flinders) | 13 | Not restored. No approved rule promotes on an adapter code. 5 of 13 name a different course or variant (MA Research for MA Social Work; PhD Research for PhD Nursing/Midwifery; BCIFT; MCRNOT; GDPTESOL exit-only) | 8 have exact-title handbook pages. **Decision:** approve or decline an "adapter code plus exact title" rule for Flinders handbook pages |
| Blocked (QUT) | 2 | Left blocked | None |
| Identity mismatch | 3 | Left unbound. Curtin 2 now show "Course not found"; UNSW 1 redirects to degree search | The courses may be discontinued (catalogue check) |

**Overall R1 status:** 679 of 714 restored; 35 still displaced.

## 4. D4, D5 and D6

**D4 (live in v2.15.374)**
- Under Approve except, an active row is superseded only by an approved row with the same identity.
- An excluded replacement leaves the active row unchanged, and the two are linked.
- Conflicts hold the decision with nothing changed. On a course page with active rows, Approve except is held.
- **Evidence:** rolled-back live dry run of every path; s180 has 10 tests; reviewer guide §5.1, §5.2 and §5.6 updated.

**D6 (live in v2.15.374)**
- The `admin_adapter_measures` role check is now enforced at rank 5 or above, with owner sessions kept.
- Dry run results:
  - allowed: owner, Platform Admin (rank 6), rank 5;
  - refused with 42501: anon, curator, rank 4, service_role with no user.
- s181 covers the contract; s183 runs deployed.
- The sweep found no other callable function with the defect. The 280 owner-only or service-only functions with the same idiom are reported, not changed; a central guard would need its own decision.

**D5 (built; BLOCKED waiting for the Platform Admin's paste)**
- The `scale_stated` marker:
  - `true`: the scale is stated;
  - `false`: a grade is printed with no stated scale;
  - `null`: case by case. Course-page rows are always `null`.
- It is added only in `entry_matrix_payload_v1` and `entry_resolve_v1`. The dry run showed every existing key byte-identical; 343 items keyed (310 true, 33 null).
- R1: "Not stated on the page" can be recorded in the workspace.
- Suite 1,257/0/0.
- **Exact decision:** apply `pastes/PASTE-20261030-d5-scale-stated-marker.sql`. The PR (`cf247-d5-lane`) then merges as v2.15.375, and the developer guide issue 6 and O9 (`ui-audit/d5-drafts/`) are issued with re-measured figures.

## 5. D7, D8 and D9

| Item | Outcome |
|---|---|
| **D7, stuck drafts** | Ran 08:50:59 after a rolled-back dry run; every precondition held. 5 drafts went to `error`; drafts capturing 24 → 19; Vardhan and AIBT unblocked; 7 onboarding events unchanged; nothing deleted; no cost |
| **D8, capacity** | Decision paper only. Recommended first: P1 (minutes 3, 5, 9), P3, and the P6 no-retry rule. No production change |
| **D9, branches** | **BLOCKED.** All four branches re-verified as redundant. The proxy refused deletion (`git push --delete` hung up; refs API HTTP 403). Operator action: `git push origin --delete cf247-enrich-reliability cf247-reader-answer-limits cf247-universities-paging cf247-zoho-dryrun`. This mandate's merged branches are listed in handback 2 §10 for the same command |

## 6. Layer 4 queue and admitted coverage (10:15 AEDT)

**Pending AER items: 1,055.**

| Kind | Pending | Detail |
|---|---:|---|
| Course first reads | 997 | 961 in the manifest + 36 from D1 step 2 |
| Provider-table first runs | 54 | 50 actionable |
| Change items (RMIT) | 4 | Approve except now safe under D4 |

**Not actionable:** 1 superseded Otago Polytechnic run, and 3 no-table notes that admit no data.

**Decided today:** 0. No AER decision was recorded by Kimi Work or by anyone else.

**Active rows:**
- Provider table: 343 (RMIT only), visible in the Website API `entry_matrix`.
- Course: 0.

**Consumer-admitted coverage:** 1 provider (RMIT, provider table); 0 courses.

## 7. Unread courses

| Group | Count | Status |
|---|---:|---|
| AU eligible, never read | 4,132 | QUT 137 (D1) + 3,995 (B5) |
| NZ eligible, never read | 17 | Beyond the approved B4 scope of 421 |
| Held long pages | 7 | QUT 6 (older copy) + NorthTec 1 (over limit) |

## 8. B5: tranches prepared, not queued (D2)

- **Status:** B5 stays blocked until:
  - D1 has been reconciled (done, §2);
  - the actionable queue has been substantially reviewed;
  - reviewer capacity has been quantified (§8);
  - you approve a single tranche.
- **Scope:** courses that are eligible and never read, AU, in plan order, live at 09:10 AEDT. QUT (137) is excluded because it is D1's scope.
- **Basis for the estimates:**
  - **Course counts:** exact.
  - **Slices:** estimated from each stored copy's compressed size. The ratio of text to compressed bytes depends on how the copy was stored:
    - about 1.7 for Firecrawl markdown copies (QUT measured 1.71);
    - 0.1 to 0.7 for direct HTML copies (RMIT 0.52, Monash 0.65).
    - Slice counts are therefore ±30%.
  - **Cost:**
    - Low: US$0.0013 a slice, the AU average measured in B3.
    - High: US$0.0026 a slice, the QUT rate measured in D1, which applies to long markdown copies.
  - **Held pages:** estimated to be over 205,000 characters. These would be held at US$0, so they count toward neither yield nor cost.
  - **Expected Layer 4 items:** about 85% of the courses read, B3's measured yield (424 of 500 read reached review).

| Tranche | Providers (never-read courses) | Courses | Likely held (> 205k) | Est. slices | Est. cost low to high | Expected Layer 4 items |
|---|---|---:|---:|---:|---|---:|
| T1 | RMIT 32, Flinders 336, Western Sydney 245, Macquarie 33 | 646 | about 103 (WSU 102) | about 2,520 | US$3.30 to 6.60 | about 460 |
| T2 | UNSW 416, Swinburne 183, Wollongong 195, Sydney 6 | 800 | 0 | about 1,740 | US$2.30 to 4.50 | about 680 |
| T3 | UWA 277, Curtin 264, Federation 2 | 543 | 0 | about 1,960 | US$2.60 to 5.10 | about 460 |
| T4 | UTS 292, Victoria University 108, Adelaide 235 | 635 | about 138 (UTS) | about 2,340 | US$3.00 to 6.10 | about 420 |
| T5 | Melbourne 309, ANU 320 | 629 | about 139 (Melbourne) | about 530 | US$0.70 to 1.40 | about 415 |
| T6 | Queensland 313, Newcastle 187, Griffith 242 | 742 | 0 | about 3,260 | US$4.20 to 8.50 | about 630 |
| **Total** | | **3,995** | **about 380** | **about 12,350** | **US$16 to 32** | **about 3,065** |

**Ceilings and holds:**
- The high end of T1 and T6 is above US$6, so a US$6 ceiling may not complete those tranches. Each tranche's migration would stop at its ceiling, as D1 did.
- Where many pages are likely to be held (Western Sydney, UTS, Melbourne), they would need a D1-style page-size decision. The Victoria University pages (106 of 108 between 100k and 205k) are now within the 205,000 limit.

**Review impact:**
- The current queue is 1,019 items.
- B5 in full would roughly quadruple it, adding about 3,065 course items: about 51 more reviewer-hours at the manifest's assumption of 1 minute an item.
- **Recommendation:** approve one tranche at a time, only after the current queue has been worked down. T2 is the best first tranche: no likely holds, a low cost range and about 680 items.

## 9. Every open item and its exact decision

| # | Item | Decision needed |
|---|---|---|
| D1 | QUT 125 unread | (a) raise the ceiling to about US$7.70, (b) read about 90 within US$6, or (c) wait for the review (recommended) |
| D1 | 15 QUT on an older copy | None now. They are read once their binding moves to the newest copy (the reader's next pass) |
| D2 | B5 | Approve one tranche (T2 recommended first) after the queue is worked down |
| D3 | 6 needs-render | Approve a one-off render path: a worker rule, or course-priority rows |
| D3 | 8 Flinders exact-title adapter pages | Approve or decline an "adapter code plus exact title" rule |
| D5 | Marker | Apply the paste |
| D8 | Capacity | Select proposals |
| D9 | Branch deletion | Run the one command |
| — | Layer 4 review, 1,051 actionable | Human, one at a time (manifest §6 gives the order) |
| — | Website rendering | Website team (O9, §2.4) |

## 10. Tests and deployed verification

- **Local:** 1,266 passed, 0 failed, 0 skipped (v2.15.374). Register regenerated.
- **Deployed, first run:** weekly safe run `40971522020` on `a50aeb8d` (v2.15.374), 10:12–10:24 AEDT.
  - Desktop 79 of 80, phone 80 of 81.
  - The only failure was the new D6 spec s183, on a wrong premise: the UAT login is a Pipeline Operator (rank 4), and D6 correctly refused it.
  - **Fixed in #764:** s183 now requires the exact refusal below rank 5 and an answer at rank 5 or above. No assertion was loosened.
- **Deployed, final:** weekly safe run `40978658818` on `a8e02461`, finished 11:28 AEDT, **success**.
  - Desktop 80 of 80, phone 81 of 81, 0 skipped.
  - Live-acting specs held (switch off): 10.
- **Reconciliation at 11:30 AEDT:**
  - AER items pending: 1,055; decisions in the last 24 hours: 0.
  - Active rows: course 0, provider table 343 (RMIT).
  - Entry reads waiting: 0.
  - The D5 before-md5 `be5478d0` is unchanged: the paste has not been applied.
