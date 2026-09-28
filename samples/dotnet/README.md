# .NET sample

ASP.NET Core 10 with xUnit, scanned by the SonarScanner for .NET.

- Project key: `sonar-samples-dotnet`
- Coverage: Coverlet OpenCover XML, `**/coverage.opencover.xml`
- Tests: TRX, `**/*.trx`
- Rules raised: [docs/rules.md](../../docs/rules.md)

```bash
dotnet tool install --global dotnet-sonarscanner   # once, needs ~/.dotnet/tools on the PATH
task build:dotnet
task scan:dotnet   # runs scan.sh
```

## scan.sh

There is no `sonar-project.properties`: the scanner wraps the build and takes its settings on `begin`.

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

- `Format=opencover` is required, Coverlet defaults to Cobertura and coverage is then 0%.
- `begin` runs before the build, since it injects the Roslyn analysers into it.
- `begin`, build and `end` share a directory, otherwise `end` reports "No analyses found".
- The token is needed on both `begin` and `end`.
- Roslyn issues show up as `external_roslyn:*`, which is why this sample raises the most.

## Other projects

`dotnet add <test project> package coverlet.collector` adds coverage.
Several solutions are built between a single `begin` and `end` at the root.
