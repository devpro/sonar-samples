# Java sample

A minimal Java 21 Maven project with JUnit 5 tests, demonstrating Java analysis in SonarQube using the **SonarScanner for Maven** — the idiomatic approach for Maven projects.

## What this demonstrates

- Java source analysis with Sonar rules (bugs, vulnerabilities, code smells)
- Test coverage import from JaCoCo
- The SonarScanner for Maven plugin — no separate scanner install required
- Correct JaCoCo + Sonar configuration in `pom.xml`

## Prerequisites

- [Java 21+](https://adoptium.net/) (JDK, not JRE)
- [Maven 3.9+](https://maven.apache.org/download.cgi)
- SonarQube running locally (`docker compose up -d` from the repo root)

No separate SonarScanner installation — the Maven plugin handles everything.

## Run the tests

```bash
mvn verify
```

This runs the test suite and generates the JaCoCo coverage report at `target/site/jacoco/jacoco.xml`.

## Create the project in SonarQube

1. Open <http://localhost:9000>
2. Log in (`admin` / your password)
3. Click **Create project** → **Manually**
4. Set **Project key**: `sonar-samples-java`
5. Set **Display name**: `sonar-samples / java`
6. Click **Set up** → **Locally**
7. Generate a token and copy it

## Run the scanner

```bash
mvn sonar:sonar -Dsonar.token=<your-token>
```

SonarQube host and project key are configured in `pom.xml` — only the token is passed on the command line.

### Combined (test + scan in one command)

```bash
mvn verify sonar:sonar -Dsonar.token=<your-token>
```

## View results

Open <http://localhost:9000/dashboard?id=sonar-samples-java>.

## Key configuration in pom.xml

```xml
<properties>
  <!-- Tell Sonar where to find the JaCoCo report -->
  <sonar.coverage.jacoco.xmlReportPaths>
    ${project.reporting.outputDirectory}/jacoco/jacoco.xml
  </sonar.coverage.jacoco.xmlReportPaths>
  <sonar.projectKey>sonar-samples-java</sonar.projectKey>
  <sonar.host.url>http://localhost:9000</sonar.host.url>
</properties>
```

The `sonar.token` is never stored in `pom.xml` — always pass it via `-Dsonar.token=` or the `SONAR_TOKEN` environment variable.

## Note on the SonarScanner for Maven vs CLI

For Maven projects, always prefer the Maven plugin:

| | Maven plugin | CLI scanner |
|---|---|---|
| Install | None (plugin declared in pom.xml) | Separate download |
| Java compilation | Analyses compiled bytecode | Source only |
| Accuracy | Higher — uses bytecode + source | Lower |
| Coverage | Reads JaCoCo automatically | Requires manual path config |
