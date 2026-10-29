# Five adapter drafts stuck in "capturing": reconciliation

Lane N, CF-247, 30 Oct 2026. Read-only reconciliation against project `fxcwkweaxjtknorudmwp`, done at about 07:00 to 07:15 AEDT on 30 Oct. The paste is `STUCK-DRAFTS-PASTE.sql` in the same folder. **It has not been run.** It is a separate operator action for the Platform Admin.

## Where the drafts live

- **Table.** `pipeline.uni_adapter_drafts`. Columns: id, provider_id, status, samples, captures, marks, comments, proposals, model, model_profile, cost_usd, reason, created_by, created_at, updated_at. It has no status check constraint and no triggers.
- **Writers:**
  - `public.admin_adapter_builder`: `start` creates a draft as `capturing`, and `propose` sets `proposing`.
  - `public.svc_adapter_draft_record` (worker callback): `capture` sets `captured`; `proposal` sets `proposed`; `error` sets **`error`** and appends `{at, kind:'error', model, cost, ...}` to `proposals`.
  - `security.provider_onboarding_step_v1` treats a draft as failed when it is `error` or has been `capturing` for more than 30 minutes. It then stops the onboarding with `capture_failed`.
- **Statuses in use now:** proposed 696, captured 533, **capturing 24**, error 19, proposing 2. There is no "superseded" or "abandoned" status.
- **Rows that reference a draft:**
  - `pipeline.provider_onboarding.draft_id`: the current draft of each onboarding run.
  - `pipeline.provider_onboarding_events.draft_id`: history.
  - `pipeline.adapter_autobuilds.draft_id`.

## The five drafts

All five were created by the onboarding step (created_by `63ba56cb…`). At reconciliation each had `updated_at = created_at`, captures `[]`, proposals `[]` and cost US$0. They were never touched after creation, and no money was spent on them.

| Draft | Provider | Created (UTC / AEDT) | Reason | Samples | What happened to the capture call | Onboarding events | Later draft, same provider | Referenced by |
|---|---|---|---|---|---|---|---|---|
| `5c8a27a6-0ab7-4d5d-9d56-4780acb2b69f` | Vardhan Institute of Management and Technology (`150489ef…`) | 27 Oct 16:46 / 28 Oct 03:46 | Onboarding: capture sample pages | 6 | No capture call reached the worker within 30 min. Function logs show no adapter-capture call, a 79-byte request, between 16:46 and 17:16 apart from another provider's draft. | 88926 capturing | `6780a06b` (30 min later, "again"). Also stuck. | events only |
| `6780a06b-0d3d-45c2-918a-e4bcc379300b` | Vardhan Institute (`150489ef…`) | 27 Oct 17:16 / 28 Oct 04:16 | Onboarding: capture sample pages again | 6 | The edge runtime returned **502 after 73.3 s**, with no worker version, at 17:17:16 UTC. The worker died mid-capture. | 88955 capturing; 88962 **stopped / capture_failed** (17:47) | **None.** This is the provider's newest draft. | **onboarding `bebba11a…` (stopped, capture_failed)**; events |
| `957b620b-dd36-474d-af23-191ac12804c3` | Australian Institute of Business and Technology, Sydney International School (`6a6b10a5…`) | 27 Oct 20:58 / 28 Oct 07:58 | Onboarding: no field passes; the AI proposes again | 6 | No capture call reached the worker within 30 min. There is also a function-log gap for the whole 20:59 UTC minute. | 89091 capturing | `4563a4d7` (30 min later). Also stuck. | events only |
| `4563a4d7-1b08-4da8-a441-679c91a5c272` | AIBT / Sydney International School (`6a6b10a5…`) | 27 Oct 21:28 / 28 Oct 08:28 | Onboarding: capture sample pages again | 6 | No capture call reached the worker within 30 min. | 89102 capturing; 89128 **stopped / capture_failed** (21:59) | **None.** This is the provider's newest draft. | **onboarding `e6adac11…` (stopped, capture_failed)**; events |
| `6a3ee319-267b-4b42-92a8-6a603e53f3e1` | Kulin Institute (`43c9cabe…`) | 29 Oct 12:10 / 29 Oct 23:10 | Onboarding: capture sample pages | 3 | The edge runtime **refused the call with 503 after 10.1 s** at 12:10:15 UTC. This was during the evening edge degradation (see `CAPACITY-ASSESSMENT.md` §3). | 92005 capturing | **Yes.** `979045dc` (12:40 UTC) captured and proposed. `47038c28` (12:54) proposed. Onboarding `300a05c6…` then stopped `nothing_ready` (no field passed after 2 AI attempts). | events only |

**References.** Seven onboarding events point at these drafts (88926, 88955, 88962, 89091, 89102, 89128, 92005). Two onboarding rows still name a stuck draft as their current draft, and both are already **stopped** with `capture_failed`. No onboarding row in an active step references any of them. No `adapter_autobuilds` row references any of them.

## Why this needs fixing, not just tidying

`public.admin_adapter_builder` refuses to start a new capture when a provider's **newest** draft is `capturing` or `proposing` ("the current samples are still being captured or proposed; try again in a…"). Two providers are blocked by these drafts:

- **Vardhan Institute.** Its newest draft is `6780a06b`, which is stuck. No new adapter capture can start until it is closed.
- **AIBT / Sydney International School.** Its newest draft is `4563a4d7`, which is stuck. Same block.
- **Kulin Institute is not blocked.** Its newest draft is `47038c28` (proposed). Its stuck draft only appears as noise on the "capturing" count.

## Governed end state

**`status = 'error'`.** This is an existing value, written today by `svc_adapter_draft_record` when the worker reports a failure.

Why `error` and not something else:

- The schema has no superseded or abandoned status, and the mandate rules out a new one.
- `captured` or `proposed` would be false, because nothing was captured.
- `error` is the honest record: the capture was attempted and did not finish.
- The onboarding step already treats `error` the same as a capture that timed out. Both onboarding rows involved are stopped, so nothing restarts automatically.

To match how the worker records an error, the paste appends one entry to `proposals`: `{at, kind:'error', model:null, cost:0, error:<plain reason>, source:'CF-247 paste cf247-stuck-capturing-20261030 …'}`. The reason text depends on the evidence:

- **6780a06b:** 502 after 73 s.
- **6a3ee319:** 503 after 10 s.
- **The other three:** the call never reached the worker.

Not changed: captures, samples, cost, reason, comments, onboarding rows and events. Nothing is deleted.

## The paste in brief

The whole paste is one transaction. Any failed check rolls everything back.

**Preconditions.** Each one raises an error if the state differs:

- **a.** Exactly 5 rows with these ids: all `capturing`, captures and proposals `[]`, cost 0, `updated_at = created_at`, and created more than 1 hour ago.
- **b.** The row snapshot md5 equals `b8e5c62ac9612834d8d56037b158fac4`, taken at reconciliation.
- **c.** All 5 draft-to-provider pairings match the table above.
- **d.** 0 onboarding rows in an active step reference them, and exactly 2 stopped `capture_failed` rows do.
- **e.** 0 `adapter_autobuilds` references.
- **f.** The audit row is not already present, so the paste cannot be run twice.

**Writes:**

- 1 `pipeline.admin_control_events` row: area `toolsets`, action `adapter_draft_close`, target `cf247-stuck-capturing-20261030`, actor Platform Admin `63ba56cb…`. The detail holds the reason, count 5 and the 5 before-images.
- `UPDATE 5`. Each draft becomes `error`, with one appended error entry and `updated_at = now()`.

**Post-checks:**

- Exactly 5 drafts are `error`, each with exactly 1 entry from this paste. Captures and cost are unchanged.
- 0 of the 5 are still capturing.
- Exactly 1 audit row exists, with count 5 and 5 before-images.
- Neither blocked provider's newest draft is `capturing` or `proposing`.
- There are still exactly 7 onboarding events on these drafts.
- A notice reports how many drafts are still capturing overall. Expected: **19**.

**Expected output:**

```
NOTICE Preconditions passed
INSERT 0 1
UPDATE 5
NOTICE Post-checks passed … 19
COMMIT
```

**Rollback.** This is a separate block, commented out in the file. It runs only if the 5 rows are still exactly as the paste left them. It restores `capturing`, `proposals = []` and `updated_at = created_at`, writes an `adapter_draft_close_rollback` audit row, and proves the result matches the original snapshot md5 `b8e5c62a…` byte for byte.

**Checks done before handing this over:**

- Both the paste and the rollback parse, including the PL/pgSQL blocks (pglast 8.7).
- Every precondition was run as a read-only SELECT against live: a = 5, c = 5, d = 0 active and 2 stopped, e = 0, f = 0 prior audit rows.
- A simulated update returned 5 rows passing check 4a.
- Precondition a first used "older than 24 h", which would have excluded the Kulin draft (created 29 Oct 12:10 UTC). It was corrected to 1 hour before handover.

## Out of scope, for the Platform Admin

- **19 more drafts are stuck in `capturing`**, the oldest from 5 Oct. They include two earlier drafts each for Vardhan (`b3706ae1`, `1c62e452`, 12 Oct) and AIBT (`e740bc24`, `3c16ecf6`, 12 Oct). There are also 2 stale `proposing` drafts (12 and 21 Oct). The same paste pattern applies if the Platform Admin wants them closed. They do not block anything, because none is a provider's newest draft. I did not check that for each of the 19.
- **Root cause.** Nothing marks a draft failed when the capture call is refused or lost. The onboarding step only stops its own run after 30 minutes and leaves the draft as `capturing`. A lasting fix would let the onboarding step's existing time-out also write `error` to the draft, through the same `svc_adapter_draft_record` shape. That needs a decision (W30 calls edge failures "external, not coded around").
- **Next step for the two blocked providers.** Once the paste has run, Vardhan and AIBT can be re-captured from Onboarding. That is a separate action, and nothing restarts automatically.
