# M2.4.7 CURRENT STATE

**Status:** ACTIVE — FIRST QUALIFIED RMIT SCALE WAVE RUNNING  
**Opened:** 2026-09-15 AEST  
**Accepted Pilot baseline:** `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 paused until M2.4.9 GO

## Accepted predecessor

M2.4.6 / CF-246 is CLOSED / PASS / FROZEN. Active Layer 2 starts are idempotent and bounded `schedule_remaining=false` requests dispatch exactly one wave. Clean predecessor proof: 5/5 processed, 5 bounded Layer 3 handoffs, 0 blocked, USD 0, one batch, terminal continuation dispatched 0 additional work.

## Admission-first baseline

Existing accepted CF-245 paths increased website/Search official-course-URL coverage to **527** after 122 canonical/Search changes. Intake coverage is 487, English 520 and provider-current tuition 161. Website v3.1 consumes the admitted data now; it does not wait for complete enrichment.

## Gate B selection

Current AU queueable profile comparison:

- RMIT: 261 queueable courses / 303 missing field rows — 37 intake, 5 English and 261 provider-current-tuition gaps;
- UQ: 104 queueable / 107 missing rows — 2 intake, 1 English and 104 provider-current-tuition gaps;
- Flinders/Curtin queue rows were not selected because their current profile source IDs did not have matching admitted Course-Fact source-qualification rows.

RMIT is therefore the first controlled scale target. Its profile is enabled/unpaused and valid; execution policy is enabled; Course-Fact source qualification is `qualified`; `apply_admitted=true`; `search_admitted=true`; admitted domains include official URL, international fee, intake and English requirement.

## Active scale wave

Request: `f120fb4b-ec69-4f2c-8147-550a338c6f3d`  
Batch: `13f33fcf-05b9-4379-b214-cf4760bbe1f3`  
Scope: RMIT university  
Route: managed  
Wave size: 25  
Schedule remaining: false

Latest observation: 8/25 processed, 8 bounded Layer 3 handoffs, 0 blocked, vendor units 8, vendor cost USD 0. No broader scope or automatic continuation is authorised.

## Active decision

Complete this bounded wave, reconcile terminal outcomes and any newly observed deterministic intake/English facts, admit only already-qualified safe changes, refresh governed Search and measure the website delta. Only then decide whether to run the next RMIT wave or widen scope.

Shared Evidence reuse, retry taxonomy, provider-routing changes or throughput tuning are not preconditions. Apply them only when measurements identify a material constraint.
