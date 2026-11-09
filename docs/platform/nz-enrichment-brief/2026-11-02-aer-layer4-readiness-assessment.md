# CF-247 — Layer 4 AER readiness assessment (mandate steps 1–3, read only)

**Date:** 2 November 2026, live reads 16:43–18:07 AEDT.
**Authority:** Platform Admin, *CF-247 Layer 4 AER Recovery and Governed Admission*, 2 Nov 2026 16:33 (`2026-11-02-aer-layer4-recovery-mandate-1633.md`), §11 steps 1–3 (reconcile, validate E13, classify).
**Read first:** `2026-11-02-aer-layer4-admission-review-and-playbook.md`, `../AGENT-OPERATING-MODEL.md`, `../ENTRY-REQUIREMENTS.md` (Draft 1.2), `../AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md` (§9–§11.1, A1–A3 and D4), `2026-11-02-morning-execution-mandate-and-decisions.md` (E11–E14), `2026-11-02-aer-phase-a-baseline.md`, `2026-11-02-platform-admin-decisions-1450.md` (D-A1–D-A5).
**Code:** Pilot `main` `3f62c2b3` (v2.15.406), read only. E13 = migration `20261102010000`, spec `tests/uat/cf-247-s213-e13-completeness-gate-contract.spec.mjs`.
**Per-item register:** `ui-audit/aer-readiness-2026-11-02.csv` (539 rows: item, provider, kind, course or source, class, root-cause fingerprint, recommendation, stored evidence id).

**Method and load.** Read-only `SELECT`s on `fxcwkweaxjtknorudmwp` only, `statement_timeout` 8 s, keyed by provider or item. Heavier reads ran only at :x6–:x8 (16:46, 16:56–16:58, 17:06–17:08, 17:16–17:18, 17:26–17:28, 17:46, 17:56–17:58, 18:06–18:07); nothing ran at :35–:42 or :47–:48. Four queries hit the 8 s limit; each was split, not re-run larger (one set of RMIT row look-ups was dropped instead, §6.1). No Layer 4 decision, no write, no SQL settlement, no AI, no Firecrawl, no edge-function call.

**Limit on this assessment.** The stored copies are gzipped HTML in Storage (`pipeline.evidence_artifacts.storage_path`). Their text is **not** in any table, and read-only SQL cannot open it. Every check below therefore uses the read's own record: quotes (the reader already proved each kept quote is on the stored page), dropped rows with reasons, proposed rows, source and run metadata, bindings, and the E13 gate parts. Two consequences:
- Class **A** means "passes every check that can be made without opening the stored page". The reviewer still opens the stored copy in Layer 4 › Review and confirms that nothing published is missing. That check is named on every A item.
- Class **E** (verified no published requirement) is **0**. It cannot be given without reading the stored rendered text, and in any case none of the three zero-row reviews qualifies (§5.4).

---

## 1. Summary

| | Count |
|---|---:|
| Pending AER items (live, 18:06) | **539** (499 course first reads + 40 provider-matrix first runs) |
| **A** evidence-complete, review-ready | **45** (all course reads: AUT 20, Monash 8, VUW 8, EIT 3, Lincoln 3, MIT 1, Ara 1, Otago 1) |
| **B** correctable reader defect | **416** (377 course, 39 matrix) |
| **C** insufficient evidence | **73** (RMIT 62 under E11, Monash 9, VUW 1, Newcastle matrix 1) |
| **D** invalid (demonstrated) | **5** (Monash: the whole read is course-description text) |
| **E** verified no published requirement | **0** |
| Provider-matrix runs ready to approve as they stand | **0 of 40** |

- **Top root causes:** score without its basis (258 items, 6 providers), quote not matched (224 items, 9 providers), row cap (162 items, 8 providers), page shared with sibling programmes (81 items, 8 providers), and, for the matrices, ANU's swapped rank and score columns (22 runs) and row-identity collisions that D4 would refuse (18 runs, 5 providers).
- **E13 is deployed and works for what it covers.** It holds 203 of the 499 course reads now. It does **not** cover 170 reads that pass the gate while carrying score, quote or low-confidence drops. It does not cover any of the 40 matrix runs, and it cannot see reads whose content is not a requirement (§3).
- **No E14 risk in this queue.** None of the 499 pending course reads is on one of the 18 E14 courses. No pending course has an active row (§6.1).

---

## 2. Live reconciliation against the mandate baseline

| Measure | Mandate baseline | Live (16:46; re-checked 18:06) | Delta |
|---|---:|---:|---|
| Pending AER | 539 | 539 | 0 |
| `course_entry_first_read` pending | 499 | 499 | 0 |
| `entry_matrix_first_run` pending | 40 | 40 | 0 (`entry_matrix_change` pending 0) |
| Course reviews with a nonempty `dropped` | 353 | 353 | 0 |
| … with `over_row_limit` | 162 | 162 | 0 |
| … with `score_without_basis` | 258 | 258 | 0 |
| … with `quote_not_on_page` | 224 | 224 | 0 |
| Dropped candidate rows in pending course reads | 5,209 | 5,209 | 0 (RMIT 905, QUT 3,884, Monash 221, AUT 90, Auckland 49, MIT 43, EIT 12, Ara 3, VUW 2) |
| RMIT / QUT pending course reads | 298 / 38 | 298 / 38 | 0 |
| ANU pending provider reviews | 22 | 22 | 0 |
| UWA pending review: proposed / dropped | 177 / 8 | 177 / 8 | 0 |
| Proposed matrix rows on the 40 pending runs | 1,760 (Phase A) | 1,760 | 0 |
| AER Layer 4 decisions saved since 16:00 | — | 0 | no other reviewer has acted during this assessment |

Per-provider drop counts match the playbook's §2 table exactly. Every pending course item was created on 29 Oct, and every pending matrix run on 28–29 Oct. Every matrix run's `content_hash` still equals its source's hash, so no newer copy has been stored since the read.

**Live drift found while this assessment ran.** It is not in the queue counts but matters for decisions:
- **Shared-page set.** Pending course reads whose stored page is also bound to a differently named course numbered **99 at 17:16** (AUT 6, EIT 7, Lincoln 1, Monash 1, NMIT 1, QUT 9, RMIT 73, VUW 1) and **81 at 17:57**. Rows in `pipeline.coverage_course_pages` were re-bound in between. Example: AUT Postgraduate Diploma in Marketing `f14a633b…` now shares its URL with no other course. The E13 migration measured 98 on its own read. Who changed the bindings was not traced (read only), and it may be the concurrent E16 link containment work. Effect: the E13 "shared page" result can change for a read that has not changed, so the gate must be read at decision time, not from this file.
- **Phase A table rows.** UWA's "236 non-active" is 177 proposed plus **59 superseded rows from the same run** (9 and 50 rows from the 29 Oct programme re-reads). It is not 236 rows from other runs.

---

## 3. E13 completeness gate (v2.15.401) — deployed-behaviour validation

**Deployed state, verified live:**
- The live md5s equal the migration's "after" values: `security.enrich_entry_record_v1` `9757abee…`, `security.course_entry_review_apply_v1` `4be9267d…`, `security.aer_review_read_v1` `50c31fc4…`.
- Migration head is `20261102090000`.
- Settings are as decided: `entry.max_rows_per_course` 6, `entry.max_rows_by_provider` `[]`, `entry.shared_page_hold` 1, `entry.variant_check` 1, `entry.variant_check_off_providers` `[]`.
- Reader: no pending item can have been created under the E13 reader, because all of them predate it (29 Oct). The pre-E13 reader recorded every cut row as `over_row_limit`, so a six-row read with no recorded cut was genuinely six rows or fewer. A six-row result is not treated as complete because of its count: the gate looks only at recorded cuts.

**What it holds now (computed from its own rules, 17:57):** 203 of 499 course reads. Approve and Approve except are refused for these:

| Gate reason | Items | Providers |
|---|---:|---|
| Rows cut at the row limit (`over_row_limit`) | 162 | RMIT 94, QUT 38, Monash 15, MIT 5, Auckland 4, AUT 3, EIT 2, Ara 1 |
| Stored page shared with a differently named programme | 81 (21 of them with no drop at all) | RMIT 56, QUT 9, EIT 7, AUT 4, Monash/Lincoln/NMIT/VUW 1 each |
| Waiting row names another programme | 2 | EIT `cf30d490…`, `c02aa5eb…` (both also on shared pages; re-checked live with `security.course_entry_variant_v1` for every non-RMIT/QUT item and the 22 Monash A candidates) |

The migration header measured 215 held, with 98 on shared pages. The 12-item difference is entirely the binding drift in §2.

**Can a material incomplete read still be admitted as complete? Yes, through six routes:**

| # | Gap | Evidence | Size now | Fix route |
|---|---|---|---:|---|
| G1 | **`score_without_basis`, `quote_not_on_page` and `low_confidence` drops do not hold a read.** The gate counts only `over_row_limit`. A minimum the page prints (for example an ATAR or GPA whose basis words fall outside the quote) can be dropped while the read passes as "Read whole". | 170 course reads pass the gate and still carry such drops: RMIT 114, Monash 28, AUT 19, Auckland 6, VUW 2, MIT 1. Each is classed B here, not A. | 170 | Extend `security.course_entry_gate_v1`: each of these reasons holds unless the dropped quote duplicates a kept row (the test used in §5.2 found 19 of 211 such drops in the non-RMIT/QUT set to be duplicates). Hold reasons belong in a setting, for example `entry.gate_hold_reasons` (G2). This stays inside the E13 approval ("prevent incomplete reads from reaching approval"). |
| G2 | **Provider-matrix runs are outside E13 and outside any completeness guard.** The manifest guard runs only for `entry.completeness_providers` = `["8e1adb6c…"]` (RMIT), and RMIT is not in `entry.providers`. All 40 pending runs record `completeness.status = not_applicable`. Approving UWA today would admit 177 rows with China entirely missing. | 40 of 40 runs | 40 | A matrix completeness rule independent of RMIT's table shape (dropped published rows hold the run unless they are excluded by a reviewer with a reason, or represented elsewhere). This is a new design, so it needs a recorded decision before code (D-R3, §9). |
| G3 | **Content validity.** E13 judges completeness, not whether a row is an entry requirement. Fifteen course reads with no drops consist only of course descriptions, progression, credit or LANTITE text, or a waiver clause. Several A reads carry one such row. | 5 D, 10 C, plus exclusions on 7 A items | 22 | Reader rule plus reviewer check (R7, §8). |
| G4 | **Audience.** The reader's audience rule ignores the word "domestic", and "international" wins over ATAR in a quote. | 5 non-RMIT rows that say "domestic" stored as `all` (4 items classed B). 9 RMIT rows quoting ATAR or selection rank not stored as domestic. | 5 + 9 rows | R5, §8 |
| G5 | **English filter.** The B1 regex misses "proficiency in English", "competency in English" and "competence in the English language". | 3 rows (2 A items exclude them, 1 B) | 3 | R6, §8 |
| G6 | **Gate inputs move.** The shared-page part reads live bindings (§2), and the gate takes about 0.7 s an item. That is fine on the review screen, but a whole-queue check does not fit an 8 s statement (`course_entry_variant_v1` runs once for every proposed row before the item filter applies). | 18 items changed state between 17:16 and 17:57 | — | Record the gate result on the item at decision time (already in `aer_review_read_v1`). For monitoring, filter by item before the variant call (§8, R4). |

**Approval path checked for A items.** No pending course has an active row, so D4's "Approve except is held when the course already has active rows" does not apply to any of the 45. AER decisions are rank 6 (Platform Admin) only (A3). The existing action set for AER items is **approve**, **approve_except** (edit-and-approve in the Approve except shape) and **reject**. There is no "return" action for AER kinds, so "hold" below means leave the item pending.

**Process gap that blocks every B fix (needs a decision, D-R2).** While an item is pending, the course reader refuses a new read of the same course ("an earlier read of this course waits in Layer 4"). Nothing supersedes a pending course read: only matrix runs have the W28 re-read supersede. A corrected re-read of any B item therefore cannot land unless the old item is first rejected or superseded. Rejecting only to clear the way is exactly what the playbook forbids ("do not reject just to remove backlog"). A governed supersede for pending course reads (a W28 equivalent: the old item is marked `superseded` and points to the new read) is needed before the 377 B course reads can be recovered.

---

## 4. Classification of every pending item

Rules applied, in this order:
- **D** only where the read's own quotes show the whole read is not about entry.
- **C** where the read is not wrong, but the evidence needed to call it complete is missing:
  - RMIT reads with no reader defect, which are held by E11 because they come from the course-page (local) view;
  - reads whose only rows are non-requirement text;
  - a zero-row rendered page with nothing read.
- **B** where a named, reusable reader defect explains the gap.
- **A** only where every check passed and each row was read individually (§7).

Every item has exactly one class and at least one fingerprint in the CSV.

### 4.1 Counts by class × provider × kind

| Provider | Kind | A | B | C | D | E | Total |
|---|---|---:|---:|---:|---:|---:|---:|
| RMIT | course | 0 | 236 | 62 | 0 | 0 | 298 |
| Monash University | course | 8 | 44 | 9 | 5 | 0 | 66 |
| AUT | course | 20 | 26 | 0 | 0 | 0 | 46 |
| QUT | course | 0 | 38 | 0 | 0 | 0 | 38 |
| VUW | course | 8 | 3 | 1 | 0 | 0 | 12 |
| EIT | course | 3 | 7 | 0 | 0 | 0 | 10 |
| MIT (Manukau) | course | 1 | 9 | 0 | 0 | 0 | 10 |
| University of Auckland | course | 0 | 10 | 0 | 0 | 0 | 10 |
| Lincoln University | course | 3 | 1 | 0 | 0 | 0 | 4 |
| Ara | course | 1 | 1 | 0 | 0 | 0 | 2 |
| NMIT | course | 0 | 1 | 0 | 0 | 0 | 1 |
| Toi Ohomai | course | 0 | 1 | 0 | 0 | 0 | 1 |
| University of Otago | course | 1 | 0 | 0 | 0 | 0 | 1 |
| ANU | matrix | 0 | 22 | 0 | 0 | 0 | 22 |
| Melbourne | matrix | 0 | 2 | 0 | 0 | 0 | 2 |
| Adelaide University | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| Curtin University | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| Federation | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| Griffith University | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| Lincoln University | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| MIT (Manukau) | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| NMIT | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| Newcastle | matrix | 0 | 0 | 1 | 0 | 0 | 1 |
| Otago Polytechnic | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| UTS | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| UWA | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| VUW | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| Victoria University (VU) | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| WSU | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| Wintec | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| Wollongong | matrix | 0 | 1 | 0 | 0 | 0 | 1 |
| **All** | matrix | 0 | 39 | 1 | 0 | 0 | 40 |
| **All** | course | 45 | 377 | 72 | 5 | 0 | 499 |
| **All** | **both** | **45** | **416** | **73** | **5** | **0** | **539** |

### 4.2 Root-cause register (each fingerprint links every affected item and provider; item IDs are in the CSV)

| Fingerprint | Items | By class | Providers |
|---|---:|---|---|
| `E11-RMIT-LOCALVIEW` | 298 | B 236, C 62 | 1: RMIT |
| `CE-SCOREBASIS` | 258 | B 258 | 6: AUT, MIT (Manukau), Monash University, QUT, RMIT, University of Auckland |
| `CE-QUOTEMATCH` | 224 | B 224 | 9: AUT, Ara, EIT, MIT (Manukau), Monash University, QUT, RMIT, University of Auckland, VUW |
| `CE-ROWCAP` | 162 | B 162 | 8: AUT, Ara, EIT, MIT (Manukau), Monash University, QUT, RMIT, University of Auckland |
| `CE-SHAREDPAGE` | 81 | B 81 | 8: AUT, EIT, Lincoln University, Monash University, NMIT, QUT, RMIT, VUW |
| `E12-QUT-MIXED` | 38 | B 38 | 1: QUT |
| `MX-LADDER-ROLE` | 22 | B 22 | 1: ANU |
| `MX-ROWHASH` | 18 | B 18 | 5: ANU, Lincoln University, Melbourne, UWA, Victoria University (VU) |
| `CE-NONREQ-TEXT` | 18 | A 3, C 10, D 5 | 3: AUT, Monash University, VUW |
| `MX-GLOBAL-QUAL` | 10 | B 10 | 10: Adelaide University, Curtin University, Lincoln University, Otago Polytechnic, UTS, VUW, Victoria University (VU), WSU, Wintec, Wollongong |
| `MX-GRADE-QUOTE` | 6 | B 6 | 6: Federation, MIT (Manukau), Otago Polytechnic, UTS, WSU, Wintec |
| `CE-LOWCONF` | 6 | B 6 | 1: RMIT |
| `MX-QUOTEMATCH` | 5 | B 5 | 5: ANU, Federation, UTS, WSU, Wintec |
| `CE-AUDIENCE-DOMESTIC` | 4 | B 4 | 2: MIT (Manukau), Toi Ohomai |
| `CE-DUP-RECORD` | 4 | B 4 | 2: MIT (Manukau), Monash University |
| `MX-SCALE` | 3 | B 3 | 3: Federation, MIT (Manukau), Otago Polytechnic |
| `CE-POINTER-ROW` | 3 | A 3 | 1: AUT |
| `CE-ENGLISH-PHRASE` | 3 | A 2, B 1 | 3: AUT, MIT (Manukau), VUW |
| `MX-COLUMN-OMITTED` | 2 | B 2 | 2: ANU, Melbourne |
| `MX-NONCOUNTRY-SCOPE` | 2 | B 2 | 2: Griffith University, Wollongong |
| `MX-REGION` | 2 | B 2 | 2: MIT (Manukau), NMIT |
| `CE-OTHERPROG` | 2 | B 2 | 1: EIT |
| `MX-SUBDIVISION` | 1 | B 1 | 1: Curtin University |
| `MX-RENDER-EMPTY` | 1 | C 1 | 1: Newcastle |
| `MX-RANGE-VALUE` | 1 | B 1 | 1: UWA |
| `MX-LOWCONF` | 1 | B 1 | 1: Wollongong |

Fingerprint meanings:
- **CE-SCOREBASIS:** score dropped because the basis words are not inside the quote.
- **CE-QUOTEMATCH:** the AI quote is not found verbatim on the stored slice.
- **CE-ROWCAP:** rows past the six-row limit.
- **CE-SHAREDPAGE / CE-OTHERPROG:** combined page, or a row naming a sibling programme.
- **CE-LOWCONF:** confidence below `entry.min_confidence`.
- **CE-NONREQ-TEXT:** description, structure, progression, credit or document-list text read as a requirement.
- **CE-AUDIENCE-DOMESTIC:** a "domestic" quote stored as `all`.
- **CE-ENGLISH-PHRASE:** an English-proficiency row not filtered.
- **CE-POINTER-ROW:** "see entry requirements for your country" stored as a requirement.
- **CE-DUP-RECORD:** one stored copy serves two course records of the same title (MIT 4432 and MN4481; Monash Master of Advanced Finance 097641J and 112898K).
- **E11-RMIT-LOCALVIEW / E12-QUT-MIXED:** the decision-held provider sets.
- **MX-LADDER-ROLE:** ANU rank and score columns swapped, or the band stored as label text.
- **MX-ROWHASH:** `row_hash` leaves out course label, subject or value, so rows collide and D4 refuses approval.
- **MX-GLOBAL-QUAL / MX-REGION / MX-SUBDIVISION / MX-NONCOUNTRY-SCOPE:** a row with no ISO country (IB, GAC, A Levels, "Pacific Islands", Scotland, provider-wide rules) is dropped as `unknown_country`. This is a model gap, and D-A5 tables are its route.
- **MX-GRADE-QUOTE / MX-SCALE:** grade not in the quote, or a pass count with no scale.
- **MX-RANGE-VALUE:** a score range ("488 to 491") fails the value check.
- **MX-COLUMN-OMITTED:** one of two qualification columns not read.
- **MX-RENDER-EMPTY:** nothing read from a rendered page.

---

## 5. The 40 provider-matrix reviews

### 5.1 Ranked by impact and readiness

**None is approvable as it stands.** Every run has at least one defect that loses or misstates a published minimum, or that D4 would refuse. Readiness means how close the run is to approvable: how many shared fixes it needs. Impact means rows, countries and applicant markets.

| Rank | Item | Provider / source | Proposed rows (countries) | Dropped | Defects | Readiness | Note |
|---:|---|---|---:|---:|---|---|---|
| 1 | `fc687e13…` | Adelaide, undergraduate by country (PDF) | 27 (22) | 1 | MX-GLOBAL-QUAL | **Closest.** The only loss is the IB row, which the current model cannot store | Candidate for conditional admission (D-R1) |
| 2 | `cdb8ec0f…` | NMIT, international entry | 48 (25) | 2 | MX-REGION | **Closest.** Only "Pacific Islands" (a region) is lost | D-R1 |
| 3 | `dcf9300f…` | Melbourne, India State Boards (courses) | 9 (1) | 0 | MX-ROWHASH | One fix: 3 course pairs collide (Agriculture/Arts, Fine Arts/Music, Design/Science) | Content otherwise whole |
| 4 | `a0595bd2…` | **UWA**, international and overseas qualifications | 177 (15) | 8 | MX-RANGE-VALUE, MX-ROWHASH | Two fixes | §5.3 |
| 5 | `71f21b77…` | Victoria University, by country (PDF, "2026 intake") | 147 (24) | 6 | MX-ROWHASH (22 collisions), MX-GLOBAL-QUAL | Two fixes | High impact |
| 6 | `d01d7b4f…`, `e278c754…`, `7e66129d…` | ANU: ACT, Vietnam, HKDSE | 11, 10, 11 | 0 | MX-LADDER-ROLE (band stored as label text only) | One fix | §5.2 |
| 7 | `763ece39…` | WSU, entry qualifications v07 (PDF) | **367 (64)** | 25 | MX-GRADE-QUOTE (16 pathway rows), MX-GLOBAL-QUAL (IB, GAC), MX-QUOTEMATCH | Three fixes | **Highest impact** |
| 8 | `5cb14460…` | Wollongong | 220 (44) | 24 | MX-GLOBAL-QUAL (European Baccalaureate, A Levels), MX-NONCOUNTRY-SCOPE (AQF degree rows), MX-LOWCONF | Three fixes; 175 superseded rows sit in the same run | High impact |
| 9 | `f7c76d5d…` | Wintec | 135 (46) | 24 | MX-QUOTEMATCH (15), MX-GRADE-QUOTE, MX-GLOBAL-QUAL | Three fixes | 90 rows have no minimum (case by case) |
| 10 | `81d14690…` | Otago Polytechnic | 104 (61) | 30 | MX-GRADE-QUOTE (17), MX-SCALE (9 GCE pass counts), MX-GLOBAL-QUAL | Three fixes | |
| 11 | `e960bd2b…` | Lincoln, international undergraduate | 71 (40) | 9 | MX-GLOBAL-QUAL (IB, AP, Cambridge), MX-ROWHASH (5) | Two fixes | |
| 12 | `5e718b20…` | Federation (PDF) | 69 (52) | 7 | MX-QUOTEMATCH, MX-SCALE, MX-GRADE-QUOTE | Three fixes | |
| 13 | `040d7b41…` | MIT (Manukau) | 68 (41) | 8 | MX-GRADE-QUOTE, MX-REGION, MX-SCALE | Three fixes | |
| 14 | `9f87d125…` | UTS | 41 (39) | 5 | MX-GLOBAL-QUAL, MX-GRADE-QUOTE, MX-QUOTEMATCH | Three fixes | |
| 15 | `060cfa14…` | Curtin 2026 (PDF) | 33 (27) | 3 | MX-GLOBAL-QUAL (IB "Any"), MX-SUBDIVISION (Scotland), NZ band | Three fixes | |
| 16 | 18 ANU runs | ANU, other qualifications | 7–14 each | 0–1 | MX-LADDER-ROLE (rank stored as minimum), mostly with MX-ROWHASH | One shared fix | §5.2 |
| 17 | `261f23b6…` | Melbourne, India CBSE and ISC | 9 (1) | 0 | MX-COLUMN-OMITTED, MX-ROWHASH | Two fixes | |
| 18 | `f6941f3d…` | VUW, international entry (rendered), **0 rows** | 0 | 4 | MX-GLOBAL-QUAL | Not a no-table page | §5.4 |
| 19 | `a0e19f74…` | Griffith, understanding entry requirements (rendered), **0 rows** | 0 | 4 | MX-NONCOUNTRY-SCOPE | Not a no-table page | §5.4 |
| 20 | `5aa58072…` | Newcastle, entry requirements by country (rendered), **0 rows** | 0 | 0 | MX-RENDER-EMPTY | **C**: evidence needed | §5.4 |

The new decision **D-R1** (§9) would let ranks 1–2 go to Layer 4 now as Approve. The dropped global or region rows cannot be represented until the D-A5 tables exist, so leaving the run waiting does not make the run more complete.

### 5.2 ANU — 22 qualification reviews, assessed one at a time

ANU publishes one page for each qualification. Each page is a ladder: ANU's "Program Required Entrance Rank" against that qualification's "Indicative score required".

The approved precedent is ANU China Gao Kao, which has 11 active rows: **minimum = the qualification's score** (for example 341, points) and **band = the ANU rank** (for example 82).

The pending runs store this inconsistently:

| Item | Qualification | Rows | Orientation | Other | Verdict |
|---|---|---:|---|---|---|
| `d01d7b4f…` | USA ACT | 11 | correct (min = ACT score) | band is the text "ANU Entrance Rank: 70" | B: normalise band |
| `e278c754…` | Vietnam Upper Secondary | 10 | correct (GPA /10) | band text; 10 rows against 11 ranks (check rank 70) | B |
| `7e66129d…` | Hong Kong HKDSE | 11 | correct | band text; no study level on any row | B |
| `c5dbff45…` | Advanced Placement | 14 | correct (aggregate) | band = 3-subject rank only; 4-subject rank column not read | B (+COLUMN-OMITTED) |
| `daae933c…` | India CBSE | 11 | **inverted** (rank 70–99 stored as minimum, scale `rank`) | 1 collision | B |
| `36a9abd7…` | India ISC | 11 | inverted | band "Indicative score required: 77"; 2 collisions | B |
| `4f6d54ad…` | Singapore A Levels | 12 | inverted ("ANU Entrance Rank" as min, scale points) | 2 collisions | B |
| `726b51d7…` | Canada Ontario OSSD | 11 | inverted | band text | B |
| `b79ab7db…` | Canada British Columbia | 11 | inverted | 1 collision | B |
| `7e5bcc2e…` | Canada Alberta | 11 | inverted (min "70", band 338) | — | B |
| `a8f7825c…` | Canada Manitoba | 11 | inverted | band text; 1 collision | B |
| `2d021379…` | Canada New Brunswick | 11 | inverted | band text; 1 collision | B |
| `4effa6fd…` | Canada Newfoundland | 11 | inverted | 1 collision | B |
| `e615509e…` | Canada Nova Scotia | 11 | inverted | 1 collision | B |
| `e537afa9…` | Canada Quebec DEC | 11 | inverted | band text; 1 collision | B |
| `ea9d17c9…` | Canada Saskatchewan | 11 | inverted | band text; 1 collision | B |
| `cad93a9a…` | Belgium Certificate of Access | 11 | inverted | 4 collisions | B |
| `02bc7d80…` | Belgian upper secondary | 11 | inverted; **qualification name stored as "Program Required Entrance Rank: 70"** (11 different names) | — | B |
| `11e999c9…` | Bulgarian Diploma | 11 | inverted | 2 collisions | B |
| `d7eedd9f…` | Czech Maturita | 11 | inverted | 2 collisions | B |
| `2b491c25…` | Croatian Matura | 7 | inverted | 1 row dropped (quote_not_on_page) | B |
| `987dac71…` | Bosnia and Herzegovina | 5 | inverted (rank as `percentage`) | 5 rows against an 11-step ladder | B |

**ANU verdict:** 0 of 22 is approvable. All 22 share one reader defect: a ladder table's column roles are assigned by the AI each time instead of from the column headings. The collisions come from the same defect, because with the score held in the band, `row_hash` sees the same band twice.

One fix applies to all 22: assign roles from the headings ("Program Required Entrance Rank" and "ANU Entrance Rank" give the band, a number; "Indicative score required" gives the minimum on the qualification's scale), following the China precedent. A stored-copy re-read follows (no page fetch). At the measured matrix cost of about US$0.016 a run (100 runs, US$1.59), that is about **US$0.35** for all 22, inside D-A3's US$2/day.

By applicant volume, take India CBSE and ISC, Vietnam, HKDSE, Singapore and ACT first. Each qualification keeps its own published scope. Approving one does not stand for an ANU provider-wide policy.

### 5.3 UWA — full reconciliation (`a0595bd2-740a-48fd-bb88-596749e6727c`)

- **Layer 4:** `entry_matrix_first_run`, **pending** since 29 Oct. One run, `4edb1e9f-fafc-4e05-88a0-c11bf13f2da8` (done; created 28 Oct). One source, `74306034…` ("UWA: international and overseas qualifications", status `read`, read direct). Stored copy `5a1824fd-8fc0-4276-b3de-6fb5b560f4e3`. The run hash `b2d394b529…` equals the source hash, so there is no newer copy.
- **Rows:** 177 proposed: 170 `band_ladder` and 7 `provider_minimum`. A further 59 are `superseded` in the **same run**: 9 from the 29 Oct 09:57 programme batch and 50 from the 29 Oct 12:23 B1 batch, both earlier passes replaced by this one. UWA has **no active, inactive or unverified rows** and no other run or source.
- **Dropped (8):** all 8 are **China (CN) Gaokao** ladder rows, `value_not_in_quote`. The quotes print score ranges, for example "488 to 491 | 65% | 70" and "675 to 689 | 90% | 98". China is therefore **absent** from the proposed set. This is a material omission: China is a top source market.
- **Duplicates:** one collision group of **7 rows**, the US College Board AP subject equivalents (English, Literature, Calculus AB and BC, Chemistry, Physics, Biology; each "3 or higher"). They share one `row_hash` because the subject is not part of the identity. Under D4, "two approved rows with the same identity" holds the whole decision.
- **Grading scales:** points 170, letter 7. No value without a scale, as the table constraint requires.
- **Country coverage (15):** US 31, GB 19, MY 18, IN 16, SG 10, IE 9, KE 9, SE 9, ZA 9, DE 8, FR 8, HK 8, ID 8, NO 8, CA 7. CN is missing (dropped). No qualification-only rows (for example IB) appear in either the proposed or the dropped set. Whether the page publishes one cannot be checked without the stored text, and the reviewer should check it.
- **Edition:** `result.edition` is null. Decision 8's edition check does not exist (Phase A §7.1), so nothing would flag a later edition.

**UWA verdict: B, not approvable.** It needs two shared fixes:
- R13: accept a printed range by its lower bound, keeping the range text;
- R10: add the subject or course label to the row identity.

Then a stored-copy re-read (about US$0.02) and a fresh first-run review. Approve except is not a fix: leaving out the AP rows still leaves China missing, which fails whole-run completeness (playbook §3.1).

### 5.4 Zero-row reviews — is "no matrix published" proven?

**None of the three is proven.** None may be approved as a "no matrix published here" note.

| Item | Provider | What the read shows | Verdict |
|---|---|---|---|
| `f6941f3d…` | VUW (rendered) | 4 rows read and dropped as `unknown_country`: "IB Diploma: minimum 24 points", IAD (three GCE A-Level passes), BTEC Level 3 National Extended, CAIE A and AS Levels | The page **does** publish global-qualification minima. B (MX-GLOBAL-QUAL) → D-A5 qualification tables |
| `a0e19f74…` | Griffith (rendered) | 4 provider-wide rules read and dropped (standard undergraduate entry, PhD, MPhil, coursework masters) | The page publishes provider-wide minima with no country. B (MX-NONCOUNTRY-SCOPE) |
| `5aa58072…` | Newcastle (rendered, "entry requirements by country") | 0 rows, 0 drops | The title says "by country". A selector loaded by script would leave the rendered copy empty. C: open the stored copy (no AI). If the table is missing, a targeted render needs fetch authority (D-A3 covers stored copies only) |

---

## 6. RMIT (E11) and QUT (E12)

### 6.1 RMIT — 298 pending course reads

- **Source identity:** all 298 are bound to RMIT course pages under `study-with-us/levels-of-study/…`. 294 URLs carry no international marker, and 4 are courses whose own title contains "international". **None comes from an international-student view**, which bears out E11's premise.
- **Readiness:**
  - **B 236**: row cap 94, score basis 171, quote match 114, low confidence 6, shared page 56 (overlapping);
  - **C 62**: no reader defect, but held by E11. Whether the stored local-view copy carries the international section is unproven.
  - **A 0**. Nothing is recommended for rejection.
- **Audience:** 135 reads carry domestic rows (143 ATAR rows correctly stored as domestic). 101 carry rows stored as international. **9 rows that quote ATAR or selection rank are not stored as domestic**, because "international" wins in the audience rule. Their IDs were not listed: the item-keyed RMIT row look-up passed the 8 s limit and was not retried larger. They must not be admitted as international rules (G4, R5).
- **E14 protection:** none of the 18 E14 courses (105 rows withdrawn on 2 Nov, now `inactive`) has a pending read, and no pending RMIT course has an active row. Approving a pending RMIT read could therefore neither supersede nor re-activate an E14 row. Approval acts only on rows carrying the item's own `review_item_id`, and E14 rows belong to the 18 approved 1 Nov items.
  - Standing control: before any future re-read of an E14 course is approved, the reviewer checks that no proposed row reproduces a withdrawn quote, whether a sibling-variant row or a cut "and"/"plus" condition. E13's variant and joined checks now catch both shapes.
- **Global IB and GAC:** these are not in the course reads. They sit in RMIT's 7 held matrix sources (no RMIT matrix item is pending). D-A2 approves their stored-copy re-read once reader fixes C2 and C3 are released.
- **Route:**
  1. E11 investigation with no AI: a text check of the stored copies for the international section. This turns C items into B (re-read) or A (complete).
  2. One bounded stored-copy pilot after **D-A4** records the ceiling. Phase A estimates about US$2.45 for all 298. At D-A3's US$2/day, the full run spans at least 2 days.
  3. The measured full run goes for approval. **No bulk reject.**

### 6.2 QUT — 38 pending course reads

- Every one is **B** with the same four fingerprints:
  - row cap, 38 of 38 (2,388 cut rows; 3,884 dropped rows in all, about 102 an item);
  - score basis, 38;
  - quote match, 38;
  - E12 mixed audience;
  - 9 are also on shared pages.
- **Domestic and international are mixed in every read:** 36 carry domestic rows (90 ATAR rows, correctly stored as domestic) and 27 carry international rows.
- Under E12 none of the existing reads is approved. They are not rejected in bulk either. They are replaced, once the international-only pilot proves itself:
  - 5 courses read from the stored `requirements-international` content, about US$0.05, **after D-A4 records the ceiling**;
  - the pilot shows no domestic ATAR or guaranteed-offer rows, explicit scales, no cap loss, and complete proposed-or-dropped accounting;
  - then supersede through D-R2.

---

## 7. Class A — individual recommendations (45 course reads)

Each item below:
- is pending;
- is on its own stored copy (the evidence id), with every proposed quote proven on that copy by the reader;
- has course identity from CRICOS, NZQA code or manual binding;
- has no row cut, no other-programme row and no shared page (as at 17:57);
- has no score, quote or low-confidence drop (`english_duplicate` drops are correct exclusions);
- has no active row on the course, so there is no D4 or supersede conflict;
- was read row by row in this assessment.

**Before saving each decision, the Platform Admin (rank 6 under A3) checks:**
1. The item is still pending, with no newer read or decision.
2. The `completeness_gate` on the review screen still says "Read whole". Bindings moved during this assessment.
3. The stored copy shows **no published entry requirement missing** from the rows. This is the one check this assessment could not make.
4. Audience and level are right.
5. The exclusions below, if any.

Then save one decision, confirm it persisted, check the destination rows are `active`, and check consumer resolution (note: all 201 non-RMIT pending courses had `publication_status = unpublished` at 16:57, so an admission may not be consumer-visible until the course is published). Record the audit reference.

| # | Item | Provider | Course | Action (existing Layer 4 set) | Evidence (stored copy) | What the reviewer must check |
|---:|---|---|---|---|---|---|
| 1 | `31e62705-57b1-4fc4-b9eb-7a58e8291087` | AUT | AK1008 Bachelor of Laws (Level 7) | **approve_except** | `fae9eb3a-99fa-45a2-a35a-c117e35f0a2b` | exclude 57db0b7e-fe3b-45a8-8276-bc2075b6582a (pointer row); check the Part I/Part II B-average rules are entry (not progression) wording |
| 2 | `cdcc71f7-1326-4d4b-ae2d-480eccea731f` | AUT | AK1011 Diploma in Paramedic Science (Level 6) | **approve** | `63e3ac43-4d67-4d0f-8c6c-0397bf63c6d4` | Year 12, selection preference, age, licence, HPCA rows |
| 3 | `3862fc80-3a68-4f09-ab93-d57918e14ded` | AUT | AK1037 Master of Science (Research) (Level 9) | **approve** | `754eea46-0ea2-4e27-99a8-435902a121d1` | B average route (two rows share one quote: check not double-counted) |
| 4 | `f14a633b-ce92-48ac-bb27-206ddbb39511` | AUT | AK1046 Postgraduate Diploma in Marketing (Level 8) | **approve_except** | `bd1db9e8-b1a6-4958-8dce-47acc1af3af2` | exclude 3de8b0df-6e3d-44a8-b4fd-0f9fdbaf1001 (pointer to country page); admit bachelor degree row; page no longer shared at 17:58 (was shared at 17:16): re-check the E13 gate at decision |
| 5 | `477cad25-13ec-4c87-9671-e1aaf7808ed1` | AUT | AK1073 Postgraduate Diploma in Teaching and Learning (L | **approve_except** | `f88241de-08a8-48c8-bb4f-eef22d6f75d4` | exclude f1dd8158-6c3b-4a92-9fb3-1b3feb796bcb (marketing question); admit B average bachelor row |
| 6 | `3bc602fe-66a9-4303-85c6-7ab673f0bdbc` | AUT | AK1324 Master of Cyber Security and Digital Forensics ( | **approve** | `34647cc1-bac2-4825-aa78-f191cb8fd41a` | BCIS or equivalent with B average, interview rows |
| 7 | `4eb01d5e-fe66-4523-8d11-57e4387c3109` | AUT | AK1328 Master of Design (Level 9) | **approve** | `3eb66d35-4d93-4eaf-acc1-ded4bf547648` | BDes or equivalent with B average, portfolio, exceptional-entry rows |
| 8 | `b6b6c5f7-c6e2-405f-ac57-f15f17a7a74d` | AUT | AK1350 Master of Architectural Design Management (Level | **approve_except** | `d0f5339c-5f4f-45db-a933-995cfdb00c81` | exclude 30b95bce-6b63-4232-8bcf-bd7d1e9977d3 (marketing text); admit B average and degree routes |
| 9 | `e0944462-2cd5-4f80-bad9-d041cf6d5c9a` | AUT | AK3006 Bachelor of Arts (NZSL-English Interpreting) (Le | **approve_except** | `bf740092-1e08-4767-8b72-35982848b07d` | exclude 18d8da24-659f-4d68-bf53-02e076d08ab7 (English competency note); admit B average Year 1 and UE (domestic) rows |
| 10 | `bae253c6-da27-4907-820f-21163356931b` | AUT | AK3487 Postgraduate Diploma in Health Science (Level 8) | **approve** | `0c9fdf8e-8414-471d-bfa0-c667cdde4fd8` | BHSc or equivalent, practice evidence, PHTY801 experience rows |
| 11 | `5071da0b-4136-4ff6-b62b-35cdf300f387` | AUT | AK3518 Doctor Of Philosophy (Level 10) | **approve** | `7dff3798-7fe6-41a4-bc86-77929ddcfaec` | degree in specialisation, supervision, portfolio, subject evidence rows |
| 12 | `64b85f05-1583-497b-966b-009a81610461` | AUT | AK3557 Postgraduate Certificate in Advanced Nursing Pra | **approve** | `6d89a0d7-3e94-459f-9135-593f6cc7a6fe` | degree, current practice, HPCA rows |
| 13 | `e77bfc3d-2438-45fe-9aaf-d63fc5a3b881` | AUT | AK3558 Postgraduate Diploma in Registered Nurse Prescri | **approve** | `61ca09ae-e833-4534-b85c-80a655a6eeb4` | six rows (degree, RN, three years practice, employer, team); six rows with no cut recorded |
| 14 | `fb4366c8-298b-4a7a-a8e6-d9d51d33fb7b` | AUT | AK3685 Doctor of Education (Level 10) | **approve_except** | `5876bb1f-b54f-49c5-930d-a9ff1bacf9f9` | exclude d82ed395-9a4b-4a7a-88b6-20e05232e5d8 (document list); check the two work_experience rows are the same two-year rule |
| 15 | `694b4b64-84c9-4987-b0f3-d1c294664c7b` | AUT | AK3693 Bachelor of Business (Level 7) | **approve_except** | `5f176d33-943e-4a6b-ba3b-fe54db0205b9` | exclude 4ea0fd12-ea7c-4a74-acd0-592cb08ab7fa (pointer to country page, not a requirement); admit UE (domestic) row |
| 16 | `3a41cf6a-c1a3-43f7-a1a7-070e824abc0b` | AUT | AK3726 Bachelor of Health Science and Bachelor of Busin | **approve** | `96fcaa65-087c-491f-80f9-f977d847ceb8` | UE (domestic), interview, HPCA fitness rows |
| 17 | `323f8441-801a-452a-8e4f-502ae768f9f3` | AUT | AK3747 Postgraduate Diploma in International Hospitalit | **approve** | `b1ce56c9-d4de-4d2d-9fe3-cae27985fdc1` | B average (international), portfolio, professional route; check the international audience wording |
| 18 | `79125c2c-4a00-4d31-9df1-694cb8ccfe3c` | AUT | AK3805 Master of Public Health (Level 9) | **approve** | `02d3741d-a9e6-4b69-b1e4-8d687a9b713c` | B average degree and professional-qualification routes |
| 19 | `253454d3-5ab3-444c-bd09-d5e3bea1b0c6` | AUT | AK3830 Master of Nursing Science (Level 9) | **approve** | `a55abf4e-c6d4-44b9-a8d4-2321462f3c60` | six rows (degree, interview, placements, CA 2018, immunisation); six rows with no cut recorded |
| 20 | `5370e7ea-71cf-423e-9c2b-dc1b0d21f451` | AUT | AK3920 Master of Psychotherapy (Level 9) | **approve** | `20f6e900-adc5-4d2f-abe7-c731fc56dce8` | GradDip Psychotherapy Studies or equivalent, suitability, references rows |
| 21 | `deeb3046-984d-49f2-8aa9-a162219005c0` | Ara | CH3900 Bachelor of Architectural Studies (Level 7) | **approve** | `49115fc6-8854-415a-9448-78ad87ba9f06` | UE and NCEA L3 subjects (domestic), Level 4 certificate, portfolio, equivalent-skills rows |
| 22 | `c5948bc5-e6ff-48f0-814f-74f9de81cb55` | EIT | 2790 New Zealand Certificate in Ng&#257; Toi (Level 4) | **approve** | `68c7d969-4118-42b7-b81e-a4d0584bfa49` | NCEA (domestic), interview, mature-student rows |
| 23 | `f51ecb48-4371-4de6-9839-74f26f114b91` | EIT | 2791 New Zealand Diploma in Ng&#257; Toi (Level 5) | **approve** | `e0ea2093-9211-4177-b52d-5c11d6bc3f70` | UE (domestic), fluency, potential, interview rows; check fluency row is te reo (not English) |
| 24 | `aecfac4d-5c06-4c99-a2d5-cdb685416cac` | EIT | 2964 New Zealand Diploma in Environmental Management (L | **approve** | `da219102-c78b-42e1-be52-92bd657aef37` | Level 3 certificate, equivalent evidence, mature route rows |
| 25 | `a04d8624-94f9-441c-8cc2-863566c81e65` | Lincoln University | LI0092 Bachelor of Science (Honours) (Level 8) | **approve** | `301616d4-3ef2-4e38-ac41-baeb347fee99` | B+ in 300-level row and programme row |
| 26 | `63532617-34b3-4404-bda7-1359854b8437` | Lincoln University | LI0121 Bachelor of Commerce (Honours) (Level 8) | **approve** | `92b63f61-b0b3-4058-b6e4-74b6931a5628` | approved degree with B+ in 300-level row |
| 27 | `0d99e0eb-6449-462f-b6fe-7a1605c0acf1` | Lincoln University | LI6540 Postgraduate Certificate in Parks, Recreation an | **approve** | `f92f0b07-4455-4d36-b00a-e377cc0b5898` | NZ level 7 bachelor's or recognised equivalent row |
| 28 | `a8f1a0fb-734c-4bad-9b22-f2c2454ab11d` | MIT (Manukau) | 2851 New Zealand Diploma in Early Childhood Education a | **approve** | `5860759f-8dd9-47b0-8685-4a94049ac9be` | six rows (NCEA L2 domestic, over-20 route, interview, referees, police check, photo); English row correctly dropped |
| 29 | `eb049aa8-9faa-4431-81e0-b179988da0b2` | Monash University | 0100208 Graduate Certificate of Strategic Communication | **approve** | `bfd9e2ea-47d5-4d8a-9d35-ec60aa529652` | bachelor 50% plus/or three years experience; check and/or wording |
| 30 | `2bb8e020-3c8e-423a-b2bb-c17a73b1128b` | Monash University | 0100210 Graduate Certificate of International Developme | **approve** | `b669d20d-3a57-4e38-9a9e-bdebda8c18cc` | bachelor 50% average row; check the work_experience row is an alternative route |
| 31 | `e85887fd-f9de-48c4-b9d7-c57b9b6ad500` | Monash University | 0100364 Graduate Certificate of Journalism | **approve** | `cc596437-e798-400f-88af-45a5a276946f` | bachelor 50% plus/or three years experience; check and/or wording |
| 32 | `8f1d7b6f-072e-424f-8e8e-a3aec237d64e` | Monash University | 072592G Bachelor of Nursing (Honours) | **approve** | `3ba94273-9f91-473a-9567-4cc658bd6438` | BNursing with distinction (70) average row |
| 33 | `01ee7de6-7782-4842-93e7-f0927dca013e` | Monash University | 097657A Graduate Certificate of International Relations | **approve** | `49245403-456b-47c2-ae07-881a8f98fa1e` | bachelor 50% plus/or three years experience; check and/or wording |
| 34 | `aec2e869-711a-4afd-be7c-f19d5dff224d` | Monash University | 097658M Graduate Certificate of Communications and Medi | **approve** | `5a86b5e3-1d69-4114-b0a1-4bbf2a81235d` | bachelor 50% average row; check the work_experience row is an alternative route |
| 35 | `d3791e23-3678-41a5-bc7d-62861b76c4a0` | Monash University | 111516D Master of Public Policy (Double Masters with O. | **approve** | `628f7ae6-6c0b-48af-af1a-65b4fca5596c` | three degree routes (60%/50%/60%) and CV row |
| 36 | `c3829792-7136-4fab-bec2-366d47ded0a3` | Monash University | 113907F Master of Transport and Mobility Planning | **approve** | `9c2a55be-2e4b-4cac-9675-5e3d14079940` | honours degree 65% (two disciplines) and three years experience rows |
| 37 | `22fcb862-5a4c-4957-a5b8-dc75cd542dff` | University of Otago | OO0488 Bachelor of Social Work with Honours (Level 8) | **approve** | `ddf559c2-f62a-4bf8-833c-0cb2796675d0` | honours selection by invitation and grade rows |
| 38 | `cea52e4b-292c-4fed-944a-03f50e99cac2` | VUW | VI0012 Bachelor of Arts with Honours (Level 8) | **approve_except** | `50285f67-f7b7-4cd8-8b24-9168a8be9daf` | exclude 98d95f61-1a78-420d-b83a-fea1c8f2f5cc (English proficiency note); admit advanced-level entry row |
| 39 | `82f40ced-5681-4b15-8f12-ebba81683fa9` | VUW | VI003Q Doctor of Health (Level 10) | **approve** | `ed809c79-3a3c-4937-b345-ba604a0d1f70` | honours/master's, five years experience, NZ citizens and residents only (override); check override audience |
| 40 | `0242c08a-3cd4-4b3d-b80e-971752eb84b6` | VUW | VI004X Master of Actuarial Science (Level 9) | **approve** | `fb77676b-37d6-47a9-aa84-e762e0e94e57` | appropriate bachelor's with actuarial/finance major row |
| 41 | `290cd1eb-52b4-4a07-bebf-b7f1f158eac8` | VUW | VI005H Postgraduate Diploma in Linguistics (Level 8) | **approve** | `b2fdc9a0-dcbf-420a-9d40-086494fae8ec` | LALS 401 B+ and related-degree rows; check the page is the PGDip page (same text as 4cf1e3bb) |
| 42 | `4cf1e3bb-3e15-4554-8578-44f1bb5d9a3c` | VUW | VI005I Postgraduate Certificate in Linguistics (Level 8 | **approve** | `606a0a20-b047-4741-b8f6-9425b1c36414` | LALS 401 B+ and related-degree rows; check the page is the PGCert page (same text as 290cd1eb) |
| 43 | `f432f4e5-b6ac-441c-996e-de65b149dc04` | VUW | VI006M Postgraduate Diploma in Construction and Buildin | **approve** | `c638e06a-3694-484d-9aaa-d440e0f964a1` | two named courses, waiver, work-experience rows |
| 44 | `cf6ac55c-8e38-4e73-aa67-d19337e4e4df` | VUW | VI00U9 Master of Engineering (Level 9) | **approve** | `032c7075-7227-4423-a9c2-541d3962529f` | BE(Hons) First or Second Class row |
| 45 | `a42352e7-13a5-4da7-a69f-739af1877457` | VUW | VI00W8 Master of Musical Arts (Level 9) | **approve** | `51af1f51-3286-4f27-8246-119c0a6bdc0a` | BMus(Hons)/PGDip route and audition rows |

The other 454 items are not recommended for a decision now. Their recommendation in the CSV is "hold", with the fix route, except the 5 D items below.

### 7.1 Classes C and D outside RMIT (recommendations for the reviewer)

| Item | Provider | Course | Class | Recommendation |
|---|---|---|---|---|
| `b84094d1-5d12-456e-899f-533f3da71dbc` | Monash University | 076844E Bachelor of Mining Engineering (Honours) | C | hold for evidence: only a VCE-alternative note (domestic); main prerequisites and international entry not captured |
| `664d3d3c-8cf9-4065-8f3a-1c93bbef5621` | Monash University | 079584G Master of Cultural Economy | C | hold for evidence: rows are course structure and credit text |
| `7433c450-e02c-454a-bcab-3818c01c0868` | Monash University | 082361G Bachelor of Education (Honours) and Bachelor of | C | hold for evidence: only row is LANTITE (accreditation standard); academic entry not captured; check stored page entry section |
| `5e8a773b-fe6d-4124-bbeb-6c9301a7aa69` | Monash University | 082364D Bachelor of Education (Honours) and Bachelor of | C | hold for evidence: only row is LANTITE; academic entry not captured |
| `f39ee29a-f77e-4662-867d-6e2b4709b84b` | Monash University | 082366B Bachelor of Education (Honours) and Bachelor of | C | hold for evidence: only row is LANTITE; academic entry not captured |
| `965fd3ec-de6d-4acb-a4c1-94ef02c1a51c` | Monash University | 082368M Bachelor of Education (Honours) and Bachelor of | C | hold for evidence: only row is LANTITE; academic entry not captured |
| `ea748318-d2b2-4e03-9d29-f1ff34717493` | Monash University | 085538G Master of Networks and Security | C | hold for evidence: research-unit progression and credit rule, not entry |
| `d93dfe41-1df6-464d-a213-ce72e08e32a1` | Monash University | 087954G Master of Applied Economics and Econometrics | C | hold for evidence: row is a credit rule, not the entry minimum |
| `368d2c4f-88b8-4a4f-a20d-fe5f4b7ff136` | Monash University | 089709E Bachelor of Pharmacy (Honours) and Master of Ph | C | hold for evidence: rows are stage progression rules, not entry |
| `3196cf12-e6d2-42a0-b642-bba01b74ec9a` | VUW | VI00V7 Postgraduate Diploma in Information Studies (Lev | C | hold for evidence: only the waiver clause captured; the entry qualification is missing |
| `4c5a4d97-73c0-483a-80f3-efd644f3642e` | Monash University | 0101963 Master of Green and Sustainable Technologies | D | reject (unrelated content, whole read): only row is course description text |
| `6feccbcf-288c-42d0-a6e2-c1c41b06211c` | Monash University | 0101964 Master of Project Leadership | D | reject (unrelated content, whole read): only row is course description text |
| `1ee33f6e-c36f-48cc-99ae-9d00a0adbbf9` | Monash University | 084615G Master of Advanced Health Care Practice | D | reject (unrelated content, whole read): only row is course description text |
| `ce3eb2bd-cbba-4a9b-a3f0-6ca600d78638` | Monash University | 096444M Bachelor of Design (Honours) | D | reject (unrelated content, whole read): only row is course description text |
| `b38e6099-6802-4212-82ee-0256633e8062` | Monash University | 112791K Master of Legal Studies | D | reject (unrelated content, whole read): only row is course description text |

D items are recommended for **reject** with the recorded reason "unrelated content: the whole read is course-description text, not an entry requirement". The course then has no read waiting and can be re-read once R7 is released. This removes nothing active.

---

## 8. Reader defects to fix (shared, reusable, not per university)

| # | Defect (fingerprint) | Fix (reusable) | Route | Unblocks |
|---|---|---|---|---|
| R1 | Row cap (CE-ROWCAP) | E13 already holds these. Recovery: per-provider limit in `entry.max_rows_by_provider` with a reason (allowed by E13), then a stored-copy re-read. Pending items are pre-E13, so their cut rows lack score fields and cannot be rebuilt without a read | Settings + D-A3 stored-copy reads | 162 (124 with it as primary cause) |
| R2 | Score basis (CE-SCOREBASIS) | Let the basis be met by the printed table heading or label next to the number on the stored page (table context, like the matrix `headerBand`), still printed and never inferred. Shared by course and matrix readers | Reader PR (decision entry first) | 258 (123 primary) |
| R3 | Quote match (CE-QUOTEMATCH, MX-QUOTEMATCH) | Ordered-fragment matching (each fragment on the page, in order, inside one segment), as the matrix `segmentCheck` does. Keeps quote-on-page | Reader PR | 224 course + 5 matrix |
| R4 | Combined pages (CE-SHAREDPAGE, CE-OTHERPROG) | Read only the section headed by the course's own title or award; drop the other sections before AI. Speed up the gate: filter rows by item before calling `course_entry_variant_v1` | Reader + gate PR (E13 scope) | 81 (+2) |
| R5 | Audience (CE-AUDIENCE-DOMESTIC; ATAR stored as international) | "domestic" maps to domestic. A quote naming ATAR, VCE or selection rank is never stored as international. The words become a setting | Reader PR | 5 rows / 4 B items; 9 RMIT rows |
| R6 | English filter (CE-ENGLISH-PHRASE) | Add the missing phrasings; the word list becomes a setting | Reader PR | 3 rows |
| R7 | Non-requirement text (CE-NONREQ-TEXT) | Prompt and validator: a row must state a condition of admission. Progression, credit, course-structure and document-list text is dropped and named. A page with no entry section is reported as "no entry section on stored page" (C), not proposed | Reader PR | 15 C/D, plus 3 A exclusions |
| R8 | Pointer rows (CE-POINTER-ROW) | Drop pointer-only rows ("see … for your country") and record a link to the provider matrix | Reader PR | 3 A exclusions |
| R9 | Ladder roles (MX-LADDER-ROLE) | Column roles from the headings; the band is a number (China precedent) | Matrix reader PR | 22 ANU |
| R10 | Row identity (MX-ROWHASH) | Add course label or subject to `row_hash` (additive; D4 matching must be re-tested) | Migration + matrix reader (design note first) | 18 runs (ANU 13, VU, Lincoln, Melbourne 2, UWA) |
| R11 | Global, region, subdivision and provider-wide scope (MX-GLOBAL-QUAL, -REGION, -SUBDIVISION, -NONCOUNTRY-SCOPE) | D-A5 tables (C1/C2 in Phase A §5); qualification and provider-wide rows become recognition rows, never synthetic countries | Approved (D-A5); build | 15 runs, including the VUW and Griffith zero-row pages |
| R12 | Pass counts and grade quotes (MX-SCALE, MX-GRADE-QUOTE) | A `passes` scale (a count, never a grade) as a setting; grade checks accept the printed cell when the whole row is quoted | Matrix reader PR | 9 runs |
| R13 | Score ranges (MX-RANGE-VALUE) | Accept the lower bound of a printed range and keep the range text | Matrix reader PR | UWA (China, 8 rows) |
| R14 | Two-qualification columns (MX-COLUMN-OMITTED) | Column manifest for ladder and course tables (extend `manifest-v1` beyond RMIT's table shape) | Matrix reader PR | ANU AP, Melbourne CBSE/ISC |
| R15 | Matrix completeness (G2) | A completeness gate for all first runs: published minus proposed minus excluded must be zero | Needs D-R3 | 40 runs |
| R16 | Course-read supersede (D-R2) | Governed supersede of a pending course read by a corrected stored-copy read (the course counterpart of W28) | Needs D-R2 | Every B course read |
| R17 | Stored-copy evidence check (E11, MX-RENDER-EMPTY) | A text search of stored copies with no AI (international section, entry section, table present), recorded per item | Worker mode, no AI | RMIT 62 C, Newcastle, Monash C |

None of these needs a global cap raise, new page fetches or unbounded AI. The re-reads they enable are stored-copy reads under D-A3 (US$2/day, inside the US$14/day platform total).

---

## 9. Approval and cost gates still open

| Gate | What it blocks | Status |
|---|---|---|
| **D-A4** record the E11 and E12 cost ceilings | RMIT pilot (Phase A estimate about US$2.45 for 298 stored-copy reads) and QUT 5-course pilot (about US$0.05) | Open since 05:18 |
| **D-R1 (new)** may a matrix run whose only loss is rows the current model cannot store (global, region) be approved now, with the loss recorded, ahead of the D-A5 tables? | Adelaide `fc687e13…` (IB only) and NMIT `cdb8ec0f…` (Pacific Islands only). The same question will arise for every run once R2, R3, R9, R10, R12 and R13 land | **A judgement call for the Platform Admin.** The recommended answer is yes, recorded as a named exclusion. Re-entry comes through the recognition tables, not by re-reading |
| **D-R2 (new)** governed supersede of a pending course read by a corrected re-read | Recovery of all 377 B course reads without rejecting them only to clear the queue | Design decision needed before code |
| **D-R3 (new)** completeness gate for matrix first runs (E13 covers course reads only) | Safe approval of any of the 40 runs | Decision entry needed: E13's approval names course reads |
| **D-A3** stored-copy re-reads, US$2/day | Throughput: the full RMIT run spans at least 2 days | Approved; ceiling unchanged |
| Fetch authority for Newcastle | A new rendered fetch, if the stored copy has no table | D-A3 covers stored copies only; a new fetch needs approval |
| **D-A6** (G3) | Any consumer qualification filter or new key (global qualifications) | Open |
| **D-A7** | Monday 08:00 report destination | Open |
| Layer 4 execution authority | The 45 A and 5 D decisions | AER decisions are rank 6 (A3). This assessment saves none, and no explicit authority for Claude to decide AER items exists |
| Production-write presence | Any data write (none proposed here) | Platform Admin present for database-tool writes (14:50 record) |

**Not performed:** no decision, write, re-read, AI or Firecrawl; no edge-function or consumer call. All figures are point-in-time (16:43–18:07). The shared-page set was moving during the session, so re-read the gate at decision time.
