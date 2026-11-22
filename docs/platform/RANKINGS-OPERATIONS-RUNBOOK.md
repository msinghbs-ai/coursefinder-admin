# Rankings operations runbook

**Version:** 1.0, 22 Nov 2026 (release v2.16.84, Pilot s971)
**Decisions:** Platform Admin 22 Nov 2026 09:22 (IR-005: THE and QS are attributed public rankings, with no publisher-file or terms hold) and 14:22 (IR-011: QS stays on the annual file upload; ARWU is the third ranking).
**In the app:** Help › Platform guide and the SOPs (Platform Admin SOP, Operator SOP) carry the same steps. This runbook adds the background.

## 1. How each ranking arrives

| Ranking body | Code | How it arrives | Where it is run or uploaded |
|---|---|---|---|
| Times Higher Education World University Rankings | `the_wur` | Automated Layer 1 reader of the public ranking JSON | Layer 1 › Sources › "Times Higher Education World University Rankings 2027" (Validate, then Run to read again) |
| Academic Ranking of World Universities (ARWU), ShanghaiRanking | `arwu` | Automated Layer 1 reader of the public ShanghaiRanking ranking API | Layer 1 › Sources › "Academic Ranking of World Universities (ARWU) 2026" |
| QS World University Rankings | `qs_wur` | Annual file upload (`.xlsx` or `.csv`) | Rankings & statistics › Datasets › Ranking imports |

The readers use a plain GET and honour robots.txt and its crawl-delay; they cost $0. QS's public endpoint answers the platform with a Cloudflare challenge, so QS is never read automatically. No proxy, other route or bypass is used.

The automated sources are re-read by the existing scheduled verification and automatic ingestion when the publisher's data changes. A new edition year needs its source registered for that year. For QS that means the new file.

## 2. Who does what

| Action | Pipeline Operator (rank 4) and PIM Admin (rank 5) | Platform Admin (rank 6) |
|---|---|---|
| Upload a ranking file (QS, or any body that has no reader) | Yes | Yes |
| Run a Layer 1 ranking source again (THE, ARWU) | Yes, where Layer 1 › Sources allows the role | Yes |
| Read the import result: rows, matches by country, rows not matched | Yes | Yes |
| Link an unmatched university to its provider, or add a ranking alias | Yes (Curators also link) | Yes |
| Check the attribution and the source page of an edition | Read only | Yes: vouches for it |
| Publish an edition, or unpublish it (roll back) | No | Yes, with a reason |

**Note on attribution:**
- The upload form asks for the licence and attribution note, and the role that uploads fills it in.
- The Platform Admin checks it on Ranking editions before relying on the edition.
- An edition read by a Layer 1 reader carries a fixed attribution written by the reader.

## 3. Standard operating procedure (six steps)

1. **Confirm how the ranking arrives** (section 1).
   - THE and ARWU need no file. Their edition appears on Rankings & statistics › Datasets › Ranking editions when it has been read.
   - QS waits for the annual file.
2. **Prepare the file (uploads only).**
   - Download the official `.xlsx` or `.csv` from the publisher.
   - Check the edition year, for example 2027.
   - Keep tied ranks (`=12`) and bands (`501-510`) exactly as printed; never average a band.
   - Check that every row has the institution name, the country or territory and the overall score.
3. **Upload and read the result.**
   - On Ranking imports, choose the ranking body, the edition year and the source page, then upload the file.
   - Read the total rows, the rows matched to providers by country, and the rows not matched.
   - Every file is checked and applied, and it appears on Ranking editions.
4. **Resolve unmatched providers.**
   - On Rankings & statistics › Overview (Link: Not linked), for each country held (Australia, New Zealand, Canada), link each unmatched university to its provider, or add the publisher's name as the provider's ranking alias.
   - The next edition then matches by itself.
   - Matching never guesses. A name it cannot place stays unlinked until a person links it.
5. **Check the attribution and publish (Platform Admin).**
   - On Ranking editions, check the attribution and the source page link.
   - An edition from a reader is published when it is complete.
   - For any other edition not yet published, press Publish, give a reason, and choose Publish edition.
   - The edition is live on Website API v3 at once. Earlier years stay as history, and any other copy of the same year is set to Not published.
6. **Check it, and roll back if needed (Platform Admin).**
   - Spot-check one ranked university we hold, on its provider page or in a Website API v3 provider answer. THE, QS and ARWU each show their own latest rank side by side.
   - If an edition is wrong, press Unpublish, give a reason, and choose Unpublish edition. The website shows the previous published edition immediately.
   - Publish it again once it is fixed. Every publish and unpublish is logged with its reason (`ranking.edition_status_changes`).

## 4. Where it shows

- **Website API v3:** the `rankings` action and each provider's `ranking_summary` read the latest published (accepted) edition of each body. The bodies are kept separate and are never combined into one rank.
- **Zoho API v3:** carries no ranking columns, so ranking changes do not reach Zoho.

## 5. Failure modes

| You see | It means | Do |
|---|---|---|
| A reader run "temporarily unavailable": challenge page (HTTP 403) | The publisher's site challenged the request | Nothing to bypass. The edition held stays live, and the run retries later. If it persists, raise it with the Platform Admin |
| An edition shows Loading | A reader is applying it; it is hidden until complete | Wait; it publishes when complete. If it stays, check the run in Layer 1 › Sources |
| Many unmatched rows in a country we hold | Names differ from the register | Step 4 |
