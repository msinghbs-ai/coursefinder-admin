# Pipeline lineage & operations reference

**Draft 1.0 — 25 Oct 2026, prepared by the Platform Admin's reviewer from the session thread files.**
Every mechanism below is marked: **[V]** verified against a landed release/record this
session, or **[T]** to-verify against Coursefinder-Pilot code before being relied on.
This file is the single map of WHAT feeds each catalogue field, HOW the pipeline moves
it, WHERE it breaks, and HOW work stops, retries, resumes and replays. It is verified
and maintained by the data-engineering agent; the verification checklist is section 8.

---

## 1. Field lineage — every catalogue field, its source, path and failure surface

### Course fields

| Field | Source (authority order) | Admitting mechanism (lane/function) | Landing table | Failure surface → follow |
| --- | --- | --- | --- | --- |
| Title | 1. Register import (NZQA/CRICOS title) [V] 2. Published page title as alias (Defect 1) | Register import; reader "TITLE SHOWN"; alias recording (quote-on-page) [V/T] | courses.title | Gap cause; Layer 4 title items; unnamed-course fix (Part C) |
| Course code | Register (CRICOS=AU, NZQA=NZ, DLI=CA) [V] | Register import; identity proof from bound page (identity-v0.6.0) [V] | course code proof | coverage_reidentify_done; identity quarantine (identity_basis_reverify) |
| Study level | Register + reader | Enrich classification [T] | courses | gap_cause_snapshots |
| Field of study | Register/enrich | Enrich classifier [T] | courses | gap_cause_snapshots |
| Delivery mode | Provider page | Reader [T] | courses | gap_cause_snapshots; Layer 4 |
| Duration | Provider page (stated length) | Reader, quote-on-page [V/T] | courses | gap_cause_snapshots ("page does not state") |
| Intakes | 1. Course page months [V] 2. Page-period→month via approved calendar (evidence = course page) [V] | Reader; period route (calendar-defaults lane RETIRED 22 Oct) [V] | intake rows (as_at) | gap causes; policy approvals queue |
| English requirement | 1. Course page [V] 2. Central policy default (provider level) [V] | Field reader; central policy lane (auto w/ disagreement check + person queue) [V] | course_english_requirements (as_at) | Layer 4; approvals panel (Operations) |
| Tuition (international) | 1. Course page fee [V] 2. Fee-schedule pages [T] | Fee reader (stored-first), fee_ai lane; write path: coverage_apply_course_v1 with fee_below_floor_v1 floor + coverage_identity_allowed (kind=tuition) [V]; supersession via fee_year/valid_to (+ superseded_by, proposed) | course_fees | unverified quarantine; Layer 4; fee_course_requests |
| Official course page link | Bound page (proven binding) [V] | Item-5 fill job (4 guards) [V]; Layer 4 "enter another address" (bind→reidentify→re-read) [V]; manual (never auto-touched) | courses.official link | course_url_fills retraction log |
| Description | Provider page (course) | B2 reader (queued) [T] | courses.description | — |
| Campus (name/city/state) | Register + provider campus pages | provider_fill refresh [V]; register mapping (v2.15.348 CRICOS location names) [V] | campuses | Layer 4; provider blade |
| Open to international | Register (e.g. CRICOS reg) + policy (NZ signatory basis) [V] | Register import; nz_cop_status apply (code-match only, 45-day window) [V] | courses/providers | Layer 4; NZ signatory list (O5) |
| Status (active/archived) | Decisions | Layer 4 archive decisions [V] | courses.status | Layer 4 Decided |

### Provider fields

| Field | Source | Mechanism | Landing | Failure surface |
| --- | --- | --- | --- | --- |
| Name / display name | Register + legal-name capture [T] | Register import; person sets display name (e.g. Torrens) | providers | Layer 4 |
| Website | Provider's own site | find_site lane; Layer 4 website-needed [V/T] | providers.website | Layer 4 (40) |
| Description | Provider's about page | Part E reader (stored-first, AI-consolidated, ≤400 chars, provenance) [V-spec] | providers.description | B3 acceptance (Wollongong) |
| Logo/assets | Provider site | logo_find lane [T] | provider_assets | Task manager |
| Contacts | Provider site (public contacts) | contact_page lane; "Fill in from website again" [V/T] | provider_contacts | Task manager |
| Enrols international | Register | Register import [V] | providers | — |
| Rankings | Stats editions (QS/THE) | Layer 1 statistics-edition-discovery job [V/T] | ranking_observations | Rankings panel |
| Graduate results | QILT/PRISMS | QILT mapping (B6; UNSW/Adelaide name-mismatch) [T] | graduate results tables | Rankings panel |

### Scholarship fields

| Field | Source | Mechanism | Landing | Failure surface |
| --- | --- | --- | --- | --- |
| Name/value/deadline | Scholarship listing + detail pages | Scholarship reader + scholarship_ai [V/T]; B4 second pass (queued) | scholarships | Layer 4 Held scholarship (935) |
| Eligibility / min academic / countries | Detail page (quote-on-page) | scholarship_ai; B4 [T] | scholarship fields | Layer 4 (three-button decisions) |
| Value-note consistency | Detail page | B4 note-vs-amount check (queued) | scholarships | the 23 contradictory notes |

---

## 2. Execution model — how work moves

**Stages per course:** register import (L0) → binding (page search + AI match + reidentify, or manual) → read (stored copy first, fetch only when silent) → extraction/enrich → per-field admission (apply functions with gates) → Layer 4 review where flagged → publication to the website/search document.

**Lanes/modes (worker tickers):** read, coverage-read-2, link_search, ai_match, reidentify, discover, find_site, central_find, contact_page, logo_find, companion_read, source_find, programme_read, provider_facts; plus service lanes: fee reader, enrich, fee_ai, scholarship_ai, central policy. **[V — R1 §2 lists the backoff-covered modes]**

**Gates (in evaluation order, single chokepoint per gate where consolidated):** target rule (rule + hand overrides) → stop list (per-course 6 wrong pages, university stop, credits check) → daily picked cap (100) → budgets (svc_fc_spend) → unpublished skip → backoff (wake-on-work, 15-min cap) → floors (fee) → identity per kind. **[V — R2, hotfixes 1–2; gate consolidation = S1 item]**

**Write paths (the only ways values reach canonical):** coverage_apply_course_v1 (fees: floor + identity); reader apply paths (English/intakes/duration/campus); item-5 fill (links); Layer 4 apply functions; admin functions (manual, exempt from auto gates, never overwritten). **[V]**

---

## 3. Incomplete mechanisms — the register of gaps being fought

| Gap | Mechanism fighting it | Status |
| --- | --- | --- |
| Binding ceiling (NZ 53.5%) | R2 cap + tranche overrides + zero-yield re-acquire + person tasks | Live, ramping |
| Wrong pages | Zero-yield flow (detect; auto_reset pending decision) + S1 rejections (queued) | Detect live |
| Identity mislabel (421) | identity-v0.6.0 re-verify; 8a country_identity_rules per kind (queued) | Re-verify live |
| Fees on separate schedule pages | fee-schedule sources + fee_ai (unproven) [T] | Queued |
| Page-silent fields | Gap causes recorded; re-reads don't help (sweep proved it) | Accepted truth |
| Policy defaults | Central policy lane; approvals queue (D-L4-1 fix queued) | Live, queue surfaced |
| Intakes beyond page-stated | Period→month route only (calendar-defaults retired) | Live |
| Unnamed courses (3,954 NZ) | Part C quantification → register-title fill proposal | Read-only now |
| Title variants / renames | Defect 1 (wrong-page first, aliases quoted) | Build queued |
| AU international variants | Defect 2 (quantify now, build later) | Queued |
| Scholarships thin fields | B4 second pass + Layer 4 de-parking | Queued |
| Provider descriptions | Part E reader (Wollongong acceptance test) | Queued |
| target_only scope | Staged (c) tranche live; (b) rule proposal after 2 weekly lines | Live |

---

## 4. Stop / start / retry semantics — what exists today **[V unless noted]**

- Per-URL read attempts capped at 3; exhausted pages are excluded from picking and feed page_rejections (S1 seed file written).
- Per-course search stop after 6 rejected pages; university stop behind it; person tasks pass the stop in the credit check (hotfix 2), credits_refused status shown.
- Backoff: empty-tick pause with event-driven wake (queue state, not timers); 15-minute cap.
- Person tasks: cancel takes effect at the next provider; progress "0 of 50" style; finished tasks move to Jobs tab.
- Recovery patterns in use: count-guarded re-queue paste files (re-opened 24 unis; tranche overrides), fee requests (re-fire on re-bind), admin_course_read_now, reidentify re-verification keyed by rule version, attempt restoration migrations (Sydney companion 219).
- A course's binding/read/admission state is reconstructable from coverage_course_pages (status, attempts, bound_at, next_read_at) + gap causes + evidence artifacts.
- **[Gap]** Person tasks have no durable per-item checkpoint: a dead mid-way task is re-derivable only from queue state, not a resumable cursor.
- **[Gap]** pickers do not carry queued-at: ledger wait_ms is null (R1 noted); queue waits measured separately via lane_queue_wait_v1.
- **[Gap]** No per-course append-only event log: a course's journey requires joining ~6 tables.

---

## 5. Logging & replay — what exists, and what replay requires

**Existing instrumentation [V]:** pipeline.mode_outcome_ledger (per worker call: mode, status, ms, items, ok, failed, landed, detail; 90-day retention); extraction_runs; pipeline.gap_cause_snapshots (hourly); evidence_artifacts (171k, bucket); pipeline.admin_control_events (fills, resets, quarantines); page_rejections (S1); field_change_log; stats_15m; health-hourly (R3); admin_queue_watch + lane_why_idle_v1.

**What a replay of a course's enrichment requires:** (1) stored page copies (exist — replay is the default read path); (2) the reader versions + prompts/rules in force at the time **[Gap — not versioned per run]**; (3) the gate settings at the time **[Gap — settings changes logged as events but not snapshotted per decision]**. Deterministic re-admission (replay stored copy through current readers) exists; *historical* replay (as-it-happened) does not.

**Proposed (spec, for the verification mandate):**

1. `pipeline.course_events` — append-only per course: at, stage, mode, run_id, in_state, out_state, error_ref. Every lane writes; this is the journey log the blade's Pipeline Strip renders from.
2. Version stamps per run: reader/rule/settings versions captured into extraction_runs + ledger detail, making historical replay reconstructable.
3. Task checkpointing: person tasks become idempotent re-derivations from queue state (re-queue = resume), with a task_items table recording per-course progress.
4. Backfill picker queued-at so ledger wait_ms is real.

---

## 6. Failsafe & failproof inventory

**Existing [V]:** count guards on every paste file (all-or-nothing, named-row failures); md5-guarded edits; contract tests + CI gates (CF-247 UATs, 1,896 tests); frozen consumer API + daily drift guard; settings-not-hardcoded live check; no drops (destructive = paste file to Platform Admin); quarantine-not-delete with named reversal paths; backoff caps; daily credit/course caps; stall visibility (why_idle, credits_refused, Task manager blocking reasons); negative-evidence learning; manual-lock exemptions; retention jobs; 15 health checks + queue watchdogs; hourly report; weekly tranche line; housekeeping Replaces/Retires.

**Proposed additions (from open mandates):** blade Fields + Pipeline Strip (per-course legibility); FIELD-ADMISSION-MAP + regeneration job; acceptance report + auto-admit (off by default); course_events journey log; task resume semantics; D-L4-1 pointer integrity check.

---

## 7. The division of labour for this file

This reference is maintained by the data-engineering agent: verified rows carry the
release/PR that evidences them; new mechanisms must land here when they land in code
(the regeneration job for FIELD-ADMISSION-MAP covers the field table; lane/gate changes
update sections 2–4 in the same PR that changes them — doc-as-code).

## 8. Verification checklist (the agent's first task on this file)

For every [T] row: name the exact function/lane/table in Coursefinder-Pilot, cite the
file, and flip [T]→[V] with the citation or correct the row. Where reality differs from
this draft, reality wins and the row is corrected, not the code bent to the doc. Output
the verified version as the same filename; report the flip count and any corrections.
