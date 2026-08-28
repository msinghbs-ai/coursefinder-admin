# Milestone 2 Execution Addendum A14 — Layer 2 / Layer 3 Telemetry Retention

**Status:** STANDING REQUIREMENT  
**Date:** 29 August 2026  
**Change Control:** CF-CHG-20260827-044 and successors

## Purpose

Layer 2 and Layer 3 must continuously retain operational performance, usage and cost telemetry so scraper/provider and AI/model behaviour can be evaluated over time rather than only during one-off UAT.

This addendum does not change authority, canonical identity, Search or Publication permissions.

## Layer 2 mandatory telemetry

For every governed acquisition/provider attempt and managed-run item where the runtime can determine the value, retain:

- acquisition provider / adapter;
- source profile + immutable profile version;
- attempt number and terminal outcome;
- HTTP status / failure class;
- request latency;
- deterministic extraction latency;
- retry count;
- vendor units / credits consumed;
- estimated or measured vendor cost;
- Evidence object count and bytes;
- content-change/no-change result where available;
- fallback/routing outcome;
- fields targeted / fields resolved;
- Layer 3 fall-out count;
- runtime timestamps.

Direct HTTP must still be recorded as an acquisition route even when vendor units/cash cost are zero.

Subscription scraper providers must not be interpreted as "free" merely because per-request cash cost is configured as zero. Quota/unit consumption must remain measurable separately from cash cost.

## Layer 3 mandatory telemetry

For every external model interpretation/benchmark call where supplied by the provider/runtime, retain:

- model profile and exact returned model;
- task class and prompt-profile version;
- external call count;
- input/prompt tokens;
- output/completion tokens;
- total tokens where derivable;
- call latency;
- retry/fallback outcome where applicable;
- validator outcome;
- estimated/measured USD cost;
- acceptance/rejection/fall-out status;
- Evidence linkage;
- runtime timestamps.

A model/provider response that omits usage metadata must remain explicit as unavailable; do not manufacture token or cost values.

## Operational reporting

Layer 2 / Layer 3 operational reporting must support at least:

- attempts/calls by provider/model;
- success/failure/fall-out rates;
- average and percentile latency where sufficient samples exist;
- retries;
- vendor units;
- input/output/total AI tokens;
- estimated/measured cost;
- Evidence footprint;
- fields resolved and unresolved;
- time-window comparison.

Metrics are operational context only. They do not authorise canonical, Search or Publication mutation.

## Acceptance rule

No new scraper/provider/model execution path is accepted if it silently bypasses the applicable telemetry contract.

Before a release gate, verify that new Layer 2/Layer 3 paths populate or explicitly mark unavailable the telemetry fields they can govern.
