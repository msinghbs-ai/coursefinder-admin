# StudySearch — Shared Source-to-Published Enrichment Contract
**Scope:** provider descriptions (F-PDESC), course descriptions (F-CDESC), academic entry requirements (F-AER), and shared operations (F-OPS / F-DISC)  
**Design decision recorded:** 10 November 2026, Australia/Melbourne  
**Status:** engineering design and acceptance contract; **NOT** proof of deployment or authority to change existing AER review policy.

## 0. Authority, owner and integration

- **Canonical governance:** docs/platform/AGENT-OPERATING-MODEL.md, STUDYSEARCH-FEATURE-ACCEPTANCE.md, STUDYSEARCH-EXECUTION-REGISTER.md, STUDYSEARCH-PROGRAMME-STATUS.md, PIPELINE-LINEAGE.md, UI-CATALOGUE.md, and the corresponding process records. Claude is the sole accountable integration/release controller. This design does not create another controller, queue, scheduler, dashboard, acceptance register or integration-issue family.
- **Previously approved scope:** docs/platform/nz-enrichment-brief/2026-11-09-all-providers-autonomous-description-delivery-decision.md and 2026-11-10-course-descriptions-autonomous-ai-admission-decision.md authorise *development* of narrowly proven machine admission for factual provider and course descriptions, not its automatic assumption before legitimate release/activation.
- **Related current acceptance:** F-PDESC.01–.05, F-CDESC.01–.06, F-AER.01–.06, F-OPS.01/.02/.03A/.05/.06, F-DISC.01; preserve existing IQ-00022/provider, #894/#900/course, IQ-00060/IQ-00293/AER and IQ-00355/planning ownership when applicable. Resolve actual current issue numbers from the integration queue; do not create duplicate issues based on this design.
- **AER authority is different:** F-AER.04 requires genuinely complete human-decision packets for first reads and other protected AER classes under present policy. This document **does not** authorise automated approval of first-read AER, qualification equivalence, grades, scores, or unsupported admission pathways.
- **Non-negotiable:** G1 job catalogue, G2 settings/spend, G3 frozen Website/Zoho contracts, G4 human approvals/manual locks and audited write gates. No direct catalogue SQL updates, impersonated review decisions, hidden paid search, mass Layer 4 approval or an independently scheduled Claude task.

## 1. Field observation: Monash Provider Fill Fields is not meaningful delivery

The 10 November operator screenshot of Monash University (AU, CRICOS 00008C) showed *Description missing* with a previously proposed Firecrawl read, **Waiting for human decision**, and an initial primary button **Preview what the reader would use**. Current Pilot main source at inspection:
- src/ProviderFillFields.jsx offers radio choices *Fill missing description*, *Refresh a basic registry description*, *Preview only* and *Verify publication*. For fill/upgrade, the first primary action invokes only the existing preview; a later *Save and queue with the reader* appears after preview and an operator audit reason. Internally the existing service supports preview → prepare → run → saved → verify, using public.admin_provider_description_run_v1; it is not a missing AI model or a reason to invent another pipeline.
- The generic human-decision badge conflates a genuinely protected human decision with a potentially recoverable machine-declined candidate or stale evidence. The existing F-PDESC.03 acceptance note separately reports Monash among machine-declined items relating to overly broad keyword checks. Reconcile its **current** exact evidence/decision, not the screenshot or an older observation, before deciding to re-read or reopen Layer 4.
- A prior proposed description is not canonical admission; a successful scheduled job is not new catalogue or consumer gain. The operator currently cannot issue an obvious single authorised **Extract/refresh description now** command without navigating a multi-step preview workflow.

**Design lesson:** expose the simplest legitimate *outcome* as the primary action while retaining fixed cohorts, audit, policy checks, source evidence, bounded costs, and asynchronous durable execution behind it. Automatically recover a source-supported candidate from technical holds; do not park everything in Layer 4 or re-spend on unchanged evidence.

## 2. One shared operating pattern, existing domain implementations

**Trigger → exact entity/scope selection → authoritative source reuse/discovery → verified identity and evidence → domain-specific AI/deterministic extraction → domain-specific validation → policy decision → governed canonical admission/exception → applicable consumer projection → HTTP read-back → scheduled recheck.**

This is a **shared user experience, state vocabulary, source/evidence contract and acceptance method**, NOT one generic extractor or write function. Reuse the current:
- Provider Description Run & Validate / provider-description-read / coverage-sweep / evidence and machine-admission route.
- Course Catalogue/Detail / Enrich fields / verified course-page stores, field-gap queue, enrichment plans, existing AI worker and the **new narrowly scoped course safe-class admission** when actually released.
- AER workspace, source inventory, entry-matrix-read and stored-page entry AI, course-entry first-read, Layer 4 inbox and existing AER application/replay.
- Operations Data Delivery (F-OPS.03A), job catalogue and existing review/recovery UI. Do not fork a second workflow per field.

### 2.1 Minimum common stage contract

For each requested provider, course or AER source/scope, expose **one durable run/cohort reference** and per-entity subresults with these logically distinct stages and timestamp/reason/actor:

1. **requested / policy-eligible** — immutable canonical provider/course identity, country, lifecycle, request type, selected scope, role, auditable request reason, current manual lock/rejection memory.
2. **source-resolved** — stored content valid, direct official page acquired, paid Firecrawl acquired or honest missing/invalid source; exact source URL and content hash. Mark old page vs fresh; link identity proof.
3. **extracted** — source-based AI/deterministic result, parser/model/prompt version, recorded cost/reservation; no AI call if previously verified text is reusable.
4. **validated** — per factual statement or structured AER row quote/table-cell proof, cross-entity identity and domain-specific eligibility; exact machine-decline code if rejected.
5. **decision** — authorised *machine-safe*, *human-approved*, *human-pending*, *technical-recoverable*, *evidence-held*, *policy-held*, *manual-locked* or *not applicable*; reviewer ownership only when human adjudication is actually necessary.
6. **canonical admitted / superseded / withdrawn** — prior and new value IDs, actor/rule, source/evidence ID, version and audit, or reason no change occurred.
7. **consumer projection / read-back** — Website and Zoho source state separately from eligible external HTTP response, with not-served and unpublished states distinguished from mismatch.
8. **completed / retry scheduled** — processed, valid, admitted, **net new retained**, published, independently HTTP verified, held, cost and next action. Record no-eligible as a real zero-work outcome, not a failure.

Persist these records in existing cohorts, items, job events, evidence, decision and consumer tables where possible. Propose a schema extension only for a **demonstrated missing persistence field**, with a guarded migration, not a parallel table family. Refreshing the browser or closing a phone must not cancel, duplicate or lose the result. Show queued, reading, validated, policy stage, admitted, published and exact time in the existing screen.

### 2.2 Sources: retrieval and authority ladder

Use the **same cost-aware policy** but different *acceptable content* per domain:

1. Reuse stored, current, **identity-proved** official pages (with URL, hash, capture and applicable registry/provider/course match). Reuse validated extracts and previously held candidates when source and rule hashes are unchanged.
2. Attempt a bounded direct read of official current page(s); follow verified official navigation from the registered site to appropriate About, **specific course**, or **entry requirements** pages. Resolve redirect, aliases, title and host identity rather than naïve first-keyword match.
3. If needed and allowed, budgeted Firecrawl map/scrape of a **small justified set** of official pages; dedupe by host/content hash and preserve existing credit, AI reservations, rate, retry and G2 limits. A source whose evidence can be reused must not trigger a repeat paid call.
4. An external search result or AI/Google-style search summary is **discovery of an official URL only**, never factual admission evidence. Search is not blanket authorisation for a paid service or external provider. Validate the official destination and read its primary content. Unverified third-party summaries, scraped provider mix-ups, obsolete pages and claimed accreditation/outcomes must not be admitted.
5. For **provider descriptions only**, where no About page exists, the already-approved and **actually implemented** registry-factual safe class may create a neutral minimal profile from authoritative confirmed registry facts. **Never** use a generic registry fallback to manufacture course content or AER grades/equivalences.

If page unreachable: classify timeout, 403, 404, JS/rendering, PDF/table, identity mismatch, empty body, missing link, no quote, exhausted credits and truly no official evidence **separately**. Automatically retry technically recoverable cases with bounded backoff and source-change triggers; park only real exceptions with owner/revisit, continue other eligible entities.

## 3. Operator UX: one primary outcome action, optional details

### Entry points (existing UI/navigation)

- **Provider Catalogue and Provider Detail:** **Extract / refresh description now** for one selected provider or bounded selection; optional **View evidence and decision** and **Verify publication**.
- **Course Catalogue and Course Detail:** **Fill / refresh course description now** for exact course ID/CRICOS, selected courses, or bounded selected-provider course cohort; show official course source and each item.
- **AER Workspace / Provider Detail / Course Detail:** **Read / refresh entry requirements now** with explicit provider-wide matrix vs one course, relevant prior-education country/qualification (where scoped) and audience. Do not silently treat university-wide entry requirements as a course-specific requirement or one country as all countries.

**Interaction contract:**
- Where authorised, one click requests a **durable governed run**. Internally the backend may perform preview → fixed membership → prepare → run automatically **if all current rights/audit contracts allow it**; no second scheduler or direct SQL write. If an operator-entered reason is legally required by the current server policy, show a concise reason input rather than inventing approval or silently bypassing validation.
- The first screen must not force *Preview only*, *Refresh basic registry description*, *Save cohort*, or manual Layer 4 parking as the routine path. Preview/diagnosis/advanced controls stay available within expandable details.
- Explicitly distinguish **operator lacks permission**, **run-now allowlist off**, **AI/Firecrawl cap reached**, **source unavailable**, **policy/reviewer required**, **already up-to-date** and **no eligible work**. Never paint a disabled operation as successful.
- Default server-generated **context** is valid (target IDs, reason category, version); never fabricate a human policy decision. Existing rank checks, signed-in session, audit and authorised release/activation remain mandatory.
- Display source URL, evidence quote/table, AI result or structured rows, machine validation and decision, run ID, last run, next retry and canonical/Website/Zoho parity. Responsive desktop and phone; operator may close and return.
- On-demand work shares the **same** de-duplicated queues and fair scheduler as unattended work, with bounded priority so user-triggered actions do not starve autonomous country/provider coverage or exceed budgets.

## 4. Domain-specific admission: same experience, deliberately different policy

| Domain | Required official source and extraction | Existing admission policy to retain | Special failure to prevent |
|---|---|---|---|
| **F-PDESC provider profile** | Verified registered institution identity, About / Who We Are page or allowed authoritative registry facts; short useful factual paraphrase and traceable claims | Safe factual class may be admitted by narrowly authorised **machine actor/rule only after release**; exceptional promotional/identity/locked cases held | Parked prior proposal, false human-pending label, broad word-only rejection, registry Basic blocking richer evidence |
| **F-CDESC course description** | **Exact bound official course page** for exact course/provider/level and variant; AI-generated distinct, useful course-specific scope and study content with claim quotes | Narrow **course** evidence-safe machine route when legitimately released/activated; not by lowering legacy review-first or auto-clicking Layer 4 | Generic university About text, wrong course/CRICOS, unsupported campuses, outcomes, fees, scholarship, duration, intake or accreditation |
| **F-AER university/qualification matrix** | Official entry page/PDF/table identifying country, prior qualification, programme level, entry grade/scale, year, relevant audience and applicability; row/cell/page evidence | First-read AER and protected changes remain **human Layer 4** under existing F-AER.04; technical extraction and review packet generation should be automatic | Guessing IB/GCE/Nepal equivalents, country rows, conversion scales, or universal entry from a generic paragraph |
| **F-AER course-specific entry** | Official course-specific requirements and provable programme identity, prerequisite, level and entry equivalence; linked but not conflated with provider-wide policy | Existing course-entry first-read and human correction/admission path; no new auto-approval asserted | Applying provider matrix indiscriminately to every course or recycling another course's prerequisites |

### 4.1 Provider descriptions — recover before re-reading

For Monash and other machine-declined proposals: inspect current evidence, source identity, sentence support, hold/decision and rejection history. Revalidate under **current approved safe policy**. If the problem is optional promotional wording or unsupported “unique/campus” claims, request a **neutral, fully quoted rewrite** from the same official evidence only when needed, then apply the **existing lawful machine path** if eligible. Do not re-crawl unchanged stored proof; do not override a human refusal, lock, identity mismatch or genuinely missing source. Reconcile any existing Layer 4 item with a distinct machine-settlement actor/rule and preserve history. Basic registry profiles must be eligible for About-page upgrade where authorised; unchanged Basic must not count as Enriched.

### 4.2 Course descriptions — deliver actual multi-provider gains

Recheck current source identity and eligibility for AU/NZ/CA active courses. Reuse the already-stored, bound **course-specific** page before calling AI; model creates concise content, quotes prove each claim and validator rejects generic/fabricated assertions. Existing Layer 4 proposals can be **machine-settled only under the released narrow policy**, with full decision audit and original manual history. At each step show distinct counts for source-ready, model-extracted, declined, held, safe-admitted, retained and consumer matched. No arbitrary 10/20-university stop phase; a technical canary does not become another manual rollout approval. Keep autonomous enqueue/read/admit workers independent of Claude.

### 4.3 AER — automate acquisition, parsing, recovery and reviewer readiness

AER is not one free-form text field. Keep two bound tracks:
- **Provider entry matrix:** provider ID, country of prior education, qualification (e.g. IB/GCE A-Level where actually stated), grade/score *with grading scale*, level, intake/admission year if applicable, audience/route, official URL/edition, table row/PDF page, source hash and confidence. **Missing year/scale/country is not AI permission to infer it.**
- **Course entry:** course ID, exact provider/qualification/level/CRICOS or country code, course prerequisites/requirements, evidence and source precedence over generic provider rules where applicable. Show any conflict as a reviewer packet, never a silent overwrite.

The on-demand action must **fetch/refresh official sources, extract structured candidate rows, validate completeness and prepare the existing Layer 4 item** automatically. When an authoritative policy requires a person for first admission, report **“Ready for reviewer: N complete rows”** with direct Inbox link and owner; do **not** report “Published”. Recover incomplete packets by automatically finding the missing page/PDF or specific table cells; distinguish “source found”, “parsed candidates”, “complete reviewer packet”, “approved”, “active canonical” and “consumer visible”. Prior-education-country gaps such as Nepal/IB and absent university source pages are **test scenarios**, not permission to invent equivalences.

AER may gain from source discovery and zero-cost stored reading even when first admissions are human-gated. Report these as real **stage advancement**, not net active-entry gain. Any proposal to machine-approve protected AER first reads is a **separate explicit policy decision**, not implied by provider/course-description approval.

## 5. Layer 4 and recovery contract

Do not use “Waiting for human decision” as a catch-all for any machine decline. Distinguish:
- **technical_recoverable:** timeout, reader/quote bug, missing source link, stale proof, parser format, unsupported optional wording; platform retries or routes source work without requiring a person.
- **evidence_unprovable:** correct official page checked but essential fact absent; durable reason, attempted sources and next source-change revisit.
- **identity_conflict:** wrong host, campus, college/university collision, unmatched course or qualification; guarded recovery and, where necessary, explicit human resolution.
- **policy_human_required:** AER first run or other actual protected decision; complete packet, named reviewer authority and direct Inbox route.
- **machine_declined / rewrite_eligible:** previous candidate fails a rule but a neutral/source-supported variant may be generated; preserve rejected content and run again only with changed wording/rule/source.
- **human_rejected / manual_locked:** immutable protection until authorised human change; no automatic retries that defeat the decision.
- **budget_paused / scheduler_blocked / consumer_pending:** technical owner and time, not a Layer 4 approval demand.

Existing Layer 4 rows must not be silently deleted or bulk auto-clicked. For descriptions, a newly qualified machine-safe candidate can settle an old candidate **only through an audited released machine rule**, with before/after and original decision history preserved. For AER, keep the existing human admission boundary.

## 6. Unattended autonomy and zero-yield diagnosis

The platform must independently discover next eligible units, plan fair bounded batches, execute, retry, admit eligible results and publish without Claude triggering each batch. On-demand work is additive and may expedite one provider/course/AER source but must **not** become the normal data population method.

The previous independent observation (10 Nov ~19:12 AEDT, subject to newer live reads) identified IQ-00355: repeated 120-second failures in enrich_plan_auto_v1 → enrich_plan_v1 → enrich_unit_costs_v1; green five-minute executors can consume old plans while the **hourly auto-planner creates zero new plans**. Before accepting autonomy, verify actual **unattended newly created plans** and processed → valid → admitted → consumer deltas on at least two scheduled cycles. A disabled scheduled job, exhausted valid scope, zero eligible, paused budget and actual failure are different outcomes. Restore temporarily disabled jobs only through authorised controls; verify restoration and resulting work.

Show reason-coded first-run, retry/lease and zero-yield events in existing Operations Data Delivery and integration queue. Avoid repeated failed AI/Firecrawl spend. Preserve backlog fairness across AU/NZ/CA providers and courses, independent of human browser sessions, and fail one entity without blocking the cohort.

## 7. Data lineage, publication and honest measurement

For every material operation and subtask, prove the chain:
**F-domain/substep → existing IQ/SS → deployed commit/function/job/settings → official evidence ID/hash → extracted candidate → policy actor/rule → active canonical ID → applicable consumer stored projection → applicable external HTTP read-back.**

Report separately:
- attempted, official page acquired/reused, valid evidence, AI calls (and spend), proposals, declined, human-required, machine-admitted/human-admitted;
- active canonical **unique IDs before/after**, retained net new, removals, source-refreshed-but-unchanged and field completeness;
- Website and Zoho served/in-scope counts and exact values, projected but unverified, external HTTP verified, not served, not published and mismatch;
- AER pages found/rows parsed/reviewer-ready vs **active approved requirement rows**; any protected review backlog and owner;
- last scheduled and on-demand run IDs, stage times, next eligible batch, zero-work reason, backlog age and costs.

Never count a search snippet, a generic summary, a stored page, an AI proposal, Layer 4 queue growth, a cron success or a gross fill event as a *new consumer-visible admission*. Do not call non-served Canadian providers “Website publication failures”. Compare to timestamp-qualified historical baselines and superseding releases; avoid regression claims from stale snapshots.

## 8. Acceptance and negative regression suite

**Shared:**
1. Exact one-item Run Now creates immutable cohort/run; refresh/reopen browser and phone shows full stage progress and final state; duplicate click is idempotent.
2. Valid stored official source triggers no needless new Firecrawl or AI; wrong identity, redirects/colliding brand, 404/403, render/PDF, stale source and absent quote produce exact reason and bounded retry without cross-provider writes.
3. Unsupported claim, manual lock, prior rejection, policy/role denial, AI/Firecrawl ceiling, unknown cost reservation, a stopped worker, zero eligible, timeout and mid-run source change **fail closed** and preserve audit.
4. Two genuine unattended cycles produce eligible **new work** or an independently provable no-work state. No Claude hand queue is required.
5. Canonical IDs/value and Website/Zoho stored and applicable HTTP match; consumer lag shown honestly. Desktop and phone controls/actions tested.

**F-PDESC.01–.05 / F-OPS.03A:** Monash source-backed proposal is correctly classified; a neutral machine-safe recovery is admitted if current evidence/policy permit, otherwise the exact protected hold is shown. Verify a missing-description provider and an authorised Basic→Enriched upgrade (previous reported zero such upgrades). All eligible AU/NZ/CA scope, including providers with no website, has an honest source/fallback/exception result. No repeated per-provider operator approval for an actually approved safe class.

**F-CDESC.01–.06:** One exact active course and selected-provider bounded cohort produce **new retained course-specific descriptions** under the safe policy, across more than one provider; wrong course, provider About page, unsupported claims, duplicate content and locked/rejected cases are refused. Two unattended production cycles and matched consumer values; avoid treating historical “163” or later baselines as fixed current truth.

**F-AER.01–.06:** (a) one provider matrix official HTML/table/PDF, (b) one exact course entry page, (c) one prior-country/IB or GCE variation where supported, (d) missing source and incomplete grade/scale, (e) wrong host/university vs college, (f) prior approved/rejected and replay supersession. Verify preserved source cell/row, completeness flags, reviewer packet, first-run human gate, authoritative decision → active rows → applicable consumer read-back; **no fabricated equivalences or unauthorised auto-approval**. Demonstrate first unattended source-discovery/read advancements separately from new approved active AER rows.

## 9. Implementation order and responsibilities

1. **Reconcile latest main, active Pilot PRs and production truth** before changing code. Existing architecture is already present; use the smallest integration slice, not a fresh platform redesign. Record exact code/setting status as implemented-only, deployed-unverified, genuinely blocked or accepted.
2. **F-PDESC.03/.04 + F-PDESC.01/.02:** diagnose Monash's current machine-vs-human state and stale technical holds; deliver a one-click provider action built on existing cohort RPC; recover a genuinely safe source-backed candidate and demonstrate canonical + consumer value. Do not use a new AI crawl if existing evidence suffices.
3. **F-CDESC.02/.03/.05/.06:** apply the same UI/status/lineage pattern to existing Enrich fields; verify the new safe-class route is legitimately live, then deliver one course and bounded multi-course accepted results and scheduled growth.
4. **F-AER.01–.06:** reuse the new source/recovery/status experience in the AER workspace with domain-specific structured output and existing protected Layer 4 admission. Deliver source discovery, complete reviewer packets and honest approved+published metrics. Do **not** change AER approval rights under this design.
5. **F-OPS.01/.02/.03A/.05/.06:** resolve any root-cause planner/worker starvation that prevents autonomous advancement; show one common stage truth in existing Data Delivery. Update existing acceptance, execution register and derived programme status with **verified** commits, first runs and gains only.

**Release and evidence requirement:** Claude owns code, independent QA, integration and serial reviewed deployment under the canonical operating model; full exact-head release CI, guarded migrations and live acceptance. Only the Platform Admin can decide protected new financial, destructive, G3 or AER first-admission policy requests. This documentation change alone does **not** deploy a UI, admit any record, raise a budget, activate a job or settle a Layer 4 item.

## 10. Final user-facing acceptance

The desired outcome is that the operator can select a provider or course and press **Extract/refresh now**, or select an AER matrix/course and press **Read/refresh requirements now**. The platform autonomously finds the best **official evidence**, reuses it economically, extracts and validates with the correct domain-specific rules, admits safely only when authorised, otherwise produces a complete reviewer packet or a precise recoverable exception, and shows actual canonical and applicable consumer results. The scheduled platform repeats this independently **without Claude**. The operator is not asked to orchestrate individual intermediate steps or approve safe description candidates one by one.

## 11. Lean AI input and evidence snapshots — design recommendations (13 November 2026, pending Platform Admin sign-off)

**Status: recommendation only, NOT a new protected budget or execution approval.** Consolidates the Platform Admin's review of Claude's F1–F8 input-size and screenshot proposals, alongside v2.16.0 Models & Services. Reuse existing source storage, `pipeline.evidence_artifacts`, capture readers, shared canonical stages, model/prompt registry, Data Delivery and existing role-gated evidence inspector; **no new orchestration engine, dashboard, permanent job family, standalone pilot or consumer API shape**. The reported evidence-bucket figures (188,046 HTML / 10.7 GB, 32,400 JSON / 9.7 GB, 2,590 Markdown / 10 MB, 28 PDFs, 4,617 adapter PNG / 7.5 GB plus 2,283 evidence PNG) are **Claude-reported snapshots and bucket/selection-specific**, not independently audited platform-wide file counts. A large normalised JSON is NOT evidence of a large AI request until actual request bytes/tokens and calls are traced.

### 11.1 Decisions recommended, not executed

| Proposal | Recommended position | Required proof and safe semantics |
|---|---|---|
| F1 full-source + clean Markdown | **Approve in principle, after measuring baseline** | Direct fetch/stored HTML first; when already using Firecrawl, ask for `rawHtml` or `html` as appropriate plus `markdown` and preserve metadata. Source version and content hash must remain immutable. For JS-rendered pages compare extracted facts with original/rendered copy. Multiple ordinary formats are supported; do not assume adding screenshots changes no service cost until a measured credit/latency probe |
| F2 source section slicer | **Approve** | Deterministic heading+DOM/table-aware sections with surrounding title, year, provider/course/campus/award identity, table headers and footnotes. **Preserve exact spans and offsets back to original evidence**. For long PDFs split by table/section with real row/column alignment; do not truncate away qualifiers |
| F3 answerability preflight | **Approve only as high-recall negative filter** | Prefer structured page classification. A missing keyword is **not** proof a page has no entry requirements, eligibility, value or intake (tables, aliases, implicit headings, international synonyms). Unknown/ambiguous pages still reach the qualified reader or explicit evidence recovery. Shadow-check known positives and false negatives before suppressing paid AI |
| F4 content/result cache | **Approve** | Cache by source evidence hash + section span/version + field/service + prompt/model + schema/verifier version + identity/audience/edition inputs. Reuse before reading again, but revalidate on changed policy/identity, new course associations, expired source or changed schema. Negative caching needs TTL/retry trigger. Historical disputed/rejected manual decisions stay locked |
| F5 model input and parameter contracts | **Approve** | Per-service tokens/bytes and output caps, supported `response_format: json_schema`, `provider.require_parameters: true`, provider/endpoint qualification and actual credit-floor checks; a cap causes **split/park with reason**, not silent text truncation or context loss. Model selection lives only in Models & Services when genuinely wired |
| F6 cost/quality observability | **Approve** | Tokens in, out, cached, actual model/provider, prompt+schema version, input payload bytes, source hash, AI/provider cost, fallback and refusal reason; report **cost per valid retained canonical field/source-backed admission** and Website/Zoho visibility, not only cost/call |
| F7 PDF conversion | **Approve selectively** | Reuse original PDF; native text and independently proven table geometry first (AER aligned grids); Cloudflare AI PDF parser where suitable, with explicitly named engine and checked layout; paid OCR/vision only for scans or table/image failures with versioned evidence. Confirm actual PDFs across relevant buckets before broad change |
| F8 visual snapshot | **Approve selectively and with versioned retention** | Capture at source-acquisition time for high-risk rendered/tabular evidence, Layer 4 cases, adapter examples and explicitly requested operator captures, or where a future admission warrants it *without misrepresenting a later screenshot as the original source snapshot*. Reference by immutable evidence ID + capture timestamp, file hash, image location; copy expiring provider URL promptly; keep referenced historical snapshots. Store WebP when legible and smaller; tile long pages around relevant passages instead of clipping lower evidence |

**Recommended options:** scope **C first → A** (measure actual payload size, then implement F1–F6 under existing architecture), existing evidence **A** (offline deterministic conversion from stored HTML; no Firecrawl re-scrape of unchanged evidence), model candidates **A** (qualify MiMo-V2.6-Flash and Mistral Small 4 independently versus Qwen3 per service), screenshots **A selective** with **full relevant evidence** rather than truncated full-page capture, and legacy PNG **A only where evidence references, readable text, checksum, restore and net storage saving are verified**. A separate tool vendor such as Trafilatura/Readability SaaS is unnecessary; a small deterministic local conversion library for the *existing* HTML corpus is useful and distinct from paying Firecrawl to scrape anew. Source HTML, original PDF and already referenced images must not be overwritten/destructively replaced simply to save bytes.

### 11.2 Further improvements worth integrating into the same work

1. **Trace actual AI payload before change:** join queued input JSON / Worker request builder → model request ID → OpenRouter generation response / actual prompt & completion tokens. Measure p50/p95/p99 byte/token size by service, and what fraction of `extraction-input.json` reaches the endpoint. Do not multiply storage-file size by requests as a cost forecast.
2. **One-pass multi-field reads:** where a single verified page contains description, fees, intakes, English and admissions facts, extract a structured evidence-linked bundle once, then route each claim to its own admission/lock/checker. Do not re-call the same AI on the same document for every field; do not combine contrary admission policies.
3. **Change-based re-extraction:** use canonical document hash and per-section hash to detect revised portions; retain old edition and compare extracted facts/dates; re-run only relevant fields. Never treat an unchanged hash as current when the source's verification interval has elapsed.
4. **Immutable evidence and quote locator:** raw source, derived Markdown, table-cell geometry, source URL/final URL, content hash, screenshot ID, text offsets, prompt/schema version, adjudicator, last verified and authoritative source edition are linked; a user viewing one field sees exactly its proof. Scraped source instructions are untrusted content; strip scripts/hidden text safely and ignore page prompt-injection instructions.
5. **Quality-based fallback:** deterministic extraction → small qualified model → alternate qualified model only on genuine parse/evidence/unsupported-output failures. The alternate may improve interpretation but cannot waive official host, source quotes, human decisions or exact course/provider identity. Model acceptance uses independently labelled AER/fees/intakes/scholarship examples, including negative, ambiguous, multi-award and multi-campus pages.
6. **Provider-aware prefetch and source reuse:** do not re-scrape already captured unmodified pages; use official map/search only to discover missing sources. Respect robots, canonical host and previous rejection history; avoid storing screenshot-only evidence as a substitute for original webpage text.
7. **Storage economics:** current file size and chargeable Supabase Storage bytes, download/egress, WebP conversion labour, preservation and retention must be measured. A 14-day generic cleanup cannot delete a historical screenshot still cited by an admitted value, reviewer decision, lock or protected audit. Minimise screenshots for unadmitted/unchanged sources. Image accessibility is more important than a universal 150–250 KB target.

### 11.3 Acceptance and implementation sequencing

**Phase 0: measured baseline (no paid reacquisition):** representative actual AI requests per critical service and source layout; report input byte/token percentiles, output tokens, source page lengths, provider spend, valid admitted values and request-to-evidence hashes; check whether large 775 KB `extraction-input.json` files are actually transmitted, vs merely staged. Preserve at least **one positive and one false-negative case per field/source family**.

**Phase 1: lowest-risk savings:** offline HTML→Markdown sidecar with deterministic converter version, structured table preservation and section offsets, high-recall preflight, dedup/source hash cache, per-service token caps with split/hold, actual usage logging; scoped source-based regression and independent QA. No prompt/model budget or admission policy change inferred.

**Phase 2: limited evidence imagery and model qualification:** capture selective screenshot with actual Firecrawl credits and latency measured on the existing authorised acquire path, store as versioned WebP/tiles and inspect in the existing evidence panel; test MiMo and Mistral Small 4 for each service's strict JSON/quote/identity/latency/true retained-field yield, pin endpoint/model and recheck prices. Defer legacy PNG conversion until references, retention and rollback are validated.

**Release acceptance:** representative source-shaped regression fixtures, no citation/identity/round/level loss from slicing, no false negatives silently classified as “not found,” no human admission bypass, actual token/cost savings versus same-source baseline, zero newly incorrect admissions, correct canonical and Website/Zoho status, and two unattended run cycles. Models & Services v2.16.0 release blockers in F-OPS.08 (scope-safe on demand, credit floor, service routing/qualification and permissions) remain in force. Avoid independent PR/UI branches that duplicate its backend.

**Vendor documentation checked 13 November 2026:** [Firecrawl scrape](https://docs.firecrawl.dev/features/scrape), [Firecrawl billing](https://docs.firecrawl.dev/billing), [OpenRouter PDF](https://openrouter.ai/docs/guides/overview/multimodal/pdfs), [MiMo](https://openrouter.ai/xiaomi/mimo-v2.6-flash), [Mistral Small 4](https://openrouter.ai/mistralai/mistral-small-2603). Prices and extra charges must be fetched/verified at model-qualification and source probe, not pinned indefinitely from prose. This proposal **does not authorise a new model, AI/vendor spend increase, blanket screenshot retention, legacy deletion, live settings change, UI sign-off or production job**.
