# CourseFinder Admin/PIM Design Decisions v1.32

**Status:** CURRENT M2 DESIGN DECISIONS  
**Date:** 25 September 2026  
**Supersedes:** v1.31  
**Change Controls:** CF-CHG-20260903-083, CF-CHG-20260903-084, CF-CHG-20260915-247

## Decisions 38–83
Decisions 38–83 from v1.31 remain authoritative and unchanged.

## Decision 84 — Layer 3 enqueue comes from the governed fee backlog
Layer 3 tuition work is queued only from the governed Layer 3 fee-validation backlog and only when a real Layer 2 fee target exists. An older rule that read the wrong population was replaced (CF-247, 23 Sep 2026).

## Decision 85 — Bounded fee-year resolution (option A)
Layer 3 may supply a fee year only when the quote states that year with the amount, within 2024–2030. Five required safety controls apply, including rejecting a course total presented as annual.

## Decision 86 — Layer 3 admission holds go to Layer 4 with plain reasons
An item Layer 3 cannot settle is routed to Layer 4 with a plain-English reason; no review item is created for validated tuition, which admission decides.

## Decision 87 — Admitted fees follow one record convention
Admitted tuition is recorded in catalogue fees with a key of course:audience:year:basis, linked to its Evidence and source. The same convention is used by Layer 3 admission and by Layer 4 human decisions.

## Decision 88 — Layer 3 daily limit and benchmark usage
The Layer 3 daily call limit is 1,000 per profile (reversible, noted on the profile). Benchmark calls currently count against it; excluding them is a follow-up.

## Decision 89 — Qualification is bound to exact code and model
A Layer 3 model is qualified for one binding: model, prompts, request format, validator and helper sources. Any change to these requires the manifest to be regenerated and the model to be re-qualified by benchmark.

## Decision 90 — Activation is a separate, deliberate step
A passing benchmark never activates a model. An administrator activates it explicitly, and a model must be paused while it is benchmarked.

## Decision 91 — Two consecutive clean passes are required
Qualification needs two consecutive benchmark runs that pass every real case and every safety control. Failed runs are kept on record; runs are never repeated until one happens to pass.

## Decision 92 — Benchmark runs name the profile and are spaced out
The benchmark service defaults to an old, disabled profile, so every run names the profile explicitly. Runs are spaced to avoid the aggregator's rate limit; a rate-limited run is invalid, not a model failure.

## Decision 93 — The benchmark keeps a strict JSON schema
The benchmark requires strict structured output. Production currently uses plain JSON mode and will move up to the strict schema, not the reverse. A model that cannot meet the strict schema through the aggregator (Claude Haiku 4.5 via OpenRouter, Sep 2026) cannot be qualified.

## Decision 94 — The benchmark mirrors production context
Real benchmark cases receive the same approved provider-rule context as production items, so a model is judged on the conditions it will run under. Before this, the benchmark rewarded guessing and penalised caution.

## Decision 95 — Quotes are compared as visible text
An Evidence quote must match the saved page's visible text exactly and in order. Link targets, JSON escapes, stray square brackets, formatting symbols and whitespace are removed on both sides before comparing; nothing is added.

## Decision 96 — A year selector is not a stated year
A fee year is recorded only when printed beside the amount. A list of selectable years does not state a year. Every quote must be one continuous passage from the page.

## Decision 97 — Provider-rule basis wording
Where an approved provider rule sets the basis (for example indicative annual), an AI answer of "annual" is accepted as the same yearly fee and the rule's wording is recorded.

## Decision 98 — Model comparison outcome, 24–25 Sep 2026
Mistral Small 3.2 was inconsistent (guessed years, invented quotes, failed a must-decline control). DeepSeek V3.2 and Gemini 2.5 Flash were safe but declined or blanked genuine values. GPT-OSS 20B was too slow. None passed two clean runs, so Layer 3 tuition validation is paused until a model qualifies. If a Gemini 2.5 model is chosen later, its successor must be planned.

## Decision 99 — One API key per aggregator
Profiles use their own key only if one is deliberately set; otherwise they use the aggregator's shared key. The register stores only the vault entry name; secrets are never read out or copied. The seven per-profile copies will be retired once the shared key is proven.

## Decision 100 — New model profiles start paused
New Layer 3 profiles are cloned from the reference profile's instructions, validators and limits, and are created paused. Nothing runs in production until activation.

## Decision 101 — Scoped search refresh
When fees or links change, only the affected courses' search documents are refreshed. The scoped refresh was proven identical to the full refresh. The full refresh still rewrites every row; making it write only changed rows is a follow-up (PERF-3).

## Decision 102 — Heavy summary reads are pre-computed
Dashboard and layer summaries are refreshed in the background every 2 minutes and Evidence filter options every 15 minutes, with a live fallback if stale. Reads that approach the 8-second limit are fixed at the source (index use, scoped work).

## Decision 103 — Tool-neutral Evidence
Acquisition tools are replaceable adapters (seven are registered). Each saved page records which tool and adapter fetched it. Downstream steps rely on visible text produced by CourseFinder's own normalisation, not on any tool's output format; storing normalised text per page is planned.

## Decision 104 — Provider fee profiles
Where a provider officially states what its published fee means, an approved profile records it: page pattern, audience, basis, exclusion words, the provider's guidance and link, approval reference and review date. Profiles are applied deterministically at Layer 2.

## Decision 105 — First provider rule: UQ program pages
UQ program pages show the indicative annual international tuition fee, per UQ's official fee guidance. Exclusions: total, semester, trimester, per unit, per credit, subsidy, Commonwealth supported, domestic, HECS. Review by 31 March 2027.

## Decision 106 — Deterministic admission for rule-covered pages
For pages covered by an approved provider rule, a fee is admitted without AI when the Layer 2 fee panel shows the exact target amount for international students, labelled as the fee, with no exclusion words in the text right after the amount. The year is left blank unless printed beside the amount. Anything else goes to Layer 3 or Layer 4 as before. (Decided 25 Sep 2026; build in progress.)

## Decision 107 — RMIT needs no provider rule
RMIT labels fees as "(year annual)" or "(year total)"; the rules already treat totals as not yearly. Storing total course fees as a separate fee type is a future product decision.

## Decision 108 — Countries without a regulatory course register
Layer 1 becomes a provider register (official where available, otherwise curated and approved). Layer 2 builds the course catalogue from provider sites. Listing and aggregator sites are leads, never Evidence. A country profile sits above provider profiles. Canada is the next country after Australia and New Zealand, after the consumer API phase.

## Decision 109 — Layer 4 review principles
One decision at a time; reason first, then the facts that settle it, then links; rule-based suggestions are shown but never applied automatically; opening an item reserves it for 30 minutes; managers (PIM Admin and above) see everyone's figures and others see their own; target: nothing waits more than 7 days.

## Decision 110 — Approve needs a complete value
Approve is offered only when a complete value is proposed (for tuition, already marked per year). Otherwise the reviewer uses Edit and approve and enters it. Approved tuition fees and course links are written to the catalogue and refreshed in search.

## Decision 111 — Reviewer-entered values have their own source
Values entered by reviewers are attributed to the "Layer 4 human review" source, approved for official course links in search, with the reviewer, time and note on the decision.

## Decision 112 — Send back really re-checks
Sending a tuition item back to Layer 3 re-queues its work item. A "send back" suggestion appears only once a newly qualified binding is active.

## Decision 113 — Official course link suggestions
Exit awards and study abroad or exchange registrations have no course page: suggest Reject (batchable). Research degrees: use the provider's research-degree page. Others are checked individually.

## Decision 114 — Batch decisions
Batches need the Pipeline Operator role, hold 2 to 100 items of one kind, require a typed confirmation and a reason, record every item individually plus the batch, and are all or nothing. Items someone else is reviewing are refused.

## Decision 115 — Scholarship scope is decided per course
Scholarship scope is decided course by course in batch work; the scholarship-level item can be marked done only when no courses remain undecided.

## Decision 116 — Menu and screen simplification
The Review Queue is retired (its address opens Layer 4). Jobs and Scheduled Tasks are one menu item, Jobs & Schedules, with tabs; the single pages remain as routes. Duplicate Layer shortcuts are removed from screens; the Administration tab row duplicates are next.

## Decision 117 — Onboarding stays in Administration
Onboarding remains under Administration, reversing the earlier UI-0 note: it is an occasional set-up task (for example onboarding a new country) and an existing governance test records it there.

## Decision 118 — Release notes are complete and current
The version pill shows the current release. The full history is generated at build time from the legacy list, the release notes files and the manifest, and a searchable page lists every release. Each visible release adds its notes; fixes without a screen change are listed in the next visible release; the version changes only with visible changes.

## Decision 119 — Delivery through consolidated packages
Work ships in consolidated packages, one pull request each. Edge functions are deployed only through the guarded workflow (allow-list with recorded settings, typed project reference matching a repository variable, Layer 3 contracts first). Files starting with a dot are created in the web editor, because the upload page skips them.

## Decision 120 — Testing before packaging
Run every changed module, not only build it; time the reads a change touches from cold; prove data changes with rolled-back runs; make sure every UPDATE and DELETE on the app path has a WHERE clause; merge only with a green smoke test; fix or retire stale tests while keeping their intent. An hourly read-speed check and tests on pull-request previews are deferred.

## Decision 121 — Roadmap to production
P1 queue relief, P2 Jobs, P3 screen review, P4 menu redesign, P5 admission cross-check (with P5a tool-neutral Evidence and provider profiles first), P6 consumer API for Wix and Zoho, P7 release history, P8 guides by role, P9 metrics, P10 production build in a new environment. Recommended production region: Sydney.

## Decision 122 — Decisions are recorded here promptly
Each design decision is numbered when made and added to this document at the next admin update, no later than the close of the package in which it was made. Runsheet entries reference decision numbers.

## Decision 123 — Preview deployments stay blocked from admin functions
Pull-request preview addresses remain blocked by CORS from calling admin edge functions. Revisit only with the production CORS design (P10), which also decides whether live tests can run against previews.
