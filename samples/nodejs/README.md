# Node.js sample

Node.js 22 with Jest, scanned by the SonarScanner CLI.

- Project key: `sonar-samples-nodejs`
- Coverage: LCOV, `coverage/lcov.info`
- Tests: `jest-sonar`, `coverage/test-report.xml`
- Rules raised: [docs/rules.md](../../docs/rules.md)

```bash
task build:nodejs   # npm install && npm test
task scan:nodejs    # scanner CLI in Docker
```

Without Task, from this directory: `npm install && npm test`, then `npx sonar-scanner -Dsonar.token="$SONAR_TOKEN"`.

## sonar-project.properties

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

- `sonar.javascript.lcov.reportPaths` must match Jest's output, otherwise coverage is 0% and the scan still succeeds.
- Jest only reports files a test imports, `"collectCoverageFrom": ["src/**/*.js"]` in `package.json` adds the others.
- TypeScript uses the same `sonar.javascript.` property, the `sonar.typescript.` one is ignored.
