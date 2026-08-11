# Java sample

A minimal Java 21 Maven project with JUnit 5 tests, analysed with the **SonarScanner for Maven**, the idiomatic choice for Maven builds.

- Project key: `sonar-samples-java`
- Coverage: JaCoCo XML, written to `target/site/jacoco/jacoco.xml`
- Issues raised: [docs/rules.md#java](../../docs/rules.md#java)

## Prerequisites

JDK 21+ and Maven 3.9+, and a running SonarQube.
See [docs/installation.md](../../docs/installation.md).

No scanner to install, it is declared as a plugin in `pom.xml`.

## Run it

```bash
mvn -B verify
```

Use `verify`, not `test`.
The JaCoCo `report` goal is bound to the `verify` phase, so `mvn test` runs the tests but never writes `jacoco.xml`, and the scan then reports no coverage.

## Scan it

```bash
export SONAR_TOKEN=$(task bootstrap)   # see docs/tokens.md
task scan:java
```

which is exactly:

```bash
mvn -B verify sonar:sonar -Dsonar.token="$SONAR_TOKEN"
```

Results: <http://localhost:9000/dashboard?id=sonar-samples-java>

## Key configuration in pom.xml

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

The JaCoCo plugin needs two executions: `prepare-agent` before the tests to instrument them, and `report` after them to write the XML.
Both are in `pom.xml`.

`sonar.token` is never stored here, pass it via `-Dsonar.token=` or `SONAR_TOKEN`.

## Maven plugin vs the generic CLI

For Maven projects, always prefer the plugin:

&nbsp;                | Maven plugin                    | CLI scanner
----------------------|---------------------------------|-----------------------------
Install               | none, declared in `pom.xml`     | separate download
What it analyses      | compiled bytecode **and** source | source only
Accuracy              | higher                          | lower
Coverage              | reads JaCoCo automatically      | manual path configuration
Dependencies          | resolved from the reactor       | invisible

Analysing bytecode is what lets the Java analyser resolve types across dependencies, which many rules need to fire at all.

## A note on the empty catch block

`Showcase.java` swallows a `NoSuchAlgorithmException`.
That is a genuine smell, but it raises **neither** `S2486` nor `S108`: both rules suppress when the block contains a comment.
It is left that way deliberately, see [docs/rules.md#java](../../docs/rules.md#java).
