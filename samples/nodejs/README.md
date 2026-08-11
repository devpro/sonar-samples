# Node.js sample

A minimal Node.js 22 app with a Jest test suite, analysed with the SonarScanner CLI.

- Project key: `sonar-samples-nodejs`
- Coverage: Istanbul LCOV, written to `coverage/lcov.info`
- Issues raised: [docs/rules.md#nodejs](../../docs/rules.md#nodejs)

## Prerequisites

Node.js 22+ and a running SonarQube.
See [docs/installation.md](../../docs/installation.md).

## Run it

```bash
npm install
npm test          # runs Jest with --coverage
node src/app.js   # optional, serves http://localhost:3000
```

`npm test` writes `coverage/lcov.info`.
Without that file SonarQube reports no coverage at all, so it is worth checking it exists before scanning.

## Scan it

```bash
export SONAR_TOKEN=$(task bootstrap)   # see docs/tokens.md
task scan:nodejs
```

`task scan:nodejs` runs the scanner in Docker.
A locally installed scanner works too, from this directory:

```bash
sonar-scanner -Dsonar.token="$SONAR_TOKEN"
# or, with no install:
npx sonar-scanner@latest -Dsonar.token="$SONAR_TOKEN"
```

Results: <http://localhost:9000/dashboard?id=sonar-samples-nodejs>

## sonar-project.properties

```ini
sonar.projectKey=sonar-samples-nodejs
sonar.projectName=sonar-samples / nodejs
sonar.sources=src
sonar.tests=tests
sonar.javascript.lcov.reportPaths=coverage/lcov.info
sonar.exclusions=node_modules/**
sonar.host.url=http://localhost:9000
```

Why these:

- `sonar.sources` and `sonar.tests` split the tree so test files are analysed with test-specific rules rather than counted as production code.
- `sonar.javascript.lcov.reportPaths` must match Jest's `coverageDirectory`.
  This is the single most common reason coverage shows as 0%.
- `node_modules` is excluded explicitly, since dependencies are not part of the analysed code.

The token is never stored here, pass it via `-Dsonar.token=` or `SONAR_TOKEN`.

## Notes

Jest only instruments files a test imports.
`src/app.js` is never imported by a test, so it contributes uncovered lines to the Sonar total, which is why coverage lands at 31% and not higher.
To report on every file regardless, add to `package.json`:

```json
"collectCoverageFrom": ["src/**/*.js"]
```

## Adapting to another project

Copy `sonar-project.properties`, change `projectKey` and `projectName`, and point `sonar.javascript.lcov.reportPaths` at the real coverage output.
The same properties work for TypeScript: use the `javascript.` prefix there too, since `sonar.typescript.lcov.reportPaths` is deprecated and ignored.
