# Node.js sample

Scan a Node.js 22 sample with Jest with the SonarScanner CLI.

## How to run

```bash
task build:nodejs   # install the dependencies, run the tests with coverage
task scan:nodejs    # run the scanner CLI in Docker
```

Without Task, from this directory:

```bash
npm install
npm test
npx sonar-scanner -Dsonar.token="$SONAR_TOKEN"
```

## Settings

```ini
sonar.projectKey=sonar-samples-nodejs
sonar.projectName=sonar-samples / nodejs
sonar.sources=src
sonar.tests=tests
sonar.javascript.lcov.reportPaths=coverage/lcov.info
sonar.exclusions=node_modules/**
sonar.host.url=http://localhost:9000
sonar.testExecutionReportPaths=coverage/test-report.xml
```

## Gotchas

- `sonar.javascript.lcov.reportPaths` must match the path Jest writes to, otherwise coverage is 0% and the scan still succeeds.
- Jest only reports the files imported by a test.
  `"collectCoverageFrom": ["src/**/*.js"]` in `package.json` makes it report the other files too.
- TypeScript uses the same `sonar.javascript.` property, and the `sonar.typescript.` one is ignored.
- The test report is written by `jest-sonar`, which is declared as a Jest reporter in `package.json`.
