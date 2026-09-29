# Go sample

Scan a Go 1.23 HTTP server with unit tests with the SonarScanner CLI.

## How to run

```bash
task build:go   # vet and build, then run the tests with coverage
task scan:go    # run the scanner CLI in Docker
```

Without Task, from this directory:

```bash
go test ./... -coverprofile=coverage.out -covermode=atomic -json > test-report.json
sonar-scanner -Dsonar.token="$SONAR_TOKEN"
```

## Settings

```ini
sonar.projectKey=sonar-samples-go
sonar.projectName=sonar-samples / go
sonar.sources=.
sonar.exclusions=vendor/**,**/*_test.go
sonar.tests=.
sonar.test.inclusions=**/*_test.go
sonar.go.coverage.reportPaths=coverage.out
sonar.host.url=http://localhost:9000
sonar.go.tests.reportPaths=test-report.json
```

## Gotchas

- In Go, the tests live next to the code they test.
  The `*_test.go` files are therefore excluded from the sources and included as tests, otherwise they would be counted as production code.
- The Go analyser has neither `S2068` nor `S4790`, so the hard-coded password and the MD5 hash in `internal/showcase` raise nothing.
