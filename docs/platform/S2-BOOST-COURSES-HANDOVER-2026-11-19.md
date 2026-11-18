# S2-BOOST-Courses 1-day handover, 19 Nov 2026

Platform Admin directive Thu 19 Nov 2026 06:49 AEDT (reserved s666–s669 and s720–s739). Times are AEDT. Every figure below was read live on the date shown, read-only.

## What shipped

| Item | Result |
|---|---|
| 1. Descriptions of 1 to 2 sentences, identity proof, Layer 4 holds | Pilot #1344 merged (worker v1.0.25, release v2.16.50, migration `20261119084000`; seven function bodies guarded by md5 and equal to live; rolled-back live dry run passed). #1335 and #1336 closed as superseded. |
| 1. Drain of the 666 held descriptions | Machine rule re-looked at every decline at 07:44. By 08:29: 44 admitted, 650 superseded for a re-read with `cdesc-source-grounded-v4`, 15 in review (evidence moved). Re-reads wait for the next `field-gap-queue` run (09:23); the 08:23 run hit a statement timeout. Zero Firecrawl. |
| 2. Study load label split and release | Not duplicated: #1337 (s721) and #1347 (s722, 820 items released) came from the S1-Courses lane. Courses with a study load: 5,689 of 36,031 active. |
| 3. Intakes, fees, deadlines | Pilot #1346 (S1-Courses lane), open; conflicts with main. Comment left. No fee tier enabled. |
| 4. Campus locality | #1341 (s727) merged: 3 postcodes and 9 campuses settled; 69 campuses still need a person. |
| 5. Live verification | s728 (Pilot #1356, #1357): read-only deployed spec run through the governed UAT login; figures below. Self-check scheduled for about 10:14. |

## Live figures (Actions run 44400209609, release v2.16.50)

- Coverage snapshot built 08:12: attribute tiles 24,066, 10,797, 13,456 and 20,834 of 36,031 admitted; Intakes 13,456; Provider tuition 10,797.
- Layer 4 Inbox: Boost study load 179; Campus locality 69; University description 76; Fee fails the check 10; Held scholarship 82; Entry requirements (AER) 2,655.
- Courses holding a description: 14,433 (07:42) to 14,477 (08:29) of 44,733.

## Credentials

GitHub Actions secrets cannot be read back, so no login was typed into a browser. The deployed UAT workflow signs in with the stored secrets and prints neither; s728 reads the screens through it. A person is not asked for credentials.

## Open

- `field-gap-queue` statement timeouts (08:23; earlier 19 Nov 05:23): 80 s average against a 120 s limit. Owner: pipeline.
- #1346 rebase (worker v1.0.26, migration above `20261119084000`, next release number).
- A study load and the description re-reads will show in the self-check.
