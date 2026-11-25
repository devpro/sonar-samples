# .NET sample

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=sonar-samples-dotnet&metric=alert_status)](https://sonarcloud.io/dashboard?id=sonar-samples-dotnet)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=sonar-samples-dotnet&metric=coverage)](https://sonarcloud.io/dashboard?id=sonar-samples-dotnet)

Scan an ASP.NET Core 10 sample with xUnit v3 with the SonarScanner for .NET.

## How to run

```bash
task build:dotnet   # restore, build and test
task scan:dotnet    # run scan.sh
```

Without Task, from this directory:

```bash
bash scan.sh "$SONAR_TOKEN"
```

## Settings

The scanner wraps the build, as done in `scan.sh`, and never reads a `sonar-project.properties` file.

File                        | Holds
----------------------------|----------------------------------------------------------------
`SonarQube.Analysis.xml`    | the analysis settings: exclusions and report paths
`.config/dotnet-tools.json` | the versions of the scanner and ReportGenerator, installed by `dotnet tool restore`
`global.json`               | the test runner, Microsoft.Testing.Platform
`Directory.Build.props`     | the target framework and compiler options
`Directory.Packages.props`  | the package versions
`.editorconfig`             | the format checked by `dotnet format`

The key, the name and the token are given to the `begin` step:

```bash
dotnet tool restore
dotnet restore

dotnet sonarscanner begin \
  /k:"sonar-samples-dotnet" \
  /n:"sonar-samples / dotnet" \
  /d:sonar.host.url="http://localhost:9000" \
  /d:sonar.token="$SONAR_TOKEN" \
  /s:"$PWD/SonarQube.Analysis.xml"

dotnet build --no-restore
rm -rf report
dotnet test --no-build --results-directory report/TestResults \
  --report-xunit-trx --coverage --coverage-output-format cobertura
dotnet reportgenerator "-reports:report/TestResults/*.cobertura.xml" "-targetdir:report" "-reporttypes:SonarQube;Html;TextSummary"

dotnet sonarscanner end /d:sonar.token="$SONAR_TOKEN"
```

`report/index.html` shows the coverage without SonarQube.

## Gotchas

- SonarQube does not read Cobertura for C#, so ReportGenerator converts it to the generic format, read through `sonar.coverageReportPaths`.
- The path given to `/s:` is absolute, since the scanner resolves a relative one against its own `.sonarqube` folder.
- `global.json` selects Microsoft.Testing.Platform, without which `dotnet test` fails on the .NET 10 SDK.
- The `begin` step runs before the build, because it injects the Roslyn analysers into it.
- The `begin` step, the build and the `end` step must run from the same directory, otherwise `end` reports "No analyses found".
- The token is needed on both the `begin` and the `end` steps.
- The issues found by the Roslyn analysers show up as `external_roslyn:*`, which is why this sample raises the most issues.

## Other projects

Coverage is added to a test project with `dotnet add <test project> package Microsoft.Testing.Extensions.CodeCoverage`.
Several solutions can be analysed together by building them all between a single `begin` and `end` run at the root.

On GitHub, the [.NET quality workflow](https://github.com/devpro/github-workflow-parts/blob/main/.github/workflows/reusable-dotnet-quality.yml) runs the same steps:

```yaml
jobs:
  code-quality:
    uses: devpro/github-workflow-parts/.github/workflows/reusable-dotnet-quality.yml@398cf79719f90e41e3407bc9f060e297629d800d
    with:
      dotnet-test-args: --report-xunit-trx --coverage --coverage-output-format cobertura
      sonar-enabled: true
      sonar-host-url: <host-url>
      sonar-organization: <organization>
      sonar-project-key: <project-key>
      sonar-settings-file: SonarQube.Analysis.xml
      workflow-parts-version: 398cf79719f90e41e3407bc9f060e297629d800d
    secrets:
      sonar-token: ${{ secrets.SONAR_TOKEN }}
```

`sonar-organization` is for SonarCloud only.
