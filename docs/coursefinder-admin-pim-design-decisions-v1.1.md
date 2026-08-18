# CourseFinder Admin / PIM Design Decisions v1.1

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 18 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.0.md`  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.10.26.md`  
**Programme baseline:** `docs/coursefinder-master-project-plan-v1.26.md`

v1.1 retains all decisions from v1.0 and adds the following mandatory filter interaction standard.

## Typed combobox filter standard

Reference-data and bounded-enum filters should be implemented as **searchable comboboxes**, not plain text boxes and not dropdown-only controls.

The user must be able to:
- type part of a code or name;
- see matching valid values in a dropdown;
- select a valid value with mouse or keyboard;
- clear the selected value quickly;
- continue typing without first opening the dropdown;
- open the dropdown without typing to browse available values.

This pattern is mandatory where practical for:
- Country;
- State / Province / Region / Subdivision;
- Provider;
- Campus;
- Study Level;
- Field of Study;
- Delivery Mode;
- Source;
- Lifecycle Status;
- Publication Status;
- Currency;
- review/reason/status taxonomies;
- other reference-data filters introduced later.

## Dependent reference filters

Where one reference constrains another, the dropdown options should narrow automatically while preserving typed search.

Examples:
- Country -> State / Province / Region;
- Provider -> Campus;
- Provider -> Course where the workflow requires it;
- Country -> regulatory Source where appropriate.

A dependent filter must not silently invent values. Options come from accepted reference/canonical data or a governed read projection.

## Display rules

Country options should display flag + ISO alpha-2 code + country name where space permits.

Subdivision options should display human-readable name plus canonical code, for example `Victoria · AU-VIC` or `Ontario · CA-ON`.

Currency options should display ISO 4217 code and display name/symbol where available. Currency code remains authoritative.

## Interaction and accessibility

Comboboxes should support:
- keyboard navigation;
- Enter to select;
- Escape to close;
- visible selected state;
- predictable focus behaviour;
- no loss of pagination/sort/list context when changing filters;
- server-side filtering for high-volume entity filters;
- bounded client-side option lists only for small reference sets.

## Automation principle

Filter metadata should be sourced dynamically from governed reference/canonical data so new countries, regions, sources and statuses appear without manual UI code changes wherever practical.

The minimum-workforce principle remains: configuration/reference changes should propagate automatically into Admin filter choices rather than requiring repeated frontend edits.

## Immediate Provider implementation contract

Provider Admin should use:
- Country searchable combobox populated from countries that currently have Provider rows;
- State / Region searchable combobox populated from authoritative subdivision values available for the selected country;
- Lifecycle and Publication searchable/selectable bounded enums;
- server-side Provider filtering after selection;
- typed global search independently of the structured filters.

For countries where authoritative subdivision mapping is absent, the State / Region combobox should show no fabricated choices and the UI should expose the coverage gap rather than infer an unverified subdivision.
