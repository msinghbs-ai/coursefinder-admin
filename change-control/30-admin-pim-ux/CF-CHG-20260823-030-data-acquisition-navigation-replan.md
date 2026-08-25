# CF-CHG-20260823-030 — Data Enrichment Navigation Replan

**Status:** CLOSED / PASS  
**Category:** 30-admin-pim-ux  
**Initiated:** 23 August 2026 21:50 AEST (+10:00)  
**Updated:** 25 August 2026 11:24 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — L2-PLATFORM  
**Owner:** Admin/PIM UX with M2.1 Layer 2 Platform  
**Change class:** Admin information architecture / navigation / operations UX

## Trigger

The first M2.1 navigation pass correctly grouped Pipeline, Source, Provider, Trial, Job and Evidence capabilities, but exposed too many backend concepts as separate management-menu destinations. Management staff need a smaller operational model: what enrichment is scheduled, which provider/routing policy is active, what did the recent run resolve, what did it cost, what Evidence exists and what fell through to Layer 3/4.

QILT and PRISMS are governed Layer 1 contextual datasets and must not appear as Layer 2 paid-acquisition targets.

## Accepted M2.1 decision

The deployed M2.1 primary menu is simplified to:

1. **Overview** — Dashboard
2. **Catalogue** — Providers / Courses / Campuses / Scholarships
3. **Data Enrichment** — Layer 2 Operations / Evidence
4. **Insights** — Outcomes (QILT) / Student Flow (PRISMS)
5. **Quality & Review** — Completeness / Review Queue
6. **Governance & Platform** — Attributes / Settings / Access

Pipeline Control, Source Registry, Layer 2 Source Config, Acquisition Providers, Acquisition Trials and Jobs remain governed operational capabilities but are accessed behind **Layer 2 Operations** through progressive drill-down rather than separate routine menu entries.

## Layer 2 Operations workspace

The accepted M2.1 management landing page exposes:

- enrichment source / country / Courses or Scholarships;
- automation schedule and batch size;
- cost-aware provider routing policy;
- provider readiness / last test;
- Evidence count / review count;
- recent run outcome: processed / L2 resolved / sent to L3 / blocked / cost.

Advanced source configuration, provider credentials/capabilities, trials, Jobs and diagnostic logs remain available only when the operator drills in.

## Progressive disclosure

**Level 1 — Management:** status, schedule, outcome, cost, exceptions.  
**Level 2 — Operations:** run, entity, provider attempts, Evidence.  
**Level 3 — Diagnostics:** source-profile version, runtime region/deployment, storage path/hash, provider trace/rate/credit headers and raw logs.

## Layer boundary

`Layer 1 Authoritative/Regulatory → Layer 2 Deterministic Acquisition/Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`.

Layer 2 never exposes a direct `Send to Layer 4` action. Its fall-out state is `L3 required`; only unresolved/conflicting Layer 3 fall-out appears in Layer 4 Review Queue. There is no Layer 5.

## Implementation

Pilot implementation includes:

- `src/layer2-operations-entry.jsx`;
- `src/layer2-operations.css`;
- `src/data-acquisition-nav-entry.js` v1.4;
- `index.html` Layer 2 Platform visible version v1.4;
- existing advanced launchers hidden from primary navigation and invoked only as drill-down controls;
- deployed navigation/provider UAT coverage.

## Final deployed UAT

Accepted evidence:

- Pilot SHA `cba0e9ecd2f4878bfd51ad5278e60046b1fae581`;
- deployed UAT run `32795496640` — SUCCESS;
- desktop job `97645884152` — PASS;
- mobile job `97645884483` — PASS;
- SHA-bound desktop/mobile evidence artifacts retained.

The run verifies authenticated deployed navigation and Layer 2 provider operations without exposing vendor credentials or service-role material.

## M2 consolidated superseding target

M2.1 navigation is accepted and closed. The next consolidated UI target is now broader: **Layer 1 — Regulatory, Layer 2 — Enrichment and Layer 3 — AI Interpretation** become explicit mature operational workspaces, with Layer 4 remaining terminal human resolution.

Current maintained target IA: `docs/coursefinder-admin-navigation-information-architecture-v1.3.md` under `CF-CHG-20260825-031`.

This later target extends the accepted M2.1 navigation; it does not invalidate the browser acceptance recorded here.

## Rollback

Revert the v1.4 navigation/Layer 2 Operations mounts. Underlying Source/Provider/Trial/Pipeline/Jobs/Evidence controls remain intact.

## Closure

**Final status:** CLOSED / PASS.  
**Closed at:** 25 August 2026 11:24 AEST (+10:00).  
**Outcome:** M2.1 management navigation is accepted; broader Layer 1–3 maturity is governed as the next M2 target.
