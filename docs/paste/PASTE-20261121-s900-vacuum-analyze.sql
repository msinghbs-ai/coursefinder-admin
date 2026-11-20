-- PASTE-20261121-s900-vacuum-analyze.sql
-- CF-247 s900, IQ-00510 option C (Platform Admin 21 Nov 2026 07:48 AEDT, chat S1-Coverage-Unlock-UI-Notes).
-- Project: fxcwkweaxjtknorudmwp only.
--
-- What it does: a plain VACUUM (ANALYZE) of the four tables the 2 AM audit flagged
-- (admin docs/platform/2026-11-21-capacity-runtime-audit.md). It marks dead rows for reuse and refreshes planner statistics.
-- It does not lock the tables against reads or writes, deletes no live row, and changes no setting or retention rule.
-- It is not VACUUM FULL (which would lock each table); it returns little or no space to the disk, but slows growth.
--
-- Why a paste file: VACUUM cannot run inside a transaction, and every migration runs inside one.
--
-- How to run: in the Supabase SQL editor, run each VACUUM line ON ITS OWN (select the line and run it).
-- Running them together fails with "VACUUM cannot run inside a transaction block"; nothing changes when that happens.
-- Each takes seconds to a minute or two.
--
-- Read before (21 Nov 2026 02:03 AEDT): dead rows as a share of all rows
--   catalogue.course_fees              142 MiB  11.6%  (last autovacuum 5 Oct 2026)
--   pipeline.course_attribute_coverage 144 MiB  15.3%
--   scholarship.course_mappings        101 MiB  15.5%
--   pipeline.coverage_provider_urls    165 MiB  11.3%
-- Replaces: nothing. Retires: nothing. Drops or deletes: nothing.

vacuum (analyze) catalogue.course_fees;

vacuum (analyze) pipeline.course_attribute_coverage;

vacuum (analyze) scholarship.course_mappings;

vacuum (analyze) pipeline.coverage_provider_urls;

-- Check afterwards (one statement; read only):
select relname, n_live_tup, n_dead_tup, round(100.0 * n_dead_tup / nullif(n_live_tup + n_dead_tup, 0), 1) as dead_pct, last_vacuum, last_analyze
  from pg_stat_user_tables
 where (schemaname, relname) in (('catalogue', 'course_fees'), ('pipeline', 'course_attribute_coverage'),
                                 ('scholarship', 'course_mappings'), ('pipeline', 'coverage_provider_urls'))
 order by relname;
