# Sonar Samples

Experiment [SonarQube](https://www.sonarsource.com/products/sonarqube/) on actual code, in six different languages, with a self-contained environment: a local SonarQube in Docker, no external services, no secrets.

**Each sample is independent**: pick the matching stack, follow its README, get a populated dashboard in minutes.

## Quick start

1. Ensure [Docker](https://docs.docker.com/engine/install/) with Compose v2, [Task](https://taskfile.dev/installation/), and for this example Node.js.
Full list: [docs/installation.md](docs/installation.md).

2. *Once per boot:* Update the Linux kernel parameter that controls the maximum number of Virtual Memory Areas (VMAs) a single process can allocate (SonarQube needs it)

   ```bash
   sudo sysctl -w vm.max_map_count=524288
   ```

3. Start SonarQube in a container and get a fresh token (used in next step)

   ```bash
   export SONAR_TOKEN=$(task bootstrap)
   ```

4. Build, test and analyze the Node.js sample

   ```bash
   task build:nodejs
   task scan:nodejs
   ```

5. Open [localhost:9000](http://localhost:9000/dashboard?id=sonar-samples-nodejs) with the credentials: `admin`/`SonarSamples2026!`

6. Show every target

   ```bash
   task --list-all
   ```

7. Pick a new sample and run it

8. *Optional:* Run every sample, scanned and verified

   ```bash
   task ci
   ```

9. Clean the system from this run

   ```bash
   task reset
   ```

> [!TIP]
> Other tasks are available to manage containers: `task stop`, `task logs`, `task wait`

## Samples

Sample                      | Stack                  | Scanner
----------------------------|------------------------|-----------------------
[angular](samples/angular/) | Angular (latest)       | SonarScanner CLI
[dotnet](samples/dotnet/)   | .NET 10 / ASP.NET Core | SonarScanner for .NET
[go](samples/go/)           | Go 1.23                | SonarScanner CLI
[java](samples/java/)       | Java 21 / Maven        | SonarScanner for Maven
[nodejs](samples/nodejs/)   | Node.js 22             | SonarScanner CLI
[python](samples/python/)   | Python 3.12 / Flask    | SonarScanner CLI

> [!NOTE]
> The `angular` sample scaffolds a fresh app with the current Angular CLI rather than committing sources, so it is excluded from `task build`, `task scan` and `task assert`.
> Run it explicitly with `task build:angular`.

## Docs

- [backlog.md](docs/backlog.md) for known gaps and planned work
- [installation.md](docs/installation.md) to install prerequisites, runtimes, scanners
- [remote-sonarqube.md](docs/remote-sonarqube.md) for pointing at a real server or SonarCloud
- [rules.md](docs/rules.md) to know which rules each sample raises, and why Go raises fewer
- [sonarqube-tips.md](docs/sonarqube-tips.md) for troubleshooting
- [tokens.md](docs/tokens.md) for getting a token, scripted or through the UI

## Scope

Targets **Linux with Docker** (including WSL2), written for `bash`.

Other platforms and container runtimes are not supported but can be adapted (for example `docker` to `podman`).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md), with [MIT](LICENSE).
