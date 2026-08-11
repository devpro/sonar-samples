# Angular sample

A walkthrough for scanning an Angular application.
No sources are committed here, `setup.sh` scaffolds a fresh app with the current Angular CLI, configures coverage, and drops in the properties file.

That mirrors real usage: an Angular app lives in its own repository, and this sample shows exactly what to add to it.

- Project key: `sonar-samples-angular`
- Coverage: LCOV, written to `coverage/<project-name>/lcov.info`

> [!NOTE]
> This sample scaffolds against the **latest** Angular CLI, so it tracks a moving target by design.
> It is excluded from `task build`, `task scan` and `task assert`, and has no section in `docs/rules.md`, because the generated app differs between CLI releases and fixed issue counts would be meaningless.
> CI still runs `task build:angular`, which is what signals that the sample has gone stale.

## Prerequisites

Node.js 22+, the Angular CLI (`npm install -g @angular/cli`), and a running SonarQube.
See [docs/installation.md](../../docs/installation.md).

## Scaffold

```bash
./setup.sh
```

This creates `my-angular-app/` via `ng new` and copies `sonar-project.properties` into it.

`setup.sh` then branches on which test builder the CLI generated, because this changed materially in Angular 20:

Angular | Test builder                        | Coverage
--------|-------------------------------------|---------------------------------------------------------------------------------------------------------
<= 19   | Karma                               | `codeCoverage: true` in `angular.json`
>= 20   | Vitest (`@angular/build:unit-test`) | a CLI flag; its schema **rejects** `codeCoverage`, and `@vitest/coverage-v8` must be installed separately

The script detects the builder, applies the right one, and prints the matching test command.
A warning about an unrecognised builder means the CLI has changed again and coverage needs configuring by hand.

## Test and scan

```bash
cd my-angular-app
ng test --watch=false --coverage --coverage-reporters=lcovonly   # Angular >= 20
# Angular <= 19: ng test --watch=false --browsers=ChromeHeadless

export SONAR_TOKEN=$(task bootstrap)   # see docs/tokens.md
sonar-scanner -Dsonar.token="$SONAR_TOKEN"
```

Results: <http://localhost:9000/dashboard?id=sonar-samples-angular>

## sonar-project.properties

```ini
sonar.projectKey=sonar-samples-angular
sonar.projectName=sonar-samples / angular
sonar.sources=src
sonar.exclusions=node_modules/**,dist/**,**/*.spec.ts,coverage/**
sonar.javascript.lcov.reportPaths=coverage/*/lcov.info
sonar.host.url=http://localhost:9000
```

Two things here are easy to get wrong:

- **Use the `javascript.` prefix for TypeScript.**
  `sonar.typescript.lcov.reportPaths` is deprecated and silently ignored by current SonarQube, so setting it leaves coverage at 0% with no error.
- **The glob is load-bearing.**
  Angular 20+ writes to `coverage/<project-name>/lcov.info`, not `coverage/lcov.info`, so a fixed path breaks whenever the project name changes.

The token is never stored here, pass it via `-Dsonar.token=` or `SONAR_TOKEN`.

## Adapting to an existing Angular project

Copy `sonar-project.properties` to the project root and adjust:

- `sonar.sources`, usually `src`
- `sonar.tests`, left unset, since Sonar detects `.spec.ts` on its own
- `sonar.javascript.lcov.reportPaths`, matching the real coverage output
- `sonar.exclusions`, adding `e2e/**` and any generated code
