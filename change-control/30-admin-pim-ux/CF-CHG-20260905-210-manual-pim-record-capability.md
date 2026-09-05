# CF-CHG-20260905-210 — Governed Manual PIM Record Capability

**Status:** DESIGN ACCEPTED / IMPLEMENTATION PARTIAL  
**Milestone:** M2.4.5  
**Workstream:** H5 — Manual record creation across PIM  
**Type:** PIM GOVERNANCE / ADMIN UX / DATA AUTHORITY  
**Initiated:** 5 September 2026  
**Primary owner:** 30-admin-pim-ux

## Objective

Define where an authorised PIM operator may create a record manually without weakening canonical identity, Evidence, Layer authority, Publication or Search boundaries.

The requirement for manual record creation does **not** mean every catalogue table receives a direct `INSERT` form.

## Governing rule

Manual entry has two different meanings:

1. **Managed record creation** — permitted where CourseFinder itself owns the operational/PIM identity and can preserve actor, source, reason, version and audit history.
2. **Source-backed canonical candidate registration** — required where an external authority or first-party Provider source owns identity. The operator may register the candidate and Evidence, but the candidate must pass the existing acquisition/reconciliation/review path before becoming canonical.

Direct manual canonical creation must never bypass source authority.

## Capability matrix

| Entity | Direct manual canonical create | Safe operator action | Minimum rank | Required governance |
|---|---|---|---:|---|
| Provider | **No** | Register source-backed Provider candidate / authority record | 5 | Country, authoritative source, stable/regulatory identifier, Evidence/reason; identity reconciliation before canonical creation |
| Course | **No** | Register source-backed Course candidate under a canonical Provider | 5 | Provider, authoritative source identifier/URL, Evidence/reason; Layer 1 identity rules before canonical creation |
| Campus | **No** | Register source-backed Campus candidate under a canonical Provider | 5 | Provider, authoritative location/source evidence; no synthetic campus identity |
| Scholarship | **No direct raw insert** | Register first-party Scholarship source candidate for acquisition/review | 5 | Canonical Provider where applicable, official source URL, Evidence/reason; no eligibility inference |
| Provider Contact | **Yes** | Create/update/deactivate/delete/restore managed contact | 5 | Provider link, source details, operator reason, version history and audit |
| Important Link | **Yes** | Register governed operational/authority link | 3 | Country/category/owner/purpose/source URL and verification state |
| Important Date | **Yes** | Register sourced operational/regulatory date | 3 | Source URL/wording, date precision, scope; vague dates remain vague |
| PIM taxonomy/configuration | Controlled configuration only | Use governed PIM configuration actions | 5+ | Rank gate, validation and change history; never use taxonomy editing to manufacture source facts |
| User / Role | Managed security record | Existing Users & Roles workflow | 6 | Platform Admin boundary and access audit |

## Existing implementation accepted

### Provider Contacts

The current managed Provider Contacts module already implements the desired direct-manual pattern for CourseFinder-owned PIM records:

- rank 5+ Add contact;
- Provider selection;
- official source URL/page title/source notes;
- change reason;
- create/update;
- version history;
- audit history;
- verify/activate/deactivate;
- soft delete and restore;
- CSV import/export under the same managed module.

This is the reference implementation for managed manual records.

### Important Links / Important Dates

The existing operations registry already permits governed manual registration with role checks. These are operational reference records, not substitutes for Provider/Course/Scholarship authority.

## Core catalogue decision

Do **not** add `Add Provider`, `Add Course`, `Add Campus` or raw `Add Scholarship` buttons that directly write canonical tables.

Instead, the future common operator pattern is:

`Add source-backed candidate → choose entity type → identify authoritative/first-party source → enter source identifier + URL → attach/retain Evidence → reason → validate → reconcile identity → Layer 4 only if ambiguous → canonical apply → publication remains separate`

The candidate must be replayable and auditable. Re-running acquisition must not duplicate canonical identity.

## Rank and audit requirements

For source-backed candidate registration:

- rank 5 (PIM Operator) or higher;
- actor ID and created timestamp retained;
- reason required;
- source URL required unless a governed source/file Evidence object is selected;
- external/source identifier required where the authority publishes one;
- target Provider required for Course/Campus/Provider-owned Scholarship candidates;
- Evidence or acquisition job lineage retained;
- no direct publication;
- no direct Search admission;
- ambiguous identity routes to review rather than operator-created duplicate identity.

## UX direction

The catalogue should eventually expose a consistent **Add source-backed candidate** action for Provider, Course, Campus and Scholarship to authorised PIM operators. It should open a compact governed form, not a generic database editor.

The action should state clearly that the record is a candidate until source validation/reconciliation succeeds.

## Implementation state

- Provider Contacts managed manual creation: **implemented**.
- Important Links / Important Dates managed registration: **implemented**.
- Core Provider/Course/Campus/Scholarship direct manual canonical creation: **intentionally prohibited**.
- Common source-backed candidate registration workflow: **implementation next** under CF-210; must reuse acquisition/Evidence/Layer 4 primitives rather than create a parallel canonical writer.

## Safety

This decision preserves the authoritative PIM principle that names/titles do not become identity, external stable identifiers remain authority, Layer 2/3 cannot redefine Layer 1 identity, Evidence remains separate, and Publication/Search remain separate decisions.

## Gate

H5 is not yet closed. The capability model is accepted; implementation is complete for managed records but the common source-backed candidate registration action for core catalogue entities remains the next H5 deliverable.
