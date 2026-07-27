# SonarQube tips

Common issues and configuration notes when running these samples locally.

## SonarQube does not start

Check that `vm.max_map_count` is high enough (required by Elasticsearch, which Sonar embeds):

```bash
# Check current value
sysctl vm.max_map_count

# Set temporarily (Linux)
sudo sysctl -w vm.max_map_count=524288

# Set permanently (Linux)
echo "vm.max_map_count=524288" | sudo tee -a /etc/sysctl.conf

# Docker Desktop on macOS / Windows: set in the Docker Desktop VM settings,
# or add to ~/.wslconfig (WSL2):
# [wsl2]
# kernelCommandLine = sysctl.vm.max_map_count=524288
```

## Quality Gate fails immediately

The default Quality Gate ("Sonar way") applies to **new code** only. On a first analysis there is no baseline, so all code is considered new. If you want to see results without a gate failure blocking the dashboard:

- Navigate to **Quality Gates** → **Sonar way** → duplicate it
- Set the duplicate as default and remove the coverage condition temporarily
- Or set the project to use **no quality gate** under **Project Settings → Quality Gate**

## Scanner exits with "Unable to parse coverage report"

Check that the coverage file path in `sonar-project.properties` matches the actual output path. Common mismatches:

Language                | Expected property                      | Typical file location
------------------------|----------------------------------------|-----------------------------------
JavaScript / TypeScript | `sonar.javascript.lcov.reportPaths`    | `coverage/lcov.info`
Python                  | `sonar.python.coverage.reportPaths`    | `coverage.xml`
Go                      | `sonar.go.coverage.reportPaths`        | `coverage.out`
C#                      | `sonar.cs.opencover.reportsPaths`      | `**/coverage.opencover.xml` (glob)
Java                    | `sonar.coverage.jacoco.xmlReportPaths` | `target/site/jacoco/jacoco.xml`

## .NET: `dotnet sonarscanner end` fails with "No analyses found"

The `begin` step writes a `.sonarqube/` directory in the current folder. Both `begin`, `dotnet build`, and `end` must run from the same working directory, and the `.sonarqube/` directory must not be deleted between steps.

## .NET: coverage report not imported

Ensure you pass the `Format=opencover` data collector setting:

```bash
dotnet test --collect:"XPlat Code Coverage" \
  -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=opencover
```

The glob `**/coverage.opencover.xml` in `sonar.cs.opencover.reportsPaths` matches across multiple test projects automatically.

## Java: JaCoCo report not found

Run `mvn verify` (not just `mvn test`) — the `report` goal is bound to the `verify` phase. The XML report at `target/site/jacoco/jacoco.xml` is only generated after `verify` completes.

## Resetting SonarQube to a clean state

```bash
# Remove all data (volumes) and start fresh
docker compose down -v
docker compose up -d
```

## Changing the admin password non-interactively

On first start, SonarQube forces a password change via the UI. To script it:

```bash
curl -s -u admin:admin -X POST \
  "http://localhost:9000/api/users/change_password" \
  -d "login=admin&previousPassword=admin&password=admin1"
```

Then use `admin1` (or whatever you set) in subsequent scanner commands.

## Running the scanner via Docker (any language)

If you prefer not to install the SonarScanner CLI locally:

```bash
docker run --rm \
  --network host \
  -e SONAR_TOKEN=<your-token> \
  -v "$(pwd)":/usr/src \
  sonarsource/sonar-scanner-cli:latest
```

`--network host` is required to reach `localhost:9000` from inside the container. On macOS/Windows with Docker Desktop, use `host.docker.internal` instead:

```bash
docker run --rm \
  -e SONAR_TOKEN=<your-token> \
  -e SONAR_HOST_URL=http://host.docker.internal:9000 \
  -v "$(pwd)":/usr/src \
  sonarsource/sonar-scanner-cli:latest
```
