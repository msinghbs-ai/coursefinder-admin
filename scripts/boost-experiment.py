#!/usr/bin/env python3
"""CF-247 S2 - BOOST: non-interactive runs on the throwaway test project coursefinder-boost-test, and read-only checks of production
(Platform Admin 17 Nov 2026 22:05: database and test-project runs go through GitHub Actions, never through a tool that asks for confirmation).

  prodcheck          production, read only: migration head, G3 (security.consumer_api_check_v1) and the md5 of security.boost_promote_v1
  copyfn SIGNATURE   read one function's definition from production (read only) and create it on the test project, then compare the md5 values
  run FILE LABEL     run a SQL file on the test project with {{RUN_LABEL}} replaced; the last statement's rows are kept
  verdict LABEL      PASS or FAIL for an admitted-count run (sql/boost-experiments/admitted-count.sql)

It reuses scripts/boost-rebuild.py: the same guard (the target must be named coursefinder-boost-test and is never production or
coursefinder-demo) and the same read_only=true calls to production. Results are written under out/.
Environment: SUPABASE_ACCESS_TOKEN, REF (test project), PROD (fxcwkweaxjtknorudmwp)."""
import importlib.util, json, os, re, sys

_spec = importlib.util.spec_from_file_location("boost_rebuild", os.path.join(os.path.dirname(os.path.abspath(__file__)), "boost-rebuild.py"))
br = importlib.util.module_from_spec(_spec); _spec.loader.exec_module(br)
OUT = "out"; os.makedirs(OUT, exist_ok=True)
PROMOTE = "security.boost_promote_v1(text,boolean,timestamptz)"


def keep(name, obj):
    json.dump(obj, open(f"{OUT}/{name}.json", "w"), indent=1)
    print(f"{name}: {json.dumps(obj)[:1500]}", flush=True)


def prodcheck():
    res = {}
    for key, sql in (("head", "select max(version) v, count(*) n from supabase_migrations.schema_migrations"),
                     ("g3", "select security.consumer_api_check_v1() v"),
                     ("promote_md5", f"select md5(pg_catalog.pg_get_functiondef('{PROMOTE}'::regprocedure)) v"),
                     ("matrix", "select security.boost_country_category_check_v1() v")):
        try:
            r = br.prod_read(sql)
            res[key] = r[0] if r else None
        except RuntimeError as e:  # production's read-only role may not run every function; the refusal is kept, not hidden
            res[key] = {"error": str(e)[:400]}
    keep("prodcheck", res)


def copyfn(sig):
    br.guard()
    if not re.fullmatch(r"[a-z_]+\.[a-z0-9_]+\([a-z ,]*\)", sig): sys.exit("refused: not a function signature")
    d = br.prod_read(f"select pg_catalog.pg_get_functiondef('{sig}'::regprocedure) d, md5(pg_catalog.pg_get_functiondef('{sig}'::regprocedure)) m")[0]
    ok, r = br.q(br.REF, d["d"])
    okm, rm = br.q(br.REF, f"select md5(pg_catalog.pg_get_functiondef('{sig}'::regprocedure)) m")
    keep("copyfn", {"function": sig, "applied": ok, "error": None if ok else str(r)[:600], "production_md5": d["m"],
                    "test_md5": rm[0]["m"] if okm and rm else None, "same": bool(okm and rm and rm[0]["m"] == d["m"])})
    if not ok: sys.exit(1)


def run(path, label):
    br.guard()
    if not re.fullmatch(r"[a-z0-9-]{3,40}", label): sys.exit("refused: the label is lower-case letters, digits and hyphens")
    sql = open(path, encoding="utf-8", newline="").read().replace("{{RUN_LABEL}}", label)
    ok, r = br.q(br.REF, sql)
    name = os.path.basename(path)
    keep(f"run-{name}", {"file": name, "label": label, "ok": ok, "result": r if ok else None, "error": None if ok else str(r)[:4000]})
    if not ok: sys.exit(1)


def verdict(label):
    d = json.load(open(f"{OUT}/run-admitted-count.sql.json"))
    r = ((d.get("result") or [{}])[0] or {}).get("r") or {}
    cp = json.load(open(f"{OUT}/copyfn.json")) if os.path.exists(f"{OUT}/copyfn.json") else {}
    cases = {(c["scenario"], c["batch_rows"]): c for c in (r.get("cases") or [])}
    q = lambda n: cases.get(("qualified", n)) or {}
    g3 = r.get("g3") or {}
    checks = {
        "admitted_equals_courses_filled": bool(cases) and all(c["admitted_min"] == c["filled_min"] and c["admitted_max"] == c["filled_max"] for c in cases.values()),
        "60_admitted_for_60_courses_at_1000": q(1000).get("admitted_min") == 60 and q(1000).get("admitted_max") == 60 and q(1000).get("filled_min") == 60,
        "60_admitted_for_60_courses_at_5000": q(5000).get("admitted_min") == 60 and q(5000).get("admitted_max") == 60 and q(5000).get("filled_min") == 60,
        "duplicates_refused_not_admitted": (r.get("duplicate_rows_refused") or 0) > 0,
        "shadow_none_admitted": (cases.get(("shadow", 1000)) or {}).get("admitted_max") == 0 and (cases.get(("shadow", 1000)) or {}).get("filled_max") == 0,
        "held_courses_unchanged": bool(cases) and all(c["held_changed"] == 0 and c["updated_at_changed"] == 0 for c in cases.values()),
        "cohort_put_back": r.get("quals_after") == 0 and r.get("no_study_load_after") == 60,
        "g3_test_project": g3.get("drift") == [] and g3.get("functions") == 75 and g3.get("relations") == 48,
        "promotion_function_is_production": (not cp) or (cp.get("same") is True and cp.get("production_md5") == r.get("promote_md5")),
    }
    keep("verdict", {"label": label, "checks": checks, "result": "PASS" if all(checks.values()) else "FAIL"})
    if not all(checks.values()): sys.exit(1)


if __name__ == "__main__":
    cmd, args = sys.argv[1], sys.argv[2:]
    {"prodcheck": lambda: prodcheck(), "copyfn": lambda: copyfn(args[0]), "run": lambda: run(args[0], args[1]), "verdict": lambda: verdict(args[0])}[cmd]()
