#!/usr/bin/env bash
#
# Asserts that a sample was analysed, that its coverage and test reports were imported, and that the rules it demonstrates still fire.
#
# A scanner exits 0 even when it cannot import the coverage report, so the exit code proves nothing.
# The rule check catches a rule retired in a SonarQube release, which would otherwise leave docs/results.md quietly wrong.
#
# The wait reads the task of the analysis from the report-task.txt the scanner writes,
# since an analysis token, such as the one IstarCI gives a job, may read a task but not the queue of a project.
#
# Usage: SONAR_TOKEN=<token> [SONAR_ASSERT_ISSUES=false] ./scripts/assert_analysis.sh <projectKey> <report-task.txt> [minCoverage] [minIssues] [rule,rule,...]
#
set -euo pipefail

USAGE="usage: assert_analysis.sh <projectKey> <report-task.txt> [minCoverage] [minIssues] [rule,rule,...]"
PROJECT_KEY="${1:?${USAGE}}"
REPORT_TASK="${2:?${USAGE}}"
MIN_COVERAGE="${3:-0.1}"
MIN_ISSUES="${4:-1}"
REQUIRED_RULES="${5:-}"
SONAR_HOST_URL="${SONAR_HOST_URL:-http://localhost:9000}"
: "${SONAR_TOKEN:?SONAR_TOKEN must be set}"
TIMEOUT_SECONDS="${SONAR_TIMEOUT_SECONDS:-180}"
# The issues and the rules depend on the quality profile, which only the SonarQube that sonar_bootstrap.sh prepares is known to have,
# so against another one, whose profile is unknown, SONAR_ASSERT_ISSUES=false checks that the analysis landed and no more.
ASSERT_ISSUES="${SONAR_ASSERT_ISSUES:-true}"

# The token goes through a config on stdin, since an argument is readable by every process of the machine
# A refusal names the call and its status, since curl alone only says it failed
api() {
  local code
  code=$(curl -s -o "${body}" -w '%{http_code}' -K - "${SONAR_HOST_URL}$1" <<< "user = \"${SONAR_TOKEN}:\"") || code=000
  if [ "${code}" != 200 ]; then
    echo "ERROR: HTTP ${code} from $1: $(head -c 300 "${body}")" >&2
    return 1
  fi
  cat "${body}"
}
body=$(mktemp)
trap 'rm -f "${body}"' EXIT

# Prints the values of a JSON string field, one per line, which is enough for the flat fields read here
field() { grep -o "\"$1\":\"[^\"]*\"" | cut -d'"' -f4 || true; }

if [ ! -s "${REPORT_TASK}" ]; then
  echo "ERROR: ${REPORT_TASK} is missing, '${PROJECT_KEY}' was not scanned" >&2
  exit 1
fi
task_id=$(grep '^ceTaskId=' "${REPORT_TASK}" | cut -d= -f2-)

echo "==> Waiting for SonarQube to finish processing '${PROJECT_KEY}' (task ${task_id})"
deadline=$((SECONDS + TIMEOUT_SECONDS))
while true; do
  state=$(api "/api/ce/task?id=${task_id}" | field status | head -n 1 || true)
  case "${state}" in
    SUCCESS) echo "    analysis report processed"; break ;;
    FAILED|CANCELED)
      echo "ERROR: background task for '${PROJECT_KEY}' ended with status ${state}" >&2
      exit 1
      ;;
  esac
  if [ "${SECONDS}" -ge "${deadline}" ]; then
    echo "ERROR: '${PROJECT_KEY}' was not processed within ${TIMEOUT_SECONDS}s (last state: ${state:-none})" >&2
    exit 1
  fi
  sleep 3
done

echo "==> Checking measures for '${PROJECT_KEY}'"
measures=$(api "/api/measures/component?component=${PROJECT_KEY}&metricKeys=ncloc,coverage,tests,violations")
measure() { printf '%s' "${measures}" | grep -o "\"metric\":\"$1\",\"value\":\"[^\"]*\"" | cut -d'"' -f8 || true; }
ncloc=$(measure ncloc)
coverage=$(measure coverage)
tests=$(measure tests)
issues=$(measure violations)
echo "    ncloc=${ncloc:-none} coverage=${coverage:-none} tests=${tests:-none} issues=${issues:-none}"

errors=()
[ "${ncloc:-0}" -gt 0 ] || errors+=("no lines of code were analysed, check sonar.sources")
if [ -z "${coverage}" ]; then
  errors+=("no coverage measure at all, the report was never imported")
elif awk -v c="${coverage}" -v m="${MIN_COVERAGE}" 'BEGIN { exit !(c < m) }'; then
  errors+=("coverage ${coverage} is below ${MIN_COVERAGE}, the coverage report path is probably wrong")
fi
[ "${tests:-0}" -gt 0 ] || errors+=("no test count, the test execution report was never imported")
if [ "${ASSERT_ISSUES}" = false ]; then
  echo "    issues and rules not checked, SONAR_ASSERT_ISSUES is false"
  MIN_ISSUES=0
  REQUIRED_RULES=""
fi
[ "${issues:-0}" -ge "${MIN_ISSUES}" ] || errors+=("only ${issues:-0} issues, expected at least ${MIN_ISSUES}")

# Security Hotspots are not returned by /api/issues/search, they have their own endpoint
if [ -n "${REQUIRED_RULES}" ]; then
  echo "==> Checking that the documented rules still fire for '${PROJECT_KEY}'"
  fired=$(
    {
      api "/api/issues/search?componentKeys=${PROJECT_KEY}&ps=500&resolved=false" | field rule
      api "/api/hotspots/search?project=${PROJECT_KEY}&ps=500" | field ruleKey
    } | sort -u
  )
  IFS=',' read -r -a required <<< "${REQUIRED_RULES}"
  echo "    $(printf '%s\n' "${fired}" | grep -c .) distinct rules fired, ${#required[@]} required"
  for rule in "${required[@]}"; do
    grep -qxF "${rule}" <<< "${fired}" || errors+=("${rule} no longer fires, re-verify and update docs/results.md")
  done
fi

if [ "${#errors[@]}" -gt 0 ]; then
  echo "    measures: ${measures}" >&2
  echo "ERROR: ${PROJECT_KEY} failed validation:" >&2
  printf '  - %s\n' "${errors[@]}" >&2
  exit 1
fi
echo "    OK: ${PROJECT_KEY}"
