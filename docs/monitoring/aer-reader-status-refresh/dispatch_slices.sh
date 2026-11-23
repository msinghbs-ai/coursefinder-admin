#!/usr/bin/env bash
# dispatch_slices.sh <pilot-worktree> <tag> <outfile> <slice.sql>...
# Runs every slice file in ONE rolled-back live dry run (db-migration-dry-run.yml, workflow_dispatch) on the Pilot branch s1-build-diag,
# after waiting until no other dry run is queued or running (a pull request's dry run is never displaced). Appends each slice's probe text
# (one line per slice) to <outfile>. Nothing is merged, applied or kept: every file runs inside BEGIN and is rolled back.
set -euo pipefail
wt="$1"; tag="$2"; out="$3"; shift 3; repo=msinghbs-ai/Coursefinder-Pilot; wf=db-migration-dry-run.yml
cd "$wt"; git fetch -q origin main; git checkout -q --detach origin/main
names=(); i=0
for src in "$@"; do f="20991123$(printf '%06d' $i)_diag_${tag}_$(printf '%03d' $i).sql"; cp "$src" "supabase/migrations/$f"; names+=("$f"); i=$((i+1)); done
git add -A supabase/migrations && git commit -q -m "diag $tag (read-only, never merged)"
busy() { gh api "repos/$repo/actions/workflows/$wf/runs?per_page=10" --jq '[.workflow_runs[]|select(.status!="completed")]|length'; }
for k in $(seq 1 90); do [ "$(busy)" = "0" ] && break; sleep 20; done
[ "$(busy)" = "0" ] || { echo "queue never cleared; skipped $tag" >&2; exit 3; }
git push -q -f origin HEAD:refs/heads/s1-build-diag; sleep 2
before=$(gh api "repos/$repo/actions/workflows/$wf/runs?event=workflow_dispatch&branch=s1-build-diag&per_page=1" --jq '.workflow_runs[0].id // 0')
list=$(IFS=,; echo "${names[*]}")
gh api -X POST "repos/$repo/actions/workflows/$wf/dispatches" -f ref=s1-build-diag -f "inputs[files]=$list" -f "inputs[probe]=current_setting('cf.diag', true)" -f "inputs[confirm_project]=fxcwkweaxjtknorudmwp"
for k in $(seq 1 60); do id=$(gh api "repos/$repo/actions/workflows/$wf/runs?event=workflow_dispatch&branch=s1-build-diag&per_page=1" --jq '.workflow_runs[0].id'); [ "$id" != "$before" ] && break; sleep 3; done
until [ "$(gh api repos/$repo/actions/runs/$id --jq .status)" = completed ]; do sleep 10; done
echo "run $id $(gh api repos/$repo/actions/runs/$id --jq .conclusion)" >&2
job=$(gh api repos/$repo/actions/runs/$id/jobs --jq '.jobs[0].id')
gh api repos/$repo/actions/jobs/$job/logs 2>/dev/null > "$out.raw.$tag"
python3 - "$out.raw.$tag" "$out" <<'PY'
import sys,json
raw=open(sys.argv[1],encoding='utf-8',errors='replace').read(); n=0
with open(sys.argv[2],'a') as o:
  for line in raw.splitlines():
    if 'CF-DRYRUN-ROLLED-BACK' in line and 'dry run passed' not in line and '::' not in line:
      m=line.split('CF-DRYRUN-ROLLED-BACK',1)[1].strip().split('\\nCONTEXT:')[0]
      try: m=json.loads('"'+m.replace('"','\\"').replace('\\\\"','\\"')+'"')
      except Exception: pass
      o.write(m.strip()+'\n'); n+=1
errs=[l for l in raw.splitlines() if '##[error]' in l or 'preflight: FAIL' in l]
print(n,'slices;',len(errs),'errors', file=sys.stderr)
for e in errs[:3]: print(e[:300], file=sys.stderr)
PY
