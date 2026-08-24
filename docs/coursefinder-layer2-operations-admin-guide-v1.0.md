# CourseFinder Layer 2 Operations Admin Guide v1.0

**Audience:** Management staff, PIM/Data Administrators, Pipeline Operators  
**Scope:** Course and Scholarship enrichment only

## What this screen is for

Use **Data Enrichment → Layer 2 Operations** to control and review Layer 2 without navigating technical backend pages.

The first screen intentionally shows only:

- which enrichment sources are active;
- whether they run manually/daily/weekly;
- batch size;
- provider-routing strategy;
- provider readiness;
- recent run result/cost;
- Evidence and items passed to Layer 3.

## Routine management actions

### Change schedule

Choose an enrichment source and select **Schedule**.

Available controls:

- Manual / Daily / Weekly / Disabled;
- batch size;
- provider-routing strategy;
- maximum paid attempts per item.

Default is Manual, batch 10, Direct HTTP then best-value fallback, maximum 2 paid attempts.

### Run a controlled test

Use **Run bounded trial** when validating a new university/source/provider or comparing scraper behaviour. Trials are measurement/candidate work only and do not directly mutate canonical Course or Scholarship data.

### Check provider readiness

Provider Health shows only operational information needed for routing. Use **Configure** when credentials, capabilities, concurrency, rate limits or account-plan cost metadata require attention.

Provider API keys remain write-only in Vault and are never displayed again.

### Review Evidence

Use **Open Evidence** to see source content and lineage.

Normal review order:

`Country → Courses/Scholarships → University/source → Run → Course/Scholarship → Provider Attempt → Evidence → extraction result`.

Raw storage paths, hashes, runtime IDs and provider header telemetry are diagnostic details and should not be needed for routine review.

## Understanding the run result

- **L2 resolved:** deterministic Layer 2 Evidence/extraction was sufficient.
- **L3 required:** Evidence exists but deterministic extraction/reconciliation was insufficient.
- **Blocked:** Layer 2 could not safely acquire/identify the target or policy/cost constraints stopped processing.

There is no routine Layer 2 `Send to Layer 4` action. Layer 3 must interpret/reconcile first. Only unresolved Layer 3 fall-out reaches Layer 4 Review Queue.

## Provider selection

Do not choose providers based only on request price or HTTP 200.

CourseFinder should prefer the method with the best measured combination of:

- correct evidence-backed field resolution;
- reliability;
- cost per resolved Course/domain;
- latency;
- retry/rate-limit behaviour;
- Evidence usefulness.

Direct HTTP is intentionally preferred where it already produces sufficient first-party Evidence.

## Evidence retention

New Layer 2 acquisition-v2 Evidence has a **minimum 365-day retention horizon**.

The date is not an automatic deletion instruction. Evidence still referenced by candidates/accepted data/review or placed on hold must be retained.

## When to use Advanced

Use advanced Source Configuration / Jobs / provider diagnostics only when:

- a source URL/discovery pattern changed;
- repeated runs are blocked;
- provider rate/cost/capability needs adjustment;
- Evidence is missing or malformed;
- a version/provenance investigation is required.

Routine management should remain in Layer 2 Operations.
