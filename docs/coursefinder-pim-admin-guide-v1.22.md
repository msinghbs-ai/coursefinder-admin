# CourseFinder PIM Admin Guide v1.22

**Status:** CURRENT M2.4 ADMIN GUIDE  
**Date:** 30 August 2026  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.21.md`  
**Change Controls:** prior accepted M2 controls plus `CF-CHG-20260826-043`, `CF-CHG-20260829-047` and active `CF-CHG-20260830-048`

## 1. Authority model

CourseFinder has exactly four enrichment authority layers:

1. **Layer 1 — Authoritative / Regulatory**;
2. **Layer 2 — Deterministic acquisition and extraction**;
3. **Layer 3 — AI-assisted Evidence interpretation**;
4. **Layer 4 — Human resolution**.

Layer 4 is terminal for enrichment authority. Search and Publication are downstream states and are not Layer 5. No downstream layer may redefine an accepted Layer 1 regulatory identity.

## 2. Layer 1 — Regulatory administration

Use **Data Operations → Layer 1 — Regulatory** for routine AU/NZ regulatory operations.

The normal screen exposes Source Health, Current/Next Job, Progress, Reconciliation, Evidence/Provenance, Schedule/Recheck and Blockers/Required Actions. Experimental parser/reset controls are intentionally absent.

### Role split

- rank 4 Pipeline Operator: read operations and validate an already-governed source;
- rank 6 Platform Admin: source configuration, dry-run/APPLY queueing, pause/resume, retry/resume and stale-run recovery.

Server-side rank enforcement remains authoritative even when a UI control is hidden.

### Source configuration

Platform Admin may govern source URL, authority name/domains, expected format/count semantics, verification/ingestion cadence and variance bounds. Saving a profile creates a retained source-configuration version and resets verification to `unverified`; validation must pass again before execution.

### Validation and guardrails

AU validates the CRICOS CKAN package/resource shape and dynamically counts active Courses from source `Expired` semantics. NZ validates the five NZQA tertiary organisation listings and deduplicates stable provider IDs.

Current M2.4.1 comparison baselines are AU 26,648 active CRICOS Course rows and NZ 409 providers. Live NZ validation observed 411, approximately 0.489% variance, which remains PASS under the initial 5% warning / 20% blocking guardrails.

A warning requires explicit Platform Admin confirmation before APPLY. A blocking variance cannot be overridden by the normal run path.

### Jobs, retries and recovery

Only one active queued/running job per source is permitted. Retry/resume retains linkage, idempotency and resume cursor. A running heartbeat older than 30 minutes may be recovered only by Platform Admin and only after confirming the prior worker is no longer active.

### Scheduled verification and housekeeping

Layer 1 scheduled authority verification runs every 15 minutes and is deliberately non-destructive: it detects changed/unchanged/failed source state and does not silently APPLY canonical data. Paused sources are excluded.

Daily transient housekeeping deletes only expired terminal Layer 1 queue rows after 30 days. Evidence, source configuration versions and canonical history are excluded from deletion.

## 3. Reading Course Detail

Course Detail remains a decision surface rather than a raw field dump. Required/decision-critical facts stay visible even when empty; optional empty groups are suppressed. A layer is struck only when that specific field/domain was actually attempted.

| UI state | Meaning | Operator action |
|---|---|---|
| value + `L1/L2/L3/L4` + Resolved | fact resolved by that authority layer | inspect Evidence if needed |
| struck `L1` + Regulatory correction | authoritative Layer 1 fact missing/invalid | correct/re-ingest through governed Layer 1 workflow |
| `L2` + Awaiting L2 | deterministic enrichment not attempted | run governed Layer 2 enrichment |
| struck `L2` → `L3` + Awaiting L3 | Layer 2 could not safely resolve | L3 interprets retained Evidence / requests better Evidence |
| struck `L2`, struck `L3` → `L4 input` | both automated layers exhausted | Layer 4 human resolution |
| `L4` + L4 input | direct PIM/human-managed field | authorised human/PIM review |

## 4. Course Detail layout and retained UI state

Normal Course Detail order remains identity/status, description, fees/entry requirements, locations, populated optional information, Regulatory facts, Evidence and Operational state.

Per-screen search/filter state and Course Detail section order may be retained browser-locally for the signed-in user. These preferences contain UI state only, never credentials, Evidence payloads or canonical facts.

## 5. Layer 2 administration

Layer 2 is deterministic Course/Scholarship enrichment. QILT and PRISMS remain contextual datasets rather than Layer 2 scraper targets.

Use the consolidated Layer 2 Enrichment workspace. Provider credentials remain server-side/Vault-backed and write-only from Admin. Provider choice is outcome-based: evidence-backed completion, correctness, latency, reliability, quota/cost and downstream fall-out matter more than HTTP success.

## 6. Layer 3 administration

Layer 3 interprets governed Evidence only and cannot directly redefine Layer 1 identity. Unchanged fresh Evidence should remain a zero-call path. Provider/model/prompt/validator/trust changes require governed revalidation where applicable.

## 7. Layer 4 editing

Layer 4 is terminal human resolution, not unrestricted edit mode. Consequential edits require a reason/audit trail. Compound tuition, English and intake facts require typed semantics and must not be flattened into generic text.

## 8. Fees

Keep registered CRICOS course cost (Layer 1) semantically separate from current Provider tuition (Layer 2/3/4 as resolved). Never substitute a CRICOS total-course value for missing Provider-current tuition.

## 9. Evidence navigation

Evidence is a private governed workspace for source URL, capture time, hash, source/profile version, acquisition attempt, observations and review lineage. Layer 1 provides direct Evidence and Jobs & Runs drill-through from the regulatory workspace.

## 10. Completeness and readiness

Completeness is a coverage signal, not truth approval and not publication approval. Raw scraped text, HTTP success or an AI suggestion does not independently make a field complete.

## 11. Publication

100% completeness must never publish a Course automatically. Publication remains an explicit governed action with eligibility, preview/audit and downstream Search refresh after accepted change.

## 12. Country completeness trials

Use representative bounded cohorts and adapt based on observed consistency. Capture acquisition/extraction success, Evidence quality, correctness, latency/retries, provider quota/cost, completeness delta and L3/L4 fall-out.

## 13. Scholarship administration

Scholarships are first-class related entities. Listing/search Evidence discovers detail URLs; detail Evidence is acquired and extracted. `Not discovered` is not equivalent to `none`.

## 14. Terminology

Avoid **Search Admission**. Use Search Eligibility, Search Projection, Search Visibility, Publication Eligibility or Publication.

## 15. M2.4.2 Layer 2 operator model

The routine Layer 2 screen is scope-first rather than provider-first. Operators select Country and Country/State/University scope, review queueability, then start one governed sync action.

Low-level source profiles, route priority, vendor concurrency, credentials and billing configuration remain Advanced controls.

### Course URL identity

A first-party Course URL is an enrichment source location, not an identity authority.

RMIT specifically requires current detail-page CRICOS verification before a discovered URL becomes queueable. Matching the canonical title alone is insufficient where legacy and current CRICOS registrations share the same Course title.

### Paused and source-limited profiles

Paused profiles are deliberately excluded from executable scope options and are shown as blockers. Do not weaken discovery thresholds or identity rules to make a paused/source-limited profile appear complete.

### Refresh and alerts

Course-profile refresh policies are governed and initially disabled until full-run acceptance. Layer 2 operational alerts cover stale runs, paused profiles, blocked items, repeated provider failures and quota reserve.

### Evidence and Layer 3 fall-out

Ambiguous, identity-mismatch and not-found discovery outcomes are legitimate deterministic fall-out. Preserve their Evidence. Only unresolved extracted facts from governed Evidence may proceed to Layer 3; Layer 3 still cannot redefine Layer 1 Course identity.


## 16. M2.4.4 operational interpretation

Housekeeping and scheduler state are operational control-plane facts and do not change the four-layer authority model.

- Layer 1 recovery cannot redefine regulatory identity.
- Layer 2 stale recovery cannot delete governed acquisition Evidence/history.
- Layer 3 stale recovery and alerts cannot turn AI output into canonical truth.
- Layer 4 remains terminal human resolution.
- Search, Publication, Website and Zoho remain separately governed consumers.

Pipeline Operators should treat a stale/blocked/paused state as a diagnostic signal with a specific owner, not as justification to reset data or bypass a layer.

Layer 3 operational alerts are available to rank 4+ operators for stale execution, profile qualification/state, repeated provider errors and recorded cost-ceiling breaches. Provider/model credentials remain private and are not included in alert output.

Storage usage is observable but no authoritative database-configured capacity threshold exists at this checkpoint. Never manufacture a red/amber storage threshold from the observed Evidence footprint.
