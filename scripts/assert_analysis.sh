#!/usr/bin/env bash
#
# Assert that a sample was actually analysed by SonarQube, that its coverage report was imported, and that the rules it is meant to demonstrate still fire.
#
# A scanner run exits 0 even when the coverage report is unresolvable, since Sonar logs an error and moves on.
# Without this check a broken coverage path is invisible in CI, which is exactly how these samples regress.
#
# The issue-count floor catches the opposite failure: these samples exist to show a populated dashboard, so a sample that analyses cleanly has failed at its job.
#
# The rule check is the strictest of the three.
# docs/rules.md claims specific rules fire, and without this check a rule could be retired and replaced by an unrelated one, leaving the count intact and the documentation quietly wrong.
#
# Usage:
#   SONAR_TOKEN=... ./scripts/assert_analysis.sh <projectKey> [minCoverage] [minViolations] [requiredRules]
#
# requiredRules is a comma-separated list of full rule keys, for example:
#   "javascript:S2068,javascript:S4790"
#
set -euo pipefail

PROJECT_KEY="${1:?usage: assert_analysis.sh <projectKey> [minCoverage] [minViolations] [requiredRules]}"
MIN_COVERAGE="${2:-0.1}"
MIN_VIOLATIONS="${3:-1}"
REQUIRED_RULES="${4:-}"
SONAR_HOST="${SONAR_HOST:-http://localhost:9000}"
: "${SONAR_TOKEN:?SONAR_TOKEN must be set}"
TIMEOUT_SECONDS="${SONAR_TIMEOUT_SECONDS:-180}"

api() { curl -sf -u "${SONAR_TOKEN}:" "$@"; }

echo "==> Waiting for SonarQube to finish processing '${PROJECT_KEY}'"
deadline=$((SECONDS + TIMEOUT_SECONDS))
while true; do
  ce=$(api "${SONAR_HOST}/api/ce/component?component=${PROJECT_KEY}" || echo '{}')
  state=$(printf '%s' "${ce}" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
except Exception:
    print("UNKNOWN"); raise SystemExit
if d.get("queue"):
    print("PENDING")
else:
    print((d.get("current") or {}).get("status", "NONE"))
')
  case "${state}" in
    SUCCESS) echo "    analysis report processed"; break ;;
    FAILED|CANCELED)
      echo "ERROR: background task for '${PROJECT_KEY}' ended with status ${state}." >&2
      exit 1
      ;;
  esac
  if [ "${SECONDS}" -ge "${deadline}" ]; then
    echo "ERROR: '${PROJECT_KEY}' was not processed within ${TIMEOUT_SECONDS}s (last state: ${state})." >&2
    exit 1
  fi
  sleep 3
done

echo "==> Checking measures for '${PROJECT_KEY}'"
measures=$(api "${SONAR_HOST}/api/measures/component?component=${PROJECT_KEY}&metricKeys=ncloc,coverage,violations")

printf '%s' "${measures}" \
  | MIN_COVERAGE="${MIN_COVERAGE}" MIN_VIOLATIONS="${MIN_VIOLATIONS}" PROJECT_KEY="${PROJECT_KEY}" python3 -c '
import json, os, sys

min_coverage = float(os.environ["MIN_COVERAGE"])
min_violations = int(os.environ["MIN_VIOLATIONS"])
project_key = os.environ["PROJECT_KEY"]

data = json.load(sys.stdin)
measures = {m["metric"]: m["value"] for m in data["component"]["measures"]}

ncloc = int(measures.get("ncloc", 0))
coverage = float(measures.get("coverage", -1))
violations = int(measures.get("violations", 0))

print(f"    ncloc={ncloc} coverage={coverage} violations={violations}")

errors = []
if ncloc <= 0:
    errors.append("no lines of code were analysed, check sonar.sources")
if coverage < 0:
    errors.append("no coverage measure at all, the report was never imported")
elif coverage < min_coverage:
    errors.append(
        f"coverage {coverage} is below the expected minimum {min_coverage}, "
        "the coverage report path is probably wrong"
    )
if violations < min_violations:
    errors.append(
        f"only {violations} issues raised, expected at least {min_violations}, "
        "the deliberate issues in this sample no longer trigger any rule"
    )

if errors:
    print(f"ERROR: {project_key} failed validation:", file=sys.stderr)
    for e in errors:
        print(f"  - {e}", file=sys.stderr)
    raise SystemExit(1)
'

if [ -z "${REQUIRED_RULES}" ]; then
  echo "    OK: ${PROJECT_KEY}"
  exit 0
fi

# Security Hotspots are not returned by /api/issues/search, they live behind their own endpoint.
# Both have to be queried to see every rule that fired.
echo "==> Checking that the documented rules still fire for '${PROJECT_KEY}'"
fired=$(
  {
    api "${SONAR_HOST}/api/issues/search?componentKeys=${PROJECT_KEY}&ps=500&resolved=false" \
      | python3 -c 'import json,sys; [print(i["rule"]) for i in json.load(sys.stdin)["issues"]]'
    api "${SONAR_HOST}/api/hotspots/search?projectKey=${PROJECT_KEY}&ps=500" \
      | python3 -c 'import json,sys; [print(h["ruleKey"]) for h in json.load(sys.stdin).get("hotspots",[])]'
  } | sort -u
)

printf '%s' "${fired}" | REQUIRED_RULES="${REQUIRED_RULES}" PROJECT_KEY="${PROJECT_KEY}" python3 -c '
import os, sys

project_key = os.environ["PROJECT_KEY"]
required = [r.strip() for r in os.environ["REQUIRED_RULES"].split(",") if r.strip()]
fired = {line.strip() for line in sys.stdin if line.strip()}

missing = [r for r in required if r not in fired]

print(f"    {len(fired)} distinct rules fired; {len(required)} required")
if missing:
    print(f"ERROR: {project_key} no longer raises documented rules:", file=sys.stderr)
    for r in missing:
        print(f"  - {r}", file=sys.stderr)
    print("  Either the rule was retired or renamed, or the sample code stopped triggering it.", file=sys.stderr)
    print("  Re-verify and update docs/rules.md.", file=sys.stderr)
    raise SystemExit(1)

print(f"    OK: {project_key}")
'
