# NZ and CA course-campus links without source or evidence: evidence audit (23 Nov 2026)

**Lane:** S2-RM-Design. **Asked:** Platform Admin, 23 Nov 2026 12:29 AEDT ("record an evidence audit of the 667 NZ/CA course-campus links without source/evidence IDs. Do not withdraw them automatically or treat previous approval as proof of course-level applicability"). **Method:** read only, rolled-back live probe (Pilot `db-migration-dry-run` rehearsal), 13:17 AEDT. Nothing was changed.

## Findings

| Measure | Count |
|---|---|
| Active NZ and CA course-campus links with neither `source_id` nor `evidence_id` | **667** (NZ 494, CA 173), 79 providers |
| Marked as made by s818 (one-off, 20 Nov 2026; search refresh requests `campus_projection`) | 257 |
| Made before s818 by an earlier projection (no source recorded) | 410 |
| Provider has exactly one active campus | 660 |
| Provider has two or more active campuses | 7 |
| Link flagged as the course's primary campus | 667 |
| Course has a stored, read course page | 119 |
| Stored page extract names a campus or location | **0** (the readers do not extract campus: extract keys are fee, English, intakes, titles) |
| Course has an official course URL | 144 |
| Course delivery mode says online | 30 |

## What this means

- **None of the 667 links has course-level evidence** in stored data. Each rests on the provider having one campus, not on a statement that the course runs there. Previous approval (s818) is recorded as the reason they exist, not as proof.
- **30 links conflict with the course's own delivery mode** (online), and **7 sit at providers that now have several campuses**; these 37 are the most likely to be wrong.
- No link was withdrawn. They stay until the Platform Admin decides (design v1.12 section H, row H-09).

## What would settle them

- A course-page read that extracts the campus or location (a reader change, then a $0 re-read of the 119 stored pages); the other 548 have no stored page.
- Or the Platform Admin's decision to withdraw some or all (for example the 37 above first), restoring the course's empty reason.
