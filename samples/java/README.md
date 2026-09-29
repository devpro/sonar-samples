# Java sample

Scan a Java 21 sample with Maven and JUnit 5 with the SonarScanner for Maven.
The scanner is a Maven plugin, so there is nothing else to install.

## How to run

```bash
task build:java   # build and test with coverage
task scan:java    # build again and run the analysis
```

Without Task, from this directory:

```bash
mvn -B verify sonar:sonar -Dsonar.token="$SONAR_TOKEN"
```

Without Maven installed, the same command runs in a container:

```bash
docker run --rm --network host --user "$(id -u):$(id -g)" \
  -v "$(pwd)":/app -w /app \
  -v "$HOME/.m2":/var/maven/.m2 -e MAVEN_CONFIG=/var/maven/.m2 \
  -v /tmp/sonarhome:/sonarhome \
  maven:3.9-eclipse-temurin-21 \
  mvn -B -Duser.home=/var/maven verify sonar:sonar \
    -Dsonar.token="$SONAR_TOKEN" -Dsonar.userHome=/sonarhome
```

## Settings

The settings are Maven properties in `pom.xml`:

```xml
<properties>
  <sonar.projectKey>sonar-samples-java</sonar.projectKey>
  <sonar.projectName>sonar-samples / java</sonar.projectName>
  <sonar.host.url>http://localhost:9000</sonar.host.url>
  <sonar.coverage.jacoco.xmlReportPaths>
    ${project.reporting.outputDirectory}/jacoco/jacoco.xml
  </sonar.coverage.jacoco.xmlReportPaths>
</properties>
```

The JaCoCo plugin needs two executions: `prepare-agent` before the tests, and `report` after them.
The test reports written by Surefire are found by the scanner without any setting.

## Gotchas

- `mvn test` produces no coverage report, because the JaCoCo `report` goal is bound to the `verify` phase.
- Many Java rules need the compiled bytecode, which the Maven plugin provides, so it is preferred over the generic scanner CLI.
