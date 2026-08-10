# Coursefinder UI Handoff v2.9.1

**Status:** Ready to start UI integration against the Mumbai pilot.

## Environment

- Supabase project: `coursefinder_Pilot`
- Project ref: `fxcwkweaxjtknorudmwp`
- Region: Mumbai (`ap-south-1`)
- Supabase URL: `https://fxcwkweaxjtknorudmwp.supabase.co`
- Plan: Free pilot/UAT

Frontend environment variables:

```text
VITE_SUPABASE_URL=https://fxcwkweaxjtknorudmwp.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=<active publishable key from coursefinder_Pilot>
```

Do not place `service_role` or embedding/LLM provider secrets in browser or Cloudflare client environment variables.

## Current UI data

The Mumbai pilot contains a deliberately small UI dataset:

- 7 Australian providers
- 35 technology/data/AI/cyber-related courses
- Search Projection rebuilt with 35 documents
- baseline PIM families/groups/attributes
- scholarship, pipeline, evidence and review schemas are present but not yet populated with the wider production dataset

This dataset is intended to validate UX and backend contracts before the wider catalogue is migrated/enriched.

## Existing React admin compatibility

The existing root React admin was originally written against demo public views/tables. To get UI work moving without carrying the old physical model forward, the Mumbai database now provides authenticated, read-only compatibility views:

- `public.catalogue_stats`
- `public.providers`
- `public.course_completeness_v2`
- `public.scholarship_catalogue_v2`
- `public.ingest_jobs`
- `public.review_queue`
- `public.evidence_artifacts`
- `public.pim_attribute_definitions`
- `public.field_values`

These views map old UI reads onto the v2.9.1 canonical schemas. They are transitional and must not become the permanent backend contract.

## v2.9.1 UI RPC bridge

Authenticated functions available for the new UI:

- `ui_context()`
- `ui_dashboard()`
- `ui_providers_list(p_limit)`
- `ui_courses_list(p_limit)`
- `ui_attributes_list()`
- `ui_jobs_list(p_limit)`
- `ui_review_queue(p_limit)`
- `ui_scholarships_list(p_limit)`
- `ui_search_courses(p_query,p_limit)`

These functions are the preferred direction for new components because they keep canonical schemas private and provide a deliberately controlled browser contract.

## Authentication

The UI requires a Mumbai Supabase Auth user.

`ui_context()` returns:

- authenticated status
- user id/email
- highest application role
- role rank

An authenticated user with no `security.user_roles` entry returns role `unassigned`. Read-only pilot UI access is supported for authenticated users; write operations are not yet promoted.

After a UI/UAT user exists in Auth, assign the required role in `security.user_roles`. The intended first administrator role is `platform_admin`.

## PIM-style UI direction

New UI work should retain the approved PIM interaction model:

### Catalogue

- Providers
- Campuses
- Course Collections
- Courses
- Scholarships
- Categories / Associations

### Course workspace

- General
- Academic
- Fees
- Intakes
- Admissions
- English
- Campuses
- Scholarships
- SEO / Content
- Evidence

Course forms should be driven by Attribute Family/Group configuration where the field is configurable, while strong relational facts such as fees, intakes, registrations, Academic Options and Scholarships remain purpose-built UI sections.

### PIM configuration

- Attribute Families
- Attribute Groups
- Attributes
- Options
- Categories
- Completeness Profiles

### Data quality / enrichment

- Pipeline Jobs
- Evidence
- Review Queue
- Layer 4 history

## Search UI

For normal search/browse:

`structured filters + FTS`

For natural-language recommendation/search:

`intent normalisation -> query embedding/cache -> FTS + HNSW candidates -> rank fusion`

Do not invoke pgvector for every keystroke/autocomplete request.

## Website vs Zoho

Keep the consumers distinct:

- Website: discovery/search/related courses, public academic truth.
- Zoho: authenticated recommendation/compare workflows using stable IDs; commercial preference/re-ranking stays outside the Coursefinder academic catalogue.

## Current branch integration

Branch: `ui/mumbai-pilot-v2-9-1`

`src/supabase.js` has been changed so the UI context comes from `ui_context()` rather than the retired demo `pim-admin-v2-1` Edge Function.

Scholarship matching currently returns a pilot-not-seeded state in the client until scholarship Layer 2/4 data is loaded and the production matcher is promoted.

## Immediate UI build order

1. Connect Cloudflare/UI environment variables to `coursefinder_Pilot`.
2. Create/sign in a Mumbai Auth UAT user and assign `platform_admin`.
3. Validate Dashboard, Providers, Courses and Completeness using the compatibility layer.
4. Replace those reads incrementally with the v2.9.1 RPC bridge.
5. Build provider detail and course workspace around the PIM-style group tabs.
6. Build Course Collections and Course Academic Options UI.
7. Build Attributes/Options/Categories configuration.
8. Build Pipeline/Jobs/Evidence/Layer 4 screens.
9. Add scholarship acquisition/review/matcher UI after scholarship data is populated.
10. Add hybrid semantic search UI after production embeddings are generated.

## Do not do

- do not point new UI code at canonical schemas directly;
- do not use `service_role` in the browser;
- do not rebuild around the demo `public` schema;
- do not treat the compatibility views as the final API;
- do not mix Zoho commission/preference data into catalogue/course embeddings;
- do not copy demo embeddings into Mumbai.

## Handover gate

The database and read API are ready for UI development. Wider catalogue migration, Layer 2/4 population and embedding generation can continue in parallel after the UI establishes the v2.9.1 contracts.
