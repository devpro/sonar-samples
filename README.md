# Sonar Samples

Working [SonarQube](https://www.sonarsource.com/products/sonarqube/) analysis on real code, in six languages.
Self-contained: a local SonarQube in Docker, no external services, no secrets.

Each sample is independent.
Pick the matching stack, follow its README, get a populated dashboard in minutes.

## Quick start

Needs [Docker](https://docs.docker.com/engine/install/) with Compose v2, [Task](https://taskfile.dev/installation/), and Node.js for the sample below.
Full list: [docs/installation.md](docs/installation.md).

```bash
sudo sysctl -w vm.max_map_count=524288   # once per boot, SonarQube needs it

export SONAR_TOKEN=$(task bootstrap)     # starts SonarQube, prints a fresh token
task build:nodejs && task scan:nodejs    # build, test, analyse
```

Then open <http://localhost:9000/dashboard?id=sonar-samples-nodejs> (`admin` / `SonarSamples2026!`).

Swap `nodejs` for any sample below.
`task ci` runs the whole thing (every sample, scanned and verified) and `task --list-all` shows every target.

Stop with `task down` (data kept) or `task reset` (clean slate).

## Samples

Sample                      | Stack                  | Scanner
----------------------------|------------------------|-----------------------
[nodejs](samples/nodejs/)   | Node.js 22             | SonarScanner CLI
[angular](samples/angular/) | Angular (latest)       | SonarScanner CLI
[python](samples/python/)   | Python 3.12 / Flask    | SonarScanner CLI
[go](samples/go/)           | Go 1.23                | SonarScanner CLI
[java](samples/java/)       | Java 21 / Maven        | SonarScanner for Maven
[dotnet](samples/dotnet/)   | .NET 10 / ASP.NET Core | SonarScanner for .NET

The angular sample scaffolds a fresh app with the current Angular CLI rather than committing sources, so it is excluded from `task build`, `task scan` and `task assert`.
Run it explicitly with `task build:angular`.

## Docs

- [installation.md](docs/installation.md) to install prerequisites, runtimes, scanners
- [tokens.md](docs/tokens.md) for getting a token, scripted or through the UI
- [rules.md](docs/rules.md) to know which rules each sample raises, and why Go raises fewer
- [remote-sonarqube.md](docs/remote-sonarqube.md) for pointing at a real server or SonarCloud
- [sonarqube-tips.md](docs/sonarqube-tips.md) for troubleshooting
- [backlog.md](docs/backlog.md) for known gaps and planned work

## Scope

Targets **Linux with Docker** (including WSL2), written for `bash`.
Other platforms and container runtimes are not supported but can be easily adapted (`docker` to `podman` for instance).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

[MIT](LICENSE) licensed.
