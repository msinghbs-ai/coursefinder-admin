# CF-247 — Continuous AER coverage assurance mandate
**Date:** 2 November 2026 AEDT
**Status:** Platform Admin design decision; implementation not yet performed.
**Depends on:** `docs/platform/ENTRY-REQUIREMENTS.md` Draft 1.2 §F; `2026-11-02-aer-qualification-coverage-gap-assessment.md` AER-GAP-01–10.
**Canonical reporting:** Extend StudySearch Admin `Coverage & completeness` and its existing operational reporting. Do not add a disconnected spreadsheet, standalone portal, manual provider checklist or unauthorised notification channel.

## Goal
Eliminate Platform Admin-driven university-by-university gap discovery. Automatically inventory all eligible AU/NZ providers, detect published academic admission coverage gaps across nationality/education-country, global qualifications, level/course and source edition, route actionable cases through existing governed operations, and report transparent longitudinal progress.

## 1. Inventory and expected coverage
- First establish an eligible AU/NZ provider denominator from live catalogue, with lifecycle/publication/international-intent criteria, reporting unknowns separately. Provider missing URL is a discovery gap, not automatically 'not published'.
- Source inventory: official primary AER landing page and linked country pages, international/global qualification pages (IB/GAC/GCE etc), course and master's/research entry pages and PDFs/JS sources, using existing canonical source tables. Each source is tied to provider, discovered section inventory, source shape, evidence/hash, edition, last read, and last successful verification.
- Only claim a country or qualification **expected** where authoritative source navigation/content supports it; avoid false missing flags from the entire world-country list. Distinguish provider-recognised qualification, country where curriculum is offered, and applicant's education country. No fabricated IB country clones.
- Establish evidence-based expected-section manifest for each source (country, qualification, study level, course/band, printed minimum cell count, policy edition), with reproducible source snapshot/provenance. When the source is inaccessible or unparseable, flag `coverage_unknown` in reporting rather than asserting 100%.

## 2. Continuous reconciliation
One provider × source × scope (country/qualification/study-level/course/edition) stable fingerprint; map:
source discovered → accessible/stored → source sections inventoried → extraction complete → proposed → verified/admitted → active consumer resolvable.
A fetched `read` source can still have a failed run or incomplete sections. Scope-based counts must not overstate completed coverage.
Persist audit timestamp, latest manifest hash, detection reason, evidence IDs, previous/next state, and first/last observed time. Deduplicate by fingerprint; carry history across checks and reopen on regression. No new admission status values: operational findings are **observations** and reference existing lifecycle states.

Severity:
- P0: incorrect/unverified source values visible, active data drift, broken admitted resolver, evidence mismatch.
- P1: missing published country/global qualification or postgraduate route, incomplete extracted page, critical stale source, released publication coverage reduction.
- P2: missing provider landing URL, newly detected source, informational edition change, optional coverage.
Escalate false positive/repeated failures separately; source evidence not available ⇒ unknown/needs evidence, never automatic 'complete'.

## 3. Autonomous remediation within existing authorisation
Stored evidence first; no paid re-read just to collect counters. Auto-skip unchanged content; deterministic tests and existing approved source/jobs where available. Use existing Layer 2/3 acquisition and AER reader, current admission and Layer 4 workflow, config/budget constraints, robots rules, throughput limits and idempotent restarts.
- Auto resolve only observation states supported by already active verified records, restored source visibility, or completed reconciliations.
- Any new or materially changed academic minimum, reader correction or first-run matrix remains pending for Layer 4; never auto-approve or bulk settle AER.
- Respect 30 Oct ingestion holds, 28 Oct 40-provider scope and bounded RMIT exclusions until a documented superseding execution approval. This document approves **audit design and reporting**, not unrestricted reads or held production changes.

## 4. Efficient reporting channel
Extend current `Coverage & completeness` AER section rather than a second dashboard:
- Four separate coverage metrics: **discovery, extraction, verified admission, consumer-resolvable** (numerators and evidence-backed denominators shown).
- By AU/NZ, provider, study level, country-specific and global qualification families, admission route; unresolved unknowns shown.
- Provider drill-down: primary/additional AER official URLs, latest manifest/evidence, exact gaps, age, status, owner, next approved action, Layer 4 pointer.
- Trend: new vs closed vs reopened findings; net change; throughput; no-progress providers; 7-/30-day trends and ETA only when defensible.
- A standing action queue sorted by impact, status and age, not a separate issue per missing cell; one deduplicated issue per underlying source/parser/root cause with linked affected providers.
- Owner segregation: Engineering for parser/schema, Pipeline Operator for source discovery, Layer 4 for review, Platform Admin for approval only.

Cadence:
- Hourly **read-only/lightweight** reconciliation aligned to the existing staggered jobs and runtime limits; no new concurrent scans of all pages each hour.
- Daily incremental summary using persisted snapshots/deltas. Re-inventory official source navigation on a configurable approved cadence (default proposed weekly) or source edition/hash change, subject to the acquisition hold, budgets and site rules.
- Weekly Monday 08:00 Australia/Sydney executive digest by the existing StudySearch operational reporting delivery, not a new ChatGPT reminder or separate email list.
- Critical exceptions through existing deduplicated push/email alert mechanism with recovery notices. No routine per-provider notification flood.

Executive digest must report eligible providers, source coverage, current published country/qualification scope, active verified entry coverage, course-level postgraduate coverage, open severity counts, new/closed/reopened gaps, oldest holds, Layer 4 backlog, planned next wave, measured processing cost and specific Platform Admin decisions needed. Clearly label **not measured**, **not published**, **pending review** and **blocked by policy**.

## 5. Tests and acceptance
- RMIT IB/GAC qualification-only source is inventoried rather than rejected for lack of country; UK 31-cell count fails closed if any absent; Nigeria/Vietnam/held sources surface with exact cause.
- Nepal+IB and Switzerland+IB share applicable provider policy without synthetic country rows; Nepal national HSC independent; US diploma issuer restrictions enforced.
- Master's course-specific requirements are not misreported as complete from an undergraduate matrix.
- A source marked read yet run failed appears as failed extraction.
- Missing-country reports derive only from published source manifest; denied/unknown pages remain unknown, never zero-gap.
- Duplicate scans do not duplicate findings; source change reopens findings; resolved items require evidence; regression raises alert; alert dedup/recovery verified.
- Dashboard and report figures reconcile to read-only database queries; cross-provider totals weighted correctly, no score inflated by small providers; 24h and 7d verification as applicable; no paid reads or admissions from the reporting scan.
- Preserve existing test register rule/G4, UI role controls, release gates, consumer API approval and rollback.

## 6. Delivery and handover
Integrator: reconcile this mandate against the latest execution register and active work, assign a unique SS task identity, append relevant change-control, propose settings and SQL objects only when validated against live schema. Build lightweight audit snapshot+diff under existing scheduling, then Admin AER reporting, then alert/digest integration; execute only stages permitted by standing authority. Record baseline, representative fixture outcomes, measured runtime/expense and actual deployed verification before calling anything complete. Weekly report should replace manual gap-chasing, not create another reporting obligation.
