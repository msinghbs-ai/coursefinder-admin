# D-SCH-VAL-01: publishing awards whose official page states benefits but no amount

**For:** the Platform Admin (protected publication policy). **Prepared by:** S2-Scholarship, 13 Nov 2026 23:30 AEDT. **Status:** awaiting decision.

## The question

The publication check "no stated award value" holds every admitted scholarship whose official page gives no amount or percentage. Some of these are real awards whose benefits are stated, verified and quoted, but not as one number: for example a return airfare, health cover, a stipend at the government rate, or accommodation. Should they be published with their verified benefits shown and the amount left unknown?

Nothing below invents a value. The amount stays empty ("not stated"). No zero is written, and a silent page is never treated as "free" or "full".

## The 95 open award-value cases (`sch_value` interventions), as at 12:20 UTC 13 Nov

The register's 94 "no number" cases plus the 1 unpublished case awaiting recheck.

| Class | Cases | What it means | Proposed handling |
|---|---|---|---|
| Benefits verified, no amount | **57** | The reader quoted at least one benefit from the official page; none is a number | **This decision** |
| No amount and no benefit stated | 24 | The page states no value of any kind | Stay with the reviewer. A person can enter a value from evidence; nothing is published without one |
| Not yet read with the detail reader | 14 | Queued for the v3 reader (paused by the OpenRouter key limit, 13 Nov 11:07 UTC) | Machine: read first, then reclassify |

**Excluded from any automatic publication, whatever the decision:**
- 3 records whose source is a student story or blog, not an award page:
  - intervention 330 (Auckland, student story);
  - intervention 328 (Auckland, student story);
  - intervention 206 (Griffith, blog).

  These are wrong-source admissions and need review or withdrawal.
- Intervention 294 (UTS Vice-Chancellor's International Undergraduate) is held as another edition of a listed scholarship.

That leaves **55** with verified benefits and an award page source.

## Options

| Option | Scope | Effect | Risk |
|---|---|---|---|
| **A** | All 55 with a verified benefit quote | Published with "Benefits: …" and value "Amount not stated" (`award_value_type = text_only`, as 7 published records already are) | Vague benefits ("other", "in kind") reach the website |
| **B (recommended)** | The **30** of them with at least one recognised cost benefit: stipend, travel, health cover, accommodation, living expenses or tuition | As A, for these only. The other 25 stay with reviewers | Smaller gain; the clearest benefits only |
| **C** | None | Status quo: each case waits for a reviewer to enter a value | 57 cases stay open and published coverage does not grow |

**Conditions in every option:**
- The benefit must carry a stored-page quote.
- The award must pass every other publication check (international audience, round currency, identity, no human lock).
- The case closes only after publication is verified.
- The consumer API shape is unchanged: `text_only` already exists in v2 and v3.

## Evidence

Each of the 95 cases is listed with its intervention ID, scholarship ID, provider, source URL, class and benefit types. The list is in the Execution Register entry of 13 Nov 2026 23:45 AEDT and can be reproduced from `pipeline.layer4_interventions` (lane `sch_value`) joined with `scholarship.coverage` (notes `sch-extract-v3:%`).

Intervention IDs by class:
- **Benefits verified (57):** 350, 282, 276, 275, 291, 292, 273, 274, 206, 353, 374, 347, 365, 346, 351, 368, 366, 375, 367, 348, 247, 251, 246, 323, 267, 266, 259, 264, 258, 265, 269, 268, 262, 253, 257, 370, 354, 371, 355, 278, 334, 338, 326, 331, 328, 190, 324, 304, 308, 359, 245, 357, 296, 297, 293, 344, 345
- **No amount and no benefit (24):** 281, 243, 356, 272, 271, 205, 283, 289, 284, 279, 254, 250, 248, 358, 340, 341, 330, 339, 186, 325, 298, 300, 295, 294
- **Not yet read (14):** 343, 299, 315, 317, 319, 236, 256, 249, 255, 337, 191, 306, 321, 361
