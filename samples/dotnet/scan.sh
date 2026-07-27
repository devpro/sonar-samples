#!/usr/bin/env bash
set -euo pipefail

TOKEN="${1:-}"
if [[ -z "${TOKEN}" ]]; then
  echo "Usage: bash scan.sh <sonar-token>"
  echo ""
  echo "Generate a token at http://localhost:9000 → My Account → Security"
  exit 1
fi

SONAR_HOST="http://localhost:9000"
PROJECT_KEY="sonar-samples-dotnet"
PROJECT_NAME="sonar-samples / dotnet"

echo "==> SonarScanner for .NET — begin"
dotnet sonarscanner begin \
  /k:"${PROJECT_KEY}" \
  /n:"${PROJECT_NAME}" \
  /d:sonar.host.url="${SONAR_HOST}" \
  /d:sonar.token="${TOKEN}" \
  /d:sonar.cs.opencover.reportsPaths="**/coverage.opencover.xml"

echo ""
echo "==> dotnet build"
dotnet build --no-restore

echo ""
echo "==> dotnet test (with coverage)"
dotnet test --no-build \
  --collect:"XPlat Code Coverage" \
  -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=opencover

echo ""
echo "==> SonarScanner for .NET — end"
dotnet sonarscanner end /d:sonar.token="${TOKEN}"

echo ""
echo "Done. View results at: ${SONAR_HOST}/dashboard?id=${PROJECT_KEY}"
