# THE and QS public ranking readers (s966, IR-005, RM1J)

**Decision:** Platform Admin, 22 Nov 2026 09:22 AEDT: "We can attribute and use both Times Higher Education (THE) and QS World University Rankings directly. Do NOT gate them behind a manual publisher file upload or a `terms = restricted` hold — remove that rule and build automated Layer 1 readers for both THE and QS using direct JSON/API table fetching."
**Release:** Pilot s966 (`ranking-layer1-etl` v1.8.0, migration `20261122110000`). Lane 1 (`S1-API-Frontend-Delivery`) took this Layer 1 item on the Platform Admin's instruction.
**Standing rule:** "Attributed Public Rankings (THE and QS)" in `CLAUDE.md` and `AGENTS.md` of both repositories.

## 1. What was in the way

| Gate | Where | Now |
|---|---|---|
| THE editions could be read only from an uploaded publisher file | `ranking-layer1-etl` (no THE reader) | THE public ranking JSON is read directly |
| Direct publisher JSON could be validated but never applied ("Direct publisher JSON APPLY is intentionally disabled") | `ranking-layer1-etl` v1.7.0 | Applied and published |
| Editions were recorded as `licensed_upload` with an upload note | `svc_ranking_ingest_apply` | A public edition is published as `public` with its attribution (`svc_ranking_public_edition_publish_v1`) |
| REQ-91 held QS and THE until terms were recorded | Request register | Terms recorded by the decision above |

Website display was already approved (`website.rankings_display_approved = true`), so the consumer API needed no change (G3 untouched).

## 2. The readers

| | THE World University Rankings | QS World University Rankings |
|---|---|---|
| Endpoint (plain GET) | `https://www.timeshighereducation.com/json/ranking_tables/world_university_rankings/<year>` | `https://www.topuniversities.com/rankings/endpoint?nid=<edition nid>&tab=indicators&items_per_page=500&page=<n>` |
| Found by | The `jsonUrl` the ranking page itself loads | The results endpoint the ranking page itself calls |
| robots.txt | Path allowed; no crawl-delay | Path allowed; `crawl-delay: 10` honoured between requests |
| 2027 edition read (rehearsal 22 Nov 10:05) | 3,146 rows: 201 tied, 1,995 banded, 849 reporters; no unrecognised rank | 1,504 rows over 4 pages: 494 tied, 804 banded; no unrecognised rank |
| Kept per row | Rank as printed, exact rank or band, tie, overall score (or score band), the five pillars with their own ranks | Rank as printed, exact rank or band, tie (printed `=` or repeated rank), overall score, every indicator with its rank and group |
| Indicator codes | The codes of the earlier THE editions (`teaching`, `research`, `citations`, `industry_income`, `international_outlook`), labelled with the publisher's 2027 names | The codes of the QS editions already held (`academic_reputation`, `employer_reputation`, …) |
| Attribution recorded | "Times Higher Education World University Rankings 2027. Source: Times Higher Education (timeshighereducation.com)…" | "QS World University Rankings 2027. Source: QS World University Rankings (topuniversities.com)…" |
| Source page linked | `…/world-university-rankings/2027/world-ranking` | `…/world-university-rankings/2027` |

Spend: $0. No Firecrawl, no browser automation, no AI. The JSON read is kept as evidence (`pipeline.evidence_artifacts`, `ranking_publisher_json`) before anything is applied.

A challenge page (Cloudflare "Just a moment") is reported and never bypassed. The edition already held stays live. The run fails as "temporarily unavailable", and the Layer 1 run driver retries it after 1, 2, 4, 8 and 15 minutes. One QS request in the rehearsal series met a challenge; the next, ten seconds apart as robots.txt asks, did not.

## 3. Provider matching (deterministic)

These rules run in order, and the first unique match wins:

1. An accepted mapping for the publisher's institution ID, from an earlier edition or a person's decision.
2. A ranking alias of a provider, in the same country.
3. The provider's name with everything except letters and digits removed, in the same country.
4. **New in s966:** one part of the provider's register name, in the same country, with exactly one provider matching. Register names are split on "/" and cut before ", including". For example, "Université d'Ottawa/University of Ottawa" or "University of Regina, including Campion College …". The link is saved as an accepted mapping, so later editions and the hourly `ranking-link` job reuse it.

Neither feed gives an institution domain, so domains cannot be used. A row that matches no provider stays in the edition without a link. It is listed in the run result and shown for review in Rankings › links, and the run does not fail.

Rehearsal (rolled-back, 22 Nov 2026 10:05 AEDT), against the 3,090 active providers (AU 1,543, CA 1,130, NZ 417):

| Edition | Australia | New Zealand | Canada | Left for review |
|---|---|---|---|---|
| THE 2027 | 37 of 37 | 8 of 8 | 32 of 34 (3 by rule 4) | University of Waterloo, Wilfrid Laurier University: no provider record |
| QS 2027 | 37 of 37 | 8 of 8 | 28 of 30 (3 by rule 4) | University of Waterloo, Queen's University at Kingston: no provider record |

The uploaded QS 2027 file had 70 links. The public read has 73, and the uploaded revision is superseded.

## 4. Running it

- **On deploy:** the migration queues one apply run each for "Times Higher Education World University Rankings 2027" (a new Layer 1 source beside THE 2026) and "QS World University Rankings 2027". The existing `layer1-run-driver` starts them about 10 minutes after the migration, once the edge function deploy has finished.
- **On demand:** Layer 1 › Sources › the source › Validate, then Run (`layer1-operations-control` → `ranking-layer1-etl`).
- **Refresh:** both sources have `auto_ingest` on. The existing scheduled verification (`layer1-regulatory-scheduler`) and automatic ingestion (`layer1-auto-ingest`) re-read them when the publisher's data changes. No new cron job.
- **Next edition:** register a source for the new year, with its QS `nid`, as was done for THE 2027 here.

## 5. Guards

- `tests/uat/cf-247-s966-public-ranking-readers-contract.spec.mjs` (new): the parsers, ties and bands, robots.txt, the challenge check, the attribution, and the migration's shape.
- `cf-067` (updated): the reader applies and publishes public JSON.
- `cf-068` (updated, deployed, `@live-acting`): QS 2027 reads the public endpoint, or reports a challenge without bypassing it.
