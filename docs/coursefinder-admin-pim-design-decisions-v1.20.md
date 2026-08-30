# CourseFinder Admin/PIM Design Decisions v1.20

**Status:** CURRENT M2 DESIGN DECISIONS  
**Date:** 30 August 2026  
**Supersedes:** v1.19; unspecified accepted decisions remain unchanged.  
**Change Controls:** prior accepted controls plus `CF-CHG-20260829-046` and `CF-CHG-20260829-047`

## M2.4.3 accepted additions

### Decision 27 — Layer 3 operator presentation is Evidence-led

The normal Layer 3 operator journey must present the governed chain:

`Evidence → model/profile → result/confidence/provenance → human-review state`.

Credentials remain write-only/private and must not be exposed in routine UI.

### Decision 28 — AI interpretation cannot silently become canonical truth

Layer 3 consumes governed Layer 2 Evidence and may produce interpreted candidates, confidence and provenance. It cannot directly rewrite Layer 1/2 canonical values. Low-confidence/no-candidate results fall out to Layer 4.

### Decision 29 — screenshots are visual Evidence, not AI text input

Rendered screenshot Evidence may be shown as governed visual context/thumbnail, but is excluded from Layer 3 text input. Native/textual Evidence remains the interpretation substrate.

### Decision 30 — model qualification is an operator/runtime gate

A Layer 3 model profile must be enabled, unpaused and benchmark-passed for its task class before execution. The accepted source-pattern profile is pinned to `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free` and passed the unchanged 4/4 Provider + 3/3 control threshold.

### Decision 31 — retries, fallback and zero-call paths are visible governance

The UI/runtime must preserve:
- zero-call paths for resolved, unchanged or active duplicate work;
- bounded retries with attempt telemetry;
- fallback only to explicitly configured qualified profiles;
- external-call/token/latency/cost outcomes under A14;
- replay/revalidation provenance.

### Decision 32 — cross-layer and consumer boundaries stay explicit

Layer 4 remains terminal human enrichment authority. Search, Publication, Website and Zoho are separately governed downstream consumers. M2.4.3 acceptance does not authorise their automatic admission/cutover.

## Closure reference

Accepted Pilot marker/head: `96de9add3762a0594ebc371fba49d4d990ff4b45`.  
Final acceptance run: `33286437795`, desktop/mobile governed status PASS; one desktop M2.3 timing flake recovered on retry and remains visible evidence.

A8, A10, A12, A13, A14 and A15 remain standing accepted design constraints.
