# M2.4.7 CURRENT STATE

**Status:** ACTIVE — END-TO-END AUTOMATED ADMISSION GAP IS THE PRIMARY DELIVERY TARGET  
**Opened:** 2026-09-15 AEST  
**Accepted Pilot baseline:** `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 paused until M2.4.9 GO  
**Primary programme authority:** `docs/coursefinder-end-to-end-automated-data-admission-roadmap-v1.0.md` / `CF-CHG-20260915-247`

## Accepted predecessor

M2.4.6 / CF-246 is CLOSED / PASS / FROZEN. Active Layer 2 starts are idempotent and bounded `schedule_remaining=false` requests dispatch exactly one wave.

## Admission-first baseline

Existing accepted CF-245 paths increased website/Search official-course-URL coverage to **527** after 122 canonical/Search changes. Intake coverage is 487, English 520 and provider-current tuition 161. Website v3.1 consumes the admitted data now; it does not wait for complete enrichment.

## RMIT controlled-scale result

Request: `f120fb4b-ec69-4f2c-8147-550a338c6f3d`  
Batch: `13f33fcf-05b9-4379-b214-cf4760bbe1f3`  
Scope: RMIT university  
Route: managed  
Wave size: 25  
Schedule remaining: false

Terminal runtime outcome:

- 25/25 processed;
- 0 resolved deterministically in Layer 2;
- 25 marked/escalated `layer3_required`;
- 0 blocked;
- 25 vendor units;
- USD 0 provider cost;
- batch terminal status `partial` because all items fell out to Layer 3.

## Confirmed architecture gap

Deployed `layer2-batch-runner` performs acquisition → Evidence → normalization → deterministic extraction. For unresolved Course items it writes `layer3_required` and reconciles the Layer 2 batch. It does **not** create/dispatch a general Layer 3 work item.

Deployed `layer3-interpret` is an evidence-bound single-interpretation executor with benchmark/profile/rate/cost/validator controls. The current Layer 3 Admin UI loads Evidence candidates and invokes `layer3-interpret` only when the operator presses **Run eligible interpretation**. Therefore general Layer 3 Course work does not continuously drain.

Current tuition-specific OpenRouter free profile is enabled but paused because its fee benchmark failed (`provider 0/4`, controls `3/4`). Other benchmark-passed free profiles are authorised only for their existing task classes; they cannot be silently reused for tuition/intake/English.

## Programme correction — CF-247

The governing definition of done is now the complete lifecycle:

`Source → L1 authority → L2 acquisition/Evidence/deterministic extraction → automatic L3 interpretation where eligible → deterministic admission or L4 exception → Search/API projection → Admin telemetry`.

Do not launch larger Course waves merely to create more `layer3_required` backlog. Existing parsers/functions stay in service; the next work is additive orchestration/admission, not a big-bang rewrite.

## Current qualified AU comparison retained

- RMIT: 261 queueable courses with material intake/English/provider-current-tuition gaps;
- UQ: 104 queueable with fewer deterministic intake/English gaps;
- Flinders/Curtin queue rows are not selected until matching admitted Course-Fact source qualifications exist.

## Exact next action

Implement the automatic Layer 3 work queue/dispatcher from existing Layer 2 Evidence fall-out, using existing `layer3-interpret` validation logic and benchmarked task profiles. Then implement deterministic post-L3 admission + Search projection and live end-to-end Admin progress. Only after that loop is proven should AU scale waves resume, followed by NZ/CA pilots and GB/US/IE/DE portability tests defined by the roadmap.
