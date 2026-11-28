# Country-neutral identity, field applicability and fee grain: review (S1-RM-Design)

S1-RM-Design, 28 Nov 2026 16:30 AEDT. Instruction: `PC-20261128-EVENING-COUNTRY-NEUTRAL-CLOSURE` (canonical command: admin #1293, comment 7234089440). Lane scope: country-neutral field applicability, identity and fee-grain review, existing roadmap and reference fixtures. This review makes no schema change, no activation and no data write.

**How it was read.** I read the checked-in live schema capture, Pilot `supabase/live-capture/baseline/schema.sql`. It was captured 27 Nov 2026 03:21 UTC. No later migration on Pilot main (head `4255651`) redefines any function named below. I didn't re-read the live database, because this session has no governed live-read path; S1-Build's read-back confirms the live definitions. The live counts in the command (27,043 tuition, 47 mismatched sums, 187 total-only, 7,005 zero non-tuition) are Programme Control's reading. This review classifies the mechanisms behind them; it does not re-count them.

Feeds: Master Plan §6, F-FEE, F-DISC, F-OPS and PIPELINE-LINEAGE. S1-Build reconciles these findings into those documents when it records the evening checkpoint. No new plan is created.

## 1. Verdict

| Area | Verdict | Evidence |
|---|---|---|
| Course and provider identity | **Country-neutral already.** No new table or migration is needed for a new country | `catalogue.course_registrations` (scheme, registration_code, country_id, status, validity), `catalogue.provider_registrations` (registration_scheme, code, classification), `catalogue.course_identifiers` / `provider_identifiers` (scheme, identifier, country, authority) and `ref.registration_schemes` (scheme, kind, country_code, authority, `never_mixed_with`, status `planned`/`active`/`retired`). No CRICOS column is mandatory on `courses`, `providers` or `campuses` |
| Registering a future country's schemes | **Existing runtime route**, data only | `admin_registration_scheme_register_v1` (Platform Admin, rank 6). Adds the scheme as `planned`, never changes an existing one, logs to `pipeline.admin_control_events` |
| Fee table shape | **Country-neutral already** | `catalogue.course_fees` already carries all the grain columns: `currency_code` (nullable, FK to `ref.currencies`, **no AUD default**), `audience` (default `international`), `fee_type`, `basis`, `load_basis`, `is_csp`, `campus_id`, `fee_year`, `status`, source, evidence and source key |
| Fee grain uniqueness | **Not enforced at the semantic grain, by design.** The only unique key is the source identity: `(course_id, source_id, source_fee_key)` | `course_fees_source_identity_uidx`. Two sources can each hold the same course × year × audience × campus fee. The selector, not the table, chooses one (section 3) |
| Consumer fee selection | **No double count in the selector** | `security.course_fee_selected_v1` (s1056) chooses one year and prefers a provider-published annual fee over a calculated equivalent. It serves the registered total, non-tuition and estimated total as separate components and never adds them together |
| Fee writers | **Five reusable defects for non-AU and future countries** (section 2). None needs a schema change | AUD written as a fixed value, or an AUD/NZD/CAD allowlist, in shared writers |

## 2. Country assumptions in shared fee writers (one reusable gap for S1-Build)

| Function | What it does | Scope | Finding |
|---|---|---|---|
| `security.fee_rule_run_v1` | Layer 4 fee-wording rule admission | Shared | Writes `currency_code = 'AUD'` as a fixed value. **Defect** if a rule matches an NZ or CA course |
| `security.provider_rule_admit_v1` | Deterministic provider rule admission | Shared | Writes `'AUD'` as a fixed value. **Defect** for NZ or CA |
| `security.provider_basis_rule_admit_v1` | Provider basis rule admission | Shared | Writes `'AUD'` as a fixed value. **Defect** for NZ or CA |
| `public.svc_coursefacts_apply_record` | Course-facts apply, used by the fee schedule apply and others | Shared | `currency_code` defaults to `'AUD'` when the payload has none. **Defect**: a missing currency should hold, not default |
| `security.layer4_tuition_apply_impl`, `security.layer3_tuition_admit_assumed_annual_v1` | Layer 4 tuition apply; Layer 3 assumed-annual admission | Shared | Accept only `AUD`, `NZD` or `CAD`. **Defect for future countries**: a GB (`GBP`) or Ireland (`EUR`) fee is refused |
| `security.adapter_overwrite_v1` | Adapter fee overwrite | Shared | Currency comes from the payload, else a fixed NZ→NZD, CA→CAD, otherwise AUD mapping. **Weak**: it should read the country's `ref.countries.default_currency_code` |
| `public.admin_course_edit` | Admin UI course fee edit | Shared | Uses the payload currency, else the provider country's `ref.countries.default_currency_code`, else AUD. **This is the pattern to reuse**; only the last-resort AUD should become a hold |
| `public.svc_layer1_apply_course_regulatory_facts` | CRICOS register facts (registered total, non-tuition, estimated total) | AU register only | AUD and `registered_total_course` are correct for the CRICOS source. **Not a defect** |
| `public.svc_fee_schedule_apply` | AU provider fee schedules, keyed by provider CRICOS | AU schedules only | AUD is correct for the AU schedules registered today. It becomes a defect only if a non-AU schedule is ever registered (the configuration should then carry the currency) |

**Smallest proven fix (one consolidated release, S1-Build):**
- Currency is resolved in one place: payload, then the provider country's `ref.countries.default_currency_code`, then **hold**, never AUD.
- Validation is the existing `ref.currencies` foreign key, not a fixed allowlist.

This is a code change to six existing functions: no new table, column, job or setting. It qualifies as a genuine reusable code defect under `PC-20261128-NO-ROUTINE-DATA-PR`, so it needs a final-head CI release. It is not a data PR. G3 is not touched: none of these is a frozen consumer function.

**Not checked here:** whether any NZ or CA rows were already written as AUD by the three rule paths. That needs a live read, owned by S1-Build or S1-Data-Gaps:

```sql
select count(*)
from catalogue.course_fees f
join catalogue.courses c on c.id = f.course_id
join catalogue.providers p on p.id = c.provider_id
join ref.countries k on k.id = p.country_id
where f.status = 'active'
  and f.currency_code is distinct from k.default_currency_code;
```

Any rows found are a data correction through the existing route, not a migration.

## 3. Fee grain and the reconciliation buckets

`catalogue.course_fees` holds one row per source observation. The fee **components** are separate `fee_type` values and are not duplicates of each other:

| `fee_type` | `basis` values seen in writers | Meaning |
|---|---|---|
| `provider_current_tuition` | `annual`, `indicative_annual` | Provider's current tuition for one year. `indicative_annual` is a calculated equivalent (for example a semester fee × 2 with proven full-time load) and is shown as such |
| `tuition` | `registered_total_course` | Registered total tuition for the whole course (AU: CRICOS) |
| `non_tuition` | (register) | Registered non-tuition cost |
| `estimated_total_course_cost` | (register), `total_indicative` | Registered estimated total = tuition + non-tuition, a **derived total** |

How each bucket in the command should be read (classification only; S1-Data-Gaps owns the per-course evidence):

| Bucket | Mechanism | Not a defect when | Defect when |
|---|---|---|---|
| 47 courses where total ≠ tuition + non-tuition | All three come from one register row, so a mismatch is in the register itself or its rounding | The register's own values differ (the source states them so): keep all three as published | Only if the stored values differ from the stored register evidence. Compare with the evidence file, never recompute |
| 187 total-only | The register published an estimated total without the tuition/non-tuition split | Always valid as a total. Never derive tuition from it | n/a |
| 7,005 zero non-tuition | Register states 0 | 0 is a published value, not missing | n/a |
| `annual` and `indicative_annual` on the same course, year, audience and campus | Two observations of one annual fee | The selector prefers `annual` (provider published) and shows one | Two `annual` rows with different amounts: the selector returns `conflict` (correct behaviour) |
| `registered_total_course` against `provider_current_tuition` | Different components and bases | Always. Annual × duration above the registered total is expected (the registered total is set at an earlier fee year) | Never compare them as one figure |

**Rules that prevent double counting** (to be recorded in F-FEE; all are already met by `course_fee_selected_v1`):
1. Never add `estimated_total_course_cost` to `tuition` or `non_tuition`.
2. Never derive an annual fee from a total without proven load and duration.
3. Never convert currency.
4. One annual fee per (course, year, audience, campus) is shown; extra observations are candidates, not extra fees.

**Selector observations (no change requested; G3 untouched):**
- `campus_differs` is raised when a course-level row (campus null) and a campus row both exist for the year, even with equal amounts. Fee writers should therefore write either course-level rows or campus rows for a year, not both (relevant to VU 115486F).
- The conflict check compares amounts and ignores currency. Two rows in different currencies with the same amount would not be flagged; in practice mixed currencies within one course should never occur once section 2 is fixed.
- The "current year" uses Melbourne time for every country, a few hours' difference at the year boundary only.
- The response key `cricos_total_tuition` is AU-named. For NZ, CA and future countries it is simply null. Renaming it would be a consumer contract change (G3), so it is recorded only.

## 4. Field applicability (country-neutral)

Recorded positions, from the schema and the roadmap, that keep field applicability country-neutral:
- A course's registration is `course_registrations.scheme` for its country (AU `cricos`, NZ `nzqa`, CA `mtcu` and first-party codes, per DESTINATION-DATA-DESIGN). A field that needs a registration code applies only where the country has a `course_registration` scheme in `ref.registration_schemes`.
- A country with no course-grain scheme (GB today) leaves registration not applicable, not missing.
- Currency comes from the provider country (`ref.countries.default_currency_code`), never from a global default.
- Audience is local data: `international` is the shared value. Local tiers (Ireland's EU/EEA versus non-EU, UK home versus overseas) are mapped by the country adapter to stored audience values. The selector already takes the audience as a parameter, so no schema change is needed.
- `campuses.primary_basis` includes the value `cricos_head_office`. It is an AU source value within a neutral column; other countries use `provider_stated`, `highest_course_count` or `manual`. No change.
- `pipeline.provider_contact_import_batches.country_code` defaults to `'AU'`, and several older admin read functions take `p_country default 'AU'`. These are AU-first defaults on operator tools, not on canonical data, and are low risk. They should be listed in the settings audit and passed explicitly by callers for other countries.

## 5. Contract fixtures (paper fixtures; nothing activated)

The two future countries are the next two named in the existing roadmap (DESTINATION-DATA-DESIGN v1.12): **GB (RM3)** and **Ireland (RM5)**; the USA (RM6) is the alternate. The command did not name them, so they are labelled roadmap candidates. They are not activated, and no scheme is registered by this review.

| # | Country | Case | Expected result | Result against today's design |
|---|---|---|---|---|
| F1 | AU | Provider annual 2027 international, AUD, `annual`, course-level | Selected | Pass |
| F2 | AU | Registered total, plus non-tuition, plus estimated total for the same course | Three separate components; total not added to tuition | Pass |
| F3 | AU | `annual` and `indicative_annual` for the same year | `annual` shown, kind `provider_published` | Pass |
| F4 | NZ | NZD annual written through a provider rule path | Stored as NZD | **Fail**: written as AUD (section 2) |
| F5 | CA | CAD annual through the Layer 4 apply | Stored as CAD | Pass (CAD is allowlisted) |
| F6 | CA | Registration `mtcu` code; no CRICOS | Identity holds; no CRICOS field required | Pass |
| F7 | GB | GBP annual "overseas" fee, provider UKPRN, no course-grain registration | Stored as GBP; audience mapped by the adapter to `international`; course registration not applicable | **Fail** at Layer 3/4 (GBP refused); identity part passes with scheme registered as data |
| F8 | IE | EUR non-EU fee and a lower EU fee for the same programme | Two audiences stored separately; international shown for international | **Fail** at Layer 3/4 (EUR refused); audience part passes |
| F9 (negative) | any | Fee with no currency in the payload | Held with a reason | **Fail**: defaults to AUD in `svc_coursefacts_apply_record` |
| F10 (negative) | any | Annual derived from a registered total | Refused | Pass (no such path in the selector) |

F4, F7, F8 and F9 become passes with the one consolidated currency fix in section 2. No fixture needs a new table, column or country-specific object.

## 6. Footprint and limits

- **This review changes nothing in the platform:** no database, code, migration, cron or setting change, no spend (US$0, no Firecrawl, no containers), and no activation.
- **Not done here:**
  - The live checks for rows already written with the wrong currency (section 2).
  - The per-course classification of the 47 / 187 buckets, owned by S1-Data-Gaps.
  - Consumer display checks, owned by S1-API-Frontend-Delivery.
  - Both evening productive cycles, owned by S1-Build.
- **Blockers for this lane:**
  - GitHub API token invalid.
  - No Pilot push access.
  - No governed live read.
  - So this lane cannot open the PR for this branch, run the live read-backs or make the fix.
