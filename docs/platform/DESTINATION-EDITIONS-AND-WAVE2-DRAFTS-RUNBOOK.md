# Operator runbook: destination data editions and Wave 2 register drafts

**Version:** 1.2, 18 Nov 2026 (chat S1-RM-Design; asked by the Platform Admin 18 Nov 2026 07:39 AEDT).
**For:** the Platform Admin and Curators. **Screens:** Destination data, Layer 1 Register, Reference data.
**Status of the screens named:** live on Pilot at v2.16.32 (18 Nov 2026 10:24 AEDT). Not yet checked in a signed-in session.

Where a step says *Platform Admin*, the button is greyed for other roles and the server refuses the call as well. Every approval, publication and activation asks for a reason, which is kept with the decision.

## 1. Destination data: from a load to a published edition

| Step | Where | Who | What happens |
|---|---|---|---|
| 1. Load the edition | Platform health › Data delivery › Destination loads › Run now | The role shown on the job | The loader creates the edition (draft), its localities (draft), postcodes and figures (draft). Nothing is returned by the API yet. |
| 2. Settle postcodes | Destination data › Localities & postcodes, lower table; or Layer 4 Review › Inbox › Campus locality | Curator and above | A postcode that sits in more than one locality below the share is waiting for a person. Accept, choose a locality, or record none. One decision settles the postcode for every campus. |
| 3. Approve localities | Destination data › Localities & postcodes | Platform Admin | **Approve** on one row, or **Bulk Approve Drafts** for a whole dataset edition: every draft with a name and attribution text is approved with one reason; a draft without attribution text stays draft and is counted. |
| 4. Approve figures | Destination data › City metrics & costs | Platform Admin | **Approve** on one row, or **Bulk Approve Drafts** (v2.16.32) for a whole dataset edition: every draft figure with attribution text is approved with one reason; the rest stay draft and are counted. A figure is returned by the API once its locality is approved too. |
| 5. Record the terms | Destination data › Overview & editions › Record terms | Platform Admin | Sets the edition's terms of use: approved, pending or restricted. |
| 6. Publish the edition | Destination data › Overview & editions › Publish edition | Platform Admin | The edition becomes the published one for its country and domain; the earlier published edition is marked superseded. |

**What the server requires at step 6:** the edition is draft or in review, its terms are approved, and it holds at least one row. It does **not** require every locality or figure to be approved: rows that are not approved or published are simply never returned. The Publish dialog says how many rows are approved before you confirm.

**What the API returns:** the API v3 `destination` action, and `campuses[].locality` on the v3 `provider` action, return only approved or published rows.

**Undo:** Withdraw on a locality, figure, rule or outcome stops it being returned. A published edition is fixed; a change is a new edition.

**State on 18 Nov 2026 07:50 AEDT (read only):** one edition, Australia, city profiles, "ABS Regional population 2024-25", draft, terms approved; 102 localities and 102 figures, all draft, none without attribution text.

## 2. Wave 2 register drafts: from a draft to a paused source

Nine drafts were pre-staged on 17 Nov 2026 (Pilot #1228). A draft is not a source: nothing reads the web and nothing is scheduled until it is activated.

| Step | Where | Who | What to do |
|---|---|---|---|
| 1. Open the draft | Layer 1 Register › + Add source › Continue a draft | Curator and above | Choose the draft. The six steps show which are finished. |
| 2. Country & scheme | Step 1 | Curator and above | Check the target record type and the registration scheme. A scheme must be registered before this step can finish. All nine drafts have one since 18 Nov 2026 (S2-Build, Pilot #1240, registered `uk_hesa`, `uk_ukvi`, `ie_ilep` and `us_ipeds_completions`). |
| 3. Source & licence | Step 2 | Curator and above | Check the address and the connector. Upload a sample file. Record the licence name and set the terms once a person has confirmed them (REQ-68); the drafts are seeded as pending. |
| 4. Field mapping | Step 3 | Curator and above | AI Auto-Map proposes the mapping and the parser from the sample; correct it by hand. Mappings seeded as "expected name" must be checked against the sample. |
| 5. Cadence & retention | Step 4 | Curator and above | Cadence and Staging kept (days). The drafts carry 90 days. |
| 6. Dry-run preview | Step 5 | Curator and above | Shows "waiting for a reader" until a reader exists for the source. |
| 7. Activate | Step 6 | Platform Admin | Saves the source **paused** and writes the keep period to the per-source retention table. Running it is a separate decision on Layer 1 Register. |

**Before activating any of the drafts:**

- **Duplicates:** the older catalogue rows for the OfS Register, Discover Uni, the Irish Register of Qualifications and the UKVI sponsor register were retired on 18 Nov 2026 (S2-Build, Pilot #1240; checked live), and adding a source now checks for a duplicate by address and name.
- **ILEP:** kept and marked as a deprecating source. Move it to the TrustEd Ireland list of eligible programmes when that replaces the ILEP (expected about the end of 2026).
- **IRCC Designated Learning Institutions** is not a draft: it is already a live Layer 1 source.

## 3. Routing rule: where a source or dataset belongs

Decision of the Platform Admin, 18 Nov 2026 07:03.

| Kind | Belongs in | Examples |
|---|---|---|
| A source read on a schedule (ETL): provider, course or study-rules registers | Layer 1 Register | OfS Register, IPEDS, PGWP fields of study |
| A reference address or dataset that is not read on a schedule | Reference data | Grade scale conversions, the API field dictionary, key dates, reference sites |
| Locality and postcode tables | Destination data › Localities & postcodes | ABS localities and postcode shares |

## 4. API v3 fields: where to look them up

| Question | Where |
|---|---|
| Which fields does an API v3 action return, from which table and column, for which request? | Reference data › API field dictionary (search a field, endpoint, source column or request number). 2,085 fields on 17 Nov 2026. |
| What does a field mean and what is its status? | `docs/integrations/api-v3/API-V3-FIELD-DEFINITION.md` |
| Which course values are held today? | Catalogue › Courses: show Study load and Empty reason from Columns, or filter by them (v2.16.29). |
| Which campus is primary, and its locality? | Catalogue › Providers › Campuses: Primary and Locality columns (v2.16.29). |

**Handover (RM0B):** both v3 APIs are still in development, so the dictionary and handover documents are not issued to the developers yet. They are issued once, at v3 release.

**Study load (updated 18 Nov 2026 10:20 AEDT):** `API-V3-FIELD-DEFINITION.md` now records that 3,772 courses hold a study load, read from provider pages and growing through Boost. It is **not yet returned** by the v3 `course` or `search` actions: no v3 course function carries it and the field dictionary lists `study_load` on the scholarship actions only. Exposing it on the course actions is open work before the handover.
