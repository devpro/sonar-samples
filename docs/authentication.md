# Tokens

## With Task

`task bootstrap` starts SonarQube, sets the admin password and prints a new token:

```bash
export SONAR_TOKEN=$(task bootstrap)
```

The admin password is `SonarSamples2026!` by default.
Another password, of at least 12 characters, can be set with `SONAR_ADMIN_PASSWORD`.
If the SonarQube data was created with a different password, the token cannot be generated, and `task reset` starts over from scratch.

Each run revokes the previous `sonar-samples` token, so only the latest one works.
The token is never written to a file: the scanners read it from `SONAR_TOKEN` or from `-Dsonar.token=`.

## By hand

### UI

On a new instance, log in as `admin` with the password `admin`, and change the password when asked.
A token is then generated from **My Account > Security**.
The project does not need to be created beforehand, since the first scan creates it from `sonar.projectKey`.

### API

The first call changes the default password, the second one generates a token:

```bash
curl -s -u admin:admin -X POST "http://localhost:9000/api/users/change_password" \
  --data-urlencode "login=admin" --data-urlencode "previousPassword=admin" --data-urlencode "password=SonarSamples2026!"
curl -s -u admin:'SonarSamples2026!' -X POST "http://localhost:9000/api/user_tokens/generate" --data-urlencode "name=local"
```
