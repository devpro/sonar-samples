# Sonar Samples

Sample projects demonstrating how to analyse code with [SonarQube](https://www.sonarsource.com/products/sonarqube/).
All fully self-contained using containers, no external services, no CI pipeline, no secrets required.

Each sample is independent.
Pick the one that matches your stack, follow its README, and you will have a working SonarQube analysis running locally in minutes.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) v2
- The language runtime for the sample you want to run (see each sample's README)
- [Task](https://taskfile.dev/) (optional, for convenience targets)

> [!TIP]
> **Linux only:** SonarQube requires `vm.max_map_count ≥ 524288`.
> If it fails to start, run:
>
> ```bash
> sudo sysctl -w vm.max_map_count=524288
> ```
>
> See [docs/sonarqube-tips.md](docs/sonarqube-tips.md) for a permanent fix.

## Quick start

Start SonarQube (with a readiness wait):

```bash
task up
```

Open [http://localhost:9000](http://localhost:9000>).

Login with default credentials: `admin` / `admin` (you will be prompted to change the password on first login).

Stop (data is preserved in a Docker volume):

```bash
task down
```

Reset (wipe all data and start fresh):

```bash
task reset
```

## Samples

Sample                      | Language / Platform   | Scanner
----------------------------|-----------------------|--------------------------------
[nodejs](samples/nodejs/)   | Node.js 22            | SonarScanner CLI
[angular](samples/angular/) | Angular (latest)      | SonarScanner CLI
[dotnet](samples/dotnet/)   | .NET 9 / ASP.NET Core | SonarScanner for .NET (MSBuild)
[python](samples/python/)   | Python 3.12           | SonarScanner CLI
[go](samples/go/)           | Go 1.23               | SonarScanner CLI
[java](samples/java/)       | Java 21 / Maven       | SonarScanner for Maven

## How it works

```txt
┌─────────────────────────────────────────────────────────┐
│  Your machine                                           │
│                                                         │
│  ┌─────────────┐   scan results   ┌──────────────────┐  │
│  │  Sample app │ ───────────────► │  SonarQube       │  │
│  │  + scanner  │                  │  (Docker)        │  │
│  └─────────────┘                  │  localhost:9000  │  │
│                                   └──────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

The scanner runs on the host (or optionally in a container) and pushes results to the local SonarQube instance.

## Scanner reference

Language          | Scanner                | Install
------------------|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------
JS / TS / Angular | SonarScanner CLI       | `npm install -g sonar-scanner` or `npx sonar-scanner@latest`
C# / .NET         | SonarScanner for .NET  | `dotnet tool install --global dotnet-sonarscanner`
Python / Go       | SonarScanner CLI       | Homebrew, package manager, or [download](https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/scanners/sonarscanner/)
Java / Maven      | SonarScanner for Maven | No install — declared as a Maven plugin in `pom.xml`

### Scanner via Docker (no install)

For CLI-based samples (Node.js, Angular, Python, Go):

```bash
# Linux — use --network host to reach localhost:9000
docker run --rm \
  --network host \
  -e SONAR_TOKEN=<your-token> \
  -v "$(pwd)":/usr/src \
  sonarsource/sonar-scanner-cli:latest

# Windows (Docker Desktop) — use host.docker.internal
docker run --rm \
  -e SONAR_TOKEN=<your-token> \
  -e SONAR_HOST_URL=http://host.docker.internal:9000 \
  -v "$(pwd)":/usr/src \
  sonarsource/sonar-scanner-cli:latest
```

## Adapting to SonarQube Server or SonarCloud

The `sonar-project.properties` in each sample targets `http://localhost:9000`.

To point at a remote instance:

- SonarQube Server

```ini
sonar.host.url=https://sonarqube.example.com
sonar.token=<your-token>
```

- SonarCloud

```ini
sonar.host.url=https://sonarcloud.io
sonar.organization=<your-org>
sonar.token=<your-token>
```

> [!IMPORTANT]
> Never commit tokens.
> Use `-Dsonar.token=` on the command line or the `SONAR_TOKEN` environment variable.

## Repository structure

```txt
sonar-samples/
├── Taskfile.yml                  # up / down / reset / logs
├── compose.yaml              # SonarQube 25 Community + PostgreSQL 16
├── samples/
│   ├── nodejs/               # Node.js 22 + Jest + lcov
│   ├── angular/              # Angular setup script + sonar-project.properties
│   ├── dotnet/               # .NET 9 minimal API + xUnit + Coverlet + scan.sh / scan.ps1
│   ├── python/               # Python 3.12 + Flask + pytest + coverage.xml
│   ├── go/                   # Go 1.23 + standard library + coverage.out
│   └── java/                 # Java 21 + Maven + JUnit 5 + JaCoCo
└── docs/
    └── sonarqube-tips.md     # Troubleshooting and tuning
```

## Troubleshooting

See [docs/sonarqube-tips.md](docs/sonarqube-tips.md) for common issues:

- SonarQube fails to start (Linux `vm.max_map_count`)
- Coverage report not imported
- .NET scanner `begin`/`end` directory issues
- Resetting to a clean state

## Contributing

See [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md).

## License

[MIT](LICENSE)
