# StudySearch – Field enrichment: lessons learnt

**Version:** 1.1 (14 Oct 2026, platform release v2.15.275) · **Change control:** CF-CHG-20260915-247 · **Related:** `FIELD-GAPS-AND-ENRICHMENT-PLAN.md`

Raised by the Platform Admin (14 Oct 2026, 12:04): "record any lesson learnt". These come from building the Enrich fields job (v2.15.273–275), the trial on the University of Waikato and the start of the New Zealand and Canada run. New lessons are added at the end with their date.

| # | Lesson | What we saw | What we do now |
|---|---|---|---|
| 1 | Check what is already read before reading again | University adapters had read campus, duration, level and delivery from 4,500 NZ and Canadian course pages and kept them as "extra", never admitted | The job uses adapter values first, at no cost |
| 2 | Stored copies are not all the same format | Course pages are stored gzip; contact pages are plain HTML. The first address and campus-list reads failed ("invalid gzip header") | The worker reads either (v0.22.1) |
| 3 | A quote must be about the course, not the site | The AI quoted a footer on every page ("International Enquiries … info@international…") as proof that a course is open to international students | "International" needs words about the course's students, fees or tuition (v0.22.2); 39 trial values were undone |
| 4 | Batch AI work by page, not by field | The first calls carried one field of twelve courses, so each page was sent many times | One call answers all of a course's fields from one page read (migration 013700) |
| 5 | Trial on one university before a batch | The trial found a query error in the AI step (nested aggregates) within minutes; nothing was written wrongly | Every new job runs on one university first, then a batch |
| 6 | Write only missing values and keep each one's record | Undoing the footer-based values was exact because each item holds its source, value and quote | Items keep source, value, quote and evidence; hand-set and locked values are never changed |
| 7 | Not every page says every thing | Waikato: delivery stated on 48 of 178 pages, duration on 153 of 278 | A value the page does not state is skipped, not guessed; the preview shows what is likely |
| 8 | Campus names are noisy | Course pages give faculty names, "online" and combined text ("Hamilton, Tauranga, Online") | The AI makes one list per university; a campus is admitted when at least two course pages name it (Waikato: Hamilton and Tauranga, 231 course links) |
| 9 | "Top tier" needs a world ranking outside Australia | The Firecrawl provider tier marks only Australia's top 50; every NZ and Canadian provider was the same tier | Batch 1 is chosen by best world ranking (17 universities), then by number of courses |
| 10 | A rule needs data behind it | New Zealand's institution rule needs the list of providers approved for international students (code of practice), which we do not hold | New Zealand uses what each course page says until that list is loaded |
| 11 | Size the settling step to its real cost | A pass of 400 items took 8 seconds, most of it counting progress across the whole task | Raised to 1,200 items a minute for the 44,539-item batch |
| 12 | A guard in observe mode only reports | OpenRouter is in observe mode, so the Enrich fields guard is shown but does not stop spending | The guard is set to the planned spend (US$25) so its notice is meaningful |
| 13 | Cost per course is small but adds up | About US$0.0016 a course for six fields with gpt-4.1-mini; about US$18 for all NZ and Canadian courses | Telemetry shows AI spend per day beside the guard |
| 14 | AI spend falls on misses too (14 Oct 2026, batch 1) | After 7,581 items: US$1.57 of US$2.30 went on items the page did not answer (duration skipped on 1,235 of 1,780 pages read) | Expected cost per filled value is about 1.5× the per-course guide; the guard and telemetry count both |
| 15 | Free sources first make the AI share small (14 Oct 2026, batch 1) | Of 5,284 values filled, 4,622 came from the adapter or the institution rule at no cost; 662 from AI | Field sources keep adapter and rule ahead of AI; change the order only with a reason |
| 16 | A failure count can include old errors (14 Oct 2026) | Telemetry showed 2 failed AI calls; both were from the trial before migration 013600, not the batch | Check the time of each failure before acting; the card counts the last 24 hours |
