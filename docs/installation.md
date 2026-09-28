# Installation

Linux or WSL2 with `bash`, Docker with Compose v2, and [Task](https://taskfile.dev/installation/).

Sample  | Runtime                 | Scanner
--------|-------------------------|---------------------------------------------------------------
nodejs  | Node.js 22              | CLI, run in Docker by `task scan:nodejs`
python  | Python 3.12 with `venv` | CLI, run in Docker by `task scan:python`
go      | Go 1.23                 | CLI, run in Docker by `task scan:go`
java    | JDK 21, Maven 3.9       | Maven plugin, declared in `pom.xml`
dotnet  | .NET 10 SDK             | `dotnet tool install --global dotnet-sonarscanner`
angular | Node.js 22, Angular CLI | CLI, run in Docker by `task scan:angular`

SonarQube does not start unless `vm.max_map_count` is at least `524288`:

```bash
sudo sysctl -w vm.max_map_count=524288
```

The setting resets on reboot, see [troubleshooting](sonarqube-tips.md) to make it permanent.

The generic SonarScanner CLI cannot analyse C# or compiled Java.
Outside Docker it installs with `npm install -g sonar-scanner`, runs with `npx sonar-scanner@latest`, or comes from the [archive](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner).
In Docker, as `task scan:<sample>` does, from the sample directory:

```bash
docker run --rm --network host --user "$(id -u):$(id -g)" \
  -e SONAR_TOKEN="$SONAR_TOKEN" -v "$(pwd)":/usr/src sonarsource/sonar-scanner-cli:latest
```

`--network host` reaches `localhost:9000`, `--user` avoids a root-owned `.scannerwork/`.
