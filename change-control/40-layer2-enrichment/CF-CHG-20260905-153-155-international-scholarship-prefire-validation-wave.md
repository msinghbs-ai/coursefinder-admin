# CF-CHG-20260905-153–155 — International Scholarship Pre-fire Gate & Validation Wave

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5  
**Related:** CF-151 international-only Scholarship Selection; CF-147/148 Evidence-reuse and candidate dedupe

## Trigger

The CourseFinder Scholarship catalogue is intended for international students. A valid first-party Scholarship page is not sufficient reason to consume acquisition capacity when catalogue evidence already indicates an Australian/domestic-only award.

## CF-153 — International-only pre-fire gate

The Monash detail-ready inventory was reviewed before further firing.

Clearly Australian/domestic catalogue cues are retained but moved from automatic `detail_ready` execution to `needs_review`, including strong cues such as:

- Indigenous Australian / Aboriginal / Torres Strait Islander / ATSI;
- Australian First Nations;
- Australian Government domestic-specific schemes;
- explicit domestic-student wording;
- selected local/rural/state-specific cues where no international cue exists.

The rule is deliberately conservative:

- nothing is deleted;
- ambiguous records remain reviewable;
- an explicit international/ASEAN/overseas/named-foreign-nationality cue is not demoted by this rule;
- first-party detail verification is still required before canonical international admission.

Runtime effect on the current Monash queue:

- automatic `detail_ready`: **252 → 222**;
- `needs_review`: **99** current rows after the gate;
- already acquired records remain unchanged.

## CF-154 — bounded first-party validation

Three Monash catalogue candidates had explicit overseas/international cues:

1. Indonesian Women Impact Scholarship;
2. John Bush Memorial Top-Up Scholarship — Thai-born graduate research cue;
3. Monash University Indonesia Scholarship.

The third item was intentionally excluded from the Australian international-student validation wave because its identity indicates the Monash Indonesia program/campus context rather than an Australian international-student award.

Only the first two first-party detail URLs were onboarded as Scholarship detail profiles. Existing Monash governed acquisition routes were inherited; no bypass or separate scraper stack was introduced.

Layer 2 requests:

- request `4916` — Indonesian Women Impact Scholarship;
- request `4917` — John Bush Memorial Top-Up Scholarship.

Both completed `resolved_l2` with retained Evidence.

## CF-155 — canonical reconciliation

First-party detail extraction established `audience=international` for both records.

### Indonesian Women Impact Scholarship

- canonical name is taken from the verified catalogue identity plus exact first-party detail URL because the generic page-heading parser returned HTML/title noise;
- Evidence retained: `1489b0db-ff36-4ca4-8085-0884e02d092a`;
- value: **AUD 37,145**;
- lifecycle: **active**;
- publication: **unpublished**.

### John Bush Memorial Top-Up Scholarship

- Evidence retained: `5d94b32f-d127-467d-99af-62d68ec94433`;
- value: **AUD 10,000**;
- catalogue evidence says it is not currently offered, therefore lifecycle is **inactive**;
- publication: **unpublished**.

The inactive record is retained for history/Evidence but is excluded by the active-only Scholarship Selector contract.

## Safety / authority boundary

- audience is first-party verified before international canonicalisation;
- no domestic Scholarship is automatically converted to international;
- no Course eligibility is manufactured from Provider ownership;
- no Scholarship is automatically published;
- Search, Website and Zoho projections are unchanged;
- Evidence and acquisition trace are retained end-to-end.

## Source reconciliation

Pilot migrations:

- `20260905084500_cf_153_international_scholarship_prefire_classifier.sql`;
- `20260905085000_cf_154_monash_international_validation_detail_profiles.sql`;
- `20260905085500_cf_155_monash_international_validation_canonical_reconciliation.sql`.

## Next boundary

Continue converting the broad Monash catalogue into an **international-qualified** queue rather than treating all valid Scholarship detail URLs as executable. Named overseas nationality/region and explicit international-student wording may enter bounded first-party detail verification. Domestic/equity/local cues remain review-only unless first-party Evidence proves international eligibility.
