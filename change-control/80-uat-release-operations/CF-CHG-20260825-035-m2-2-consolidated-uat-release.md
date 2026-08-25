# CF-CHG-20260825-035 — M2.2 Consolidated Automated UAT & Release Gate

**Status:** **CLOSED / PASS — IMPLEMENTED SCOPE**  
**Category:** 80-uat-release-operations  
**Initiated:** 25 August 2026 20:08 AEST (+10:00)  
**Closed:** 25 August 2026 21:15 AEST (+10:00)  
**Origin:** M2.2 — SECURITY-PRODUCTION-SEARCH-SHOWCASE  
**Owner:** CourseFinder UAT/release operations

## Scope accepted

Automated evidence was completed for the M2.2 implementation that can be executed in the current Pilot/runtime boundary:

- M2.1 Layer 2 regression safety;
- Auth/RBAC/RPC/RLS/Storage/Vault/Edge security checks;
- Supabase Pro entitlement/control-state reconciliation;
- deterministic Search exact lookup, FTS and structured filters;
- pgvector candidate decision;
- server-side website-developer read-contract boundary;
- query-plan and latency corrections;
- SHA-bound desktop and mobile deployed-browser regression;
- Publication non-escalation and canonical/Search invariants.

## Final evidence

Final Pilot SHA: `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`.

- Frontend build run `32840377937`: PASS.
- Deployed UAT run `32840377935`: PASS.
- Chromium desktop job `97778367860`: PASS.
- Chromium mobile job `97778367490`: PASS.
- Desktop artifact `9560350909`, digest `sha256:b72ab53cfb77435d2508af645f5ed478b07655f1cc80460ace15c7552f80f677`.
- Mobile artifact `9560520848`, digest `sha256:3504e06bd8c22f31203a87f17ef81914a293e0571aa2f99db29afb3fa0a7683c`.

Final desktop evidence remained within the existing 3-second governed RPC budget. Representative values: Layer 2 overview 445 ms, Layer 2 profiles 431 ms, Providers page 1,238 ms, Courses page 1,841 ms, Evidence 788 ms, Data Quality 392 ms, exact Course interaction request 963 ms, Course detail 986 ms.

## Security result

- direct authenticated Layer 2 privileged policy RPC: denied;
- JWT-enforced Edge/server mutation path: accepted;
- Search preview functions: normal browser roles denied, service role allowed;
- raw private Search/Vault boundaries retained;
- final Publication count remains zero;
- sole material external Security Advisor WARN: leaked-password protection disabled.

The leaked-password control is tracked under `CF-CHG-20260823-022` / `CF-CHG-20260825-034`; its inability to close does not invalidate the successful automated UAT of implemented scope, but it blocks overall M2.2 acceptance under the milestone's mandatory Auth wording.

## Search result

The gate found and corrected real performance regressions rather than changing test thresholds:

- Admin exact lookup: >3 s regression corrected; representative database path ~288 ms;
- website exact preview: ~8.78 s -> ~17 ms;
- website AU FTS preview: ~4.74 s -> ~281 ms.

Exact/FTS/filter Search is accepted for the bounded showcase. Vector/hybrid is explicitly deferred because no governed embedding profile/corpus exists.

## Deferred later-environment proof

A real Production restore is not fabricated in Pilot. Backup/PITR/isolated restore execution remains an explicit acceptance requirement for the clean Production establishment/cutover gate.

## Closure

**Final status: CLOSED / PASS — IMPLEMENTED SCOPE.**

Full technical evidence is retained in `docs/uat/coursefinder-m2-2-security-search-showcase-2026-08-25.md`. Overall M2.2 remains BLOCKED only by the separately evidenced managed leaked-password control.