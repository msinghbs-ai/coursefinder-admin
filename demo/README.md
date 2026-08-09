# Coursefinder Demo App

Public-facing demo application, intentionally separated from the operational PIM admin while remaining in the same repository.

## Deployment recommendation
Create a separate Cloudflare Pages project using this repository with:
- Root directory: `demo`
- Production branch: `main`
- Framework preset: Vite
- Build command: `npm run build`
- Output directory: `dist`
- Node version: `22`

Environment variables:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_PUBLISHABLE_KEY`

Do not configure service-role, admin or pipeline secrets in this project.

## Data boundary
The demo app only consumes read-only catalogue surfaces:
- `course_completeness_v2`
- `scholarship_catalogue_v2`

The PIM admin remains the root app in this repository and should be deployed as its own Cloudflare Pages project.

## Visual matching
The reference Kimi site could not be fetched from the current execution environment. This is therefore a Coursefinder demo baseline, not a claimed pixel-copy of the Kimi page. Provide screenshots or exported source to do a precise visual alignment pass.
