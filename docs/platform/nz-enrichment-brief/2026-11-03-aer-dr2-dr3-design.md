# CF-247 AER D-R2, D-R3 and the E13 extension — design record (recorded before merge)

**Date:** 3 November 2026 AEDT.
**Authority:** Platform Admin direction, 2 Nov 2026 23:24 (`2026-11-02-overnight-continuous-delivery-direction-2324.md` §1, "AER D-R2" and "AER D-R3"). Workstream A.
**Evidence:** `2026-11-02-aer-layer4-readiness-assessment.md`, §3 (G1–G6), §8 (R15, R16) and §9 (D-R2, D-R3).
**Code:** Pilot branch `cf247-aer-dr2-dr3`, migration `20261103010000_cf247_aer_dr2_dr3_supersede_and_matrix_gate.sql` (not applied), spec `s224`, fixtures `tests/fixtures/aer-dr2-dr3/` (scratch PostgreSQL 16).
**Out of scope:** D-R1 (global qualifications such as IB). That is a separate workstream, and no qualification model is built here.

## 1. D-R3 — whole-read completeness of provider entry-matrix runs

`security.entry_matrix_gate_v1(run, exclude)` uses E13's pattern: a stable function that returns `{rule, complete, reasons, …}`, with settings in toolset `pipeline`. It is read by:
- the review screen (`aer_review_read_v1.completeness_gate`, now for matrix items too);
- approval (`entry_matrix_review_apply_v1`).

A person's Approve or Approve except, including confirming "no matrix published here" (Step C), is refused with errcode 55000 and nothing changed while the run is incomplete. Reject is unchanged, and so is the automatic recording path (no Layer 4 item).

The run is complete only when all of the following hold. Checks 1–4 cannot be fixed by leaving rows out. Checks 5–6 can, with Approve except.

1. The run is `done` and is the read of the source's current stored copy, by content hash.
2. The reader's own completeness verdict, where it made one, passed.
3. Every row the run proposed still waits ("rows changed since the read").
4. Every dropped published row is covered by an admitted row:
   - "covered" means the admitted quote contains the first `entry.gate_cover_chars` (40) letters and digits of the dropped quote, and the dropped quote has at least `entry.gate_cover_min_chars` (12);
   - correct exclusions are ignored (`entry.matrix_gate_ignore_reasons`: English test rows, rows that publish no minimum);
   - countries left with no row at all are named (UWA: CN).
5. Row-level checks:
   - no row from another provider, source or stored copy;
   - no qualification named by a column label;
   - the provider's rank is not stored as the qualification's minimum, including a ladder quote whose minimum is not the score's own cell;
   - no band holding label text;
   - no value without a scale or missing from its quote;
   - no quote too short to prove the row.
6. No two waiting rows share one identity (`row_hash`). Under D4 these would hold the approval anyway, but they are now reported first.

A zero-row "no table" run that dropped rows is not a page without a table: it is refused (VUW, Griffith). A zero-row run that dropped nothing can still be confirmed by a person, and the screen asks them to check the stored copy (Newcastle).

## 2. E13 extension — course reads that bypassed the gate

`security.course_entry_read_check_v1(rows, dropped)` is added to `course_entry_gate_v1`. The E13 parts are unchanged; the shared-page part is factored out as `course_entry_shared_page_v1`.
- **Dropped minimums that no waiting row covers** (`entry.gate_hold_reasons`: score_without_basis, quote_not_on_page, low_confidence) hold the read. They are not released by leaving rows out: the read is replaced through D-R2, or rejected.
- **Waiting rows that are not entry requirements** hold approval until they are left out with Approve except. The patterns are in `entry.nonrequirement_patterns`, taken from real pending shapes: course description, progression, credit, pointer, LANTITE and English notes.
- **Domestic routes stored for everyone or for international applicants** (`entry.domestic_audience_words`) hold approval until they are left out the same way.

## 3. D-R2 — a corrected read replaces a waiting course read

How it works:
- `security.course_entry_correction_v1(item, actor, reason)` asks for one stored-page read of the same course, through the existing `course_entry_read_enqueue_v1`. It is owner-only, run by a governed migration or paste; there is no screen action yet.
- It writes one row to `pipeline.aer_read_supersessions`.
- When that read returns, `enrich_entry_record_v1` checks it before writing any row (`course_entry_correction_check_v1`).

The check passes only when:
- the course and bound URL are the same as the waiting read's;
- the waiting read is still pending;
- no `layer4_decisions` row exists for it;
- no claim is younger than `entry.supersede_claim_minutes` (60);
- the course has no manual lock on `entry.supersede_lock_fields`;
- the corrected read is complete: no cut, no set-aside rows, no uncovered drops, no non-requirement or audience rows, and no shared page.

What happens next:
- **If it passes**, one transaction marks the old item `superseded` (the existing status and trigger quarantine its waiting rows; nothing is deleted) and opens the new item `pending`. The new item's `proposed_value.supersedes` holds the reviewer's diff: rows added, removed and unchanged; dropped counts before and after; old and new stored copy; the reason and who asked.
- **If it fails**, nothing changes and the request is recorded as `refused` with the reason. This also covers a read that ended held, empty or not admitted.
- History is kept: a request row moves once from `requested` to `superseded` or `refused`, and a trigger forbids any other update and any delete.
- A unique partial index keeps at most one waiting read per course. Live had no duplicates at 23:46.
- Nothing is approved automatically.

**Matrix runs:** the W28 re-read (`security.aer_reread_v1`, `20261030080000`) already supersedes a pending matrix item when its source is read again, and it is not changed here. Its claim and lock protection is a follow-up, if wanted.

## 4. Live read-only estimates, 2–3 Nov 2026 (no function called; logic replicated in a SELECT)

| Gate | Held now | Held with this change | Notes |
|---|---:|---:|---|
| Course reads (499) | 203 | **381** | 178 newly held: 151 uncovered dropped minimums, 29 with non-requirement rows, 5 with domestic rows (they overlap). By provider: RMIT 100, Monash 38, AUT 26, Auckland 5, MIT 4, VUW 4, Toi Ohomai 1. 118 pass. A items with non-requirement rows stay approvable with the Approve except already recommended. |
| Matrix runs (40) | 0 (no gate) | **38** (16 with lost rows, 25 with rows that cannot be admitted as read, 18 with shared identities; 7 fixable only by Approve except) | Passing: ANU AP (the 4-subject column omission cannot be detected without a column manifest, R14) and Newcastle (0 rows, 0 drops; a person confirms the stored copy). UWA is held: 8 lost, China left with no row, 1 shared-identity group. |

## 5. Rules kept

- **G2:** eleven settings, each with label, range, unit and `used_by`, in section Entry requirements.
- **G3:** no consumer object is touched.
- **G4:** `s224` with a `// Guards:` line; the register is regenerated.
- **Housekeeping:** Replaces and Retires lines; the new table is commented; no job.
- **md5 guards:** the four live functions are edited only through md5 guards (before values read live 2 Nov 23:46; after values computed on fixtures rebuilt from the repository, whose before values equal live).
- No production write, no Layer 4 decision, no AI, no Firecrawl.
