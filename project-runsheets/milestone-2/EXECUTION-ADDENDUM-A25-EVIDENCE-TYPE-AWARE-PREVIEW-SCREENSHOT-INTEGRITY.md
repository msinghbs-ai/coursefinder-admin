# Execution Addendum A25 — Evidence Type-aware Preview & Screenshot Lineage Integrity

**Status:** ACTIVE — M2.4.4 ADDENDUM  
**Effective:** 31 August 2026  
**Change Control:** `CF-CHG-20260830-048`

## Purpose

Restore Evidence as a type-aware governed workspace. A screenshot is a specific Evidence artifact or an exact secondary visual captured from the same acquisition attempt; it must never become a generic thumbnail for unrelated JSON/HTML/API/regulatory evidence.

## A25.1 — Evidence format is explicit

Evidence list/detail must visibly identify the actual artifact format:
- JSON / API payload;
- HTML/source snapshot;
- screenshot/image;
- PDF;
- CSV/XLSX/workbook;
- ZIP/archive;
- text/other.

Evidence type and MIME remain distinct fields and both remain filterable.

## A25.2 — Screenshot relationship integrity

A related screenshot may render only when:
1. the current artifact is an HTML/source artifact; and
2. the screenshot is linked to the exact same Layer 2 acquisition attempt through non-null Evidence IDs.

Prohibited:
- empty-string/null matching;
- Provider-only/source-only screenshot inheritance;
- attaching a screenshot to JSON/API/regulatory/workbook/PDF evidence merely because it shares a Provider/source;
- reusing one screenshot thumbnail across unrelated Providers.

## A25.3 — Type-aware preview

- JSON/text: bounded inline text/structured preview from the selected artifact's own private object.
- Screenshot/image: preview the selected image itself.
- HTML: retain source metadata and optionally show an exact same-attempt screenshot as secondary visual Evidence.
- PDF: signed preview/open action.
- CSV/XLSX/ZIP and other non-browser-safe types: format card + governed download/open controls; do not substitute a screenshot.

Raw private Storage paths remain hidden. Signed preview/download access remains short-lived and role-gated.

## A25.4 — Evidence authority

A screenshot is visual corroboration only. It does not replace the HTML/JSON/source artifact for extraction, lineage, content hash, canonical consequences or audit.

## A25.5 — Acceptance

A25 requires:
1. JSON evidence remains present and filterable in runtime/UI;
2. JSON detail does not render a website screenshot;
3. exact HTML attempt may render its exact related screenshot;
4. different Providers cannot receive the same unrelated screenshot through null/empty matching;
5. selected screenshot evidence previews its own image;
6. format badge/label is visible in list and detail;
7. permanent deployed UAT covers JSON, HTML+related screenshot and screenshot/image cases.
