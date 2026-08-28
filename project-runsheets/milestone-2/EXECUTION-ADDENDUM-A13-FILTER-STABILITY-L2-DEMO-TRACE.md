# Milestone 2 Execution Addendum A13 — Stable Filters & Demo-Visible Layer 2 Routing

**Status:** AUTHORITATIVE EXECUTION ADDENDUM  
**Effective:** 28 August 2026  
**Applies to:** M2.4.2 and later M2 work unless superseded.

## A13.1 — Course filter stability on tablet/touch

Course catalogue filters must remain visually anchored to the filter control that opened them.

The current tablet behaviour where a filter popover is forced into the middle of the viewport is rejected.

Required behaviour:
- opening a Course filter must not reposition it into the centre of the screen on tablet;
- popovers remain anchored to their trigger/control and inside the visible viewport;
- opening one filter closes any prior filter rather than leaving multiple transient menus;
- filter option fetches are bounded/paged and stale responses must not cause a closed/replaced dropdown to reappear;
- coarse-pointer/touch opening must not auto-focus the search input or summon the keyboard;
- changing Country/State/Provider clears invalid dependent selections without reopening a filter;
- loading state is contained inside the open filter; it must not cause layout jumping or a new popover instance;
- desktop, tablet and mobile UAT must explicitly cover repeated open/close, paging and dependent-filter changes.

## A13.2 — Layer 2 single-button transparency

The routine Layer 2 workflow intentionally has one primary action. The operator selects **what** to sync; the platform resolves **how** to acquire it.

The routine screen must make this visible rather than requiring Advanced configuration to understand it.

The operator-facing Layer 2 screen must display the governed route sequence, normally:

`Direct HTTP → Firecrawl → remaining enabled fallback providers`

The screen must explain:
- Direct HTTP is attempted first when eligible;
- Firecrawl is used automatically only when a governed fallback condition occurs or the source profile requires rendered acquisition;
- later providers are used only under stored route/fallback policy and provider quota/credential gates;
- the operator does not manually choose Firecrawl during normal sync.

## A13.3 — Evidence must be demonstrable from the normal journey

Layer 2 must expose recent acquisition-attempt evidence from the routine screen.

For recent attempts show at least:
- provider used;
- request/source URL;
- HTTP/result state;
- attempt order;
- timestamp;
- linked Evidence artifact when captured.

A linked Evidence action must open the governed Evidence workspace/detail so an operator can demonstrate:
`scope → acquisition provider → captured website Evidence → extracted/result state`.

"Website snapshot" means the retained native HTML/document/image Evidence returned by the governed provider. A screenshot image is shown only when the provider actually returned screenshot/image Evidence; the platform must not imply that Firecrawl always produces a screenshot.

## A13.4 — Demo readiness

For meeting/demo scenarios, use an already accepted successful Evidence-backed example rather than initiating a broad national run merely to show activity.

The UI should make at least one recent successful Firecrawl-backed Evidence example readily discoverable where such evidence exists.

No demo affordance may:
- bypass Layer 1 identity;
- mutate canonical/Search/Publication state;
- expose credentials;
- create synthetic screenshots or Evidence;
- start a paid/broad run without normal scope/guardrails.



## A13.5 — Screenshot Evidence and thumbnail

Where a governed rendered acquisition provider returns a screenshot reference, Layer 2 should immediately retain the image as a separate private Evidence artifact linked to the same acquisition attempt.

Required semantics:
- HTML/raw source Evidence remains authoritative for extraction and audit;
- screenshot Evidence is secondary visual Evidence only;
- screenshot capture is optional and must not make the acquisition fail when visual capture alone fails;
- the returned screenshot URL must be consumed immediately and the image copied into the private Evidence bucket because provider-hosted screenshot URLs may be temporary;
- screenshot Evidence records the same source URL, job, profile version and acquisition attempt provenance;
- the provider-attempt record stores `screenshot_evidence_id`;
- no screenshot may be fabricated when the provider does not return one;
- the Evidence drawer may obtain a short-lived signed image URL through the existing private Evidence access service and render a thumbnail;
- full screenshot and screenshot-Evidence drill-through remain available from the thumbnail;
- canonical, Search and Publication mutation remain false.

A bounded service-only historical backfill may be used for accepted Evidence where the original acquisition requested screenshots but older workers did not persist the returned image. Backfill must use the existing one-time nonce bridge, must not rerun canonical extraction and must attach the screenshot to the original attempt/Evidence group.
