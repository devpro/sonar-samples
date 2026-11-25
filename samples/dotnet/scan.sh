#!/usr/bin/env bash
set -euo pipefail

TOKEN="${1:-}"
if [[ -z "${TOKEN}" ]]; then
  echo "Usage: bash scan.sh <sonar-token>"
  echo ""
  echo "Generate a token at http://localhost:9000 → My Account → Security"
  exit 1
fi

# The scanner finds nothing when its steps run from different directories
cd "$(dirname "${BASH_SOURCE[0]}")"

SONAR_HOST_URL="${SONAR_HOST_URL:-http://localhost:9000}"
PROJECT_KEY="sonar-samples-dotnet"
PROJECT_NAME="sonar-samples / dotnet"

echo "==> dotnet restore"
dotnet tool restore
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
  /s:"${PWD}/SonarQube.Analysis.xml"

echo ""
echo "==> dotnet build"
dotnet build --no-restore

echo ""
echo "==> dotnet test (with coverage)"
rm -rf report
dotnet test --no-build --results-directory report/TestResults \
  --report-xunit-trx --coverage --coverage-output-format cobertura

echo ""
echo "==> ReportGenerator: Cobertura to the generic format of SonarQube"
dotnet reportgenerator "-reports:report/TestResults/*.cobertura.xml" "-targetdir:report" "-reporttypes:SonarQube;Html;TextSummary"

echo ""
echo "==> SonarScanner for .NET: end"
dotnet sonarscanner end /d:sonar.token="${TOKEN}"

echo ""
echo "Done. View results at: ${SONAR_HOST_URL}/dashboard?id=${PROJECT_KEY}"
