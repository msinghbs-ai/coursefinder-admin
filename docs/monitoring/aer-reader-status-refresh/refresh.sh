#!/usr/bin/env bash
# refresh.sh <pilot-clone> <admin-clone> <work-dir>
# Daily AER University Reader Status refresh (S1-Build). Read-only: rolled-back live reads through the shared dry-run workflow.
# Produces <work-dir>/AER_University_Reader_Status.csv (with daily_admitted_delta against the admin main copy) and <work-dir>/sheet.json.
set -euo pipefail
pilot="$1"; admin="$2"; work="$3"; here="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$work"; rm -f "$work"/A.out* "$work"/B.out* "$work"/C.out "$work"/A_*.sql "$work"/B_*.sql "$work"/C_*.sql
wt="$work/pilot-diag-wt"
if [ ! -d "$wt" ]; then git -C "$pilot" fetch -q origin main; git -C "$pilot" worktree add -q --detach "$wt" origin/main; fi
for k in $(seq 0 89); do sed -e "s/@OFF@/$((k*24))/; s/@LIM@/24/; s/@K@/$k/" "$here/sliceA.sql.tmpl" > "$work/A_$(printf %02d $k).sql"; done
for k in $(seq 0 39); do sed -e "s/@OFF@/$((k*12))/; s/@LIM@/12/; s/@K@/$k/" "$here/sliceB.sql.tmpl" > "$work/B_$(printf %02d $k).sql"; done
bash "$here/dispatch_slices.sh" "$wt" a1 "$work/A.out" $(ls "$work"/A_*.sql | head -45)
bash "$here/dispatch_slices.sh" "$wt" a2 "$work/A.out" $(ls "$work"/A_*.sql | tail -45)
cp "$here/sliceC.sql.tmpl" "$work/C_00.sql"  # live coverage and guardrails for the daily digest, in the same dispatch
bash "$here/dispatch_slices.sh" "$wt" b1 "$work/B.out" $(ls "$work"/B_*.sql) "$work/C_00.sql"
grep '^C0~' "$work/B.out" > "$work/C.out" || { echo "the live coverage probe returned nothing" >&2; exit 6; }
git -C "$admin" fetch -q origin main
git -C "$admin" show origin/main:docs/monitoring/AER_University_Reader_Status.csv > "$work/prev.csv" 2>/dev/null || rm -f "$work/prev.csv"
[ "$(grep -c '^A[0-9]' "$work/A.out")" = 90 ] || { echo "A slices missing: $(grep -c '^A[0-9]' "$work/A.out") of 90" >&2; exit 5; }
[ "$(grep -c '^B[0-9]' "$work/B.out")" = 40 ] || { echo "B slices missing: $(grep -c '^B[0-9]' "$work/B.out") of 40" >&2; exit 5; }
# the last A and B slices must be empty: otherwise the provider list outgrew the slice count
grep '^A[0-9]' "$work/A.out" | tail -n 1 | grep -qE '^A[0-9]+~?$' || { echo "the last A slice is not empty: raise the A slice count" >&2; exit 4; }
grep '^B[0-9]' "$work/B.out" | tail -n 1 | grep -qE '^B[0-9]+~?$' || { echo "the last B slice is not empty: raise the B slice count" >&2; exit 4; }
python3 "$here/build_register.py" --work "$work" --updated "$(TZ=Australia/Sydney date '+%Y-%m-%d %H:%M')" --out "$work/AER_University_Reader_Status.csv" --prev "$work/prev.csv" --sheet-json "$work/sheet.json"
