#!/usr/bin/env python3
"""CF-247 S2 - BOOST: non-interactive runs on the throwaway test project coursefinder-boost-test, and read-only checks of production
(Platform Admin 17 Nov 2026 22:05: database and test-project runs go through GitHub Actions, never through a tool that asks for confirmation).

  prodcheck          production, read only: migration head, G3 (security.consumer_api_check_v1) and the md5 of security.boost_promote_v1
  copyfn SIGNATURE   read one function's definition from production (read only) and create it on the test project, then compare the md5 values
  run FILE LABEL     run a SQL file on the test project with {{RUN_LABEL}} replaced; the last statement's rows are kept
  verdict LABEL      PASS or FAIL for an admitted-count run (sql/boost-experiments/admitted-count.sql)
  benchmark LABEL    replay a production Boost model benchmark run (pipeline.boost_benchmark_items, read only) on the test project: seed its
                     courses, load each model's answers as that model's own batch with only that model qualified (test project only), run
                     security.boost_promote_v1, and report per model and country; the seeded courses and the qualification are removed after

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


def benchmark(label):
    br.guard()
    if not re.fullmatch(r"[a-z0-9-]{3,40}", label): sys.exit("refused: the label is lower-case letters, digits and hyphens")
    rows, off = [], 0
    while True:  # production, read only, in pages
        r = br.prod_read("select i.item_key, i.entity_id, i.evidence_id, i.country_code, i.model_code, i.model_identifier, i.state, i.selector, i.answer, i.verdict, "
                         "i.input_tokens, i.output_tokens, i.cost, i.ms, i.source_url, c.provider_id from pipeline.boost_benchmark_items i "
                         f"join catalogue.courses c on c.id = i.entity_id where i.run_label = '{label}' and i.state in ('verified', 'rejected', 'failed', 'no_signal') "
                         f"order by i.id limit 500 offset {off}")
        rows += r
        if len(r) < 500: break
        off += 500
    left = br.prod_read(f"select count(*) n from pipeline.boost_benchmark_items where run_label = '{label}' and state in ('queued', 'claimed')")[0]["n"]
    if not rows: keep("benchmark", {"label": label, "error": "no finished benchmark rows on production", "left": left}); sys.exit(1)
    lit = lambda v: "'" + str(v).replace("'", "''") + "'"
    courses = {r["entity_id"]: (r["provider_id"], r["country_code"]) for r in rows}
    providers = {p: cc for (p, cc) in courses.values()}
    seed = ("insert into pim.entity_registry (id, entity_type, stable_key) values "
            + ", ".join(f"({lit(p)}, 'provider', {lit('boostbench:provider:' + p)})" for p in providers) + " on conflict do nothing;\n"
            + "insert into pim.entity_registry (id, entity_type, stable_key) values "
            + ", ".join(f"({lit(c)}, 'course', {lit('boostbench:course:' + c)})" for c in courses) + " on conflict do nothing;\n"
            + "insert into catalogue.providers (id, stable_key, canonical_name, country_id) select v.id::uuid, 'boostbench:provider:' || v.id, 'Boost benchmark provider ' || left(v.id, 8), k.id from (values "
            + ", ".join(f"({lit(p)}, {lit(cc)})" for p, cc in providers.items()) + ") v(id, cc) join ref.countries k on k.iso_alpha2 = v.cc on conflict do nothing;\n"
            + "insert into catalogue.courses (id, stable_key, provider_id, canonical_title) select v.id::uuid, 'boostbench:course:' || v.id, v.p::uuid, 'Boost benchmark course ' || left(v.id, 8) from (values "
            + ", ".join(f"({lit(c)}, {lit(p)})" for c, (p, cc) in courses.items()) + ") v(id, p) on conflict do nothing;\n"
            + "select (select count(*) from catalogue.courses where stable_key like 'boostbench:%') courses")
    ok, r = br.q(br.REF, seed)
    if not ok: keep("benchmark", {"label": label, "error": "seed failed: " + str(r)[:600]}); sys.exit(1)
    seeded = r[0]["courses"] if r else None
    med = lambda xs: (sorted(xs)[len(xs) // 2] if xs else None)
    models, report = {}, []
    for r in rows: models.setdefault(r["model_code"], r["model_identifier"])
    for code, ident in sorted(models.items()):
        mine = [r for r in rows if r["model_code"] == code]
        batch = f"{label}-{re.sub(r'[^a-z0-9-]', '-', code)}"
        payload = json.dumps([{"item_key": r["item_key"], "entity_id": r["entity_id"], "evidence_id": r["evidence_id"], "source_url": r["source_url"], "selector": r["selector"],
                               "answer": r["answer"], "verdict": r["verdict"] or {"problems": []}, "state": r["state"]} for r in mine])
        sql = (f"delete from pipeline.boost_inbound_staging where batch_id = {lit(batch)};\n"
               "update catalogue.courses set study_load = null, study_load_source = null, study_load_evidence_id = null where stable_key like 'boostbench:%' and study_load is not null;\n"
               "delete from pipeline.boost_model_qualifications;\n"
               f"insert into pipeline.boost_model_qualifications (lane, provider, model, qualified_by, qualified_at, reason) values ('study_load', 'openrouter', {lit(ident)}, null, now(), 'S2 - BOOST benchmark replay on the test project only');\n"
               "insert into pipeline.boost_inbound_staging (batch_id, item_key, lane, entity, entity_id, evidence_id, source_url, provider, model, prompt_id, prompt_version, prompt_sha256, selector, answer, verdict, worker_status, attempts, worker_at)\n"
               f"select {lit(batch)}, j->>'item_key', 'study_load', 'course', (j->>'entity_id')::uuid, (j->>'evidence_id')::uuid, j->>'source_url', 'openrouter', {lit(ident)}, 'boost-study-load', 'boost-study-load-v1', repeat('0', 64),\n"
               "       j->>'selector', j->'answer', j->'verdict', case when j->>'state' in ('verified', 'no_signal') then 'verified' when j->>'state' = 'rejected' then 'rejected' else 'failed' end, '[]'::jsonb, now()\n"
               f"  from jsonb_array_elements($boostbench${payload}$boostbench$::jsonb) j;\n"
               "create temp table if not exists boost_bench_out (v jsonb, ms numeric); truncate boost_bench_out;\n"
               f"do $x$ declare t0 timestamptz := clock_timestamp(); v jsonb; begin v := security.boost_promote_v1({lit(batch)}, false, '2026-11-18 02:00+11'::timestamptz); insert into boost_bench_out values (v, extract(epoch from clock_timestamp() - t0) * 1000); end $x$;\n"
               "select json_build_object('promote', (select v from boost_bench_out), 'promote_ms', (select round(ms, 1) from boost_bench_out),\n"
               "  'filled_by_country', (select coalesce(json_object_agg(cc, n), '{}'::json) from (select k.iso_alpha2 cc, count(*) n from catalogue.courses c join catalogue.providers p on p.id = c.provider_id join ref.countries k on k.id = p.country_id\n"
               "     where c.stable_key like 'boostbench:%' and c.study_load is not null group by 1) x)) r")
        if "$boostbench$" in payload: keep("benchmark", {"label": label, "error": "an answer holds the quoting tag"}); sys.exit(1)
        ok, res = br.q(br.REF, sql)
        out = (res[0]["r"] if ok and res else {"error": str(res)[:600]})
        filled = out.get("filled_by_country") or {}
        for cc in sorted({r["country_code"] for r in mine}) + ["ALL"]:
            g = [r for r in mine if cc == "ALL" or r["country_code"] == cc]
            calls = [r for r in g if r["state"] in ("verified", "rejected", "failed")]
            val = [r for r in g if r["state"] == "verified" and (r["answer"] or {}).get("study_load")]
            cost = sum(float(r["cost"] or 0) for r in g)
            adm = sum(filled.values()) if cc == "ALL" else filled.get(cc, 0)
            ms = [r["ms"] for r in calls if r["ms"] is not None]
            report.append({"model": code, "country": cc, "pages": len(g), "model_calls": len(calls), "verified_with_value": len(val),
                           "verified_not_stated": sum(1 for r in g if r["state"] == "verified") - len(val), "rejected": sum(1 for r in g if r["state"] == "rejected"),
                           "failed": sum(1 for r in g if r["state"] == "failed"), "no_signal": sum(1 for r in g if r["state"] == "no_signal"),
                           "admitted_courses": adm, "promotion_pass_rate_of_pages": round(adm / len(g), 4) if g else None,
                           "input_tokens": sum(int(r["input_tokens"] or 0) for r in g), "output_tokens": sum(int(r["output_tokens"] or 0) for r in g),
                           "cost_usd": round(cost, 6), "cost_usd_per_admitted_field": round(cost / adm, 6) if adm else None,
                           "median_ms_per_call": med(ms), "calls_per_second_one_at_a_time": round(1000 / med(ms), 2) if ms and med(ms) else None,
                           **({"promote": out.get("promote"), "promote_ms": out.get("promote_ms"), "error": out.get("error")} if cc == "ALL" else {})})
    # agreement: pages every model answered with a verified value
    by_page = {}
    for r in rows:
        if r["state"] == "verified" and (r["answer"] or {}).get("study_load"): by_page.setdefault(r["item_key"], {})[r["model_code"]] = r["answer"]["study_load"]
    full = [v for v in by_page.values() if len(v) == len(models)]
    agree = {"models": sorted(models), "pages_with_a_value_from_any_model": len(by_page), "pages_with_a_value_from_every_model": len(full),
             "of_those_all_agree": sum(1 for v in full if len(set(v.values())) == 1)}
    br.q(br.REF, "delete from pipeline.boost_model_qualifications; delete from pim.entity_registry where stable_key like 'boostbench:%'; select 1")
    ok, chk = br.q(br.REF, "select json_build_object('quals', (select count(*) from pipeline.boost_model_qualifications), 'bench_courses_left', (select count(*) from catalogue.courses where stable_key like 'boostbench:%'), 'g3', security.consumer_api_check_v1()) r")
    keep("benchmark", {"label": label, "production_rows_read": len(rows), "production_rows_left": left, "courses_seeded": seeded, "report": report, "agreement": agree,
                       "after": chk[0]["r"] if ok and chk else str(chk)[:300]})


if __name__ == "__main__":
    cmd, args = sys.argv[1], sys.argv[2:]
    {"prodcheck": lambda: prodcheck(), "copyfn": lambda: copyfn(args[0]), "run": lambda: run(args[0], args[1]), "verdict": lambda: verdict(args[0]), "benchmark": lambda: benchmark(args[0])}[cmd]()
