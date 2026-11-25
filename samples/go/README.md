# Go sample

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=sonar-samples-go&metric=alert_status)](https://sonarcloud.io/dashboard?id=sonar-samples-go)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=sonar-samples-go&metric=coverage)](https://sonarcloud.io/dashboard?id=sonar-samples-go)

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
sonar.exclusions=vendor/**
sonar.tests=.
sonar.test.inclusions=**/*_test.go
sonar.go.coverage.reportPaths=coverage.out
sonar.host.url=http://localhost:9000
sonar.go.tests.reportPaths=test-report.json
```

## Gotchas

- In Go, the tests live next to the code they test.
  `sonar.test.inclusions` makes the `*_test.go` files tests, and the scanner leaves them out of the sources by itself.
- On the local SonarQube, the hard-coded password and the MD5 hash in `internal/showcase` raise nothing.
  SonarCloud raises `go:S4790` on the hash.
