# Layer 4 review kinds: action, evidence, timestamp and recovery audit

**Decision:** Platform Admin, 4 Nov 2026 12:24 (`2026-11-04-layer4-usability-action-lifecycle-decision-1224.md`), §5 and §10.
**First reproducible case:** IQ-00279, RMIT Diploma of Commerce (CRICOS 111278B).
**Build:** Pilot branch `cf247-l4-action-lifecycle`, migration `20261104540000` (number finalised at release), spec `s281`, fixture `tests/fixtures/l4-action-lifecycle`.
**Production figures:** read-only, 4 Nov 2026 12:28–12:56 AEDT. Code read: Pilot `main` at v2.15.469 (ae248238), plus playbook v6.

## 1. RMIT Diploma of Commerce: what actually happened

| Question (§1) | Answer from the records |
|---|---|
| Did the button submit? | Yes. 12:17:46 AEDT, Platform Admin. |
| Was an action audit record created? | Yes. Recovery action 1 (`layer4_aer_recovery_actions`) and audit event 28863 (`admin_control_events`, `inbox_decide`). |
| Request time and reference | Corrected-read request `d05725e2`, job `8fb3173c`, enrich item 270218, all at 12:17:46. |
| Did the reader accept or refuse? | The reader ran at 12:18:11 and refused: "the corrected read was cut at the row limit (E13)". The page has 9 requirements and the limit is 6, so nothing was proposed. |
| Did the reader execute? | Yes. It read stored copy `a0ffab81`, the bound page's copy of 2 Nov. |
| Did the source or evidence change? | No. The scheduled job's request `3c06308a` (3 Nov, 5:13 pm AEDT) read the same copy and was refused the same way. No `entry.*` setting has changed since 3 Nov, 9:07 am. |
| Are the two dropped requirements still unresolved? | Yes. Both are `score_without_basis`: the VCE English study scores 20 and 23. |
| Should the original item stay pending? | Yes. Nothing replaced it. |
| What is the correct next action? | Either a row-limit decision for RMIT (Platform Admin; `entry.max_rows_by_provider`, not yet decided), or **Open human input** with the dropped requirements. Another re-read of the same copy would be refused again. |

**Defect (a):** the card showed no acknowledgement, state, time or result. The decision reply carried `event_id` and the result, but the screen only showed it in a passing note at the top. The card had no record of past actions.

**Defect (b):** the recovery panel still offered "Re-read from stored evidence" after the identical refusal. A second click answered "its result is awaited", even though the result was already in.

Both are fixed centrally (§3). The original item stays pending.

## 2. The shared lifecycle (§2) — derived, no new state table

`security.layer4_item_lifecycle_v1(kind, ref)` reads one item, and `security.layer4_items_lifecycle_v1(items)` reads one page in a single call. The screen calls `public.admin_layer4_lifecycle`, which needs Curator or above.

Each item moves through these stages: **Waiting for a reviewer → Accepted or Refused → Scheduled → Running → Completed, Failed (still pending) or Waiting for human input → Verified → Resolved or Superseded.**

The lifecycle reads only records that already exist:

- `admin_control_events` (`inbox_decide`)
- `layer4_aer_recovery_actions`
- `aer_read_supersessions`
- `field_enrich_items`
- `work_items`
- `layer4_interventions` and their events
- each kind's own source row

Six steps are reported separately, so the decision's five distinctions stay apart:

1. **requested**
2. **executed** (the operation ran)
3. **valid** (the extraction passed its gates)
4. **approved** (the Layer 4 decision)
5. **admitted** (rows active)
6. **published** (course and university published)

**Timestamps (§3):** first entered Layer 4, item created, last entered, last updated, last reviewer action, last automatic attempt, next action, decided, admitted and published. All are shown as Australian time with AEDT or AEST, for example "Wed 4 Nov 2026, 12:17 pm AEDT".

**First entry is never reset:**

- For a corrected read, the first entry is taken from the earliest item for the same record and field, following the chain of corrected reads.
- For holds, it is taken from a new column, `enrichment_flags.first_flagged_at`. A trigger keeps it when "Keep waiting" moves `flagged_at` forward.

**Acknowledgement (§4):** every reply to `admin_layer4_inbox('decide')` now carries an `ack` with these fields:

- `outcome`: accepted, refused, queued, already_requested, completed, incomplete or human_input
- `ref` (the audit number) and `at`
- `reason` and `alternative`
- `next`
- `stage`

The card's Progress block reads the same record back after Refresh. It never shows success before the server confirms it.

## 3. Fixed centrally in this change

| # | Shared defect | Fix |
|---|---|---|
| F1 | A click had no visible, lasting result (defect a) | `ack` on every decision reply. A Progress block on every card (`src/Layer4ItemLifecycle.jsx`) shows the stage, why the item is pending, what is next, the times, the steps and the history. |
| F2 | A refused corrected read of an unchanged copy was offered and allowed again (defect b) | `security.layer4_reread_repeat_v1`. Recovery panel: Re-read is not allowed and not recommended, and the refusal and the alternative are shown (`detail_v1`, live `636c1764`). Decide function: the repeat is refused with its reason and recorded (`decide_v1`, live `841234cb`). The read is offered again only when the stored copy changes, `layer4.reader_revision` is raised, or a setting matching `layer4.reread_change_keys` changes. |
| F3 | A duplicate click said "its result is awaited" after the result had arrived | The reply now gives "Already requested: recovery action N at <time>. Now: <current state>", plus the alternative. |
| F4 | "Keep waiting" reset a hold's age | New column `first_flagged_at` with a trigger. Existing raised holds were backfilled from the earlier of `flagged_at` and their first Layer 4 action. |
| F5 | Corrected reads were not linked to the reads they replaced | `predecessor` and `successor` on both items, with their state. |
| F6 | No §10 measures | `security.layer4_lifecycle_report_v1()` (window `layer4.lifecycle_report_days`). |

## 4. The §10 matrix (production, 4 Nov 2026 12:56 AEDT)

**How to read the columns:**

- "Action gap", "Evidence gap" and "Timestamp gap" describe the state **before** this change. The F-numbers say what this change fixes.
- "Recovery works" asks whether a non-Reject path exists that resumes processing.
- "Production verified" covers this change only; it is code-ready and not yet released.

**Pending, 7-day and target columns:**

- *Pending* is the number waiting now.
- *7-day decisions* is the number of Inbox decisions in the last 7 days.
- *Late* is the number older than the 7-day target.

| Review kind | Pending (late) | 7-day decisions | Action gap | Evidence gap | Timestamp gap | Recovery works | Decision works | Production verified |
|---|---:|---:|---|---|---|---|---|---|
| Course link `course_link` | 3,099 (30) | 196 | No ack on the card (F1). "Use" and "Enter" schedule a re-read whose result was not shown. | None. | Card showed age only (F1). | Yes: re-read after Use or Enter. | Yes | No (code-ready) |
| Held scholarship `held_scholarship` | 132 (69) | 787 | **96 items were decided twice** (same ref, two audit rows). | AI re-check quote only. | F1 | Not applicable (decision only) | Yes, but re-raised after decision | No |
| Website needed `website_needed` | 41 (40) | 0 | Onboarding restart had no visible result. The lifecycle now shows the newer onboarding run (F1). | No site candidates shown. | Item time is `updated_at` of the onboarding run, so it moves. The lifecycle shows the first stop (F1). | Yes (onboarding restarts) | Yes | No |
| Too few course pages `too_few_pages` | 129 (124) | 0 | Navigation only ("Add page addresses"). Nothing closes the item from the card. | No count of pages found. | F1 | Only through the builder | Navigation | No |
| Adapter has nothing ready `nothing_ready` | 317 (172) | 0 | Rebuild is rank 5. The rebuild outcome was not shown. | No error or affected course count on the card. | F1 | Rebuild (once) | Yes | No |
| Central pages to approve `central_to_approve` | 3 (2) | 0 | Navigation only. | None. | F1 | Through the builder | Navigation | No |
| Adapter proposal failed `onboarding_failed` | 1 | 5 | Retry outcome not shown before (F1). Repeated retries are not guarded. | Stop reason only. | F1 | Retry | Yes | No |
| Course pages not found `pages_not_found` | 54 (54) | 0 | "Release and try again" has no repeat guard (playbook: at most once). | No list of the pages tried. | Hold age reset by actions (F4) | Release, website or pages | Yes | No |
| Website not answering `site_down` | 0 | 0 | — | — | "Keep waiting" reset the age (F4) | Website change | Yes | No |
| Fee fails the check `fee_check` | 7 | 12 | "Open the course" is navigation. Closure was not shown. | Stored copy shown (v2.15.449). | F1 | Fee re-check route | Yes | No |
| Course not offered `not_offered` | 0 | 0 | — | — | F4 | — | Yes | No |
| Course not on the university's site `not_on_site` | 0 | 0 | — | — | F4 | — | Yes | No |
| Counsellor report `counsellor_report` | 0 | 0 | "Fixed" can be chosen without a saved correction (playbook rule only). | — | F1 | Not applicable | Yes | No |
| Provider left the register `provider_departure` | 7 (7) | 9 | Rank 6 only. | Register evidence not on the card. | F1 | Not applicable | Yes | No |
| No page published: first run `no_page_first_run` | 55 | 49 | None. | None. | F1 | Not applicable | Yes | No |
| Conjoint: first run `conjoint_first_run` | 5 | 12 | None. | None. | F1 | Not applicable | Yes | No |
| Entry requirements (AER) `aer_review` | 605 | 517 | Defects a and b (F1–F3). **81 pending reads have a refused corrected read.** 1 has two refusals on the same copy (RMIT). | Dropped quotations shown. Row-limit cause shown (F2). | F1, F5 | Human input. Re-read only after a real change (F2). | Yes (E13 holds approval) | No |
| Course page needed `course_page_needed` | 82 | 0 | "Search again" outcome not shown before (F1). | Last refused page shown. | F1 | Search again | Yes | No |
| Descriptions `provider_description` (university and course) | 465 | 0 | None (approve as read or reject). | Sentence quotes shown. | F1 | Rejected items are read again after the set wait | Yes | No |
| Human input needed `intervention` | 162 (12 AER source, 150 scholarship coverage) | — | `ok:false` requests were shown but not kept after Refresh (F1). | Four sections (v2.15.463). | Own times. Now on the card (F1). | Yes: validate, then resume | Yes | No |

**Kinds with any gap before this change:**

- **Action gaps:** 12 kinds (course link, held scholarship, website needed, too few pages, nothing ready, central pages, onboarding failed, pages not found, fee check, counsellor report, AER, course page needed), plus Human input needed.
- **Evidence gaps:** 6 kinds (held scholarship, website needed, too few pages, nothing ready, pages not found, provider departure).
- **Timestamp gaps:** all 18 kinds plus Human input needed. No card showed more than its age. F1, F4 and F5 close these.
- **Recovery gaps:** 2 kinds. AER offered a recovery that could not work (F2). Too few pages and central pages can only be recovered through the builder.

## 5. Per-kind exceptions not fixed here

| Kind | Exception | Root cause | Owner | Next checkpoint |
|---|---|---|---|---|
| Held scholarship | 96 items decided twice | The item stays or comes back pending after `admin_scholarship_ai('review_decide')`: either re-raised by the recheck, or a double submit with no idempotency. Not yet traced. | Scholarship workstream (IQ-00264 agent) | Trace one of the 96 (read-only) before v2.15.471. Raise an IQ if it is a re-raise without new evidence. |
| AER (RMIT and the other 80 refused) | The next action needs a person or an authority decision | Row limit 6 (`entry.max_rows_per_course`). Score basis not printed. | Platform Admin (row limit for RMIT); AER review-queue agent (`har_aer_item_generate_v1` raises `aer_read_rows_missing` for reads refused on the same copy) | When v2.15.470 is released: check that its generator raised one item each for the 81, and that none was re-read. |
| Pages not found, onboarding failed, nothing ready | Retry and rebuild have no repeat guard ("at most once" is a playbook rule only) | No equivalent of `layer4_reread_repeat_v1` for the onboarding stop fingerprint | Integration Controller (next Layer 4 change) | Next Layer 4 release: the same approach keyed on `provider_onboarding.stop_reason` and `result`. |
| Too few pages, central pages, fee check, counsellor report | Navigation choices close nothing. The card cannot show whether the work in the destination screen finished. | The destination screens write no Layer 4 audit row | Integration Controller | Next Layer 4 release: write `inbox_decide` with `choice='navigated'` when the destination saves, so the lifecycle shows it. |
| Website needed, nothing ready | No site candidates, error or affected course count on the card | Evidence lives in onboarding `result`, which `items_v2` does not read | Inbox owner (performance agent) | With the next `items_v2` change (no edit here: it is not ours) |
| Input validation refusals (all built-in kinds) | A refused input (a bad URL or a missing reason) raises an error, so it is shown immediately but not kept after Refresh | An exception rolls back, so no audit row can be written. Nothing changed, so the item is accurate as shown. | Accepted as is | None. Recorded here so it is not reported as a gap again. |
| Website not answering, not offered, not on site, counsellor report | No pending items to verify on production | — | Integration Controller | Verify with the first new item after release. |

## 6. §8 downstream processing

| After | Next stage | Connected? |
|---|---|---|
| AER corrected read, complete | New item, ready for review | Yes. The reader supersedes the old item in the same transaction (D-R2). |
| AER corrected read, refused | Human input or authority | **No automatic next step before v2.15.470.** The review-queue generator raises `aer_read_rows_missing` for reads refused on the same copy. Row-limit cases need the Platform Admin. |
| Official URL supplied (intervention) | Validate, then run the reader | Yes (v2.15.463 handlers) |
| Fee corrected (Open the course) | Catalogue saved, then projection verified | Partly. The tuition publication repair (v2.15.459) runs. The card closure is not linked (§5, navigation row). |
| Scholarship eligibility confirmed | Governed admission, then publication check | Yes (v2.15.460 and v2.15.467). The duplicate decisions are open (§5). |
| Adapter repaired (builder) | Qualify, then process sources | Navigation. Onboarding continues by itself. The card is not linked (§5). |
| Counsellor correction saved | Verify and close the report | Manual ("Fixed" after the save). The playbook rule is not enforced (§5). |

The one shared gap is that a refused corrected read leaves the item with no next step. It is closed by the combination of F2 (no wasted repeat; the alternative is shown) and the review-queue generator (v2.15.470). No second mechanism is built here.

## 7. Measures (§10), first production values (12:56 AEDT)

| Measure | Value |
|---|---|
| Waiting items | 5,002 over 15 kinds with items (plus 162 Human input needed) |
| Re-entered pending items | 161 |
| Late (over the 7-day target) | 498 |
| Human input needed | 162 |
| Corrected reads refused, items still pending | 81 |
| Repeated no-yield reads (same copy, refused again) | 1 (RMIT) |
| Duplicate decisions | 96 (held scholarship) |

From release, `security.layer4_lifecycle_report_v1()` reports these over `layer4.lifecycle_report_days`:

- entered and re-entered
- waiting for a person or for technical recovery
- actions by outcome
- automatic resumptions
- verified admissions and publications
- repeated no-yield reads

## 8. Observation 13:00 (re-read transparency), RMIT verified values

| Field | Verified value |
|---|---|
| Review item/reference | `a7849f66-bfa7-412e-b26e-4fecc7fdaa6e` (`course_entry_first_read`); provider `8e1adb6c`, course `b365fde8` |
| Original entry time | Thu 29 Oct 2026, 12:44 pm AEDT (kept: no re-read or "Keep waiting" resets it) |
| Re-read request time | Wed 4 Nov 2026, 12:17:46 pm AEDT; Platform Admin; audit event 28863; recovery action 1 |
| Operation ID | Request `d05725e2`, enrich item 270218, job `8fb3173c`; attempt 2 (attempt 1 was the scheduled job's request `3c06308a`, enrich item 265315, 3 Nov 5:13 → 5:14 pm AEDT) |
| Started/completed | 12:17:46.99 → 12:18:11.95 pm AEDT; one attempt; US$0.0063; stored copy `a0ffab81` |
| Actual outcome | "Ran but reproduced the original error". The reader refused: over row limit, 9 requirements and a limit of 6, nothing proposed (E13). It did not fail silently, was not deferred and was not deduplicated. The click was handed to the server correctly; the missing piece was the feedback on the card. |
| Current E13 reason | 2 dropped requirements (`score_without_basis`: VCE English study scores 20 and 23), so the read is incomplete |
| Next permitted action | Open human input with the dropped requirements, or a row-limit decision for RMIT (Platform Admin). Re-read is not offered again until the copy, the reader or a read setting changes. |

**What the card now says:**

- Last recovery: "Attempt 2: Recovery completed — still held under E13".
- History, with operation, reader times and stored copy on each read:
  - "Recovery queued — 12:17 AEDT"
  - "Recovery completed — still held under E13"
- A second click answers "Recovery refused — unchanged evidence and reader", with the alternative.

**Delta coverage (13:00 §2–§6):**

- **§2 transitions:** each one carries attempt, operation (request, enrich item, job), reader start and completion, original and replacement read, re-entry time, provider and course.
- **§3 wording:** the six headlines are chosen on the server (`security.layer4_recovery_headline_v1`, `security.layer4_ack_headline_v1`). The same words appear on the reply and, after Refresh, from the audit row. A reviewer's re-read has no daily cap of its own. "Deferred" is shown only when an existing gate refuses for a cap, a budget or the AI limits; no new cap was added to the reviewer's path.
- **§4 summary:** first entered, status, last reviewer action, last recovery and its result, next step, and time waiting. Event history expands below.
- **§5 reconciliation:** while a recovery is queued or running, the card reads its progress again (`layer4.lifecycle_poll_seconds` 15, `layer4.lifecycle_poll_max` 40). When it settles, the card, its recovery detail and the counts refresh. A replacement read is linked with whether it is complete, and opens as its own card. Approve is still enabled only by the E13 and D-R3 gates.
- **§6 repeated clicks:** a repeated `reread_stored` while a corrected read or course read is queued or running returns that request, whoever asked for it. A repeated `request_evidence`, `open_intervention` or `ai_analyse` while a Human input needed item is open returns that item. Nothing new is started.

## 9. Mandate 16:32 §2, §7, §8: operational groups and the kind-audit gaps

**Build:** Pilot branch `cf247-l4-operational-groups`, migration `20261104560000`, spec `s283`, fixture `tests/fixtures/l4-operational-groups` (G1–G8). Production read-only, 17:11–17:27 AEDT.

### 9.1 The four groups (one shared server function, `security.layer4_groups_v1`)

| Group | Shown as | What puts an item there |
|---|---|---|
| A — automatically resolvable | Counts and their rule only | An existing authorised rule covers it, named on the item. Review items: the platform resolution rules (`security.layer4_reconcile_v1`: repeat, decided before with no new evidence, already active, record retired); switch `layer4.reconcile_supersede_on` is **off**, so these still wait for a person until the Platform Admin switches it on. Official links: the Course Link classifier `security.course_link_route_class_v1` (migration 570000: Decision 263 rules, Decision 179 conversion, the resolution rules). |
| B — technical recovery | "Technical recovery" | Readiness `technical_blocked` (completeness gate, invalid link, manual lock); adapter nothing ready, proposal failed, site down; Human input needed items being analysed or resuming. |
| C — human decision | "Ready for my decision" | Readiness `judgement_ready`; protected decisions (held scholarships, fees, archive, departures, descriptions, first runs). |
| D — human information | "Information needed from me" | Website, pages or a document needed; course page needed; Human input needed items awaiting input; held AER reads with an open Human input needed item. |

No new admission authority: the classifier and the screen read decide, supersede and admit nothing (s283 checks there is no write in them; the post-check refuses an A item without its rule). Kind defaults are a setting (`layer4.group_by_kind`); Course Link routing can be switched off (`layer4.groups_course_link_router_on`).

**Production at 17:16 AEDT** (the same logic as a read-only query; the Course Link classifier was not yet live, so official links are counted by readiness here and will move to the Course Link classes on release):

| Kind | A | B | C | D |
|---|---:|---:|---:|---:|
| Course link | 280 (252 already active, 28 retired) + 27 Decision 263 pattern | 64 (59 invalid link, 5 manual lock) | 2,728 | — |
| AER | — | 257 (completeness gate) | 331 | 17 (open human input) |
| Descriptions | — | — | 666 | — |
| Held scholarship | — | — | 132 | — |
| Adapter nothing ready / proposal failed | — | 318 | — | — |
| Too few pages / pages not found / website needed | — | — | — | 224 |
| Course page needed | — | — | — | 88 |
| First runs, fee checks, central pages, departures | — | — | 77 | — |
| Human input needed | — | — | — | 201 |
| **Total** | **307** | **639** | **3,934** | **530** |

### 9.2 Each card answers the six §7 questions

The Progress block (v2.15.471) now also carries the group and "Person needed" (`no: an existing rule may settle it`, `not yet: the platform is recovering it`, `yes: a decision`, `yes: information only a person can give`), and "What the platform holds" (expandable). Why it is in Layer 4, what the platform has done, what moves it forward, first entered and last changed, and whether an earlier action worked were already there.

### 9.3 §8 gaps

| Gap | Root cause (production) | Shared fix | Status |
|---|---|---|---|
| 96 held scholarships decided twice | One decision sent twice about 3 s apart (batch L4B-20261030-1138). The first reply was the scholarship screen's status and the item stayed waiting; the second applied it (`decided_at` is the second audit row). One effect, two audit rows, the first not saying it had not applied. | Every Inbox decision records `still_waiting`; a decision that left the item waiting is acknowledged "Still incomplete" and never counted as done. The same decision on the same item within `layer4.duplicate_decision_seconds` (120 s) returns the first one (audited as `inbox_refused`). A decided item already refuses another. | Fixed (G4, G4b) |
| Retry guards (onboarding, page recovery) | Retry, rebuild and release were repeatable on an unchanged stop. | `layer4.once_only_choices` (retry, rebuild, release): refused with the reason and the alternative ("Not tried again — the same stop, nothing changed") when the same choice was already taken for the same university and the university has not changed since. | Fixed (G5) |
| Navigation-only choices | No audit row. | `public.admin_layer4_navigate` records `inbox_navigate`. The card shows "Opened the adapter builder — 17:20 AEDT: the item closes when the work there is saved", and later the item's own closing time. | Fixed (G6) |
| Evidence on provider and adapter cards | The evidence is in `provider_onboarding.result` and the hold's evidence, which the Inbox list does not read. | `security.layer4_card_evidence_v1` covers website, active courses, pages read, AI attempts, why each field is held, runs stopped the same way, how pages were looked for and the next automatic check. `items_v2` is not edited. | Fixed (G3) |
| Re-raised reviews after a valid decision | The readiness check already classifies them (`platform:decided_before`), and the arrival guard and reconcile switches are off. | The card names the earlier decision and the rule that may settle it. A group A count is shown. Switching `layer4.reconcile_supersede_on` and `layer4.arrival_guard_on` on is a Platform Admin decision (no new authority is taken here). | Visible; settling awaits the switch |
| Human input that doesn't resume | **No production case:** 198 interventions are awaiting input, with 0 given input and not resumed. | Group B shows the item while it resumes. The existing resolve and resume handlers are unchanged. | Verified (G7); monitor after first input |

### 9.4 Checkpoints

**Performance (s273 budget):**
- The groups read the whole waiting list once (`security.layer4_inbox_items_v2`, no detail). On production at 17:26 AEDT that list alone took **1.93 s for 5,213 items**; it was 0.26 s on 4 Nov 08:16.
- The three-choice bar loads on its own, so the Inbox's first read is unchanged.
- A group page costs the same as one classification plus one page of cards.
- The Course Link classifier adds one call per official link (2,958).
- **Checkpoint:** measure both on production at the first release window after 570000 and 560000.
- **Fallback if over budget:** store the group with the readiness classification (job `layer4-readiness`), or set `layer4.groups_course_link_router_on` to 0.

**Settling group A:**
- 280 review items are covered by the platform resolution rules, which are switched off.
- Switching them on needs a separate Platform Admin decision (§9 of the mandate): the expected effect is about 280 fewer reviews; the rules supersede only and are reversible by the Platform Admin.
- **Owner:** Integration Controller.
