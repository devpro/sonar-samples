# Go sample

Go 1.23 HTTP server with unit tests, scanned by the SonarScanner CLI.

- Project key: `sonar-samples-go`
- Coverage: Go cover profile, `coverage.out`
- Tests: `go test -json` output, `test-report.json`
- Rules raised: [docs/rules.md](../../docs/rules.md)

```bash
task build:go   # go vet, go test with coverage
task scan:go    # scanner CLI in Docker
```

Without Task, from this directory:

```bash
go test ./... -coverprofile=coverage.out -covermode=atomic -json > test-report.json
sonar-scanner -Dsonar.token="$SONAR_TOKEN"
```

## sonar-project.properties

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

- Sources and tests share a directory, so `*_test.go` is excluded from sources and included as tests, otherwise tests count as production code.
- The Go analyser has no `S2068` and no `S4790`: the hard-coded password and the MD5 hash in `internal/showcase` raise nothing.
