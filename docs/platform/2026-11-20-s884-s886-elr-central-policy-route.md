# English language requirements from central English pages: `elr-central-v1.0`, the governed policy route and the sweep (s884 to s886)

**Session:** S1-ELR-Central · **Platform Admin decision:** 20 Nov 2026 22:07 AEDT ("Decision approved: Yes — populate the remaining Table 1 English gaps from each university's central English requirements page via the governed provider English policy route, using $0 AI and $0 Firecrawl spend over already-stored pages") · **Change control:** CF-CHG-20260915-247 · **Pilot:** #1439, migration `20261120220000` · **Spend:** US$0

This lane covers English language requirements only.

## 1. Audit (live, rolled back, 20 Nov 2026 22:10 to 22:40 AEDT)

Table 1 holds the active AU, NZ and CA courses that have no active English requirement but do have a stored course page bound. At the time of this audit it was **6,160 courses on 792 providers**.

| Group | Providers | Courses | What it means |
|---|---:|---:|---|
| Approved central English policy | 115 | 1,829 | None of these was waiting to cascade (0 plan outcomes of "write"). They are held because the level is not covered (VET, certificates, non-AQF: 1,173), there is no research requirement (362), there is no default for the level (266), the course is named in the policy (186), or it is a double degree or exit award (61). |
| Central reading waiting for a person | 15 | 648 | Governed approval is pending in Universities › English. |
| Stored central page, reading found no values | 69 | 1,051 | The page is stored, so it can be read at $0. |
| Central page found, not stored | 70 | 346 | Needs Firecrawl, so it is outside this $0 lane. |
| No central page | 523 | 2,286 | Needs page discovery. |

Table 1 by level: diploma 1,276; certificates (all) 1,441; non-AQF 514; advanced diploma 352; bachelor (incl. honours and associate) 615; postgraduate coursework 1,168; research 511; school and short courses 237; unknown 44.

## 2. Reader `elr-central-v1.0` (s884)

The module is Pilot `supabase/functions/coverage-sweep/elr-central-reader.ts`, used by the read-only worker mode `elr_central_read`. It uses the `elr-det-v1.0` test reader (IELTS, TOEFL iBT, PTE Academic with decimals kept, OET, CELPIP, Cambridge C1/C2).

- **Tiers:** undergraduate, postgraduate coursework, higher degree by research, and VET and diploma. A graduate diploma or certificate counts as postgraduate, not VET.
- **Strict tiers:** a value goes to a tier only when its line, its table row or the heading it sits under names that tier.
  - A line that names two tiers is split into clauses, one per tier.
  - "All courses" means undergraduate and postgraduate only.
  - A value with no tier context is not used.
- **Conflicts:** two values of one test for one tier are a conflict. That test is left out of the tier and reported.
- **Not used as a default:**
  - Regulated disciplines (nursing, midwifery, medicine, allied health, teaching and education, law, social work) are reported as `discipline_higher`.
  - Lines that name a specific award are skipped.
  - Pathway, foundation and ELICOS lines are ignored.
- **Tables:** a test table is read row by row, and each row line is that value's verbatim quote.

## 3. The governed route (s885)

- **One proposal per university.** `security.elr_central_record_v1` merges a university's stored central pages into at most one `english_policy` proposal (parser `elr-central-v1.0`, status `proposed`).
  - It holds **only the tiers the university's approved policy does not already give**, so an approved policy is never replaced.
  - It carries that policy's named courses and exceptions, so the plan still holds those courses.
  - It records the conflicts and the regulated disciplines.
- **Approval is the existing route.** `security.policy_auto_approve_v1` (job `policy-auto-approve`) now also approves an elr-central reading when all of these are true:
  - setting `central.auto_approve_elr_central` is 1;
  - the reading has no conflict;
  - no other reading for the university is waiting for a person;
  - the existing course-page disagreement check passes (no more than 50% of at least 10 compared courses disagree).

  Otherwise the reading waits in Universities › English for a person.
- **Plan** (`security.provider_english_plan_v1`):
  - A VET, diploma or certificate course takes the policy's `vet` default only when the policy states one. Without one it is held as before.
  - A course of a regulated discipline the page gives higher bands for is held ("regulated discipline (…)").
  - The existing rules keep tiers strict: an undergraduate default never applies to a postgraduate course.
  - The existing outcome rules keep it insert-only: a course with any row, a manual lock or a pending review is never written.
  - The plans of the 8 largest existing policies are compared row for row before and after the change, and must match.
- **Apply:** the existing `security.provider_english_apply_v1` writes the rows. Its note now names the "VET and diploma" tier.

## 4. The sweep (s886)

No new cron job is added, so the active job count does not change. Each 5-minute run of `elr-det-sweep` now also:

1. reads back the central-page answers and records them;
2. if no central call is open, sends the stored central pages of the next `batch.elr_central` universities (6). The claim finds 604 pages for 263 universities;
3. applies `elr_central.apply_per_run` (2) approved elr-central policies, oldest first, and applies each again after `elr_central.reapply_hours` (6);
4. sends each regulated-discipline hold to Layer 4 (`course_english`, up to `elr_central.l4_per_run`, 50), with a plain reason and the central page's quote.

`security.provider_english_apply_all_v1` (job `provider-english-defaults`) skips elr-central policies, so that run's time does not grow with them.

**Settings:** `elr_central.on`, `batch.elr_central`, `elr_central.apply_per_run`, `elr_central.reapply_hours`, `elr_central.l4_per_run`, `central.auto_approve_elr_central`.

**Status:** `security.elr_det_status_v1()` → `central`, read with workflow `elr-det-read.yml`.

## 5. Guardrails

- **G1:** no new job; the catalogue line for `elr-det-sweep` is updated.
- **G2:** six settings.
- **G3:** 75/48, checked before and after. No public object was added.
- **Locks and cron jobs:** manual locks and the active cron count are compared before and after.
- **Functions:** every replaced function is md5-checked against its live text first.
- **Spend:** US$0.
- **Nothing dropped or deleted.**

## 6. Validation before merge

- **Specs:** s884 7 of 7, s885 and s886 6 of 6. s42, s57, s120, s840 to s842 and the AI-models spec pass.
- **Rolled-back live dry run** of the final file passed.
- **Smoke test** in a rolled-back transaction:
  - one proposal was recorded for a university with no policy;
  - the auto-approve refused it on the course-page disagreement check (the values were synthetic), which shows that gate holds;
  - its plan wrote VET (diploma, advanced diploma) and undergraduate defaults by tier;
  - one sweep run took 1.1 s.

## 7. After merge (closing record)

(Filled in by the closing record.)

## 8. Comments and replies
