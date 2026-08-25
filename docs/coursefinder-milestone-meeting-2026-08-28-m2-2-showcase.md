# CourseFinder Milestone Meeting — M2.2 Security / Production / Search Showcase

**Meeting date:** Friday 28 August 2026  
**Prepared:** 25 August 2026  
**Milestone:** M2.2  
**Current gate state:** IN PROGRESS / NOT YET PASS

## Milestone objective

Demonstrate the accepted M2.1 Layer 2 platform and a defensible M2.2 progression covering Supabase Pro security, Production trust architecture, representative AU/NZ enriched data, deterministic Search/filtering and a bounded website-developer read contract without granting broad Publication or Production consumer authority.

## Completed / evidenced

- M2.1 remains CLOSED/PASS and is inherited.
- Supabase organisation verified on Pro.
- Pilot remains Mumbai; Production remains a separate clean future Sydney-target environment.
- privileged Layer 2 policy mutation moved behind JWT-enforced Edge/server boundary; direct authenticated RPC execute revoked.
- former Layer 2 SECURITY DEFINER advisor WARN removed.
- pgvector 0.8.2 runtime verified.
- current vector corpus verified as zero; no model profile exists.
- Search Projection reconciled at 33,105 AU+NZ documents, generation 22.
- bounded service-only exact/FTS/filter website preview contract implemented.
- website developer DTO/filters/error/boundary contract documented.
- real enriched examples identified for showcase without fabricated values.
- direct FTS/index behaviour benchmarked; query-plan regression in richer preview surfaced rather than concealed.

## Current implementation refs

### Pilot

- `7274bbb58a408b32530cdaa421e31036eb35d16d` — hardened Layer 2 Edge function source;
- `016f902e5dbdcda7ef1913e3f89cdef32c667209` — Layer 2 UI mutation path routed through Edge;
- `703cc2cc03f8728d5bd9a7bbae0ccb9f600648bb` — direct authenticated policy RPC revoke migration;
- `5370ebd681d4c1c826dc2370c754085161935167` — initial bounded website Search preview;
- `045d5960ab1932eaa86ad459041ab3d5cd0659d9` — split exact lookup/FTS preview and indexes.

### Admin governance/docs

- CF-CHG-20260825-032 — programme acceleration;
- CF-CHG-20260825-033 — bounded Search/pgvector;
- CF-CHG-20260825-034 — Security & Production Foundation;
- CF-CHG-20260825-035 — consolidated UAT/release.

## UAT status

- Supabase Pro entitlement: PASS.
- direct Layer 2 privileged browser RPC removal: PASS.
- Search preview privilege boundary: PASS.
- broad publication remains disabled: PASS invariant.
- leaked-password protection: BLOCKED — still disabled in Security Advisor.
- vector/hybrid relevance: DEFERRED / NOT ACCEPTED — no governed model/profile/corpus.
- Search database/index path: partial PASS; direct FTS ~18 ms and exact predicate ~31 ms measured, rich preview wrapper still ~0.38–0.44 s and under optimisation.
- deployed desktop/mobile UAT: current final-SHA run pending at preparation time; must be reconciled before gate closure.

## Showcase-ready workflow

1. Dashboard / Catalogue context.
2. Open Provider/Course with regulatory identity.
3. Show Provider-current Layer 2 fact and its Evidence/provenance.
4. Show factual completeness improvement while unresolved domains remain explicitly unresolved.
5. Show Layer 2 Operations → Provider Attempts → Evidence lifecycle.
6. Show Search Projection status/version/hash and publication state.
7. Demonstrate exact-code lookup and deterministic FTS/filter contract using real current data.
8. Demonstrate fee semantics: CRICOS regulatory tuition versus Provider-current annual tuition.
9. Explain pgvector state with evidence: extension available, schema prepared, zero corpus/model profile, therefore not falsely accepted.
10. Walk website developers through request filters, DTO, server/browser boundary and next contract gate.

## Recommended real showcase cohort

- UQ `082960F` — Bachelor of Nursing (Honours): regulatory tuition AUD 37,920 registered-total-course; Provider-current annual tuition AUD 48,080; Intake and English data; official URL; unpublished.
- UQ `092454G` — Master of Data Science: Provider-current annual tuition AUD 60,952 with Intake/English.
- UQ `102784C` — Bachelor of Computer Science (Honours): exact code lookup example.
- RMIT `111279A` — Associate Degree in Business: Provider-current annual tuition AUD 37,440 and Intake/English.

Scholarship Search coverage is currently zero; no demo Scholarship value is to be fabricated.

## Security status

No unexplained newly introduced Critical/High browser exposure has been accepted. One material Auth WARN remains: leaked-password protection disabled. Three internal Search gate tables have RLS disabled; normal browser roles currently have no Search schema usage/direct grants, so this is retained as an explicit defence-in-depth Production policy item rather than blindly enabling RLS and breaking internal projection operations.

## Costs / expenses

Supabase Pro subscription: record as a project expense separately from engineering time. Exact subscription amount should come from the actual billing record; this meeting record does not fabricate cost.

## Engineering hours

Confirmed engagement hours remain governed by the current milestone time record. No additional hours are inferred from technical task completion. Current programme baseline recorded 11 confirmed hours through 25 August 2026; later hours must be explicitly confirmed before being treated as billable.

## Remaining planned hours

The prior programme baseline carried 59 planned hours after the confirmed 11 hours. The Friday acceleration changes task sequencing/scope but does not automatically change billable-hour confirmation. The next plan/TSOW version records this distinction explicitly.

## Blockers / residual risks

- leaked-password protection is still disabled despite Pro entitlement;
- no governed embedding model/profile/provider is configured;
- rich Search preview wrapper needs further latency optimisation for a Production claim;
- final deployed desktop/mobile UAT must complete against final source SHA;
- clean Production environment, protected Production deployment environment and executed restore remain later gated work;
- no Publication authority granted.

## Exact next gate

Close M2.2 only after final automated security/browser regression and resolution/disposition of the Pro Auth blocker. Continue the stable deterministic Search/read contract into the next consumer integration gate; establish a separate vector benchmark gate only after an explicit embedding model/profile is approved and reproducible.
