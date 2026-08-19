# CourseFinder Admin / PIM Design Decisions v1.6

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.5.md`

v1.6 retains the v1.5 Course geography and decision-workspace standard and adds a mandatory visible-row filter semantics rule after live Provider State/Region browser UAT.

## Visible-row filter semantics

A structured grid filter MUST filter against the semantic value visibly represented in the corresponding row/column.

Examples:
- Provider `State / Region = Victoria` means the Provider row's canonical/display State / Region must be Victoria.
- It must NOT implicitly mean `Provider has any related Campus in Victoria`.
- Course `Provider = X` means the Course's canonical Provider is X.
- Evidence `Source = X` means the displayed Evidence Source is X.

Broader relationship predicates remain useful but must be separately named and visibly distinct, for example:
- `Has campus in State / Region`;
- `Available at campus`;
- `Has related evidence type`;
- `Scholarship applies to course`.

A row whose displayed State / Region is South Australia, New South Wales, Tasmania or Queensland must never appear under a Provider grid filter visibly set to Victoria.

## Cross-entity filtering

Cross-entity predicates should be exposed through explicit cross-links, related-record drawers, or clearly named relationship filters. They must not overload a canonical/display-value filter.

## UAT requirement

Every structured filter must include adversarial UAT proving that:
1. all returned rows match the displayed selected value;
2. obvious non-matching values are absent;
3. the result count matches a direct canonical query;
4. related-entity predicates do not leak into the visible-value filter unless explicitly named.

## Automation / agent rule

Agents may suggest relationship filters or validation paths but must preserve the same semantic distinction. Automated UAT should include mismatch detection between active filter values and visible row values.