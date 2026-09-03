# M2.4.5 NEXT CHAT

Recommended chat name:

`CF M2.4.5 — H11 Provider Assets & Rankings — 2026-09-03`

Continue CourseFinder M2.4.5 from repository/runtime truth.

## Mandatory start

1. Read `PROJECT_INSTRUCTIONS.md`.
2. Read `docs/README.md` as the authoritative current-document router.
3. Read `docs/01-governance/coursefinder-pim-operating-principles-v1.0.md` and preserve CF-086.
4. Read `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md`.
5. Read CF-087 and CF-091.
6. Read CF-083/A32, CF-090, CF-089 and CF-084 where they overlap.
7. Read current M2.4.5 RUNSHEET/CURRENT-STATE/FOLLOW-UPS/WORK-ITEM-LEDGER/MEETING-READINESS.
8. Read `change-control/REGISTER.md`.
9. Reconcile current Admin/Pilot heads, Pilot Supabase/runtime and targeted CI/UAT before modifying shared foundations.

Preserve:
- M2.4.4 CLOSED / PASS / FROZEN;
- H1 CLOSED / TARGETED PASS;
- CF-089 Scraper Config UI/performance TARGETED PASS;
- Parse.bot live execution NOT qualified because current credential probe returned HTTP 401;
- M2.5 PAUSED AT P0; do not create Production resources;
- current DB Architecture/Admin-PIM documents selected through docs/README.md.

## Immediate priority: H11 onward first

### H11 — Provider Logo Completeness & University Source Discovery

Start here.

1. Build a canonical in-scope Provider/university logo coverage matrix:
   - expected Provider count;
   - discovered candidate;
   - acquired Evidence;
   - approved primary;
   - blocked;
   - missing;
   - source/freshness.
2. Reconcile existing CF-083/A32 provider-asset tables, profiles, approved assets and blocked cases before creating anything new.
3. Run a bounded first-party logo discovery/acquisition cohort.
4. Prefer official university/provider SVG/PNG/brand/header assets.
5. Use Hotcourses sitemap/navigation only to identify missing Providers/source entrypoints or reconcile gaps; do not treat Hotcourses as canonical logo authority.
6. Preserve Evidence, hashes, source URLs, approval state and rollback.
7. Mature the Admin/PIM logo coverage/read surface only where needed and keep shared UI/UX rules.

### H12 — ARWU & University Diversity Statistics

After bounded H11 progress:
1. Reconcile current QS/THE/ranking schema and CF-090 recovery.
2. Add ARWU as an editioned ranking family beginning with 2025 and supporting multi-year history.
3. Preserve exact/tied/banded/unranked semantics and Provider crosswalk/Evidence.
4. Add University Diversity/HDI as a separate contextual dataset, not a QS/THE/ARWU score.
5. Preserve year/edition, diversity rank, nationalities represented, international-student count, source and geography where available.
6. Wire Statistics & Rankings, Provider and Compare surfaces through the accepted UI system.
7. No Search/Website/Zoho admission without a separate consumer gate.

### H13 — Ranking Acquisition Adapters

Then:
1. Make uploaded-file parser and governed API acquisition converge on one staging → validate → Provider reconcile → Apply contract.
2. Support explicit edition/year and multi-year replay.
3. Retain raw Evidence, request/source metadata, adapter/parser version, validation outcome and cost/latency/vendor telemetry.
4. Proceed with file/parser implementation even if Parse.bot credentials remain invalid.
5. For Parse.bot ranking acquisition use the established dataset-specific APIs from CF-092:
   - QS scraper_id `e3ecc5de-f530-478a-b464-867d43099420`, endpoint `get_world_rankings`;
   - ARWU reference scraper `0f6d2cb9-c7eb-4f31-9216-f7be578e9f96`, execution scraper_id `9a025ecd-9ccb-4cf6-a454-be52e290b946`, endpoint `get_arwu_rankings`, `API-Snapshot-Version: 10`;
   - target 2015–2026 inclusive;
   - keep key Vault-only;
   - require successful authentication;
   - do not generate replacement QS/ARWU scrapers;
   - determine QS year/pagination semantics from the endpoint contract rather than inventing parameters;
   - execute bounded one-request qualification before multi-year backfill;
   - capture Evidence/cost/latency/completeness telemetry;
   - fail closed on auth/schema drift/incomplete pagination/identity ambiguity.
6. Never allow generic unqualified Parse.bot proxy execution.

## Parked work

Do not resume H2 residual Parse.bot qualification as a standalone priority. It becomes a dependency only when H13 reaches the live Parse.bot API step.

H3-H6 remain parked until H11-H13 have been materially advanced. H7-H10 remain continuous governance/telemetry/UAT/meeting obligations.

## Testing

Use static/build/schema → targeted contract → bounded integration → targeted browser UAT.

Do not run the full acceptance suite during intermediate work.

## Before ending

- update owning Change Controls;
- update all M2.4.5 continuity files;
- record absolute date/time, commits, runtime/migration evidence and targeted UAT;
- update Production migration inventory/telemetry for every material runtime/schema/Edge/Storage/config change;
- update MEETING-READINESS;
- return only Achieved, Failed/Blocked, Next and recommended continuation chat.


## CF-093 immediate continuation — 2026-09-03 14:42 AEST

The ranking URL/file parser is implemented and deployed.

First operator actions in an authenticated Admin session:
1. Administration → Sources & Imports → Register ranking publisher file.
2. QS World University Rankings → 2026 → Parse.bot URL.
3. Confirm `/scrapers/e3ecc5de-f530-478a-b464-867d43099420` → Parse import.
4. Review parse/reconciliation result; Apply edition only if bounded result is acceptable.
5. Repeat for ARWU → 2026 using `/scrapers/0f6d2cb9-c7eb-4f31-9216-f7be578e9f96`.
6. Confirm both cards/history become data-backed.
7. Record import IDs, Evidence IDs, mapped/unmapped counts and Jobs.

Do not bypass the authenticated Admin operator boundary from management tooling.
