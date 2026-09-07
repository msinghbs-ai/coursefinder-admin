# M2.4.5 NEXT CHAT

## Latest accepted UI correction — CF-243

- Pilot visible release is **v2.15.74** at `0475dc5dc88a7f3b568a5151e6fd8d94af411924`.
- Provider Compare has independent QS/THE edition selectors with Multi-year per publisher.
- Shared QILT/PRISMS snapshot/trend controls are removed; QILT keeps its year selector.
- QILT/PRISMS University/Provider identity headers are sticky.
- Final build/browser smoke `34097989443` PASS; deployed Cloudflare UAT/currentness `34097989441` PASS.
- CF-241 remains reserved for separate CF-239 runtime reconciliation.
- Production untouched; M2.5 remains paused.


Recommended chat name:

`CF M2.4.5 — v2.15.73 Accepted UI Baseline, CF-241 Runtime Reconciliation & Remaining Pre-Production Gates — 2026-09-07`

Continue CourseFinder M2.4.5 from repository/runtime truth. Do not use superseded v2.15.72 recovery history or prior chat memory as the active baseline.

## Mandatory start

1. Read `PROJECT_INSTRUCTIONS.md` and `docs/README.md`.
2. Read the PIM operating principles and troubleshooting/bugfix/recovery protocol.
3. Read Milestone 2 Standing Instructions and applicable execution addenda.
4. Read `change-control/README.md`, `change-control/REGISTER.md`, CF-240 and CF-242.
5. Read current M2.4.5 `RUNSHEET.md`, `CURRENT-STATE.md`, `FOLLOW-UPS.md`, `WORK-ITEM-LEDGER.md`, `MEETING-READINESS.md` and this file.
6. Reconcile the current Pilot `main` head, deployed Worker currentness, Pilot Supabase migrations/runtime and latest CI/UAT evidence before changing shared foundations.

## Accepted active baseline

- Visible Admin release: **v2.15.73**.
- Accepted Pilot `main` head: **`82e1f13cd37508bec314bfbf882ecdcb4a89183c`**.
- Functional UI acceptance head before release-only sync: `39dbf633d236c812cd5134ff263b993f6ac3e851`.
- Governed DB reconciliation: `20260907064251_m245_ui_read_contract_reconciliation`.
- CF-242: **CLOSED / PASS**.
- Final v2.15.73 merged-head build + browser smoke: `34093765392` — PASS.
- Final v2.15.73 deployed targeted UAT/currentness: `34093765349` — PASS.
- Earlier functional deployed UAT: `34093156194` — PASS.
- Bounded viewport gate: `34093001623` — PASS at 1600×900, 1366×768, 900×820 and 390×844.

## What CF-242 closed

- Scholarship Catalogue Provider filter is bounded/searchable and server-authoritative through `provider_id`.
- Scholarship/table columns use the accepted fluid list/grid pattern and meaningful server-backed sorting.
- QILT and PRISMS datasets use fluid tables and governed server ordering.
- QS and THE provide Open Dataset + Compare with edition/year, Provider mapping/equivalence and Evidence preserved.
- Provider Compare defaults QS/THE on when accepted data exists, defaults to latest retained edition, displays retained history independently and keeps Provider identity visible while wide data scrolls.
- Release pill, browser title, release-currentness authority and legacy release list are synchronized to v2.15.73.

## Superseded / separate work — do not conflate

- **v2.15.72 is superseded forensic history under CF-240 and must not be reused.**
- **CF-241 remains reserved for forward reconciliation of retained parts of the superseded CF-239 runtime-performance changes.**
- CF-242 did not reintroduce CF-239 helper/read-path behaviour.
- Production was not touched and M2.5 was not reopened.

## Next governed action

First determine whether CF-241 has already been implemented after this handoff. If not, treat it as a separate runtime reconciliation:

- retain/requalify only the post-v2.15.71 DB/runtime changes explicitly classified for retention by CF-240;
- do not restore CF-239 as a unit;
- inspect exact current runtime/function/index truth first;
- use targeted → bounded → nominated acceptance;
- preserve role/rank, Evidence, publication, source grain, Provider equivalence and consumer-admission boundaries.

After CF-241, continue only the remaining open M2.4.5/pre-production gates recorded in `FOLLOW-UPS.md`; do not infer that M2.4.5 as a whole is closed merely because CF-242 is closed.

## Standing troubleshooting guardrails

- inspect exact failing evidence before changing implementation;
- classify failures before changing code/test/schema;
- do not rerun repeatedly without a material fix or justified transient reason;
- never weaken correct security, authority, data or Evidence semantics to make a test pass;
- change UAT expectations only when runtime/repository evidence proves the old expectation stale;
- apply the smallest safe fix;
- keep browser-visible version/currentness synchronized only after its functional gate passes;
- Production remains a separate trust boundary requiring explicit authorization.

## Pickup text

> Continue CourseFinder M2.4.5 from repository/runtime truth. Read the mandatory governance/current-state files first. Accepted Pilot baseline is v2.15.73 at `82e1f13cd37508bec314bfbf882ecdcb4a89183c`, CF-242 is CLOSED/PASS, final build/browser smoke `34093765392` PASS and deployed currentness `34093765349` PASS. v2.15.72 is superseded forensic history. CF-241 remains reserved for the separate forward reconciliation of retained CF-239 runtime changes. Do not touch Production, do not reopen M2.5, and use targeted → bounded → nominated acceptance without weakening governed semantics.

## Before ending the continuation

- update owning Change Controls and current M2.4.5 control records;
- record exact source/runtime/migration/UAT evidence;
- keep visible version/release currentness synchronized for browser-visible changes;
- record rollback/recovery path;
- return concise Achieved / Blocked / Next.