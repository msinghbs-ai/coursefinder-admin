# CF-CHG-20260825-038 — M2.3 Layer 3/4 Launch, Refresh Intelligence & Important Dates

**Status:** APPROVED / IN PROGRESS  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 22:26 AEST (+10:00)  
**Origin:** M2.3 scope expansion  
**Owner:** CourseFinder programme / Data Operations

## Trigger

M2.3 is expanded to launch governed Layer 3 AI Interpretation and Layer 4 Human Resolution in the same milestone, alongside a freshness-aware refresh scheduler, Important Links registry and Important Dates ticker. The user supplied an L3/L4 design reference showing configurable OpenAI-compatible LLM routing and human curation. That concept is accepted only as a UX reference; browser-stored API keys or direct browser-to-aggregator privileged execution are not authorised.

## Layer 3 operating model

Layer 3 becomes operational during M2.3.

- Use OpenAI-compatible aggregator/provider abstraction with server-side secrets only.
- Prefer free/zero-cost models when they satisfy the governed task contract.
- Model choice is profile-driven, replaceable and versioned; do not hard-code one free model as permanent architecture.
- Apply account/model/provider rate limits, request/day budget, request/minute budget, retry ceiling, token/output ceiling and circuit-breaker behaviour.
- Use structured-output validation and deterministic post-validation before any candidate can progress.
- Preserve prompt/model/provider/profile/version lineage and Evidence references.
- Layer 3 produces suggestions/candidates only; it does not silently mutate Layer 1 identity or bypass Layer 4 where human resolution is required.

OpenRouter is an acceptable initial aggregator. Current public OpenRouter information indicates free accounts are rate-limited and free-model availability can change; therefore CourseFinder must treat model availability and limits as runtime configuration, not a fixed assumption.

## Layer 4 operating model

Layer 4 becomes operational during M2.3 as the terminal human-resolution layer.

- Review queue with approve/edit/reject/return-for-evidence actions.
- Full source/Evidence/provenance visibility.
- Explicit before/after and reason capture.
- Audit actor/timestamp/Change Control lineage.
- No hidden auto-approval from Layer 3.
- Human decisions can resolve ambiguous semantic conflicts but must not rewrite authoritative Layer 1 source history.

## Freshness-aware update cycle

Do not process the whole catalogue through Layers 2/3 on a fixed frequent cadence. Use a source/entity freshness scheduler driven by authority, known source cadence, change detection and important dates.

Recommended classes:

1. **Regulatory/Layer 1** — poll according to authority publication cadence/freshness SLA; fast-track detected source/version changes.
2. **Provider/Course Layer 2** — refresh when Layer 1 changes identity/status, provider source hash changes, course/intake/fee freshness expires, or a known important date approaches.
3. **Layer 3** — run only on unresolved/new/changed Evidence or expired interpretation; unchanged hashes do not consume LLM requests.
4. **Layer 4** — event-driven queue only when Layer 3 confidence/validation or deterministic conflicts require human resolution.
5. **Search/consumer projections** — refresh only after upstream accepted canonical/read-state changes.

The scheduler should support freshness classes such as critical/weekly/monthly/term-cycle/annual/event-driven rather than one universal interval.

## Important Links workspace

Add a maintained **Important Links** menu/workspace that assimilates governed country-wide operational/reference links, grouped by country and authority type, including where applicable:

- regulatory Provider/Course authorities;
- immigration/international-student authorities;
- quality/outcomes authorities;
- official scholarship portals;
- qualification frameworks;
- national/statistical agencies;
- accepted Provider/catalogue sources;
- source status/health pages;
- official policy/change notices.

Each link record should carry country, authority class, source owner, URL, purpose, last verified date, freshness/check cadence, related source profile and operational status. It must not become an ungoverned bookmark dump.

## Important Dates / ticker

Add an **Important Dates** registry and compact dashboard ticker. Dates may include sourced Course/intake deadlines, scholarship closing dates, regulatory data-release dates, application windows and other governed events.

Ticker rules:

- sourced dates only;
- country/provider/course/scholarship scope clearly labelled;
- timezone/date semantics retained;
- source/Evidence link available;
- expiry/archival after the event;
- configurable warning windows;
- no fabricated deadline if a source provides only a season/month/term;
- dates can trigger targeted refresh jobs, but not broad uncontrolled re-ingestion.

## M2.4 consequence

Because Layer 3 and Layer 4 are now operationalised in M2.3, M2.4 should be repurposed to **AI/Data Quality optimisation, full-stack regression and pre-blackout checkpoint**, not duplicate initial Layer 3 implementation.

## Security

- Aggregator/API keys are Vault/server-only.
- No LLM API key field is persisted in browser local storage or exposed to normal client JavaScript.
- Admin UI stores only governed profile references and non-secret settings.
- New L3/L4 RPCs/Edge Functions require negative authorisation UAT.
- LLM/provider responses are untrusted input and require schema validation.

## UAT

M2.3 closure now additionally requires:

- L3 free-model/provider routing and rate-limit tests;
- provider/model unavailability fallback without unsafe mutation;
- unchanged-Evidence no-LLM-call replay;
- malformed/hallucinated-output rejection;
- Layer 3 to Layer 4 escalation tests;
- Layer 4 approve/edit/reject audit tests;
- Important Links verification/role tests;
- Important Dates expiry, warning and targeted-refresh tests;
- desktop/mobile L3/L4/links/ticker UAT;
- regression of Layer 1/2 identity, Evidence, Search and Publication boundaries.

## Boundary

This change does not create the separate Production environment, broad Publication, Zoho cutover or final handover. Layer 4 remains terminal. Search/Publication remain downstream states.
