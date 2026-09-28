# Troubleshooting

## SonarQube does not start

`vm.max_map_count` is too low, the logs are in `task logs`.
To make the fix permanent:

```bash
echo "vm.max_map_count=524288" | sudo tee /etc/sysctl.d/99-sonarqube.conf   # Linux
sudo sysctl --system
```

On WSL2, in `%UserProfile%\.wslconfig`, followed by `wsl --shutdown`:

```ini
[wsl2]
kernelCommandLine = sysctl.vm.max_map_count=524288
```

## `network ... not found` on start

Containers left from an earlier run point at a Docker network that no longer exists.
`task down` removes them and keeps the data.

## Coverage shows 0%

The scanner exits `0` when the coverage report is not found, which is why `task assert` exists.
The scanner output lists the resolved reports under `Coverage report`.

Language   | Property                               | Path
-----------|----------------------------------------|--------------------------------
JS / TS    | `sonar.javascript.lcov.reportPaths`    | `coverage/lcov.info`
Python     | `sonar.python.coverage.reportPaths`    | `coverage.xml`
Go         | `sonar.go.coverage.reportPaths`        | `coverage.out`
C#         | `sonar.cs.opencover.reportsPaths`      | `**/coverage.opencover.xml`
Java       | `sonar.coverage.jacoco.xmlReportPaths` | `target/site/jacoco/jacoco.xml`

- TypeScript: `sonar.typescript.lcov.reportPaths` is ignored.
- Python: `relative_files = True` under `[coverage:run]`, otherwise paths are absolute and dropped.
- Java: `mvn verify`, not `mvn test`.
- .NET: `Format=opencover`, Coverlet defaults to Cobertura.
- Angular 20 and later: `coverage/<project-name>/lcov.info`.

## Tests count is missing

Only a test execution report gives the number of tests, `task assert` fails without it.

Language   | Property                               | Report
-----------|----------------------------------------|---------------------------------------------------
JS / TS    | `sonar.testExecutionReportPaths`       | generic XML, from `jest-sonar` or `vitest-sonar-reporter`
Python     | `sonar.python.xunit.reportPath`        | `pytest --junitxml=test-results.xml`
Go         | `sonar.go.tests.reportPaths`           | `go test -json > test-report.json`
C#         | `sonar.cs.vstest.reportsPaths`         | `dotnet test --logger trx`
Java       | read by the Maven plugin               | Surefire reports in `target/surefire-reports`

JS and TS test files must be indexed as tests, through `sonar.tests`, for their report to import.

## A rule looks retired

Security Hotspots are not returned by `/api/issues/search`, they have their own endpoint `/api/hotspots/search`.
Results read before `/api/ce/activity_status` shows an empty queue mix two analyses.

## Permission denied after a manual scan

The `sonarsource/sonar-scanner-cli` image runs as root and leaves a root-owned `.scannerwork/` without `--user "$(id -u):$(id -g)"`.
`sudo rm -rf .scannerwork` clears it.

## .NET `end` reports "No analyses found"

`begin`, build and `end` did not run from the same directory, or `.sonarqube/` was deleted in between.

## The Quality Gate fails on a first analysis

All code is new code on a first analysis, so this is expected.
**Project Settings > Quality Gate** can be set to none.

## Starting over

`task reset` removes every volume: analyses, tokens and the admin password.
