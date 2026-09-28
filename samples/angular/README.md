# Angular sample

An app scaffolded by the latest Angular CLI, scanned by the SonarScanner CLI.
It is not part of `task ci`, since the generated code changes with every CLI release.

- Project key: `sonar-samples-angular`
- Coverage: LCOV, `coverage/<project-name>/lcov.info`
- Tests: `vitest-sonar-reporter`, `test-report.xml`

```bash
npm install -g @angular/cli
task build:angular    # setup.sh scaffolds my-angular-app/, then build and test
task scan:angular     # scanner CLI in Docker
task assert:angular   # coverage and tests imported
```

`setup.sh` installs `@vitest/coverage-v8` and `vitest-sonar-reporter`, which `ng new` does not, and prints the test command:

```bash
ng test --watch=false --coverage --coverage-reporters=lcovonly \
  --reporters=vitest-sonar-reporter --reporters=default --output-file=test-report.xml
```

Up to Angular 19, the Karma builder only gets `codeCoverage: true`, without a test report.

## sonar-project.properties

```ini
sonar.projectKey=sonar-samples-angular
sonar.projectName=sonar-samples / angular
sonar.sources=src
sonar.exclusions=node_modules/**,dist/**,**/*.spec.ts,coverage/**
sonar.tests=src
sonar.test.inclusions=**/*.spec.ts
sonar.javascript.lcov.reportPaths=coverage/*/lcov.info
sonar.testExecutionReportPaths=test-report.xml
sonar.scm.exclusions.disabled=true
sonar.host.url=http://localhost:9000
```

## Gotchas

- TypeScript coverage goes in `sonar.javascript.lcov.reportPaths`, the `sonar.typescript.` variant is ignored.
- Angular 20 and later writes into a per-project subdirectory, hence the glob.
- The scanner skips git ignored files, and `my-angular-app/` is git ignored here: without `sonar.scm.exclusions.disabled=true` it reports `0 files indexed` and still succeeds.
- The test report only imports when the spec files are indexed as tests, hence `sonar.tests` with the specs excluded from the sources.
- In an existing app, `sonar.exclusions` also takes `e2e/**` and generated code.
