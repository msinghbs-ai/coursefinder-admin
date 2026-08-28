# Milestone 2 Execution Addendum A15 — Institute International Contact Intelligence

**Status:** AUTHORITATIVE ADDENDUM — ACTIVE
**Effective:** 29 August 2026
**Applies to:** M2.4.3 onward until superseded
**Change Control:** CF-CHG-20260829-046

## Purpose

Add governed institute/university international recruitment contact intelligence to the Provider decision journey while preserving Layer authority, Evidence, privacy and licensed-data boundaries.

## Source precedence

1. **First-party university website** — preferred for public international-team, regional-manager, admissions and recruitment contacts.
2. **Licensed professional enrichment** — secondary context only; may confirm title/employer/profile but must not silently overwrite first-party facts.
3. **Manual governed resolution** — allowed only with source/provenance and normal review authority.

LinkedIn page scraping is not authorised. LinkedIn profile URLs may be stored when published by the university or returned by an authorised enrichment provider.

## Initial source cohort

Seed from governed catalogue:
- AU providers whose governed name indicates University and whose website is present;
- NZ providers whose governed name indicates University/Te Pūkenga and whose website is present.

Current initial cohort at adoption: 52 AU + 8 NZ = 60.

## Deterministic first-party discovery

The contact scraper targets:
- International / international students;
- Contact international team;
- Regional / country / market managers;
- International recruitment;
- International admissions;
- Representatives / advisers;
- territory-specific manager pages.

Discovery must remain same-host to the governed provider website. Candidate links are scored from URL and anchor text; only bounded pages are fetched per run.

Extract only public professional contact information:
- name;
- title;
- team;
- territory/market assignment;
- institutional work email;
- publicly published work phone;
- profile URL when published;
- source URL;
- observed/verified timestamps.

Do not collect personal emails from free-mail domains as first-party work contacts.

## Licensed enrichment

Provider adapters must:
- be explicitly configured and secret-backed server-side;
- default to domain + job-title search;
- not request personal email or phone reveal;
- retain provider name, external ID/profile URL, current title, employer/domain, call count, latency, units/credits/cost where returned;
- preserve first-party data as higher-priority;
- emit a watch event when a title/employer/contact value materially changes.

Apollo initial search adapter uses People API Search with domain/title filters; its search endpoint returns professional prospect metadata but not email/phone, which is the accepted default.

## Data model

Private pipeline tables:
- provider contact discovery profiles;
- provider contact observations;
- provider contact watch events;
- provider contact enrichment attempts.

No direct anon/authenticated table access. Provider detail is exposed only through the governed Admin read boundary.

## UI

Provider blade must show a dedicated **International contacts** section with:
- First-party / Enriched source badge;
- name/title/team;
- territory;
- work email/phone where permitted;
- source/provider link;
- observed/verified freshness;
- Evidence link;
- change signal.

Do not bury contacts in generic raw-object rendering.

## UAT

Targeted UAT must prove:
- 52 AU + 8 NZ seed baseline or current governed equivalent with explicit delta;
- role/anonymous/private-table negatives;
- Provider read projection;
- source precedence;
- browser blade rendering;
- no personal-email/phone reveal request in licensed adapter;
- watch-event behavior;
- A14 telemetry;
- Security and Performance Advisor disposition;
- canonical/Search/Publication unchanged.
