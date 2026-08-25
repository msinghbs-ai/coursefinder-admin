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

## Implementation checkpoint — 25 August 2026

Governance was reconciled before implementation against Master Project Plan v1.71, M2→Production Delivery Plan / TSOW v1.4, the current deployed Supabase state and the current Pilot `main`. The frozen M2.2 acceptance was not redefined; M2.3 was implemented additively on top of the newer Layer 2 Evidence/batch runtime and the existing M2.1 Layer 4 scalar-resolution authority.

### Deployed database/runtime

Applied Supabase migrations:

- `20260825124619_m2_3_layer3_layer4_refresh_intelligence_foundation`;
- `20260825124942_m2_3_layer3_refresh_admin_read_write_contracts`;
- `20260825125714_m2_3_authenticated_rpc_invoker_hardening`;
- `20260825125742_m2_3_foreign_key_index_hardening`.

The deployed model introduces private governed ledgers/configuration for model profiles, Layer 3 interpretations, Layer 4 review items/decisions, refresh policies/requests, Important Links and Important Dates. Direct browser table privileges remain revoked.

The initial model profile is `openrouter-free-router-v1` using the configuration-driven OpenAI-compatible endpoint and `openrouter/free` model identifier. It stores only the server secret name `OPENROUTER_API_KEY`; it is **enabled but paused** with validation state `pending_credentials_and_benchmark`. This is intentionally not a permanent-model dependency and cannot issue provider traffic until server-side credentials and the required benchmark/validation gate are satisfied.

Deployed Edge Function:

- `layer3-interpret` — function ID `33dd7564-990a-4b15-a884-35ac609c2258`, version 1, `verify_jwt=true`.

The function validates the authenticated actor, reserves eligibility before any external call, refuses unchanged-Evidence replay, reads provider credentials server-side only, enforces configured RPM/day/token/retry/timeout/cost ceilings, validates structured output deterministically and escalates validated non-null candidates to a pending Layer 4 review item. It does not write canonical values itself.

Layer 4 terminal approval/edit continues through the existing governed `security.layer4_course_scalar_resolve_impl` path rather than introducing a competing canonical authority. Reject, Request More Evidence, Return to Layer 2 and Return to Layer 3 are retained as explicit audited decisions; Return to Layer 2 creates an entity-bounded refresh request.

Important Date refresh requests require a source-profile or entity target. Country-reference dates without a bounded target cannot launch ingestion. `source_vague` dates retain the original source wording and cannot be promoted to an invented exact date.

### Security/performance hardening

The first post-DDL security review identified browser-executable public `SECURITY DEFINER` warnings on the newly introduced Admin RPCs. These were remediated in migration `20260825125714`: privileged implementations now reside in the private `security` schema while public browser contracts are `SECURITY INVOKER` wrappers with the existing role/rank checks retained. A repeat security advisor run reports no M2.3 authenticated-security-definer warnings. Existing INFO-only no-policy notices on deliberately private/RLS-protected schemas remain programme baseline rather than an M2.3 regression.

Performance advisor review identified M2.3 foreign-key paths without dedicated covering indexes. Migration `20260825125742` added the relevant indexes for Layer 3 profiles/interpretations, Layer 4 Evidence/resolution lineage, Important Date Evidence and refresh-date references. Unrelated pre-existing INFO advisories are outside this change.

### Automated UAT evidence

Rollback-only database contract UAT: **PASS**.

Verified in one controlled transaction and rolled back afterwards:

- new governed Evidence is L3-eligible;
- a validated L3 candidate creates a **pending** Layer 4 item only;
- Layer 3 does not mutate the canonical Course before human approval;
- replay of the same unchanged Evidence hash returns `call_required=false` / `unchanged_evidence`;
- Layer 4 Approve applies through the existing scalar-resolution authority with actor/Evidence/L2/L3 lineage;
- Edit and Approve, Reject, Request More Evidence, Return to Layer 2 and Return to Layer 3 execute as distinct audited actions;
- Return to Layer 2 creates a targeted entity refresh request;
- Important Link verification advances last/next verification state;
- a vague country-reference Important Date is rejected as an ingestion trigger;
- an exact entity-targeted Important Date creates only a bounded refresh request.

No synthetic UAT mutation was retained after rollback.

Permanent deployed Playwright UAT has been added for desktop/mobile coverage in `tests/uat/m2-3-intelligence-deployed.spec.mjs` and wired into `.github/workflows/deployed-uat.yml`. It verifies the paused initial L3 profile, no-call governance messaging, Layer 4 terminal workspace, refresh queue, Important Links, Important Dates and vague-date/targeted-refresh messaging.

### Pilot source/runtime references

Pilot source commits in this implementation slice:

- `42661fb74fedf24e610a5adf9371623bc82f4c96` — governed M2.3 Admin workspace;
- `4d84b34c7d50c23ac759941980e270b1cb19ee2a` — M2.3 responsive workspace styling;
- `b5322cdf068ab7872c6d3b2f057dc5b17e7a303a` — workspace/ticker mount;
- `d71f0ec236358eeae858007c682424c798c23eb6` — source-controlled `layer3-interpret` function;
- `36f05d2ab035168a6d9c3cc3eca83d61c1f0ff85` — deployed M2.3 Playwright UAT;
- `2159db7afb6adddf144f7e827992e3c91cc48f78` — M2.3 test added to the permanent deployed UAT matrix.

At this checkpoint the final-sha Frontend Build and Deployed UAT workflows have been triggered and are still running/queued. Their conclusions must be reconciled before calling this implementation slice accepted.

### Current gate / residual work

**Gate: IN PROGRESS — database contract PASS; final deployed-browser gate pending.**

Still required before the Layer 3 provider route can be enabled:

1. configure an authorised `OPENROUTER_API_KEY` or alternative compatible aggregator credential as a server-side Supabase secret only;
2. execute real-provider structured-output, malformed-output/unavailability, rate-limit and fallback benchmark UAT;
3. record quality/cost benchmark results against the model profile and only unpause a profile that passes;
4. reconcile final desktop/mobile deployed UAT and frontend-build conclusions for Pilot SHA `2159db7afb6adddf144f7e827992e3c91cc48f78`;
5. continue M2.3 full-stack regression and operational population/tuning of Important Links, Important Dates and source/entity refresh policies.

M2.3 is **not closed** by this checkpoint. M2.4 remains the already-approved optimisation/regression/pre-blackout workstream after M2.3 acceptance.
