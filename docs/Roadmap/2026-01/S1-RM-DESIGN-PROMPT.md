# S1-RM-Design — Database design for Website and Zoho API v3

Copy the prompt below into the **S1-RM-Design** chat. Its primary milestone is **RM0 Shared platform**. Use the registered child item for a later engagement scoped to that item.

```text
Chat reference: S1-RM-Design
Roadmap: RM0 Shared platform · Database design for Website and Zoho API v3
Repositories: msinghbs-ai/coursefinder-admin and msinghbs-ai/Coursefinder-Pilot

Design the database changes and projections that let StudySearch deliver
source-backed roadmap data through the existing Website and Zoho API v3
endpoints. Produce a release-ready design with small, independently testable
handoffs to the existing module owners. Use Australian English.

Read first:
- Admin docs/platform/AGENT-OPERATING-MODEL.md and the Admin Quick Start.
- Admin docs/Roadmap/2026-01/DESTINATION-DATA-DESIGN.md,
  V3-QUICK-WINS-MODULES.md, ROADMAP-ENGAGEMENT-REGISTER.md and
  ROADMAP-MILESTONES.csv.
- Admin docs/integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md and
  api-v3/API-V3-FIELD-DEFINITION.md. Prefer dated deployment evidence over
  superseded draft sections. Check current Pilot main, relevant existing
  PRs, per-action wrappers and targeted read-only live metadata. Distinguish
  deployed, authenticated read-back, consumer cutover and planned.

Design in this order:
1. RM1A / O29 and O28 first: AU CRICOS recognition and source-backed AU
   ASCED codes. Then RM4A / O29: NZQA course recognition. Test reuse of
   catalogue.course_registrations and catalogue.courses.primary_field_id
   joined to ref.fields_of_study. Reuse existing source/evidence and
   publication checks. Confirm entity grain, scheme, effective date,
   provenance and visible denominator. Keep provider DLI distinct from
   programme PGWP and AU ASCED distinct from CA/US CIP and NZSCED.
2. Design the smallest shared destination model for RM1B / O38 AU city
   population, then RM1C / O23 application routes. Define stable locality,
   boundary vintage, dataset edition and source/evidence for observations.
   Define dated rule versions and course/provider/country applicability
   for routes. Include climate, living costs, careers and effective-dated
   study rules as extensions of the destination design. Keep city budgets,
   visa funds, wage floors and labour earnings distinct. O27 conditional
   post-study rules require proven applicability and source evidence.
3. Carry the design across AU, CA, GB, NZ, IE and US. Reuse AU/CA/NZ
   catalogue identity and the existing UK/Ireland/USA adapter milestones.
   Keep R30 accreditation and R32 primary-campus policy tied to D-3/D-4.
   Route study load and teaching language to S2-CF, admissions to AER,
   deadlines to S2-Intakes and awards to S2-Scholarship. Use RM0B / R33
   for the field dictionary.

Deliver in the Admin roadmap folder:
- Update the existing destination design with a field matrix:
  RM / request ID | meaning and entity grain | verified source and
  canonical column or proposed field | type/enum and null meaning |
  evidence/rights | Website v3 action | Zoho v3 action | owner.
- Include a compact relationship diagram and proposed DDL/migration
  sequence where there is a verified schema gap. Specify PK/FK,
  constraints and indexes, effective dating, permissions, idempotent
  backfill, corrections/withdrawals and rollback. Keep proposed names
  distinct from deployed objects. Prefer a read-only projection where
  existing canonical records can supply the field.
- Specify consumer-specific request/response examples and contract
  fixtures. Start recognition and native codes on course detail. Compare
  a versioned destination action with reuse of an existing suitable
  action for city and policy data. Define paging, source visibility,
  revisions, null/empty semantics and explicit action coverage. Verify
  Zoho search/detail/sync/export separately, including where a v3 route
  still returns v2-shaped sync or CSV. Specify child changes and
  withdrawals in delta sync only when that surface is in scope.
- Specify source registration, approval and refresh, operator visibility
  in existing Admin views, and measurable acceptance. Include positive,
  unknown, hidden, expired and withdrawn cases, Website and Zoho
  compatibility, bounded query performance and v2 regression proof.
  Identify the first implementable slice, dependencies and named owners.

The Integration Controller owns shared API wrappers, migration ordering,
production release and shared runner settings. Preserve v2 contracts.
Verify consumer cutover and follow the current additive v3, developer
comms and G3 rules for each surface. Keep this chat at design and handoff
until implementation is separately directed. Record the design in the
existing roadmap and link the relevant developer requests and acceptance
items. Record actual implementation or deployment only when verified.

Roadmap engagement logging (required):
- For each substantive human interaction, record one row with the stable
  engagement ID, Melbourne timestamp, primary RM item, activity, topic,
  outcome, next action and human minutes. Use 15 minutes if unspecified
  and at least 15 minutes when a duration is supplied. Exclude agent
  runtime, tool calls, CI, idle and waiting. A design/prompt request is
  Planning. A separate request directing implementation is Development.
- ChatGPT and Claude write ROADMAP-ENGAGEMENTS.csv on Admin main. Fetch
  latest, deduplicate, append, and verify before replying. Change
  ROADMAP-MILESTONES.csv only for status, owner or next-action changes.
  Claude alone rebuilds Roadmap_Engagement_Register.xlsx from the CSVs.
  Log this chat's new interaction once. Reuse the original engagement ID
  on retries and handoffs of the same interaction.
```

[Destination data design](DESTINATION-DATA-DESIGN.md) · [Module briefs](V3-QUICK-WINS-MODULES.md) · [Engagement register](ROADMAP-ENGAGEMENT-REGISTER.md)
