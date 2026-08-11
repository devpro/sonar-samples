# Go sample

A minimal Go 1.23 HTTP server with unit tests, analysed with the SonarScanner CLI.

- Project key: `sonar-samples-go`
- Coverage: `go test -coverprofile` writes `coverage.out`, read natively with no conversion
- Issues raised: [docs/rules.md#go](../../docs/rules.md#go)

## Prerequisites

Go 1.23+ and a running SonarQube.
See [docs/installation.md](../../docs/installation.md).

## Run it

```bash
go vet ./...
go test ./... -coverprofile=coverage.out -covermode=atomic
go run ./cmd/server   # optional, serves http://localhost:8080
```

## Scan it

```bash
export SONAR_TOKEN=$(task bootstrap)   # see docs/tokens.md
task scan:go
```

Or with a locally installed scanner, from this directory:

```bash
sonar-scanner -Dsonar.token="$SONAR_TOKEN"
```

Results: <http://localhost:9000/dashboard?id=sonar-samples-go>

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
```

Go layout does not separate sources from tests into different directories, so `sonar.sources` and `sonar.tests` both point at `.`, and the split is expressed through inclusions instead: `*_test.go` is excluded from sources and included as tests.
Getting this wrong makes test files count as production code, which inflates both the line count and the issue count.

`vendor/` is excluded because vendored dependencies are not part of the analysed code.

## Why this sample raises the fewest issues

This is the most instructive sample in the repo, and worth reading [docs/rules.md#go](../../docs/rules.md#go) for.

`internal/showcase/showcase.go` contains a hard-coded password and MD5 hashing, the same code that raises a Vulnerability and a Security Hotspot in the Java, Python, and .NET samples.
In Go it raises **nothing at all**, because the Go analyser ships neither `S2068` nor `S4790`.

A clean dashboard does not always mean clean code.
Sometimes it means the rule does not exist for that language.

Go also rejects unused local variables at compile time, so the "unused variable" smell that the Node.js sample demonstrates cannot exist in a Go program.
