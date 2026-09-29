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

cd "${APP_DIR}"

echo ""
echo "==> Configuring coverage..."

# Angular <= 19 scaffolds a Karma test target, which takes `codeCoverage` as a builder option in angular.json.
# Angular >= 20 scaffolds the Vitest-based `@angular/build:unit-test` builder, whose schema *rejects* `codeCoverage`;
# coverage is a CLI flag there, and the v8 coverage provider is a separate package that `ng new` does not install.
BUILDER=$(node -p "
const c = require('./angular.json');
const p = c.projects[Object.keys(c.projects)[0]];
const t = (p.architect || p.targets || {}).test;
t ? t.builder : '';
")
echo "  test builder: ${BUILDER:-none}"

case "${BUILDER}" in
  *karma*)
    node -e "
      const fs = require('fs');
      const config = JSON.parse(fs.readFileSync('angular.json', 'utf8'));
      const project = config.projects[Object.keys(config.projects)[0]];
      const targets = project.architect || project.targets;
      targets.test.options = targets.test.options || {};
      targets.test.options.codeCoverage = true;
      fs.writeFileSync('angular.json', JSON.stringify(config, null, 2));
      console.log('  angular.json updated: codeCoverage = true');
    "
    TEST_CMD="ng test --watch=false --browsers=ChromeHeadless"
    ;;
  *unit-test*)
    # vitest-sonar-reporter writes the test count in the generic format SonarQube imports for JavaScript and TypeScript
    echo "  installing @vitest/coverage-v8 and vitest-sonar-reporter"
    npm install --save-dev @vitest/coverage-v8 vitest-sonar-reporter
    TEST_CMD="ng test --watch=false --coverage --coverage-reporters=lcovonly --reporters=vitest-sonar-reporter --reporters=default --output-file=test-report.xml"
    ;;
  *)
    echo "  WARNING: unrecognised test builder, configure coverage manually."
    TEST_CMD="ng test --watch=false"
    ;;
esac

echo ""
echo "Done. Next steps:"
echo ""
echo "  cd ${APP_DIR}"
echo "  ${TEST_CMD}"
echo "  sonar-scanner -Dsonar.token=<token>"
echo ""
echo "See the README for full instructions."
