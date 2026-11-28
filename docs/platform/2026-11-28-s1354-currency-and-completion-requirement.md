# s1354: no provider-default currency on unknown or contradictory evidence; a completion requirement is not an entry row

**Direction:** SS-Programme-Control PC-20261128-1729-DELIVERY-VERIFY (28 Nov 2026 17:29 AEDT): S1-Build continues the consolidated country and currency defect and "do[es] not substitute provider-default currency for contradictory or unknown evidence"; the P0 completion-requirement finding gets "a reusable negative fixture to existing reader/prompt and verifier, no separate PR unless genuine release need". This is one worker release: the currency defect is the release need, and the negative fixture goes with it.
**Pilot change:** worker `coverage-sweep-worker-v1.0.64`, code and tests only (`extract.ts`, `adapters.ts`, `scholarship.ts`, `course-entry.ts`, `index.ts`). There is no migration, setting, job, cron row or spend. The prompt `course-entry-v1` is unchanged, so no prompt registry version is needed (s553). Spec: `tests/uat/cf-247-s1354-currency-unknown-and-completion-requirement-contract.spec.mjs`.

## 1. Currency

| Before | After |
|---|---|
| `currencyFor(country)` gave AUD for every country except NZ and CA, and for a missing country | AUD, NZD and CAD for AU, NZ and CA only; any other country or none gives no currency, and `fee()` reads no amount (`currency_unknown`) |
| The adapter fee path stamped `currencyFor(country)` on a page-data fee | The page-data fee needs a known currency; otherwise the ordinary reader applies and refuses |
| Three scholarship reads used `it.currency \|\| "AUD"` | `it.currency \|\| null`: with no currency, no amount is read as a value (`currency_unknown`) |
| A bare "$" was the provider's home currency whatever that was | A bare "$" is the home currency only for a dollar currency; a GBP or EUR provider's "$5,000" is foreign (contradictory) and not a value |

**Live effect today: none.**
- Every provider has a country (0 without one; three countries: AU, NZ and CA).
- Every live lease carries its provider's country: `svc_coverage_read_next`, `svc_coverage_site_next`, `svc_provider_website_check_next` and `svc_scholarship_ai_next` through `security.coverage_country`, and `svc_fc_run_next` through the item column. All 34,836 Firecrawl run items hold AU, NZ or CA.
- Scholarship leases carry `scholarship.provider_currency` (the country's `default_currency_code`).
- `coverage-reidentify` (98) and `coverage-reextract` (57) are switched off.

**GB and IE fixtures (compatibility only, no provider is read):** a GB, IE, missing or unknown country gives no fee. A "$" scholarship amount is not a value for an unknown, GBP or EUR currency. Percentages need no currency and read as before. AU, NZ and CA fixtures are unchanged.

**Residual, unchanged:** the read-only `scholarship_inspect` mode still reads values as AUD; it writes nothing. The country defaults `it.country || "AU"` in the site and website checks fire only for a provider with no country, and there are none.

## 2. Completion requirement (P0, Murdoch 030196A)

The row `d4222382-551e-4a44-b5c0-46a53f8f2ac9` is `portfolio_interview`, active, read by AI item 477470 (worker v1.0.63) and admitted at 17:18 by `aer-machine-v1`. Website v3 serves it as a selection task. Its quote: "All students will undertake at least 450 hours of approved work experience, plus complete a report outlining the experience gained, in order to comple[te the requirements of the degree]". That is a condition of finishing the degree, not of entry. The course is unpublished.

- **Verifier (every answer from now on).** `entryCompletionRequirement`: a row whose quote states that it is needed to complete or graduate from the course, or is done during or as part of it, and names no entry word (entry, admission, applicants, apply, selection, eligible, before starting or enrolling) is dropped as `completion_requirement`. The reason is not in `entry.gate_hold_reasons` (`score_without_basis`, `quote_not_on_page`, `low_confidence`, `det_other_requirement`), so it does not hold the read as incomplete, and the drop stays on the read with its quote.
- **Fixtures.**
  - Dropped: the Murdoch sentence, "80 days of professional placement as part of the degree", "a 12-week industry placement to graduate".
  - Kept: "Applicants must have at least two years of relevant work experience", "A folio is required as part of your application", an interview that "forms part of the course selection process", "before you start your first placement", IB 27, selection rank 80, AQF 7.
- **The admitted row: exact governed route, a person's action.** Entry requirements › Course entry requirements (`#entry-requirements?tab=course`) › the Murdoch 030196A row with kind "Portfolio or interview" › drawer › **Withdraw**, with a reason such as "completion requirement, not an entry requirement (s1354, PC-20261128-1729)". This needs Curator (rank 3) or above. The row becomes inactive and stops reaching the website; the quote, evidence 93ab4e73 and its history stay. Reclassification is not needed, because it is not an entry requirement of any kind. Withdrawing the whole machine admission (`admin_aer_machine_withdraw_v1`) would return all six rows to Layer 4, so it is not used.
- **The other five rows** (IB 27 international; AQF 7 or one year of tertiary study; French Baccalaureate 12; GCE A Levels 7; selection rank 80 domestic) state entry conditions. S2-AER validates them individually against the source. Until it does, they are not counted as accepted delivery.

## 3. Verification

- Locally: the new spec, the worker-version pins, the scholarship, AER reader-quality and prompt-file specs, and every spec that reads the worker: 1,522 passed. After the three pinned assertions were updated: 32 passed. Governance specs s120, s32 and s57 passed. `node scripts/ui-map.mjs --check` matches. Migration pre-flight: no new migrations.
- After deploy, the S1-Build M3 document records the deployed worker line and the next entry read's drop reasons.

## 4. Cron reconciliation (asked at 17:29)

The active band moves between 136 and 137, always within 140. The job that moves is `boost-extract` (job 439, catalogued, owned by its lane): 400 runs in the last 10 hours with one 21-minute gap. No job was created or first run within 8 hours, and no switched-off job ran in that time. The newest job is 518 `fid-det-sweep`, which has run since earlier today.
