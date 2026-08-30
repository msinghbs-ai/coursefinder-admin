# Execution Addendum A19 — Scholarship Scheduled ETL, Maintenance & Health

**Status:** ACTIVE — M2.4.4 ADDENDUM  
**Effective:** 31 August 2026  
**Change Control:** `CF-CHG-20260830-048`

## Purpose

Operationalise the existing Scholarship ingestion substrate so Scholarship discovery, ETL, Course mapping and maintenance are not one-off operator actions.

## Existing ETL truth

The Pilot already contains a deployed `scholarships-au-etl` Edge Function and Scholarship Layer 2 extraction functions. The AU ETL supports two governed feeds:

- `study_australia` — Australian Trade and Investment Commission / Study Australia Scholarship Search;
- `australia_awards` — Department of Foreign Affairs and Trade Australia Awards.

The ETL preserves source Evidence, content hashes, source records, stable identifiers, Provider mapping through CRICOS where available, offering cycles, application windows, scopes, criteria, award tiers and coverage. It does not make Scholarship sources a Layer 1 identity authority.

## A19.1 — Scheduling

- Study Australia runs on a routine scheduled cadence, bounded by configured page/max-record limits.
- DFAT Australia Awards runs on a lower-frequency scheduled cadence because it is programme/policy-cycle oriented.
- Schedules dispatch through the existing one-time nonce helper; browser/service-role secrets are never exposed.
- A scheduled run must be deduplicated and record dispatch/request state.
- Failed/stale dispatch state is visible to operators and does not silently advance freshness.

## A19.2 — Course mapping maintenance

After Scholarship ETL refresh, deterministic Course–Scholarship mappings are reconciled idempotently from explicit Scholarship scopes.

- Explicit Course/Provider include scope may map.
- Provider ownership without an explicit applicability scope remains review-only.
- Unscoped programmes such as Australia Awards are not sprayed across all Courses.
- Scheduled mapping maintenance does not alter Course canonical identity or Publication state.

## A19.3 — Housekeeping / health

Maintenance must report and reconcile:
- qualified/bounded Scholarship sources;
- captured vs applied source records;
- discovered but unresolved Scholarship candidates;
- stale source records / source last-success state;
- deterministic Course mappings and review-only candidates;
- ETL dispatch age/status;
- Evidence retention and hashes.

Housekeeping may clean expired transient nonces/temporary scheduler state, but must not delete governed Evidence, source records, Scholarship history, mapping audit state or source qualification history.

## Default Pilot cadence

- Study Australia: daily scheduler evaluation, bounded current feed request.
- DFAT Australia Awards: weekly scheduler evaluation.
- Scholarship maintenance / mapping reconciliation: daily after the ETL window.

Cadence is configuration, not source truth, and may be adjusted by an authorised operator without changing source authority.

## Acceptance

A19 requires:
1. deployed ETL source mirrored into the Pilot repo;
2. active scheduler and maintenance cron entries;
3. deterministic mapping maintenance is idempotent;
4. scheduler does not invoke unqualified/bounded-out source behaviour;
5. source/Evidence/history retention remains intact;
6. operational read surface reports ETL/mapping/maintenance status;
7. Security/Performance advisors and targeted scheduler tests pass.
