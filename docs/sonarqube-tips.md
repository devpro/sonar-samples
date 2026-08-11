# Troubleshooting

Setup instructions live in [installation.md](installation.md), tokens in [tokens.md](tokens.md).
This page is failures and their causes.

## SonarQube does not start

Almost always `vm.max_map_count`, required by the Elasticsearch that SonarQube embeds:

```bash
sysctl vm.max_map_count                    # check
sudo sysctl -w vm.max_map_count=524288     # fix until reboot
```

Permanently:

```bash
echo "vm.max_map_count=524288" | sudo tee /etc/sysctl.d/99-sonarqube.conf
sudo sysctl --system
```

On WSL2 this resets whenever the VM restarts.
To make it stick, add to `%UserProfile%\.wslconfig` on the Windows side and run `wsl --shutdown`:

```ini
[wsl2]
kernelCommandLine = sysctl.vm.max_map_count=524288
```

Otherwise check the logs: `task logs`.

## Coverage shows 0%

The most common failure in this repo, and the reason `task assert` exists: **the scanner exits `0` even when it cannot resolve the coverage report**.
It logs a warning and uploads an analysis with no coverage.

First check the property matches where the tool actually wrote the file:

Language                | Property                               | Typical path
------------------------|----------------------------------------|--------------------------------
JavaScript / TypeScript | `sonar.javascript.lcov.reportPaths`    | `coverage/lcov.info`
Python                  | `sonar.python.coverage.reportPaths`    | `coverage.xml`
Go                      | `sonar.go.coverage.reportPaths`        | `coverage.out`
C#                      | `sonar.cs.opencover.reportsPaths`      | `**/coverage.opencover.xml`
Java                    | `sonar.coverage.jacoco.xmlReportPaths` | `target/site/jacoco/jacoco.xml`

Then check these language-specific traps:

- **TypeScript**: `sonar.typescript.lcov.reportPaths` is deprecated and ignored.
  Use the `javascript.` prefix.
- **Python**: without `relative_files = True` under `[coverage:run]`, `coverage.py` writes absolute paths that SonarQube cannot match, and every measure is dropped.
- **Java**: run `mvn verify`, not `mvn test`.
  The JaCoCo `report` goal is bound to `verify`, so `jacoco.xml` does not exist yet after `test`.
- **.NET**: pass `Format=opencover` to the collector, since Coverlet defaults to Cobertura.
- **Angular 20+**: coverage goes to `coverage/<project-name>/lcov.info`, so a fixed `coverage/lcov.info` path misses it.

Search the scanner output for `Coverage report` to see which files it resolved.

## .NET: `end` fails with "No analyses found"

`begin` writes a `.sonarqube/` directory in the working directory.
`begin`, `dotnet build`, and `end` must all run from that same directory, and nothing may delete `.sonarqube/` in between.

Also make sure `begin` runs *before* the build: it injects Roslyn analysers into it.
Running it against an already-built tree analyses nothing.

## Permission denied on a build after scanning

The `sonarsource/sonar-scanner-cli` image runs as root by default and leaves a root-owned `.scannerwork/` in the mounted directory, which breaks the next build.
`task scan:*` passes `--user "$(id -u):$(id -g)"` to prevent this.
After running the container by hand, the fix is:

```bash
sudo rm -rf .scannerwork
```

## Quality Gate fails on the first analysis

The default "Sonar way" gate applies to **new code**, and on a first analysis all code is new.
This is expected, not a misconfiguration.
To look at the dashboard without a failing gate, set the project to **no quality gate** under **Project Settings > Quality Gate**.

## Starting over

```bash
task reset     # down -v: removes every volume, including all analyses and tokens
task up
```
