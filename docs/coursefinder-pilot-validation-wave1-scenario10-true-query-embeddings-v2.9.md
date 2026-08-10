# Coursefinder Pilot Validation Wave 1 — Scenario 10 — True Query Embeddings v2.9

**Status:** Implemented in `coursefinder-demo` pilot.

## Objective

Replace the pilot shortcut that used an existing course embedding as a stand-in for a user query embedding.

## Implemented flow

Website / Zoho query text
→ Edge Function `semantic-search-query-v2-9`
→ configured embedding provider/model from server-side pipeline configuration
→ true 1536-d query embedding
→ `public.hybrid_search_query_embedding_pilot_v2_9`
→ FTS candidates + HNSW/pgvector candidates
→ reciprocal-rank fusion
→ ranked course results.

## Security boundary

- Edge Function requires JWT in the pilot.
- Embedding provider API key remains server-side.
- Browser/client never receives the embedding provider credential.
- Hybrid RPC execution is revoked from `public`, `anon` and `authenticated`; only `service_role` may execute it.
- Canonical catalogue tables remain unchanged.

## Input

- `query`
- optional `country`
- optional `level`
- optional `limit` capped at 50

## Output

- course ID
- provider name
- course title
- study level
- fused score
- text rank
- vector rank
- embedding model/dimensions
- embedding/database timing telemetry

## Existing implementation reused

The demo already had a working embedding-provider configuration used by `embed-courses` and `course-search`. Scenario 10 reuses that server-side configuration but routes the generated user-query embedding through the new hybrid Search Projection RPC instead of the old vector-only `match_courses` path.

## Validation status

- Supabase migration applied successfully: `search_pilot_v2_9_true_query_embedding_rpc`.
- Edge Function deployed successfully: `semantic-search-query-v2-9`, JWT verification enabled.
- GitHub migration and Edge Function source committed.
- End-to-end HTTP invocation from the assistant execution container could not be completed because that container could not resolve the Supabase hostname. This is an execution-environment networking limitation, not a Supabase deployment failure.

## Production implication

This removes the largest quality limitation found in Scenario 9 for Zoho natural-language recommendation queries. The next improvement should be intent normalisation and query-embedding/result caching; those can sit above this API without changing the canonical catalogue model.
