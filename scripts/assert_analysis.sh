#!/usr/bin/env bash
#
# Asserts that a sample was analysed, that its coverage and test reports were imported, and that the rules it demonstrates still fire.
#
# A scanner exits 0 even when it cannot import the coverage report, so the exit code proves nothing.
# The rule check catches a rule retired in a SonarQube release, which would otherwise leave docs/results.md quietly wrong.
#
# Usage: SONAR_TOKEN=<token> ./scripts/assert_analysis.sh <projectKey> [minCoverage] [minIssues] [rule,rule,...]
#
set -euo pipefail

PROJECT_KEY="${1:?usage: assert_analysis.sh <projectKey> [minCoverage] [minIssues] [rule,rule,...]}"
MIN_COVERAGE="${2:-0.1}"
MIN_ISSUES="${3:-1}"
REQUIRED_RULES="${4:-}"
SONAR_HOST="${SONAR_HOST:-http://localhost:9000}"
: "${SONAR_TOKEN:?SONAR_TOKEN must be set}"
TIMEOUT_SECONDS="${SONAR_TIMEOUT_SECONDS:-180}"

api() { curl -sf -u "${SONAR_TOKEN}:" "${SONAR_HOST}$1"; }

# Prints the values of a JSON string field, one per line, which is enough for the flat fields read here
field() { grep -o "\"$1\":\"[^\"]*\"" | cut -d'"' -f4 || true; }

echo "==> Waiting for SonarQube to finish processing '${PROJECT_KEY}'"
deadline=$((SECONDS + TIMEOUT_SECONDS))
while true; do
  ce=$(api "/api/ce/component?component=${PROJECT_KEY}" || echo '{}')
  # The queue holds the pending analyses, and "current" the last finished one
  if [[ "${ce}" == *'"queue":[]'* ]]; then
    state=$(printf '%s' "${ce}" | field status | head -n 1)
  else
    state=PENDING
  fi
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
[ "${issues:-0}" -ge "${MIN_ISSUES}" ] || errors+=("only ${issues:-0} issues, expected at least ${MIN_ISSUES}")

# Security Hotspots are not returned by /api/issues/search, they have their own endpoint
if [ -n "${REQUIRED_RULES}" ]; then
  echo "==> Checking that the documented rules still fire for '${PROJECT_KEY}'"
  fired=$(
    {
      api "/api/issues/search?componentKeys=${PROJECT_KEY}&ps=500&resolved=false" | field rule
      api "/api/hotspots/search?projectKey=${PROJECT_KEY}&ps=500" | field ruleKey
    } | sort -u
  )
  IFS=',' read -r -a required <<< "${REQUIRED_RULES}"
  echo "    $(printf '%s\n' "${fired}" | grep -c .) distinct rules fired, ${#required[@]} required"
  for rule in "${required[@]}"; do
    grep -qxF "${rule}" <<< "${fired}" || errors+=("${rule} no longer fires, re-verify and update docs/results.md")
  done
fi

if [ "${#errors[@]}" -gt 0 ]; then
  echo "ERROR: ${PROJECT_KEY} failed validation:" >&2
  printf '  - %s\n' "${errors[@]}" >&2
  exit 1
fi
echo "    OK: ${PROJECT_KEY}"
