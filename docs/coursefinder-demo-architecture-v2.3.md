# Coursefinder Demo Architecture v2.3

**Status:** Pilot paused / demo track active

## Decision
Use the existing `msinghbs-ai/coursefinder-admin` repository as a small monorepo and deploy the demo as a separate Cloudflare Pages project from `/demo`.

This keeps source control, shared design direction and versioning together while isolating the public demo runtime from the operational PIM admin.

## Deployment topology

```mermaid
flowchart LR
  GH[GitHub coursefinder-admin] --> ADMIN[Root Admin App]
  GH --> DEMO[/demo Public Demo]
  ADMIN --> CFA[Cloudflare Pages - Admin]
  DEMO --> CFD[Cloudflare Pages - Demo]
  CFA --> AUTH[Supabase Auth]
  CFA --> ADMINAPI[Authenticated Admin Edge Functions]
  CFD --> READ[Read-only Catalogue Views/API]
  ADMINAPI --> DB[(Supabase PostgreSQL)]
  READ --> DB
```

## Security boundary
The demo Cloudflare project must contain only:
- Supabase URL
- Supabase publishable/browser key

Never configure:
- service-role keys
- Layer 1/2/3 pipeline secrets
- scraper/LLM API keys
- admin service secrets
- Zoho suggestion secret

## Demo data surfaces
Initial demo UI reads:
- `course_completeness_v2`
- `scholarship_catalogue_v2`

Long term, replace direct public view access with a purpose-built public Coursefinder API before external release.

## Cloudflare configuration
Create a second Pages project:
- Repository: `msinghbs-ai/coursefinder-admin`
- Root directory: `demo`
- Production branch: `main`
- Framework: Vite
- Build command: `npm run build`
- Build output: `dist`
- Node: 22

## Visual reference
Requested visual reference: `https://krpqszb4vh7io57.kimi.page`

The reference URL was not fetchable from the available execution environment. The committed demo is therefore a functional visual baseline. A screenshot/export is required for a precise pixel/style alignment review.

## Pilot state
Operational pilot development is paused. Changes to database/pipeline/admin functionality should only resume when explicitly restarted. Demo work remains isolated under `/demo`.
