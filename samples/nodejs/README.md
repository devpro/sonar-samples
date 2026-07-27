# Node.js sample

A minimal Node.js 22 application with a test suite, demonstrating JavaScript analysis with coverage reporting in SonarQube.

## What this demonstrates

- JavaScript source analysis
- Test coverage import from Istanbul/V8 (`lcov.info`)
- Exclusion of `node_modules` and test files from analysis
- Inline issue detection (unused variables, code smells)

## Prerequisites

- [Node.js 22+](https://nodejs.org/)
- SonarQube running locally (`docker compose up -d` from the repo root)
- [SonarScanner CLI](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/scanners/sonarscanner/) — install via npm globally:

```bash
npm install -g sonar-scanner
```

Or run it with `npx` (no install needed):

```bash
npx sonar-scanner@latest
```

## Setup

```bash
npm install
```

## Run the application

```bash
node src/app.js
# Listening on http://localhost:3000
```

## Run tests with coverage

```bash
npm test
```

Coverage output is written to `coverage/lcov.info`, which SonarQube will import.

## Create the project in SonarQube

1. Open <http://localhost:9000>
2. Log in (`admin` / your password)
3. Click **Create project** → **Manually**
4. Set **Project key**: `sonar-samples-nodejs`
5. Set **Display name**: `sonar-samples / nodejs`
6. Click **Set up** → **Locally**
7. Generate a token and copy it

## Run the scanner

```bash
sonar-scanner -Dsonar.token=<your-token>
```

Or with `npx`:

```bash
npx sonar-scanner@latest -Dsonar.token=<your-token>
```

All other properties are read from `sonar-project.properties`.

## View results

Open <http://localhost:9000/dashboard?id=sonar-samples-nodejs>.

## sonar-project.properties

```properties
sonar.projectKey=sonar-samples-nodejs
sonar.projectName=sonar-samples / nodejs
sonar.sources=src
sonar.tests=tests
sonar.javascript.lcov.reportPaths=coverage/lcov.info
sonar.exclusions=node_modules/**
sonar.host.url=http://localhost:9000
```

The `sonar.token` is intentionally not stored here — pass it on the command line or via the `SONAR_TOKEN` environment variable.
