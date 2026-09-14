# M2.4.5 NEXT CHAT

## Active baseline — 15 September 2026 AEST

- Milestone: **M2.4.5 — Pre-Production Hardening**.
- M2.5 remains paused; no Production Supabase project exists.
- `CF-CHG-20260910-093` is **CLOSED / PASS / HISTORICAL ONLY**.
- Active operational-enrichment workstream: **`CF-CHG-20260915-245`**.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Accepted Pilot main before CF-245 implementation: **`7196c5d2fade8830ec371c663b008e8a47e01f74`**.
- Visible accepted/recovery release: **v2.15.79 / package 0.1.6**.

## CF-245 objective

Make real enrichment measurable and expand governed AU/NZ coverage. Separate scheduler liveness from data outcome and report the complete funnel:

`missing/stale/due → eligible → queued → acquired → extracted → admitted/unchanged/rejected → Layer 3/4 → Search/Publication → website/API visible`.

Do not increase scheduler frequency merely because a tick finds no work. First make demand and admission outcomes observable.

## Reconciled live findings

At planning time on 15 September 2026:

- cron/scheduler infrastructure was healthy;
- 245 successful `layer2_acquisition_v2/course_facts` jobs existed in the inspected prior 24h;
- all 245 reported content changed, Evidence and screenshot Evidence;
- zero reported `canonical_mutation_authorised=true`;
- no matching `layer2_run_items` telemetry was produced by that active path in the inspected period;
- 3,059 Layer 2 source profiles existed, including approximately 933 active course-facts website profiles;
- only 10 Layer 2 refresh policies existed, 8 enabled, effectively AU-only, with zero due at inspection;
- 50 Layer 2 execution policies existed and were enabled.

Website/consumer coverage baseline for this workstream:

- 33,105 Search courses;
- 26,457 regulatory tuition;
- 10 intakes;
- 10 English requirement coverage;
- 10 official links;
- 10 provider-current tuition;
- 0 website-admitted scholarships.

## Exact first action

1. Reconcile the 245 successful recent acquisition jobs against provider attempts, Evidence, extraction/candidate/admission stores and Search/publication outputs.
2. Produce exact counts for every reason `canonical_mutation_authorised=false`.
3. Wire the real scheduled acquisition path into the common batch/item telemetry contract, preserving accepted security/authority boundaries.
4. Produce the first real one-hour enrichment funnel report before changing concurrency, scheduler frequency or provider limits.
5. Then classify/generate AU/NZ missing/stale backlog and expand bounded work queues.

## Required reporting

Hourly reporting must show eligible/queued/fetched/failed, Evidence, extraction, fields found, facts admitted/unchanged/rejected, L3/L4 counts, courses improved, website-visible field deltas, cost/units, latency and 429/5xx/runtime errors.

Daily reporting must show:

`starting coverage → added today → ending coverage → coverage % → remaining gap → blocked/not-queueable → recent velocity`.

Do not invent ETA until representative multi-period throughput exists.

## Authority and tuning boundaries

Preserve Layer 1 identity, deterministic Evidence-preserving Layer 2, Preview/binding provenance where applicable, no generic Layer 3 auto-approval, Layer 4 authority, separate Search/Publication admission, existing ACL/RLS/private-helper/service-role boundaries and immutable applied migration history.

Tune only from comparable evidence. Behavioural tuning must be audited with reason, before/after policy and CF-245 reference.

## Continuity obligation

Proceed autonomously through normal governed implementation, targeted testing and recovery loops. Before ending or approaching tool/runtime limits, update CF-245, RUNSHEET, CURRENT-STATE, FOLLOW-UPS and NEXT-CHAT with exact repo/runtime heads, migrations, PR/CI/UAT IDs, measured metrics, blockers and the first next action.
