# CF-CHG-20260823-025 — M1 Guides, Operations & Handover Finalisation

**Status:** CLOSED / PASS  
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

Guidance was distributed across multiple versioned documents and included obsolete navigation/planned behaviour in older User Guide revisions.

## After

- `docs/coursefinder-user-guide-v2.0.md` is the current role-specific User Guide;
- `docs/coursefinder-pim-admin-guide-v1.15.md` is the current PIM Admin Guide with final complex-field semantic matrix;
- `docs/coursefinder-operations-runbook-v1.0.md` is the current operations runbook;
- `docs/uat/coursefinder-m1-guides-ops-handover-technical-acceptance-2026-08-23.md` records autonomous technical acceptance.

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
- documentation commits include `7cd9bb1716ce2deb9eede87c84f6d8c25ff45185`, `c98e3679287d94897580c32aecf357a56c8f43a3`, `759b84b8b96ffa5a4ddd0325f16712c795a22f98`, `1453ae05448d24b2ab61dbb7da8b8e48f24c6af0`;
- RPC/API objects verified: `public.admin_read(text,jsonb)`, `search.refresh_course_documents_v3(boolean)`;
- UI version: no frontend change; documents PIM Admin v2.12 and independently versioned capabilities.

## UAT

Technical acceptance: `docs/uat/coursefinder-m1-guides-ops-handover-technical-acceptance-2026-08-23.md` — **PASS**.

Verified current deployed navigation, live role ranks, current all-country Provider/Course counts, 33,105 `course-v3` Search documents, 0 published Search documents, accepted Search hash, current generation 22, and the existing leaked-password Pilot exception.

## Rollback / reversion

Documentation-only. Revert the documentation commits and restore v1.14 as the current PIM Admin Guide if reversion is ever required. No database or runtime rollback is required.

## Documentation impact

- PIM Admin Guide: v1.15 current;
- User Guide: v2.0 current;
- Operations Runbook: v1.0 current;
- Architecture: unchanged;
- Running build: should advance to record the closed handover gate;
- Master plan: should record M1 documentation/handover gate closed;
- Zoho contract: unchanged.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 23 Aug 2026 14:14 AEST | PROPOSED | Documentation gate initiated | M1-GUIDES-OPS-HANDOVER |
| 23 Aug 2026 14:32 AEST | APPLIED / UAT IN PROGRESS | Consolidated guides/runbook authored from current governance, accepted Pilot source and live Supabase state | this change |
| 23 Aug 2026 14:46 AEST | UAT PASS | Navigation, roles, Search/publication state, security exception and runbook coverage validated | technical acceptance |
| 23 Aug 2026 14:47 AEST | CLOSED / PASS | M1 handover documentation accepted | this change |

## Closure

**Final status:** CLOSED / PASS  
**Closed at:** 23 August 2026 14:47 AEST  
**Outcome:** Current role-specific User Guide, PIM Admin Guide and Operations Runbook are reconciled to accepted deployed Pilot state and form the M1 operational handover baseline.