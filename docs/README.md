# CourseFinder Documentation — Current Document Index

**Status:** AUTHORITATIVE CURRENT-DOCUMENT ROUTER  
**Effective:** 15 September 2026  
**Governance:** `PROJECT_INSTRUCTIONS.md`, `docs/01-governance/coursefinder-pim-operating-principles-v1.0.md`, `docs/01-governance/coursefinder-troubleshooting-bugfix-recovery-protocol-v1.0.md`, `docs/01-governance/coursefinder-release-version-control-recovery-v1.0.md`  
**Change Control:** CF-CHG-20260903-086; CF-234 recovery-protocol batch; CF-CHG-20260910-093 CLOSED/PASS historical; CF-CHG-20260915-245 CLOSED/PASS M2.4.5 predecessor; CF-CHG-20260915-246 CLOSED/PASS M2.4.6 operations contract; CF-CHG-20260915-247 ACTIVE end-to-end automated admission programme

## Rule

Do not infer the current document from the highest filename version or from chat history. This index identifies the accepted/current document for each core family.

## Current core documents

| Family | Current document | State |
|---|---|---|
| Master Project Plan | `docs/coursefinder-master-project-plan-v1.82.md` | CURRENT |
| Running Build | `docs/coursefinder-running-build-v2.81.md` | CURRENT |
| Database Architecture | `docs/coursefinder-database-architecture-v2.10.50.md` | CURRENT ACCEPTED |
| Admin/PIM Design Decisions | `docs/coursefinder-admin-pim-design-decisions-v1.31.md` | CURRENT |
| Admin Navigation / Information Architecture | `docs/coursefinder-admin-navigation-information-architecture-v1.6.md` | CURRENT |
| PIM Admin Guide | `docs/coursefinder-pim-admin-guide-v1.22.md` | CURRENT |
| Operations Runbook | `docs/coursefinder-operations-runbook-v1.8.md` | CURRENT |
| Data Operations Admin Guide | `docs/coursefinder-m2-4-data-operations-admin-guide-v1.6.md` | CURRENT |
| End-to-End Automated Data Admission Roadmap | `docs/coursefinder-end-to-end-automated-data-admission-roadmap-v1.0.md` | ACTIVE PROGRAMME DELIVERY AUTHORITY |
| Programme PIM Operating Principles | `docs/01-governance/coursefinder-pim-operating-principles-v1.0.md` | CURRENT |
| Troubleshooting / Bug-Fix / Recovery Protocol | `docs/01-governance/coursefinder-troubleshooting-bugfix-recovery-protocol-v1.0.md` | CURRENT |
| Release / Version Control & Recovery | `docs/01-governance/coursefinder-release-version-control-recovery-v1.0.md` | CURRENT |
| University Ranking Data Design | `docs/coursefinder-university-ranking-data-design-v1.1.md` | CURRENT |

## Active milestone router

- M1: CLOSED / PASS / FROZEN.
- M2.1–M2.4.5: CLOSED / PASS; M2.4.5 is FROZEN at predecessor Pilot `e62c01cadaf43efa8c3d8ea57625c23874d1b010`.
- M2.4.6: CLOSED / PASS / FROZEN at Pilot `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a` under CF-CHG-20260915-246.
- **M2.4.7: ACTIVE — CONTROLLED OPERATIONAL SCALE, governed by the end-to-end automated admission outcome rather than raw wave volume.**
- M2.4.8: planned consumer/data-operations readiness after M2.4.7.
- M2.4.9: planned production dress rehearsal and explicit GO/NO-GO.
- M2.5: PAUSED / Production establishment must not start until M2.4.9 records GO.
- **Primary active delivery roadmap:** `docs/coursefinder-end-to-end-automated-data-admission-roadmap-v1.0.md` under `CF-CHG-20260915-247`.
- Programme sequence authority remains: `project-runsheets/milestone-2/m2.4/M2.4.6-M2.4.9-OPERATIONS-PLAN.md`.
- Active continuity: `project-runsheets/milestone-2/m2.4/m2.4.7/`.
- Active exact gate source: `project-runsheets/milestone-2/m2.4/m2.4.7/RUNSHEET.md`.
- **CF-093 is CLOSED / PASS and historical only:** `change-control/30-admin-pim-ux/CF-CHG-20260910-093-scheduled-workflow-orchestrator.md`. Future country/source onboarding or defects must use a new Change Control ID and may reference CF-093 only as historical evidence.
- **CF-245 is CLOSED / PASS predecessor evidence:** `change-control/40-layer2-enrichment/CF-CHG-20260915-245-m245-enrichment-operations-metrics-coverage-expansion.md`.
- **CF-246 is CLOSED / PASS predecessor evidence:** `change-control/40-layer2-enrichment/CF-CHG-20260915-246-m246-production-operations-contract.md`.
- **CF-247 is ACTIVE:** `change-control/00-governance-programme/CF-CHG-20260915-247-end-to-end-automated-data-admission-programme.md`.
- Production-readiness authority retained: `change-control/70-security-platform/CF-CHG-20260901-049-m2-5-clean-production-stack-establishment.md`; it does not authorise early M2.5 entry.
- Change index: `change-control/REGISTER.md`.

For any bug, regression, failed UAT, runtime incident, large corrective change or recovery continuation, the Troubleshooting / Bug-Fix / Recovery Protocol is mandatory in addition to the normal milestone authorities.

For any visible-release version conflict, release promotion, rollback or currentness defect, the Release / Version Control & Recovery document is mandatory. Candidate version authority must come from the Pilot release manifest and must pass the automated release contract before build/promotion.

## Document family policy

1. The current version stays at the stable documented path listed above until a governed archive migration is performed.
2. When a new version supersedes a family, update this index in the same change.
3. Superseded versions are historical evidence and must not be selected by new chats.
4. Historical files should be moved into category archive folders only as an atomic reference-safe migration.
5. Any archive move must rewrite internal links, Change Control references, runsheets and documentation references and then validate them.
6. Do not create duplicate “current”, “final”, “latest”, “new” or “v2-final” aliases.

## Archive target structure

```
docs/
  README.md
  01-governance/
  archive/
    governance-programme/
    architecture-data/
    admin-pim-ux/
    layer1/
    layer2-layer3/
    search-api-integrations/
    security-platform/
    uat-release-operations/
```

## Archive migration ledger

Physical relocation of the existing historical corpus is intentionally gated because the repository contains many hard-coded historical references. CF-086 establishes the destination and selection rules first. Each migration batch must record:
- files moved;
- old path → new path;
- reference files rewritten;
- commit SHA;
- link/reference validation result;
- rollback commit.

Until a batch passes validation, the old paths remain authoritative historical references.
