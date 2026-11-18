# S3-Boost providers full CRICOS reconciliation

**18 November 2026 AEDT** · [Pilot #1312](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1312) · [Admin #574](https://github.com/msinghbs-ai/coursefinder-admin/pull/574) · [Full audit run](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/44282828858) · [Raw JSON artifact](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/44282828858/artifacts/14418325449)

## Scope and execution

The SHA-pinned Department of Education [CRICOS Institutions export](https://data.gov.au/data/dataset/cricos/resource/7f6941f3-5327-4db7-b556-5f16d77f63c1) dated 2 November 2026 contains 1,543 provider codes and has no active-status column. Every published source row was reconciled, including source rows without an active live match. There were 1,539 exact matches to both an active Australian provider and active CRICOS registration, two exact matches to ended/archived records and two source codes without an Australian exact match.

Pilot main and Admin main were checked for the reserved `s700`–`s709` block with no existing spec files found. The lane uses `s700` and zero migrations. The exact audit workflow used the Supabase Management API `read_only: true` with SELECT-only SQL. It made no staging, provider, alias, wizard-draft or run-metadata write (`p_write: false`), contacted the official export only, and made zero LLM or Firecrawl calls. The existing wizard dry-run endpoint persists metadata, so the live catalogue comparison used the separate read-only audit workflow.

The run checked all 75 live consumer function identities and definition checksums and all baseline columns on the 48 frozen relations. It found zero G3 drift. The live migration head was `20261118239000`. Publisher file SHA-256 was `d62824262a8184ebb16a9caa13d7dc5d438fbce348556febf6a37e2b9481a11f`.

## Telemetry

```json
{
  "source": "CRICOS_PROVIDERS_PILOT",
  "sample_size": 1543,
  "matched_exact": 1541,
  "alias_candidates_found": 2,
  "domain_mismatch_count": 21,
  "missing_url_count": 106,
  "bare_scheme_urls_normalised": 709,
  "execution_duration_ms": 5203,
  "llm_cost_usd": 0.00
}
```

Execution duration covers the hash check, parser, Management API read and deterministic comparison, excluding publisher download and workflow queue time. `matched_exact` counts code matches irrespective of catalogue status. `alias_candidates_found` counts distinct source codes with eligible literal aliases. `missing_url_count` counts blank catalogue websites on exact, unambiguous matches. The comparison lowercases hostnames and removes a leading `www.` or a trailing dot. It measures presence and domain differences without website fetches. A domain difference is an evidence-review item and does not establish which domain is current.

## Complete domain mismatch list

| CRICOS code | Provider | CRICOS website | Catalogue website |
| --- | --- | --- | --- |
| 00057E | Alexander Language School | https://anglischools.edu.au/international/ | https://www.sgis.wa.edu.au |
| 00244B | University of Southern Queensland | http://www.usq.edu.au/study/international | https://www.unisq.edu.au |
| 00899G | Whitecliffe, The Fashion Institute | www.icat.edu.au | https://thefashioninstitute.com.au |
| 01032F | The University of Notre Dame Australia | www.nd.edu.au | https://www.notredame.edu.au |
| 01718J | BPP Institute Pty Ltd | www.cic.vic.edu.au | https://www.bppinstitute.com |
| 02155J | Academy of Interactive Technology | www.ait.nsw.edu.au | https://ait.edu.au |
| 02406F | The Academy of Interactive Entertainment Ltd | https://aieinstitute.edu.au/ | https://www.aie.edu.au |
| 02506B | Australian National Institute of Business & Technology | http://www.anibt.vic.edu.au | https://www.anibt.edu.au |
| 02672K | Greenwich English College, Greenwich Management College | www.greenwichcollege.com.au | https://greenwichcollege.edu.au |
| 02975F | Astute Training Pty Ltd | www.astutetraining.com.au | https://www.astutetraining.edu.au |
| 03255G | Australian Professional Skills Institute | www.apsi.wa.edu.au | https://apsi.edu.au |
| 03262J | Discover English | http://www.discoverenglish.com.au | https://www.discoverenglish.vic.edu.au |
| 03504G | Sydney International Business College | http://sibc.nsw.edu.au | https://sibc.edu.au |
| 03529J | Mechanical Institute of Training and Technology Pty Ltd | www.mitt.vic.edu.au | https://mitt.edu.au |
| 03530E | The Cairnmillar Institute | http://www.cairnmillar.edu.au/ | https://www.cairnmillar.org.au |
| 03547G | Anglican Schools Commission International; ASC International; Esperance ACS; Frederick Irwin AS; Georgiana Molloy AS; John Septimus Roe ACS; John Wollston ACS; Peter Carnley ACS; Peter Moyes ACS; St George's AGS; St James AS; St Mark's ACS; Swan Valley AC | https://anglischools.edu.au/ | https://www.ascinternational.wa.edu.au |
| 03806D | AIM Institute of Health & Sciences | www.centralcollege.edu.au | https://aiminstitute.edu.au/ |
| 03822D | Charlton Brown | http://charltonbrown.com.au | https://charltonbrown.edu.au |
| 04025C | Evantaa Institute | www.evantaa.edu.au | https://www.nvc.edu.au |
| 04327M | ST MARTIN COLLEGE PTY LTD | www.stmartincollege.edu.ua | https://stmartincollege.edu.au/ |
| 04377A | Aroha College | www.arohacollege.com.au | https://www.arohacollege.edu.au |

## Complete alias candidate list

| CRICOS code | Matched field | Alias | Alias type | Candidate provider | Relationship |
| --- | --- | --- | --- | --- | --- |
| 00017B | legal | Bond University | qs_wur_publisher_name | Bond University Limited | Exact same provider |
| 00213J | legal | Queensland University of Technology (QUT) | qs_wur_publisher_name | Queensland University of Technology | Exact same provider |

## Additional exceptions

| Check | Result |
| --- | --- |
| Unmatched CRICOS codes | 03396F CHC Services Pty Ltd, 03721J Ti Education and Training Pty Ltd |
| Ended registration with archived provider | 03795B, 04372F |
| Duplicate exact codes | 0 |
| Alias-only or cross-provider candidates | 0 / 0 |
| Blank source websites | 612 |
| Invalid non-blank source website cells | 5 |
| Invalid catalogue websites | 0 |
| Blank source trading names | 325 |
| Source trading names with uncovered values | 11 |

Five invalid publisher cells contain multiple URLs in one field or an email address. All five values and the complete blank URL and trading-name exception lists are in the JSON artifact.

## Normaliser and register

The s700 normaliser supplies `https://` for a syntactically valid bare DNS hostname before the website is validated. Explicit HTTP(S) addresses retain their original scheme and path. Empty, malformed or multi-address cells remain unresolved. The same helper is used by the CRICOS legacy archive reader, adapter and replay, and the declarative wizard's mapping preview, dry run and apply path. Mapping and replay use the draft's existing `cricos` registration scheme. The full audit factors formatting changes out before comparing domains.

Pilot #1312 is awaiting its governed CI and release checks.

## Man-power and ROI

| Work | Full 2 November CRICOS edition |
| --- | --- |
| Manual baseline at 6 min/provider | 154.30 h |
| Automated engine | 5.203 s measured |
| Engineer review, modelled at 10 min per 25 providers | 10.29 h |
| Total automated plus review | 10.29 h |
| Net time saved, modelled | 144.01 h or 18.95 FTE days at 7.6 h/day |

The review allowance is an estimate. The comparison covers evidence triage, code and name checking, and URL presence. It excludes website ownership verification, reachability and remediation. Scaling the same assumptions to the earlier 3,091-provider catalogue baseline gives approximately 288.49 hours or 37.96 FTE days if equivalent registry inputs exist across countries. The observed run covered the 1,543 CRICOS rows.
