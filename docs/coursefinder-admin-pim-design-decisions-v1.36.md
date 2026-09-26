# CourseFinder Admin/PIM Design Decisions v1.36

**Status:** CURRENT M2 DESIGN DECISIONS  
**Date:** 26 September 2026  
**Supersedes:** v1.35  
**Change Controls:** CF-CHG-20260903-083, CF-CHG-20260903-084, CF-CHG-20260915-247

## Decisions 38–133
Decisions 38–83 from v1.31, 84–123 from v1.32, 124–128 from v1.33, 129 from v1.34 and 130–133 from v1.35 remain authoritative and unchanged.

## Decision 134 — Statistics datasets: one card per dataset, one edition per year
Each statistics dataset (QILT, PRISMS, QS, THE) is one dataset family shown as one card, with a year selector over its retained editions. QILT is one family with its four surveys (SES, GOS, GOS-Longitudinal, ESS) as tabs. A family's source is the publisher's stable page that lists its files, with a rule for finding each year's file, not a year-specific file address. Each new year becomes a new edition in the same family; the newest becomes current and earlier editions are kept. Each family has one schedule that checks for a new edition. Licensed files (QS, THE) are uploaded from their own dataset card with the same validation and history. Placement: Statistics & Rankings is where people view and compare, Layer 1 Operations is where operators run and upload, and Administration is where sources and schedules are configured; each card links to all three. Data fixes (with proof first): apply THE 2019–2024, check the THE "2015" edition, and merge the duplicated QS 2024 and 2025 editions.

## Decision 135 — ARWU and University Diversity Index are planned
ARWU and the University Diversity Index remain registered but are shown as "Planned — no data yet" until acquisition is approved.

## Decision 136 — Consumer API guard
Every database change that can affect the website, Wix or Zoho APIs runs a guard in the same transaction: the outputs of the six consumer data functions are fingerprinted with fixed cases before and after the change, and any difference aborts the change. Baselines are kept. Permission changes, which the guard cannot see, are verified separately in the same change.

## Decision 137 — The consumer reference bundle is cached
The consumer reference bundle (countries, subdivisions, providers, filters, platform figures) is rebuilt every 10 minutes and served from the cache; if the cache is older than 30 minutes the live query is used. Output is unchanged; response time fell from about 4.6 seconds to 54 milliseconds.

## Decision 138 — Publication: pilot behaviour now, gate in production
In the pilot, consumer APIs continue to return unpublished records (intended). For production (P10): a course is publishable when it is active, has a study level, its provider is active, and (AU) it has a registered cost; enrichment attributes are not required. Publication is applied by an audited rule that also withdraws courses that stop qualifying, with Layer 4 overrides either way. The production sequence is: publish by rule with proof first, compare consumer output before and after, then make the consumer APIs return published records only. Sized on 26 September 2026: 26,457 AU and 6,163 NZ courses would publish; 485 would be held for review.

## Decision 139 — Scholarship publication
A scholarship is publishable when it has the provider's own page, an international audience, a stated award value, captured evidence, at least one linked course, and verification within the last 12 months. Scholarships are published by a PIM Admin in batches, because they carry eligibility claims, and withdrawn automatically when re-verification lapses. On 26 September 2026, 57 of 292 met every condition.

## Decision 140 — Course description
The course description's authority is Layer 2: the provider's own overview text, taken only from the admitted official course page, so description and link always match. Extraction takes the first overview section as plain text, 200 to 1,000 characters, without fees, dates or navigation, stored with evidence. No AI rewriting. It is shown with attribution and a link to the provider page; corrections use the Layer 4 description path.

## Decision 141 — Layer 2 qualification per provider
Layer 2 source qualification is done per provider, so one qualification unlocks all of that provider's courses, instead of course by course. The Layer 2 admissions view shows, per attribute and country, the funnel from awaiting qualification to queued to admitted, with blocked reasons and the actions to qualify a provider or run a wave.

## Decision 142 — Layer 4 correction for intakes and English requirements
Intakes and English requirements get a Layer 4 correction path, like official links and tuition, so every non-regulatory attribute has one.

## Decision 143 — New Zealand baseline
New Zealand courses keep identity and study level from the NZ register; field, locations, delivery mode and fees are not available from that source. NZ enrichment is planned after Australia.

## Decision 144 — The Attribute & Admission Register
The Attribute & Admission Register is a standing design document: one row per course attribute with its authority layer, source, admission rule, Layer 4 correction path, refresh, consumer field and coverage. Every attribute has exactly one authority layer; every non-regulatory attribute has an admission rule and a correction path; a new attribute is added to the register before it reaches consumers.

## Decision 145 — Database hygiene
Indexes are added for foreign keys on busy tables. Unused indexes are removed only when large and verified as not serving a consumer path, a planned production path or a foreign key, and each removal keeps a recreate script; small unused indexes are left, because some serve yearly jobs. Security-definer functions must pin their search path, public (anon) access is not granted to them, and internal or integration functions are limited to the service role. The Auth connection strategy is set for production in P10.