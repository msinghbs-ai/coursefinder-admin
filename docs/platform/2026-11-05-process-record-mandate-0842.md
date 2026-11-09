# Process record mandate (Platform Admin, 5 Nov 2026 08:42 AEDT)

**Instruction (verbatim):** "I need to validate the design from ui as well dont just deliver it, i need proper validation what it did , how many and what was missed and reason what is the schedule to revisit, all stored and keep up-to-date in repo. Mandate from here, every process need to be maintained in admin repo, its result failure and reason."

Context (08:40): the Platform Admin asked why stored course pages, adapters and AI reading have not produced intake dates for the top 10 Australian universities, and asked that the platform learn new page formats and become self-sufficient.

## What this requires from now on

1. **Every process has a record in the admin repo.** A process is any job, reader, rule or pipeline step that changes or decides data (for example intake dates, course links, fees, scholarships).
2. **Each record states, per run or per measured period:**
   - what it did (scope and denominator);
   - how many succeeded, by outcome;
   - what was missed, with the reason for each group;
   - the next revisit: when the missed items are looked at again, and by which job or decision;
   - the evidence (run IDs, queries, release).
3. **Records are kept current**, not written once. A generated document is preferred over hand edits, so the record cannot go stale.
4. **Validation is visible in the Admin UI**, not only in the repo. The Platform Admin can see the same numbers and reasons on screen and check them, rather than receiving a delivery to accept.
5. **Delivery is not acceptance.** A release is reported with what the process did, how many, what was missed and why, measured in production.

## First application

The intake dates process for the top 10 Australian universities (investigation started 08:40), recorded under `docs/platform/processes/`.
