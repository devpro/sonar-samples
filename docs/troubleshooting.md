# Troubleshooting

## SonarQube does not start

The kernel setting `vm.max_map_count` is too low, which `task logs` confirms.
On Linux, the fix is made permanent with:

```bash
echo "vm.max_map_count=524288" | sudo tee /etc/sysctl.d/99-sonarqube.conf
sudo sysctl --system
```

On WSL2, the setting goes in `%UserProfile%\.wslconfig`, and takes effect after `wsl --shutdown`:

```ini
[wsl2]
kernelCommandLine = sysctl.vm.max_map_count=524288
```

## `network ... not found` on start

Containers left over from an earlier run point at a Docker network that no longer exists.
`task down` removes them and keeps the data.

## Coverage shows 0%

The scanner still succeeds when it cannot find the coverage report, which is why `task assert` exists.
The scanner output shows which reports were found, under `Coverage report`.

Language   | Property                               | Path
-----------|----------------------------------------|--------------------------------
JS / TS    | `sonar.javascript.lcov.reportPaths`    | `coverage/lcov.info`
Python     | `sonar.python.coverage.reportPaths`    | `coverage.xml`
Go         | `sonar.go.coverage.reportPaths`        | `coverage.out`
C#         | `sonar.cs.opencover.reportsPaths`      | `**/coverage.opencover.xml`
Java       | `sonar.coverage.jacoco.xmlReportPaths` | `target/site/jacoco/jacoco.xml`

The most common causes are:

- In TypeScript, the report is set in `sonar.typescript.lcov.reportPaths`, which is ignored.
- In Python, `relative_files = True` is missing under `[coverage:run]`, so the paths are absolute and dropped.
- In Java, the build ran `mvn test` instead of `mvn verify`.
- In .NET, `Format=opencover` is missing, and Coverlet writes Cobertura by default.
- Since Angular 20, the report is in `coverage/<project-name>/lcov.info`.

## Tests count is missing

The number of tests only comes from a test execution report, and `task assert` fails without one.

Language   | Property                               | Report
-----------|----------------------------------------|---------------------------------------------------
JS / TS    | `sonar.testExecutionReportPaths`       | generic XML, from `jest-sonar` or `vitest-sonar-reporter`
Python     | `sonar.python.xunit.reportPath`        | `pytest --junitxml=test-results.xml`
Go         | `sonar.go.tests.reportPaths`           | `go test -json > test-report.json`
C#         | `sonar.cs.vstest.reportsPaths`         | `dotnet test --logger trx`
Java       | read by the Maven plugin               | Surefire reports in `target/surefire-reports`

In JavaScript and TypeScript, the report is only imported when the test files are indexed as tests, through `sonar.tests`.

## A rule looks retired

Security Hotspots are not returned by `/api/issues/search`, and are listed by `/api/hotspots/search` instead.
Results read while an analysis is still being processed can mix two analyses, so `/api/ce/activity_status` must show an empty queue first.

## Permission denied after a manual scan

Without `--user "$(id -u):$(id -g)"`, the `sonarsource/sonar-scanner-cli` image runs as root and leaves a `.scannerwork/` directory owned by root.
`sudo rm -rf .scannerwork` removes it.

## .NET `end` reports "No analyses found"

The `begin` step, the build and the `end` step did not run from the same directory, or `.sonarqube/` was deleted in between.

## The Quality Gate fails on a first analysis

On a first analysis all the code counts as new code, so this failure is expected.
The Quality Gate can be set to none in **Project Settings > Quality Gate**.

## Starting over

`task reset` deletes all the data: analyses, tokens and the admin password.
