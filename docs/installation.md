# Installation

## Requirements

The repository runs on Linux or WSL2 with `bash`.
It needs Docker with Compose v2 and [Task](https://taskfile.dev/installation/).
Each sample also needs its own runtime:

Sample  | Runtime                 | Scanner
--------|-------------------------|---------------------------------------------------
nodejs  | Node.js 22              | CLI
python  | Python 3.12 with `venv` | CLI
go      | Go 1.23                 | CLI
java    | JDK 21, Maven 3.9       | Maven plugin
dotnet  | .NET 10 SDK             | `dotnet tool install --global dotnet-sonarscanner`
angular | Node.js 22, Angular CLI | CLI

## Kernel setting

SonarQube does not start unless `vm.max_map_count` is at least `524288`:

```bash
sudo sysctl -w vm.max_map_count=524288
```

The setting is lost on reboot, and [troubleshooting](troubleshooting.md) explains how to make it permanent.

## SonarScanner CLI

The generic SonarScanner CLI analyses every sample except .NET and Java, which have their own scanners.
It does not need to be installed, since `task scan:<sample>` runs it in Docker.
The same command can be run by hand from a sample directory:

```bash
docker run --rm --network host --user "$(id -u):$(id -g)" \
  -e SONAR_TOKEN="$SONAR_TOKEN" -v "$(pwd)":/usr/src sonarsource/sonar-scanner-cli:latest
```

`--network host` lets the container reach SonarQube on `localhost:9000`.
`--user` makes the files written by the scanner belong to the current user instead of root.

To run it outside Docker, it can be installed with `npm install -g sonar-scanner`, run with `npx sonar-scanner@latest`, or downloaded from the [SonarSource documentation](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner).

## Another server

Every sample sends its analysis to `http://localhost:9000`.
To use another server, the host is overridden on the command line:

```bash
sonar-scanner -Dsonar.host.url=https://sonarqube.example.com -Dsonar.token="$SONAR_TOKEN"
```

SonarCloud also needs `-Dsonar.organization=<organization>`.
Maven takes the same `-D` arguments, and the .NET scanner takes `/d:sonar.host.url=` on its `begin` step.
