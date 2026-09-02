# CourseFinder Admin/PIM Design Decisions v1.28

**Status:** CURRENT M2 DESIGN DECISIONS  
**Date:** 2 September 2026  
**Supersedes:** v1.27  
**Change Controls:** CF-CHG-20260902-063, CF-CHG-20260902-064, CF-CHG-20260902-076

## Decisions 38–53

Decisions 38–53 from v1.27 remain authoritative and unchanged.

## Decision 54 — Provider Contacts is a first-class Catalogue module

Provider Contacts is not buried in generic Evidence or Layer 2 diagnostics. It is a dedicated Catalogue workspace linked many-to-one to canonical Providers.

## Decision 55 — Managed contacts do not replace A15 observations

A15 contact observations remain source/Evidence history. Operator edits apply to a stable managed contact and append a new managed version/resolution instead of rewriting source observations.

## Decision 56 — Contact deletion is reversible

Routine delete is soft-delete with actor/time/reason and retained history. Deleted contacts remain filterable and can be restored. Hard delete is not a normal PIM action.

## Decision 57 — Contact import is dry-run first

Mass imports are private-Evidence-backed, hash-addressed and idempotent. Provider mapping, duplicate matching and create/update/restore/skip/conflict actions are previewed before APPLY.

## Decision 58 — Provider matching cannot rely on source names alone

Legacy, merged and alternate institution names must resolve through governed Provider aliases/crosswalks to canonical `provider_id`. Ambiguous Provider matches remain review items.

## Decision 59 — Contact management uses a dense decision grid

The module provides server-side search/filter/sort and operator-controlled column order/visibility/width, with a detail drawer for source, verification, history and audit context.

## Decision 60 — Import/export belongs in the module

PIM/Data Admin can import and export from Provider Contacts without navigating to a separate generic ingestion tool. The workflow still reuses the governed private Evidence/import infrastructure and retains audit history.

## Decision 61 — Contact consumer publication remains separate

Admin availability does not imply Search, Website/Wix or Zoho admission. Any external contact projection requires a separately governed consumer contract.
