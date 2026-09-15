# M2.4.7 / CF-247 Hourly Monitoring

**Status:** ACTIVE  
**Purpose:** durable hourly operational record for autonomous CourseFinder delivery.  
**Authority:** `docs/coursefinder-end-to-end-automated-data-admission-roadmap-v1.0.md`, `docs/coursefinder-actionable-operations-monitoring-standard-v1.0.md`, `CF-CHG-20260915-247`.

## Recording rule

Add one concise entry per hourly monitoring/execution cycle. Record only actionable deltas and exact blockers; do not turn this into a chat transcript.

Each entry should contain where available: timestamp; repo/runtime/CI head checked; implementation/data outcome; L2/L3/L4; admissions/Search/API delta; Evidence; provider/model usage; backlog/resource headroom; forecast/next action; hard external blocker.

## 2026-09-15 09:27 UTC — monitoring baseline

- CF-247 active; Pilot Supabase `fxcwkweaxjtknorudmwp`; accepted entering baseline `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`.
- RMIT proof: 25/25 processed, 0 deterministic L2 resolution, 25 `layer3_required`, 0 blocked, USD 0.
- Runtime backlog **2,402** `layer3_required`; consumer baseline Search 33,105; official URLs 527; intakes 487; English 520; provider-current tuition 161.
- Decision: no larger L2 backlog until automatic L2→L3→admission exists.

## 2026-09-15 11:27 UTC — durable Layer 3 queue foundation

- Implemented private `pipeline.layer3_work_items`, idempotent enqueue, bounded `SKIP LOCKED` reservation, benchmark/paused-profile guard and explicit transition service on Pilot PR #97.
- Runtime: 2,402 layer3_required; 2,281 resolved_l2; 815 cancelled; 10 blocked. L3 executions 0; provider/model usage 0 / USD 0.

## 2026-09-15 12:27 UTC — queue security/recovery hardening

- PR #97 initial build/Cloudflare PASS; Gitar found ineffective SECURITY DEFINER caller check, stale reservation recovery gap and unlimited retries.
- Corrected caller JWT/session role evaluation, 15-minute lease recovery and five-attempt parking; extended targeted UAT.
- Runtime unchanged; no L2 volume added.

## 2026-09-15 13:27 UTC — queue foundation accepted/deployed

- Pilot PR #97 merged to main as `81cfa56b5f4689b0208b3cf50dc48dec12dcd34c`; queue migration applied to Pilot runtime.
- Runtime queue initially empty by design; historical Layer 2 backlog remained 2,402 pending governed Evidence/task-class derivation.
- No AI calls/admissions/consumer delta; next unit is handoff derivation + dispatcher.

## 2026-09-15 14:27 UTC — Evidence lineage reconciled; governed handoff derivation opened

- Reconciled Pilot main `81cfa56b5f4689b0208b3cf50dc48dec12dcd34c` and live runtime.
- Runtime remains **2,402 layer3_required**, 2,281 resolved_l2, 815 cancelled, 10 blocked; Layer 3 queue empty; interpretations in prior hour 0.
- Important lineage finding: direct `evidence_artifacts.entity_id/job_id` matching is not the correct Layer 2 Evidence join for these runs. `layer2_provider_attempts` carries the authoritative raw/html/screenshot Evidence IDs. **2,178 / 2,402** current Layer 3 fall-out items have retained raw Evidence through that lineage with storage path + content hash.
- Backlog composition is predominantly tuition ambiguity: 351 multiple-equal-rank fee cases, 105 low-confidence fee cases plus further fee/no-fee variants; 1,403 rows show a generic `layer3_required` blocker and must not have a task class guessed.
- Model headroom: general free profile PASS/unpaused 20 RPM / 50 day but not tuition-authorised; source-pattern PASS 10/30; international-contact PASS 8/50. Provider-current-tuition profile remains paused + benchmark FAIL at 10 RPM / 25 day. Scholarship profiles remain paused/FAIL.
- Opened Pilot PR #98 at `896403d26231a38f4bf5b35cf9046530b944e219`: explicit service-role handoff derivation for fee-specific blockers using retained provider-attempt Evidence and only an enabled/unpaused/benchmark-PASS tuition profile. It deliberately fails closed today, so unsafe tuition AI is not executed.
- No AI/provider calls, tokens or cost this cycle; no canonical/Search/API delta. No new Layer 2 wave launched.
- Next action: get PR #98 CI/review clean; in parallel improve/benchmark the tuition task route rather than bypassing it. Once a tuition profile passes, deploy derivation and a bounded dispatcher can begin draining explicit fee cases. Generic `layer3_required` rows require explicit unresolved-field provenance before dispatch.
- No hard external API/auth/quota blocker. Active gate is internal task qualification and CI/review, not resource exhaustion.
