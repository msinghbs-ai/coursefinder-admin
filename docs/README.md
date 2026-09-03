# CourseFinder Documentation — Current Document Index

**Status:** AUTHORITATIVE CURRENT-DOCUMENT ROUTER  
**Effective:** 3 September 2026 10:03 AEST  
**Governance:** `PROJECT_INSTRUCTIONS.md`, `docs/01-governance/coursefinder-pim-operating-principles-v1.0.md`  
**Change Control:** CF-CHG-20260903-086

## Rule

Do not infer the current document from the highest filename version or from chat history. This index identifies the accepted/current document for each core family.

## Current core documents

| Family | Current document | State |
|---|---|---|
| Master Project Plan | `docs/coursefinder-master-project-plan-v1.81.md` | CURRENT |
| Running Build | `docs/coursefinder-running-build-v2.81.md` | CURRENT |
| Database Architecture | `docs/coursefinder-database-architecture-v2.10.50.md` | CURRENT ACCEPTED |
| Admin/PIM Design Decisions | `docs/coursefinder-admin-pim-design-decisions-v1.31.md` | CURRENT |
| Admin Navigation / Information Architecture | `docs/coursefinder-admin-navigation-information-architecture-v1.6.md` | CURRENT |
| PIM Admin Guide | `docs/coursefinder-pim-admin-guide-v1.22.md` | CURRENT |
| Operations Runbook | `docs/coursefinder-operations-runbook-v1.8.md` | CURRENT |
| Data Operations Admin Guide | `docs/coursefinder-m2-4-data-operations-admin-guide-v1.6.md` | CURRENT |
| Programme PIM Operating Principles | `docs/01-governance/coursefinder-pim-operating-principles-v1.0.md` | CURRENT |
| University Ranking Data Design | `docs/coursefinder-university-ranking-data-design-v1.1.md` | CURRENT |

## Active milestone router

- M1: CLOSED / PASS / FROZEN.
- M2.1–M2.4.4: CLOSED / PASS; M2.4.4 remains FROZEN.
- **M2.4.5: ACTIVE / PRE-PRODUCTION HARDENING.**
- M2.5: PAUSED / READINESS AT P0 until M2.4.5 closes.
- Active continuity: `project-runsheets/milestone-2/m2.4/m2.4.5/`.
- Active hardening authority: `change-control/00-governance-programme/CF-CHG-20260903-087-m2-4-5-admin-pim-hardening-preproduction-readiness.md`.
- Production-readiness authority retained: `change-control/70-security-platform/CF-CHG-20260901-049-m2-5-clean-production-stack-establishment.md`.
- Change index: `change-control/REGISTER.md`.

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
