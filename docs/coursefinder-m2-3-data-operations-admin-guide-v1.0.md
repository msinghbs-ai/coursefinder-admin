# CourseFinder M2.3 Data Operations Admin Guide v1.0

**Applies to:** Pilot/UAT M2.3 deployed Data Operations surfaces  
**Change Controls:** CF-CHG-20260825-036, CF-CHG-20260825-037, CF-CHG-20260825-038  
**Authority chain:** Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition/extraction → Layer 3 AI-assisted Evidence interpretation → Layer 4 human resolution → downstream Search/Publication

## 1. Operating rules

- Never use Layer 2, Layer 3, Search or the Admin UI to redefine Layer 1 Provider/Course identity.
- Preserve source/evidence/version lineage. Missing, zero, suppressed, source-null and unresolved are different states.
- Layer 4 is the terminal human decision authority for governed scalar Course changes. Search/Publication are downstream states, not approval authorities.
- Browser code must never contain provider/model secrets or direct private-table write authority.
- Routine UAT mutations must be rollback-only or disposable.

## 2. Role quick reference

### Platform Admin
- Own role/access administration, platform configuration and approved operational controls.
- May inspect all M2.3 operational surfaces but must not bypass Layer authority, private-helper ACLs, model-profile validation or Publication governance.
- May use **OpenRouter API Key** to save/rotate the provider credential through the write-only Supabase Vault boundary and run the bounded provider verification check.
- Saving or verifying a credential never grants benchmark authority by itself. A PAUSED Layer 3 profile stays PAUSED until the real-provider quality benchmark is explicitly PASS.

### Pipeline Operator
- Operates acquisition/provider profiles, bounded refresh, onboarding and model-profile operational state where rank permits.
- Check provider economics and Firecrawl page budget before paid acquisition.
- May route unresolved work but cannot use Layer 2/3 output as direct canonical or Publication authority.

### Curator / Reviewer
- Uses Evidence, decision context, Important Links/Dates, Scholarship Selection and Layer 4 review packages.
- Every Layer 4 decision requires a reason. Edit-and-Approve requires an explicit final value.
- Treat QILT/PRISMS as contextual observations and Scholarship Selection scores as structural relevance only.

### Read-only / Counsellor-facing authorised user
- May inspect authorised catalogue/decision information according to role.
- Cannot execute private helpers, operator-only writes or infer missing eligibility/authority from absence of data.

## 3. Layer 2 provider operations and Firecrawl budget

The Firecrawl commercial contract is **5,000 pages per month**. CourseFinder reserves 5% (250 pages), so a batch that would cross the reserve is rejected before an external provider attempt starts.

Operators should use the provider/budget status to check used pages, remaining pages, requested batch impact and eligibility before scheduling paid acquisition. Direct HTTP remains preferred when it satisfies the Evidence contract. No silent paid fallback is permitted.

A failed provider attempt must retain deterministic attempt/status evidence; retry/resume must not duplicate canonical changes.

## 4. Layer 3 governed interpretation

Layer 3 is Evidence interpretation only. It cannot directly mutate canonical Course values or publish to Search.

The accepted Pilot profile is `openrouter-free-router-v1`, pinned to `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`. It is ACTIVE only because the governed Go 5 real-provider quality benchmark passed. The prior router-wide `openrouter/free` configuration was rejected after benchmark evidence showed model switching and a semantic extraction failure.

The accepted benchmark proves valid extraction, no-candidate/hallucination guards, exact URL extraction, unavailable-model rejection, malformed/unsupported-result rejection, zero-call unchanged Evidence, changed/expired/revalidation eligibility, request/day/retry/timeout/cost ceilings and no silent fallback. The accepted benchmark run is retained in private benchmark lineage.

Eligibility is evaluated before a provider call. Identical still-fresh Evidence returns a zero-call result. Explicit governed revalidation, changed Evidence or expired interpretation can create provider-call eligibility subject to rate/day/token/retry/timeout/cost controls.

Credentials are server-only. Platform Admin credential entry is write-only to Supabase Vault; browser code cannot read the key. `layer3-interpret` resolves the approved credential server-side and remains JWT protected. Returned model output remains untrusted until deterministic validation passes.

If the credential, pinned model, provider trust boundary, prompt/validator contract or relevant cost/rate controls materially change, do not assume the existing benchmark remains valid. Pause/revalidate/rebenchmark under Change Control before relying on the changed profile for governed interpretation.

## 5. Layer 4 terminal review

Six actions are supported:

1. Approve
2. Edit and Approve
3. Reject
4. Request More Evidence
5. Return to Layer 2
6. Return to Layer 3

Every terminal action requires a reason and retains decision history. Approve/Edit-and-Approve can invoke the canonical scalar resolution authority. Search refresh signals are created only after the accepted canonical change succeeds.

Reject creates no Search signal. More Evidence/Return L2/Return L3 may create bounded refresh/revalidation work but do not imply canonical acceptance.

Review context includes Evidence, Layer 2 lineage, Layer 3 configured/returned model and validation context, decision history and downstream refresh information where applicable.

## 6. Important Links and Important Dates

Important Links are an operational directory. Link health is not semantic authority.

Important Dates preserve source precision:

- date-only stays date-only;
- timestamp stays timestamp;
- ranges/month/term/year stay at their stated precision;
- vague source wording remains vague;
- no clock time or exact date may be manufactured from an imprecise source.

Country-reference dates with no legitimate ingestion target must not trigger ingestion.

## 7. Country / Provider / Course Onboarding

The shared lifecycle is:

`Draft → Source Qualification → Adapter Assessment → Schema Assessment → L1 UAT → L2 UAT → L3 Ready → Operational Certification → Production Promotion Ready`

Outcomes are READY, CONDITIONAL, BLOCKED, PAUSED or REJECTED.

Onboarding must reuse the shared canonical Provider/Course/Campus/Scholarship architecture. Do not create a country-specific canonical fork. Source/adaptor differences belong in source-native staging, adapters, configuration or genuinely country-specific extension facts.

Lifecycle transitions are rank-checked server operations with immutable actor/time/reason lineage. M2.3 rollback acceptance exercised the complete nine-stage lifecycle against an existing AU source/profile/provider/course/Evidence chain, including invalid-transition rejection and direct/private access denial.

## 8. QILT and PRISMS decision context

QILT and PRISMS are contextual observations, not Course-grain canonical facts.

The Course decision-context contract preserves provider/study-area/state grain, collection/period semantics, source/evidence, suppression and observation timing. Do not present a provider outcome or student-flow observation as if it were a fact about an individual Course.

## 9. Scholarship Selection

Scholarship Selection is **decision support only**. It intentionally separates:

- **SOURCE FACT** — sourced scholarship fields, source/evidence and recorded scopes;
- **DERIVED SCORE** — transparent structural Course/scope fit only;
- **MISSING / UNRESOLVED** — missing scope and/or student-specific mandatory criteria that have not been established.

`eligibility_inference_permitted=false` is part of the contract. A high structural fit score never means the student is eligible.

Current structural weights are explicit in the API response: Course 100, Provider 70, Study Level 50, Field 50, Country 40, unscoped 10. These are decision-ordering weights, not probability or eligibility percentages.

Where mandatory criteria are narrative/non-machine-evaluable, the UI must leave eligibility UNRESOLVED and direct the operator back to the published source/Evidence.

## 10. Search and Publication boundary

Search refresh is downstream of accepted canonical change. Returned Layer 2/3 candidates, unresolved Scholarship Selection results, QILT/PRISMS context, review proposals and onboarding progress do not by themselves grant Search or Publication authority.

Production cutover and broad Publication authority remain outside this Pilot/UAT M2.3 boundary unless a later accepted Change Control explicitly changes that.

## 11. Acceptance and escalation

A surface is accepted only when database/API/security/deployed-browser UAT is PASS or the exact residual item is explicitly DEFERRED/BLOCKED with evidence.

The Go 5 Layer 3 credential and real-provider benchmark blocker is cleared. The accepted profile is benchmark-passed and ACTIVE in Pilot. Any material provider/model/credential-contract change reopens the relevant verification/benchmark gate; it must not be inferred safe from the current PASS.
