# Go sample

A minimal Go 1.23 HTTP server with unit tests, demonstrating Go analysis in SonarQube using the SonarScanner CLI combined with `go test` coverage output.

## What this demonstrates

- Go source analysis (bugs, code smells, security hotspots)
- Test coverage import from `go test -coverprofile`
- Exclusion of generated files and vendor directory
- SonarScanner CLI running against a Go module

## Prerequisites

- [Go 1.23+](https://go.dev/dl/)
- SonarQube running locally (`docker compose up -d` from the repo root)
- SonarScanner CLI:

```bash
# macOS (Homebrew)
brew install sonar-scanner

# Linux / Windows — download from:
# https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/scanners/sonarscanner/
```

Or run the scanner via Docker — see below.

## Run the application

```bash
go run ./cmd/server
# Listening on http://localhost:8080
```

## Run tests with coverage

```bash
go test ./... -coverprofile=coverage.out -covermode=atomic
```

SonarQube reads Go coverage in the `go test` text format directly — no conversion needed.

## Create the project in SonarQube

1. Open <http://localhost:9000>
2. Log in (`admin` / your password)
3. Click **Create project** → **Manually**
4. Set **Project key**: `sonar-samples-go`
5. Set **Display name**: `sonar-samples / go`
6. Click **Set up** → **Locally**
7. Generate a token and copy it

## Run the scanner

```bash
sonar-scanner -Dsonar.token=<your-token>
```

### Running the scanner via Docker (no install)

```bash
docker run --rm \
  --network host \
  -e SONAR_TOKEN=<your-token> \
  -v "$(pwd)":/usr/src \
  sonarsource/sonar-scanner-cli:latest
```

## View results

Open <http://localhost:9000/dashboard?id=sonar-samples-go>.

## sonar-project.properties

```properties
sonar.projectKey=sonar-samples-go
sonar.projectName=sonar-samples / go
sonar.sources=.
sonar.exclusions=vendor/**,**/*_test.go
sonar.tests=.
sonar.test.inclusions=**/*_test.go
sonar.go.coverage.reportPaths=coverage.out
sonar.host.url=http://localhost:9000
```

> `sonar.sources` and `sonar.tests` both point to `.` — Sonar distinguishes them via the inclusions/exclusions on `*_test.go`.

The `sonar.token` is not stored here — pass it on the command line or via `SONAR_TOKEN`.
