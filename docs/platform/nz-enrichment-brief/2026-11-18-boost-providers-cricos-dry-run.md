# BOOST Providers CRICOS dry-run reconciliation

**18 November 2026 AEDT** · [Admin tracking PR #574](https://github.com/msinghbs-ai/coursefinder-admin/pull/574)

## Pre-flight

| Check | Evidence |
|---|---|
| Specification collision | Both GitHub `main` refs were checked. Top-level `specs/` was absent in both repos. Pilot specs use `tests/uat`, and Admin mirrors the test register at `docs/platform/TEST-REGISTER.md`. `s597` and `s598` are already claimed. Pilot #1243 originally added the wizard as `s599`, #1245 moved it to `s612` and reserved `s599` for BOOST, and #1244 used `s600` for the BOOST benchmark. This run exercised existing `s612` and consumed no spec ID. |
| Migration monotonicity | Production migration history returned `20261118233000` as its head at pre-flight. Open Pilot PR file lists show `20261118234000` (#1307), `20261118237000` (#1308), and `20261118238000` and `20261118239000` (#1310). Pilot #1235 is an older squash rehearsal. Admin returned no open PRs in the scoped search. No migration was needed. |
| Production and spend | Production queries were SELECT-only. Wizard runtime and dependencies were isolated from production. Zero production writes and US$0.00 external LLM spend. |

References · [Wizard rename](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1245) · [BOOST benchmark rename](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1244) · [Admin test register](https://github.com/msinghbs-ai/coursefinder-admin/blob/main/docs/platform/TEST-REGISTER.md)

## Source and live reconciliation

The single source was the Department of Education’s [CRICOS Institutions export](https://data.gov.au/data/dataset/cricos/resource/7f6941f3-5327-4db7-b556-5f16d77f63c1) dated 2 November 2026. The first 25 published provider rows in ascending CRICOS-code order ran from `00001K` to `00099F`. The export has no provider-status column. Inclusion came from the export, and the reconciliation independently confirmed an active catalogue provider and active registration for every sampled code. This ordering is reproducible and favours older registration codes.

Each source code was matched exactly through `catalogue.provider_registrations` (`registration_scheme = 'cricos'`) to `catalogue.providers`. The comparison checked current Australian `catalogue.provider_aliases` against the CRICOS code, legal name and trading names. Trading-name coverage used case-insensitive, whitespace-normalised exact matches to catalogue names or current aliases for the exact provider. Comma- and semicolon-delimited trading names in this sample were also compared individually.

| Result | Count or detail |
|---|---|
| Exact active matches | 25 of 25. Zero duplicate exact codes. |
| Rows with alias candidates | 1. `00017B` matched the legal-name alias `Bond University` for the same provider. Zero code-as-alias, alias-only or cross-provider candidates. |
| Missing websites | 0 catalogue URLs and 0 source website values. This was a presence check. |
| Trading-name differences | 0 uncovered trading names across the 22 rows with a source trading name. The three source blanks were `00001K`, `00011G` and `00094M`. |
| Website host difference | `00057E`, Alexander Language School. The source lists `https://anglischools.edu.au/international/` and the catalogue lists `https://www.sgis.wa.edu.au`. The check compared hostnames after removing a leading `www.` and did not assess site ownership or reachability. |
| Production mutations | 0 |

## Telemetry

```json
{
  "source": "CRICOS_PROVIDERS_PILOT",
  "sample_size": 25,
  "matched_exact": 25,
  "alias_candidates_found": 1,
  "missing_url_count": 0,
  "execution_duration_ms": 1160,
  "llm_cost_usd": 0.00
}
```

The reconciliation request took 1,160 ms end to end, with 83.843 ms measured by PostgreSQL. Source acquisition time and the separate fixture run are outside that telemetry duration.

## Wizard verification

The existing Step 5 **Run dry run** callback and runner `1.1.0` executed against a four-column CSV fixture reconstructed from those same 25 official rows. The auth, settings, source download and database RPCs used isolated fixtures. The runner parsed 25 records in 98.081 ms with zero duplicate keys, called staging with `p_write: false`, and made no call to apply or activate. Both assertion groups from existing `s612` passed against the current wizard source. No spec or unit test was added, so the test register did not require regeneration.

The URL parser flagged 16 raw values without `http://` or `https://` and mapped those optional fields to null while the preview still passed. That parser result is separate from the catalogue URL presence count. The live CRICOS source has no wizard induction draft. The production preview route persists the run start, run completion and draft result, despite its success message saying nothing was written. No production preview was invoked. The dry-run recorder calls were observed only in the isolated runtime.

References · [Existing s612 contract](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/tests/uat/cf-247-s612-wizard-dry-run-runner-contract.spec.mjs) · [Wizard](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/src/Layer1InductionWizard.jsx) · [Runner](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/supabase/functions/layer1-declarative-runner/index.ts)

## Draft comment for Admin #574

BOOST Providers completed a read-only check of 25 CRICOS Institutions records. All 25 matched active Australian registrations and providers. One name alias pointed to the exact provider. There were zero missing catalogue URLs and zero uncovered trading names where CRICOS supplied one.

Existing wizard spec `s612` (formerly `s599`) passed in isolation with 25 records and `p_write: false`. The fixture warned on 16 source website values written without a scheme. Production writes and external LLM spend were zero. No new spec ID was used.
```json
{
  "source": "CRICOS_PROVIDERS_PILOT",
  "sample_size": 25,
  "matched_exact": 25,
  "alias_candidates_found": 1,
  "missing_url_count": 0,
  "execution_duration_ms": 1160,
  "llm_cost_usd": 0.00
}

```

## Man-power and ROI calculation

| Measure | 25-provider pilot | 3,091 active providers |
|---|---:|---:|
| Manual analyst baseline at 6 min/provider | 2.50 h | 309.10 h or 40.67 FTE days |
| Automated dry run | 1.26 s measured runtime plus 10 min estimated engineer review | 20.65 h modelled |
| Net hours saved | 2.33 h modelled | 288.45 h or 37.95 FTE days modelled |

Projection applies the pilot compute time and 10 minutes of engineer review per 25 providers, with 7.6 hours per FTE day. The automated check measures registry reconciliation and URL presence. The extrapolation assumes equivalent registry inputs for the other countries and excludes any separate website reachability, ownership or exception-remediation work. No analyst time or catalogue-wide saving was measured.
