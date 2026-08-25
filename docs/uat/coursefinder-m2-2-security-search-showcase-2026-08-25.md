# CourseFinder M2.2 Automated UAT — Security / Search / Showcase

**Run date:** 25 August 2026  
**Status:** **CLOSED / PASS — IMPLEMENTED M2.2 PILOT SCOPE**  
**Change Controls:** CF-CHG-20260825-032, -033, -034, -035; CF-CHG-20260823-022

## Evidence baseline

- Accepted M2.1 Pilot baseline: `cba0e9ecd2f4878bfd51ad5278e60046b1fae581`, deployed UAT run `32795496640`.
- Final M2.2 Pilot source/deployed candidate: `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`.
- Final Pilot Frontend Build: run `32840377937` — PASS.
- Final deployed-browser UAT: run `32840377935` — PASS on Chromium desktop and mobile.
- Desktop evidence artifact: `9560350909`, `sha256:b72ab53cfb77435d2508af645f5ed478b07655f1cc80460ace15c7552f80f677`.
- Mobile evidence artifact: `9560520848`, `sha256:3504e06bd8c22f31203a87f17ef81914a293e0571aa2f99db29afb3fa0a7683c`.
- Supabase Pilot: `fxcwkweaxjtknorudmwp`, Mumbai `ap-south-1`, PostgreSQL 17.6.1.
- Supabase organisation plan: `pro`.

## Security UAT

| Test | Final evidence | Result |
|---|---|---|
| Pro entitlement | live organisation plan = `pro` | PASS |
| Leaked-password protection | authorised Dashboard enablement completed; live Security Advisor no longer reports `auth_leaked_password_protection` | **PASS** |
| Direct Layer 2 privileged RPC | anon/authenticated EXECUTE false; service_role true | PASS |
| Hardened Layer 2 mutation boundary | `layer2-config-control` v3, `verify_jwt=true`, current actor/rank validation and policy allowlist | PASS |
| Security Advisor regression | previous material leaked-password and Layer 2 SECURITY DEFINER WARNs absent; remaining notices are INFO-level RLS/no-policy items | PASS |
| Website Search preview exposure | anon/authenticated EXECUTE false; service_role true | PASS |
| Search raw-schema browser access | no normal browser `search` schema/table CRUD boundary | PASS |
| Vault browser access | anon/authenticated Vault schema USAGE false | PASS |
| Publication escalation | final published entity count remains 0; preview metadata states `publication_authority=not_granted` | PASS |
| Search gate-table defence-in-depth | internal gate-table policy design remains a Production item; no browser exposure was introduced | PASS for current Pilot boundary / Production action retained |

## Frozen/regression invariants

Final live checks after Auth enablement and M2.2 hardening:

- catalogue Courses: 43,461;
- Providers: 3,085;
- Search documents: 33,105;
- AU Search documents: 26,648;
- NZ Search documents: 6,457;
- Search Projection: `course-v3`, generation 22;
- Search Projection hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`;
- embeddings: 0;
- embedding jobs: 0;
- query embedding cache: 0;
- published entities: 0.

M2.1 Layer 2 authority, Evidence and canonical identity boundaries were not reopened or redefined.

## Search/read-contract UAT

### Functional behaviour

- exact CRICOS lookup `102784C` returns the expected Course through `website-course-lookup-preview-v1`;
- exact stable Course ID `course:cricos:00025b:102784c` returns the same stable identity;
- AU FTS query `data science` returns a bounded result page;
- structured AU / QLD / masters / tuition / Intake / English filters return a bounded matching cohort;
- no-result exact lookup returns JSON null safely;
- consumer preview remains service-side only and does not grant Publication authority.

### Performance defects found and corrected

The automated gate rejected real query-plan regressions rather than weakening thresholds:

1. Admin exact-CRICOS Course lookup initially exceeded the deployed 3-second RPC budget. `security.admin_course_page_fast` was hardened with an indexed exact-identity route. Database UAT then measured about 288 ms for the representative exact lookup under the UAT actor context.
2. Website exact-read preview initially measured about 8.78 s cold. Splitting indexed Course-code and stable-ID branches reduced the measured wrapper to about **17 ms**.
3. Website FTS preview initially measured about 4.74 s because the generic optional-query predicate defeated the intended GIN path. Separating query and filter-only branches reduced the measured `data science` + AU preview to about **281 ms**.

Final deployed desktop evidence remained inside the existing 3-second RPC budgets without threshold relaxation. Representative final desktop artefact values include:

- Layer 2 Operations overview: 445 ms;
- Layer 2 profiles: 431 ms;
- Providers page: 1,238 ms;
- Courses page: 1,841 ms;
- Evidence page: 788 ms;
- Data Quality overview: 392 ms;
- exact Course interaction page request: 963 ms;
- Course detail: 986 ms.

## pgvector decision

- pgvector 0.8.2 installed;
- `search.course_embeddings`: 0;
- embedding jobs/cache: 0;
- governed `integration.model_profiles`: 0;
- no accepted reproducible embedding provider/model/profile was found.

**Decision:** vector/hybrid is **EXPLICITLY DEFERRED / NOT ACCEPTED**. Synthetic/demo embeddings are prohibited. Exact lookup + deterministic FTS + structured filters are the accepted bounded Friday Search/read demonstration.

## Deployed browser UAT

Final SHA `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`:

- build run `32840377937`: PASS;
- deployed UAT run `32840377935`: PASS;
- Chromium desktop job `97778367860`: PASS;
- Chromium mobile job `97778367490`: PASS;
- both jobs uploaded SHA-bound evidence and published successful deployed-UAT commit status.

The subsequent leaked-password managed Auth enablement did not alter application source, grants, Search projection or canonical data. Post-enablement security/invariant SQL regression and Security Advisor verification passed.

## Recovery / Production boundary

Production remains a clean later environment. M2.2 defines the Pro backup/PITR/restore acceptance requirements but does not fabricate a Production restore before that separate project exists. Executed restore proof is explicitly deferred to the accepted Production establishment/cutover gate.

## Final UAT verdict

**CF-CHG-20260825-035: CLOSED / PASS.**  
**CF-CHG-20260825-034: CLOSED / PASS — Pilot security foundation.**  
**CF-CHG-20260823-022: CLOSED / PASS — Pilot leaked-password protection.**

The implemented M2.2 Pilot scope is reproducible on final Pilot SHA `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`, with final Auth security state independently verified after managed Dashboard enablement.

This PASS does **not** grant broad Publication, Production consumer exposure, Zoho cutover, Production restore acceptance or final Production handover authority.