# Pointing at a remote SonarQube

Every `sonar-project.properties` in this repo targets `http://localhost:9000`.
To analyse against a real instance instead, change the host and supply a token.

## SonarQube Server

```ini
sonar.host.url=https://sonarqube.example.com
```

## SonarCloud

```ini
sonar.host.url=https://sonarcloud.io
sonar.organization=<organization>
```

## The token

> [!IMPORTANT]
> Never commit a token
> Keep `sonar.token` out of every file and pass it at run time

```bash
export SONAR_TOKEN=<token>
```

or per invocation:

```bash
sonar-scanner -Dsonar.token=<token>
mvn sonar:sonar -Dsonar.token=<token>            # java
dotnet sonarscanner begin /d:sonar.token=<token> # dotnet, also needed on `end`
```

In CI, store it as a secret and expose it as `SONAR_TOKEN`.
That is what [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) does, except that it mints a throwaway token against a SonarQube it boots itself, so the repo needs no secrets at all.

## Overriding the host without editing files

Any property can be passed on the command line, which is usually cleaner than editing the checked-in file:

```bash
sonar-scanner \
  -Dsonar.host.url=https://sonarqube.example.com \
  -Dsonar.token="${SONAR_TOKEN}"
```
