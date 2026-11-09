# AU builds and enrichment jobs — MANDATE RECORD

**Record type:** Mandate record, not an execution response.  
**Issued:** 24 October 2026, 09:55 AEDT, by the Platform Admin.  
**Recorded:** 24 October 2026, to close the durable-record gap.  
**Sources:** the mandate text preserved in the later response; [AU quick wins](2026-10-24-au-quick-wins-and-247-ingestion.md) section 6 for B1–B6 and section 7 for the coverage baseline; [NZ field admission](2026-10-24-nz-field-admission.md) section 5 for entry requirements; [Platform throughput gap and schema plan](2026-10-23-platform-throughput-gap-schema.md) for R1/R3 and the standing order.

> **Execution-state note:** the mandate was issued on 24 October but was never executed as a complete builds-and-enrichment programme. When the record gap was identified, no response file existed at this path. R1 and R3 were subsequently delivered under Phase 0; those releases do not mean B1–B6 or every E-job was completed. Execution evidence belongs in separate release records, principally [R1 — release plan and verification](2026-10-24-r1-release-plan-and-verification.md).

## 1. Phase 0 — R1 first, then R3

**R1 ships as ONE uninterrupted release before any build:**

- **Q2:** empty-tick backoff with event-driven reset. Any new eligible work must wake the lane; backoff must never leave a lane idle while eligible work exists.
- **Q4, narrowed:** fix the companion-read failure and add a per-lane “why idle” line. Do not expand this pass into the other stuck-lane causes.
- **Q3:** durable per-mode outcome ledger.
- **Apply-time identity check:** enforce the bound page’s identity basis in the common apply path, not only at enqueue.

**R3 follows only when R1 lands:** `health-hourly` at minute 11, using the existing hourly report rather than a new panel. Its provisional headline target comes from its first full week of evidence; a passing qualification never sets the target or activates anything by itself.

Nothing is applied, merged, deployed or activated without the approval gates in the standing order and CF-247.

## 2. Decisions already made before this mandate

1. **Academic entry requirements approved first.** B1 uses the approved specification in [NZ field admission](2026-10-24-nz-field-admission.md) section 5: `catalogue.course_entry_requirements` beside the course; stored-page reading through the existing Enrich fields lane; quote-on-page evidence; statement-length, level, numeric-scale and international-audience validation; existing status vocabulary and supersession behaviour. NZ + AU, stored pages first.
2. **Official-link fill widened and executed.** `course_url.fill_countries` was widened from NZ to NZ, AU and CA. The logged fill produced **16,889 AU and 1,863 CA links**, with no retractions. This is a completed prior decision, not new R1 scope and not a claim that B1–B6 started.
3. **Description and scholarship readers approved behind settings** where stored copies cover the population, using quote-on-page evidence and existing apply paths.
4. **Provider calendars remain off** unless the Platform Admin decides otherwise. Zero-yield automatic resets likewise remain off until separately approved.

## 3. Phase 1 — builds B1–B6

All builds are settings-keyed, use catalogued jobs and contract tests, and include count-guarded backfills where rows already exist. Every AI reader requires quote-on-page evidence and uses existing apply paths. Consumer API work is additive only.

| # | Build and required scope | Governed settings | Estimate | Expected movement |
|---|---|---|---|---|
| **B1** | **Academic entry requirements**, NZ + AU, stored pages first; the approved section-5 table, admission rules and reader | `entry.max_rows_per_course` 1–10/default 6; `entry.min_confidence` 0.5–1/default 0.8; `entry.countries` | 2.5 days | 0% until shipped; first rows within 7 days after shipping |
| **B2** | **Course-description reader** over stored copies into `courses.description`; sentences must occur on the page | `description.max_chars` 200–1,000/default 600; `description.min_confidence` 0.5–1/default 0.8; `description.countries` | 1.5 days | 40–55% of AU published courses within a week after shipping |
| **B3** | **Provider descriptions** from stored home/about pages into `providers.description`, initially the AU universities, then NZ/CA | B2 keys plus `description.provider_pages` | 0.5 day with B2 | 45 AU university descriptions after shipping and source coverage |
| **B4** | **Scholarship second pass** for eligibility summary, minimum academic result, eligible countries asked explicitly, and value-note/amount consistency; reject a contradictory note | `scholarship.second_pass_batch` 10–500/default 100; `scholarship.note_amount_check` 0/1 | 1 day | eligible countries 63 → 160–300; closing dates +50–100; contradictory notes corrected |
| **B5** | Add **`provider_annual_is_derived`** to the search document so lists can explain fees derived from the CRICOS registered total; visibility only, no fee-count change | none | 0.5 day | derived flag visible; tuition coverage unchanged |
| **B6** | Load **earlier QS editions** and correct **QILT name mapping** for UNSW, Adelaide, UQ College and USQ Sydney; distinguish unranked/not-surveyed from missing | none | 1 day | rankings gain explicit not-ranked states; graduate results 41 → 43, with two not-surveyed states |

**Order:** B1 first. B5 can run beside B1 because it is additive search-document work. B2 and B3 share the description-reader work; B4 follows B2; B6 follows B4. No build displaces Phase 0.

## 4. Phase 2 — existing enrichment jobs E1–E6

| # | Mandated job | Required treatment and gate |
|---|---|---|
| **E1** | **Provider-policy approvals** | Report the approval UX, how many proposals wait, and add a daily summary line to the existing work-queue report. Checked AI readings follow the already-approved automatic path; the remainder wait for a person under Settings › Provider policies. Do not approve proposals merely to raise coverage. |
| **E2** | **Intake-calendar on/off analysis** | Analyse what `provider-calendar-intakes` would write and whether it can move the gap. **Do not switch it on.** Record the decision for the Platform Admin; do not infer course start months from a provider calendar and present them as course-page facts. |
| **E3** | **Campus lists** | Check stored-page coverage before firing anything. Use the existing lane only if it can produce full lists; otherwise record the small-build gap rather than hand-typing page facts. |
| **E4** | **Zero-yield continuation** | F9 first: retain rejected quotes and correct field-specific rejection reasons before re-reading. Keep `zero_yield.auto_reset` off until decided; obtain the UoA catalogue-host-versus-manual-bindings decision; then continue to the NZ top-20 under the zero-yield guards. |
| **E5** | **Fee follow-through** | Drive the 149 identity-quarantined fees towards zero through reidentify, re-read and re-admission under each country’s rule. Close superseded Layer 4 rows through existing status behaviour. Manual bindings are never touched; any corrective paste job is count-guarded and logged. |
| **E6** | **Scholarship fields from existing reads** | Measure what the current AI and nationality reads already establish before building B4. Separate genuinely free admissions from fields that need a new prompt or sanity rule; no hand-entered values. |

## 5. Phase 3 — standing-order gates

Phase 3 requires status lines, not unauthorised activation:

| Gate | Required status and condition |
|---|---|
| **R2 / Q1** | Not part of R1. First produce the `target_only` audit paste file and obtain Platform Admin sign-off **O10**. Only then ship Q1 with `search.daily_picked_cap = 100`; raise it only on ledger evidence. |
| **Stepped read-lane test** | Follows R2 in the standing order; no throughput increase before R3’s tripwire is live and the evidence supports it. |
| **S1 full** | Absorb the zero-yield rejection table. Prove by contract test that search, AI match **and** finder all consume rejections. Zero-yield detect-only state does not activate S1. |
| **8a remainder** | Build the `country_identity_rules` table after S1; the earlier worker identity release does not complete this gate. |
| **Items 9, 10, 11** | Remain after 8a in the standing order; report their status without pulling them forward. |

Cross-cutting gates: no consumer API change without explicit Platform Admin approval; Website API v2 is additive only; no new status values; no manual-binding changes; no unguarded paste jobs; no new panels or SOPs without retiring old ones; no applied migration may drop or delete; operational values remain governed settings.

## 6. Expected AU coverage

Baseline population: **14,930 courses at published AU providers**. These are expectations from the mandate’s source records, not execution results. R2-dependent figures remain gated by O10.

| Gap | At issue | 24 h | 7 days | 30 days | Lever |
|---|---:|---:|---:|---:|---|
| Official course links | 74.5% served after refresh (11,130) | 75% | 76–77% | 80–85% | prior fill, then R2 bindings |
| Start months | 54% | 54% | 54–55% | 56–60% | R2; E2 decision remains separate |
| English requirements | 79% | 79% | 79–85% | 85–90% | E1 approvals + R2 |
| Tuition (any) | 99.3% | 99.3% | 99.3% | 99.3% | B5 changes the flag, not the count |
| Course descriptions | 1% | 1% | 1% until B2 ships, then 40–55% within a week of shipping | 40–55% | B2 |
| University descriptions | 0 of 45 | 0 | 0 until B3, then 45 | 39–53 after source-coverage reconciliation | B3 |
| Campuses (full lists) | city + postcode for all | — | +50–150 after list refresh/build and review | +50–150 | E3, then the resulting build if required |
| Scholarships — eligible countries | 63 of 898 | 63 | 63 until B4, then 160–300 | 160–300 | B4 |
| Scholarships — closing dates | 479 | 479 | 479 until B4 | 530–580 | B4 |
| Rankings | 38 of 45 | 38 | 38, with not-ranked states after B6 | 45 including not-ranked | B6 |
| Graduate results | 41 of 45 | 41 | 43 after B6 | 43 + two not-surveyed | B6 |
| Academic entry requirements | 0% | 0% | 0% until B1 ships | 10–20% | B1 |

## 7. Weekly matrix and blocked decisions

When Phase 1 lands, the existing weekly coverage matrix gains rows for official links, intake months, English, tuition and derived share, course and provider descriptions, campus-list completeness, scholarship nationalities/close date/eligibility summary/minimum academic result, rankings, graduate results and entry requirements. Each row names its unblock lever; item 10 remains the delivery vehicle and is not pulled ahead of the standing order.

Only these decisions are recorded as blocked:

1. **O5:** NZQA signatory-list page URL.
2. **O8/O9:** Firecrawl plan tier and monthly credit cap; OpenRouter plan and monthly spend cap.
3. **E2:** leave the calendar job off, build a provider-level typical-start field, or switch the job on.
4. **Zero-yield:** whether to enable `zero_yield.auto_reset` after the UoA pilot review.
5. **UoA:** catalogue-host allowance versus manual bindings for the 45 catalogue-only courses.
6. **E1:** provider-policy proposals continue to require their applicable automatic-check or human-approval path.

## 8. Mandate as received

> Mandate — ALL builds and data-enrichment jobs from the website developer's Australia gap review, plus the standing order. Phase 0: R1 (Q2 empty-tick backoff with event-driven reset; Q4 narrowed to companion-read failure + why-idle line; Q3 per-mode ledger; apply-time identity check) ships as ONE release before any build; then R3 (health-hourly at :11, provisional headline target from its first week). Phase 1: B1 entry requirements (first; 2.5 d), B2 course descriptions (1.5 d), B3 university descriptions (0.5 d), B4 scholarship second pass (1 d), B5 tuition derived flag (0.5 d), B6 rankings + graduate results (1 d); quote-on-page, existing apply paths, settings-keyed, catalogued jobs, contract tests, count-guarded backfills. Phase 2: E1 provider-policy approvals (report the UX, how many wait, a daily summary line), E2 intake calendars on/off analysis (do not switch on), E3 campus lists (check stored coverage first), E4 zero-yield continuation (F9 first; auto_reset off until decided; UoA decision; then NZ top-20), E5 fee follow-through (149 shrinking to zero), E6 scholarship fields from existing reads. Phase 3: status lines for R2, S1, 8a, items 9–11. Output: R1 + R3 references and the provisional target; B1–B6 with keys, estimates, expected counts, order; E1–E6; the 7-day / 30-day coverage table; the weekly matrix rows; what is blocked (O5, O8/O9 and the three decisions only).
