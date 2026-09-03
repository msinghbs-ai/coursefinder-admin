# CF-CHG-20260903-099 — Ranking Multi-file Upload Transport

**Status:** IMPLEMENTED / DEPLOYED UAT PASS — BUILD FINALISING  
**Initiated:** 2026-09-03 18:26 AEST  
**Category:** 20-layer1-regulatory-ingestion  
**Parent:** CF-098 / H12-H13

## Trigger

Mobile browser screenshot on Admin v2.15.54:
- two ranking files selected and correctly detected;
- submission failed with `Failed to send a request to the Edge Function`.

## Live diagnosis

Supabase Edge logs at 18:26 AEST showed:
- `OPTIONS 204` for `ranking-publisher-import`;
- no matching POST reached the Edge Function.

The selected AU/NZ ranking files are only about 70 KB combined, ruling out the 50 MB function/file limit. The failure occurred before Edge execution, in the browser/client transport path.

## Root cause / corrective pattern

The multi-file client used `supabase.functions.invoke()` with multiple File parts in one FormData body. This path was unreliable in the mobile browser although single-file THE uploads were proven.

## Fix

- multiple ranking files are now combined client-side into one `manual_ranking_bundle` JSON file;
- only one multipart file is sent to the Edge Function;
- original filenames, MIME types and payloads remain embedded in the bundle for Evidence lineage;
- backend CF-098 parser/system/year/scope validation is unchanged;
- release advanced to v2.15.55.

## Pilot refs

- transport fix: `c4636d79ec09447fffa04c66ed5df4e0fb2e6c92`;
- UI version: `03e6f4adfdfd65df7c5bc629cf12073c4ab1dd95`;
- release: `658eac64b58ccdd413f8928f7c9758128e5c80fd`;
- title: `b26613d84fa9e4848c9deb5c0e687dfd3be6950a`.

## Validation

- deployed UAT run `33733582425`: PASS;
- final frontend build on the same candidate was still running at governance record time.

No ranking edition was Applied by this correction.
