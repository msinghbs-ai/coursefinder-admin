# CF-CHG-20260905-151 — International Scholarship Selector: Course & University Search

**Status:** IMPLEMENTED / RUNTIME PASS — BUILD/UAT ACTIVE  
**Milestone:** M2.4.5  
**Date:** 5 September 2026

## Requirement

Scholarship Selection is an international-student decision-support surface. Operators must be able to test coverage using recognisable Course or University names rather than internal Course UUIDs, including for external landscape/completeness reconciliation.

## Corrective changes

### International-only hard boundary

The governed selector now requires:

`lower(coalesce(scholarship.audience,'')) = 'international'`

This is enforced in the server-side Course and University selector implementations rather than relying on the current data population to happen to contain international rows only.

### University mode

A new University/provider selector returns the Provider's active international Scholarship inventory and a visible candidate count. This supports quick coverage reconciliation by institution. External catalogues may be used privately to understand the landscape/missing inventory, but they do not become CourseFinder authority; first-party Provider Evidence remains the verification authority.

### Course mode

The operator can search by Course title, Course/CRICOS code or University name and select a canonical Course from the governed catalogue result. Raw UUID entry is no longer required.

Course candidate semantics are tightened:

- explicit Course/Provider/study-level/field/country include scopes remain eligible structural matches;
- an unscoped Scholarship can appear for a Course only when it is owned by that Course's canonical Provider;
- Provider-neutral/unscoped rows are excluded from Course mode until a governed explicit scope exists;
- exclusion scopes remain terminal for structural selection;
- exact student eligibility is never inferred by this surface.

This closes a prior cross-Provider noise path where unscoped Scholarships from unrelated institutions could appear with a low unresolved score.

## UI

`Scholarship Selection` now provides two searchable tabs:

1. **University** — search Provider/university name and show the international Scholarship inventory count;
2. **Course** — search Course title, Course/CRICOS code or University name and show structurally relevant international candidates.

The UI displays **International students only** prominently and preserves each candidate's source URL, Evidence/reference state, award value, scope state and unresolved eligibility warning.

## Security

- Selector UI remains available from rank 3 and above.
- Browser-facing selector bridges enforce `security.current_role_rank() >= 3` for authenticated callers.
- implementation functions remain unavailable to `anon` and `authenticated` and remain service-role-only;
- public selector wrappers are unavailable to `anon`;
- no raw/private Scholarship tables are exposed to browser clients.

## Runtime validation

Targeted RMIT validation:

- University: `RMIT University (RMIT)` → **8** active international Scholarship records;
- Course: `Advanced Diploma of Accounting` → **8** international structural candidates after Provider-neutral/unscoped noise was removed;
- all returned candidate `audience` values are `international`;
- unrelated provider-neutral unscoped Scholarships are no longer returned in Course mode.

The counts are operational coverage signals, not claims of complete first-party inventory and not proof of individual eligibility.

## Publication boundary

This change does not publish any Scholarship, change Course eligibility, mutate Search documents or admit data to Website/Zoho consumers. It is read-only decision support over governed canonical/Evidence records.

## Source reconciliation

Pilot migration:

`supabase/migrations/20260905061000_cf_151_international_scholarship_selector_course_provider_modes.sql`

UI:

- `src/scholarship-selection-entry.jsx`
- `src/scholarship-selection.css`
- release currentness `v2.15.61`
