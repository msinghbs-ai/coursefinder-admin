# Scholarships — countries in scope and how a new country joins (v1, 9 Oct 2026)

Platform Admin decision (9 Oct 2026): scholarships run for **Australia, New Zealand and Canada** only for now. More countries will join later; the plan below switches on as each one does. Migration `20261008005000` (CF-247).

## 1. Countries today

| Country | Scholarships | Provider pages | Government register | Notes |
|---|---|---|---|---|
| Australia | On | Universities (admission universities only) | Study Australia (index), Australia Awards (record) | Live |
| New Zealand | On | Universities | Manaaki (record) | Live |
| Canada | On | Universities | Study in Canada — held | EduCanada robots.txt blocks automated readers |
| United Kingdom | Watching | — | Chevening, Commonwealth Scholarships (planned) | Joins when UK courses are in the catalogue |
| United States | Watching | — | Fulbright Foreign Student Program (planned) | Joins when US courses are in the catalogue |
| Ireland | Watching | — | To research | Joins when Irish courses are in the catalogue |
| Germany | Watching | — | To research (DAAD) | Joins when German courses are in the catalogue |

The country switch (`ref.countries.scholarship_ingestion_enabled`) is on for AU, NZ and CA only. It was also on for DE, GB, IE and US, which have no courses; it was switched off (logged).

## 2. What triggers a new country

- A daily job, **scholarship-country-watch** (06:13 Melbourne), checks every country that has active courses in the catalogue.
- If a country has courses but scholarships are off — or is switched on with something missing — it raises a **platform issue** `scholarship_country:<code>` (warning, area Scholarships) with the course count, universities found, what is missing and the next steps.
- The issue resolves itself once the country is switched on and ready (or no longer has courses).
- Proven in a rolled-back simulation (a university temporarily moved to the UK): the issue read "United Kingdom has 199 courses but scholarships are not switched on"; switching the UK on resolved it.

## 3. What "ready" means (`security.scholarship_country_readiness_v1`)

| Check | Why |
|---|---|
| Active courses in the catalogue | Scholarships only reach counsellors through course links |
| An onboarding entry (`scholarship.country_onboarding`) | Holds the country's status, wording and registers |
| Domestic-student wording for that country | So the audience reader can tell domestic-only scholarships from international ones |
| A nationality term for the country | So "citizens of <country>" is read correctly when it is the study country |
| At least one university recognised | Admission from provider pages is universities only |
| Once on: providers queued for discovery | Confirms the scholarship pipeline has started |

## 4. Steps when a country joins

1. **The alert appears** on the platform issues list when the country's courses arrive in Layer 1.
2. **Check the onboarding entry**: domestic-student wording (prefilled for GB, US, IE, DE) and the government registers to build.
3. **Build the planned government registers** as Layer 1 record registers (same pattern as Australia Awards and Manaaki):
   - reader;
   - Layer 1 source;
   - register profile;
   - institutions matched by website.
4. **Switch the country on (Platform Admin)**: `admin_scholarship_country('<code>', true, '<reason>')`.
   - It is refused until the country is ready.
   - It is logged.
   - It queues the country's universities for scholarship discovery straight away.
   - The existing hourly jobs (discover, read, audience, nationality, course links) then run for it with no code change.
5. **Set the government registers' schedule** (monthly) once their first run passes.
6. **Check reporting views that still list countries** (data quality, Zoho reference bundle). These are reporting only and are reviewed per country.

## 5. What no longer needs code changes

- **University test** (`security.scholarship_university`): reads the country switch for every country other than Australia. Australia keeps its own university test.
- **Audience reader**: uses the country's domestic wording from `country_onboarding` for any country other than AU, NZ and CA.
- **Government awards**: the register record profile and publishing rules are country-neutral. They cover nationalities from the register, institutions by website, and full-tuition coverage.

## 6. Reading and switching

| Function | Who | What |
|---|---|---|
| `admin_scholarship_countries()` | Rank 5+ | Readiness per country |
| `admin_scholarship_country(code, on, reason)` | Platform Admin | Switch a country on (only when ready) or off |
| `admin_scholarship_registers()` | Rank 5+ | Registers per country with counts |
| `admin_scholarship_register_institutions(register, providers, reason)` | Platform Admin | Pick institutions for a government award |
