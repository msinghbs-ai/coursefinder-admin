# Reported data issues: R1 backend contract (s1281)

**Owner:** S1-Build. **Assignment:** SS-Programme-Control, 26 Nov 2026 22:22 AEDT.
**Design:** `2026-11-26-dr19-record-journey-and-diagnosis-design.md` section 8 (admin #1220).
**UI release plan:** `2026-11-26-reported-data-issues-ui-mockups.md` (admin #1223, s1278).
**Pilot:** migration `20261130041500` (s1281).

**For:**
- S1-API-Frontend-Delivery: R2, the reporter UI.
- S2-Build and S2-RM-Design: R3, the Layer 4 unified view.

**Scope:** additive on the in-app store `pipeline.counsellor_feedback` (s1025). No consumer API object changes (G3). Zoho (`pipeline.data_flags` with `reported`, `zoho-api-v3`) is R4 and is held for the developer notice and Platform Admin approval.

## Who may call

- Every RPC needs a signed-in user at Counsellor rank (2) or above, using the existing role ranks.
- Admin and Portal call the same RPCs. The Portal passes `origin: "portal"`.
- The reporter reads only their own reports.
- Curator (rank 3) and above triage in the Layer 4 Inbox (kind `counsellor_feedback`), as before.

## Submit: `public.counsellor_feedback_submit_v1(p_args jsonb)` (same signature)

**Existing keys:** `course_id`, `campus_id`, `issue_categories[]`, `notes`, `source_url`, `displayed_snapshot`.

**New optional keys:**

| Key | Rule |
|---|---|
| `field_code` | An active `pipeline.field_register` field |
| `displayed_value` | At most `feedback.notes_max_chars` |
| `audience` | `international`, `domestic` or `all` |
| `year` | From last year to the current Melbourne year plus `lookups.intake_years_ahead` |
| `origin` | `admin` (the default) or `portal` |
| `idempotency_key` | Up to 100 of `[A-Za-z0-9._:-]` |

**Returns:** `{ok, id, status, stage}`.
- `idempotent: true`: a retry with the same key returns the first report.
- `duplicate: true`: the same person already has an open report on the same course and field (or the same categories when no field is given), and that report is returned. Neither case counts towards `feedback.max_per_user_day`.
- **Errors:** `INVALID_INPUT: …` (22023), `LIMIT: …` (P0001), 42501.

## Reads and state (reporter-owned)

| RPC | Returns |
|---|---|
| `public.report_summary_v1()` | `{as_of, active, in_progress, awaiting_input, resolved_unread, unread_updates, history}`, counted on the server |
| `public.report_inbox_v1({view, limit, offset})` | `view` is `active` (default), `in_progress`, `awaiting_input`, `resolved` (closed, not acknowledged) or `history` (closed and acknowledged). Each item: `id, created_at, last_update_at, stage, status, unread, acknowledged, archived, origin, course_id, course, provider, field_code, field, issue_categories`. Page size 1 to 200, ordered by latest update |
| `public.report_detail_v1({id})` | The report as sent (`sent`: displayed value, audience, year, notes, source URL, snapshot), `stage`, `timeline[]` (`at, stage, label` only: no operator, evidence or other reporter), `outcome` (`fixed` with note, `verified_at` and `served_value`; `not_changed` with note; `awaiting_input` with question; `awaiting_verification`) and `reader` (seen, acknowledged, archived). Opening a report marks it seen, and re-checks a report that is awaiting verification. `NOT_FOUND` (P0002) for another person's id |
| `public.report_ack_v1({action, ids[]})` | `action` is `seen`, `acknowledge` or `archive`; 1 to 100 of your own ids. Acknowledge and archive apply only to closed reports. Returns `{ok, action, updated, refused}` |

- **Unread:** a report counts as unread when its latest stage, triage or verification time is after your `seen_at`.
- **Reader state** is kept per person in `pipeline.counsellor_feedback_reader_state`. It is never deleted, and acknowledging is not an investigation decision.

## Stages and Fixed

- **Stages:** `stage` is `received`, `investigating`, `awaiting_input`, `awaiting_verification`, `fixed` or `not_changed`.
- **Status:** `status` stays `open`, `fixed` or `not_changed` for the existing screens and the Inbox.
- **Layer 4 choices:** Investigating; Ask the reporter (note required); Fixed (note required; optional expected value); Verify now; Not changed (note required); Open the course.
- **Fixed** moves the report to `awaiting_verification`. `security.counsellor_feedback_verify_v1` then closes it as fixed only when both hold:
  - the field is held and verified in the catalogue (`security.field_state_entity_v1` completeness `verified`);
  - `public.website_v2_course` serves a value under the field's consumer key that differs from the value the reporter saw, and contains the expected value when the operator named one.
- **Field map:** fields map to consumer keys in `pipeline.report_field_targets` (data).
- **Unresolved cases:**
  - A field with no consumer key (`unsupported_field`) stays awaiting verification.
  - So does a field the consumer does not yet serve.

  Each case is re-checked by Verify now or when the reporter opens the report.
- **History:** every decision and check is an `admin_control_events` row on `counsellor_feedback:<id>`.

## Rehearsal (rolled back, 26 Nov 2026 23:10 AEDT)

- A retry returned the same id. A second open report on the same course and field returned the first.
- Fixed was verified and closed against the live `website_v2_course` of 121476B.
- Not changed closed with its note. Acknowledge refused the open report and updated the closed one.
- History and summary counts matched.
- Cron, locks and G3 75/48 unchanged.

## Not in R1

- The Zoho v3 additions (R4).
- The Layer 4 union with `counsellor_report` (R3).
- The screens (R2).
- Notifications beyond the unread state (no email, push or polling job).
