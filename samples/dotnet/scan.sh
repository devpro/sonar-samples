#!/usr/bin/env bash
set -euo pipefail

TOKEN="${1:-}"
if [[ -z "${TOKEN}" ]]; then
  echo "Usage: bash scan.sh <sonar-token>"
  echo ""
  echo "Generate a token at http://localhost:9000 → My Account → Security"
  exit 1
fi

SONAR_HOST_URL="${SONAR_HOST_URL:-http://localhost:9000}"
PROJECT_KEY="sonar-samples-dotnet"
PROJECT_NAME="sonar-samples / dotnet"

echo "==> dotnet restore"
dotnet restore

echo ""
echo "==> SonarScanner for .NET: begin"
# On a pull request, read from GITHUB_BASE_REF, the scanner skips the files the cache of the previous analysis holds as unchanged,
# which against a SonarQube kept between runs leaves the sample without issues nor lines, so the sample is always analysed in full
env -u GITHUB_BASE_REF dotnet sonarscanner begin \
  /k:"${PROJECT_KEY}" \
  /n:"${PROJECT_NAME}" \
  /d:sonar.host.url="${SONAR_HOST_URL}" \
  /d:sonar.token="${TOKEN}" \
  /d:sonar.cs.vscoveragexml.reportsPaths="TestResults/coverage.xml" \
  /d:sonar.cs.vstest.reportsPaths="TestResults/tests.trx"

echo ""
echo "==> dotnet build"
dotnet build --no-restore

echo ""
echo "==> dotnet test (with coverage)"
dotnet test --no-build --results-directory TestResults \
  --report-xunit-trx --report-xunit-trx-filename tests.trx \
  --coverage --coverage-output-format xml --coverage-output coverage.xml

echo ""
echo "==> SonarScanner for .NET: end"
dotnet sonarscanner end /d:sonar.token="${TOKEN}"

echo ""
echo "Done. View results at: ${SONAR_HOST_URL}/dashboard?id=${PROJECT_KEY}"
