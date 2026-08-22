# CF-CHG-20260823-021 — Data Quality overview snapshot and concurrent UAT hardening

**Status:** **CLOSED / PASS**  
**Category:** `80-uat-release-operations`  
**Initiated:** 23 August 2026 07:00 AEST (UTC+10)  
**Closed:** 23 August 2026 07:39 AEST (UTC+10)  
**Origin:** M1-UAT-HARNESS first authenticated deployed desktop/mobile run  
**Owner:** CourseFinder release operations / Admin Data Quality  
**Affected surfaces:** Data Quality overview read path, Admin Dashboard startup, mobile Data Quality scroll container, deployed UAT evidence  
**Change class:** performance/reliability hardening; no canonical or readiness-semantic change

## 1. Trigger

The first automatically triggered authenticated desktop/mobile UAT successfully logged in but reproduced `public.admin_read` HTTP 500s under concurrent startup.

Postgres evidence identified statement-timeout cancellations. The authenticated browser role has an 8-second statement timeout and a cold AU+NZ `data_quality_overview` live recomputation measured approximately 10.65 seconds. The previous warm-cache result was therefore not a safe production read contract.

## 2. Accepted design

The browser timeout was not increased and the UAT harness was not weakened.

Accepted design:

1. `data_quality_exceptions` remains live, bounded and server-paged;
2. aggregate `data_quality_overview` is computed out-of-band into private timestamped AU+NZ/AU/NZ snapshots;
3. browser overview reads use the snapshot;
4. computation time/freshness is visible to the operator;
5. snapshots refresh every 15 minutes through database scheduling;
6. refresh remains server-side and is not exposed as a normal browser mutation;
7. Dashboard Recent Activity bounds each source before its final top-10 merge;
8. all Data Quality state/domain semantics remain unchanged.

## 3. Live migrations

Applied to Supabase project `coursefinder_Pilot`:

- `20260822210828 — m1_data_quality_overview_snapshot_core_v1`;
- `20260822210926 — m1_admin_dashboard_recent_activity_bounded_v1`;
- `20260822210938 — m1_data_quality_overview_snapshot_schedule_v1`;
- `20260822211428 — m1_data_quality_snapshot_visibility_v1`.

The private snapshot relation and refresh helpers are not direct browser APIs. Existing `public.admin_read` authentication/rank checks remain authoritative.

## 4. Scheduler evidence — PASS

`pg_cron` job:

`coursefinder-data-quality-overview-refresh`

Schedule:

`*/15 * * * *`

Command:

`select security.refresh_data_quality_overview_snapshots();`

The first observed scheduled execution started 23 August 2026 07:15:00 AEST and completed successfully at 07:15:13 AEST.

Resulting compute durations were approximately:

- AU+NZ: 9.49 s;
- AU: 2.77 s;
- NZ: 0.70 s.

This work is deliberately out-of-band rather than performed in the authenticated browser request.

## 5. Browser performance — PASS

Representative governed browser reads after snapshotting:

- AU+NZ Data Quality overview: approximately 16–22 ms in measured warm samples;
- overview while scheduled recomputation was active: approximately 16 ms;
- Dashboard after bounded recent-activity change: approximately 75 ms warm and approximately 558 ms during concurrent snapshot refresh.

All are comfortably below the authenticated 8-second statement timeout.

## 6. Semantic regression — PASS

Snapshot payloads preserve the accepted CF-CHG-018 state model and counts.

AU+NZ Course regulatory fee remains:

- Present: **26,326**;
- Source-null: **191**;
- Not applicable: **6,457**;
- Zero: **131**;
- readiness: **99.28%**.

Also retained:

- Course geography: 26,614 present / 34 source-null / 6,457 not-yet-enriched;
- Course taxonomy: 26,648 present / 6,457 not-yet-enriched;
- Provider-current fee / URL / Intake / English remain later-layer enrichment states as previously accepted;
- no synthetic Campus, fee, Review item or publication state was introduced.

The operator-visible policy text states that the aggregate is timestamped/refreshed every 15 minutes while exception drill-down remains live.

## 7. Pilot promotion and UAT history

### PR #23 — snapshot/read-path hardening

PR #23 passed production build and local browser smoke, then promoted at:

`6c8e8458033c8559013f3f79d47a46a1a9cd984a`.

The next automatic deployed run no longer reproduced the original Data Quality statement-timeout defect. It did expose two independent issues:

- desktop Evidence assertion used case-sensitive text that did not match the real rendered DOM despite the correct artifact being open with zero runtime errors;
- mobile Data Quality had a genuine scroll-container defect below 820px, making lower domain controls unreachable.

These were not waived.

### PR #24 — final responsive/UAT correction

PR #24:

- corrected Evidence drawer locators to match actual semantic DOM;
- restored an explicit height-bounded mobile `.dq-main` scroll container with momentum scrolling;
- clarified runtime JSON `status_at_capture` versus final Playwright/JUnit/GitHub status.

PR #24 passed production build, suite discovery, Chromium installation and local browser smoke before promotion.

Final Pilot head:

`e877e3e28cd281ff3751a70bc500eeb0d8f31963`.

## 8. Final deployed desktop/mobile gate — PASS

Automatic deployed workflow run **32600027592** executed against the Worker using normal Supabase Auth and the governed UAT identity.

Desktop:

- 3/3 tests PASS;
- runtime 25.5 s;
- artefact `9482641524`;
- digest `sha256:8dddfadd2c970037030f2ecf6efb4f25d73c6c8dc2a2c134e68c63c78e666666`.

Mobile / Pixel 7:

- 3/3 tests PASS;
- runtime 23.3 s;
- previously inaccessible Source-null control is now reachable/operable;
- artefact `9482641597`;
- digest `sha256:e601d52976be082e7db17c878fee5b207c0d9a80e16574eb2f4fe21d01fef2de`.

Both SHA-bound commit contexts report `success`.

Independent artefact inspection found, across all six final tests:

- HTTP 5xx: **0**;
- HTTP 4xx: **0**;
- console/page errors: **0**.

## 9. Security and architecture result

- browser `public.admin_read` boundary retained;
- snapshot storage/refresh remains private/server-side;
- Evidence remains Curator+ and private;
- no service-role credential is exposed to browser UAT;
- no canonical identity/source authority/Search/publication semantics changed;
- no factual values were manufactured.

## 10. Closure

**Final gate: CLOSED / PASS.**

Data Quality aggregate readiness is now a timestamped operational snapshot with live exception drill-down. The original concurrent timeout is removed from the browser critical path, Dashboard startup is bounded, mobile Data Quality is operable, and the exact promoted runtime passes authenticated desktop/mobile automation with zero recorded runtime errors.
