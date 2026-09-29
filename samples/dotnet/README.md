# .NET sample

Scan an ASP.NET Core 10 sample with xUnit with the SonarScanner for .NET.

## How to run

The scanner is installed once, as a global tool, and `~/.dotnet/tools` must be on the `PATH`:

```bash
dotnet tool install --global dotnet-sonarscanner
```

Then:

```bash
task build:dotnet   # restore, build and test
task scan:dotnet    # run scan.sh
```

Without Task, from this directory:

```bash
bash scan.sh "$SONAR_TOKEN"
```

## Settings

There is no `sonar-project.properties` file.
The scanner wraps the build and receives its settings on the `begin` step, as done in `scan.sh`:

```bash
dotnet sonarscanner begin \
  /k:"sonar-samples-dotnet" \
  /n:"sonar-samples / dotnet" \
  /d:sonar.host.url="http://localhost:9000" \
  /d:sonar.token="$SONAR_TOKEN" \
  /d:sonar.cs.opencover.reportsPaths="**/coverage.opencover.xml" \
  /d:sonar.cs.vstest.reportsPaths="**/*.trx"

dotnet build --no-restore
dotnet test --no-build --logger trx --collect:"XPlat Code Coverage" \
  -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=opencover

dotnet sonarscanner end /d:sonar.token="$SONAR_TOKEN"
```

## Gotchas

- Coverlet writes Cobertura by default, which SonarQube does not read for C#, so `Format=opencover` is required to get any coverage.
- The `begin` step runs before the build, because it injects the Roslyn analysers into it.
- The `begin` step, the build and the `end` step must run from the same directory, otherwise `end` reports "No analyses found".
- The token is needed on both the `begin` and the `end` steps.
- The issues found by the Roslyn analysers show up as `external_roslyn:*`, which is why this sample raises the most issues.

## Other projects

Coverage is added to a test project with `dotnet add <test project> package coverlet.collector`.
Several solutions can be analysed together by building them all between a single `begin` and `end` run at the root.
