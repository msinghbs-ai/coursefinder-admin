# CF-CHG-20260902-064 — Statistics, Rankings, Comparison & Manual Publisher Import UX

**Status:** DESIGN ACCEPTED / UI IMPLEMENTATION ACTIVE  
**Initiated:** 2026-09-02 Australia/Melbourne  
**Primary category:** 30 — Admin/PIM UX  
**Related:** CF-061, CF-063, A12, A29, Layer 1, Evidence, Administration

## Request

Consolidate statistical/contextual datasets into one verification workspace, make comparison a first-class navigation journey, support year/dataset selection, expose concise Provider/Course blade summaries, and provide a governed manual file path for historical ranking editions when publisher access prevents automated retrieval.

## Decision

Create a primary **Statistics & Rankings** workspace that acts as the human verification/read surface for:
- QILT outcomes;
- PRISMS student-flow observations;
- QS World University Rankings;
- Times Higher Education World University Rankings;
- future country-equivalent statistical/ranking sources admitted under their own source gates.

Create a separate primary **Compare** page. Comparison begins with Provider/Course selection, then dataset selection, then aligned year/period selection.

## Manual publisher file import

Reuse the existing private `evidence` Storage bucket and Evidence lineage model. Do not create a separate document store.

Permitted publisher artifact types are governed by the bucket/profile and may include CSV, XLSX, PDF, JSON or ZIP. The import form requires:
- ranking system;
- edition year;
- publisher;
- source/landing URL;
- access/licence note;
- file;
- optional methodology URL/revision note.

Upload alone does not publish ranking rows. State machine:

`uploaded → validated → parsed → reconciled → applied` or `rejected / needs_review`.

Retain uploader, time, hash, original filename, MIME, size, source URL, licence/access note and Evidence ID. Duplicate hash+edition is rejected/idempotent.

## Navigation

Primary sidebar:
1. Overview
2. Catalogue
3. Statistics & Insights
   - Statistics & Rankings
   - Compare
4. Data Operations
5. Quality & Review
6. Administration

QILT/PRISMS remain accessible as dataset drill-downs from Statistics & Rankings rather than separate competing top-level concepts.

## Detail blades

Provider:
- compact latest QILT/PRISMS/ranking summary;
- clear Provider grain;
- deep-link to Statistics & Rankings;
- Add to Compare.

Course:
- Course-specific QILT only where valid;
- Provider-context PRISMS/rankings explicitly labelled inherited/provider context;
- Add to Compare.

## Comparison

Comparison page supports:
- up to six Providers/Courses;
- dataset toggles;
- year/period selector per dataset or aligned common period;
- explicit unavailable/suppressed/not-mapped states;
- source/methodology link;
- QS and THE remain separate systems;
- no mixed-methodology synthetic score.

## Runtime boundary

This Change Control does not authorise Search/Website/Zoho publication or ranking-based relevance changes.