# CourseFinder Admin/PIM Design Decisions v1.13

**Status:** **CURRENT — ACCESS ADMIN v1.0 / UAT HARNESS v1.0 / DQ SNAPSHOT ACCEPTED**  
**Effective:** 23 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.12.md`  
**Change Controls:** `CF-CHG-20260822-019`, `CF-CHG-20260822-020`, `CF-CHG-20260823-021`

All accepted v1.12 PIM, Pipeline, Evidence and Data Quality semantic decisions remain in force. This revision adds the operational/security decisions below.

## DD-ACCESS-01 — Platform Admin is the only browser identity-administration authority

Creating/inviting users, replacing governed role assignments and disabling/re-enabling accounts require effective Platform Admin rank 6.

Frontend visibility is not authorization. The privileged action must validate the signed-in user server-side before using Auth Admin/service-role capabilities.

## DD-ACCESS-02 — Service-role authority stays server-side

Access Admin uses a JWT-protected Edge Function. The browser sends its normal signed-in user JWT; the function validates CourseFinder Platform Admin rank and only then instantiates the service-role client.

No service-role key may be returned to or embedded in browser code, UAT source or governance evidence.

## DD-ACCESS-03 — Highest active role remains effective access

`security.user_roles` remains additive. Effective access is the highest active, unexpired governed role. Access Admin may replace assignments but does not introduce a second authorization model.

Non-Platform-Admin roles may have expiry. `platform_admin` expiry is not allowed in v1.

## DD-ACCESS-04 — Platform lockout protections are server invariants

The system must reject Platform Admin self-disable/self-removal and removal/disablement of the last active Platform Admin. These controls are proven through safe negative server UAT; destructive testing of the sole Platform Admin is not required for browser acceptance.

## DD-ACCESS-05 — Access mutations create private audit history

User create/invite, role replacement and disable/enable mutations create server-side access events with actor/target and safe before/after state. Passwords, tokens and session material are excluded.

## DD-DQ-08 — Aggregate readiness may be snapshot; exceptions remain live

The accepted Data Quality semantic model is unchanged. At AU+NZ scale, aggregate readiness is served from a private timestamped server snapshot refreshed out-of-band. Exception drill-down remains a live bounded/paged query.

The UI must expose the aggregate computation timestamp/freshness so operators are not misled into treating a snapshot as a live transactional count.

## DD-DQ-09 — Do not solve aggregate cost by increasing browser timeout

Heavy aggregate computation is separated from the authenticated browser request. The 8-second authenticated statement timeout remains intact; browser reliability is achieved by execution architecture, not by concealing a slow query behind a longer timeout.

## DD-UAT-01 — Every promoted Pilot main can run authenticated desktop/mobile acceptance

The deployed UAT harness is a release control. A main promotion triggers governed desktop and mobile browser acceptance using normal Supabase Auth and publishes SHA-bound GitHub status contexts.

## DD-UAT-02 — Unexpected 5xx is a release failure

Unexpected HTTP 5xx observed during the governed critical path fails deployed UAT even if the UI later recovers. 4xx/console/page errors are retained as diagnostics and must be reviewed in final artefacts.

## DD-UAT-03 — Failing automation must distinguish product defect from test defect

A failing assertion is evidence to investigate, not automatically a product defect. Run artefacts, DOM/accessibility snapshots, runtime network evidence and server logs are used to classify failures. Test defects may be corrected without changing accepted product semantics; real responsive/runtime defects must be fixed and re-run.

## DD-UAT-04 — Desktop success cannot substitute for mobile success

Both required deployed contexts must pass before release acceptance when the change affects responsive Admin operation. The mobile Data Quality scroll-container defect discovered during CF-CHG-021 demonstrates why this is an independent gate.

## Accepted release reference

- Pilot: `msinghbs-ai/Coursefinder-Pilot@e877e3e28cd281ff3751a70bc500eeb0d8f31963`;
- deployed UAT run: `32600027592` — desktop 3/3 PASS, mobile 3/3 PASS;
- Access Admin: `CF-CHG-20260822-020` — CLOSED / PASS;
- UAT Harness: `CF-CHG-20260822-019` — CLOSED / PASS;
- Data Quality snapshot hardening: `CF-CHG-20260823-021` — CLOSED / PASS;
- Database Architecture: v2.10.39;
- Admin Guide: v1.14;
- Running Build: v2.63.
