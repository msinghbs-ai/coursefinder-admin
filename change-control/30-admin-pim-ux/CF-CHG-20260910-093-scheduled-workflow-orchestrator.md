# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** REOPENED — CORE ACCEPTANCE BOUNDARY SATISFIED; LARGE-BATCH RUNTIME VALIDATION / RELEASE FOLLOW-ON ACTIVE  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-13 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Visible accepted release:** v2.15.78  
**Current Pilot main:** `cb31abe21ffe9a041cacd5f975a0e4af5248daa5`

## Objective

Provide a governed Scheduled Tasks control plane for AU Course Facts while preserving CourseFinder authority boundaries: Layer 1 identity/regulatory authority, deterministic Evidence-preserving Layer 2, governed Layer 3 interpretation, Layer 4 human resolution, and separate Search/Publication admission.

## Accepted implementation path

PR #72 merged the Preview-bound async Layer 2 authority contract. PR #80 repaired deployed-main acceptance triggering. PR #81 reconciled UQ acceptance to governed scope invariants. PR #82 merged Firecrawl -> ZenRows exhaustion/Layer 3+4 parking. PR #83 merged the bounded six-university scale-out as `cb31abe21ffe9a041cacd5f975a0e4af5248daa5`.

The accepted authority contract remains:

- same-actor Preview before consequential dispatch;
- exact Preview token/fingerprint/binding/identity provenance;
- bounded profile/policy/route/credential/budget qualification;
- deterministic Layer 2 and Evidence truth;
- no generic scheduler Layer 3 auto-approval;
- Layer 4 retains human authority for unresolved outcomes;
- no implicit Search/Publication consequence.

## Scraper / escalation boundary

CourseFinder does **not** require website-specific scraper perfection before work can progress.

For the active governed university cohort the acquisition route is:

1. Firecrawl — priority 10;
2. ZenRows — priority 20.

Direct HTTP, scrape.do and ScraperAPI are disabled for this cohort at priorities 110/120/130.

If a Preview-bound course remains unresolved after its governed retry limit:

- successful selected discovery candidates are excluded from escalation;
- unresolved courses are parked as blocked Layer 3 refresh work;
- Layer 3 remains Evidence-gated and is not called with fabricated Evidence;
- the same unresolved courses are surfaced as pending Layer 4 `official_course_url` review items;
- `canonical_mutation_authorised=false` is retained;
- the async binding moves from `active` to `handoff_started` so scraper exhaustion is not left as an active scheduler blocker.

This is the intended architecture boundary: acquisition failure becomes governed enrichment/human-review work, not an instruction to keep engineering around each institution's website mechanics.

## Deployed runtime identities

Preserve repository/runtime identities independently:

- repo `20260913113000_cf_093_firecrawl_zenrows_exhaustion_parking.sql`; runtime `20260913115513 cf_093_firecrawl_zenrows_exhaustion_parking`;
- repo `20260913121500_cf_093_large_university_batch_enablement.sql`; runtime `20260913121052 cf_093_large_university_batch_enablement`.

Do not rename, retimestamp or rewrite applied migration history.

## Live UQ parking proof

Earlier UQ exhausted Preview token `b0eb7e77-d31a-4cb7-b187-8226445a1b7c` moved to `handoff_started` without another scrape run. Live result remains:

- 42 unresolved courses parked as blocked Layer 3 refresh requests;
- 42/42 Layer 3 rows have no fabricated Evidence;
- 42 pending Layer 4 `official_course_url` review items;
- 42/42 retain `canonical_mutation_authorised=false`.

## Six-university large-batch validation

PR #83 enabled a bounded cohort using the same accepted deterministic execution-policy shape and Firecrawl -> ZenRows route. Rollback-only proof first confirmed all scopes were executable. Exact-head Fresh Reconstruction, Targeted Recovery, Frontend Build and Cloudflare preview passed before merge.

Live acquisition-only dispatches:

| University | Preview token | Discovery scope | Dispatch request |
|---|---|---:|---:|
| RMIT | `7d445b99-b545-4987-99f2-df5c1bbc2211` | 27 | 6015 |
| Curtin | `c2e70f76-c5ac-45f7-b99b-c8af38fa3ae1` | 356 | 6016 |
| Flinders | `40d7e691-4d49-4448-aabd-c4238c690db6` | 461 | 6017 |
| Griffith | `3de32f03-e5d9-4b26-a7ee-61f7241eefad` | 294 | 6018 |
| La Trobe | `8823638e-df65-4e7e-9518-2190130bf203` | 244 | 6020 |
| Queensland University of Technology | `cb84a25c-a52d-420b-91bd-071d034444f7` | 294 | 6021 |

Total Preview-bound discovery scope: **1,676 courses**.

Initial runtime evidence:

- Firecrawl monthly usage before this wave: 4,656 of 11,000 governed units; 250-unit stop reserve remains enforced;
- first measured wave sample: 50 Firecrawl attempts, 50 HTTP-successful attempts;
- RMIT first worker chunk completed 5 processed / 0 failed;
- Curtin, Flinders, Griffith and RMIT continuation were actively running at first reconciliation;
- La Trobe and QUT bindings were active and queued behind bounded continuation/concurrency;
- no duplicate dispatch is authorised while these exact Preview bindings remain active.

Terminal reconciliation must be by Preview token. Successful deterministic discovery/handoff may proceed through Layer 2; unresolved exhaustion must park into Layer 3/4 rather than trigger institution-specific scraper engineering.

## Acceptance / validation evidence

Earlier post-PR #82 exact Pilot main passed Frontend Build `34755718375` and Deployed UAT `34755717852`.

PR #83 exact head `c437ef6caa495b3ffc122a9d3e6d9174745d44de` passed:

- CF-093 Fresh Reconstruction `34756285717`;
- CF-093 Targeted Recovery `34756285696`;
- Pilot Frontend Build `34756285691`;
- Cloudflare exact-head preview.

Gitar exact-head review was requested; no inline finding was present at merge. Final standalone Gitar response should be recorded when available and must not be retroactively claimed if absent.

## Runtime-operations follow-on

Pilot PR #79 remains open for browser-visible Runtime Health / efficiency work. Its already-deployed read-only observability migrations remain valid, but the UI change still requires release-currentness/version reconciliation before merge. Visible accepted release therefore remains v2.15.78 until that governed release gate changes.

## Remaining closure gates

CF-CHG-20260910-093 remains REOPENED for large-batch terminal reconciliation plus final governance/release reconciliation, not for website-specific scraper engineering.

1. Reconcile all six active Preview tokens to terminal Jobs/Evidence/handoff/Layer 3+4 outcomes without duplicate dispatch.
2. Record Firecrawl/ZenRows usage and throughput for the larger wave while enforcing budget/reserve.
3. Finish Admin PR #37 exact-head review and merge from current-main governance truth.
4. Reconcile PR #79 release-currentness/version and exact-head validation before merge.
5. Reconcile REGISTER/RUNSHEET/CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT to the final merged/deployed boundary.
6. Close CF-093 when the remaining runtime/governance release follow-on is accepted; do **not** reopen scraper-specific perfection as a closure gate.
7. M2.5 remains paused unless separately reopened.

## Rollback / recovery

- Never rewrite applied migration history.
- Database rollback is forward-only through a new migration.
- Never fabricate Evidence, identity mappings, provider credentials or canonical values to obtain a PASS.
- Never bypass Layer 3 Evidence gating or Layer 4 human authority.
- Scraper exhaustion is an escalation outcome, not permission for implicit canonical/Search/Publication mutation.

**Current outcome:** Scheduled Tasks Preview/dispatch authority is proven and has now been scaled to a six-university, 1,676-course discovery wave using Firecrawl -> ZenRows. The large batch is active; unresolved terminal outcomes are governed Layer 3/4 work, not a scraper-perfection blocker.