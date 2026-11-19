# s766 and s767: Australian university identity holds, and Country and Provider type filters on Layer 4 Review

Version 1.1, 19 Nov 2026 17:53 (chat S1-RM-Design). Platform Admin directive 19 Nov 2026 16:18 and addendum 17:02. Pilot release v2.16.53 (package 0.1.475), migrations `20261119172000`, `20261119173000`, `20261119175000` and `20261119181000` (Pilot #1385, #1388, #1391).

## 1. What was read (live, by the rolled-back dry run only; no interactive query)

| University | State read | Cause of the hold |
|---|---|---|
| Victoria University | Two active records: CRICOS 00124K (279 active courses, vu.edu.au) and CRICOS 02475D (35 active courses, vu.edu.au/international) | Each holds the host the other uses (`provider_host_conflict`) |
| RMIT University | Parent (CRICOS 00122A, 510 courses) and "RMIT University Pathways, RMIT UP" (CRICOS 01912G, 3 courses, rmit.edu.au/up) | Both hold rmit.edu.au |
| Western Sydney University | Parent (CRICOS 00917K, 334 courses) and "UWS College ... The College" (CRICOS 02851G, 5 courses, westernsydney.edu.au/thecollege) | Both hold westernsydney.edu.au |
| Torrens University Australia (CRICOS 03389E) | Stored About page, no description | The page is headed "Torrens University"; the catalogue name is "Torrens University Australia; ..." (`provider_name_conflict`) |
| Moore College (CRICOS 00682B) | Stored About page, no description | The page is headed "Moore Theological College" (`provider_name_conflict`) |
| Australian University College of Divinity (CRICOS 02948J) | No stored page, 41 courses | Open finding `domain_shared`: aucd.edu.au is also recorded for a provider named "NA" |
| "NA" (CRICOS 03811G) | Private VET provider (Myotherapy, Real Estate, Beauty Therapy), 7 active courses, website `aucd.edu.au` manually locked | It is not the University College of Divinity; its website value is wrong |
| Macquarie University (188103a5) | Open finding `identity_unconfirmed`: "mq.edu.au fits neither the provider's name nor its contact email domain, and no site check verified it" | Needs a person or a site check |
| Avondale University (fd815678) | Read held `not_about_page`: the About address redirects to `/your-uni/` | Needs an approved About address |

Live head was `20261119160000`. `pdesc.acquire_firecrawl` 0; route `openai/gpt-4.1-mini`, cap US$0.50 a day, US$0.0075 used (8 calls). Only Torrens and Moore have a stored page.

## 2. What was done (migration `20261119172000`, md5-guarded against the live definitions)

1. **Host owners.** New table `pipeline.provider_host_owners` (host, owner, reason, who, when; row level security on, comment on table). Owners recorded: vu.edu.au to Victoria University 00124K, rmit.edu.au to RMIT University, westernsydney.edu.au to Western Sydney University. `security.provider_description_identity_v1` now treats the recorded owner as clear on its host and every other provider that holds the host as still in conflict (same rule, `provider_host_conflict`). A host with no row is decided exactly as before. The units (RMIT UP, UWS College) and the second Victoria registration therefore stay held, which is correct: their pages are not the university's About page.
2. **Trading names.** "Torrens University" and "Moore Theological College" are recorded in `catalogue.provider_aliases` with alias type `trading_name`, each taken from the provider's own stored About page heading. `public.svc_provider_description_next` appends active trading names to `identity_names` (the catalogue names still come first). The proof itself is unchanged: it still requires a heading that names the provider.
3. **Reads.** One stored-page read queued for each of Torrens and Moore (state `queued`, drain rule `s766-au-university-identity`), run by the scheduled worker under its own limits: GPT-4.1 mini, about US$0.0015 a read, Firecrawl 0. Both providers have no description and no manual lock. The reader, grounding checks and machine admission decide each one; nothing is admitted by this change.

Not changed: the consumer API (G3 stays 75 functions and 48 tables; the new table is in schema `pipeline`), the manual locks (7,585), any description a person wrote. Nothing is merged, retired or deleted.

### 2a. Addendum of 17:02 (migrations `20261119175000` and `20261119181000`)

| Item | Result |
|---|---|
| Trading names | Recorded (type `trading_name`): AUT, Auckland University of Technology in New Zealand, CIHE, Crown Institute of Higher Education, Kaplan Murdoch, Sydney Metropolitan Institute of Technology. With Torrens University and Moore Theological College that is six providers. Lyons College and Te Whare Wānanga o Awanuiārangi were not added: their stored pages carry no heading with the name, so an alias would not clear the proof (not weakened). |
| Host owner, Holmes Institute | holmesinstitute.edu.au to CRICOS 02639M (Melbourne). Three records share the website; the other two now read `provider_host_conflict`. Reversible by a person. |
| Bounded read | On-demand request `ebcc6b09`, six stored-page reads, GPT-4.1 mini, Firecrawl 0. Admitted: Kaplan Murdoch, CIHE, Sydney Met. Held by the sentence checks on the model answer: Torrens, Moore ("the first sentence does not name the provider"), AUT ("a sentence is not supported by its quote", 0.4545). |
| Spend | Firecrawl 0 units; OpenRouter US$0.0887 in the window across all lanes (cap US$0.10); balance US$6.96 after. Window closed by `20261119181000`. |
| Guardrails | Manual locks and G3 (75 functions, 48 tables) untouched; no new consumer object; `pdesc.acquire_firecrawl` 0. |

## 3. Decisions taken and what is left for a person

| Item | Decision | Why |
|---|---|---|
| Victoria University duplicate | Not merged or retired. Owner recorded for 00124K. | The two are separate CRICOS registrations, not one record twice. 120 tables reference a provider, 34 of the 35 courses on 02475D share a title with a course on 00124K but none shares a code, no merge function exists and a migration may not delete. A merge needs a person to decide which courses move or retire. |
| RMIT and Western Sydney | Done (owner recorded). | Neither has a stored page yet, so no description can be read until a page is stored (acquisition is off). |
| "NA" record | Not retired or unlinked. | It holds 7 active courses and its website is manually locked. A person should correct its website (it is a different VET provider) and unlock it; that clears the `domain_shared` finding on both records. |
| Macquarie | Not changed. | The finding needs a person or a site check on mq.edu.au. |
| Avondale | Not changed. | Needs an approved About address (the current one redirects to `/your-uni/`). |

## 4. s767: Layer 4 Review › Grid, Country and Provider type pills

`public.admin_layer4_grid_read_v1` (md5-guarded edit, read only) takes optional `country` (an ISO code, checked against `ref.countries`) and `provider_type` (one of four groups). The filter runs before the page is cut, so rows, count and Export CSV agree. Items with no provider are left out when a filter is set.

| Pill | Covers |
|---|---|
| Country: All, Australia, New Zealand, Canada | AU, NZ, CA |
| Provider type: University | university, university_college, wananga |
| Provider type: VET / College | tafe_polytechnic, private_vet |
| Provider type: School | school |
| Provider type: HEI | higher_education_institute |

The register type `other` and the two retired types belong to no group and show under All. The pills are not kept in a saved view (the view definition keeps its five keys). Provider description items on Grid: 209 waiting, 94 of them Australian private VET.

## 5. Verification

Both migrations passed the rolled-back live dry run (their own post-checks ran to the end). The dry run showed the three owners and the two reads that would queue. Specs `cf-247-s766-au-university-identity-contract` (9, including the addendum) and `cf-247-s767-layer4-grid-country-type-contract` (4, one on the phone project at 375 px).
