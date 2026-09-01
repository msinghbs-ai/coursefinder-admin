# CourseFinder UAT & Performance Baseline v1.0

**Status:** CURRENT POST-M2.4 BASELINE  
**Issued:** 1 September 2026  
**Related:** `CF-CHG-20260901-050`

## Accepted final M2.4.4 evidence

- Pilot `95f2991e97e76e644bd74f73512b8bf2725fd4b7`
- build `33468512538` PASS
- final UAT `33468512515` PASS
- desktop: 75 passed
- mobile: 76 passed

## Permanent acceptance suite domains

1. Layer 1 operations
2. Data Quality/readiness
3. Performance/payload budgets
4. Layer 2 operations maturity
5. Layer 2 platform/profile configuration
6. Layer 2 Provider operations
7. Administration navigation/deep links
8. Course detail UX
9. screen-state persistence
10. cross-layer intelligence
11. Layer 3 credentials
12. Layer 3 operations
13. cross-layer operations
14. Layer 4 intervention boundaries
15. permanent Layer navigation
16. responsive detail blades
17. background/quota-aware Firecrawl
18. unified Layer headers
19. Evidence type/MIME/screenshot integrity
20. Layer status
21. parent-run/operator UX
22. Scholarship decision support
23. release notes
24. paged filters
25. contextual QILT/PRISMS/Scholarship insights
26. Layer 2 demo/filter trace
27. Provider international contacts

## Standing performance budgets

- RPC/detail interaction ≤ 3,000 ms
- management/page payload ≤ 250,000 bytes
- filter/options payload ≤ 60,000 bytes

## Standing performance principles

- page entity IDs/rows before expensive enrichment;
- bounded projections, no full-registry payloads;
- API reads do not trigger acquisition;
- background ingestion has quota/concurrency control;
- Website/Zoho cache stable reference data;
- version keys invalidate caches;
- load testing must include simultaneous background work where that reflects Production;
- test DB-boundary and browser/API latency separately;
- do not weaken thresholds to absorb contention.

## Future UAT additions

### Country onboarding
- source qualification;
- identity safety;
- expected-count variance;
- idempotency;
- malformed/null input;
- source-version change;
- disable/rollback;
- Pilot vs Production isolation.

### Provider collections
- official collection source;
- membership validity/history;
- Provider UI display;
- filters;
- consumer facet;
- invalid/expired membership.

### Manual create/edit
- duplicate detection;
- provisional lifecycle;
- authority reconciliation;
- L4 audit;
- rank/negative tests;
- Search/Publication remains off by default.

### Blocking
- Provider/Course block/unblock;
- cascading options;
- Search/Publication exclusion;
- scheduling exclusion;
- reason/audit/expiry.

### Storage/maintenance
- dashboard metrics;
- alert thresholds;
- retention dry-run;
- immutable Evidence exclusion;
- reclaim verification;
- backup/PITR state.

### Scraper onboarding
- credential isolation;
- quota/cost;
- acquisition success/failure;
- MIME/Evidence;
- timeout/retry;
- fallback;
- Pilot-only enablement;
- Production enablement separately.

### AI onboarding
- model profile qualification;
- benchmark + negative controls;
- schema validation;
- token/cost limits;
- fallback;
- confidence/fall-out;
- Evidence-only input boundary;
- no direct canonical mutation.

### Consumer caching
- bootstrap/reference bundle;
- ETag/version;
- stale-cache behaviour;
- invalidation;
- bounded query cache;
- no sensitive/private data in consumer cache.
