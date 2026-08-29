# M2.4.3 Next Chat

Start by reading:
1. `PROJECT_INSTRUCTIONS.md`;
2. M2 standing instructions and A1–A15;
3. CF-CHG-20260829-046;
4. latest Running Build / Master Plan / DB Architecture / Admin-PIM Design;
5. this RUNSHEET, CURRENT-STATE and FOLLOW-UPS;
6. current Pilot head, deployed Edge state and Supabase contact-profile rollout state.

Immediate A15 continuation:
- query `pipeline.provider_contact_profiles` for `last_run_at is null`;
- continue `provider-contact-discover-scheduled` in sequential nonce-backed batches of 3;
- do not overlap Firecrawl batches;
- inspect non-zero rows for quality;
- preserve rejected history;
- update coverage metrics and Change Control;
- when all profiles are terminal, run advisors + bounded integration UAT;
- Apollo is configuration-blocked unless a server-side key has been separately supplied.

Do not weaken first-party precedence, privacy, Layer 1 identity, Evidence, Search or Publication boundaries.
