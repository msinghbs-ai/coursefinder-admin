# CourseFinder Master Project Plan v1.67

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE — M1 FROZEN / M2 CONSOLIDATED / PRODUCTION DELIVERY BASELINE  
**Date:** 25 August 2026  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.66.md`  
**Change Control:** `CF-CHG-20260825-031`  
**Detailed delivery/TSOW:** `docs/coursefinder-m2-production-delivery-plan-tsow-v1.0.md`

## Programme position

Milestone 1 remains CLOSED / PASS / FROZEN for the governed Pilot baseline.

Milestone 2 is now the consolidated delivery programme that absorbs the former AU structured-enrichment, AU Scholarship and NZ enrichment workstreams and extends them through Production security, Layer 2 scale, Layer 3 operations and full Production-stack acceptance.

The programme retains separate later gates for the governed consumer API/Zoho contract and Search/publication/release handover.

## Current sequence

| Milestone | Status | Window | Planned hours | Outcome |
|---|---|---|---:|---|
| M2.0 — Programme Consolidation & Auto-UAT | COMPLETE / RECORDED | 22–24 Aug | 8 | programme consolidation, milestone governance and automated UAT baseline |
| M2.1 — Layer 2 Platform | CLOSED / PASS | 24–25 Aug | 3 | deterministic L2 provider/evidence/extraction/completeness platform |
| M2.2 — Security & Production Foundation | NEXT | 26 Aug–4 Sep | 10 | Production trust/security/deployment/recovery design and hardening |
| M2.3 — L2 Scale Enrichment & L1/L2 UX Maturity | PLANNED | 5–11 Sep | 12 | controlled AU/NZ scale-out and mature operational UX |
| M2.4 — L3 AI Operations & Pre-Blackout Gate | PLANNED | 12–15 Sep | 7 | governed L3 interpretation and safe L4 fall-out |
| BLACKOUT | NO DELIVERY | 16–30 Sep | 0 | no planned project work |
| M2.5 — Full Production Stack Deployment & Acceptance | PLANNED | 1–7 Oct | 12 | isolated Production environment fully deployed and accepted |
| M3 — Consumer API / Zoho | PLANNED | 8–14 Oct | 10 | browser-safe consumer contract and Zoho integration |
| M4 — Search / Publication / Production Handover | PLANNED | 15–21 Oct | 8 | explicit publication gate, regression, release and handover |

**Post-M1 engineering envelope:** 70 h.  
**Recorded through 25 Aug:** 11 h.  
**Remaining planned envelope:** 59 h.

## Weekly hours rule

Active delivery periods target approximately 8–12 engineering hours per week. The accepted detailed split is maintained in `docs/coursefinder-m2-production-delivery-plan-tsow-v1.0.md`.

## Production scope

Production scope includes a separate paid-plan Supabase project, governed migrations/data seed, Auth/RBAC/RLS/RPC hardening, private Evidence Storage, Vault/server secrets, Layer 1–4 runtime, mature Admin/PIM operations, protected GitHub Production CI/CD, Cloudflare Production environment, automated UAT, monitoring, backup/restore/DR, consumer API/Zoho, Search/publication governance and final operations handover.

Production is a separate trust boundary; Pilot credentials/secrets/state are not Production authority.

## Security rule

Security remains the primary acceptance gate. No milestone may close PASS with unexplained Critical/High findings, untested privileged mutation boundaries, exposed secrets, missing negative-authorisation tests, unverified restore, or unbounded publication consequences.

## Blackout rule

No planned implementation, deployment, milestone UAT or project delivery occurs from **16 September through 30 September 2026 inclusive**. Emergency work requires separate explicit authorisation and time recording.

## Standing milestone record

Every milestone meeting must reconcile objective/use cases, implementation refs, security, data authority, automated UAT, evidence, scale/cost/storage, UX, monitoring/restore, residual risks, expenses, hours consumed/remaining, closure state and next gate.

Use:

- `docs/coursefinder-milestone-governance-standard-v1.0.md`;
- `docs/coursefinder-m2-production-delivery-plan-tsow-v1.0.md`;
- `docs/coursefinder-engagement-time-log.md`.
