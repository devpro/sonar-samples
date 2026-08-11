# Installation

Everything the samples need.
Only what the chosen sample requires has to be installed.

> [!NOTE]
> These samples target **Linux with Docker** (including WSL2) and are written and tested for `bash`
> Other platforms and container runtimes are not supported: with Podman or Docker Desktop on macOS/Windows, the `docker` command lines need adapting

## Required for every sample

Tool                                                           | Check
---------------------------------------------------------------|-------------------------
[Docker](https://docs.docker.com/engine/install/) + Compose v2 | `docker compose version`
[Task](https://taskfile.dev/installation/)                     | `task --version`

Task is optional but every documented shortcut uses it.
Without Task, read `Taskfile.yml` and run the underlying commands directly.

### Kernel setting for the embedded Elasticsearch

SonarQube will not start unless `vm.max_map_count` is at least `524288`:

```bash
sudo sysctl -w vm.max_map_count=524288
```

That resets on reboot. See [sonarqube-tips.md](sonarqube-tips.md) for a permanent fix.

## Language runtimes

Sample  | Needs
--------|-------------------------------------------------------------------------------------------------
nodejs  | [Node.js 22+](https://nodejs.org/)
angular | Node.js 22+ and the [Angular CLI](https://angular.dev/tools/cli) (`npm install -g @angular/cli`)
python  | [Python 3.12+](https://www.python.org/) with `venv`
go      | [Go 1.23+](https://go.dev/dl/)
java    | [JDK 21+](https://adoptium.net/) and [Maven 3.9+](https://maven.apache.org/download.cgi)
dotnet  | [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0)

## Scanners

Each language family uses a different scanner.
This is the single most common source of confusion, so it is worth being explicit:

Sample                      | Scanner                | Install
----------------------------|------------------------|---------------------------------------------------
nodejs, angular, python, go | SonarScanner CLI       | See below, or run it via Docker with no install
java                        | SonarScanner for Maven | Nothing to install; declared in `pom.xml`
dotnet                      | SonarScanner for .NET  | `dotnet tool install --global dotnet-sonarscanner`

The generic CLI **cannot** analyse C# or compiled Java properly.
Use the language-specific scanner where one exists.

### SonarScanner CLI

Install it from a package manager, or [download the archive](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/scanners/sonarscanner) and put `bin/sonar-scanner` on `PATH`.
For the Node.js and Angular samples npm works too:

```bash
npm install -g sonar-scanner
# or, with no install at all:
npx sonar-scanner@latest
```

### SonarScanner CLI via Docker (no install)

Run this from the sample directory to analyse:

```bash
docker run --rm --network host \
  --user "$(id -u):$(id -g)" \
  -e SONAR_TOKEN="${SONAR_TOKEN}" \
  -v "$(pwd)":/usr/src \
  sonarsource/sonar-scanner-cli:latest
```

Two flags matter:

- `--network host` lets the container reach SonarQube on `localhost:9000`.
- `--user` stops the container writing a **root-owned `.scannerwork/`** into the working tree, which would break the next build with `permission denied`.

This is exactly what `task scan:<sample>` runs.
