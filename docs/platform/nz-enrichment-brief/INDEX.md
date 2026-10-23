# Platform data programme — INDEX and standing state
Last updated: 2026-10-24 10:50 AEDT by Platform Admin.
New sessions (human or agent): read this file first. Full operating rules:
docs/platform/AGENT-OPERATING-MODEL.md (read once). This repo is the durable record;
chat history is transport only. Australian English throughout.

## Repos
- DECISIONS (this repo): msinghbs-ai/coursefinder-admin — WHAT and WHY. Nothing executes here.
- EXECUTION: msinghbs-ai/Coursefinder-Pilot — Cloudflare Worker + Supabase code.
  All deployments ship from Pilot; this repo's wrangler target is NOT the live Worker.
  Pilot working rules: its CLAUDE.md (CF-247). Every code change traces to a decision
  recorded here FIRST.

## Thread files (read only what a task touches)
Base: https://raw.githubusercontent.com/msinghbs-ai/coursefinder-admin/main/docs/platform/nz-enrichment-brief/

| File | Contents |
|---|---|
| 2026-10-23-nz-enrichment-brief-assessment.md | Day-one DB introspection, coverage matrix |
| 2026-10-23-nz-brief-verification-and-release-plan.md | Verification answers, Releases 1–3 |
| 2026-10-23-nz-brief-decisions.md | Decisions + thread (quarantine a07de41, 8a query, R1 extension, identity root cause) |
| 2026-10-23-platform-throughput-gap-schema.md | Plan + live build thread (diagnosis: upstream starvation, not budget) |
| 2026-10-24-nz-field-admission.md | NZ field push; item 5 shipped (1,874 links); entry-requirements spec section 5 |
| 2026-10-24-zero-yield-reacquisition.md | Zero-yield flow v2.15.338; UoA pilot; standing order section 6; detect-only |
| 2026-10-24-au-quick-wins-and-247-ingestion.md | AU triage vs developer gaps; links widened (16,889 AU + 1,863 CA); 24/7 audit; hourly report ≤8 min fresh |
| 2026-10-24-au-builds-and-enrichment-jobs.md | Builds B1–B6, jobs E1–E6, Phases 0–3, expected-coverage table (section 7) — response pending at time of writing |

## Standing order
R1 (Q2 backoff, Q4 narrowed, Q3 ledger, apply-time identity check) — STARTED 3 TIMES,
COMPLETED 0. Ships as ONE release, uninterrupted. Then R3 (health-hourly). Then
target_only audit paste file → Platform Admin sign-off (O10). Then R2 (Q1 at
search.daily_picked_cap = 100; raise only on ledger evidence). Then stepped read-lane
test. Then S1 full (absorbs zero-yield table; contract test: search, AI match AND
finder all consume rejections). Then 8a remainder (country_identity_rules table).
Then items 9, 10, 11.

## Decisions awaiting Platform Admin
1. Approve provider-policy proposals — Settings › Provider policies, queue ~99 (E1;
   est +400–900 English admissions). Largest value-per-click.
2. zero_yield.auto_reset → 1 (after reading UoA pilot in the zero-yield file).
3. UoA catalogue-host: refreshed map pending; else per-provider catalogue-host
   allowance vs manual bindings for the 45 catalogue-only courses.
4. provider-calendar-intakes on/off (E2 analysis in the builds file).
5. O5: NZQA signatory-list page URL.
6. O8/O9: Firecrawl plan tier + monthly credit cap; OpenRouter plan + monthly spend cap.
7. O10: sign the target_only audit at R2.

## Live platform state (key releases)
v2.15.334 Release 1 · v2.15.335 read-lane capability (values frozen 60/8) ·
v2.15.336 item 5 course_url fill · v2.15.337 identity CRICOS-AU-only (4,909
re-verified, 281 re-bound) · v2.15.338 zero-yield flow detect-only.
Key metric: course-page binding % (NZ baseline 53.5%) — every field's ceiling.
Fee quarantine: 158 rows identity_basis_reverify, reversal = reidentify → re-read →
re-admit. Hourly report "StudySearch hourly stats" (≤8 min fresh) is the daily view.

## Guardrails (summary — full rules in AGENT-OPERATING-MODEL.md and Pilot CLAUDE.md)
Config over code; settings keys for every tunable; no new status values; quote-on-page
for AI admissions; manual bindings never touched; count guards on paste jobs; no new
panels/SOPs without retiring old; decisions precede code.
