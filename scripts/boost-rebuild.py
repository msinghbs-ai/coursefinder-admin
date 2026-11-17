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
               "pipeline.platform_toolsets", "pipeline.consumer_api_baseline"]
# pipeline.consumer_api_baseline: the G3 baseline (75 functions, 48 relations); without it G3 reports every consumer function as added
# (run 43940610220). pipeline.firecrawl_purpose_groups was dropped from the list: production has no such table.
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


# duplicate table or sequence (42P07), second primary key (42P16), duplicate object (42710), column (42701) or function (42723), duplicate schema (42P06)
ALREADY = re.compile(r"\b(42P07|42P16|42710|42701|42723|42P06)\b")
SESSION_SET = re.compile(r"^\s*(SET\s+(?!LOCAL\b)(\w+)|SELECT\s+pg_catalog\.set_config\('([\w.]+)')", re.I)


def apply_statements(stmts, label):
    # Each batch is one API call, which is its own session. A schema dump sets its session first (check_function_bodies = false,
    # search_path = '', ...) and relies on it for every later statement: functions come before the tables they read. Run 43885548875
    # sent those settings in the first batch only, so 557 functions failed their body check and their 556 ALTER FUNCTION and 145
    # COMMENT statements failed after them. Every call now starts with the session settings in effect before its first statement and
    # ends with RESET ALL, so nothing carries into later calls on a reused connection.
    # A failed batch (one transaction) is split in half and each half retried (bisection); order is kept.
    settings, pre, prefix = {}, [], ""
    for st in stmts:  # pre[i]: the session settings in effect before statement i
        pre.append(prefix)
        m = SESSION_SET.match(st)
        if m:
            settings[(m.group(2) or m.group(3)).lower()] = st.strip().rstrip(";") + ";"
            prefix = "\n".join(settings.values()) + "\n"
    ok_n, fails, calls, present, committed = 0, [], 0, [], []
    ok0, r0 = q(REF, "create table if not exists public.boost_rebuild_marks (label text, lo int, hi int, at timestamptz default now(), primary key (label, lo, hi))")
    if not ok0: sys.exit(f"{label}: cannot create public.boost_rebuild_marks on the test project: {r0}")
    t0 = time.time()
    def run(lo, hi):
        nonlocal ok_n, calls
        if lo >= hi: return
        calls += 1
        # an explicit transaction: run 43991418340 showed the API commits a call statement by statement, so a call cut off part way (a
        # transient error and its retry) left half a batch behind and every later re-send failed with "already exists"
        # each call also records its batch in public.boost_rebuild_marks, in the same transaction (the probe showed the API keeps it all or
        # nothing): when a call fails, one look at the marks says whether it committed anyway (run 44004171402: replies lost after the
        # commit, then every re-send refused as "already exists" and split into single statements, about 200 extra calls each time)
        mark = f"insert into public.boost_rebuild_marks (label, lo, hi) values ('{label}', {lo}, {hi}) on conflict do nothing;"
        ok, r = q(REF, "BEGIN;\n" + pre[lo] + "\n".join(stmts[lo:hi]) + "\n" + mark + "\nCOMMIT;\nRESET ALL;")
        if ok: ok_n += hi - lo; return
        okm, rm = q(REF, f"select count(*) as n from public.boost_rebuild_marks where label = '{label}' and lo = {lo} and hi = {hi}")
        if okm and rm and int(rm[0].get("n", 0)) > 0:
            committed.append(lo); ok_n += hi - lo; return
        if hi - lo == 1:
            if ALREADY.search(str(r)):  # already in place (committed by an earlier, interrupted call): counted as applied, and listed
                present.append({"statement": stmts[lo][:200], "error": str(r)[:200]}); ok_n += 1; return
            fails.append({"statement": stmts[lo][:300], "error": str(r)[:400]}); return
        mid = (lo + hi) // 2
        run(lo, mid); run(mid, hi)
    def save(done):  # rewritten after every batch, so a step time-out still leaves the counts so far
        json.dump({"statements": len(stmts), "done": done, "applied": ok_n, "failed": len(fails), "calls": calls, "seconds": int(time.time() - t0),
                   "already_present": len(present), "present": present[:50], "committed_despite_error": len(committed), "failures": fails}, open(f"{OUT}/{label}.json", "w"), indent=1)
    save(0)
    lo, size = 0, 0
    for i, st in enumerate(stmts):
        size += len(st)
        if size > 150_000 or i + 1 - lo >= 200 or i + 1 == len(stmts):
            run(lo, i + 1); lo, size = i + 1, 0
            print(f"  {label}: {lo}/{len(stmts)} statements, {ok_n} applied, {len(fails)} failed, {calls} calls, {int(time.time() - t0)} s", flush=True)
            save(lo)
    print(f"{label}: {ok_n} statements applied, {len(fails)} failed ({calls} calls, {int(time.time() - t0)} s)", flush=True)


def probe():
    """Records whether a failed call with an explicit transaction leaves anything behind (test project only)."""
    guard()
    q(REF, "drop schema if exists boost_probe cascade; create schema boost_probe;")
    ok, r = q(REF, "BEGIN;\ncreate table boost_probe.t1 (id int);\nselect 1/0;\nCOMMIT;")
    ok2, r2 = q(REF, "select to_regclass('boost_probe.t1') is not null as left_behind")
    left = bool(ok2 and r2 and r2[0].get("left_behind"))
    q(REF, "drop schema if exists boost_probe cascade;")
    json.dump({"failed_call_error": str(r)[:200], "left_behind": left, "atomic": not left}, open(f"{OUT}/probe.json", "w"), indent=1)
    print(f"probe: an explicit transaction is {'all or nothing' if not left else 'NOT all or nothing (half a call stays)'}", flush=True)


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


def fk_order(tables):
    """Parents before children, by the foreign keys on the test project (run 43940610220 loaded ref.countries before ref.currencies)."""
    ok, r = q(REF, "select conrelid::regclass::text c, confrelid::regclass::text p from pg_constraint where contype = 'f' and conrelid <> confrelid")
    edges = {t: set() for t in tables}
    for e in (r if ok else []):
        if e["c"] in edges and e["p"] in edges: edges[e["c"]].add(e["p"])
    done, out = set(), []
    while len(out) < len(tables):
        ready = [t for t in tables if t not in done and edges[t] <= done]
        if not ready: ready = [t for t in tables if t not in done][:1]  # a cycle: take the next in list order; the retry passes cover it
        for t in ready: done.add(t); out.append(t)
    return out


def data():
    guard()
    report, pending = {}, []
    tables = fk_order(tables_to_copy())
    for t in tables:
        ok, ex = q(REF, f"select to_regclass('{t}') is not null as e")
        if not ok or not ex[0]["e"]:
            report[t] = {"table": t, "rows": 0, "error": "missing on the test project"}; continue
        q(REF, f"truncate {t} cascade")
        report[t] = {"table": t, "rows": 0}
        off = 0
        while True:
            try:
                r = prod_read(f"select coalesce(json_agg(x), '[]') j from (select * from {t} order by 1 limit {PAGE} offset {off}) x")
            except RuntimeError as e:
                report[t]["error"] = f"read: {e}"[:300]; break
            rows = r[0]["j"]
            if not rows: break
            ok, res = insert_page(t, rows)
            if ok: report[t]["rows"] += len(rows)
            elif "23503" in str(res): pending.append((t, rows, str(res)))  # a parent row not there yet (a self reference or a cycle): retried below
            else: report[t]["error"] = str(res)[:300]; break
            off += PAGE
    for _ in range(3):  # retry the pages that waited for a parent row
        if not pending: break
        left = []
        for t, rows, err in pending:
            ok, res = insert_page(t, rows)
            if ok: report[t]["rows"] += len(rows)
            else: left.append((t, rows, str(res)))
        if len(left) == len(pending): pending = left; break
        pending = left
    for t, rows, err in pending:
        report[t]["error"] = err[:300]; report[t]["rows_not_loaded"] = report[t].get("rows_not_loaded", 0) + len(rows)
    out = list(report.values())
    json.dump(out, open(f"{OUT}/data.json", "w"), indent=1)
    print(f"data: {sum(x['rows'] for x in out)} rows in {len(out)} tables (parents first); {sum(1 for x in out if 'error' in x)} with an error", flush=True)


def insert_page(t, rows):
    payload = json.dumps(rows).replace("$boostdata$", "")
    ok, res = q(REF, f"insert into {t} overriding system value select * from json_populate_recordset(null::{t}, $boostdata${payload}$boostdata$) on conflict do nothing")
    if not ok and "23503" not in str(res):
        ok, res = q(REF, f"insert into {t} select * from json_populate_recordset(null::{t}, $boostdata${payload}$boostdata$) on conflict do nothing")
    return ok, res


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
    {"reset": lambda: reset(), "probe": lambda: probe(), "schema": lambda: schema(args[0]), "data": lambda: data(), "newer": lambda: newer(args[0], args[1] if len(args) > 1 else ""),
     "g3": lambda: g3(), "sqlfile": lambda: sqlfile(args[0])}[cmd]()
