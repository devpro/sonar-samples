#!/usr/bin/env bash
set -euo pipefail

APP_DIR="my-angular-app"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Checking prerequisites..."

if ! command -v ng &>/dev/null; then
  echo "ERROR: Angular CLI not found. Install with: npm install -g @angular/cli"
  exit 1
fi

if ! command -v node &>/dev/null; then
  echo "ERROR: Node.js not found. Install from https://nodejs.org/"
  exit 1
fi

echo "  node $(node --version)"
echo "  ng $(ng version --skip-confirmation 2>/dev/null | grep 'Angular CLI' | awk '{print $NF}')"

echo ""
echo "==> Scaffolding Angular project into ./${APP_DIR} ..."

ng new "${APP_DIR}" \
  --routing=false \
  --style=css \
  --skip-git \
  --skip-tests=false \
  --package-manager=npm

echo ""
echo "==> Copying sonar-project.properties..."
cp "${SCRIPT_DIR}/sonar-project.properties" "${APP_DIR}/"

echo ""
echo "==> Patching angular.json to enable code coverage by default..."
cd "${APP_DIR}"

# Enable codeCoverage in the test target
node -e "
const fs = require('fs');
const config = JSON.parse(fs.readFileSync('angular.json', 'utf8'));
const projectName = Object.keys(config.projects)[0];
const testOptions = config.projects[projectName].architect.test.options;
testOptions.codeCoverage = true;
fs.writeFileSync('angular.json', JSON.stringify(config, null, 2));
console.log('  angular.json updated: codeCoverage = true');
"

echo ""
echo "Done. Next steps:"
echo ""
echo "  cd ${APP_DIR}"
echo "  ng test --watch=false --browsers=ChromeHeadless"
echo "  sonar-scanner -Dsonar.token=<your-token>"
echo ""
echo "See the README for full instructions."
