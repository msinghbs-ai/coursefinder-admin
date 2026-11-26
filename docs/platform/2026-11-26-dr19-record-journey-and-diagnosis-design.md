# DR-19: record processing journey, diagnosis and human-assisted resolution (design adjustments)

**Owner:** S2-Build (UI and the read contract's first version), with S2-RM-Design (shared diagnostic and recovery contract). S1-Build stays integration and release owner.
**Mandate:** SS-Programme-Control, 26 Nov 2026 19:19 AEDT, "DR-19: intelligent monitoring and human-assisted resolution" (Platform Admin execution mandate).
**Status:** design recorded 26 Nov 2026 19:25 AEDT. Increment 1 (`s1272`) built, rehearsed and recorded before merge at 19:40. Live on production, and accepted there at 22:40 (Deployed UAT 45812223349: Platform Admin and Pipeline Operator, 1440 and 412 px).

## 1. What changes, and what does not

- **No new dashboard, page, tab or navigation level.** The journey and the diagnosis are one more fold, **Processing journey and diagnosis**, on the existing Layer 4 card. That card is the same component in the focused view (Waiting, grouped by rule) and in the list views, so both get it with one change.
- **Data Delivery** keeps its stream view. A record-level drill from a stream's holds into the same fold is increment 2 (section 7). It needs a per-record list from the shared contract first.
- **No cosmetic redesign.** The fold reuses the card's existing styles (`l4z-fold`, `l4lc-*`) and the PIM `StatusChip` tones. The only new style is the eight-stage strip, which wraps on a phone.
- **No backend logic in the frontend.** The fold renders what `public.admin_record_journey_v1` returns; every stage state and reason is decided on the server.
- **Actions are unchanged.** The fold names the card's existing decision buttons (the same choices, roles and admission paths) as the authorised next action. It adds no new action, permission or admission path.
- **No spend.** The read runs no model. An AI diagnosis is shown when the platform has already made one (Layer 4 interventions: the stronger model analyses a failure once). Otherwise the fold says none has been run.
- **G3 untouched.** The read only reads the consumer API's tables, and never through or into its shape.

## 2. The eight stages

| Stage | Read from |
|---|---|
| Discovery | the stored evidence's source page; else the course's active official page (`catalogue.course_links`) |
| Acquisition | the stored copy (`pipeline.evidence_artifacts`: stored path or content hash, time, type) |
| Extraction | the value the reader proposed (`layer4_review_items.proposed_value`); the reader run and its model (`pipeline.field_enrich_items`) |
| Normalisation and mapping | the AI interpretation when there is one (`pipeline.layer3_interpretations`: status, validator result, model, prompt version, confidence, cost); otherwise "deterministic reader, no AI interpretation" |
| Validation | the item's decision state and the gate that holds it (the course entry completeness gate for entry reads; the item's hold reason otherwise) |
| Canonical admission | the Layer 4 lifecycle's admission check (`security.layer4_item_lifecycle_v1` › `steps.admitted`) |
| Publication | the lifecycle's publication check (`steps.published`) |
| Website and Zoho verification | none is recorded per record yet, so the stage reads **Not verified** (increment 2, shared contract) |

**Each stage has one state:**
- `done`;
- `failed`;
- `held` (waiting for a person or a gate);
- `not_started`;
- `skipped` (not used for this kind of record, or replaced by a newer read);
- `waiting` (not reached: an earlier stage stopped it; the reason names that stage);
- `not_verified`;
- `unavailable` (the platform keeps no per-stage record for this kind of item; the reason says so).

The first stage that is not `done` is the **stopping stage**. Every later stage that is not done reads `waiting`, with "Not reached: waits for <stage>".

**Unavailable, not verified and zero are never merged.**
- A missing value is `null` with a reason, shown as "Not available".
- An unchecked value is `not_verified`, shown as "Not verified".
- A measured zero is `0`, shown as 0 (for example US$0.00 for a stored-copy re-read).

## 3. The diagnosis (same read)

| Field | Source in increment 1 | When there is none |
|---|---|---|
| Exact failure reason | the stopping stage's reason | n/a |
| Stored source evidence | evidence id, page, captured time, type, hash prefix, whether a stored copy exists | "No stored copy is linked" |
| Previous attempts | the lifecycle's events (reviewer and automatic), corrected reads, the technical work item's attempts and failure class | 0 attempts (a measured zero) |
| Reader and AI model | the reader run's source and model; the interpretation's model, prompt version and confidence | "Deterministic reader: no model" when the reader is deterministic; "Not recorded" otherwise |
| Failed validation or admission gate | the gate's missing parts, or the item's hold reason | n/a |
| AI-assisted root cause diagnosis | the intervention's AI analysis, recommendation and required input | "Not run: the platform runs one only when automatic recovery fails, so nothing was spent" |
| Similar resolved cases | items of the same field and hold reason decided in the last `layer4.journey_similar_days` days (G2, 90): outcome counts and the latest `layer4.journey_similar_max` (G2, 5), each with its reference | 0 similar cases |
| PR and resolution references | the item's and the similar items' change-control references; the intervention's integration issue | "None recorded" |
| Recommended recovery | the intervention's recommendation; else the lifecycle's repeat-guard alternative; else its next step | n/a |
| Estimated recovery cost | a stored-copy re-read by the deterministic reader (entry reads) is US$0.00; an AI re-interpretation is the average cost of this task's last interpretations, with the count | "Not available" |
| Potential data population gain | what admission would fill: the field, the course or provider, and the row count where the value has rows | n/a |
| Authorised next action | the card's own decision buttons, with the role each needs (the existing Layer 4 rules) | n/a |
| Actual outcome | decision state and time, admission and publication from the lifecycle | "Not decided yet" |

## 4. Read contract (increment 1): `public.admin_record_journey_v1(p_args jsonb)`

**Input:** `{kind, ref}`, the Layer 4 item. Signed-in Curator and above (rank 3), the same as the lifecycle read.

**Output:**
```
{kind, ref, found, family, subject, stopped_at, stopped_label, stopped_state, stopped_reason,
 stages: [{key, label, state, reason, at, detail}],
 diagnosis: {failure_reason, evidence, attempts, reader, gate, ai_diagnosis, similar, references, recommendation, cost, gain, outcome},
 lifecycle_stage, generated_at}
```

**Families:**
- `review_item`: course link, entry, matrix, description, no page and conjoint items; the full journey.
- `intervention`: validation, admission and publication from the intervention; earlier stages `unavailable`.
- `lifecycle_only`: every other kind, mapped from the lifecycle's steps; stages it does not track are `unavailable`.

The functions inside are `security.record_journey_v1(kind, ref)` and the two settings. There is no table, job, cron or spend.

## 5. For S2-RM-Design: the shared diagnostic and recovery contract

This read is the first version of the shared contract. S2-RM-Design owns what it does not yet hold:
1. **Website and Zoho verification per record:** a recorded check that a published record is returned by the website read (v2 and v3) and by Zoho, with its time. Until then the stage reads Not verified.
2. **A per-record list behind Data Delivery's holds and recoveries** (stream, stage, provider), so Data Delivery can open the same fold for a record (increment 2).
3. **Resolution references:** PR numbers and change-control items linked to the records they fixed, beyond `change_control_ref`, so similar cases can name the PR that settled them.
4. **Recovery outcome measurement:** for an automatic recovery, the fields it filled when it ran (realised gain), so the diagnosis can show measured gain beside potential gain.

The keys above stay stable. New fields are added beside them.

**Status (S2-RM-Design, 26 Nov 2026 19:55 AEDT):** items 1 and 2 are delivered at course × field grain by s1273 (`security.pim_record_trace_v1`: the trace's `consumer` block holds Website v3 and Zoho v3 `returned` with `checked_at`; `security.pim_provider_trace_v1` with a class gives the record list). Items 3 and 4 are the next slices (Master Plan 6.6).

## 6. Guardrails

- PIM visual design kept, desktop and 412 px phone width, no sideways scroll.
- S1-API-Frontend-Delivery's page search (s1270) is not touched.
- Permissions, G3, manual locks, cron ceiling and spend controls are unchanged.
- Admin pull request first, then Pilot; live-dry-run rehearsal; production UAT on the signed-in browser.

## 7. Increments

1. **s1272, Layer 4 card:** the read contract, the fold on every Layer 4 card, and the guide text.
2. **Data Delivery drill:** a record list for a stream's holds and recoveries, opening the same fold. Needs contract item 2.
3. **Course record drawer:** the journey per field on the Course catalogue blade.
4. **Verification and realised gain:** after contract items 1 and 4.

**As built (S2-Build, 26 Nov 2026):** increments 2 to 4 are s1282 (Pilot #1701; no migration) on S2-RM-Design's reads `admin_pim_record_trace_v1`, `admin_pim_provider_trace_v1` and `admin_pim_operational_recovery_measure_v1`. The Data Delivery drill opens with a button and reads only when opened, and each listed record reads its trace only when opened (production UAT fix). The course drawer fold keeps seven facts apart: record returned by consumer, field populated, field value verified, international applicability verified, canonical admission, consumer delivery and actual recovery gain. Where evidence is incomplete it shows Not verified or Not available.

## 8. Reported data issues — shared Admin, Portal and Zoho lifecycle (Platform Admin, 26 Nov 2026)

**Status:** Platform Admin requested feature improvement; implementation and acceptance outstanding. This extends DR-19 and existing F-OPS.03/.17/.19/.21; not a separate ticketing system, data pipeline or release prerequisite. Design owner S2-RM-Design with S2-Build; UI owner S1-API-Frontend-Delivery (coordinate Portal single writer); S1-Build is integration/API/security release owner. Reserve spec/migration only at implementation after checking current main and open PRs.

### 8.1 Existing capability and verified gaps
- In-app: s1025 backend, s1044 UI (full spec `cf-247-s1044-layer4-bulk-counsellor-feedback-contract`); `pipeline.counsellor_feedback`, DB-driven `counsellor_feedback_categories`, `public.counsellor_feedback_submit_v1` and `list_v1`; rank 2 own, rank 3+ authorised all; Layer 4 kind `counsellor_feedback`. Existing Fixed/Not changed operation records closure/note, not evidence of correction.
- Zoho: POST `zoho-api-v3` actions `report` and `report_status`; live `public.zoho_v3_report` / `zoho_v3_report_status` wrap v2. `pipeline.data_flags` with `flag_code='reported'`, `detail.source='zoho'`, existing Layer 4 kind `counsellor_report`. Existing v3 reports are labelled zoho-v2 internally; do not guess historic version. Current report status lookup receives flag IDs, no caller-key binding apparent in SQL; verify gateway/tenant boundary before extending. Current v3 report does not capture an exact caller display snapshot. Both stores had zero records in read-only check 26 Nov 21:45 AEDT; no authenticated round-trip UAT established.
- Portal full own-report path and Admin Dashboard reporter updates require implementation/readback; do not claim current availability. Source links: [Pilot v3 edge](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/supabase/functions/zoho-api-v3/index.ts), [Zoho developer changes](../integrations/zoho-pack/ZOHO-API-V3-CHANGES.md).

### 8.2 One lifecycle, two existing ingress records
Keep both original tables and source-specific IDs stable (in-app UUID, Zoho flag_id); project a common report view through existing reads and role checks. One logical investigation may link multiple submissions concerning the same stable entity, exact field/offering/audience and evidence version. Preserve each reporter's own receipt, notification state and history; don't expose another reporter's note or identity. Source labels Admin, Portal, Zoho (known API version only); legacy/unknown origins clearly labelled. Future Website is optional, not part of this delivery. Do not add a new parallel report store, queue, scheduler or dashboard. If existing storage cannot safely hold provenance, ownership or acknowledgement, propose the smallest additive internal schema change through S1-Build (no assumed schema approval; preserve original IDs).

Report captures: stable entity type/id and provider, country, field, exact course/offering/campus/year/currency/audience/qualification/award scope where applicable, issue category (missing/wrong/outdated/other), displayed snapshot and observed time/version, reporter's note, optional suggested value and official URL, origin, submission and correlation/idempotency ID. Validate identity against catalogue; snapshot/notes/URLs are untrusted evidence, never instruction or canonical truth. Existing categories are canonical; map Zoho aliases explicitly, reject unsupported categories or explain 'other'; no silent loss of scope. No student/customer personal details, credentials or applicant documents; allowlisted snapshot, size limits, escaped rendering, authorised source acquisition only, no arbitrary URL fetching or paid AI call triggered by submission.

### 8.3 User experience (both authenticated applications)
- Reuse existing dashboards and My reports area/route (Admin) and equivalent Portal own-report workspace; no new standalone dashboard. Dashboard card: active reports, investigating/held, resolved since last visit, unread updates; click through to the relevant filter. Actual server-side counts, pagination and freshness; not inferred from local badge state. Active list by default; filters Open, In progress, Awaiting input, Resolved, History. Empty state and accessible responsive design.
- Course/provider/campus or other supported detail: report action with prefilled exact record and field context, existing category selector, receipt and link to My reports. User can view their own submitted snapshot, status timeline, safe public progress/closure reason, verified corrected value or no-change explanation and link back to the record. Reporter may add bounded follow-up evidence through existing governed mechanisms; not directly edit canonical data. Portal and Admin authenticated identity shared where supported; verify backend ownership, never infer from matching names/email.
- Users receive an in-app update when report status changes materially or a response is requested, and a final outcome when resolved. Reuse existing dashboard/activity/notification mechanisms where present; if unavailable use scoped report read + durable per-user unread/acknowledged state, not a separate notification service. No new email/SMS/push or scheduled polling job. Badge per user's own updates, accessible text plus icon; avoid duplicate notifications from retries.
- Terminal report leaves active processing list, but remains in **Resolved — unread** until acknowledged; acknowledgement removes it from active user inbox/dashboard notification count and archives to My reports > History, not hard-delete. Optional user dismiss/archive after reading; don't auto-hide unread resolutions. Retain stable IDs, immutable evidence, audit, external status responses and operator history under existing retention/privacy policy; no new hard-deletion or arbitrary retention period. A recurrence opens/reopens a linked investigation per existing rules; prior resolution remains auditable. Acknowledging is not an admission decision and does not reopen/alter the investigation.

### 8.4 Operator experience (existing Layer 4 Inbox)
One "Reported data issues" projection/filter covering existing `counsellor_feedback` and `counsellor_report`; show source chip **Admin / Portal / Zoho**, report reference, record, exact affected field, issue, reported vs current vs proposed value, age, status, severity, owner, linked investigation and next action. Add **Reported** / **Resolved** flag (with origin and safe status detail) to authorised Admin catalogue/Layer 4 records; show open issue separately from past resolution, not a global quality judgement. Counsellor/Portal user sees their own report badge/status only unless existing role explicitly grants wider access; no public Website flags or other users' reports. Zoho-origin flag remains filterable after resolution in history. Use existing journey fold (s1272), record/provider trace (s1273), evidence and permitted actions. Prioritise consumer-visible incorrect data as existing P0 rule. One operator decision/verified recovery updates all correlated reporter receipts without duplicate reads.

Lifecycle proposal: received/open -> investigating -> recovery in progress -> awaiting input/held or awaiting verification -> fixed/not_changed; optionally reopened on new evidence. Acknowledged/archived is per-reporter presentation state, not a global investigation state. Expose only safe reason categories and reporter-facing notes, never internal model prompts, account data, other reporters' identity or private evidence. Reuse existing request/attempt/event records; preserve existing status enums through projection when possible. Report submission cannot mutate canonical values, release protected holds, start paid work or create manual locks. Use stored evidence and existing bounded recovery first, qualified AI only through approved controls; record cost/attempt/decision. Verify exact field value, identity, audience, edition and relevant API consumer read-back before marking Fixed. If correction admitted but not yet delivered, show awaiting verification. If evidence proves displayed value already correct, close Not changed with evidence and reason; unresolved/blocked cases remain open/held, not false resolution. "Fixed" cannot be based solely on a manual note, reader success, course presence or a PR. External status compatibility maps intermediate states to open and final states to fixed/not_changed; a closed-but-unacknowledged report still has its final status.

**8.4a As built: R3 (s1285, S2-Build, 26 Nov 2026).**
- **Read:** `public.admin_reported_issues_v1` (Curator and above, read only, migration `20261130060000`, after R1 s1281).
  - It projects `counsellor_feedback` (origin Admin or Portal) and `data_flags` `reported` (origin Zoho) into one shape.
  - Zoho field names map to register fields through `pipeline.report_origin_field_map` (data).
  - Figures: submitted, open, awaiting verification, resolved, fixed, not changed, median time to resolve, and recurring course fields within `reports.recurrence_days`.
- **Evidence:** R1's verification when held; otherwise the current field state, labelled as current state rather than a check made at closing. A Fixed with no held value is flagged.
- **Layer 4:** a closed panel above the queues, with origin and state choices, opening each report's field trace (s1282) and journey fold (s1272), and linking to its existing card. Decisions stay on the cards.
- **Course drawer:** Reported and Resolved beside each field.
- **Not in R3:**
  - severity, owner and linked investigations (no store holds them yet);
  - Zoho v3 additions (R4, held).

### 8.5 Zoho v3 (backwards compatible, v2 frozen)
Reuse existing `report` and `report_status`; retain `flag_id`, existing fields, error/status semantics and batch bounds. Add optional v3-only structured display snapshot/field scope, request idempotency key, safe timeline/update timestamp, resolution reason and verified value/consumer status only after contract review; support report acknowledgement only if needed by Zoho developer, as additive v3 capability, not mandatory for existing clients. Derive origin, authenticated integration/key/tenant and caller scope at trusted gateway, not client-supplied reporter email. Authorise status/list/ack per integration and scoped actor; credential rotation preserves stable ownership; avoid leaking whether another tenant's UUID exists. Historical ambiguous ownership handled explicitly, no blanket backfill. Preserve shared key rate limits and audit; no secrets or raw personal info in logs, AI or notifications. Report should correlate back to the actual Zoho displayed value (legacy sync snapshot may differ). Extend award and international eligibility reports only with qualified stable entity/scope contract; do not silently map them to course other. Keep existing v2 functions, edge, G3 and payload unchanged; no new consumer endpoint if existing actions suffice. Prepare developer comms for Divya (Zoho), Wix if affected; HOLD any consumer-affecting Pilot PR until Platform Admin confirms communications and applicable G3 approval/rebaseline.

### 8.6 Implementation and acceptance (incremental, existing F-OPS)
A. Backend contract/security — S1-Build and S2-RM-Design: reconcile existing ingress and report ownership, common read/projection, status transition validation, reporter-safe events and acknowledgement, source/field mappings; reuse existing controls. Read-only baseline, scoped rolled-back fixture then exact-head CI. No production data seeded by design.
B. Reporter UI — S1-API-Frontend-Delivery with Portal owner: existing Dashboard card, Report action, My reports active/resolved/history, durable acknowledgement and accessible mobile layout, common components where feasible. Existing Admin/Portal navigation only; no unrelated redesign.
C. Layer 4 — S2-Build / S2-RM-Design: unified filter/source flags, existing diagnosis/recovery controls and evidence-backed outcome, correlated receipts, verified consumer read-back. Show relevant reporting stats (submitted, open, resolved unread, acknowledged, age, verified resolution time, recurrence) by source and domain; not new enrichment admissions.
D. Zoho — S1-Build: additive report/status contract and developer handover; existing valid request works unchanged, tenant isolation and rate limits; Divya implements Zoho UI separately. Consumer comms gate before merge.
E. Acceptance: authenticated two-user and operator checks on Admin and Portal, desktop and measured 412px; report creation/idempotent retry, correct source and field, own/all permissions, no cross-user/tenant leaks, input/XSS/URL/payload validation, protected records unchanged, terminal closure only on verified field outcome (or evidenced not_changed), status/readback, unread update once, acknowledgement removes only user's notification, history and API flag_id still retrievable, reopen/recurrence, no double-counting or duplicate paid work. Include wrong-value and no-change cases, multiple reporters, non-course entities, failed recovery and delayed consumer sync. Validate signed-in Zoho v3 request/status with authorised test credentials and v2 regression; no unsolicited real report or PII. Mark accepted only with actual production evidence; no launch wait for this improvement. Regenerate existing test register through S1-Build; update existing Master Plan, CURRENT-STATE, Feature Acceptance, Execution Register and linked handover. No new cron, data pipeline, approval policy or spend authority. Preserve 24x7, existing manual locks, G3 and <=140 active cron.
