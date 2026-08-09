# Coursefinder Demo Architecture v2.4

**Status:** Demo track active; pilot/data-platform changes paused.

## Deployment model
- Repository: `msinghbs-ai/coursefinder-admin`
- Operational PIM admin: repository root, separate Cloudflare Pages project
- Public demo: `/demo`, separate Cloudflare Pages project
- Production branch: `main`

## Demo purpose
The demo reuses the V5.8 presentation model while aligning the displayed data with the V2 PIM schema.

### Demonstrated
- Layer 1–4 architecture and job history
- Course catalogue
- `course_completeness_v2`
- Scholarships via `scholarship_catalogue_v2`
- UnoPIM-inspired attribute families
- Generic/custom values from `field_values`
- Layer-4 workload status
- Change history
- Private evidence architecture
- Counsellor shortlist UX
- Public student catalogue search

### Explicitly disabled in public demo
- Layer 1/2/3 execution
- Layer-4 approve/correct/reject actions
- `demo-reset`
- embedding generation
- cost-incurring semantic search
- pipeline secret editing/validation
- service-role access
- raw private evidence access

## Security boundary
The Cloudflare demo receives only:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_PUBLISHABLE_KEY`

Scraper, LLM, service-role and Zoho secrets remain server-side.

## Database status
No database/schema/pipeline changes are included in this demo release. The pilot remains paused.

## Cloudflare Pages
- Root directory: `demo`
- Framework: Vite
- Build command: `npm run build`
- Output directory: `dist`
- Node: 22
