# Scholarship module — plan for global coverage (v1, 3 Oct 2026, 21:00 AEST)

Decisions by the Platform Admin (20:55, multiple choice): coverage **AU, NZ, CA + UK and USA government awards**; serving **exact selector + pgvector search**; **nationality as a first-class field read from wording**; funder scholarships **not now**. Sources review: `scholarship-sources-review-2026-10-03.md`.

## 1. Principles (unchanged)
- Source of record: the provider's own page for provider money; the government portal for government money. Aggregators and directories are benchmarks only (Decision 232).
- Every value carries its page quote; a value set by hand is never overwritten; nothing publishes itself.
- Rules are versioned and testable (Decision 238); readers run on stored evidence first, re-fetch only on a schedule.

## 2. Record model (additions to `scholarship.*`)

| Addition | Why |
|---|---|
| `scholarships.kind` — `provider` / `government` / `funder` | Different sources, links and refresh cadence |
| `scholarships.study_country` (ISO) | Government and funder awards are not tied to a provider |
| `scholarships.nationalities` text[] + `scholarship.nationality_readings` (phrases kept) | Government and some provider awards are by student nationality; read from wording like audience (Decision 244) |
| `scholarships.audience` (done, Decision 244) | — |
| `scholarship.embeddings` (scholarship_id, model, text_hash, vector(1024)) — pgvector 0.8.2 is installed | Semantic search for website and Zoho |
| `scholarship.source_registry` (country, kind, name, url, reader, cadence, terms_note, status) | Replaces hard-coded site patterns; one place to add a country |

## 3. Sources per country (registry rows to create)

| Country | Government (source of record) | Provider pages | Status |
|---|---|---|---|
| AU | Study Australia search tool (script-rendered → worker/Firecrawl); DFAT Australia Awards country profiles | Done for 1,217 | Live; tool read to move to worker |
| NZ | Education New Zealand / Manaaki New Zealand Scholarships (MFAT); Universities NZ | Provider scholarship pages for the NZ providers in the catalogue | To build — same reader, NZ site patterns |
| CA | EduCanada scholarships (Vanier, Banting, SEED, Study in Canada); provincial (e.g. Ontario Trillium) | Provider pages for CA providers | To build |
| UK (government only) | Study UK / British Council: Chevening, GREAT, Commonwealth Scholarships | None (no UK courses) | Government reader only |
| USA (government only) | EducationUSA / Fulbright Foreign Student Program; Humphrey | None | Government reader only |

## 4. Serving layer

1. **Exact selector** (`scholarship_selection_for_course/provider`) stays the source of truth: audience gate → scope match (course 100 · provider 70 · level/field 50 · country) → saving per year.
2. **Semantic search**: `scholarship_search_v1(p_query text, p_country, p_level, p_nationality, p_limit)` — embeds the query with the pinned embedding model, `<=>` over `scholarship.embeddings` (HNSW, cosine), joined to published scholarships, then **re-checked** by the same rules as the selector (audience, nationality, country, scope) and returned with the matched quote. Zoho course API gains action `scholarships` (course_id or stable_key → selector result + top semantic matches); website API the same.
3. Embedding text = name + award text + eligibility criteria (human_text) + scopes in words; re-embedded when `text_hash` changes; one pinned model, version stored on the row (Layer 3 rule).

## 5. Fold and retire
- Scholarships › Course links tab → folds into the Scholarships list (links are decided per scholarship, 0 waiting).
- Scholarship runtime workspace → retires once Publishing shows audience, nationality and readiness.
- `au_study_australia_scholarships` list reader and per-provider detail re-reads → one registry-driven reader.

## 6. Sequence and estimate

| Step | What | Depends on | Est. |
|---|---|---|---|
| 1 | Publish the 177 ready (Platform Admin) | — | — |
| 2 | Award value and close date pass over stored pages (194 without value; 1,055 without close date) | — | 1 day |
| 3 | Nationality from wording (readings + field + hourly job) | Decision 244 pattern | 0.5 day |
| 4 | Source registry + Study Australia tool read via worker; DFAT per-country profiles | — | 1 day |
| 5 | NZ and CA provider scholarship readers (patterns from stored site maps) | registry | 2 days |
| 6 | UK and USA government readers | registry | 1 day |
| 7 | pgvector embeddings + `scholarship_search_v1` + Zoho `scholarships` action + website endpoint | 3 | 2 days |
| 8 | Fold Course links; retire runtime workspace; Publishing columns | 3, 7 | 0.5 day |
| 9 | Reviewer role on the 459 not-stated and nationality exceptions | roles work | with the roles build |

Each step: migration under md5 guards, rolled-back test, verify live = file, release note, runsheet entry.
