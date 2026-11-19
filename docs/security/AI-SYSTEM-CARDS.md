# AI system cards

**Owner:** Platform Admin · **Issued:** 20 Nov 2026 (AEDT), s808 · **ISM controls addressed:** 2084 and 2085 (AI system documentation and inventory), 2103 (provider data use and non-training), 2090 and 2091 (spend and rate limits), 2156 to 2159 (untrusted content in prompts).
**Status words:** *Met*, *Partly*, *Gap*. Values that are settings (limits, model pins) are read from Settings › Models & services and Settings › Settings; the figures quoted here are those recorded on the dates shown and are **not** a second source of truth.

## 1. Rules that apply to every AI service

| Rule | How it is met | Status |
|---|---|---|
| A model is pinned per service and lane; no "auto" routing across models, so every stored answer traces to the model that gave it | `pipeline.ai_service_routes` and `ai_route_qualifications`; only provider-level routing controls (such as `require_parameters`) are used | Met |
| A model never writes to the catalogue on its own word | Structured JSON answer only; the quote must be on the saved page; deterministic checks; then the admission gate; manual locks always win | Met |
| A passing qualification never switches a service on | Activation is a separate, approved step | Met |
| The person can see what was sent | The instructions each service sends are generated from the worker source into `docs/platform/ai-prompts.json` and shown on Models & services; a staleness guard fails the build if the file is out of date | Met |
| Every answer records its prompt version and model | Admitted values carry the `prompt_version`; cost is written to the AI spend ledger | Met |
| Page text is data, never an instruction | Section 4 | Met from s810 |
| Spend and rate are limited | Section 3 | Met |
| The provider does not train on our data | Section 5 | **Gap** |

## 2. Service inventory

One card per service. "Reads" is what is sent to the model; "Writes" is what may result, always through its own admission path.

| Service (lane) | Purpose | Reads | Writes | Human check |
|---|---|---|---|---|
| Provider description (`provider_description`) | One or two factual sentences about a provider, each tied to a quote | Provider's own page text | Provider description, source tier recorded | Layer 4 for anything the checks hold; manual locks win |
| Course description (`course_description`, prompt `cdesc-source-grounded-v2`) | Source-grounded course description | Course page text | Course description | As above |
| Scholarship extraction (`scholarship_ai`, prompt v3) | Is this a scholarship, who may apply, what is it worth, with quotes | Award page and linked terms page | Scholarship fields after the database checks | Layer 4 |
| Entry matrices (`entry_matrix`) | Read a country's entry-requirement table | A stored copy of the table page | Entry requirements after the admission rules | Layer 4; 5% audit sample |
| Course entry and field enrichment (`enrich_fields`) | Fee, intake, English, study load and other fields | Stored course page | Course fields after field checks | Layer 4 |
| Boost study load (`boost_extract`) | Study load, as the page states it | Parts of a stored course page | Result file in Storage, then checks | Checks before admission |
| Adapter builder | Propose reading rules for a university's pages | Sample pages and the Platform Admin's marks | A draft adapter; nothing live | Platform Admin approves and activates after a dry run |
| Layer 1 induction mapper | Map a new source's columns | Source headers and samples | A draft mapping | Curator prepares, Platform Admin activates |
| Operations diagnosis | Explain a failing job | Job and error records | A note only | A person reads it |

Layer 3 AI validation was retired on 12 Oct 2026; the university adapters admit values, and AI is used where a page cannot be read by rule.

## 3. Spend and rate limits (ISM-2090, ISM-2091)

| Control | Where | Behaviour |
|---|---|---|
| OpenRouter credit floor and platform ceiling | Settings › AI & Models | Both stop when reached. Recorded 12 Nov 2026: floor US$5, field-enrichment guard US$25, entry matrices US$2 a day |
| Firecrawl monthly plan and credit reserve | Settings › Firecrawl | Scheduled work is held by toolset limits; on-demand work is held only by the account's own limits |
| On-demand gate | `security.on_demand_open_v1` and `on_demand_close_v1` | Opens with an estimate and reports credit left; closes with actual use |
| Batch size and retry timing | `pipeline.platform_toolset_settings` | Settings, never numbers in code (G2) |
| API rate per key | `website_api_v2_rate`, `rate_per_minute` per API key | Over the limit returns `RATE_LIMITED` |
| Per-call time-out | Fixed in code, marked `-- fixed:` | One slow call cannot hold a run |

Platform-wide cap on spend by an unattended Claude session: US$0 for AI and Firecrawl unless the Platform Admin opens an on-demand request (20 Nov 2026 directive).

## 4. Untrusted page text (ISM-2156 to 2159)

**The rule.** Everything read from a university or provider site is untrusted evidence. It is placed in a fenced block, with hidden content removed, and the model is told in the same message to ignore any instruction inside it.

**What `fenceUntrusted` and `stripHiddenContent` do** (`supabase/functions/coverage-sweep/untrusted.ts`, added in s810):
- remove HTML comments, `script`, `style`, `template` and `noscript` bodies, and elements hidden by the `hidden` or `aria-hidden` attribute or by `display:none`, `visibility:hidden` or zero font size;
- remove invisible characters that can hide text;
- defuse `<<<` and `>>>` so the page cannot close or reopen the fence;
- add a one-line statement that the block is evidence only.

| Call site | Treatment | Status |
|---|---|---|
| Scholarship extraction (`sch-extract.ts`) | Already fenced per source; hidden markup now stripped and fence markers defused | Met |
| Adapter builder (`builder.ts`) | System prompt says page content is untrusted; sample pages now inside a fence | Met |
| Boost study load (`boost.ts`) | System prompt says the page is data; page text now inside a fence | Met |
| Page-text reads in `coverage-sweep/index.ts` (course fields, address, scholarship check, central pages, matching) | Page text now inside a fence | Met |
| Provider and course description (`description.ts`) | Hidden markup is stripped when the page text is built. The prompt wording is held in the prompt registry (spec `s553`), so the visible fence needs a **registry version bump**, which is its own approved step | **Partly** |
| Undeployed Boost extractor Worker (admin repository `workers/cf-boost-extractor`) | Not deployed; the production Boost path is `boost.ts`. If it is ever deployed it must adopt the same fence first | Partly (not in use) |

Residual risk: text that is visible to a reader can still try to persuade a model. This is why a model's answer is never proof: the quote must be on the page, the checks are deterministic and manual locks win.

## 5. Provider data use (ISM-2103): open gap

The requests name a pinned model and set `require_parameters`, but **do not set a per-request data-collection or non-training preference**, and this repository holds no record of the account-level OpenRouter privacy setting. Until the Platform Admin confirms the account setting, the control is not evidenced.

| Next step | Owner | Note |
|---|---|---|
| Confirm and record the account-level OpenRouter setting that denies prompt logging and training | Platform Admin | Evidence goes in this document |
| Decide whether to add a per-request data-collection preference | Platform Admin | It can narrow the set of providers that serve a pinned model, so it needs a qualification run first (a separately approved step, not done in s810) |

What is sent is already limited to public page text and field names; no personal data, student data or credentials are sent to a model.

## 6. Change control
A change to a prompt, a pinned model or a limit is a versioned, logged change with a reason. A new prompt version runs in shadow first. Update this document in the same release as any new AI service.
