# M2.4.5 NEXT CHAT

## Active baseline — 15 September 2026 08:22 AEST

- Milestone: **M2.4.5 — Pre-Production Hardening**.
- M2.5 remains paused; no Production Supabase project exists.
- `CF-CHG-20260910-093` is **CLOSED / PASS / HISTORICAL ONLY**.
- Active operational-enrichment workstream: **`CF-CHG-20260915-245`**.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Accepted Pilot main before CF-245 merge: **`7196c5d2fade8830ec371c663b008e8a47e01f74`**.
- Active Pilot branch: **`cf-245-enrichment-ops` @ `2feb5be5d9bf39f0d677a323bafd30c7f8da1026`**.
- Pilot PR: **#91 — OPEN / mergeable; CI must be rechecked before merge**.
- Visible accepted/recovery release: **v2.15.79 / package 0.1.6**.

## What CF-245 has established

The planning-time `no layer2_run_items` conclusion was false because the managed-run items were pre-created and later lifecycle-updated. CF-245 now uses lifecycle timestamps and reconciles the run-item/job/provider-attempt/Evidence/source-record/Search path.

The 263-item RMIT managed batch is quantitatively explained:

- 263 fetched/extracted;
- 789 Evidence artifacts (263 acquisition + 263 screenshot + 263 normalised);
- 1,307 fields targeted;
- 935 deterministic candidates resolved;
- 263 original Layer 3 escalations;
- zero original field admissions;
- zero HTTP 429 / zero HTTP 5xx in the reconciled batch.

The dominant stop was whole-item escalation whenever any targeted domain remained unresolved; description was unresolved across the cohort. Do not respond by raising scheduler frequency/concurrency.

## Runtime migrations already applied

Pilot runtime contains, and PR #91 carries:

1. `20260915072000_cf_245_enrichment_operational_ledger_v1.sql`;
2. `20260915074500_cf_245_enrichment_reports_backlog_v1.sql`;
3. `20260915082000_cf_245_field_admission_bounded_url_v1.sql`.

These are forward-only and preserve existing ACL/RLS/private-helper/service-role and Layer authority boundaries.

## AU/NZ backlog truth

For each core course-fact coverage domain under the current scope:

### AU

- 516 queueable missing courses;
- 2,005 require governed URL discovery;
- 28 have URL/profile but no enabled execution policy;
- 18,534 require both discovery and execution-policy qualification;
- 5,555 are outside current qualified course-fact scope.

### NZ

- 0 queueable;
- 1,087 are in scope but require discovery/policy qualification;
- 5,370 have no qualified course-fact scope.

Do not enable NZ by copying AU assumptions. Resolve source/profile/discovery/policy qualification first.

## Bounded official URL admission

The qualified RMIT official URL replay is complete for the safe candidate set:

- 262 field-admission decisions;
- 260 admitted canonical changes;
- 2 unchanged/idempotent;
- one additional candidate remained unadmitted because the regulatory code was not observed.

Admission requires exact CRICOS identity, candidate URL = Evidence URL, qualified source/domain, approved Search source gate and no Layer 4 operational block. No generic tuition/intake/English/description auto-approval was introduced.

## Current website/Search coverage

After the final governed Search projection refresh:

- Search courses: **33,105**;
- regulatory tuition: **26,457**;
- intake coverage: **161**;
- English requirement coverage: **161**;
- official course links: **421**;
- provider-current tuition: **161**;
- website-admitted scholarships: **0**.

The final pending publication preview contained exactly 37 changed Search rows and only the expected official-URL delta; it was applied.

## Exact continuation sequence

1. Check PR #91 head/checks first. Last observed frontend build run: `34904038556` for `2feb5be5...`, previously in progress.
2. Review PR #91 diff for security/search_path/RLS/service-role semantics; run targeted DB/security checks. Merge only when green.
3. After merge, recheck Pilot main SHA and migration/runtime currentness before making further changes.
4. Implement **Gate F Enrichment Operations** Admin reporting, separate from Scheduled Tasks. It must show backlog, due/queued/processing, Evidence, admitted/published/failed, field coverage start/+hour/+day/current/remaining, provider/source yield, latency, blockers/rejections, retries/errors, vendor units/cost and Jobs/Evidence drill-down.
5. Run one fresh bounded governed Layer 2 cohort and prove the complete acquisition → Evidence → extraction → admission/fall-out → Search/publication path within one measurement window.
6. Continue bounded AU expansion only from qualified scope. Keep NZ blocked until qualification is real.
7. Do not change scheduler frequency/concurrency/provider ceilings until comparable fresh-period measurements justify a governed tuning event.

## Acceptance still open

CF-245 is not closed. Remaining gates include Admin outcome reporting, fresh-period end-to-end telemetry, bounded AU/NZ representative execution where qualified, targeted/bounded CI/UAT/security, deployed runtime reconciliation and steady-state daily reporting. Do not invent ETA from the historical cohort.
