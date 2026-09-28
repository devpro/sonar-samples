# Tokens

`task bootstrap` starts SonarQube, sets the admin password and prints a new token on stdout:

```bash
export SONAR_TOKEN=$(task bootstrap)
```

The password defaults to `SonarSamples2026!` and is overridden with `SONAR_ADMIN_PASSWORD`, at least 12 characters.
A volume created with another password makes token generation fail, `task reset` starts over.

Each run revokes the previous `sonar-samples` token, so only the latest one works.
No token is ever written to a file: scanners read `SONAR_TOKEN` or `-Dsonar.token=`.

## By hand

Through the UI on a fresh instance: log in as `admin` / `admin`, change the password, then **My Account > Security** generates a token.
A project does not need to exist first, the first scan creates it from `sonar.projectKey`.

Through the API:

```bash
curl -s -u admin:admin -X POST "http://localhost:9000/api/users/change_password" \
  --data-urlencode "login=admin" --data-urlencode "previousPassword=admin" --data-urlencode "password=SonarSamples2026!"
curl -s -u admin:'SonarSamples2026!' -X POST "http://localhost:9000/api/user_tokens/generate" --data-urlencode "name=local"
```
