# CourseFinder Admin/PIM Design Decisions v1.22

**Status:** CURRENT M2 DESIGN DECISIONS  
**Date:** 31 August 2026  
**Supersedes:** v1.21; unspecified accepted decisions remain unchanged.  
**Change Controls:** prior accepted controls plus `CF-CHG-20260830-048`

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


## M2.4.4 navigation standard addition

### Decision 33 — Repository navigation registry is canonical UI authority

The CourseFinder Admin primary navigation must follow the navigation registry implemented in the authoritative Pilot repository.

Canonical implementation:
- `src/mature-main.jsx::NAV` — primary menu authority;
- `src/mature-main.jsx::HIDDEN_ROUTES` — backwards-compatible deep routes only;
- `src/mature-main.jsx::PAGE_META` — canonical page labels/descriptions;
- `src/mature-main.jsx::routeFromHash()` — supported route resolution.

Future UI/UX work must extend this registry rather than create a parallel top-level menu inside feature components.

Administration remains the single normal entrypoint for configuration/settings under A20. Routine Catalogue, Insights, Data Quality and Operations workspaces must remain task-first. Important Links/Dates may remain operational reference registries; configuration such as Sources, PIM Attributes, Scheduling policy, Onboarding templates, acquisition/provider settings, AI model settings and platform diagnostics belongs under Administration.

Hidden routes may be retained for compatibility, but they do not establish primary navigation authority. Floating launchers and overlays are secondary affordances only and cannot be the sole path required by permanent UAT.

Any change to the canonical navigation must update repository implementation, A20 or its successor, this design-decision baseline, desktop/tablet UAT and release notes where user-visible. Repository/runtime truth takes precedence over stale screenshots or older documentation.


## M2.4.4 permanent Layer navigation addition

### Decision 34 — Layer workspaces are permanent canonical routes, not floating applications

The final Pilot information architecture places four permanent sibling workspaces under Operations:

1. Layer 1 — Authority
2. Layer 2 — Enrichment
3. Layer 3 — AI Interpretation
4. Layer 4 — Human Resolution

These routes are rendered inside the canonical CourseFinder shell. Visible floating launchers, independent feature roots and modal-only primary journeys are not permitted for these Layers.

Layer 3 and Layer 4 are separate operator workspaces. A combined tabbed Layer 3/4 dialog may not be the canonical route.

The Pilot is a demonstration of intended final placement. Navigation/layout experiments must not be exposed as competing user journeys in the normal shell. Feature experimentation may occur behind development controls, but accepted Pilot UI must use the governed navigation architecture before user-facing validation.

Operational information-density standard:
- normally 3–5 primary KPIs;
- one main action group for the current state;
- visible blocker/fall-out guidance;
- recent progress/outcomes compactly presented;
- Evidence one or two clicks away;
- raw IDs, diagnostics, credentials and provider/model configuration progressively disclosed or centralised in Administration.

Feature modules may export embedded workspace components, but `src/mature-main.jsx::NAV` remains the primary menu authority. Permanent UAT must navigate through canonical routes and assert absence of floating Layer launchers.
