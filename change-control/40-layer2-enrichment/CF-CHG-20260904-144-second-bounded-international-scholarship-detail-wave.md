# CF-CHG-20260904-144 — Second Bounded International Scholarship Detail Wave

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5

## Review finding

The post-CF-141 candidate selector was reviewed before further firing. A simple `%global%` title/description test would have admitted non-international records such as an Arts Equity Travel Grant whose description mentioned global participation. That condition was rejected before acquisition.

## Corrected firing rule

The next wave is limited to identity-clear, first-party detail candidates whose current title explicitly indicates an international/ASEAN award and whose Provider is already qualified for the Scholarship acquisition route.

Executed targets:

- Edith Cowan University — 2027 ASEAN International Scholarship;
- Monash University — Vice-Chancellor International School Leaver Award;
- Monash University — Vice Chancellor's ASEAN Award.

## Runtime result

All three Layer 2 run batches completed `resolved_l2` with retained Evidence and linked Jobs. The wave reused the existing governed Provider route policy; no route bypass or broad scraper fan-out was introduced.

## Cost / scope guard

- only 3 candidates fired;
- raw `detail_ready` inventory was not mass-acquired;
- navigation/support/ambiguous records remain outside this wave;
- first-party identity and Evidence are required before canonical reconciliation;
- no automatic Publication/Search/Website/Zoho admission.

## Evidence provenance

CF-142 acquisition provenance remains active for this wave, allowing operators to distinguish the live acquisition provider from downstream artifacts derived from already-retained Evidence.

## Source reconciliation

Pilot source migration:

- `supabase/migrations/20260904063500_cf_144_145_second_international_scholarship_wave.sql`

Runtime batch IDs are operational evidence and are intentionally not replayed as migrations.
