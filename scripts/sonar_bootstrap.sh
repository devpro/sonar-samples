#!/usr/bin/env bash
#
# Boot the local SonarQube stack and print a freshly generated user token.
#
# Used via `task bootstrap` and `task ci`, and usable directly:
#
#   export SONAR_TOKEN=$(./scripts/sonar_bootstrap.sh)
#
# Only the token goes to stdout; all progress output goes to stderr so the command above captures the token cleanly.
#
set -euo pipefail

SONAR_HOST_URL="${SONAR_HOST_URL:-http://localhost:9000}"
# SonarQube rejects passwords shorter than 12 characters.
SONAR_ADMIN_PASSWORD="${SONAR_ADMIN_PASSWORD:-SonarSamples2026!}"
TIMEOUT_SECONDS="${SONAR_TIMEOUT_SECONDS:-360}"
TOKEN_NAME="sonar-samples"
PROFILE="Sonar way comprehensive"

log() { echo "$*" >&2; }

if [ "${#SONAR_ADMIN_PASSWORD}" -lt 12 ]; then
  log "ERROR: SONAR_ADMIN_PASSWORD must be at least 12 characters (SonarQube policy)."
  exit 1
fi

log "==> Starting the SonarQube stack"
docker compose up -d >&2

log "==> Waiting for SonarQube to report UP (timeout ${TIMEOUT_SECONDS}s)"
deadline=$((SECONDS + TIMEOUT_SECONDS))
while true; do
  status=$(curl -sf "${SONAR_HOST_URL}/api/system/status" 2>/dev/null \
    | grep -o '"status":"[^"]*"' | cut -d'"' -f4 || true)
  if [ "${status}" = "UP" ]; then
    log "    status: UP"
    break
  fi
  if [ "${SECONDS}" -ge "${deadline}" ]; then
    log "ERROR: SonarQube did not become ready within ${TIMEOUT_SECONDS}s (last status: ${status:-unreachable})."
    docker compose logs --tail 80 sonarqube >&2 || true
    exit 1
  fi
  log "    status: ${status:-waiting}..."
  sleep 5
done

log "==> Setting the admin password (SonarQube ships with admin/admin)"
body=$(mktemp)
code=$(curl -s -o "${body}" -w '%{http_code}' -u admin:admin \
  -X POST "${SONAR_HOST_URL}/api/users/change_password" \
  --data-urlencode "login=admin" \
  --data-urlencode "previousPassword=admin" \
  --data-urlencode "password=${SONAR_ADMIN_PASSWORD}")

case "${code}" in
  204)
    log "    password changed"
    ;;
  401)
    # Default credentials rejected: the password was already changed on a previous run against the same volume
    # Carry on and let token generation below prove whether SONAR_ADMIN_PASSWORD is correct
    log "    default credentials rejected, assuming the password is already set"
    ;;
  *)
    log "ERROR: unexpected HTTP ${code} from change_password:"
    cat "${body}" >&2
    rm -f "${body}"
    exit 1
    ;;
esac
rm -f "${body}"

log "==> Generating a user token"
# One token name, revoked before each run, so tokens do not pile up and only the latest one is valid
curl -s -o /dev/null -u "admin:${SONAR_ADMIN_PASSWORD}" \
  -X POST "${SONAR_HOST_URL}/api/user_tokens/revoke" \
  --data-urlencode "name=${TOKEN_NAME}" || true
token=$(curl -s -u "admin:${SONAR_ADMIN_PASSWORD}" \
  -X POST "${SONAR_HOST_URL}/api/user_tokens/generate" \
  --data-urlencode "name=${TOKEN_NAME}" \
  | grep -o '"token":"[^"]*"' | cut -d'"' -f4 || true)

if [ -z "${token}" ]; then
  log "ERROR: could not generate a token. Is SONAR_ADMIN_PASSWORD correct?"
  log "       Run 'task reset' to return to a clean state."
  exit 1
fi

log "    token generated"

# The showcase rules are spread over the tiers of the built-in profiles, and only the comprehensive one holds them all,
# so each sample project is created ahead of its first analysis and given that profile.
# Every language that has it is covered, as IstarCI does, since a sample also holds HTML, CSS or YAML, which the default profile would judge.
log "==> Assigning the '${PROFILE}' quality profile to the sample projects"
admin() { curl -sf -o /dev/null -K - -X POST "${SONAR_HOST_URL}$1" "${@:2}" <<< "user = \"admin:${SONAR_ADMIN_PASSWORD}\""; }
languages=$(curl -sf -G -K - "${SONAR_HOST_URL}/api/qualityprofiles/search" --data-urlencode "qualityProfile=${PROFILE}" \
  <<< "user = \"admin:${SONAR_ADMIN_PASSWORD}\"" | grep -o '"language":"[^"]*"' | cut -d'"' -f4 | sort -u || true)
if [ -z "${languages}" ]; then
  log "ERROR: no language has the '${PROFILE}' quality profile"
  exit 1
fi
for sample in nodejs python go java dotnet angular; do
  project="sonar-samples-${sample}"
  admin /api/projects/create --data-urlencode "project=${project}" --data-urlencode "name=sonar-samples / ${sample}" || true
  for language in ${languages}; do
    if ! admin /api/qualityprofiles/add_project --data-urlencode "language=${language}" \
      --data-urlencode "qualityProfile=${PROFILE}" --data-urlencode "project=${project}"; then
      log "ERROR: could not assign '${PROFILE}' to ${project} for ${language}"
      exit 1
    fi
  done
done
log "    profile assigned"

echo "${token}"
