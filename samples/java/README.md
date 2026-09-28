# Java sample

Java 21 with Maven and JUnit 5, scanned by the SonarScanner for Maven, nothing to install.

- Project key: `sonar-samples-java`
- Coverage: JaCoCo XML, `target/site/jacoco/jacoco.xml`
- Tests: Surefire reports, read by the Maven plugin with no setting
- Rules raised: [docs/rules.md](../../docs/rules.md)

```bash
task build:java   # mvn -B verify
task scan:java    # mvn -B verify sonar:sonar -Dsonar.token="$SONAR_TOKEN"
```

## pom.xml

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

The JaCoCo plugin needs both executions: `prepare-agent` before the tests, `report` after them.

## Gotchas

- `mvn test` is not enough: the JaCoCo `report` goal is bound to `verify`.
- The Maven plugin analyses bytecode, which many Java rules need, so it is preferred over the generic CLI.
- Without Maven on the `PATH`, the build and scan run in a container:

  ```bash
  docker run --rm --network host --user "$(id -u):$(id -g)" \
    -v "$(pwd)":/app -w /app \
    -v "$HOME/.m2":/var/maven/.m2 -e MAVEN_CONFIG=/var/maven/.m2 \
    -v /tmp/sonarhome:/sonarhome \
    maven:3.9-eclipse-temurin-21 \
    mvn -B -Duser.home=/var/maven verify sonar:sonar \
      -Dsonar.token="$SONAR_TOKEN" -Dsonar.userHome=/sonarhome
  ```
