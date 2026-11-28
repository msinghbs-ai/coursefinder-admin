# s1357 and s1362: fee writers never record AUD by default; an entry row's audience must be on its sentence

**Direction:** PC-20261128-CONTINUOUS-BUILD-EXECUTE and PC-20261128-1924-PROGRESS-REVIEW. Reconcile #1764 ordering and rehearse it on the exact head before merge; integrate branch `3bbb6ede` without a duplicate completion verifier. S1-Build integrates both. The content is the owning lanes'.

## s1357 (S1-RM-Design, Pilot #1764, integrated as a new S1-Build pull request)

- **Ordering.** #1764 had `20261201130000`. After the main-green fix s1360 the live head is `20261201140000`, so that version can no longer apply. The migration moves to **`20261201150000`** with its content unchanged; only the spec's path follows it. #1764 itself is superseded and stays open for its owner to close.
- **Change** (S1-RM-Design's design record, Admin #1376). One resolver, `security.fee_currency_resolve_v1(provider, explicit)`: an explicit active ISO code wins; otherwise the provider country's default currency; otherwise null, and the writer holds the fee.
  - Seven writers use it: the fee wording, provider and provider-basis rules, course facts, adapter overwrite, Layer 4 apply, and Layer 3 assumed-annual admission.
  - The fixed `'AUD'`, the AUD default and the AUD/NZD/CAD allowlist are gone.
- **Rehearsed rolled back on the exact live head `20261201140000`.**

  | Check | Result |
  |---|---|
  | Edit markers | every marker found once |
  | Resolver: AU, NZ, CA providers | AUD, NZD, CAD |
  | Resolver: explicit `gbp` | GBP |
  | Resolver: unknown code | null |
  | Resolver: nothing | null |
  | Fixed AUD literals left in the rule writers | 0 |
  | G3 | 75/48, no drift |

- **Local:** s1357 and every spec naming a changed writer, plus s32, s42, s57, s120 and s980, passed (132). Pre-flight passed.
- **Live effect for AU, NZ and CA:** none expected. 0 active fees have a null currency or a currency other than the country default (S1-Data-Gaps, Admin #1372).

## s1362 (S2-AER branch `s2-aer-semantic-entry-validation`, worker v1.0.65)

- **Taken:** `entryAudienceSupported`.
  - `international` needs an international, overseas or non-Australian word in the sentence; "International Baccalaureate" does not count.
  - `domestic` needs a domestic route or group (the s1280 words).
  - A label the sentence does not support becomes `all`.
- **Not taken:** the branch's `entryCompletionNotEntry`. s1354's `entryCompletionRequirement` already drops that row, so there is one completion check, not two.
- **Fixtures (Murdoch H1287):**

  | Row | Result |
  |---|---|
  | IB 27, read as international | all |
  | ATAR 80 | domestic, unchanged |
  | The 450-hour completion sentence | dropped once (`completion_requirement`) |

- **Local:** every worker spec and s120 passed (1,524). The prompt is unchanged, and the prompt file is regenerated (worker line only).

Neither change adds a job, a table, a setting or spend.
