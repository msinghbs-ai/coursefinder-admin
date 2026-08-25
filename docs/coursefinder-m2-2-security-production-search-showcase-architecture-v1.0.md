# CourseFinder M2.2 — Security, Production & Search Showcase Architecture v1.0

**Date:** 25 August 2026  
**Status:** CURRENT / M2.2 WORKING BASELINE  
**Change Controls:** CF-CHG-20260825-032, -033, -034, -035

## 1. Purpose

This document defines the bounded M2.2 architecture introduced by the Friday 28 August showcase acceleration. It does not replace the accepted database architecture or M2.1 Layer 1–4 contract. It records only the new Production/security and Search/read-contract decisions needed for M2.2.

## 2. Authority model preserved

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 remains terminal. Search Projection, Search Visibility and Publication are downstream product states. Website Search does not become an authority layer and cannot write canonical catalogue values.

## 3. Environment trust model

### Pilot

- Supabase: `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp`, Mumbai `ap-south-1`;
- Cloudflare Worker: existing Pilot boundary;
- purpose: governed implementation, UAT and Friday showcase;
- broad publication remains disabled.

### Production target

Production remains a **clean, separately established environment**. It is not a renamed or credential-promoted Pilot.

Target controls:

- separate Supabase project, preferred Sydney `ap-southeast-2` unless explicitly changed;
- separate Storage, Vault/secrets and Auth authority;
- separate Cloudflare Production route/environment;
- protected GitHub Production environment with scoped secrets and approval policy;
- migration-based bootstrap plus reconciled canonical data bootstrap;
- SHA-bound deployment and automated release UAT;
- recovery/restore evidence before Production acceptance.

Creation/cutover remains governed by the later Production establishment gate and is not implied by the Friday showcase.

## 4. Supabase Pro state

Organisation `techM` is verified on plan `pro`. Pro makes leaked-password protection available but does not automatically enable it. The live Security Advisor still reports leaked-password protection disabled.

Production planning may rely on Pro availability for daily backups and optional PITR, observability/logging and larger resource envelopes only after the relevant feature/configuration state is independently verified for the target Production project.

## 5. Security boundary

### Browser-safe Admin

Normal browser clients use a low-privilege Supabase client and authenticated user JWT. Raw private schemas remain unavailable to anon/authenticated roles. `public.admin_read(...)` remains the governed SECURITY INVOKER read dispatcher.

### Privileged mutations

Privileged mutations must cross an authenticated Edge/server boundary or an explicitly justified server-enforced RPC. M2.2 moved Layer 2 execution-policy update away from direct authenticated SECURITY DEFINER execution:

Browser → JWT-enforced `layer2-config-control` → role/rank validation → service-bound `layer2_ops_policy_update`.

### Search/read boundary

Raw `search.*` tables are not a website contract. Friday preview functions are service-role-only and return an allowlisted DTO. No browser or website consumer authority is granted by their existence.

## 6. Search architecture

### Deterministic baseline

The accepted `course-v3` Search Projection remains the primary substrate. Current state:

- 33,105 AU+NZ documents;
- AU 26,648 / NZ 6,457;
- projection generation 22;
- projection hash `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`;
- all current rows unpublished.

Search modes are deliberately separated:

1. exact public/regulatory Course code or stable Course ID lookup;
2. conventional FTS;
3. deterministic structured filtering;
4. vector/hybrid only if a governed embedding profile and relevance benchmark later prove added value.

### Vector candidate

`pgvector 0.8.2` is installed. The schema already provides embedding/job/cache structures and semantic/content hashes, but:

- course embeddings = 0;
- embedding jobs = 0;
- query embedding cache = 0;
- `integration.model_profiles` = 0;
- prior vector diagnostic Edge function is intentionally retired.

Therefore vector availability is architectural readiness, not acceptance. No synthetic/random/demo embeddings may be introduced.

## 7. Embedding acceptance prerequisites

Any future vector candidate must explicitly define:

- provider/model;
- dimensions;
- model/profile version;
- semantic text contract;
- semantic/content hashes;
- regeneration/invalidation rules;
- query embedding cache policy;
- excluded private fields;
- generation cost/latency;
- measured FTS versus vector versus hybrid relevance;
- index choice based on real query plans and corpus scale.

Embeddings remain derived artefacts and never canonical identity.

## 8. Search gate-table RLS disposition

The following internal Search gate tables currently have RLS disabled:

- `search.projection_country_gates`;
- `search.enrichment_gates`;
- `search.enrichment_source_gates`.

Current effective role checks show anon/authenticated have neither `search` schema usage nor direct table grants, so the tables are not presently reachable through the normal browser client. This remains a defence-in-depth WARN. RLS will not be enabled blindly without defining service/internal policies because doing so could break accepted projection rebuilding. Production policy must be resolved before any change that exposes `search` schema access.

## 9. Recovery architecture

M2.2 defines the recovery requirements; actual Production restore acceptance occurs after the clean Production project exists.

Required Production evidence:

- backup configuration state;
- PITR decision and configured retention if selected;
- documented RPO/RTO;
- restore target isolated from live Production;
- executed restore validation;
- checksum/count/invariant reconciliation;
- credential/secrets re-binding procedure;
- rollback/redeployment path.

A Production DR PASS cannot be claimed before the restore test executes.

## 10. Release architecture

Pilot already has SHA-bound desktop/mobile deployed UAT. Production requires a separate protected-environment promotion workflow with scoped Production secrets and explicit release gate. M2.2 records this as an implementation requirement; it does not reuse Pilot secrets as Production authority.

## 11. Current M2.2 decision

- Security hardening: in progress; direct Layer 2 privileged browser RPC finding remediated and advisor warning removed.
- Supabase Pro: entitlement verified; leaked-password control remains disabled and therefore blocks full security PASS until enabled/verified.
- Search: deterministic exact/FTS/filter contract implemented as server-side preview; performance optimisation/UAT remains active.
- pgvector: **candidate / not accepted** because no governed embedding profile/corpus exists.
- Publication/Production consumer authority: **not granted**.
