# Sonar Samples

Small code samples in six languages, analysed by a local SonarQube running in Docker.

## Getting started

```bash
sudo sysctl -w vm.max_map_count=524288   # once per boot
export SONAR_TOKEN=$(task bootstrap)     # starts SonarQube, prints a token
task build:nodejs && task scan:nodejs
```

Results are on [http://localhost:9000](http://localhost:9000) (log in as `admin` / `SonarSamples2026!`).

## Samples

- [angular](samples/angular/)
- [dotnet](samples/dotnet/)
- [go](samples/go/)
- [java](samples/java/)
- [nodejs](samples/nodejs/)
- [python](samples/python/)

## Going further

- [Quickstart](docs/quickstart.md)
- [Installation](docs/installation.md)
- [Troubleshooting](docs/sonarqube-tips.md)
- [Tokens](docs/tokens.md)
- [Rules raised](docs/rules.md)
- [Remote server](docs/remote-sonarqube.md).
