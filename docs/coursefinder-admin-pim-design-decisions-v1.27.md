# CourseFinder Admin/PIM Design Decisions v1.27

**Status:** CURRENT M2 DESIGN DECISIONS  
**Date:** 2 September 2026  
**Supersedes:** v1.26  
**Change Control:** CF-CHG-20260902-063, CF-CHG-20260902-064

## Decisions 38–43

Decisions 38–43 from v1.25 remain authoritative and unchanged.

## Decision 44 — QS/THE are Provider context, not Course quality

QS and Times Higher Education World University Rankings attach at institution/Provider grain. A Course blade may show inherited Provider ranking only when labelled explicitly as Provider context.

## Decision 45 — Ranking systems remain independent

QS and THE ranks/scores must be displayed separately. Do not calculate a combined “world rank” or directly compare a QS ordinal with a THE ordinal as though they shared one methodology.

## Decision 46 — Historical ranking is editioned and methodology-aware

The Admin may display up to 5–10 years of history, but methodology/revision boundaries must remain visible. Banded ranks stay banded; missing/unranked is not zero.

## Decision 47 — Ranking provenance is one-click context

Latest rank cards and comparison rows must expose edition, publisher source and methodology/provenance with minimum navigation. Ambiguous Provider matches show unresolved rather than guessing.

## Decision 48 — Ranking filters/sorts require explicit consumer semantics

A ranking filter or sort is permitted only after consumer admission and must state ranking system + edition. Ranking is never an undisclosed Search relevance boost.


## Decision 49 — Statistics & Rankings is the verification hub

QILT, PRISMS, QS, THE and future admitted statistical datasets are organised through one Statistics & Rankings workspace for coverage, period availability, observation review, mapping and Evidence verification.

## Decision 50 — Compare is a first-class workflow

Compare is exposed directly in primary navigation. Entity selection is followed by dataset selection and period/edition selection. Users are not forced to accept every available metric or the latest year.

## Decision 51 — Manual historical publisher files reuse governed Evidence

When automated acquisition is blocked by publisher access controls, an authorised publisher artifact may be uploaded through a privileged Sources & Imports flow into the existing private Evidence store. Upload, parse, reconcile and apply are separate states.

## Decision 52 — Detail blades summarise and deep-link

Provider/Course blades show concise contextual statistics and ranking summaries with View Statistics and Add to Compare actions. They do not duplicate the full statistics workspace.

## Decision 53 — Navigation separates insights from operations

Primary groups become Overview, Catalogue, Statistics & Insights, Data Operations, Quality & Review and Administration. QILT/PRISMS detailed pages remain available as dataset drill-downs rather than competing top-level concepts.
