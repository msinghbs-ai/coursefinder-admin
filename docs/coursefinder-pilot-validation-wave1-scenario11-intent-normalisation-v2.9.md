# Coursefinder Pilot Validation Wave 1 — Scenario 11 Intent Normalisation v2.9

**Status:** Implemented and validated in `coursefinder-demo`.

**Purpose:** Improve Website and Zoho semantic search quality by normalising user intent before generating query embeddings, while keeping structured inference conservative and configuration-driven.

---

## 1. Implemented flow

```text
Website / Zoho query
        ↓
Intent normalisation
        ↓
Explicit structured hints where safe
        ↓
Normalised semantic query
        ↓
Query embedding
        ↓
FTS + HNSW/pgvector candidates
        ↓
Rank fusion
```

The original query is preserved and returned alongside the normalised query.

---

## 2. Configuration model

Pilot table: `search_pilot.intent_aliases`

Fields:
- `alias`
- `canonical_term`
- `alias_kind`
- `level_hint`
- `priority`
- `is_active`

The intent rules are data/configuration rather than Website or Zoho UI code.

Examples:
- `AI` → `artificial intelligence`
- `IT` → `information technology`
- `cyber security` → `cybersecurity`
- `industry focus` → `industry professional applied`
- `career focus` → `professional applied`

Explicit level terms may infer a structured level:
- Bachelor / undergraduate → `bachelor`
- Master / Masters → `masters`
- Graduate Certificate → `graduate_certificate`
- Graduate Diploma → `graduate_diploma`
- Doctoral / PhD → `doctoral`

Ambiguous terms such as `postgraduate` do **not** force a study level.

---

## 3. Validation examples

### Rich Zoho intent
Input:
`AI machine learning industry focus with postgraduate study`

Normalised:
`artificial intelligence machine learning industry professional applied with postgraduate study`

Level inference: none.

Reason: `postgraduate` is broader than Masters and must not be over-normalised.

### Website / Zoho explicit level
Input:
`IT undergraduate course with career focus`

Normalised:
`information technology undergraduate course with professional applied`

Level inference: `bachelor`.

### Controlled terminology
Input:
`Graduate Certificate in cyber security`

Normalised:
`graduate certificate in cybersecurity`

Level inference: `graduate_certificate`.

---

## 4. API behaviour

`semantic-search-query-v2-9` version 2 now:
1. accepts the original query;
2. calls `intent_normalize_pilot_v2_9`;
3. applies an inferred level only when the caller did not explicitly provide one;
4. embeds the normalised semantic query;
5. passes the normalised query + vector to `hybrid_search_query_embedding_pilot_v2_9`;
6. returns original query, normalised query, inferred/effective level and applied aliases.

Explicit API filters always override inferred filters.

---

## 5. Performance

A 1,000-call database simulation of the intent normaliser completed in approximately **175 ms total**, or roughly **0.175 ms per normalisation** in the warm pilot test.

The normalisation stage is therefore negligible compared with embedding-provider and hybrid-search latency.

---

## 6. Security

- `intent_normalize_pilot_v2_9` is `SECURITY DEFINER` with an explicit `search_path`.
- Execute permission is revoked from `public`, `anon` and `authenticated`.
- Only `service_role` can execute the normaliser RPC directly.
- `semantic-search-query-v2-9` continues to require JWT.
- Embedding credentials remain server-side.

Supabase advisor review after deployment exposed no new warning attributable to this change. Existing demo warnings remain outside this scenario, including the `vector` extension in `public` and leaked-password protection being disabled.

---

## 7. Production recommendation

Carry the intent-alias/rule concept into the production `search` schema as versioned Search Profile configuration.

Do not make the rule set a single global hard-coded dictionary. Production should allow:
- channel-specific rules (`website`, `zoho`);
- locale/language variants;
- country-specific terminology;
- rule/profile versioning;
- controlled review and activation;
- observability for which aliases were applied.

Later complex intent extraction may add an LLM-assisted parser, but deterministic controlled rules should remain the fast path and structured filters should not be inferred when the source wording is ambiguous.

---

## 8. Result

**PASS — implementation improvement validated.**

No fundamental catalogue/PIM database redesign is required. The production search design should include versioned intent-normalisation configuration before query embedding.
