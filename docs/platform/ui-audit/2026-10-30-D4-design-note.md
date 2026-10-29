# D4: what Approve except may supersede (implementation decision, lodged before code)

**Authority:** Platform Admin, 30 Oct 2026 08:45, decision D4. This closes the open point in `AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md` §10 (A1) and handback 2 line D4.

**The rule (verbatim).** When a reviewer approves a change item with exclusions:
- only an active row with an explicitly approved replacement may be superseded;
- an active row whose proposed replacement was excluded must remain active and unchanged;
- exclusion must never implicitly withdraw, stale or supersede the existing active value;
- the relationship between the retained active row, excluded proposal and review decision must remain auditable;
- if approved replacements conflict with one another, hold the decision rather than guessing.

Lane D4 builds and tests this. The integrator numbers, merges and applies it.

---

## 1. Current behaviour (live, read 30 Oct 2026)

### 1.1 Provider tables (`entry_matrix_first_run`, `entry_matrix_change`)

**Call path:**
- `security.layer4_review_decide_impl` calls `security.entry_matrix_review_apply_v1(item, 'approve', v_final, reason)`.
- For Approve except, `v_final` comes from `security.aer_approve_except_v1` and carries `exclude_row_ids`.
- For Approve all rows, `v_final` is `proposed_value - 'exclude_row_ids'`, so nothing is excluded.

**The line that supersedes (W15), in `entry_matrix_review_apply_v1`:**

```sql
update catalogue.provider_entry_matrix m set status = 'superseded', status_reason = 'replaced by run ' || r.id, updated_at = now()
 where m.provider_id = r.provider_id and m.source_id = r.source_id and m.status = 'active' and m.run_id is distinct from r.id;
```

This runs before the exclusion update and before the activation, and it does not depend on `v_ex`. So Approve except supersedes every earlier active row from the same page, including:
- a row whose new reading was excluded;
- a row the new read does not carry at all.

That is the open point from §10.

**Other callers (not changed by D4):**
- `public.svc_entry_matrix_record` calls the same function with `p_final` null. This is the automatic path for a changed page when `entry.matrix_first_run_review` is 0. That setting is 1 today, so the path is off.
- `security.entry_matrix_review_trg_v1` calls it for reject, more evidence, returns and superseded. That is the quarantine branch, and it never supersedes active rows.

**Today's data:**
- 4 `entry_matrix_change` items are pending (`9adbeada`, `f56bd767`, `8a803c95`, `bcd9f55b`). Each is the first run on a new source of its provider, so none has active rows on its own source.
- No pending matrix item has a waiting row whose identity is already active on another source.
- So D4 changes no outcome for anything waiting now. It governs future change reads of a page that already has active rows.

### 1.2 Course pages (`course_entry_first_read`)

**The line that supersedes, in `security.course_entry_review_apply_v1`:**

```sql
update catalogue.course_entry_requirements x set status = 'superseded', status_reason = 'replaced by Layer 4 item ' || p_item, updated_at = now()
 where x.course_id = r.entity_id and x.status = 'active' and x.provenance->>'reader' = 'enrich_ai';
```

This also ignores exclusions: every active AI-read row of the course is superseded.

**Today's data:**
- No course has an active row yet: all 3,334 rows are `proposed`, across 956 pending items.
- So the course case cannot arise until a course is read a second time after an approval.
- Course rows have no identity key: `description` is free text, and a course has many rows of the same kind (for example `prior_qualification` × n). An approved course row therefore cannot be matched to the active row it replaces without guessing. See §4.

## 2. How a replacement is matched (provider tables)

**Key: `row_hash`.** This is the table's existing row identity, set by trigger `security.entry_matrix_identity_tg` through `security.entry_matrix_row_hash_v1`. It hashes:
- provider;
- course;
- country;
- study level;
- band;
- qualification, condition keys and level label.

It is already unique among active rows (`provider_entry_matrix_row_hash_uq ... where status = 'active'`). Since the RMIT band fix (26 Oct), it is the identity used to refuse duplicate rows in a run.

**Scope:** the same provider and source as today (W15's scope is unchanged). Only matching is added inside that scope.

**Classification.** On an Approve except decision (`exclude_row_ids` is not empty), with run R:
- **Approved proposal P:** a waiting (`proposed`) row of R that is not ticked.
- **Excluded proposal X:** a waiting row of R that the reviewer ticked.
- **Each earlier active row A of the same provider and source (`run_id <> R`)** falls into exactly one class:

| Class | Condition | Result |
|---|---|---|
| **Replaced** | Some P has `P.row_hash = A.row_hash` | A becomes `superseded` (the explicitly approved replacement) |
| **Retained: replacement excluded** | No P matches, but some X has `X.row_hash = A.row_hash` | A stays `active` and is **not written to at all** (status, reason, provenance, version and `updated_at` unchanged) |
| **Retained: not in this read** | No P or X matches | A stays `active` and untouched |

**Approve all rows** (no exclusion), the automatic path and the quarantine branch keep W15 exactly as today. The rule is about approvals with exclusions; Approve all is a whole-read approval.

**Judgement point:** the "not in this read" class follows the rule literally: only a row with an approved replacement may be superseded.
- **Consequence:** under Approve except, a row the provider has dropped from the page stays active until a later Approve all, or until a curator withdraws it in the workspace.
- **Alternative:** supersede the "not in this read" rows as W15 does. This is not recommended. A reader that misreads a row's country, level or band gives the excluded row a different hash. That row would then fall into "not in this read", and its active counterpart would be superseded implicitly. This is exactly what bullets 2 and 3 forbid.
- **Recommendation:** literal, with the guide telling the reviewer how to handle a page that has really dropped a row (§6).

## 3. Conflicts: "hold the decision"

**What a hold is.** The whole decision is refused before anything is written:
- the function raises inside `layer4_review_decide_impl`'s transaction;
- no row changes, no `layer4_decisions` row and no control event are written;
- the item stays `pending`.

No new status or table is needed. The refusal message starts **"Held (decision D4): … nothing was changed"**, names the clashing row ids and says what to do. The reviewer then:
- ticks so that the clash is gone; or
- uses Reject; or
- escalates for a re-read.

A hold cannot be recorded in the same transaction it refuses. The Inbox shows the message, as it does today for completeness refusals.

**The conflicts that are held:**

| # | Conflict | Detection | errcode |
|---|---|---|---|
| C1 | Two approved proposals with the same identity | Group the approved P by `row_hash`, having count > 1. This check already exists (RMIT band fix) with the message "proposed rows share an identity; nothing admitted". Only the wording is changed to the Held message, and it applies to both paths. | 23505 |
| C2 | An approved proposal's identity is already active on a row this decision does not supersede: another source of the same provider, or a row that would be retained | An approved P has `row_hash` equal to an active row outside the replaced set. Today this ends as a raw unique-index violation on activation; it becomes a clear Held refusal. It applies to both paths, with the same outcome (nothing changes) and a clear message. | 23505 |
| C3 | An approved proposal replaces an active row that more than one approved proposal claims | This cannot happen, because `row_hash` is unique among active rows and C1 already blocks two approved proposals with one hash. It is listed so the spec asserts it stays covered by C1. | — |

**Deliberately not a conflict:**
- **An approved P and an excluded X with the same identity as A.** A is superseded: an explicitly approved replacement exists. X is recorded as excluded with no retained row.
- **A retained A and an approved P with a different identity in the same country and level.** For example, two qualifications, or a band ladder where one band's new reading was excluded. These rows legitimately coexist (the identity includes qualification, band and level label). Holding them would block ordinary band ladders.

## 4. Course pages: hold rather than guess

There is no identity key (§1.2). So when an Approve except is given on a `course_entry_first_read` item **and** the course already has active AI-read rows (`provenance.reader = 'enrich_ai'`), the decision is held:
- **Message:** "Held (decision D4): course … has N active entry requirement rows and course rows have no identity to match an excluded row to the row it would replace; nothing was changed. Use Approve all rows if every waiting row is right, or Reject the read."
- **errcode:** 55000.

When the course has no active rows (every item today), Approve except works exactly as now. Approve all rows keeps W15.

## 5. Audit record

There are no new status values, tables or columns. Existing provenance, the decision and the event log are used.

**On the excluded proposal X.** Its `provenance.aer_exclusion` object already records item, run, hash, reviewer, reason and time. It gains:
- `retains_active_row_id`: the A it would have replaced, or null;
- `retains_active_row_hash`.

The retained row A itself is not written, as "unchanged" requires.

**On each replaced row A.**
- `status_reason` stays `'replaced by run <run id>'`, so the existing format is kept.
- `provenance.aer_supersede = {review_item_id, run_id, replaced_by_row_id, decision: 'approve_except (D4)', at}` is added. This applies to the Approve except path only; Approve all is unchanged.

**Return value of `entry_matrix_review_apply_v1`.** The existing keys `entry_matrix_run`, `admitted`, `quarantined` and `superseded` stay. It gains:
- `retained`: count;
- `supersede_map`: `{replaced: [{active_row_id, replaced_by_row_id}], retained_excluded: [{active_row_id, excluded_row_id}], retained_not_in_read: [active_row_id …]}`.

`layer4_review_decide_impl` already stores this return value as `result` in the `admin_control_events` row (area `layer4`, action `aer_approve_except`), together with `decision_id`, item, lineage and `excluded_row_ids`.

**The audit chain:** retained row A ← `X.provenance.aer_exclusion.retains_active_row_id` → item (`review_item_id`) → `layer4_decisions` (one per item) and the event (decision_id, `result.supersede_map`). It can be read in either direction.

`layer4_review_decide_impl` is **not edited**.

**Course rows:** only the hold is added (§4); there is no new audit shape.

## 6. Changes, guards and files

**md5-guarded edits** (live definitions read 30 Oct 2026; `pg_temp.edit_n`, each edit applies exactly once):

| Function | Live md5 | Edit |
|---|---|---|
| `security.entry_matrix_review_apply_v1(uuid,text,jsonb,text,uuid)` | `7c718987b496cad38352f8dfa1f727b7` | C1 wording; the C2 check; the supersede statement branches (no exclusion: the W15 statement byte-for-byte; with exclusions: identity-matched supersede with `aer_supersede`); `retains_active_row_id` on the exclusion record; the extended return value |
| `security.course_entry_review_apply_v1(uuid,text,jsonb,text)` | `25899209725990622fea50e533316f49` | The §4 hold before the supersede statement |
| `security.layer4_inbox_kinds_v1()` | `08e7999c3f4639f02b9607e1fd9ac506` | The Approve except "returns" text only: "…; an active row whose replacement you leave out stays active" |

**Read and not changed:**

| Function | md5 |
|---|---|
| `security.layer4_review_decide_impl` | `67966cebe3184b9acad1a3451fd0021b` |
| `security.aer_approve_except_v1` | `d9e0e9fc378a57e6684a4ce84c718de9` |
| `security.aer_review_lineage_v1` | `cf2cdb56aded004a3c6fac091f0898e7` |
| `security.aer_review_read_v1` | `62793b3544874e91a1e2aa26b80e8a14` |
| `security.entry_matrix_review_trg_v1` | `d3cc5abcda5de110137f269b3809965e` |
| `security.course_entry_review_trg_v1` | `527980ffd84edffd9e8841a5c4202f72` |
| `public.svc_entry_matrix_record` | `16253ffa620d446ec4c762a16fceeb3b` |

**Migration:** `supabase/migrations/20261030XXXXXX_cf247_d4_supersede_rule.sql` (the integrator numbers it).
- `-- Replaces: security.entry_matrix_review_apply_v1, security.course_entry_review_apply_v1, security.layer4_inbox_kinds_v1 (same names, md5-guarded edits)`
- `-- Retires: nothing (the implicit supersede of an excluded row's active counterpart under Approve except is switched off here)`
- There is no new table, job, setting, status or column. Nothing is dropped. The consumer API (G3) is untouched: only `security` functions are changed, and they write status and provenance on `catalogue.provider_entry_matrix`, as A1 already does.
- A post-check `do` block asserts that each edited definition carries its change.

**Spec:** `tests/uat/cf-247-s180-aer-supersede-rule-contract.spec.mjs`. s180 is the next free number after s179 on main and in the d5 and d6 worktrees; the integrator should confirm no other lane takes s180.

```
// Guards: CF-247 decision D4 (Platform Admin 30 Oct 2026 08:45): under Approve except only an active row with an explicitly approved replacement (same row identity) is superseded; an active row whose replacement was excluded stays active and unchanged; the retained row, excluded proposal and decision stay linked; conflicting approved replacements hold the whole decision with nothing changed
```

**Planned tests:**
- **Source-level contract tests** in the s176 style:
  - md5 guards and edit counts;
  - the W15 statement kept byte-for-byte on the no-exclusion branch;
  - identity-matched supersede on the exclusion branch;
  - the retained row never in any `update … where` on the exclusion branch;
  - the C1 and C2 Held messages;
  - the course hold;
  - audit keys;
  - Replaces and Retires lines;
  - no drop or delete.
- **Mixed approve and exclude regression tests**, run as a table-driven model of the classification against fixtures:
  - replaced plus retained-excluded plus not-in-read in one group;
  - an approved and an excluded row with one identity;
  - a band ladder with one band excluded;
  - C1;
  - C2;
  - a course with and without active rows.

  The fixtures mirror the SQL predicates, and the spec asserts the SQL contains those same predicates. A mocked Inbox test checks that the Held refusal reaches the reviewer.
- **The live rolled-back dry run** proves each case on real rows (step 2).

**Test register:** `node scripts/test-register.mjs` is regenerated in the same change. The admin-repo copy is the integrator's to commit.

## 7. Reviewer guide: AER-ROLE-GUIDES §5.1 (text for the integrator to commit)

**Replace the Approve except bullet list and the "Caution, provider-table change items" paragraph with:**

> - **Approve except… (decisions A1 and D4):**
>   - Tick the rows to leave out and give one reason. At least one row must be ticked and at least one must stay; if all would be ticked, use Reject.
>   - Ticked rows become `inactive`, with the reason "excluded by approve except (Layer 4 item …, reviewer …): …" and an exclusion record in the row's provenance. They show as "Excluded in Layer 4", stay unadmitted and are never re-read or superseded automatically.
>   - Every other row is admitted through the same checks as Approve.
>   - **What happens to the rows the website shows today (D4):** an earlier active row from the same page is replaced only when you approve a new row with the same identity (provider, course, country, level, band and qualification). If you leave out its new reading, the earlier row **stays active and unchanged**. A row the new read does not carry at all also stays active.
>   - The excluded row records which active row it would have replaced, and the decision's event log lists what was replaced and what was kept. Anyone can see what was approved, what was left out and what stayed.
>   - **Held decisions:** if two approved rows have the same identity, or an approved row matches a row that is already active elsewhere for the provider, the server holds the decision: "Held (decision D4): … nothing was changed". Nothing is admitted or changed, and the item stays pending. Tick the clashing row, or Reject, or escalate for a re-read.
>   - **Course pages:** if the course already has active entry requirements, Approve except is held, because course rows cannot be matched one to one. Use Approve all rows if every row is right, or Reject the read.
> - **Reject the read:** no row is admitted; every waiting row becomes `inactive` with your reason.
>
> An AER item is never edited inline, and there is no generic bulk path. A complete read is always accounted for: every row it matched is either admitted or explicitly excluded.
>
> **If the provider has removed a row from the page:** Approve except keeps the earlier active row. If the whole new read is right, use **Approve all rows**, which replaces every earlier row from that page. Otherwise, after the decision, withdraw the dropped row in Catalogue › Entry requirements with a reason (section 3.4).

**Also:**
- §5.2, last paragraph: drop "(observe the caution in 5.1 for change items)".
- §5.6, last sentence: replace "Until the Platform Admin decides "approve except" (decision paper A1), reject an item whose rows are partly wrong, with the reason." with "Use Approve except for an item whose rows are partly wrong (section 5.1); an active row whose replacement you leave out stays active (D4)."
- Handback 2: the D4 line becomes decided, and the `entry_matrix_change` row "(reject until the open point in decision §10 is decided)" is no longer needed.

## 8. Not in scope (follow-up if wanted)

`security.aer_review_read_v1` could show, for each waiting row, the active row it would replace, so the reviewer sees it before ticking. That needs a screen change as well and is not required by D4.
