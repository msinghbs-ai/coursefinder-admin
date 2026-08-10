# Coursefinder Demo v2.5 — V5.8 Control Experience

Status: Demo UI/control-plane update only. Pilot/database changes remain paused.

## Deployment boundary

- **Repository root** — production/internal Coursefinder PIM using the UnoPIM-inspired UI/UX.
- **`/demo`** — separate V5.8-style operational demo deployed as its own Cloudflare Pages project.

The V5.8 visual/interaction model must not replace the production PIM UI.

## Demo personas

The `/demo` app provides:

1. **Pipeline Ops** — Layer 1–3 execution controls, Layer 4 queue visibility, execution scope, jobs and course selection.
2. **Platform Admin** — dense catalogue/completeness view mapped to `course_completeness_v2`.
3. **Counsellor View** — filtered canonical catalogue with fees, IELTS, shortlist and compare.
4. **Student Finder** — quick catalogue cross-check and structured scholarship matcher.
5. **PIM Model** — global attribute definitions, aliases, field values and scholarships for demonstration.

## Layer execution

Layer 1–3 buttons call `pipeline-control-v2-5`.

The control function validates the signed-in Supabase user and requires `pipeline_operator`, `pim_admin` or `platform_admin` before invoking the existing pipeline functions server-side.

Layer 4 canonical review actions remain in the production UnoPIM-style application through `pim-admin-v2-1`. The demo only surfaces the review workload and links the operating story together.

## V2 catalogue mapping

The V5.8 catalogue/completeness grid uses `course_completeness_v2` and exposes:

- canonical course and provider
- country and study level
- registration
- academic structure
- fees
- intakes
- English requirements
- description
- scholarship linkage/count
- V2 completeness score

Filtering supports country, provider, level, missing facet, minimum completeness, scholarship linkage and free text.

Selected courses can be reused as targeted Layer 2/3 execution scope.

## Cloudflare

### Production PIM
- Repository root
- Production branch: `main`
- UnoPIM-style application

### Demo
- Root directory: `demo`
- Production branch: `main`
- Framework: Vite
- Build command: `npm run build`
- Output directory: `dist`
- Node: 22

Environment variables:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_PUBLISHABLE_KEY`

Never add service-role, scraper or LLM secrets to the Cloudflare browser environment.
