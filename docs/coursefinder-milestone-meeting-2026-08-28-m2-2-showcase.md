# CourseFinder Milestone Meeting — M2.2 Security / Production / Search Showcase

**Meeting date:** Friday 28 August 2026  
**Prepared/final technical state:** 25 August 2026  
**Milestone:** M2.2  
**Current gate state:** **CLOSED / PASS — SHOWCASE READY**

## Milestone objective

Demonstrate the accepted M2.1 Layer 2 platform and the completed M2.2 progression covering Supabase Pro security, Production trust architecture, representative AU/NZ enriched data, deterministic Search/filtering and a bounded website-developer read contract without granting broad Publication or Production consumer authority.

## Final status

- M1 remains frozen; M2.1 remains CLOSED / PASS.
- Supabase organisation verified on Pro.
- leaked-password protection is enabled and live Security Advisor verified; the former material Auth WARN is absent.
- privileged Layer 2 policy mutation is behind JWT-enforced Edge/server controls; direct authenticated RPC execution is revoked.
- Search Projection remains 33,105 AU+NZ `course-v3` documents, generation 22, with zero broad Publication.
- bounded service-side exact/FTS/filter website Search/read contract is implemented and UAT-proven.
- pgvector 0.8.2 is installed, but vector/hybrid is explicitly deferred because there is no governed embedding model/profile/corpus.
- final deployed desktop and mobile automated UAT passed on the same final Pilot SHA.
- M2.2 is CLOSED / PASS for the implemented Pilot Security/Production/Search showcase scope.

## Final implementation refs

Final Pilot SHA: `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`.

Key progression refs:

- `7274bbb58a408b32530cdaa421e31036eb35d16d` — hardened Layer 2 Edge control;
- `016f902e5dbdcda7ef1913e3f89cdef32c667209` — Layer 2 UI mutation routed through Edge;
- `703cc2cc03f8728d5bd9a7bbae0ccb9f600648bb` — direct authenticated policy RPC revoke;
- `ab369e074812df076d58952ab5ce1c73797a887b` — exact Admin Course lookup hardening;
- `cf5df7a38da4411768b1fea018e3e275c0d276ac` — website exact lookup plan hardening;
- `38ad08bb75ee7cf26a0a701a3ae008d1563b915b` — website FTS plan hardening / final candidate.

Governance:

- `CF-CHG-20260823-022` — leaked-password protection CLOSED / PASS;
- `CF-CHG-20260825-032` — programme acceleration CLOSED / PASS;
- `CF-CHG-20260825-033` — deterministic Search CLOSED / PASS; vector/hybrid DEFERRED;
- `CF-CHG-20260825-034` — Pilot Security & Production Foundation CLOSED / PASS;
- `CF-CHG-20260825-035` — consolidated automated UAT CLOSED / PASS.

## Automated UAT

Final build run `32840377937`: PASS.

Final deployed run `32840377935`: PASS.

- desktop job `97778367860`: PASS;
- mobile job `97778367490`: PASS;
- desktop artifact `9560350909`, digest `sha256:b72ab53cfb77435d2508af645f5ed478b07655f1cc80460ace15c7552f80f677`;
- mobile artifact `9560520848`, digest `sha256:3504e06bd8c22f31203a87f17ef81914a293e0571aa2f99db29afb3fa0a7683c`.

Representative final desktop runtime evidence:

- Layer 2 Operations overview: 445 ms;
- Providers page: 1,238 ms;
- Courses page: 1,841 ms;
- Evidence page: 788 ms;
- Data Quality overview: 392 ms;
- exact Course interaction request: 963 ms;
- Course detail: 986 ms.

Search database benchmark after fixes:

- website exact lookup: ~17 ms measured;
- website `data science` + AU FTS preview: ~281 ms measured;
- no 3-second deployed RPC threshold was relaxed.

## Search / pgvector decision

**Accepted for Friday:** exact Course/code lookup, deterministic FTS, structured filters, bounded pagination/sorting and consumer-safe DTO via the server-side preview contract.

**Deferred / not accepted:** pgvector/vector/hybrid relevance. Embeddings/jobs/cache/model profiles remain zero. No synthetic embeddings were generated.

Website developer contract: `docs/coursefinder-website-developer-search-read-contract-v1.0.md`.

## Showcase-ready workflow

1. Dashboard and current AU/NZ Catalogue state.
2. Regulatory Provider/Course identity.
3. Provider-current Layer 2 facts with Evidence/provenance.
4. Factual completeness uplift with unresolved values left explicitly unresolved.
5. Layer 2 Operations → Provider Attempts → Evidence lifecycle.
6. Search Projection generation/state and zero broad Publication.
7. Exact-code and deterministic FTS/filter demonstration.
8. Fee semantics: CRICOS regulatory tuition versus Provider-current annual tuition.
9. pgvector readiness plus evidence-based defer decision.
10. Website developer request/filter/DTO/server-boundary discussion.
11. Clean Production trust/recovery/release path.

## Representative real cohort

- UQ `082960F` — Bachelor of Nursing (Honours): regulatory tuition AUD 37,920 registered-total-course; Provider-current annual tuition AUD 48,080; Intake/English/official URL; unpublished.
- UQ `092454G` — Master of Data Science: Provider-current annual tuition AUD 60,952 with Intake/English.
- UQ `102784C` — Bachelor of Computer Science (Honours): exact lookup example.
- RMIT `111279A` — Associate Degree in Business: Provider-current annual tuition AUD 37,440 with Intake/English.

Scholarship Search coverage remains zero; no unsupported demo Scholarship value is to be created.

## Security status

All M2.2 Pilot security controls are now PASS. Current Security Advisor no longer reports leaked-password protection disabled. Remaining advisor notices are INFO-level RLS/no-policy findings on private/internal tables and are retained for Production policy design rather than treated as browser exposure.

## Costs / engineering hours

- Supabase Pro: project expense, amount to come from the actual billing record; no amount fabricated.
- Confirmed engineering hours remain those already approved in the milestone time record; no additional billable hours are inferred from technical execution.

## Next gate

Proceed to clean Production establishment/release readiness under the current Master Plan/TSOW. Production project creation, protected deployment, backup/PITR/restore execution, Production Auth/security regression, broad Publication and Zoho cutover remain separately governed.