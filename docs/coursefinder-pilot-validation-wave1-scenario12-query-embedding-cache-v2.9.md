# Coursefinder Pilot Validation Wave 1 — Scenario 12: Query Embedding Cache v2.9

**Status:** PASS

**Purpose:** Validate production-safe caching for repeated semantic queries before moving from the pilot database to the clean production project.

## 1. Scope

This scenario validates the third production improvement from the recommendation simulation:

- normalise the query;
- derive a cache key from `embedding model + Search Profile version + normalised query`;
- reuse an existing query embedding when the cache entry is valid;
- skip the external embedding-provider call on a cache hit;
- keep the cache isolated from the canonical catalogue/PIM model.

## 2. Privacy and security rule

The cache does **not** store raw user query text.

The Edge Function computes a SHA-256 key over:

`model | profile_version | normalised_query`

The database stores only:

- cache key;
- embedding model;
- Search Profile version;
- vector embedding;
- created/last-used timestamps;
- hit count;
- expiry timestamp.

The cache RPCs are executable only by `service_role`.

## 3. Pilot implementation

Created:

- `search_pilot.query_embedding_cache`
- `public.query_embedding_cache_get_pilot_v2_9(...)`
- `public.query_embedding_cache_put_pilot_v2_9(...)`

`semantic-search-query-v2-9` was upgraded to version 3.

Request path:

`raw query -> intent normalisation -> cache hash -> cache lookup -> embedding provider only on MISS -> hybrid search`

## 4. TTL and versioning

Pilot default TTL: **7 days**.

TTL is bounded by the RPC to between 60 seconds and 30 days.

Cache identity includes the Search Profile version so a changed normalisation/ranking profile naturally creates a new cache namespace instead of serving stale semantic intent.

Model is also part of cache identity, preventing reuse across incompatible embedding models.

## 5. Validation

A test embedding was inserted and retrieved twice through the cache RPC. The returned hit count reached **2**, proving retrieval and hit tracking work.

The test cache row was removed after validation.

## 6. Production decision

**PASS — carry this pattern into `Coursefinder_Prod`.**

Recommended production placement:

- `search.query_embedding_cache`
- service-role/server-only access;
- no raw query text;
- Search Profile and embedding model versioning;
- configurable TTL;
- scheduled expired-entry cleanup;
- cache hit/miss metrics exposed through operational telemetry, not the public catalogue API.

## 7. Pilot-to-production gate

This completes the three immediate semantic-search improvements validated in the pilot:

1. true query embeddings;
2. intent normalisation;
3. query embedding cache.

No further pilot schema expansion is required before production schema consolidation.

Next action:

**Consolidate all validated v2.9 design changes into the final production schema pack, then create the clean `Coursefinder_Prod` Supabase project and apply ordered production migrations.**
