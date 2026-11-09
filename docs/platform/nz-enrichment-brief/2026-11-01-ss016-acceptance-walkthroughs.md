# SS-016 acceptance walkthroughs (1 Nov 2026)

**Direction:** Platform Admin 1 Nov 2026 21:02 §3. **Live release:** v2.15.395 (Pilot `73f46d1a`, PR #787), checked from 21:18 AEDT.
**Role used:** Platform Admin (rank 6), the only account this session holds. Every write-path step was either read-only or a real Layer 4 decision already made under the v5 playbook. No production data was changed to demonstrate a test.
**Rule:** a finding is **Accepted** only when every acceptance criterion in the usability review has passing evidence. "Pass (partial)" means the tested criteria passed and at least one criterion still lacks evidence.

| Finding | Expected behaviour (review "Accept") | Actual result | Evidence and destination | Verdict | Defect / next action |
|---|---|---|---|---|---|
| UR-01 Alert guidance | Guide and Health agree on delivery mode, timing, acknowledgement and recovery; raised, delivered and receipt-confirmed explained separately | Guide › Alerts (push and e-mail): "about 75 minutes"; "Delivered means sent, not read"; no Mailgun or on-screen-only text. Platform health: "External delivery: On: by the alert scheduled task"; last delivered 31 Oct 11:00 pm; 3 delivered in 7 days ([TEST] alert and recovery) | Live `#platform-guide`, `#platform-health` | **Pass (partial)** | The receipt confirmation of the delivered test alerts is still open (SS-014, 2 Nov). Accept once it is recorded |
| UR-02 Role boundaries | Rank 4, 5 and 6 walkthroughs match the server boundary; a denial names the next owner | The guide and SOPs state Operator diagnoses/records/escalates, PIM Admin paces/pauses, Platform Admin for automations marked Platform Admin. Live `security.admin_automation_control_v1` md5 `71951aa2`: the rank-5 floor's refusal now reads "PIM Admin role or above required … A Pipeline Operator records the issue and raises it with the PIM Admin"; the per-automation `control_rank` check is unchanged | Live definition; migration `20261101090000` (history md5 = file md5 `1b75ffee`) | **Insufficient evidence** | Rank-4 and rank-5 sessions are needed for the walkthrough. This session has none, and it does not enter credentials. Needs a Pipeline Operator and a PIM Admin user to run the two checks (refused / allowed) |
| UR-03 SOP mirrors | A stale mirror is detected; both copies regenerate identically; cross-repo conflicts fail clearly | `--check-mirror` on the Admin copies: both "same", exit 0. A deliberately edited copy: "differs … from line 20 … content-sha256 does not match", exit 1. Admin mirrors synchronised (provenance `90b5c088`, reviewed release 2.15.395) | Admin `docs/sops/`; scratch stale copy | **Pass (partial)** | Cross-repo write conflict not exercised (the copy is a git commit; a conflicting push fails at git). Accept after one conflict rehearsal |
| UR-04 Traversal beyond 200 | More than 200 mixed items all reachable exactly once; concurrent changes cause no starvation or duplicates | AER 539 of 539 in 3 pages; "Adapter has nothing ready" 316 of 316 in 2 pages; 0 duplicates; Next disabled at the end | Live `#layer-4-review?kind=…` | **Pass (partial)** | The concurrent-arrival case was not exercised live. Covered only by the v2.15.391 fixture spec. Accept after a pass that runs while decisions are being saved |
| UR-05 Evidence and corrections | Prove a decision from held evidence; finish linked corrections without external acquisition | Course link: 66 of 66 cards with Stored copy and Open the course record; Stored copy opens the evidence drawer (Burman, read 25 Oct); 31 fee checks show the proposed fee | Live `#layer-4-review?kind=course_link` → `#evidence?evidence_id=…` | **Pass (partial)** | "Finish linked corrections" is a write. Not exercised. Accept on the next real correction |
| UR-06 Verified outcome | Every choice route shows a verifiable outcome | 21 AER approvals at 19:47–19:52 each showed "Admitted · rows N active · decision · audit #"; database read-back 57 rows Active, 0 other. Fee admissions (#27786, #27799–27801) and course-link keeps (#27654–27659) earlier the same day matched the database | Batch checkpoints 3, 9; `pipeline.layer4_decisions`, `catalogue.course_entry_requirements`, `catalogue.course_fees` | **Accepted** | None |
| UR-07 Retired jobs | Retired jobs cannot be resumed by single-job or area controls; paused active jobs stay recoverable | 3 retired jobs (`l4-rule-low-agreement`, `cron-history-retention`, `cron-history-trim`) show "Retired: replaced by …" and no controls; active jobs keep Resume. Live function excludes `retiring`/`retired` jobs from area resume | Live `#scheduled-jobs`; `security.admin_automation_control_v1` | **Pass (partial)** | A real resume attempt on a retired job was not made: it would change production if the guard failed. Fixture spec s203 covers it. Accept after a fixture-environment rehearsal |
| UR-09 Deep links | Task links land at their destination; old bookmarks resolve | **v2.15.394: Fail.** Back from a university to the same kind kept the university's items. Fixed in v2.15.395. Live 21:19: kind 66 → university 11 → Back 66, no reload. A kind change and a provider change work without a reload | Live; spec s204 (new test fails without the fix) | **Pass (partial)** | Old external bookmarks were not re-checked in this pass. Accept after the bookmark list is replayed |
| UR-13 Migration checks | Absent applies once; identical skips after comparison; changed same-version fails before execution; error cases reported | Fixture tests in the full suite (s203) pass: 1,355 passed, 0 failed, 0 skipped. Live: migration `20261101090000` applied once by Deploy on merge; history md5 equals the file | `scripts/ci/apply-migration.sh`; `supabase_migrations.schema_migrations` | **Accepted** | None |
| UR-17 Specialist guides | Each role finds its top tasks; AER instructions match the choice contract and D4 | Guide › Specialist tasks: 7 tasks, each with lowest role, source, saved evidence, escalation and document reference. All 7 Open buttons land on their screens (entry requirements ×4, courses, Layer 4 Review, Platform health). The SOP AER item names Platform Admin only and the three current choices | Live `#platform-guide` | **Pass (partial)** | Walkthrough only as Platform Admin. Each role's view needs rank 1–5 sessions |

**Result:** 2 accepted (UR-06, UR-13). 7 passed in part, awaiting one named criterion each (UR-01, UR-03, UR-04, UR-05, UR-07, UR-09, UR-17). 1 insufficient evidence (UR-02, which needs lower-role sessions). UR-09 failed on v2.15.394 and was fixed in v2.15.395.

## Overnight addendum (1 Nov 2026 23:50): role fixtures and releases v2.15.396 and v2.15.397

**Six roles:** these are fixture journeys (s207, mocked server using the live refusal texts), **not live lower-role sessions**. Server boundaries were verified from the live definitions (static).

| Role | Fixture result | Live result |
|---|---|---|
| Viewer (1) | Pass | Not run: no session |
| Counsellor (2) | Pass for navigation; insufficient for shortlist and report (no shortlist on the server; reports arrive from Zoho only) | Not run |
| Curator (3) | Pass (after fix D1) | Not run |
| Pipeline Operator (4) | Pass | Not run |
| PIM Admin (5) | Pass (refusal now names the owner: v2.15.397 migration `20261101110000`) | Not run |
| Platform Admin (6) | Pass | **Pass**: live walkthroughs earlier the same day; v2.15.397 "Read again" opens Sources, reads and holds, and course-link choices are enabled at rank 6 |

**Findings updated (fixture evidence added; acceptance still needs the named live criterion):**

| Finding | Added evidence | Still missing |
|---|---|---|
| UR-04 | s208: 450 items, 40 arrivals and a decision partway through; 0 duplicates; nothing starved (fixture) | A live pass while decisions are saved |
| UR-07 | s209: single and area resume refused on retired jobs; a paused active job resumes (fixture) | A rehearsal against a real database (only a fixture so far) |
| UR-09 | s210: 97 old addresses at every rank; Back and Forward (fixture); live Back fixed in v2.15.395 | Live replay at lower ranks (needs sessions) |
| UR-17 | s211: destinations at every rank; handoffs; G1–G3 fixed in v2.15.397 | Live views at ranks 1–5 |
| UR-02 | Fixture refusals and allowances at ranks 4–6; both refusal messages now name the next owner (v2.15.395 and v2.15.397) | **Live rank-4 and rank-5 sessions** |
| UR-03 | Conflict rehearsal: a stale push is refused (non-fast-forward); `--check-mirror` detects drift | Gap: a stale writer who pulls first, then exports an older source, is accepted. The proposed ancestor guard is not built yet |

**Status:** accepted 2 of 17 (UR-06, UR-13; unchanged). UR-08, UR-10, UR-11, UR-12 and UR-16 are implemented (v2.15.396), so 13 are now implemented and awaiting acceptance. UR-14 and UR-15 are investigation only, and 2 are not implemented.

**Decisions for the Platform Admin raised by the fixtures:**
- **P1:** the guide says a Curator decides Layer 4 items and "Website needed", but the server needs rank 4 for every Inbox choice.
- **P2:** the guide promises Counsellor shortlists, which do not exist.
