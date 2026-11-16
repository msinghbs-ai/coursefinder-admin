#!/usr/bin/env python3
"""CF-247 Boost: rebuild the throwaway test project coursefinder-boost-test from a production schema dump (Platform Admin 16 Nov 2026 22:44).

Route (the migration replay cannot rebuild production: run 43851316573, document section 12):
  reset        drop every application schema on the TEST project and unschedule its cron jobs (refused unless the target is named
               coursefinder-boost-test and is neither production nor coursefinder-demo)
  schema FILE  apply a schema file (Pilot db-schema-dump output) statement by statement through the Management API; every failure listed
  data         copy reference and configuration tables from production (read only, 20 s per page) into the test project
  newer HEAD   apply production's migrations with a version above HEAD (the live head when the dump was taken), read only from production
  g3           security.consumer_api_check_v1() and counts on the test project
  sqlfile FILE run one SQL file on the test project as it is (001, 002, 005)

Every call to production is a Management API query with read_only=true. Results are written under out/.
Environment: SUPABASE_ACCESS_TOKEN, REF (test project), PROD (fxcwkweaxjtknorudmwp).
"""
import json, os, re, sys, time, urllib.request, urllib.error

API = os.environ.get("BOOST_API_BASE", "https://api.supabase.com/v1/projects")  # the override is for the offline test only
TOKEN, REF, PROD = os.environ["SUPABASE_ACCESS_TOKEN"], os.environ["REF"], os.environ.get("PROD", "fxcwkweaxjtknorudmwp")
DEMO = "gfryvshbeptxwbzjomhe"
OUT = "out"; os.makedirs(OUT, exist_ok=True)
SYSTEM = {"pg_catalog", "information_schema", "pg_toast", "auth", "storage", "realtime", "vault", "extensions", "supabase_migrations", "net", "cron",
          "graphql", "graphql_public", "pgsodium", "pgsodium_masks", "supabase_functions", "pgbouncer", "_realtime", "_analytics", "public"}
# reference and configuration data the platform's functions and later migrations expect (no catalogue rows, no customer data)
DATA_TABLES = ["ref.*", "security.roles", "pipeline.platform_toolset_settings", "pipeline.automation_catalogue", "pipeline.component_register",
               "pipeline.ai_service_routes", "pipeline.ai_model_catalogue", "pipeline.aer_prompt_versions", "pipeline.prompt_templates",
               "pipeline.layer4_field_registry", "pipeline.rollup_targets", "pipeline.admission_rules", "pipeline.admin_job_kinds",
               "pipeline.platform_toolsets", "pipeline.firecrawl_purpose_groups"]
PAGE = 500  # fixed: rows per copied page (request size), not an operational limit


def guard():
    if not re.fullmatch(r"[a-z]{20}", REF) or REF in (PROD, DEMO) or PROD != "fxcwkweaxjtknorudmwp":
        sys.exit("refused: the target must be a throwaway project, never production or coursefinder-demo")
    req = urllib.request.Request(f"{API}/{REF}", headers={"Authorization": f"Bearer {TOKEN}"})
    name = json.load(urllib.request.urlopen(req, timeout=30)).get("name")
    if name != "coursefinder-boost-test":
        sys.exit(f"refused: the target is named {name!r}")


def q(ref, sql, read_only=False, tries=3):
    body = json.dumps({"query": sql, **({"read_only": True} if read_only else {})}).encode()
    for t in range(tries):
        req = urllib.request.Request(f"{API}/{ref}/database/query", data=body, method="POST",
                                     headers={"Authorization": f"Bearer {TOKEN}", "Content-Type": "application/json"})
        try:
            return True, json.load(urllib.request.urlopen(req, timeout=180))
        except urllib.error.HTTPError as e:
            msg = e.read().decode(errors="replace")
            if e.code in (429, 502, 503, 504) and t < tries - 1:
                time.sleep(5 * (t + 1)); continue
            try: msg = json.loads(msg).get("message", msg)
            except Exception: pass
            return False, f"HTTP {e.code}: {msg}"
        except Exception as e:  # timeouts and resets
            if t < tries - 1: time.sleep(5 * (t + 1)); continue
            return False, f"{type(e).__name__}: {e}"


def prod_read(sql):
    if PROD != "fxcwkweaxjtknorudmwp": sys.exit("refused")
    ok, r = q(PROD, "set statement_timeout = '20s'; " + sql, read_only=True)
    if not ok: raise RuntimeError(r)
    return r


def split_sql(text):
    """Split a pg_dump file into statements, respecting quotes, dollar quotes and comments."""
    out, buf, i, n = [], [], 0, len(text)
    dollar, squote = None, False
    while i < n:
        c = text[i]
        if dollar:
            if text.startswith(dollar, i): buf.append(dollar); i += len(dollar); dollar = None; continue
            buf.append(c); i += 1; continue
        if squote:
            buf.append(c); i += 1
            if c == "'":
                if i < n and text[i] == "'": buf.append("'"); i += 1
                else: squote = False
            continue
        if text.startswith("--", i):
            j = text.find("\n", i); j = n if j < 0 else j; i = j; continue
        if c == "'": squote = True; buf.append(c); i += 1; continue
        if c == "$":
            m = re.match(r"\$[A-Za-z_]*\$", text[i:])
            if m: dollar = m.group(0); buf.append(dollar); i += len(dollar); continue
        if c == ";":
            s = "".join(buf).strip()
            if s: out.append(s + ";")
            buf = []; i += 1; continue
        buf.append(c); i += 1
    s = "".join(buf).strip()
    if s: out.append(s)
    return out


def reset():
    guard()
    ok, r = q(REF, "select nspname from pg_namespace where nspname not like 'pg_temp%' and nspname not like 'pg_toast_temp%'")
    if not ok: sys.exit(r)
    app = sorted(x["nspname"] for x in r if x["nspname"] not in SYSTEM)
    log = []
    log.append(("cron", q(REF, "do $x$ begin if to_regclass('cron.job') is not null then perform cron.unschedule(jobid) from cron.job; end if; end $x$;")))
    for s in app:
        log.append((s, q(REF, f'drop schema if exists "{s}" cascade')))
    # public: drop its objects, keep the schema and Supabase's grants
    log.append(("public", q(REF, "do $x$ declare r record; begin "
                "for r in select c.oid::regclass::text t from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'public' and c.relkind in ('r','v','m','p','f') loop execute 'drop ' || case (select relkind from pg_class where oid = r.t::regclass) when 'v' then 'view' when 'm' then 'materialized view' when 'f' then 'foreign table' else 'table' end || ' if exists ' || r.t || ' cascade'; end loop; "
                "for r in select p.oid::regprocedure::text f, p.prokind k from pg_proc p join pg_namespace n on n.oid = p.pronamespace where n.nspname = 'public' loop execute 'drop ' || case r.k when 'p' then 'procedure' when 'a' then 'aggregate' else 'function' end || ' if exists ' || r.f || ' cascade'; end loop; "
                "for r in select t.typname from pg_type t join pg_namespace n on n.oid = t.typnamespace where n.nspname = 'public' and t.typtype in ('e','c','d') and not exists (select 1 from pg_class c where c.reltype = t.oid) loop execute 'drop type if exists public.' || quote_ident(r.typname) || ' cascade'; end loop; end $x$;")))
    bad = [(k, v[1]) for k, v in log if not v[0]]
    json.dump({"dropped_schemas": app, "failures": bad}, open(f"{OUT}/reset.json", "w"), indent=1)
    print(f"reset: {len(app)} schemas dropped; {len(bad)} failures")


def apply_statements(stmts, label):
    ok_n, fails = 0, []
    chunk, size = [], 0
    def flush(ch):
        nonlocal ok_n
        if not ch: return
        ok, r = q(REF, "\n".join(ch))
        if ok: ok_n += len(ch); return
        for s in ch:  # isolate the failing statement(s)
            ok1, r1 = q(REF, s)
            if ok1: ok_n += 1
            else: fails.append({"statement": s[:300], "error": str(r1)[:400]})
    for s in stmts:
        chunk.append(s); size += len(s)
        if size > 150_000 or len(chunk) >= 200: flush(chunk); chunk, size = [], 0
    flush(chunk)
    json.dump({"applied": ok_n, "failed": len(fails), "failures": fails}, open(f"{OUT}/{label}.json", "w"), indent=1)
    print(f"{label}: {ok_n} statements applied, {len(fails)} failed")


def schema(path):
    guard()
    text = open(path, encoding="utf-8").read()
    apply_statements(split_sql(text), "schema-" + os.path.basename(path).replace(".sql", ""))


def tables_to_copy():
    names = []
    for t in DATA_TABLES:
        if t.endswith(".*"):
            r = prod_read(f"select coalesce(json_agg(schemaname || '.' || tablename order by tablename), '[]') l from pg_tables where schemaname = '{t[:-2]}'")
            names += r[0]["l"]
        else:
            names.append(t)
    return names


def data():
    guard()
    report = []
    for t in tables_to_copy():
        sch, tab = t.split(".")
        ok, ex = q(REF, f"select to_regclass('{t}') is not null as e")
        if not ok or not ex[0]["e"]:
            report.append({"table": t, "rows": 0, "error": "missing on the test project"}); continue
        q(REF, f"truncate {t} cascade")
        copied, off, err = 0, 0, None
        while True:
            try:
                r = prod_read(f"select coalesce(json_agg(x), '[]') j from (select * from {t} order by 1 limit {PAGE} offset {off}) x")
            except RuntimeError as e:
                err = f"read: {e}"[:300]; break
            rows = r[0]["j"]
            if not rows: break
            payload = json.dumps(rows).replace("$boostdata$", "")
            ok, res = q(REF, f"insert into {t} overriding system value select * from json_populate_recordset(null::{t}, $boostdata${payload}$boostdata$) on conflict do nothing")
            if not ok:
                ok, res = q(REF, f"insert into {t} select * from json_populate_recordset(null::{t}, $boostdata${payload}$boostdata$) on conflict do nothing")
            if not ok: err = str(res)[:300]; break
            copied += len(rows); off += PAGE
        report.append({"table": t, "rows": copied, **({"error": err} if err else {})})
    json.dump(report, open(f"{OUT}/data.json", "w"), indent=1)
    print(f"data: {sum(x['rows'] for x in report)} rows in {len(report)} tables; {sum(1 for x in report if 'error' in x)} with an error")


def newer(head, extra=""):
    guard()
    if not re.fullmatch(r"\d{14}", head): sys.exit("HEAD must be a 14-digit migration version")
    extras = [v for v in (x.strip() for x in extra.split(",")) if v]
    if any(not re.fullmatch(r"\d{14}", v) for v in extras): sys.exit("extra versions must be 14-digit migration versions")
    # versions above the dump's head, plus versions below it that reached production after the dump (a lower number merged later)
    extra_sql = (" or version in (" + ", ".join(f"'{v}'" for v in extras) + ")") if extras else ""
    r = prod_read(f"select coalesce(json_agg(json_build_object('v', version, 'n', name, 's', statements) order by version), '[]') p from supabase_migrations.schema_migrations where version > '{head}'{extra_sql}")
    rows, ok_n, fails = r[0]["p"], 0, []
    off = "do $cf$ begin if to_regclass('cron.job') is not null then perform cron.alter_job(j.jobid, active => false) from cron.job j where j.active; end if; end $cf$;"
    for m in rows:
        ok, res = q(REF, ";\n".join(s.rstrip().rstrip(";") for s in (m["s"] or [])) + ";\n" + off)
        if ok: ok_n += 1
        else: fails.append({"version": m["v"], "name": m["n"], "error": str(res)[:400]})
    q(REF, off)
    json.dump({"head": head, "newer": len(rows), "applied": ok_n, "failures": fails}, open(f"{OUT}/newer.json", "w"), indent=1)
    print(f"newer than {head}: {len(rows)} migrations, {ok_n} applied, {len(fails)} failed")


def g3():
    guard()
    ok, r = q(REF, "select json_build_object('g3', (select security.consumer_api_check_v1()), 'cron_active', (select count(*) from cron.job where active), "
                   "'security_functions', (select count(*) from pg_proc p join pg_namespace n on n.oid = p.pronamespace where n.nspname = 'security'), "
                   "'pipeline_tables', (select count(*) from pg_tables where schemaname = 'pipeline')) r")
    res = r[0]["r"] if ok else {"error": r}
    json.dump(res, open(f"{OUT}/g3.json", "w"), indent=1)
    print("g3:", json.dumps(res)[:400])


def sqlfile(path):
    guard()
    ok, r = q(REF, open(path, encoding="utf-8").read())
    name = os.path.basename(path)
    res = {"file": name, "ok": ok, "result": r if ok else None, "error": None if ok else str(r)[:4000]}
    m = re.search(r"BOOST_REHEARSAL (\{.*\})", "" if ok else str(r), re.S)
    if m:
        try: res["rehearsal"] = json.loads(m.group(1))
        except Exception: res["rehearsal_raw"] = m.group(1)[:3000]
    json.dump(res, open(f"{OUT}/sql-{name}.json", "w"), indent=1)
    print(f"{name}: {'ok' if ok else 'error'} {('' if ok else str(r)[:300])}")


if __name__ == "__main__":
    cmd, args = sys.argv[1], sys.argv[2:]
    {"reset": lambda: reset(), "schema": lambda: schema(args[0]), "data": lambda: data(), "newer": lambda: newer(args[0], args[1] if len(args) > 1 else ""),
     "g3": lambda: g3(), "sqlfile": lambda: sqlfile(args[0])}[cmd]()
