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

## 2026-09-15 11:27–23:25 UTC — prior cycles

- Durable service-owned Layer 3 queue, security/recovery controls and explicit Evidence-backed tuition handoff derivation were implemented, reviewed, merged and deployed through Pilot main `2346fab3...`.
- Direct runtime truth reconciled at **2,402 layer3_required / 2,281 resolved_l2 / 815 cancelled / 10 blocked**. L3 queue remains empty because tuition qualification fails closed.
- Explicit tuition ambiguity comprises **390 multiple-equal-rank + 208 low-confidence = 598** items. Generic **1,780** `layer3_required` rows remain non-dispatchable until unresolved-field provenance is explicit.
- Tuition benchmark execution was unblocked with forward migration `cf_247_allowlist_tuition_benchmark_nonce`, reconciled to Pilot `188093ca...`. Fresh benchmark: provider semantic **0/4**, safety controls **4/4**, 8 calls, 68,071 input + 1,466 output tokens, max latency 5.794 s, USD 0. Profile remains paused/FAIL.
- Root cause: prior positive benchmark cases were unresolved backlog Evidence whose expected basis itself required validation; the safety contract correctly refused to manufacture an annual fee. Do not weaken the prompt/model.

## 2026-09-16 01:27 UTC — valid benchmark-positive corpus located

- Reconciled Pilot main `188093ca24449ff25068c7c555ada23b7f05c24c`; latest frontend build is PASS and deployed-UAT run exists on the exact head. Tuition profile remains paused as required.
- Runtime contains **168** admitted `provider_current_tuition` fee rows. Of these, **9** have retained governed Evidence with storage path + content hash and an already-admitted explicit basis in the task validator's allowed set (`annual`, `indicative_annual`, `per_year_explicit`). These are suitable positive benchmark truth because the expected answer is independently established by deterministic admitted state rather than inferred from unresolved backlog.
- Positive corpus includes 8 UQ 2027 first-party `source_snapshot` cases (AUD 48,080 / 56,800 / 60,952, `indicative_annual`) and 1 RMIT 2027 first-party `source_snapshot` case (AUD 37,440, `annual`). This gives both provider diversity and basis diversity while preserving first-party Evidence lineage.
- No model call was consumed this cycle; nominal tuition-profile headroom remains the prior 17 calls from the configured 25/day ceiling, subject to provider-side free-tier enforcement. No L3 work/admission/Search delta claimed.
- Exact next action: change the tuition benchmark worker/corpus selector so four positive provider cases are drawn from these already-admitted Evidence-backed annual/indicative-annual truths; retain unresolved/ambiguous backlog cases as negative/exception controls. Rerun qualification. Only on semantic + control PASS may the profile be unpaused and a bounded 10–25-item queue cohort dispatched.
- No hard external quota/auth blocker observed. The remaining gate is implementation of the corrected benchmark corpus, followed by dispatcher/admission/Search proof.