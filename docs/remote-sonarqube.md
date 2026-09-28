# Remote SonarQube

Every sample targets `http://localhost:9000`.
Another server is used by overriding the host at run time:

```bash
sonar-scanner -Dsonar.host.url=https://sonarqube.example.com -Dsonar.token="$SONAR_TOKEN"
```

SonarCloud also needs `-Dsonar.organization=<organization>`.
Maven takes the same `-D` arguments, .NET takes `/d:sonar.host.url=` on `begin`.

In CI the token is a secret exposed as `SONAR_TOKEN`.
This repository's CI needs none, it mints a token against the SonarQube it boots.
