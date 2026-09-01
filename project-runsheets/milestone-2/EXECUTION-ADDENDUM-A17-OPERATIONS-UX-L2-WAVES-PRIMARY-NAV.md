# Execution Addendum A17 — Operations UX, Layer Wave Control & Primary Navigation

**Status:** CLOSED / PASS — ACCEPTED M2.4.4 STANDING BEHAVIOUR
**Effective:** 30 August 2026  
**Change Control:** `CF-CHG-20260830-048`

## Purpose

Make the Admin control plane operationally understandable and runnable at catalogue scale without weakening Layer authority.

## A17.1 — Layer 2 execution waves

Layer 2 must separate **source qualification** from **execution batching**.

- Qualification remains bounded and evidence-first.
- Once a scope is qualified, the operator can choose an execution wave size. Default: **500 Courses for Wave 1**.
- The UI shows: total scoped Courses, Wave 1 size, remaining Courses, estimated number of remaining waves, active/scheduled work and current provider/API ceiling.
- **Schedule remaining** queues subsequent waves rather than issuing one unbounded request.
- Default route remains governed automatic routing: Direct HTTP → Firecrawl → configured fallback → Evidence.
- A second **scraper-first** option may begin with Firecrawl/configured scraper when the profile allows it. It must not bypass provider quotas, evidence retention, retry ceilings or source qualification.
- “Expandable request” means the operator may raise the requested wave size up to a governed platform ceiling; the service clamps it to the current API/provider ceiling and reports both requested and accepted sizes.
- No browser-side loop may hammer a scraper API.

## A17.2 — Dashboard

Dashboard must show meaningful status for Layers 1, 2 and 3, including:
- Layer 1 source/job freshness and recent success/failure;
- Layer 2 active/scheduled waves, processed/success/fall-out, Evidence and provider-route usage;
- Layer 3 qualified model profiles, pending Evidence candidates, recent interpretations, calls/tokens/latency/cost where recorded;
- Layer 4 pending human decisions and active overrides as a human-resolution summary.

## A17.3 — Layer 3 / Layer 4 UI cleanup

- Layer 3 presents a small operational scorecard, qualified model state, Evidence queue, one clear Run action and recent outcomes; advanced IDs/config remain progressive disclosure.
- Layer 4 presents pending decisions, active overrides, publication decisions and concise resolution controls; raw identifiers/lineage remain secondary.
- Important Links, Important Dates and other reusable operational registries must live in the **primary parent navigation**, not inside the Layer 3/4 operational overlay.

## Acceptance

A17 requires targeted deployed desktop validation of the new controls/navigation, server-side wave clamping/deduplication, scraper-first governance, and no regression of A10/A13/A14.

## Closure disposition — 1 September 2026
- Accepted under closed `CF-CHG-20260830-048` / M2.4.4.
- Replacement final acceptance `33468512515` PASS on desktop and mobile.
- This addendum remains standing behavioural/governance guidance where applicable, but does not keep M2.4.4 open.
