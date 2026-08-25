# CF-CHG-20260825-038 — M2.3 Layer 3/4 Launch, Refresh Intelligence & Important Dates

**Status:** APPROVED / IN PROGRESS — RUNTIME RECONCILED, PROVIDER BENCHMARK BLOCKED  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 22:26 AEST (+10:00)  
**Last reconciled:** 26 August 2026 06:35 AEST (+10:00)  
**Owner:** CourseFinder programme / Data Operations

## Decision and authority boundary

M2.3 operationalises governed Layer 3 AI Interpretation and Layer 4 Human Resolution together with bounded refresh intelligence, Important Links and Important Dates.

The authority chain remains:

`Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition/extraction → Layer 3 AI-assisted Evidence interpretation → Layer 4 human resolution`.

Layer 4 is terminal. Search Projection, Search Visibility and Publication are downstream product states. Layer 3 cannot mutate Layer 1 identity or canonical Course values directly, and browser code cannot hold aggregator credentials.

## Layer 3 operating contract

- OpenAI-compatible provider abstraction with server-side secrets only.
- Model/provider choice is profile-driven, replaceable and versioned.
- Eligibility is checked before any external provider call.
- Unchanged Evidence is a zero-call result.
- RPM/day/input/output/retry/timeout/cost ceilings remain enforced.
- Model output is untrusted and must pass deterministic validation.
- Validated non-null candidates can create Layer 4 work only.
- No direct Search publication or canonical mutation.

### Current deployed profile

`openrouter-free-router-v1` remains:

- aggregator: OpenRouter;
- endpoint: `https://openrouter.ai/api/v1`;
- configured model: `openrouter/free`;
- server secret reference: `OPENROUTER_API_KEY`;
- enabled: `true`;
- paused: `true`;
- validation state: `pending_credentials_and_benchmark`;
- requests/minute: 20;
- requests/day: 50;
- max input/output: 12,000 / 1,200 tokens;
- retry ceiling: 1;
- timeout: 30 seconds;
- cost ceiling: USD 0 for the initial free-router profile.

The authorised management surface still does not expose Edge Function secret enumeration. Credential presence therefore remains unverified and must not be inferred.

**Provider gate: BLOCKED — CREDENTIAL REQUIRED / AUTHORISED SERVER SECRET NOT VERIFIED.**

The profile must remain PAUSED until a real-provider benchmark explicitly passes.

### Current Edge runtime

Reconciled deployed function:

- slug: `layer3-interpret`;
- function ID: `33dd7564-990a-4b15-a884-35ac609c2258`;
- version: 1;
- `verify_jwt=true`;
- status: ACTIVE;
- deployed bundle SHA-256: `83dea5345d4cfd7d5970905285fff8680ed853f2dae5be8962d66e44672efad9`.

No runtime drift was observed from the prior accepted Layer 3 Edge checkpoint.

## Layer 4 operating contract

`security.layer4_course_scalar_resolve_impl` remains the only canonical Course scalar authority. The hardened Layer 4 decision contract supports all six governed actions:

1. Approve;
2. Edit and Approve;
3. Reject;
4. Request More Evidence;
5. Return to Layer 2;
6. Return to Layer 3.

Request More Evidence / Return to Layer 2 create bounded Layer 2 work. Return to Layer 3 creates a bounded revalidation request. Search-refresh signals are created only after Approve/Edit and Approve and only after the canonical scalar authority succeeds.

The deployed browser has the six actions, mandatory reason capture and before/proposed display, but still requires the full `public.layer4_review_context` UX: queue filters/prioritisation, Evidence opening, L2 context, L3 profile/configured and returned model/result/validator/token/cost context, full history, explicit final value and downstream refresh result. This remains an M2.3 implementation gate; no second Layer 4 authority is authorised.

## Refresh intelligence

Applied migration `20260825133136_m2_3_refresh_scheduler_layer4_terminal_operations`:

- adds `source_id` targeting to refresh policy/request contracts;
- creates private `pipeline.search_refresh_signals`;
- adds source relationships to Important Links/Dates;
- strengthens Layer 4 terminal routing;
- installs `security.refresh_scheduler_tick_impl`;
- installs pg_cron job `coursefinder-m2-3-refresh-intelligence-tick` on `*/15 * * * *`.

Live reconciliation confirms the cron job is ACTIVE and executes only:

`select security.refresh_scheduler_tick_impl(now(), 100);`

The scheduler is a bounded work-selection mechanism only. It must not directly perform uncontrolled catalogue ingestion, provider/model calls, Layer 4 approval or Search publication.

Live policy state is ten enabled policies; all ten have `source_id` targets and **zero unbounded policies**. This remains subject to rollback-only due-policy UAT proving that a due policy cannot select an entire country.

## Important Links

The governed AU/NZ directory remains seeded from accepted CourseFinder official sources: AU CRICOS/Data Catalogue, PRISMS, QILT GOS, Study Australia Scholarship Search, DFAT Australia Awards, NZQA Education Organisations and Education Counts Tertiary Providers Directory.

Health remains an operational observation, not proof of semantic authority. Education Counts was deliberately marked degraded when its prior verification timed out; HTTP success alone must not change this status without semantic verification.

## Important Dates — exact source precision

The post-boundary migration version is now authoritatively reconciled as:

`20260825133749_m2_3_important_dates_source_precision`.

The migration statements were read back from `supabase_migrations.schema_migrations` and the **exact deployed SQL** was restored to source at:

`supabase/migrations/20260825133749_m2_3_important_dates_source_precision.sql`.

Source-control repair commit:

`3858a8f9bf4ccfb7bb5aec89fbc239420718e47e`.

No deployed semantics were recreated or changed during this repair.

The deployed model preserves the distinction between source dates and source timestamps:

- UQ Semester 1 2027 international application deadline — `2026-11-30`, date-only, Australia/Brisbane, provider/source-targeted Layer 2 refresh;
- UQ Semester 1 2027 classes start — `2027-02-22`, date-only, Australia/Brisbane, provider/source-targeted Layer 2 refresh;
- Australia Awards Fellowships Round 22 expected opening — `source_vague`, no fabricated date, country-reference only, `refresh_layer=null`.

The browser workspace still uses the older timestamp-oriented date write contract and does not yet present date-only ticker values correctly. M2.3 must move the Admin UX to `important_date_upsert_v2` and retain exact date-only/date-range/month/term/year/source-vague semantics without manufacturing a clock time.

## Migration history — reconciled live

Current M2.3 migration tail:

- `20260825124619_m2_3_layer3_layer4_refresh_intelligence_foundation`;
- `20260825124942_m2_3_layer3_refresh_admin_read_write_contracts`;
- `20260825125714_m2_3_authenticated_rpc_invoker_hardening`;
- `20260825125742_m2_3_foreign_key_index_hardening`;
- `20260825133136_m2_3_refresh_scheduler_layer4_terminal_operations`;
- `20260825133749_m2_3_important_dates_source_precision`.

## CI / deployed-browser reconciliation

Previously accepted semantic runtime:

- Pilot SHA `400e06d26cb7147a14971af578607816b0aca342`;
- Frontend Build run `32854071358` — PASS;
- Deployed UAT run `32854071828` — PASS;
- desktop job `97821647704` — PASS;
- mobile job `97821647394` — PASS.

The source-only migration synchronisation commit `3858a8f9bf4ccfb7bb5aec89fbc239420718e47e` has:

- Frontend Build run `32894556070` — PASS;
- Deployed UAT run `32894556145` — **IN PROGRESS at this reconciliation checkpoint**; desktop governed acceptance executing, mobile queued.

Therefore `3858a8f9…` is not yet recorded as deployed-accepted. The exact Cloudflare Worker deployment/version identifier is not exposed by the currently authorised connector surface; SHA-bound deployed acceptance must continue to be established by the permanent deployed UAT gate until runtime build provenance is made directly observable.

## Security / performance advisor reconciliation

Post-DDL Security Advisor: no M2.3 WARN/ERROR finding. Existing `rls_enabled_no_policy` notices are INFO-only on deliberately private/RLS-protected schemas and remain programme baseline.

Post-DDL Performance Advisor: INFO-only findings. The earlier M2.3 foreign-key hardening is effective; no new Layer 3/Layer 4/refresh unindexed-FK regression is present. Unused-index notices are not evidence to remove fresh operational indexes before representative workload history exists.

## Mandatory remaining automated UAT

Before this Change Control can close, retain evidence for:

- rollback-only database contract suite;
- due-policy bounded-scope scheduler case;
- Important Date exact date-only, exact timestamp, range, month, term, year and source-vague cases;
- timezone/warning/expiry/targeted refresh and country-reference no-target rejection;
- all six Layer 4 actions and search-signal-only-after-accepted-change;
- Layer 3 unchanged Evidence zero-call and revalidation eligibility;
- private-table/private-helper/anon/insufficient-rank/profile-write/link/date write denial;
- Edge authentication negative path;
- server-secret/browser-bundle leakage regression;
- Layer 1/2, Evidence, Search and Publication authority regression;
- permanent desktop/mobile/deployed-runtime UAT.

Synthetic UAT mutations must be rolled back.

## Real-provider benchmark gate

If an authorised server-only credential becomes verifiable, run the bounded benchmark covering valid extraction, no-candidate, malformed output, hallucinated/unsupported candidate rejection, unavailable provider/model, timeout, retry/RPM/day/cost ceilings, unchanged Evidence zero-call, changed/expired/revalidation eligibility and configured fallback. Persist configured and returned model, profile, prompt/validator versions, token/cost/latency/result/quality/Evidence/UAT/Change Control lineage.

Until then, continue all noncredential M2.3 gates and keep the profile PAUSED.

## Acceptance

This Change Control is **not closed**. Closure requires its applicable criteria to be PASS, deliberately DEFERRED outside M2.3, or explicitly accepted as residual risk, with governance updated to the actual deployed runtime. M2.4 does not begin before the M2.3 acceptance boundary is established.