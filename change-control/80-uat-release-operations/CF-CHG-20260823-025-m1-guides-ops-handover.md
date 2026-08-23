# CF-CHG-20260823-025 — M1 Guides, Operations & Handover Finalisation

**Status:** APPLIED / UAT IN PROGRESS  
**Category:** 80-uat-release-operations  
**Initiated:** 23 August 2026 14:14 AEST  
**Origin chat/workstream:** M1-GUIDES-OPS-HANDOVER  
**Owner:** CourseFinder governance / operations handover  
**Change class:** documentation / operations

## Trigger

Final Milestone-1 documentation gate requested against the actually deployed Pilot platform.

## Problem / requested outcome

Existing guidance was accurate in parts but fragmented across PIM, Data Quality, Access Admin, Pipeline, Search and publication records. Final handover requires role-specific navigation and operational runbooks grounded in deployed behaviour, with obsolete navigation removed and complex field semantics documented consistently.

## Affected surfaces / related workstreams

- Admin/PIM v2.12 navigation and role boundaries;
- Pipeline Ops v1.0, Evidence v1.0, Data Quality v1.0 and Access Admin v1.0;
- Search `course-v3` and Publication Governance v1.0;
- Layer 1–4 operational support;
- Zoho-facing semantics where approved;
- change-control, UAT and handover documentation.

Related accepted controls: CF-CHG-20260820-001, 005–015, 016–024.

## Semantic impact

No canonical identity, field meaning, source authority, grain, lifecycle, Search or publication semantic change. This change consolidates and clarifies the accepted operational contract only.

## Before

Guidance was distributed across multiple versioned documents and did not provide one complete role-specific user guide plus one end-to-end operations runbook.

## After

- one current role-specific User Guide;
- PIM Admin Guide advanced to v1.15 with the final complex-field semantic matrix;
- one Operations Runbook covering source refresh, failed jobs, replay/idempotency, evidence inspection, source changes, rollback, security escalation and publication rollback;
- one technical acceptance record proving documentation against current governance, accepted Pilot source and live Supabase state.

## Source authority / evidence

- `PROJECT_INSTRUCTIONS.md`;
- `change-control/REGISTER.md` and overlapping records;
- Master Project Plan v1.63;
- Running Build v2.65;
- Database Architecture v2.10.40;
- Admin/PIM Design Decisions v1.13;
- PIM Admin Guide v1.14;
- Data Quality and Publication governance contracts;
- accepted Pilot `msinghbs-ai/Coursefinder-Pilot@16ce78e25e78c2324e056a7b8cb6024d4a0428a8`;
- live Pilot Supabase `fxcwkweaxjtknorudmwp`.

## Implementation references

- Supabase migration(s): none;
- Git repository: `msinghbs-ai/coursefinder-admin`;
- RPC/API objects verified: `public.admin_read(text,jsonb)`, `search.refresh_course_documents_v3(boolean)`;
- UI version: no frontend change; documents PIM Admin v2.12 and independently versioned capabilities.

## UAT

Technical acceptance is recorded in `docs/uat/coursefinder-m1-guides-ops-handover-technical-acceptance-2026-08-23.md`.

## Rollback / reversion

Documentation-only. Revert the documentation commits and restore v1.14 as the current PIM Admin Guide if acceptance fails. No database or runtime rollback is required.

## Documentation impact

- PIM Admin Guide: v1.15;
- User Guide: new current consolidated guide;
- Operations Runbook: new;
- Architecture: unchanged;
- Running build: update only after handover gate closes;
- Master plan: update only after handover gate closes;
- Zoho contract: unchanged.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 23 Aug 2026 14:14 AEST | PROPOSED | Documentation gate initiated | M1-GUIDES-OPS-HANDOVER |
| 23 Aug 2026 14:32 AEST | APPLIED / UAT IN PROGRESS | Consolidated guides/runbook authored from current governance, accepted Pilot source and live Supabase state | this change |

## Closure

**Final status:** pending UAT  
**Closed at:** N/A  
**Outcome:** pending technical acceptance.