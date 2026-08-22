# CourseFinder Admin/PIM Design Decisions v1.12

**Status:** **CURRENT — DATA QUALITY v1.0 ACCEPTED**  
**Effective:** 22 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.11.md`  
**Change Control:** `CF-CHG-20260821-018`

All accepted v1.11 PIM, Pipeline and Evidence decisions remain in force. This revision adds the Data Quality decisions below.

## DD-DQ-01 — Domain readiness, not one equal-weight completeness score

CourseFinder does not expose one equal-weight cross-domain completeness percentage as authoritative truth. Identity, regulatory, geography/delivery, taxonomy, regulatory fee, Provider-current fee, Course URL, Intake, English, Scholarship, Evidence, freshness, Search admission and publication readiness remain separate decision domains.

## DD-DQ-02 — State vocabulary is semantic, not cosmetic

Every governed readiness metric distinguishes:

`present / source_null / not_applicable / zero / suppressed / not_yet_enriched / stale / ambiguous / rejected`

`present` and legitimate numeric `zero` are ready. `not_applicable` is excluded from the applicable denominator. Missing Layer 2 enrichment is not reclassified as source-null.

## DD-DQ-03 — Source authority and country applicability are preserved

AU CRICOS source absence, NZQA authority boundaries and later Provider enrichment are not collapsed. A source-null classification requires governed source evidence. No Campus, fee, URL, Intake, English requirement, Scholarship or Review item may be synthesised merely to improve readiness.

## DD-DQ-04 — Search admission and publication remain independent

Presence in `search.course_documents` proves governed Search projection only. It does not prove enrichment admission, canonical publication readiness or downstream channel publication.

## DD-DQ-05 — Operational drill-down is bounded and explicit

The supported browser path uses one aggregate `data_quality_overview` RPC and one server-paged `data_quality_exceptions` RPC. Entity, Evidence or Review detail is loaded only after an explicit operator action. The page must not issue per-row N+1 detail reads.

## DD-DQ-06 — Legacy Course score is labelled as legacy presence

The historical six-signal Course percentage may remain for backward-compatible catalogue/history use, but it is labelled `Legacy presence` / `Min legacy presence`. It must not be represented as governed Data Quality readiness.

## DD-DQ-07 — Evidence/private boundary is retained through readiness drill-down

Data Quality may expose a governed Evidence ID where authorised, but Evidence detail remains subject to the Evidence rank/private-storage boundary. Data Quality does not weaken Evidence ACLs or expose private Storage directly.

## Accepted release reference

- Pilot: `msinghbs-ai/Coursefinder-Pilot@72721c57d2a11a5fb79288c9eadf4e14602a2e14`
- Data Quality contract: `docs/coursefinder-data-quality-readiness-contract-v1.0.md`
- technical UAT: `docs/uat/coursefinder-m1-data-quality-readiness-technical-acceptance-2026-08-21.md`
- deployed browser UAT: `docs/uat/coursefinder-m1-data-quality-readiness-browser-evidence-2026-08-21.md`
- Admin Guide: `docs/coursefinder-pim-admin-guide-v1.13.md`
- Running Build: `docs/coursefinder-running-build-v2.62.md`

Database Architecture v2.10.38 remains current; these decisions govern a read/operational UX contract and do not change canonical identity, authority, evidence grain or core schema architecture.