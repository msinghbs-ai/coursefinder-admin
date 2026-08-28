# M2.4.2 Layer 2 / Layer 3 Telemetry Baseline

**Captured:** 29 August 2026  
**Purpose:** initial retained baseline for Execution Addendum A14.  
**Authority:** operational metrics only; no canonical/Search/Publication authority.

## Layer 2 acquisition baseline

| Provider | Attempts | Succeeded | Failed | Avg latency ms | P95 latency ms | Historical recorded vendor units | Historical recorded cost USD |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Direct HTTP | 2,234 | 1,430 | 43 | 729.6 | 1,819.7 | 0 | 0 |
| Firecrawl | 740 | 671 | 21 | 8,606.8 | 20,634.9 | 0 | 0 |
| Scrape.do | 52 | 2 | 19 | 4,438.7 | 9,579.25 | 0 | 0 |
| ZenRows | 39 | 2 | 0 | 7,978.6 | 23,841.9 | 0 | 0 |

The historical unit/cost columns reflect what was actually retained before A14. They must not be interpreted as proof that paid/vendor-backed requests consumed no quota or had no subscription cost.

From `layer2-acquire-v2.9`, each new provider attempt retains provider key, latency, request-unit usage basis, vendor units and estimated request cost when available. Direct HTTP records zero vendor units. Non-direct acquisition records one provider request-attempt unit unless a future provider supplies a more authoritative usage unit.

## Layer 3 benchmark baseline

| Configured model | Benchmark runs | External calls | Input tokens | Output tokens | Retained cost USD | Max latency ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free | 4 | 26 | 10,462 | 7,078 | 0 | 22,263 |
| openai/gpt-oss-20b:free | 1 | 7 | 0 | 0 | 0 | 13 |
| openrouter/free | 1 | 5 | 452 | 422 | 0 | 3,229 |

The GPT-OSS trial retained zero tokens because the failed runtime did not return usage. This remains explicit unavailable/zero-retained usage rather than an inferred token count.

Accepted production `pipeline.layer3_interpretations` count remains zero at this checkpoint; therefore production interpretation token totals are correctly zero.

## Standing comparison metrics

Future reviews should compare:
- provider/model attempts and external calls;
- success, failure and Layer 3 fall-out rates;
- average/p95 latency;
- retries;
- scraper/vendor units and quota;
- prompt/input, completion/output and total tokens;
- estimated/measured USD cost;
- Evidence bytes/count;
- fields targeted/resolved;
- time-window changes.

Historical values must remain distinguishable from post-A14 telemetry completeness.


## Managed Layer 2 execution baseline

- managed batches retained: **7**
- aggregate batch vendor units: **483**
- aggregate retained batch cost: **USD 0** (cash cost as currently recorded; not proof that subscriptions are free)
- managed run items retained: **589**
- items with response + extraction timing populated: **111**
- items currently classified Layer 3 required: **106**
- historical rows with retry_count > 0: **220**; note M2.4.2 corrected earlier first-attempt retry semantics, so time/profile context must be considered before treating historical retry counts as comparable.

Use provider-attempt metrics for acquisition-provider comparisons and managed-run metrics for execution/fall-out comparisons. Do not sum unlike usage bases without labelling them.


### A14 scheduled-discovery telemetry completion

The A14 audit identified and closed the separate scheduled-discovery telemetry path. `layer2-scope-discover-scheduled-v1.3.2` (deployed Edge version 19) now records provider key, request-unit usage basis, vendor units, latency and estimated request cost where available for scheduled discovery, fallback/failure and Course detail identity-verification attempts. Security remains 131 INFO / 0 WARN / 0 ERROR; Performance remains 167 INFO / 0 WARN / 0 ERROR.


### A14 active-path audit completion

Active Edge audit confirms exactly three current Layer 2 functions start provider attempts: `layer2-acquire-v2` v9, `layer2-scope-discover-scheduled` v19 and `layer2-scale-qualify-scheduled` v3. All three now retain vendor-unit usage and estimated-cost fields where available in addition to provider/latency/outcome telemetry. No other active Layer 2 provider-attempt starter was found. Post-deploy Security remains 131 INFO / 0 WARN / 0 ERROR; Performance remains 167 INFO / 0 WARN / 0 ERROR.


### A14 Layer 3 active-call audit completion

Active chat-completion audit confirms three current Layer 3 model callers: `layer3-interpret` v3, `layer3-provider-control` v2 and `layer3-source-pattern-benchmark` v7. All retain model identity, external-call count, input/output tokens, latency and cost where available. Interpretation failures now retain call count/latency, and credential verification retains its small token/cost footprint rather than hiding it. New nullable telemetry columns preserve unavailable provider usage without inference. Post-DDL/Edge Security remains 131 INFO / 0 WARN / 0 ERROR; Performance remains 167 INFO / 0 WARN / 0 ERROR.


## Final accepted M2.4.2 telemetry snapshot — 29 August 2026

Captured immediately after corrective Stage C PASS.

### Layer 2 acquisition

| Provider | Attempts | Succeeded | Failed | Avg latency ms | P95 latency ms |
| --- | ---: | ---: | ---: | ---: | ---: |
| Direct HTTP | 2,246 | 1,442 | 43 | 732.3 | 1,818.5 |
| Firecrawl | 740 | 671 | 21 | 8,606.8 | 20,634.9 |
| Scrape.do | 52 | 2 | 19 | 4,438.7 | 9,579.3 |
| ZenRows | 39 | 2 | 0 | 7,978.6 | 23,841.9 |

The zero historical provider-attempt cost/unit totals remain a retained-data limitation, not evidence that subscription providers consumed no quota or commercial value. A14 instrumentation is prospective and must remain distinct from historical pre-A14 records.

### Layer 3 benchmark usage

- Nemotron reasoning profile: **26 external calls**, **10,462 input tokens**, **7,078 output tokens**, retained cost USD 0, max latency 22,263 ms.
- OpenRouter/free trial: **5 calls**, **452 input tokens**, **422 output tokens**, retained cost USD 0, max latency 3,229 ms.
- GPT-OSS free trial: **7 calls**; token usage was not returned and remains explicitly unavailable/zero-retained rather than inferred.
- Accepted production Layer 3 interpretations: **0** at M2.4.2 closure.

### Acceptance relationship

These metrics are operational evidence only. They do not create canonical, Search or Publication authority. The Layer 3 source-pattern benchmark remains blocked under its existing quality threshold and carries into M2.4.3.
