# Getting a token

Every scanner authenticates with a user token.
A token is never stored in any file in this repo, pass it via `-Dsonar.token=` or the `SONAR_TOKEN` environment variable.

## Scripted (recommended)

`scripts/sonar_bootstrap.sh` starts the stack, waits for it to come up, sets the admin password, and prints a fresh token on stdout:

```bash
export SONAR_TOKEN=$(task bootstrap)
```

Progress messages go to stderr, so only the token is captured.
Every `task scan:*` target reads `SONAR_TOKEN` from the environment.

The admin password defaults to `SonarSamples2026!` and is overridable:

```bash
export SONAR_ADMIN_PASSWORD='my-longer-password'
export SONAR_TOKEN=$(task bootstrap)
```

SonarQube rejects passwords shorter than 12 characters.

> [!NOTE]
> Each run mints a new token and never revokes the old ones.
> They accumulate under **My Account > Security**.
> `task reset` wipes them along with everything else.

## Manually, through the UI

These are the steps to follow against a real SonarQube server, so they are worth seeing once:

1. Open <http://localhost:9000>
2. Log in as `admin`, with password `admin` on a fresh instance, which SonarQube then forces to be changed
3. **Create project** > **Manually**
4. Set the **project key** and **display name** to the values in the sample's README
5. **Set up** > **Locally**
6. Generate a token and copy it

The project key must match `sonar.projectKey` in the sample's `sonar-project.properties`, otherwise the scan lands on a second, unexpected project.

> [!TIP]
> The project must not be created first.
> If the key does not exist, the scanner creates it on the first analysis.
> Creating it manually is only useful when a quality gate or permissions need to be set up front.

## Manually, through the API

```bash
# sets the admin password (204 = success)
curl -s -u admin:admin -X POST \
  "http://localhost:9000/api/users/change_password" \
  --data-urlencode "login=admin" \
  --data-urlencode "previousPassword=admin" \
  --data-urlencode "password=SonarSamples2026!"

# mints a token
curl -s -u admin:'SonarSamples2026!' -X POST \
  "http://localhost:9000/api/user_tokens/generate" --data-urlencode "name=local"
```
