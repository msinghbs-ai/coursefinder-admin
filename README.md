# Coursefinder PIM Admin v2.1

Cloudflare Pages-ready React/Vite admin UI for the Coursefinder Supabase PIM.

## Included screens
- Dashboard
- Scholarships
- Layer 4 Review Queue
- Global Attributes
- Evidence
- Student Scholarship Matcher

## Local setup
1. Copy `.env.example` to `.env.local`.
2. Set `VITE_SUPABASE_PUBLISHABLE_KEY` to a **publishable/browser key**, never a secret/service-role key.
3. Run:
   ```bash
   npm install
   npm run dev
   ```

## Required Supabase setup
1. Create/invite a Supabase Auth user.
2. Add the user to `public.pim_user_roles` with one of:
   - viewer
   - counsellor
   - curator
   - pipeline_operator
   - pim_admin
   - platform_admin
3. Curator or higher is needed for Review Queue and Evidence operations.
4. `pim_admin` or higher is needed to create attributes and aliases.

## Cloudflare Pages
Use Git integration:
- Framework preset: Vite
- Build command: `npm run build`
- Build output directory: `dist`
- Node runtime: pinned in `.node-version`
- Environment variables:
  - `VITE_SUPABASE_URL`
  - `VITE_SUPABASE_PUBLISHABLE_KEY`

Cloudflare Pages installs npm dependencies before the build. Use a preview branch first. Add the production custom domain only after UAT.

## Zoho suggestion endpoint
Edge Function: `catalogue-suggest-v2-1`

Before use, configure a Supabase Edge Function secret:
`ZOHO_SUGGESTION_SECRET=<random-long-secret>`

Zoho sends the same value in:
`X-Coursefinder-Suggestion-Key`

The endpoint only creates a suggestion + Layer 4 queue item. It never directly updates canonical catalogue data.
