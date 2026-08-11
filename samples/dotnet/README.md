# .NET sample

A minimal ASP.NET Core 10 Web API with an xUnit test project, analysed with the **SonarScanner for .NET**.
The generic SonarScanner CLI cannot analyse C#.

- Project key: `sonar-samples-dotnet`
- Coverage: Coverlet OpenCover XML, matched by `**/coverage.opencover.xml`
- Issues raised: [docs/rules.md#dotnet](../../docs/rules.md#dotnet)

## Prerequisites

.NET 10 SDK and a running SonarQube.
See [docs/installation.md](../../docs/installation.md).

Plus the scanner as a global tool:

```bash
dotnet tool install --global dotnet-sonarscanner
dotnet sonarscanner --version    # verify; needs ~/.dotnet/tools on PATH
```

Coverage comes from the `coverlet.collector` package already referenced by the test project, so nothing else needs installing.

## Run it

```bash
dotnet restore
dotnet build --no-restore
dotnet test --no-build --collect:"XPlat Code Coverage" \
  -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=opencover
```

The trailing `Format=opencover` is required.
Coverlet defaults to Cobertura, which this configuration does not import, and the result is a passing build with 0% coverage.

## Scan it

```bash
export SONAR_TOKEN=$(task bootstrap)   # see docs/tokens.md
task scan:dotnet
```

which runs [`scan.sh`](scan.sh).
`scan.ps1` is the PowerShell equivalent, kept for convenience but not covered by CI.

## The three-step flow

Unlike every other sample, there is no `sonar-project.properties`.
The scanner wraps the build, and configuration is passed as `/d:` parameters:

```bash
dotnet sonarscanner begin \
  /k:"sonar-samples-dotnet" \
  /n:"sonar-samples / dotnet" \
  /d:sonar.host.url="http://localhost:9000" \
  /d:sonar.token="$SONAR_TOKEN" \
  /d:sonar.cs.opencover.reportsPaths="**/coverage.opencover.xml"

dotnet build --no-restore
dotnet test --no-build --collect:"XPlat Code Coverage" \
  -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=opencover

dotnet sonarscanner end /d:sonar.token="$SONAR_TOKEN"
```

Point                   | Detail
------------------------|----------------------------------------------------------------------------------------------
Token in **both** steps | `begin` authenticates the upload, `end` the quality gate check
Same working directory  | `begin` writes `.sonarqube/`; `build` and `end` must run beside it and must not delete it
Coverage glob           | `**/coverage.opencover.xml` matches across multiple test projects
`begin` before `build`  | the scanner injects Roslyn analysers into the build; analysing a pre-built tree finds nothing

If `end` reports "No analyses found", the three steps did not share a directory.

## Why this sample raises the most issues

The MSBuild scanner analyses **compiled** code, so Roslyn's own analysers are imported alongside Sonar's own rules.
They appear as `external_roslyn:*` on the dashboard.
That is the concrete advantage of a language-specific scanner over the generic CLI, and it is visible here as a higher issue count on comparable code.

## Adapting to another project

Add the collector to the test project if it is missing:

```bash
dotnet add tests/MyTests/MyTests.csproj package coverlet.collector
```

Then use the same three steps.
For a repo with several solutions, run `begin` once at the root and build them all between `begin` and `end`.
