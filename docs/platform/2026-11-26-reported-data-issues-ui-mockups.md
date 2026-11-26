# Reported data issues and resolution tracking: UI mock-ups and release plan (s1278)

**Owner:** S1-API-Frontend-Delivery (UI). **Assignment:** SS-Programme-Control, 26 Nov 2026 21:59 AEDT, with the mock-up addendum. **Design of record:** `docs/platform/2026-11-26-dr19-record-journey-and-diagnosis-design.md` section 8 (Admin PR #1220). **Feature Acceptance:** F-OPS.03, .17, .19, .21.

## 1. Mock-ups (visual implementation and UAT reference)

- **Drive document:** [StudySearch — Reported Data Issues & Resolution Tracking | UI Mock-ups](https://docs.google.com/document/d/1Pafu45ifemADUHiBV2NSY3eesnfiTkwLLeqexyqj-kY/edit) in the same Drive folder as the Architecture, Control & Governance Design. Document id `1Pafu45ifemADUHiBV2NSY3eesnfiTkwLLeqexyqj-kY`.
- **Linked from:** Architecture, Control & Governance Design section 6.9 (read back live, 26 Nov 2026 22:08 AEDT).
- **Content:** 19 screens and states (Admin A1 to A10 and A5b, Portal P1 to P6 and P5b, Zoho Z1), each at desktop (1440 px) and phone (412 px), 38 images. Each has route and component, what it shows, interaction, backend dependency and acceptance criterion. Rendered from the real tokens and kit classes (Admin `src/ui-v1`, Portal `portal/src/styles.css`); no horizontal overflow at 412 px. All data is illustrative and labelled so on every screen.
- **Screens:** Admin Dashboard card; Report a data issue; My reports (Active, Resolved with acknowledge and archive); report detail and timeline (resolved and awaiting verification); Layer 4 unified Reported data issues; Catalogue Reported and Resolved flags with Zoho source; AI-assisted investigation and resolution panel; roles and journey; states. Portal Dashboard; course Report a data issue; My reports; status and resolution; acknowledge and archive; states. Zoho v3 report and report_status journey.
- **Origins** are told apart by a labelled chip (Admin blue, Portal green, Zoho dark, each with a letter so colour is never the only cue).
- The mock-up source is not committed to either repository; the Drive document is the reference. No design-approval wait applies.

## 2. Reuse and proposed additions

Reused: shell, `ui-kpi`, `ui-grid` card reflow, `ui-pillbar`, `ui-modal`, `ui-diff`, `ui-actionbar`, `ui-emptystate`, `ui-alert` (Admin); `fpill`, `card`, `tag`, `notice`, `drawer` (Portal). The s1044 `ReportIssue` modal and `MyReportsView` are extended. Proposed small kit pieces (tokens only): origin chip, Reported and Resolved flag chips, unread dot, reporter-safe timeline, bulk acknowledge bar. No new menu item beyond one My reports entry in the Portal; no standalone dashboard; no new queue, scheduler or notification channel.

## 3. Release plan (bounded; PIM processing is not touched)

| Release | Scope | Owner | Depends on |
|---|---|---|---|
| R1 backend contract (additive) | Per-reporter acknowledge and unread state; submit extension (exact field, displayed value, audience, year, idempotency key, duplicate check); own-report summary, list views, reporter-safe detail and timeline; verification state (Awaiting verification until canonical field and consumer read-back match); Portal access to the Counsellor RPCs. Proposed names (final names set by S1-Build): `public.report_summary_v1`, `report_inbox_v1`, `report_detail_v1`, `report_ack_v1`, an extension of `counsellor_feedback_submit_v1`, and a reader-state table beside `pipeline.counsellor_feedback`. No consumer API object changes (G3). | S1-Build with S2-RM-Design | None |
| R2 reporter UI | Admin and Portal: Dashboard card, Report a data issue, My reports views, detail and timeline, acknowledge and archive, states; inline help, Guides and `docs/UI-MAP.md`; specs (two users, desktop and 412 px) | S1-API-Frontend-Delivery (Portal edits cross-lane, S2-Build is Portal single writer, Platform Admin authority as for s1275) | R1 live |
| R3 Layer 4 unified view and flags | Read-only union of `pipeline.counsellor_feedback` and `pipeline.data_flags` (`reported`), source chips, Reported and Resolved flags, investigation and resolution panel reusing s1273 trace and s1277 history, verified-resolution logic | S2-Build, S2-RM-Design (UI by this lane on their projection) | R1 |
| R4 Zoho v3 | Additive v3 fields and report_status ownership binding (verify the gateway or tenant binding first), developer notice for Divya, v2 unchanged. **HELD** until developer communication and approval are confirmed. | S1-Build | R1; Platform Admin confirmation |

## 4. Open items

1. R1 needs an owner start from S1-Build; this lane does not write the backend migration (Master Plan section 2 mandate: work for another lane is written into the plan).
2. Portal edits (R2) need the Platform Admin's authority, as for s1275; the Portal is a new caller of the existing Counsellor RPCs.
3. Role matrix in the mock-up (A9) is a proposal; ranks are confirmed against the existing RPC checks at build.
