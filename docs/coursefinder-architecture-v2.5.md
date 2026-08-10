# Coursefinder Architecture v2.5 — V5.8 Operations Console

Status: UI/control-plane update only. No database schema migration is included in this version.

## Objective
Restore the operational density and control model of the V5.8 prototype while keeping the V2/V2.1 PIM, scholarship, evidence, completeness and role model.

## Authenticated Admin Personas
- **Pipeline Ops** — Layer 1–3 execution, Layer 4 queue, execution scope, jobs and changes.
- **Platform Admin** — dense catalogue/completeness control view and targeted course selection.
- **Counsellor** — user-facing catalogue filters, shortlist and compare, no pipeline execution controls.
- **Student Finder** — quick catalogue cross-check plus structured scholarship matcher.
- **PIM Model** — global attributes, aliases, custom values and scholarships.

## Layer Controls
Layer 1–3 execution is performed through `pipeline-control-v2-5`.

The browser never receives service-role, scraper or LLM secrets. The control endpoint validates the signed-in user and requires one of:
- pipeline_operator
- pim_admin
- platform_admin

It then invokes the existing pipeline Edge Function with a server-side credential.

Layer 4 is human curation rather than a batch ETL. Its action opens the authenticated review queue backed by `pim-admin-v2-1` operations.

## V2 Catalogue Mapping
The dense Platform Admin/Counsellor grids use `course_completeness_v2` and surface:
- canonical course/provider identity
- country and level
- registration
- academic structure
- fee
- intake
- English requirement
- description
- scholarship coverage/count
- V2 completeness score

Filters include country, provider, study level, missing facet, minimum completeness, scholarship linkage and free text.

Selected courses are shared with Pipeline Ops and can scope Layer 2/3 runs.

## PIM Mapping
PIM Model surfaces:
- `pim_attribute_definitions`
- `pim_attribute_aliases`
- `field_values`
- `scholarship_catalogue_v2`

This preserves the UnoPIM-inspired Attribute Family / Group / Definition / Value model introduced in V2.

## Deployment Split
- Repository root: authenticated operational/admin console.
- `/demo`: separate read-only Cloudflare Pages demo.

The demo remains deliberately unable to run pipeline layers or mutate canonical data.

## Deferred / Pilot-Paused Items
- No DB schema changes.
- No Layer 1–3 algorithm changes.
- No cron/scheduler changes.
- No relocation of the existing `vector` extension.
- Legacy direct pipeline Edge Function exposure remains a separate security-remediation item; the new admin UI does not call those functions directly.
