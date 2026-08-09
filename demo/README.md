# Coursefinder Demo — V5.8 / V2 Showcase

Public read-only demo UI based on the restored V5.8 presentation model and aligned to the current V2 catalogue/PIM schema.

## Demonstrates
- Layer 1–4 architecture and recent job status
- Course catalogue and `course_completeness_v2`
- Scholarships
- UnoPIM-inspired attribute families
- Live custom/enriched values from `field_values`
- Layer-4 review workload (read-only)
- Job/change history and private-evidence posture
- Counsellor catalogue/shortlist experience
- Public student course search

## Security boundary
This demo cannot execute pipeline layers, resolve reviews, reset data, generate embeddings, edit secrets, perform canonical writes or access private evidence objects.

## Cloudflare Pages
- Root directory: `demo`
- Production branch: `main`
- Framework preset: Vite
- Build command: `npm run build`
- Output directory: `dist`
- Node version: `22`

Environment variables:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_PUBLISHABLE_KEY`

Never configure service-role, scraper, LLM or admin secrets in this Cloudflare project.
