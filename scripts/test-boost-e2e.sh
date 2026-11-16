#!/usr/bin/env bash
# CF-247 Boost: 4-point parallel test harness (Platform Admin, 16 Nov 2026 20:31).
#
#   scripts/test-boost-e2e.sh [1|2|3|4|all]
#
# Point 1  Worker CPU (< 10 ms a free-tier call) and the 429 failover chain           local, no database, no network
# Point 2  every ungrounded quote blocked before any database ingress (100%)             local, no database, no network
# Point 3  bulk ingestion: 1,000 rows in one transaction under 5 s; no updated_at moved;  TEST_DB_URL
#          promotion rehearsal (rolled back)
# Point 4  consolidation rehearsal: all live migrations replayed in order onto an empty    TEST_DB_URL (empty project) + PROD_RO_URL (read only)
#          test project, then G3 (75 functions, 48 relations, no drift) and the Pilot suite
#
# Environment:
#   TEST_DB_URL   the PARALLEL test Supabase project's Postgres URL. Refused if it names production (fxcwkweaxjtknorudmwp) or coursefinder-demo.
#   PROD_RO_URL   point 4 only: a READ-ONLY role on production, used to export supabase_migrations.schema_migrations (20 s per page, read only)
#   PILOT_DIR     a Coursefinder-Pilot checkout (point 4 runs its local Playwright suite); default ../Coursefinder-Pilot or ../coursefinder-pilot
#   WORK_DIR      scratch folder (default ./staging-boost/harness); never committed
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; ROOT="$(cd "$HERE/.." && pwd)"
PROD_REF=fxcwkweaxjtknorudmwp; DEMO_REF=gfryvshbeptxwbzjomhe
WORK_DIR="${WORK_DIR:-$ROOT/staging-boost/harness}"; mkdir -p "$WORK_DIR"
POINT="${1:-all}"
say() { printf '\n== %s\n' "$*"; }
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }

guard_test_db() {
  [ -n "${TEST_DB_URL:-}" ] || fail "TEST_DB_URL is not set (the parallel test project)"
  case "$TEST_DB_URL" in *"$PROD_REF"*) fail "TEST_DB_URL names production ($PROD_REF): refused";; *"$DEMO_REF"*) fail "TEST_DB_URL names coursefinder-demo: never targeted";; esac
  local ref; ref=$(psql "$TEST_DB_URL" -X -At -c "select current_database()") || fail "TEST_DB_URL does not connect"
  echo "test database: $(echo "$TEST_DB_URL" | sed -E 's#://[^@]*@#://***@#') ($ref)"
}

point1() {
  say "Point 1: Worker CPU and 429 failover (mocked providers)"
  (cd "$ROOT/workers/cf-boost-extractor" && node --experimental-strip-types --no-warnings --test \
    --test-name-pattern="(429 failover|chain order|every provider|OpenRouter|Google answers|CPU)" test/*.test.mjs) | tee "$WORK_DIR/point1.tap" | grep -E "^(not )?ok|cpu:|# (pass|fail)"
  grep -q "^# fail 0" "$WORK_DIR/point1.tap" || fail "point 1"
}

point2() {
  say "Point 2: ungrounded quotes are blocked before ingress"
  (cd "$ROOT/workers/cf-boost-extractor" && node --experimental-strip-types --no-warnings --test \
    --test-name-pattern="(quote_on_page|quote must state|schema)" test/*.test.mjs) | tee "$WORK_DIR/point2.tap" | grep -E "^(not )?ok|# (pass|fail)"
  grep -q "^# fail 0" "$WORK_DIR/point2.tap" || fail "point 2"
}

point3() {
  say "Point 3: bulk ingestion benchmark and promotion rehearsal"
  guard_test_db
  for f in 001_boost_inbound_staging.sql 002_boost_promote.sql; do psql "$TEST_DB_URL" -X -q -v ON_ERROR_STOP=1 -1 -f "$ROOT/sql/boost-ingestion/$f"; done
  local file="$WORK_DIR/results-1000.ndjson"
  python3 - "$file" <<'PY'
import json, sys, uuid, datetime
now = datetime.datetime.now(datetime.timezone.utc).isoformat()
with open(sys.argv[1], "w") as f:
    for i in range(1000):
        f.write(json.dumps({"kind": "result", "batch_id": "harness-bench-1000", "item_key": f"sl-{i}", "lane": "study_load", "entity": "course",
            "entity_id": str(uuid.uuid4()), "evidence_id": None, "source_url": "https://example.edu/course", "provider": "groq", "model": "llama-3.3-70b-versatile",
            "prompt_id": "boost-study-load", "prompt_version": "boost-study-load-v1", "prompt_sha256": "a" * 64, "selector": "lean-sections-v3",
            "answer": {"study_load": "full_time", "quote": "3 years full-time"}, "verdict": {"ok": True, "problems": [], "quotes_checked": 1},
            "status": "verified", "attempts": [{"provider": "groq", "status": 200}], "at": now}) + "\n")
PY
  local before after t0 t1 secs
  before=$(psql "$TEST_DB_URL" -X -At -c "select md5(coalesce(string_agg(id::text || ':' || updated_at::text, ',' order by id), '')) from catalogue.courses")
  t0=$(date +%s.%N)
  psql "$TEST_DB_URL" -X -At -v ON_ERROR_STOP=1 -f "$ROOT/sql/boost-ingestion/003_load_results.sql" < "$file" | tail -2
  t1=$(date +%s.%N); secs=$(python3 -c "print(round($t1-$t0,3))")
  after=$(psql "$TEST_DB_URL" -X -At -c "select md5(coalesce(string_agg(id::text || ':' || updated_at::text, ',' order by id), '')) from catalogue.courses")
  echo "1,000 rows loaded in ${secs} s (one transaction)"
  python3 -c "import sys; sys.exit(0 if $secs < 5 else 1)" || fail "bulk load took ${secs} s (limit 5 s)"
  [ "$before" = "$after" ] || fail "catalogue.courses updated_at moved during the load"
  echo "catalogue.courses updated_at: unchanged"
  psql "$TEST_DB_URL" -X -q -c "delete from pipeline.boost_inbound_staging where batch_id = 'harness-bench-1000'"   # test project only
  psql "$TEST_DB_URL" -X -v ON_ERROR_STOP=1 -f "$ROOT/sql/boost-ingestion/004_rehearsal.sql" | tee "$WORK_DIR/point3-rehearsal.txt" | grep -E "NOTICE|q[1-5] |courses \|"
  grep -qE "courses \|\s+1 \|\s+0" "$WORK_DIR/point3-rehearsal.txt" || fail "rehearsal: expected 1 study load written and no updated_at touched"
  # the 50-item shadow-only check and the bulk load, in one block that always rolls back (005)
  local r; r=$(psql "$TEST_DB_URL" -X -f "$ROOT/sql/boost-ingestion/005_rehearsal_rolled_back.sql" 2>&1 | grep -o 'BOOST_REHEARSAL .*' | sed 's/^BOOST_REHEARSAL //')
  echo "005: $r" | tee "$WORK_DIR/point3-005.json"
  python3 - "$r" <<'PY' || fail "005: shadow-only check or bulk load did not pass"
import json, sys
r = json.loads(sys.argv[1])
ok = r["bulk_1000"]["under_5s"] and r["shadow_50"]["courses_changed"] == 0 and r["shadow_50"]["result"]["by_state"].get("admitted", 0) == 0 \
     and r["study_load_written"] == 1 and r["updated_at_touched"] == 0 and r["outside_window"] == "refused"
sys.exit(0 if ok else 1)
PY
}

point4() {
  say "Point 4: consolidation rehearsal of every live migration on the empty test project"
  guard_test_db
  [ -n "${PROD_RO_URL:-}" ] || fail "PROD_RO_URL (read-only production role) is not set"
  case "$PROD_RO_URL" in *"$PROD_REF"*) ;; *) fail "PROD_RO_URL must be production ($PROD_REF)";; esac
  [ "$(psql "$TEST_DB_URL" -X -At -c "select count(*) from pg_namespace where nspname in ('pipeline','catalogue')")" = "0" ] || fail "the test project is not empty (pipeline or catalogue exists)"
  local mig="$WORK_DIR/migrations"; rm -rf "$mig"; mkdir -p "$mig"
  # export in pages, each page its own read-only transaction under 20 s; the live record is the source (the repository holds only part of it)
  local after="0" n=0 page
  while :; do
    page=$(psql "$PROD_RO_URL" -X -At -v ON_ERROR_STOP=1 -c "begin; set transaction read only; set local statement_timeout = '20s';
      select coalesce(json_agg(json_build_object('v', version, 'n', name, 's', statements) order by version), '[]') from (
        select version, name, statements from supabase_migrations.schema_migrations where version > '$after' order by version limit 50) x; rollback;" | grep '^\[')
    [ "$page" = "[]" ] && break
    after=$(python3 - "$mig" "$page" <<'PY'
import json, sys, re
d, rows = sys.argv[1], json.loads(sys.argv[2])
for r in rows:
    name = re.sub(r"[^A-Za-z0-9_]+", "_", r["n"] or "unnamed")
    with open(f"{d}/{r['v']}_{name}.sql", "w") as f:
        for s in r["s"] or []:
            f.write(s.rstrip().rstrip(";") + ";\n")
print(rows[-1]["v"])
PY
)
    n=$((n + $(python3 -c "import json,sys; print(len(json.loads(sys.argv[1])))" "$page")))
  done
  echo "exported $n live migrations to $mig (repository holds $(ls "${PILOT_DIR:-$ROOT/../coursefinder-pilot}/supabase/migrations" 2>/dev/null | grep -c '\.sql$' || echo '?') files)"
  local ok=0 bad=0 first_bad=""
  for f in $(ls "$mig" | sort); do
    if psql "$TEST_DB_URL" -X -q -v ON_ERROR_STOP=1 -1 -f "$mig/$f" > "$WORK_DIR/apply.log" 2>&1; then ok=$((ok + 1))
    else bad=$((bad + 1)); [ -z "$first_bad" ] && first_bad="$f"; echo "failed: $f ($(grep -m1 ERROR "$WORK_DIR/apply.log"))" | tee -a "$WORK_DIR/point4-failures.txt"
      [ "${CONTINUE_ON_ERROR:-0}" = "1" ] || break; fi
  done
  echo "applied $ok, failed $bad${first_bad:+ (first: $first_bad)}"
  [ "$bad" = "0" ] || fail "consolidation rehearsal stopped (set CONTINUE_ON_ERROR=1 to list every failure)"
  local g3; g3=$(psql "$TEST_DB_URL" -X -At -c "begin; select security.consumer_api_check_v1()::text; rollback;" | grep '^{')
  echo "G3: $g3"
  python3 - "$g3" <<'PY' || fail "G3 does not match (75 functions, 48 relations, no drift)"
import json, sys
g = json.loads(sys.argv[1]); sys.exit(0 if g.get("drift") == [] and g.get("functions") == 75 and g.get("relations") == 48 else 1)
PY
  local pilot="${PILOT_DIR:-}"; [ -n "$pilot" ] || for c in "$ROOT/../Coursefinder-Pilot" "$ROOT/../coursefinder-pilot"; do [ -d "$c" ] && pilot="$c"; done
  [ -d "$pilot" ] || fail "PILOT_DIR not found"
  (cd "$pilot" && npx playwright test --grep-invert @deployed --reporter=line) || fail "Pilot local suite"
}

case "$POINT" in
  1) point1;; 2) point2;; 3) point3;; 4) point4;;
  all) point1; point2; point3; point4;;
  *) fail "usage: $0 [1|2|3|4|all]";;
esac
say "done: point(s) $POINT passed"
