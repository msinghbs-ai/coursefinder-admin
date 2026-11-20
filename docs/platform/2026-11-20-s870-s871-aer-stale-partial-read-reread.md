# S1-RM-Design s870 and s871: AER re-read from the stored copy ($0); stale partial-table holds re-queued

**Trigger:** Platform Admin 20 Nov 2026 16:28 AEDT.
**Release:** PIM Admin **v2.16.70** (package 0.1.492).
**Pilot PR:** #1432.
**Migration:** `20261120145500_cf247_s870_s871_aer_stale_partial_read_det_reread.sql`.
**Status (20 Nov 2026 17:30 AEDT): recorded before merge.** The rolled-back live dry run passed (md5 `0c632f37`).

## 1. What was found (read only, rolled-back probes)

| Fact | Live value |
|---|---|
| AER items filed by `layer4-groups` as Technical recovery (B, `repair:completeness_gate`) | 2,069 |
| … course first reads by the AI readers | 1,985 (1,952 with a bound stored copy, 33 without, 0 locked) |
| … entry-matrix first runs / matrix changes (provider items) | 66 / 6 |
| … by first-entered date | 29 Oct 238; 12 Nov 277; 13 Nov 1,393; others small |
| Why the deterministic reader did not recover them | `security.aer_det_propose_v1` skips a course with proposed or active rows (`has_rows`) or any earlier `course_entry_first_read` item (`earlier_read`) |
| Item trigger on supersession | `security.course_entry_review_trg_v1` quarantines the item's proposed rows with a full table scan for each item (no index on `provenance->>'review_item_id'`) |

## 2. What changes

| Id | Change |
|---|---|
| s870 | `security.aer_det_reread_v1(check / apply / fetch)`. A pending AER course first read is **rereadable** when it meets all of these: held as technical recovery (B); not an audit sample; not already read by the deterministic reader; no manual lock; course active; has a bound stored copy. **Apply:** supersedes the item and records its supersession; its proposed rows go inactive through the trigger; its readiness and group rows close; the reader pages marked `has_rows` or `earlier_read` reopen; a control event is logged. **Fetch:** a course with no stored copy goes on the Course page needed list. The function is reached through `public.admin_layer4_inbox` actions `aer_det_reread_check` (Curator), and `aer_det_reread` and `aer_page_fetch` (Platform Admin, with a reason). The rule groups key technical-recovery AER items `aerb:<code>` (System recovery / Re-read available), so Waiting for a reviewer counts only items a person decides. `rule_group_items` carries each AER card's check, so the card shows **Re-read from stored copy ($0)** or **Queue stored-page fetch**. The deterministic proposer ignores superseded earlier reads. An index is added on proposed entry rows by review item. |
| s871 | Every pending AI course first read held by the completeness gate (latest machine reason `gate_incomplete`) that the rule can re-read is superseded once, with the Platform Admin's reason. |

## 3. Guardrails

- **G3:** 75/48, checked before and after; no public object.
- **G1:** no new job; `aer-det-sweep` reads the copies.
- **G2:** no new value; the batch size is `layer4.rule_batch_max`.
- **Spend:** $0. The reader is deterministic: no model, no Firecrawl.
- **Never touched:** entry matrices (S677 and the 6 changes), audit samples, manual locks (7,585) and active rows. The migration asserts each of these is unchanged.
- **Reversible:** items keep status `superseded` with a supersession row; rows keep status `inactive` with their reason.

## 4. Dry run (rolled back)

- Holds superseded: 1,818.
- AI-proposed rows inactive: 7,232.
- Reader pages reopened: 68.
- Course first reads still waiting: 693.
- AER rail after the run:
  - Waiting for a reviewer: Audit sample 464.
  - System recovery: all rows held 111, gate 60 (matrix and unbound items), no stored page 33, audit sample 28, matrix changes 6.
